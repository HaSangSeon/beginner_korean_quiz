import 'package:flutter/material.dart';
import '../data/app_localization.dart';
import '../data/quiz_data.dart';
import '../models/quiz_question.dart';
import '../services/quiz_repository.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String initialLangCode;
  final String? category;

  const QuizScreen({
    super.key,
    this.initialLangCode = 'KO',
    this.category,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<QuizQuestion> _questions;
  late String _currentLangCode;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _currentLangCode = widget.initialLangCode;
    _questions = QuizRepository.getByCategory(widget.category);
  }

  void _onOptionSelected(int index) {
    if (_isAnswered) return;

    final currentQuestion = _questions[_currentIndex];
    final isCorrect = index == currentQuestion.answerIndex;

    setState(() {
      _selectedOptionIndex = index;
      _isAnswered = true;
      if (isCorrect) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
        _isAnswered = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: _score,
            totalQuestions: _questions.length,
            langCode: _currentLangCode,
          ),
        ),
      );
    }
  }

  LanguageOption _getCurrentLanguageOption() {
    return supportedLanguages.firstWhere(
      (l) => l.code == _currentLangCode,
      orElse: () => supportedLanguages.first,
    );
  }

  String _getCategoryLabel(String category) {
    return AppStrings.category(category, _currentLangCode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final total = _questions.length;
    final currentQuestion = _questions[_currentIndex];
    final isLastQuestion = _currentIndex == total - 1;
    final progress = (_currentIndex + 1) / total;
    final currentLang = _getCurrentLanguageOption();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(AppStrings.tr('app_bar_quiz_title', _currentLangCode)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: AppStrings.tr('quiz_exit_tooltip', _currentLangCode),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(AppStrings.tr('quiz_quit_title', _currentLangCode)),
                content: Text(
                  AppStrings.tr('quiz_quit_desc', _currentLangCode),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(AppStrings.tr('quiz_quit_continue', _currentLangCode)),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                    ),
                    child: Text(AppStrings.tr('quiz_quit_exit', _currentLangCode)),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          // Dynamic Language Switcher Popup
          PopupMenuButton<String>(
            tooltip: 'Switch Explanation Language',
            initialValue: _currentLangCode,
            onSelected: (String newCode) {
              setState(() {
                _currentLangCode = newCode;
              });
            },
            itemBuilder: (BuildContext context) {
              return supportedLanguages.map((LanguageOption lang) {
                return PopupMenuItem<String>(
                  value: lang.code,
                  child: Row(
                    children: [
                      Text(lang.flag, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${lang.code} • ${lang.label}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: lang.code == _currentLangCode
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: lang.code == _currentLangCode
                                ? const Color(0xFF2563EB)
                                : const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 14),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(currentLang.flag, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    currentLang.code,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.arrow_drop_down_rounded,
                    size: 18,
                    color: Color(0xFF1D4ED8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top: Progress Bar, Question Counter & Category Badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          AppStrings.tr('quiz_question_progress', _currentLangCode, {
                            'current': '${_currentIndex + 1}',
                            'total': '$total',
                          }),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E3A8A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.tag_rounded,
                              size: 13,
                              color: Color(0xFF2563EB),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getCategoryLabel(currentQuestion.category),
                              style: const TextStyle(
                                color: Color(0xFF1D4ED8),
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content: Situation Box + Question Card + 4 Options
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Situation Context Card (In Selected Language)
                    Container(
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFCBD5E1),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF334155),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.theater_comedy_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        AppStrings.tr('quiz_situation_context', _currentLangCode),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF475569),
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '(${currentLang.code})',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2563EB),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  currentQuestion.getSituation(_currentLangCode),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1E293B),
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 2. Question Prompt Card (In Selected Language)
                    Container(
                      padding: const EdgeInsets.all(18.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF64748B).withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.help_outline_rounded,
                                size: 17,
                                color: Color(0xFF2563EB),
                              ),
                              const SizedBox(width: 7),
                              Flexible(
                                child: Text(
                                  AppStrings.tr('quiz_which_expression', _currentLangCode),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            currentQuestion.getQuestion(_currentLangCode),
                            style: const TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. 4 Multiple Choice Options (Korean Text >= 19pt)
                    ...List.generate(currentQuestion.options.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 11.0),
                        child: _buildOptionButton(
                          context: context,
                          index: index,
                          optionText: currentQuestion.options[index],
                          correctIndex: currentQuestion.answerIndex,
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Bottom Area: Spot on! / Not quite!, Explanation & Next Button
            if (_isAnswered) _buildFeedbackBottomBar(context, isLastQuestion),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required int index,
    required String optionText,
    required int correctIndex,
  }) {
    Color backgroundColor = Colors.white;
    Color borderColor = const Color(0xFFE2E8F0);
    Color textColor = const Color(0xFF0F172A);
    Widget? trailingIcon;

    if (_isAnswered) {
      if (index == correctIndex) {
        backgroundColor = const Color(0xFFF0FDF4);
        borderColor = const Color(0xFF16A34A);
        textColor = const Color(0xFF14532D);
        trailingIcon = const Icon(
          Icons.check_circle_rounded,
          color: Color(0xFF16A34A),
          size: 24,
        );
      } else if (index == _selectedOptionIndex) {
        backgroundColor = const Color(0xFFFEF2F2);
        borderColor = const Color(0xFFDC2626);
        textColor = const Color(0xFF7F1D1D);
        trailingIcon = const Icon(
          Icons.cancel_rounded,
          color: Color(0xFFDC2626),
          size: 24,
        );
      } else {
        backgroundColor = const Color(0xFFF8FAFC);
        borderColor = const Color(0xFFE2E8F0);
        textColor = const Color(0xFF94A3B8);
      }
    }

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _isAnswered ? null : () => _onOptionSelected(index),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: (_isAnswered && (index == correctIndex || index == _selectedOptionIndex))
                  ? 2.0
                  : 1.2,
            ),
            boxShadow: [
              if (!_isAnswered)
                BoxShadow(
                  color: const Color(0xFF64748B).withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isAnswered && index == correctIndex
                      ? const Color(0xFF16A34A)
                      : (_isAnswered && index == _selectedOptionIndex
                          ? const Color(0xFFDC2626)
                          : const Color(0xFFF1F5F9)),
                ),
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: _isAnswered &&
                            (index == correctIndex || index == _selectedOptionIndex)
                        ? Colors.white
                        : const Color(0xFF475569),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  optionText,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    height: 1.25,
                  ),
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                trailingIcon,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackBottomBar(BuildContext context, bool isLastQuestion) {
    final currentQuestion = _questions[_currentIndex];
    final isCorrect = _selectedOptionIndex == currentQuestion.answerIndex;
    final currentLang = _getCurrentLanguageOption();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
                color: isCorrect ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                size: 26,
              ),
              const SizedBox(width: 10),
              Text(
                isCorrect
                    ? AppStrings.tr('quiz_correct_feedback', _currentLangCode)
                    : AppStrings.tr('quiz_incorrect_feedback', _currentLangCode),
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: isCorrect ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Certified Instructor Nuance Explanation in Selected Language
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.psychology_alt_rounded,
                  size: 20,
                  color: Color(0xFF2563EB),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              AppStrings.tr('quiz_instructor_header', _currentLangCode),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2563EB),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${currentLang.code})',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentQuestion.getExplanation(_currentLangCode),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1E293B),
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Next Question Button
          FilledButton.icon(
            onPressed: _nextQuestion,
            icon: Icon(
              isLastQuestion ? Icons.emoji_events_rounded : Icons.arrow_forward_rounded,
            ),
            label: Text(
              isLastQuestion
                  ? AppStrings.tr('quiz_see_results', _currentLangCode)
                  : AppStrings.tr('quiz_next_question', _currentLangCode),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
