class QuizQuestion {
  final int id;
  final String category;
  final Map<String, String> situations;
  final Map<String, String> questions;
  final List<String> options;
  final int answerIndex;
  final Map<String, String> explanations;

  const QuizQuestion({
    required this.id,
    required this.category,
    required this.situations,
    required this.questions,
    required this.options,
    required this.answerIndex,
    required this.explanations,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as int,
      category: json['category'] as String,
      situations: Map<String, String>.from(json['situations'] as Map),
      questions: Map<String, String>.from(json['questions'] as Map),
      options: List<String>.from(json['options'] as List),
      answerIndex: json['answerIndex'] as int,
      explanations: Map<String, String>.from(json['explanations'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'situations': situations,
      'questions': questions,
      'options': options,
      'answerIndex': answerIndex,
      'explanations': explanations,
    };
  }

  /// Helper methods with fallback to Korean ('KO'), then English ('EN')
  String getSituation(String langCode) {
    return situations[langCode] ?? situations['KO'] ?? situations['EN'] ?? '';
  }

  String getQuestion(String langCode) {
    return questions[langCode] ?? questions['KO'] ?? questions['EN'] ?? '';
  }

  String getExplanation(String langCode) {
    return explanations[langCode] ?? explanations['KO'] ?? explanations['EN'] ?? '';
  }
}
