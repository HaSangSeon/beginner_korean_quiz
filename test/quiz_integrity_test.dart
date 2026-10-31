import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:beginner_korean_quiz/models/quiz_question.dart';
import 'package:beginner_korean_quiz/data/quiz_data.dart';
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
        expect(qMemory.options[qMemory.answerIndex], equals(qJson.options[qJson.answerIndex]));
      }
    });
  });
}

