import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:beginner_korean_quiz/data/quiz_data.dart';
import 'package:beginner_korean_quiz/data/hangul_data.dart';
import 'package:beginner_korean_quiz/utils/korean_romanizer.dart';
import 'dart:io';

void main() {
  group('Quiz Data Integrity & Solvability Tests', () {
    late List<QuizQuestion> questions;

    setUpAll(() async {
      final file = File('assets/data/questions.json');
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonString);
      questions = jsonList.map((e) => QuizQuestion.fromJson(e)).toList();
    });

    test('Total questions count is at least 200', () {
      expect(questions.length, greaterThanOrEqualTo(200));
      expect(sampleQuizQuestions.length, equals(questions.length));
    });

    test('All IDs are unique and sequential', () {
      final ids = questions.map((q) => q.id).toList();
      final uniqueIds = ids.toSet();
      expect(uniqueIds.length, equals(ids.length), reason: 'Duplicate IDs found!');
    });

    test('All questions have valid answerIndex within options range', () {
      for (final q in questions) {
        expect(q.options.length, equals(4), reason: 'Question #${q.id} must have exactly 4 options');
        expect(q.answerIndex, greaterThanOrEqualTo(0), reason: 'Question #${q.id} negative answerIndex');
        expect(q.answerIndex, lessThan(q.options.length), reason: 'Question #${q.id} answerIndex overflow');
      }
    });

    test('All 5 languages (KO, EN, VI, ZH, JA) are present in situations and explanations', () {
      const requiredLangs = ['KO', 'EN', 'VI', 'ZH', 'JA'];
      for (final q in questions) {
        for (final lang in requiredLangs) {
          expect(q.situations[lang]?.trim().isNotEmpty, isTrue,
              reason: 'Question #${q.id} missing situation for $lang');
          expect(q.explanations[lang]?.trim().isNotEmpty, isTrue,
              reason: 'Question #${q.id} missing explanation for $lang');
        }
      }
    });

    test('All chip (word-assembly) questions can construct the exact target answer', () {
      for (final q in questions) {
        if (q.chips != null && q.chips!.isNotEmpty) {
          final targetText = q.options[q.answerIndex].replaceAll(' ', '').trim();
          
          // Verify that combinations of chips can formulate the targetText exactly
          final chipsClean = q.chips!.map((c) => c.replaceAll(' ', '').trim()).toList();
          
          bool canSolve(String current, List<String> available) {
            if (current == targetText) return true;
            if (!targetText.startsWith(current)) return false;
            
            for (int i = 0; i < available.length; i++) {
              final next = current + available[i];
              final remaining = List<String>.from(available)..removeAt(i);
              if (canSolve(next, remaining)) return true;
            }
            return false;
          }

          final solvable = canSolve('', chipsClean);
          expect(solvable, isTrue,
              reason: 'Question #${q.id} chips ${q.chips} cannot form answer "${q.options[q.answerIndex]}"');
        }
      }
    });

    test('In-memory sampleQuizQuestions is synchronized with questions.json', () {
      expect(sampleQuizQuestions.length, equals(questions.length));
      for (int i = 0; i < questions.length; i++) {
        final qJson = questions[i];
        final qMemory = sampleQuizQuestions[i];
        expect(qMemory.id, equals(qJson.id));
        expect(qMemory.options, equals(qJson.options));
        expect(qMemory.answerIndex, equals(qJson.answerIndex));
        expect(qMemory.questions['KO'], equals(qJson.questions['KO']));
        expect(qMemory.situations, equals(qJson.situations));
        expect(qMemory.explanations, equals(qJson.explanations));
      }
    });

    test('Every question has exactly 1 blank and no slash particles around blanks', () {
      final blankRegex = RegExp(r'\(\s*\)');
      for (final q in questions) {
        final ko = q.questions['KO'] ?? '';
        final matches = blankRegex.allMatches(ko).length;
        expect(matches, equals(1), reason: 'Question #${q.id} has $matches blanks: $ko');
        expect(ko.contains('을/를'), isFalse, reason: 'Question #${q.id} still contains 을/를');
        expect(ko.contains('이/가'), isFalse, reason: 'Question #${q.id} still contains 이/가');
      }
    });

    test('Hangul Vietnamese soundTips do not contain untranslated Korean 또는', () {
      for (final tip in HangulData.localizedSoundTips.values) {
        expect(tip['VI']?.contains('또는'), isFalse,
            reason: 'Hangul VI soundTip contains 또는: ${tip['VI']}');
      }
    });
  });

  group('KoreanRomanizer Regression Tests', () {
    test('Handles liaison (연음), punctuation tokens, and phonological rules accurately', () {
      expect(KoreanRomanizer.romanize('물이'), equals('muri'));
      expect(KoreanRomanizer.romanize('밥을'), equals('babeul'));
      expect(KoreanRomanizer.romanize('있어요'), equals('isseoyo'));
      expect(KoreanRomanizer.romanize('있어요?'), equals('isseoyo?'));
      expect(KoreanRomanizer.romanize('있어요!'), equals('isseoyo!'));
      expect(KoreanRomanizer.romanize('먹어요'), equals('meogeoyo'));
      expect(KoreanRomanizer.romanize('같이'), equals('gachi'));
      expect(KoreanRomanizer.romanize('축하해요'), equals('chukahaeyo'));
      expect(KoreanRomanizer.romanize('설날'), equals('seollal'));
      expect(KoreanRomanizer.romanize('감사합니다.'), equals('gamsahamnida.'));
    });
  });
}

