# -*- coding: utf-8 -*-
"""
sync_quiz_data_dart.py
Synchronizes lib/data/quiz_data.dart with assets/data/questions.json.
"""

import json

def escape_dart_str(s):
    if s is None:
        return 'null'
    # Escape backslashes and single quotes and newlines
    s = s.replace('\\', '\\\\')
    s = s.replace("'", "\\'")
    s = s.replace('\n', '\\n')
    s = s.replace('\r', '')
    s = s.replace('$', '\\$')
    return f"'{s}'"

def format_map(m):
    items = []
    for k, v in m.items():
        items.append(f"      '{k}': {escape_dart_str(v)},")
    return "{\n" + "\n".join(items) + "\n    }"

def format_list(l):
    items = [escape_dart_str(x) for x in l]
    return f"[{', '.join(items)}]"

def main():
    with open('assets/data/questions.json', 'r', encoding='utf-8') as f:
        questions = json.load(f)

    header = """import '../models/quiz_question.dart';

export '../models/quiz_question.dart';

class LanguageOption {
  final String code;
  final String label;
  final String flag;

  const LanguageOption({
    required this.code,
    required this.label,
    required this.flag,
  });
}

const List<LanguageOption> supportedLanguages = [
  LanguageOption(code: 'KO', label: '한국어 (기본)', flag: '🇰🇷'),
  LanguageOption(code: 'EN', label: 'English', flag: '🇺🇸'),
  LanguageOption(code: 'ZH', label: '中文', flag: '🇨🇳'),
  LanguageOption(code: 'JA', label: '日本語', flag: '🇯🇵'),
  LanguageOption(code: 'VI', label: 'Tiếng Việt', flag: '🇻🇳'),
];

/// Fallback in-memory quiz questions synchronized with assets/data/questions.json
final List<QuizQuestion> sampleQuizQuestions = [
"""

    blocks = []
    for q in questions:
        lines = ["  QuizQuestion("]
        lines.append(f"    id: {q['id']},")
        lines.append(f"    type: {escape_dart_str(q.get('type', 'sentence'))},")
        lines.append(f"    category: {escape_dart_str(q['category'])},")
        if q.get('visual'):
            lines.append(f"    visual: {escape_dart_str(q['visual'])},")
        if q.get('keyword'):
            lines.append(f"    keyword: {escape_dart_str(q['keyword'])},")
        if q.get('speechBubble'):
            lines.append(f"    speechBubble: {escape_dart_str(q['speechBubble'])},")
        lines.append(f"    level: {q.get('level', 1)},")
        lines.append(f"    situations: {format_map(q['situations'])},")
        lines.append(f"    questions: {format_map(q['questions'])},")
        lines.append(f"    options: {format_list(q['options'])},")
        lines.append(f"    answerIndex: {q['answerIndex']},")
        lines.append(f"    explanations: {format_map(q['explanations'])},")
        if q.get('chips'):
            lines.append(f"    chips: {format_list(q['chips'])},")
        lines.append("  ),")
        blocks.append("\n".join(lines))

    footer = "\n];\n"
    content = header + "\n".join(blocks) + footer

    with open('lib/data/quiz_data.dart', 'w', encoding='utf-8') as f:
        f.write(content)

    print(f"Successfully synchronized lib/data/quiz_data.dart with {len(questions)} questions.")

if __name__ == '__main__':
    main()

