import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quiz_question.dart';
import '../data/quiz_data.dart';

class QuizRepository {
  static List<QuizQuestion> _questions = [];

  /// Get the currently loaded questions (falls back to sample questions if not loaded)
  static List<QuizQuestion> get questions {
    if (_questions.isNotEmpty) {
      return _questions;
    }
    return sampleQuizQuestions;
  }

  /// Total count of loaded questions
  static int get totalCount => questions.length;

  /// Load questions from assets/data/questions.json
  static Future<List<QuizQuestion>> loadQuestions({bool reload = false}) async {
    if (_questions.isNotEmpty && !reload) {
      return _questions;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/data/questions.json');
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      _questions = jsonList
          .map((item) => QuizQuestion.fromJson(item as Map<String, dynamic>))
          .toList();
      return _questions;
    } catch (e) {
      // Fallback to in-memory sample questions if JSON read fails
      _questions = List.from(sampleQuizQuestions);
      return _questions;
    }
  }

  /// Filter questions by category (case-insensitive)
  static List<QuizQuestion> getByCategory(String? category) {
    if (category == null || category.isEmpty) {
      return List.from(questions);
    }
    final filtered = questions
        .where((q) => q.category.toLowerCase() == category.toLowerCase())
        .toList();
    return filtered.isNotEmpty ? filtered : List.from(questions);
  }
}
