import 'package:flutter/material.dart';
import '../data/app_localization.dart';
import '../data/quiz_data.dart';
import '../services/ad_service.dart';
import '../services/progress_service.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final String langCode;
  final String? quizType;
  final String? category;
  final int? level;
  final bool isReviewMode;
  final List<int>? reviewIds;
  final List<int>? sessionWrongIds;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    this.langCode = 'KO',
    this.quizType,
    this.category,
    this.level,
    this.isReviewMode = false,
    this.reviewIds,
    this.sessionWrongIds,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String get _langCode => ProgressService().language;

  @override
  void initState() {
    super.initState();
  }

  String _getLocalizedEncouragement(double percentage) {
    final lang = _langCode.toUpperCase();

    if (percentage == 1.0) {
      switch (lang) {
        case 'KO':
          return widget.isReviewMode
              ? '완벽합니다! 틀렸던 문제들을 완벽하게 이해하고 마스터하셨습니다.'
              : '원어민 수준의 자연스러운 뉘앙스 감각! 교과서에서는 배울 수 없는 진짜 한국어 감각을 완벽히 마스터하셨습니다.';
        case 'ES':
          return '¡Intuición de nivel nativo! Comprendes los matices reales del coreano que los libros no enseñan.';
        case 'ZH':
          return '母语级语感！你已经掌握了教科书里学不到的地道韩国语实际语感。';
        case 'JA':
          return 'ネイティブ級の感覚！教科書には載っていない生きた韓国語のニュアンスを掴んでいます。';
        case 'VI':
          return 'Trực giác chuẩn người bản xứ! Bạn đã hiểu được những sắc thái tiếng Hàn thực tế mà sách vở không dạy.';
        case 'PT':
          return 'Intuição de nível nativo! Você compreende as nuances reais do coreano que os livros não ensinam.';
        default:
          return 'Native-level Intuition! You understand real Korean nuances that textbooks never teach.';
      }
    } else if (percentage >= 0.75) {
      switch (lang) {
        case 'KO':
          return '훌륭합니다! 교과서식의 어색한 함정을 피하고 한국인처럼 매우 자연스럽게 표현하고 계십니다.';
        case 'ES':
          return '¡Impresionante! Evitas las trampas comunes de los libros y suenas muy natural.';
        case 'ZH':
          return '令人印象深刻！你成功避开了教科书常见误区，韩语表达非常自然。';
        case 'JA':
          return '素晴らしい！教科書の不自然な落とし穴を避け、とても自然に表現できています。';
        case 'VI':
          return 'Thật ấn tượng! Bạn đã tránh được những lỗi dịch ngô nghê trong sách và nói rất tự nhiên.';
        case 'PT':
          return 'Impressionante! Você evita as armadilhas comuns dos livros e soa muito natural.';
        default:
          return 'Impressive! You avoid the common textbook traps and sound very natural.';
      }
    } else if (percentage >= 0.5) {
      switch (lang) {
        case 'KO':
          return '좋은 진전입니다! 어색한 직역 습관에서 벗어나고 있습니다. 뉘앙스를 한 번 더 복습하면 완벽해집니다!';
        case 'ES':
          return '¡Buen progreso! Estás superando las traducciones forzadas. ¡Repasa los matices para dominarlos!';
        case 'ZH':
          return '进步很大！正在摆脱尴尬的直译思维。多复习几次即可彻底掌握！';
        case 'JA':
          return '順調にステップアップ！不自然な直訳から脱却できています。復習して定着させましょう！';
        case 'VI':
          return 'Tiến bộ tốt! Bạn đang dần thoát khỏi lối dịch gượng gạo. Hãy ôn lại để thành thạo hơn nhé!';
        case 'PT':
          return 'Bom progresso! Você está superando as traduções forçadas. Revise as nuances para dominá-las!';
        default:
          return 'Good progress! You are breaking free of awkward translations. Review the nuances to master them!';
      }
    } else {
      switch (lang) {
        case 'KO':
          return '포기하지 마세요! 한국어의 뉘앙스는 깊은 문화와 맥락이 담겨 있습니다. 다시 한번 도전해 보세요!';
        case 'ES':
          return '¡Sigue aprendiendo! Los matices coreanos son sutiles y profundos. ¡Inténtalo de nuevo!';
        case 'ZH':
          return '继续加油！韩语实际语感非常细腻且蕴含文化背景。再做一次测验来锻炼敏锐度吧！';
        case 'JA':
          return '諦めずに挑戦！韓国語のニュアンスは奥深く文化が反映されています。もう一度挑戦してみましょう！';
        case 'VI':
          return 'Hãy kiên trì nhé! Sắc thái tiếng Hàn rất tinh tế và mang đậm văn hóa. Hãy thử lại để rèn luyện thêm!';
        case 'PT':
          return 'Continue praticando! As nuances do coreano são sutis e ricas culturalmente. Tente de novo!';
        default:
          return 'Keep learning! Korean nuances are subtle and culturally deep. Take the quiz again to sharpen your ear!';
      }
    }
  }

  IconData _getResultIcon(double percentage) {
    if (percentage >= 0.75) {
      return Icons.emoji_events_rounded;
    } else if (percentage >= 0.5) {
      return Icons.thumb_up_alt_rounded;
    } else {
      return Icons.psychology_rounded;
    }
  }

  Color _getResultColor(BuildContext context, double percentage) {
    if (percentage >= 0.75) {
      return Colors.amber.shade700;
    } else if (percentage >= 0.5) {
      return const Color(0xFF2563EB);
    } else {
      return Colors.orange.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final percentage = widget.totalQuestions > 0
        ? widget.score / widget.totalQuestions
        : 0.0;
    final percentInt = (percentage * 100).round();
    final langOption = supportedLanguages.firstWhere(
      (l) => l.code == _langCode,
      orElse: () => supportedLanguages.first,
    );

    final IconData headerIcon;
    final Color headerColor;
    if (widget.isReviewMode) {
      final allMastered = percentInt == 100;
      headerIcon = allMastered ? Icons.verified_rounded : Icons.replay_rounded;
      headerColor = allMastered ? const Color(0xFF16A34A) : const Color(0xFFF59E0B);
    } else {
      headerIcon = _getResultIcon(percentage);
      headerColor = _getResultColor(context, percentage);
    }

    final String titleText;
    if (widget.isReviewMode) {
      titleText = percentInt == 100
          ? AppStrings.tr('review_all_mastered', _langCode)
          : AppStrings.tr('review_completed_title', _langCode);
    } else {
      titleText = AppStrings.tr('result_finished', _langCode);
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          widget.isReviewMode
              ? AppStrings.tr('review_completed_title', _langCode)
              : AppStrings.tr('result_title', _langCode),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            tooltip: AppStrings.tr('lang_selector_title', _langCode),
            initialValue: _langCode,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            onSelected: (code) {
              ProgressService().setLanguage(code);
              setState(() {});
            },
            itemBuilder: (context) => supportedLanguages.map((lang) {
              final isSelected = lang.code == _langCode;
              return PopupMenuItem<String>(
                value: lang.code,
                child: Row(
                  children: [
                    Text(lang.flag, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${lang.code} • ${lang.label}',
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 13.5,
                          color: isSelected
                              ? const Color(0xFF3B82F6)
                              : (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B)),
                        ),
                      ),
                    ),
                    if (isSelected) const Icon(Icons.check_rounded, size: 18, color: Color(0xFF3B82F6)),
                  ],
                ),
              );
            }).toList(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(langOption.flag, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    langOption.code,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    size: 18,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),

                  // Trophy / Result Icon Badge
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: headerColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        headerIcon,
                        size: 46,
                        color: headerColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    titleText,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),

                  // Score Card
                  Card(
                    elevation: 0,
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.tr('result_your_score', _langCode),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(langOption.flag, style: const TextStyle(fontSize: 12)),
                                    const SizedBox(width: 4),
                                    Text(
                                      langOption.code,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2563EB),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.tr(
                              'result_score_fraction',
                              _langCode,
                              {
                                'score': '${widget.score}',
                                'total': '${widget.totalQuestions}',
                              },
                            ),
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              AppStrings.tr(
                                'result_accuracy',
                                _langCode,
                                {'pct': '$percentInt'},
                              ),
                              style: const TextStyle(
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.bold,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                          Divider(height: 28, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          Text(
                            _getLocalizedEncouragement(percentage),
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                              height: 1.45,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Action Buttons Section
                  if (widget.isReviewMode) ...[
                    // Review Mode Flow
                    Builder(builder: (context) {
                      final remainingWrong = ProgressService().wrongIds;
                      if (remainingWrong.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FilledButton.icon(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizScreen(
                                      initialLangCode: _langCode,
                                      quizType: widget.quizType,
                                      category: widget.category,
                                      level: widget.level,
                                      reviewIds: remainingWrong,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.replay_rounded),
                              label: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  AppStrings.tr(
                                    'review_retry_remaining',
                                    _langCode,
                                    {'count': '${remainingWrong.length}'},
                                  ),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFEF4444),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            OutlinedButton.icon(
                              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                              icon: const Icon(Icons.home_rounded),
                              label: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  AppStrings.tr('result_home', _langCode),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E3A8B),
                                  ),
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                side: BorderSide(
                                  color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return FilledButton.icon(
                          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                          icon: const Icon(Icons.home_rounded),
                          label: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              AppStrings.tr('result_home', _langCode),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF16A34A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        );
                      }
                    }),
                  ] else ...[
                    // Normal Quiz Flow
                    // 1. If user missed questions in this session, show a prominent "Review Missed Questions Now" CTA!
                    if (widget.sessionWrongIds != null && widget.sessionWrongIds!.isNotEmpty) ...[
                      FilledButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                initialLangCode: _langCode,
                                quizType: widget.quizType,
                                category: widget.category,
                                level: widget.level,
                                reviewIds: widget.sessionWrongIds,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.local_fire_department_rounded),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            AppStrings.tr(
                              'review_now_button',
                              _langCode,
                              {'count': '${widget.sessionWrongIds!.length}'},
                            ),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    // 2. Play this category again
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              initialLangCode: _langCode,
                              quizType: widget.quizType,
                              category: widget.category,
                              level: widget.level,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.replay_rounded),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          AppStrings.tr('result_retry', _langCode),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: (widget.sessionWrongIds != null && widget.sessionWrongIds!.isNotEmpty)
                            ? (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))
                            : const Color(0xFF2563EB),
                        foregroundColor: (widget.sessionWrongIds != null && widget.sessionWrongIds!.isNotEmpty)
                            ? (isDark ? Colors.white : const Color(0xFF0F172A))
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 3. Return Home
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      icon: const Icon(Icons.home_rounded),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          AppStrings.tr('result_home', _langCode),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E3A8B),
                          ),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide(
                          color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          const BottomBannerAdWidget(fillSafeAreaWhenEmpty: true),
        ],
      ),
    );
  }
}
