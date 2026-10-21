import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../data/app_localization.dart';
import '../data/dialogue_data.dart';
import '../services/tts_service.dart';

/// 상황별 대화문 보기 화면 + 실제 사람 같은 원어민 고음질 전체 오디오 플레이어
class DialogueScreen extends StatefulWidget {
  final Dialogue dialogue;
  final String langCode;

  const DialogueScreen({
    super.key,
    required this.dialogue,
    required this.langCode,
  });

  @override
  State<DialogueScreen> createState() => _DialogueScreenState();
}

class _DialogueScreenState extends State<DialogueScreen> {
  late final AudioPlayer _player;
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  StreamSubscription? _stateSub;
  StreamSubscription? _durationSub;
  StreamSubscription? _posSub;
  StreamSubscription? _completeSub;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudioPlayer();

    _stateSub = _player.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _playerState = state);
    });

    _durationSub = _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });

    _posSub = _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _completeSub = _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _playerState = PlayerState.completed;
          _position = Duration.zero;
        });
      }
    });
  }

  Future<void> _initAudioPlayer() async {
    try {
      await _player.setAudioContext(
        AudioContext(
          android: const AudioContextAndroid(
            isSpeakerphoneOn: true,
            stayAwake: true,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: const {AVAudioSessionOptions.defaultToSpeaker},
          ),
        ),
      );
      await _player.setVolume(1.0);
    } catch (e) {
      debugPrint('AudioContext init error: $e');
    }
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _durationSub?.cancel();
    _posSub?.cancel();
    _completeSub?.cancel();
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  String _cleanAssetPath(String fullPath) {
    if (fullPath.startsWith('assets/')) {
      return fullPath.substring(7);
    }
    return fullPath;
  }

  Future<void> _togglePlay() async {
    try {
      await _player.setVolume(1.0);
      if (_playerState == PlayerState.playing) {
        await _player.pause();
      } else if (_playerState == PlayerState.paused) {
        await _player.resume();
      } else {
        final asset = _cleanAssetPath(widget.dialogue.audioAsset);
        await _player.play(AssetSource(asset), volume: 1.0);
      }
    } catch (e) {
      debugPrint('Play error: $e - fallback to TTS');
      final fullText = widget.dialogue.lines.map((l) => l.text).join(' ');
      TtsService().speak(fullText);
    }
  }

  Future<void> _replay() async {
    try {
      await _player.setVolume(1.0);
      final asset = _cleanAssetPath(widget.dialogue.audioAsset);
      await _player.stop();
      await _player.seek(Duration.zero);
      await _player.play(AssetSource(asset), volume: 1.0);
    } catch (e) {
      debugPrint('Replay error: $e - fallback to TTS');
      final fullText = widget.dialogue.lines.map((l) => l.text).join(' ');
      TtsService().speak(fullText);
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: isDark ? Colors.white : const Color(0xFF0F172A)),
        title: Text(
          '${widget.dialogue.emoji}  ${widget.dialogue.title(widget.langCode)}',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            // 1. 안내 박스
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
                ),
              ),
              child: Text(
                AppStrings.tr('dialogue_sub', widget.langCode),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E40AF),
                ),
              ),
            ),

            // 2. 고품질 원어민 전체 오디오 플레이어 카드
            _buildAudioPlayerCard(isDark),
            const SizedBox(height: 18),

            // 3. 대화 말풍선 목록
            ...widget.dialogue.lines.map((line) => _buildBubble(line, isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayerCard(bool isDark) {
    final isPlaying = _playerState == PlayerState.playing;
    final isCompleted = _playerState == PlayerState.completed;

    final progress = (_duration.inMilliseconds > 0)
        ? (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPlaying
              ? const Color(0xFFDB2777).withValues(alpha: 0.6)
              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          width: isPlaying ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isPlaying
                ? const Color(0xFFDB2777).withValues(alpha: isDark ? 0.25 : 0.12)
                : Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDB2777), Color(0xFF9333EA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text('🎧', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.tr('audio_play_all', widget.langCode),
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '철수(남성) & 영희(여성) 원어민 대화',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              if (_playerState != PlayerState.stopped) ...[
                IconButton(
                  onPressed: _replay,
                  tooltip: AppStrings.tr('audio_replay', widget.langCode),
                  icon: Icon(
                    Icons.replay_rounded,
                    size: 22,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                  ),
                ),
              ],
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: isCompleted ? _replay : _togglePlay,
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDB2777),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDB2777).withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isPlaying
                          ? Icons.pause_rounded
                          : (isCompleted ? Icons.replay_rounded : Icons.play_arrow_rounded),
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFDB2777)),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_position),
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
              Text(
                _formatDuration(_duration),
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(DialogueLine line, bool isDark) {
    final isLeft = line.speaker == '철수';
    final accent = isLeft ? const Color(0xFF2563EB) : const Color(0xFFDB2777);
    final avatar = isLeft ? '👦' : '👧';

    final bubbleColor = isLeft
        ? (isDark ? const Color(0xFF1E293B) : Colors.white)
        : (isDark ? const Color(0xFF3B1530) : const Color(0xFFFDF2F8));
    final borderColor = isLeft
        ? (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))
        : (isDark ? const Color(0xFF831843) : const Color(0xFFFBCFE8));

    final avatarWidget = Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.25 : 0.12),
        shape: BoxShape.circle,
      ),
      child: Text(avatar, style: const TextStyle(fontSize: 20)),
    );

    final bubble = Flexible(
      child: Column(
        crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              line.speaker,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: isDark ? accent.withValues(alpha: 0.9) : accent,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isLeft ? 4 : 18),
                topRight: Radius.circular(isLeft ? 18 : 4),
                bottomLeft: const Radius.circular(18),
                bottomRight: const Radius.circular(18),
              ),
              onTap: () => TtsService().speak(line.text),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isLeft ? 4 : 18),
                    topRight: Radius.circular(isLeft ? 18 : 4),
                    bottomLeft: const Radius.circular(18),
                    bottomRight: const Radius.circular(18),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        line.text,
                        style: TextStyle(
                          fontSize: 16.5,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.volume_up_rounded,
                      size: 15,
                      color: accent.withValues(alpha: isDark ? 0.75 : 0.55),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isLeft
            ? [avatarWidget, const SizedBox(width: 8), bubble, const SizedBox(width: 40)]
            : [const SizedBox(width: 40), bubble, const SizedBox(width: 8), avatarWidget],
      ),
    );
  }
}
