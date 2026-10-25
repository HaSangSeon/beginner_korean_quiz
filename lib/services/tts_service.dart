import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  bool _isInitializing = false;
  String? _currentlyPlayingText;

  String? get currentlyPlayingText => _currentlyPlayingText;

  Future<void> _initTts() async {
    if (_isInitialized) return;
    if (_isInitializing) {
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      return;
    }
    _isInitializing = true;
    try {
      _flutterTts = FlutterTts();

      // Prioritize Google TTS Engine on Android for high-naturalness Korean neural voices
      if (defaultTargetPlatform == TargetPlatform.android) {
        try {
          final engines = await _flutterTts!.getEngines;
          if (engines is List && engines.contains('com.google.android.tts')) {
            await _flutterTts!.setEngine('com.google.android.tts');
          }
        } catch (_) {}
      }

      await _flutterTts!.setLanguage('ko-KR');

      // Attempt to pick the highest quality natural voice for ko-KR
      try {
        final voices = await _flutterTts!.getVoices;
        if (voices is List) {
          final koVoices = voices.where((v) {
            if (v is! Map) return false;
            final locale = v['locale']?.toString().toLowerCase() ?? '';
            return locale.contains('ko') || locale.contains('kr');
          }).toList();

          if (koVoices.isNotEmpty) {
            // Prefer network or high quality neural voice if available
            final bestVoice = koVoices.firstWhere(
              (v) => (v as Map)['name']?.toString().contains('network') ?? false,
              orElse: () => koVoices.first,
            );
            await _flutterTts!.setVoice({
              'name': (bestVoice as Map)['name'].toString(),
              'locale': (bestVoice)['locale'].toString(),
            });
          }
        }
      } catch (_) {}

      await _flutterTts!.setVolume(1.0);

      _flutterTts!.setCompletionHandler(() {
        _currentlyPlayingText = null;
      });

      _flutterTts!.setErrorHandler((msg) {
        _currentlyPlayingText = null;
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint('TtsService init error: $e');
    } finally {
      _isInitializing = false;
    }
  }

  /// Clean text for natural speech synthesis without awkward bracket sounds
  String _prepareTextForSpeech(String rawText) {
    var text = rawText;
    // Remove dialogue prefix if any (e.g. "가: ", "선생님: ")
    text = text.replaceAll(RegExp(r'^[^:\n\r]{1,10}\s*:\s*'), '');
    // Remove empty blanks or underline symbols
    text = text.replaceAll(RegExp(r'\(\s*\)'), '');
    text = text.replaceAll(RegExp(r'_{2,}'), '');
    // Remove meta characters
    text = text.replaceAll(RegExp(r'[※•*]'), '');
    return text.trim();
  }

  /// Speak Korean text with native-like intonation adaptation
  /// (Rising pitch for questions, warm pace for words, expressive accents)
  Future<void> speak(String text) async {
    final cleanText = _prepareTextForSpeech(text);
    if (cleanText.isEmpty) return;

    try {
      await _initTts();
      if (_flutterTts != null) {
        _currentlyPlayingText = cleanText;
        await _flutterTts!.stop();

        // 🎯 Native Prosody Adaptation:
        // 1. Question Sentence ('?'): Boost pitch to 1.16 for a natural rising intonation at sentence ending
        // 2. Exclamation Sentence ('!'): Warm bright pitch 1.08 with energetic rate
        // 3. Short Single Word: Articulated slow rate 0.43 for crystal clear pronunciation
        // 4. Default sentence: Calm natural conversational tone 0.47 rate, 1.0 pitch
        final isQuestion = cleanText.contains('?') ||
            cleanText.endsWith('까요') ||
            cleanText.endsWith('나요') ||
            cleanText.endsWith('가요') ||
            cleanText.endsWith('어?') ||
            cleanText.endsWith('니?');
        final isExclamation = cleanText.contains('!');
        final isShortWord = !cleanText.contains(' ') && cleanText.length <= 4;

        if (isQuestion) {
          // Native rising intonation: pitch raised so the question ending goes up naturally
          await _flutterTts!.setPitch(1.16);
          await _flutterTts!.setSpeechRate(0.46);
        } else if (isExclamation) {
          await _flutterTts!.setPitch(1.08);
          await _flutterTts!.setSpeechRate(0.49);
        } else if (isShortWord) {
          // Clear, crisp vocabulary pronunciation
          await _flutterTts!.setPitch(1.0);
          await _flutterTts!.setSpeechRate(0.43);
        } else {
          // Standard conversational Korean
          await _flutterTts!.setPitch(1.0);
          await _flutterTts!.setSpeechRate(0.47);
        }

        await _flutterTts!.speak(cleanText);
      }
    } catch (e) {
      debugPrint('TtsService speak error: $e');
      _currentlyPlayingText = null;
    }
  }

  /// Stop current playback
  Future<void> stop() async {
    try {
      if (_flutterTts != null) {
        await _flutterTts!.stop();
      }
    } catch (e) {
      debugPrint('TtsService stop error: $e');
    } finally {
      _currentlyPlayingText = null;
    }
  }
}
