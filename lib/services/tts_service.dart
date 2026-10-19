import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  String? _currentlyPlayingText;

  String? get currentlyPlayingText => _currentlyPlayingText;

  Future<void> _initTts() async {
    if (_isInitialized) return;
    try {
      _flutterTts = FlutterTts();
      await _flutterTts!.setLanguage('ko-KR');
      await _flutterTts!.setSpeechRate(0.48); // Slightly slower for language learners
      await _flutterTts!.setVolume(1.0);
      await _flutterTts!.setPitch(1.0);

      _flutterTts!.setCompletionHandler(() {
        _currentlyPlayingText = null;
      });

      _flutterTts!.setErrorHandler((msg) {
        _currentlyPlayingText = null;
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint('TtsService init error: $e');
    }
  }

  /// Speak Korean text
  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    try {
      await _initTts();
      if (_flutterTts != null) {
        _currentlyPlayingText = text;
        await _flutterTts!.stop();
        await _flutterTts!.speak(text);
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
