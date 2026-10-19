import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quiz_question.dart';
import '../data/quiz_data.dart';

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
    // Always use sampleQuizQuestions directly so hot reload / hot restart reflects immediately
    _questions = List.from(sampleQuizQuestions);
    return _questions;
  }

  /// Filter questions by type ('word' or 'sentence') and/or category
  static List<QuizQuestion> getQuestions({String? type, String? category}) {
    var result = List<QuizQuestion>.from(questions);
    if (type != null && type.isNotEmpty && type != 'all') {
      result = result.where((q) => q.type.toLowerCase() == type.toLowerCase()).toList();
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
    return result.isNotEmpty ? result : List.from(questions);
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
}
