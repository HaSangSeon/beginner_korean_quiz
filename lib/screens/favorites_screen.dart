import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/quiz_question.dart';
import '../services/progress_service.dart';
import '../services/quiz_repository.dart';
import '../services/tts_service.dart';
import '../data/app_localization.dart';
import '../data/quiz_data.dart';

/// Metadata helper for the 3 main tracks (K-Life, Sentence, Word).
class _TrackMeta {
  final String key;
  final String emoji;
  final String labelKey;
  final Color lightColor;
  final Color darkColor;
  final Color lightBg;
  final Color darkBg;
  final Color lightBorder;
  final Color darkBorder;

  const _TrackMeta({
    required this.key,
    required this.emoji,
    required this.labelKey,
    required this.lightColor,
    required this.darkColor,
    required this.lightBg,
    required this.darkBg,
    required this.lightBorder,
    required this.darkBorder,
  });
}

_TrackMeta _getTrackMeta(String type) {
  switch (type.toLowerCase()) {
    case 'survival':
      return const _TrackMeta(
        key: 'survival',
        emoji: '🇰🇷',
        labelKey: 'track_tab_survival',
        lightColor: Color(0xFFC2410C), // Orange 700
        darkColor: Color(0xFFFB923C),  // Orange 400
        lightBg: Color(0xFFFFF7ED),    // Orange 50
        darkBg: Color(0xFF431407),     // Orange 950
        lightBorder: Color(0xFFFDBA74),// Orange 300
        darkBorder: Color(0xFF9A3412), // Orange 800
      );
    case 'word':
      return const _TrackMeta(
        key: 'word',
        emoji: '📚',
        labelKey: 'track_tab_vocab',
        lightColor: Color(0xFF0F766E), // Teal 700
        darkColor: Color(0xFF2DD4BF),  // Teal 400
        lightBg: Color(0xFFF0FDFA),    // Teal 50
        darkBg: Color(0xFF134E4A),     // Teal 900
        lightBorder: Color(0xFF99F6E4),// Teal 200
        darkBorder: Color(0xFF115E59), // Teal 800
      );
    case 'sentence':
    default:
      return const _TrackMeta(
        key: 'sentence',
        emoji: '💬',
        labelKey: 'track_tab_sentence',
        lightColor: Color(0xFF1D4ED8), // Blue 700
        darkColor: Color(0xFF60A5FA),  // Blue 400
        lightBg: Color(0xFFEFF6FF),    // Blue 50
        darkBg: Color(0xFF1E3A8A),     // Blue 900
        lightBorder: Color(0xFFBFDBFE),// Blue 200
        darkBorder: Color(0xFF1E40AF), // Blue 800
      );
  }
}

/// Refined, elegant screen displaying user-curated bookmarked/favorited expressions.
/// Acts as a personal vocabulary handbook with 3 distinct track badges,
/// integrated TTS pronunciation, and clean harmonious typography.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Filter by track: 'all', 'survival', 'sentence', 'word'
  String _selectedTrack = 'all';

  String get _langCode => ProgressService().language;

  static final RegExp _blankPattern = RegExp(r'\(\s*\)|_{3,}');

  String _cleanTtsText(QuizQuestion q) {
    final raw = q.getQuestion('KO');
    final answer = q.options[q.answerIndex];
    if (_blankPattern.hasMatch(raw)) {
      return raw.replaceFirst(_blankPattern, answer).replaceAll(RegExp(r'^[ABab]\s*[:：]\s*'), '');
    }
    return answer;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = ProgressService();

    return ListenableBuilder(
      listenable: progress,
      builder: (context, _) {
        final favoriteIds = progress.favoriteIds.toList();
        final questions = favoriteIds
            .map((id) => QuizRepository.getById(id))
            .whereType<QuizQuestion>()
            .toList();

        // Calculate count per track
        final survivalCount = questions.where((q) => q.type.toLowerCase() == 'survival').length;
        final sentenceCount = questions.where((q) => q.type.toLowerCase() == 'sentence').length;
        final wordCount = questions.where((q) => q.type.toLowerCase() == 'word').length;

        // Filter list by selected track
        final filteredQuestions = _selectedTrack == 'all'
            ? questions
            : questions.where((q) => q.type.toLowerCase() == _selectedTrack).toList();

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: false,
            titleSpacing: 0,
            toolbarHeight: 60,
            leadingWidth: 58,
            leading: Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
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
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⭐', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    AppStrings.tr('favorites_title', _langCode),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              _buildLanguageMenu(isDark),
              if (favoriteIds.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF78350F).withValues(alpha: 0.5)
                        : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(
                      color: isDark ? const Color(0xFFF59E0B) : const Color(0xFFFCD34D),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark ? Colors.black : const Color(0xFF64748B))
                            .withValues(alpha: isDark ? 0.3 : 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 1.5),
                      ),
                    ],
                  ),
                  child: Text(
                    '${favoriteIds.length}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 16),
            ],
          ),
          body: questions.isEmpty
              ? _buildEmptyState(context, isDark)
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // 1. 3 Main Categories (Tracks) Filter Tabs
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 12),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              _buildTrackTab(
                                label: AppStrings.tr('favorites_filter_all', _langCode),
                                emoji: '✨',
                                count: questions.length,
                                isSelected: _selectedTrack == 'all',
                                isDark: isDark,
                                activeColor: const Color(0xFFF59E0B),
                                onTap: () => setState(() => _selectedTrack = 'all'),
                              ),
                              const SizedBox(width: 8),
                              _buildTrackTab(
                                label: AppStrings.tr('track_tab_survival', _langCode),
                                emoji: '🇰🇷',
                                count: survivalCount,
                                isSelected: _selectedTrack == 'survival',
                                isDark: isDark,
                                activeColor: const Color(0xFFEA580C),
                                onTap: () => setState(() => _selectedTrack = 'survival'),
                              ),
                              const SizedBox(width: 8),
                              _buildTrackTab(
                                label: AppStrings.tr('track_tab_sentence', _langCode),
                                emoji: '💬',
                                count: sentenceCount,
                                isSelected: _selectedTrack == 'sentence',
                                isDark: isDark,
                                activeColor: const Color(0xFF2563EB),
                                onTap: () => setState(() => _selectedTrack = 'sentence'),
                              ),
                              const SizedBox(width: 8),
                              _buildTrackTab(
                                label: AppStrings.tr('track_tab_vocab', _langCode),
                                emoji: '📚',
                                count: wordCount,
                                isSelected: _selectedTrack == 'word',
                                isDark: isDark,
                                activeColor: const Color(0xFF0D9488),
                                onTap: () => setState(() => _selectedTrack = 'word'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 2. Question Cards List
                    if (filteredQuestions.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Center(
                            child: Text(
                              AppStrings.tr('favorites_empty_desc', _langCode),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.5,
                                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 36),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final q = filteredQuestions[index];
                              return _buildQuestionCard(context, q, isDark);
                            },
                            childCount: filteredQuestions.length,
                          ),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildLanguageMenu(bool isDark) {
    final currentLang = supportedLanguages.firstWhere(
      (l) => l.code == _langCode,
      orElse: () => supportedLanguages.first,
    );
    return PopupMenuButton<String>(
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
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : const Color(0xFF64748B))
                  .withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1.5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currentLang.flag, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              currentLang.code,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 15,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFFEF3C7),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFFDE68A),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.2 : 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                child: Text('⭐', style: TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              AppStrings.tr('favorites_empty_title', _langCode),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19.5,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppStrings.tr('favorites_empty_desc', _langCode),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: Text(
                AppStrings.tr('result_home', _langCode),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackTab({
    required String label,
    required String emoji,
    required int count,
    required bool isSelected,
    required bool isDark,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? activeColor.withValues(alpha: 0.25) : activeColor.withValues(alpha: 0.12))
                : (isDark ? const Color(0xFF1E293B) : Colors.white),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? activeColor
                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: isSelected ? 1.4 : 1.1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: activeColor.withValues(alpha: isDark ? 0.3 : 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? (isDark ? Colors.white : activeColor)
                      : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: isSelected
                      ? activeColor
                      : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: isSelected
                        ? Colors.white
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

  Widget _buildQuestionCard(BuildContext context, QuizQuestion q, bool isDark) {
    final progress = ProgressService();
    final isFav = progress.isFavorite(q.id);
    final correctAnswer = q.options[q.answerIndex];
    final ttsText = _cleanTtsText(q);
    final trackMeta = _getTrackMeta(q.type);

    // Question dialogue or text
    final rawQuestion = q.getQuestion('KO');
    final explanation = q.getExplanation(_langCode);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFF64748B))
                .withValues(alpha: isDark ? 0.35 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Top Badges Row: [3대 대분류 트랙 뱃지] + [소주제 칩] + [#ID] + [⭐ 북마크 토글]
            Row(
              children: [
                // A. 3대 대분류 카테고리 뱃지 (K-라이프 / 생활 대화 / 기초 단어)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.5, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? trackMeta.darkBg.withValues(alpha: 0.6) : trackMeta.lightBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? trackMeta.darkBorder : trackMeta.lightBorder,
                      width: 1.1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(trackMeta.emoji, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        AppStrings.tr(trackMeta.labelKey, _langCode),
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: isDark ? trackMeta.darkColor : trackMeta.lightColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),

                // B. 소주제 뱃지
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.5, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      AppStrings.category(q.category, _langCode),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                Text(
                  '#${q.id}',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                ),

                const Spacer(),

                // C. Bookmark Star Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      progress.toggleFavorite(q.id);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppStrings.tr('favorites_removed_toast', _langCode),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        isFav ? Icons.star_rounded : Icons.star_border_rounded,
                        color: const Color(0xFFF59E0B),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2. Korean Question Text (100% Korean Rule, Clean & Readable)
            Text(
              rawQuestion,
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                height: 1.48,
                letterSpacing: -0.3,
                color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            // 3. Integrated Answer & Pronunciation TTS Row (Aligned & Polished)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF064E3B).withValues(alpha: 0.35)
                    : const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFF059669).withValues(alpha: 0.45) : const Color(0xFFBBF7D0),
                  width: 1.1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 19,
                    color: isDark ? const Color(0xFF34D399) : const Color(0xFF16A34A),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.25,
                          color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D),
                        ),
                        children: [
                          TextSpan(
                            text: '${AppStrings.tr('quiz_correct_answer_label', _langCode)} ',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: correctAnswer,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF14532D),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Dedicated Native Pronunciation Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        TtsService().speak(ttsText);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF059669).withValues(alpha: 0.5)
                                : const Color(0xFF86EFAC),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.2 : 0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.volume_up_rounded,
                              size: 15,
                              color: Color(0xFF16A34A),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'TTS',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 4. Localized Explanation Card (Nuance Guide)
            if (explanation.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A).withValues(alpha: 0.6) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 1.0),
                      child: Text('💡', style: TextStyle(fontSize: 13)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        explanation,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.48,
                          fontWeight: FontWeight.w500,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
