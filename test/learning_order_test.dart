import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beginner_korean_quiz/data/dialogue_data.dart';
import 'package:beginner_korean_quiz/data/learning_order.dart';
import 'package:beginner_korean_quiz/services/progress_service.dart';
import 'package:beginner_korean_quiz/services/quiz_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await ProgressService().init();
    QuizRepository.enableShuffle = true;
  });

  test('All three tracks start with ten curated beginner questions', () {
    for (final type in ['word', 'sentence', 'survival']) {
      final items = QuizRepository.getQuestions(type: type, limit: 10);
      expect(items.length, 10);
      expect(items.every((q) => LearningOrder.beginnerQuestionIds.contains(q.id)), true);
      expect(items.map((q) => q.id),
          QuizRepository.getQuestions(type: type, limit: 10).map((q) => q.id));
      for (final q in items) {
        final original = QuizRepository.getById(q.id)!;
        expect(q.options[q.answerIndex], original.options[original.answerIndex]);
        expect(q.level, original.level);
      }
    }
  });

  test('Returning learners advance past learned beginner questions', () async {
    final first = QuizRepository.getQuestions(type: 'word', limit: 10);
    SharedPreferences.setMockInitialValues({
      'progress_learned_ids': first.map((q) => '${q.id}').toList(),
    });
    await ProgressService().init();
    final next = QuizRepository.getQuestions(type: 'word', limit: 10);
    expect(next.any((q) => first.any((old) => old.id == q.id)), false);
    expect(next.every((q) => LearningOrder.beginnerQuestionIds.contains(q.id)), true);
  });

  test('Category order is stable and reviews keep selected content', () {
    final category = QuizRepository.getQuestions(category: '배달·생활편의', shuffle: false);
    expect(category.first.id, 630);
    expect(category.indexWhere((q) => q.id == 329), greaterThan(category.indexWhere((q) => q.id == 625)));
    final review = QuizRepository.getQuestions(ids: [601, 329], shuffle: false);
    expect(review.map((q) => q.id).toList(), [329, 601]);
    final levelTwo = QuizRepository.getQuestions(level: 2);
    expect(levelTwo.every((q) => q.level == 2), true);
  });

  test('Dialogue order includes every ID once and keeps audio mappings', () {
    final ordered = dialoguesInLearningOrder;
    expect(ordered.map((d) => d.id).toSet(), dialogues.map((d) => d.id).toSet());
    expect(LearningOrder.dialogueIds.toSet().length, dialogues.length);
    expect(ordered.take(4).map((d) => d.id).toList(), [1, 2, 3, 4]);
    expect(ordered.last.id, 20);
    for (final d in ordered) {
      expect(d.audioAsset, 'assets/audio/dialogue_${d.id}.mp3');
    }
    final ids = QuizRepository.questions.map((q) => q.id).toSet();
    expect(ids.containsAll(LearningOrder.beginnerQuestionIds), true);
    expect(ids.containsAll(LearningOrder.advancedQuestionIds), true);
    expect(LearningOrder.beginnerQuestionIds.toSet().length, LearningOrder.beginnerQuestionIds.length);
  });
}
