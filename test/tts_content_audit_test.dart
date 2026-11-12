import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beginner_korean_quiz/services/tts_service.dart';
import 'package:beginner_korean_quiz/data/dialogue_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('New content reaches TTS in Korean with ko-KR configured', () async {
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_tts'), (call) async {
      calls.add(call);
      switch (call.method) {
        case 'isLanguageAvailable':
        case 'isLanguageInstalled': return true;
        case 'getVoices': return [{'name': 'test-korean', 'locale': 'ko-KR'}];
        case 'getEngines': return [];
        default: return 1;
      }
    });
    final tts = TtsService();
    final questions = (jsonDecode(File('assets/data/questions.json').readAsStringSync()) as List)
        .where((q) => q['id'] >= 601).toList();
    final blank = RegExp(r'\(\s*\)');
    for (final q in questions) {
      final target = (q['questions']['KO'] as String).split('\n').firstWhere(blank.hasMatch);
      final complete = target.replaceFirst(blank, q['options'][q['answerIndex']]);
      await tts.speak(complete);
      final spoken = calls.lastWhere((c) => c.method == 'speak').arguments as String;
      expect(spoken, complete.replaceFirst(RegExp(r'^[^:]+:\s*'), ''));
      expect(spoken, isNot(matches(RegExp(r'[A-Za-z]|\(\s*\)|^[가나]:'))));
    }
    final lines = dialogues.where((d) => d.id >= 42).expand((d) => d.lines).toList();
    expect(lines.length, 80);
    for (final line in lines) {
      await tts.speak(line.text);
      expect(calls.lastWhere((c) => c.method == 'speak').arguments, line.text);
    }
    expect(calls.where((c) => c.method == 'setLanguage').map((c) => c.arguments), ['ko-KR']);
    expect(calls.lastWhere((c) => c.method == 'setVoice').arguments['locale'], 'ko-KR');
    expect(calls.lastWhere((c) => c.method == 'awaitSpeakCompletion').arguments, true);
    expect(calls.where((c) => c.method == 'speak').length, 110);
  });
}
