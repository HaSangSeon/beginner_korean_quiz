class QuizQuestion {
  final int id;
  final String category;
  final String type; // 'word' (기초 어휘) or 'sentence' (실전 문장·뉘앙스)
  final int level; // 1 (기초), 2 (실전), 3 (심화)
  final String? visual; // emoji/illustration symbol (e.g. '🌹', '🎹', '🚗')
  final String? keyword; // visual card caption (e.g. '공원', '도서관', '편의점')
  final String? speechBubble; // visual comic speech bubble (e.g. '저는 미국 사람이지만...')
  final Map<String, String> situations;
  final Map<String, String> questions;
  final List<String> options;
  final int answerIndex;
  final Map<String, String> explanations;

  const QuizQuestion({
    required this.id,
    required this.category,
    this.type = 'sentence',
    this.level = 1,
    this.visual,
    this.keyword,
    this.speechBubble,
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
      type: json['type'] as String? ?? 'sentence',
      level: json['level'] as int? ?? 1,
      visual: json['visual'] as String?,
      keyword: json['keyword'] as String?,
      speechBubble: json['speechBubble'] as String?,
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
      'type': type,
      'level': level,
      if (visual != null) 'visual': visual,
      if (keyword != null) 'keyword': keyword,
      if (speechBubble != null) 'speechBubble': speechBubble,
      'situations': situations,
      'questions': questions,
      'options': options,
      'answerIndex': answerIndex,
      'explanations': explanations,
    };
  }

  /// Helper methods defaulting to Korean ('KO') for quiz questions and situations
  String getSituation([String langCode = 'KO']) {
    return situations[langCode] ?? situations['KO'] ?? situations['EN'] ?? '';
  }

  String getQuestion([String langCode = 'KO']) {
    return questions[langCode] ?? questions['KO'] ?? questions['EN'] ?? '';
  }

  String getExplanation(String langCode) {
    return explanations[langCode] ?? explanations['KO'] ?? explanations['EN'] ?? '';
  }
}
