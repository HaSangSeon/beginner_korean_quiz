import '../models/quiz_question.dart';
import '../data/quiz_data.dart';
import 'progress_service.dart';

class QuizRepository {
  static List<QuizQuestion> _questions = [];

  /// Get the currently loaded questions (always synchronized with sampleQuizQuestions)
  static List<QuizQuestion> get questions {
    if (_questions.isNotEmpty) {
      return _questions;
    }
    return sampleQuizQuestions;
  }

  /// Total count of loaded questions
  static int get totalCount => questions.length;

  /// Load questions (defaults to live in-memory sampleQuizQuestions)
  static Future<List<QuizQuestion>> loadQuestions({bool reload = false}) async {
    _questions = List.from(sampleQuizQuestions);
    return _questions;
  }

  /// Global toggle for shuffling (can be set to false in widget tests)
  static bool enableShuffle = true;

  /// Default number of questions in one lesson session.
  static const int sessionSize = 10;

  /// Filter questions by type ('word' or 'sentence'), category, and level.
  /// Unlearned questions are prioritized so returning users always get fresh content.
  static List<QuizQuestion> getQuestions({
    String? type,
    String? category,
    int? level,
    List<int>? ids,
    int? limit,
    bool shuffle = true,
  }) {
    var result = List<QuizQuestion>.from(questions);
    if (ids != null) {
      final idSet = ids.toSet();
      result = result.where((q) => idSet.contains(q.id)).toList();
    }
    if (type != null && type.isNotEmpty && type != 'all') {
      result = result.where((q) => q.type.toLowerCase() == type.toLowerCase()).toList();
    }
    if (level != null && level > 0) {
      result = result.where((q) => q.level == level).toList();
    }
    if (category != null &&
        category.isNotEmpty &&
        category.toLowerCase() != 'nuances' &&
        category.toLowerCase() != 'nuance' &&
        category.toLowerCase() != 'all') {
      final filtered = result
          .where((q) => q.category.toLowerCase() == category.toLowerCase())
          .toList();
      if (filtered.isNotEmpty) {
        result = filtered;
      }
    }

    var baseList = result.isNotEmpty ? result : List<QuizQuestion>.from(questions);

    if (!shuffle || !enableShuffle) {
      if (limit != null && baseList.length > limit) {
        return baseList.sublist(0, limit);
      }
      return baseList;
    }

    // Smart Duolingo-style Priority:
    // 1) Unlearned questions first (always fresh content for the learner)
    // 2) Mastered questions second (for spaced review)
    final learned = ProgressService().learnedIds;
    final unlearned = baseList.where((q) => !learned.contains(q.id)).toList()..shuffle();
    final mastered = baseList.where((q) => learned.contains(q.id)).toList()..shuffle();
    baseList = [...unlearned, ...mastered];

    if (limit != null && baseList.length > limit) {
      baseList = baseList.sublist(0, limit);
    }

    // Dynamically shuffle options for each question so answers are always randomized
    return baseList.map((q) {
      final correctAnswer = q.options[q.answerIndex];
      final shuffledOptions = List<String>.from(q.options)..shuffle();
      final newAnswerIndex = shuffledOptions.indexOf(correctAnswer);

      return QuizQuestion(
        id: q.id,
        category: q.category,
        type: q.type,
        visual: q.visual,
        keyword: q.keyword,
        speechBubble: q.speechBubble,
        situations: q.situations,
        questions: q.questions,
        options: shuffledOptions,
        answerIndex: newAnswerIndex >= 0 ? newAnswerIndex : q.answerIndex,
        explanations: q.explanations,
      );
    }).toList();
  }

  /// Filter questions by category (case-insensitive)
  static List<QuizQuestion> getByCategory(String? category) {
    return getQuestions(category: category);
  }

  /// Filter questions by type ('word' or 'sentence')
  static List<QuizQuestion> getByType(String type) {
    return questions.where((q) => q.type.toLowerCase() == type.toLowerCase()).toList();
  }

  /// Get question count for a specific type
  static int getCountByType(String type) {
    return questions.where((q) => q.type.toLowerCase() == type.toLowerCase()).length;
  }

  /// Get question count for a specific category
  static int getCountByCategory(String category) {
    return questions
        .where((q) => q.category.toLowerCase() == category.toLowerCase())
        .length;
  }

  /// Ordered list of categories for a track (in order of first appearance)
  static List<String> getCategoriesByType(String type) {
    final seen = <String>{};
    for (final q in questions) {
      if (q.type.toLowerCase() == type.toLowerCase()) seen.add(q.category);
    }
    return seen.toList();
  }

  /// Question IDs belonging to a category
  static List<int> getIdsByCategory(String category) {
    return questions.where((q) => q.category == category).map((q) => q.id).toList();
  }

  /// Get available levels for a category
  static List<int> getLevelsByCategory(String category) {
    final levels = questions
        .where((q) => q.category.toLowerCase() == category.toLowerCase())
        .map((q) => q.level)
        .toSet()
        .toList();
    levels.sort();
    return levels.isEmpty ? [1] : levels;
  }

  /// Question IDs belonging to a category and specific level
  static List<int> getIdsByCategoryAndLevel(String category, int level) {
    return questions
        .where((q) => q.category.toLowerCase() == category.toLowerCase() && q.level == level)
        .map((q) => q.id)
        .toList();
  }
}
