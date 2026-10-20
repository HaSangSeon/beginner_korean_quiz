import 'package:flutter/material.dart';
import '../data/app_localization.dart';
import '../data/quiz_data.dart';
import '../services/ad_service.dart';
import '../services/progress_service.dart';
import '../services/quiz_repository.dart';
import '../services/tts_service.dart';
import 'quiz_screen.dart';

/// Emoji icon per quiz category (0-byte vector icons)
const Map<String, String> _categoryEmoji = {
  '능력·가능': '💪',
  '목적·이동': '🚶',
  '국적·소개': '🌏',
  '출신·인사': '✈️',
  '직업·소개': '💼',
  '장소·생활': '🏙️',
  '의류·잡화': '👕',
  '생활·사물': '🏠',
  '음식·음료': '🍎',
  '자연': '🌿',
  '신체·건강': '🩺',
  '교통·이동': '🚌',
  '식당·주문': '🍽️',
  '희망·의도': '✨',
  '요청·예절': '🙏',
  '이유·원인': '💡',
  '시간·일과': '⏰',
  '카페·테이크아웃': '☕',
  '편의점·서바이벌': '🏪',
  '카톡·SNS 뉘앙스': '📱',
  '배달·택시 실전': '🚕',
  '실전 에티켓·문화': '🥩',
  '쇼핑·결제': '🛍️',
  'K-리액션·감탄사': '✨',
  '길찾기·교통': '🚇',
  'K-컬처·팬문화': '🎤',
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static String _detectDefaultLanguage() {
    try {
      final code = WidgetsBinding.instance.platformDispatcher.locale.languageCode.toLowerCase();
      if (code.startsWith('vi')) return 'VI';
      if (code.startsWith('zh')) return 'ZH';
      if (code.startsWith('ja')) return 'JA';
      if (code.startsWith('es')) return 'ES';
      if (code.startsWith('pt')) return 'PT';
      if (code.startsWith('ko')) return 'KO';
      return 'EN'; // Default to English for other international users
    } catch (_) {
      return 'VI'; // Primary target fallback
    }
  }

  late String _selectedLangCode;
  String _selectedTrack = 'survival'; // Default to 'survival' (K-라이프 실전) for high immersion
  bool _isWordBookmarked = false;

  @override
  void initState() {
    super.initState();
    _selectedLangCode = _detectDefaultLanguage();
    QuizRepository.loadQuestions().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    TtsService().stop();
    super.dispose();
  }

  void _navigateToQuiz(
    BuildContext context, {
    String? category,
    String? quizType,
    List<int>? reviewIds,
    int? level,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          initialLangCode: _selectedLangCode,
          category: category,
          quizType: quizType ?? _selectedTrack,
          level: level,
          reviewIds: reviewIds,
        ),
      ),
    );
  }

  void _onCategoryCardTap(BuildContext context, String cat, String emoji, bool isDark) {
    final levels = QuizRepository.getLevelsByCategory(cat);
    if (levels.length <= 1) {
      _navigateToQuiz(
        context,
        category: cat,
        quizType: _selectedTrack,
        level: levels.firstOrNull ?? 1,
      );
      return;
    }
    _showLevelSelectionSheet(context, cat, emoji, isDark, levels);
  }

  void _showLevelSelectionSheet(
    BuildContext context,
    String category,
    String emoji,
    bool isDark,
    List<int> levels,
  ) {
    final progress = ProgressService();
    final localizedCat = AppStrings.category(category, _selectedLangCode);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.85,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: (isDark ? const Color(0xFF2563EB) : const Color(0xFF3B82F6))
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(emoji, style: const TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizedCat,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppStrings.tr('stage_modal_sub', _selectedLangCode),
                            style: TextStyle(
                              fontSize: 12.5,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                      onPressed: () => Navigator.pop(bottomSheetContext),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...levels.map((lvl) {
                  final ids = QuizRepository.getIdsByCategoryAndLevel(category, lvl);
                  final total = ids.length;
                  final learned = ids.where((id) => progress.isLearned(id)).length;
                  final isDone = total > 0 && learned == total;
                  final ratio = total > 0 ? (learned / total) : 0.0;
                  final stageTitle = lvl == 1
                      ? AppStrings.tr('stage_level_1', _selectedLangCode)
                      : AppStrings.tr('stage_level_2', _selectedLangCode);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDone
                            ? const Color(0xFF22C55E).withValues(alpha: 0.7)
                            : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                        width: isDone ? 1.5 : 1.0,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(bottomSheetContext);
                        _navigateToQuiz(
                          context,
                          category: category,
                          quizType: _selectedTrack,
                          level: lvl,
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (isDone
                                            ? const Color(0xFF22C55E)
                                            : (lvl == 1
                                                ? const Color(0xFF2563EB)
                                                : const Color(0xFFF97316)))
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'STEP $lvl',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: isDone
                                          ? const Color(0xFF22C55E)
                                          : (lvl == 1
                                              ? const Color(0xFF2563EB)
                                              : const Color(0xFFF97316)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    stageTitle,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                if (isDone)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.check_circle_rounded,
                                            size: 14, color: Color(0xFF22C55E)),
                                        const SizedBox(width: 4),
                                        Text(
                                          AppStrings.tr('stage_completed', _selectedLangCode),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF22C55E),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Text(
                                    '$learned / $total',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? const Color(0xFF94A3B8)
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: ratio,
                                minHeight: 6,
                                backgroundColor: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFE2E8F0),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isDone
                                      ? const Color(0xFF22C55E)
                                      : (lvl == 1
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFFF97316)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: ProgressService(),
      builder: (context, _) => Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        appBar: _buildCustomAppBar(context, isDark),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Greeting + Daily Goal / Streak / Learned stats
                    _buildDailyGoalCard(context, isDark),
                    const SizedBox(height: 18),

                    // 2. Track Switcher Segmented Control (📚 기초 어휘 vs 💬 실전 문장·뉘앙스)
                    _buildTrackSwitcherSection(context, isDark),
                    const SizedBox(height: 18),

                    // 3. Main Hero Card (Adapts to _selectedTrack)
                    _buildHeroQuizCard(context, isDark),
                    const SizedBox(height: 18),

                    // 4. Prominent [Start Quiz] CTA Button (Adapts to _selectedTrack)
                    _buildMainStartButton(context, isDark),
                    const SizedBox(height: 14),

                    // 5. Mistake Review (only when there are mistakes in this track)
                    _buildReviewCard(context, isDark),

                    // 6. Topic list with per-topic progress
                    _buildCategorySection(context, isDark),
                    const SizedBox(height: 22),

                    // 7. Word & Nuance of the Day
                    _buildWordOfTheDayCard(context, isDark),
                  ],
                ),
              ),
            ),
            const BottomBannerAdWidget(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(
    BuildContext context,
    bool isDark,
  ) {
    return AppBar(
      elevation: 0,
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.school_rounded,
              size: 20,
              color: Color(0xFF2563EB),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppStrings.tr('app_title', _selectedLangCode),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                letterSpacing: -0.3,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        _buildStreakChip(isDark),
        const SizedBox(width: 8),
        _buildThemeToggle(context, isDark),
        const SizedBox(width: 8),
        _buildLanguageMenu(isDark),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildThemeToggle(BuildContext context, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          ProgressService().toggleTheme(context);
        },
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : const Color(0xFF64748B))
                    .withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            size: 17,
            color: isDark ? const Color(0xFFFCD34D) : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakChip(bool isDark) {
    final progress = ProgressService();
    final active = progress.studiedToday;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active
            ? (isDark ? const Color(0xFF78350F).withValues(alpha: 0.45) : const Color(0xFFFFF7ED))
            : (isDark ? const Color(0xFF1E293B) : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active
              ? const Color(0xFFF97316).withValues(alpha: 0.6)
              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: active ? 1.0 : 0.45,
            child: const Text('🔥', style: TextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 4),
          Text(
            '${progress.streak}',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w900,
              color: active
                  ? const Color(0xFFF97316)
                  : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageMenu(bool isDark) {
    final currentLang = supportedLanguages.firstWhere(
      (l) => l.code == _selectedLangCode,
      orElse: () => supportedLanguages.first,
    );
    return PopupMenuButton<String>(
      tooltip: AppStrings.tr('lang_selector_title', _selectedLangCode),
      initialValue: _selectedLangCode,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      onSelected: (code) => setState(() => _selectedLangCode = code),
      itemBuilder: (context) => supportedLanguages.map((lang) {
        final isSelected = lang.code == _selectedLangCode;
        return PopupMenuItem<String>(
          value: lang.code,
          child: Row(
            children: [
              Text(lang.flag, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  lang.label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
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
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currentLang.flag, style: const TextStyle(fontSize: 15)),
            const SizedBox(width: 4),
            Text(
              currentLang.code,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyGoalCard(BuildContext context, bool isDark) {
    final progress = ProgressService();
    final xp = progress.xpToday;
    const goal = ProgressService.dailyGoalXp;
    final ratio = (xp / goal).clamp(0.0, 1.0);
    final done = progress.dailyGoalReached;
    final learned = progress.learnedIds.length;
    final total = QuizRepository.totalCount;
    const accent = Color(0xFF22C55E);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: isDark ? 0.18 : 0.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.tr('greeting_title', _selectedLangCode),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            AppStrings.tr('greeting_sub', _selectedLangCode),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Daily goal ring
              SizedBox(
                width: 58,
                height: 58,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: ratio),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) => SizedBox(
                        width: 58,
                        height: 58,
                        child: CircularProgressIndicator(
                          value: value,
                          strokeWidth: 6,
                          strokeCap: StrokeCap.round,
                          backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            done ? const Color(0xFFF59E0B) : accent,
                          ),
                        ),
                      ),
                    ),
                    Text(done ? '🏆' : '⚡', style: const TextStyle(fontSize: 22)),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      done
                          ? AppStrings.tr('daily_goal_done', _selectedLangCode)
                          : AppStrings.tr('daily_goal_title', _selectedLangCode),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$xp / $goal XP',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: done
                            ? const Color(0xFFF59E0B)
                            : (isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildMiniStat(
                  isDark: isDark,
                  emoji: '🔥',
                  value: AppStrings.tr('streak_days', _selectedLangCode, {'n': '${progress.streak}'}),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMiniStat(
                  isDark: isDark,
                  emoji: '✅',
                  value: '${AppStrings.tr('stat_learned', _selectedLangCode)} $learned/$total',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat({required bool isDark, required String emoji, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, bool isDark) {
    final trackQuestions = QuizRepository.getByType(_selectedTrack);
    final trackIds = trackQuestions.map((q) => q.id).toSet();
    final wrongForTrack = ProgressService().wrongIds.where((id) => trackIds.contains(id)).toList();

    if (wrongForTrack.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFFEF4444).withValues(alpha: 0.5) : const Color(0xFFFCA5A5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF7F1D1D).withValues(alpha: 0.5)
                  : const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text('🔄', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.tr('review_title', _selectedLangCode),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.tr('review_desc', _selectedLangCode, {'count': '${wrongForTrack.length}'}),
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () => _navigateToQuiz(context, reviewIds: wrongForTrack),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              AppStrings.tr('quiz_review_badge', _selectedLangCode),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, bool isDark) {
    final categories = QuizRepository.getCategoriesByType(_selectedTrack);
    final progress = ProgressService();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.grid_view_rounded, size: 18, color: Color(0xFF2563EB)),
            const SizedBox(width: 8),
            Text(
              AppStrings.tr('categories_header', _selectedLangCode),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        Builder(
          builder: (context) {
            final screenWidth = MediaQuery.sizeOf(context).width;
            final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
            final double dynamicAspectRatio = (screenWidth < 360 || textScale > 1.1) ? 1.24 : 1.35;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: dynamicAspectRatio,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
            final cat = categories[index];
            final catIds = QuizRepository.getIdsByCategory(cat);
            final total = catIds.length;
            final learned = catIds.where((id) => progress.isLearned(id)).length;
            final ratio = total > 0 ? (learned / total) : 0.0;
            final emoji = _categoryEmoji[cat] ?? '📌';
            final isComplete = learned == total && total > 0;
            final levels = QuizRepository.getLevelsByCategory(cat);
            final hasMultipleLevels = levels.length > 1;

            return Material(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                onTap: () => _onCategoryCardTap(context, cat, emoji, isDark),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isComplete
                          ? const Color(0xFF22C55E).withValues(alpha: 0.6)
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      width: isComplete ? 1.5 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(emoji, style: const TextStyle(fontSize: 22)),
                              if (hasMultipleLevels) ...[
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: (isDark ? const Color(0xFF2563EB) : const Color(0xFF3B82F6))
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Lv 1~${levels.last}',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (isComplete)
                            const Icon(Icons.check_circle_rounded, size: 18, color: Color(0xFF22C55E))
                          else
                            Text(
                              '$learned/$total',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.category(cat, _selectedLangCode),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: ratio,
                              minHeight: 4.5,
                              backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isComplete ? const Color(0xFF22C55E) : const Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              );
            },
          );
        },
      ),
    ],
  );
  }

  Widget _buildTrackSwitcherSection(BuildContext context, bool isDark) {
    final wordCount = QuizRepository.getCountByType('word');
    final sentenceCount = QuizRepository.getCountByType('sentence');
    final survivalCount = QuizRepository.getCountByType('survival');

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFF64748B))
                .withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Track 1: K-라이프 실전 (K-Life & Survival)
          Expanded(
            child: _buildTrackTabButton(
              isDark: isDark,
              isSelected: _selectedTrack == 'survival',
              emoji: '🇰🇷',
              label: AppStrings.tr('track_tab_survival', _selectedLangCode),
              badge: '$survivalCount',
              activeColor: const Color(0xFFEA580C), // Orange 600
              onTap: () {
                if (_selectedTrack != 'survival') {
                  setState(() => _selectedTrack = 'survival');
                }
              },
            ),
          ),
          const SizedBox(width: 5),
          // Track 2: 실전 문장·뉘앙스 (Sentences & Nuances)
          Expanded(
            child: _buildTrackTabButton(
              isDark: isDark,
              isSelected: _selectedTrack == 'sentence',
              emoji: '💬',
              label: AppStrings.tr('track_tab_sentence', _selectedLangCode),
              badge: '$sentenceCount',
              activeColor: const Color(0xFF2563EB), // Blue 600
              onTap: () {
                if (_selectedTrack != 'sentence') {
                  setState(() => _selectedTrack = 'sentence');
                }
              },
            ),
          ),
          const SizedBox(width: 5),
          // Track 3: 기초 어휘 (Vocabulary)
          Expanded(
            child: _buildTrackTabButton(
              isDark: isDark,
              isSelected: _selectedTrack == 'word',
              emoji: '📚',
              label: AppStrings.tr('track_tab_vocab', _selectedLangCode),
              badge: '$wordCount',
              activeColor: const Color(0xFF0D9488), // Teal 600
              onTap: () {
                if (_selectedTrack != 'word') {
                  setState(() => _selectedTrack = 'word');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackTabButton({
    required bool isDark,
    required bool isSelected,
    required String emoji,
    required String label,
    required String badge,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? activeColor.withValues(alpha: 0.25) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: isSelected
                ? Border.all(
                    color: isDark ? activeColor : activeColor.withValues(alpha: 0.6),
                    width: 1.5,
                  )
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: (isDark ? Colors.black : activeColor)
                          .withValues(alpha: isDark ? 0.3 : 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Row: Emoji + Count Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? activeColor : activeColor.withValues(alpha: 0.15))
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: isSelected
                            ? (isDark ? Colors.white : activeColor)
                            : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3.5),
              // Bottom Label: Full width, clean, legible without truncation
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    letterSpacing: -0.3,
                    color: isSelected
                        ? (isDark ? Colors.white : const Color(0xFF0F172A))
                        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroQuizCard(BuildContext context, bool isDark) {
    final isWordTrack = _selectedTrack == 'word';
    final isSurvivalTrack = _selectedTrack == 'survival';
    final currentLangLabel = supportedLanguages
        .firstWhere(
          (l) => l.code == _selectedLangCode,
          orElse: () => supportedLanguages.first,
        )
        .label;

    final gradientColors = isWordTrack
        ? const [
            Color(0xFF064E3B), // Emerald 900
            Color(0xFF0F766E), // Teal 700
            Color(0xFF0369A1), // Sky 700
          ]
        : (isSurvivalTrack
            ? const [
                Color(0xFF431407), // Amber 950
                Color(0xFFC2410C), // Orange 700
                Color(0xFF7E22CE), // Purple 700
              ]
            : const [
                Color(0xFF0F172A), // Slate 900
                Color(0xFF1E3A8A), // Indigo 900
                Color(0xFF1D4ED8), // Blue 700
              ]);

    final watermarkText = isWordTrack
        ? '단어'
        : (isSurvivalTrack ? 'K-생존' : '대화');
    final heroBadgeText = isWordTrack
        ? AppStrings.tr('hero_vocab_badge', _selectedLangCode)
        : (isSurvivalTrack
            ? AppStrings.tr('hero_survival_badge', _selectedLangCode)
            : AppStrings.tr('hero_badge', _selectedLangCode));
    final heroTitleText = isWordTrack
        ? AppStrings.tr('hero_vocab_title', _selectedLangCode)
        : (isSurvivalTrack
            ? AppStrings.tr('hero_survival_title', _selectedLangCode)
            : AppStrings.tr('hero_title', _selectedLangCode));
    final heroDescText = isWordTrack
        ? AppStrings.tr('hero_vocab_desc', _selectedLangCode)
        : (isSurvivalTrack
            ? AppStrings.tr('hero_survival_desc', _selectedLangCode)
            : AppStrings.tr('hero_desc', _selectedLangCode));

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: (isWordTrack ? const Color(0xFF0F766E) : const Color(0xFF1E3A8A))
                .withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -15,
            child: Opacity(
              opacity: 0.08,
              child: Text(
                watermarkText,
                style: const TextStyle(
                  fontSize: 130,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontFamily: 'serif',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.translate_rounded,
                              size: 14,
                              color: Color(0xFFFDE047),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'ACTIVE: $currentLangLabel',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isWordTrack
                            ? AppStrings.tr('track_label_word', _selectedLangCode)
                            : AppStrings.tr('track_label_sentence', _selectedLangCode),
                        style: const TextStyle(
                          color: Color(0xFF93C5FD),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Hero Badge
                Text(
                  heroBadgeText,
                  style: const TextStyle(
                    color: Color(0xFFFDE047),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 6),

                // Main Title
                Text(
                  heroTitleText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    height: 1.22,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),

                // Subtitle
                Text(
                  heroDescText,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),

                // Category Chips (Tap to start category quiz)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: isWordTrack
                      ? [
                          _buildPillTag(
                            icon: Icons.checkroom_rounded,
                            label: AppStrings.category('의류·잡화', _selectedLangCode),
                            bgColor: Colors.white.withValues(alpha: 0.15),
                            onTap: () => _onCategoryCardTap(context, '의류·잡화', _categoryEmoji['의류·잡화'] ?? '👕', isDark),
                          ),
                          _buildPillTag(
                            icon: Icons.home_rounded,
                            label: AppStrings.category('생활·사물', _selectedLangCode),
                            bgColor: Colors.white.withValues(alpha: 0.15),
                            onTap: () => _onCategoryCardTap(context, '생활·사물', _categoryEmoji['생활·사물'] ?? '🏠', isDark),
                          ),
                          _buildPillTag(
                            icon: Icons.restaurant_rounded,
                            label: AppStrings.category('음식·음료', _selectedLangCode),
                            bgColor: Colors.white.withValues(alpha: 0.15),
                            onTap: () => _onCategoryCardTap(context, '음식·음료', _categoryEmoji['음식·음료'] ?? '🍎', isDark),
                          ),
                          _buildPillTag(
                            icon: Icons.park_rounded,
                            label: AppStrings.category('자연', _selectedLangCode),
                            bgColor: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                            iconColor: const Color(0xFFFDE047),
                            onTap: () => _onCategoryCardTap(context, '자연', _categoryEmoji['자연'] ?? '🌿', isDark),
                          ),
                        ]
                      : (isSurvivalTrack
                          ? [
                              _buildPillTag(
                                icon: Icons.coffee_rounded,
                                label: AppStrings.category('카페·테이크아웃', _selectedLangCode),
                                bgColor: Colors.white.withValues(alpha: 0.15),
                                onTap: () => _onCategoryCardTap(context, '카페·테이크아웃', _categoryEmoji['카페·테이크아웃'] ?? '☕', isDark),
                              ),
                              _buildPillTag(
                                icon: Icons.shopping_bag_rounded,
                                label: AppStrings.category('쇼핑·결제', _selectedLangCode),
                                bgColor: Colors.white.withValues(alpha: 0.15),
                                onTap: () => _onCategoryCardTap(context, '쇼핑·결제', _categoryEmoji['쇼핑·결제'] ?? '🛍️', isDark),
                              ),
                              _buildPillTag(
                                icon: Icons.auto_awesome_rounded,
                                label: AppStrings.category('K-리액션·감탄사', _selectedLangCode),
                                bgColor: Colors.white.withValues(alpha: 0.15),
                                onTap: () => _onCategoryCardTap(context, 'K-리액션·감탄사', _categoryEmoji['K-리액션·감탄사'] ?? '✨', isDark),
                              ),
                              _buildPillTag(
                                icon: Icons.subway_rounded,
                                label: AppStrings.category('길찾기·교통', _selectedLangCode),
                                bgColor: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                                iconColor: const Color(0xFFFDE047),
                                onTap: () => _onCategoryCardTap(context, '길찾기·교통', _categoryEmoji['길찾기·교통'] ?? '🚇', isDark),
                              ),
                            ]
                          : [
                              _buildPillTag(
                                icon: Icons.public_rounded,
                                label: AppStrings.category('국적·소개', _selectedLangCode),
                                bgColor: Colors.white.withValues(alpha: 0.15),
                                onTap: () => _onCategoryCardTap(context, '국적·소개', _categoryEmoji['국적·소개'] ?? '🌏', isDark),
                              ),
                              _buildPillTag(
                                icon: Icons.badge_rounded,
                                label: AppStrings.category('직업·소개', _selectedLangCode),
                                bgColor: Colors.white.withValues(alpha: 0.15),
                                onTap: () => _onCategoryCardTap(context, '직업·소개', _categoryEmoji['직업·소개'] ?? '💼', isDark),
                              ),
                              _buildPillTag(
                                icon: Icons.place_rounded,
                                label: AppStrings.category('장소·생활', _selectedLangCode),
                                bgColor: Colors.white.withValues(alpha: 0.15),
                                onTap: () => _onCategoryCardTap(context, '장소·생활', _categoryEmoji['장소·생활'] ?? '🏙️', isDark),
                              ),
                              _buildPillTag(
                                icon: Icons.flash_on_rounded,
                                label: AppStrings.category('능력·가능', _selectedLangCode),
                                bgColor: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                                iconColor: const Color(0xFFFDE047),
                                onTap: () => _onCategoryCardTap(context, '능력·가능', _categoryEmoji['능력·가능'] ?? '💪', isDark),
                              ),
                            ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillTag({
    required IconData icon,
    required String label,
    required Color bgColor,
    Color iconColor = Colors.white,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 3),
              const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainStartButton(BuildContext context, bool isDark) {
    final isWordTrack = _selectedTrack == 'word';
    final isSurvivalTrack = _selectedTrack == 'survival';
    final buttonGradient = isWordTrack
        ? const LinearGradient(
            colors: [
              Color(0xFF0D9488), // Teal 600
              Color(0xFF0F766E), // Teal 700
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : (isSurvivalTrack
            ? const LinearGradient(
                colors: [
                  Color(0xFFEA580C), // Orange 600
                  Color(0xFFC2410C), // Orange 700
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [
                  Color(0xFF2563EB), // Blue 600
                  Color(0xFF1D4ED8), // Blue 700
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ));

    final trackCount = QuizRepository.getCountByType(_selectedTrack);
    final buttonSub = isWordTrack
        ? AppStrings.tr('btn_sub_vocab', _selectedLangCode, {'count': '$trackCount'})
        : (isSurvivalTrack
            ? AppStrings.tr('btn_sub_survival', _selectedLangCode, {'count': '$trackCount'})
            : AppStrings.tr('btn_sub_sentence', _selectedLangCode, {'count': '$trackCount'}));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: (isWordTrack
                    ? const Color(0xFF0D9488)
                    : (isSurvivalTrack ? const Color(0xFFEA580C) : const Color(0xFF2563EB)))
                .withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: buttonGradient,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: InkWell(
            onTap: () => _navigateToQuiz(context, quizType: _selectedTrack),
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: isWordTrack
                          ? const Color(0xFF0F766E)
                          : (isSurvivalTrack ? const Color(0xFFC2410C) : const Color(0xFF1D4ED8)),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.tr('start_quiz_btn', _selectedLangCode),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          buttonSub,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildWordOfTheDayCard(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lightbulb_outline_rounded, size: 15, color: Color(0xFF2563EB)),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          AppStrings.tr('wotd_badge', _selectedLangCode),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2563EB),
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  _isWordBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: _isWordBookmarked ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    _isWordBookmarked = !_isWordBookmarked;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppStrings.tr(
                          _isWordBookmarked ? 'wotd_bookmarked' : 'wotd_unbookmarked',
                          _selectedLangCode,
                        ),
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),

          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            children: [
              Text(
                '괜찮습니다',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '[gwaen-chan-seum-ni-da]',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF92400E),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    TtsService().speak('괜찮습니다');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppStrings.tr('wotd_listen_toast', _selectedLangCode),
                        ),
                        duration: const Duration(milliseconds: 900),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.volume_up_rounded,
                          size: 15,
                          color: Color(0xFF2563EB),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppStrings.tr('wotd_listen', _selectedLangCode),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          Text(
            AppStrings.tr('wotd_meaning', _selectedLangCode),
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2563EB),
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡 ', style: TextStyle(fontSize: 14)),
                Expanded(
                  child: Text(
                    AppStrings.tr('wotd_tip', _selectedLangCode),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E293B),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
