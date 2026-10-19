import 'package:flutter/material.dart';
import '../data/app_localization.dart';
import '../data/quiz_data.dart';
import '../services/quiz_repository.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLangCode = 'KO';
  bool _isWordBookmarked = false;

  @override
  void initState() {
    super.initState();
    QuizRepository.loadQuestions().then((_) {
      if (mounted) setState(() {});
    });
  }

  void _navigateToQuiz(BuildContext context, {String? category}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          initialLangCode: _selectedLangCode,
          category: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalQuestions = QuizRepository.totalCount;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: _buildCustomAppBar(context, isDark, totalQuestions),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. User Greeting Section
                    _buildUserGreetingSection(context, isDark),
                    const SizedBox(height: 16),

                    // 2. Language Selector Bar (7 Languages)
                    _buildLanguageSelectorSection(context, isDark),
                    const SizedBox(height: 18),

                    // 3. Main Hero Card (Interactive Category Tags)
                    _buildHeroQuizCard(context, isDark),
                    const SizedBox(height: 18),

                    // 4. Prominent [Start Quiz] CTA Button
                    _buildMainStartButton(context, totalQuestions),
                    const SizedBox(height: 22),

                    // 5. Dynamic Stats Row (Synced with Real Question Count)
                    _buildStatsRow(context, isDark, totalQuestions),
                    const SizedBox(height: 24),

                    // 6. Word & Nuance of the Day
                    _buildWordOfTheDayCard(context, isDark),
                    const SizedBox(height: 24),

                    // 7. Core Nuance Modules (Each taps to that category quiz)
                    _buildTopicsSection(context, isDark),
                    const SizedBox(height: 24),

                    // 8. Certified Instructor Trust Banner
                    _buildInstructorTrustBanner(context, isDark),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // 9. AdMob Banner Placeholder
            _buildAdMobBanner(context, isDark),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(
    BuildContext context,
    bool isDark,
    int totalQuestions,
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
          Text(
            AppStrings.tr('app_title', _selectedLangCode),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF1E3A8A),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
      actions: [
        // Real-time loaded questions badge (clean & informative)
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.quiz_rounded, size: 14, color: Color(0xFF2563EB)),
              const SizedBox(width: 5),
              Text(
                '$totalQuestions Qs',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserGreetingSection(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.tr('greeting_title', _selectedLangCode),
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                AppStrings.tr('greeting_sub', _selectedLangCode),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_rounded, size: 15, color: Color(0xFF2563EB)),
              const SizedBox(width: 4),
              Text(
                AppStrings.tr('greeting_badge', _selectedLangCode),
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
    );
  }

  Widget _buildLanguageSelectorSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.language_rounded, size: 16, color: Color(0xFF2563EB)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                AppStrings.tr('lang_selector_title', _selectedLangCode),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: supportedLanguages.map((lang) {
              final isSelected = lang.code == _selectedLangCode;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  showCheckmark: false,
                  avatar: Text(lang.flag, style: const TextStyle(fontSize: 15)),
                  label: Text(
                    '${lang.code} • ${lang.label}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155)),
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: const Color(0xFF2563EB),
                  backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF2563EB)
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedLangCode = lang.code;
                      });
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroQuizCard(BuildContext context, bool isDark) {
    final currentLangLabel = supportedLanguages
        .firstWhere(
          (l) => l.code == _selectedLangCode,
          orElse: () => supportedLanguages.first,
        )
        .label;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F172A), // Slate 900
            Color(0xFF1E3A8A), // Indigo 900
            Color(0xFF1D4ED8), // Blue 700
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.35),
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
              child: const Text(
                '실전',
                style: TextStyle(
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
                      child: const Text(
                        'TOPIK & Daily',
                        style: TextStyle(
                          color: Color(0xFF93C5FD),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Main Title
                Text(
                  AppStrings.tr('hero_title', _selectedLangCode),
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
                  AppStrings.tr('hero_desc', _selectedLangCode),
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
                  children: [
                    _buildPillTag(
                      icon: Icons.record_voice_over_rounded,
                      label: AppStrings.category('Honorifics', _selectedLangCode),
                      bgColor: Colors.white.withValues(alpha: 0.15),
                      onTap: () => _navigateToQuiz(context, category: 'Honorifics'),
                    ),
                    _buildPillTag(
                      icon: Icons.tune_rounded,
                      label: AppStrings.category('Particles', _selectedLangCode),
                      bgColor: Colors.white.withValues(alpha: 0.15),
                      onTap: () => _navigateToQuiz(context, category: 'Particles'),
                    ),
                    _buildPillTag(
                      icon: Icons.storefront_rounded,
                      label: AppStrings.category('Real-life', _selectedLangCode),
                      bgColor: Colors.white.withValues(alpha: 0.15),
                      onTap: () => _navigateToQuiz(context, category: 'Real-life'),
                    ),
                    _buildPillTag(
                      icon: Icons.lightbulb_rounded,
                      label: AppStrings.category('Nuances', _selectedLangCode),
                      bgColor: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                      iconColor: const Color(0xFFFDE047),
                      onTap: () => _navigateToQuiz(context, category: 'Nuances'),
                    ),
                  ],
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
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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

  Widget _buildMainStartButton(BuildContext context, int totalQuestions) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF2563EB), // Blue 600
                Color(0xFF1D4ED8), // Blue 700
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFF60A5FA).withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: InkWell(
            onTap: () => _navigateToQuiz(context),
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
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Color(0xFF1D4ED8),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
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

  Widget _buildStatsRow(BuildContext context, bool isDark, int totalQuestions) {
    return Row(
      children: [
        // 1. Difficulty Level
        Expanded(
          child: _buildSingleStatCard(
            context: context,
            isDark: isDark,
            icon: Icons.psychology_outlined,
            iconColor: const Color(0xFF10B981),
            iconBg: const Color(0xFFD1FAE5),
            label: AppStrings.tr('stat_level_label', _selectedLangCode),
            value: AppStrings.tr('stat_level_val', _selectedLangCode),
            onTap: () => _navigateToQuiz(context),
          ),
        ),
        const SizedBox(width: 10),

        // 2. Questions Count (Dynamically bound to totalQuestions)
        Expanded(
          child: _buildSingleStatCard(
            context: context,
            isDark: isDark,
            icon: Icons.fact_check_outlined,
            iconColor: const Color(0xFFF59E0B),
            iconBg: const Color(0xFFFEF3C7),
            label: AppStrings.tr('stat_questions_label', _selectedLangCode),
            value: AppStrings.tr(
              'stat_questions_val',
              _selectedLangCode,
              {'count': totalQuestions.toString()},
            ),
            onTap: () => _navigateToQuiz(context),
          ),
        ),
        const SizedBox(width: 10),

        // 3. Current Selected Language Code
        Expanded(
          child: _buildSingleStatCard(
            context: context,
            isDark: isDark,
            icon: Icons.translate_rounded,
            iconColor: const Color(0xFF3B82F6),
            iconBg: const Color(0xFFDBEAFE),
            label: AppStrings.tr('stat_lang_label', _selectedLangCode),
            value: _selectedLangCode,
            onTap: null,
          ),
        ),
      ],
    );
  }

  Widget _buildSingleStatCard({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return Material(
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF64748B).withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ],
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
              Container(
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
                    Text(
                      AppStrings.tr('wotd_badge', _selectedLangCode),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2563EB),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
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

  Widget _buildTopicsSection(BuildContext context, bool isDark) {
    final topics = [
      {
        'category': 'Honorifics',
        'emoji': '👔',
        'title': AppStrings.category('Honorifics', _selectedLangCode),
        'sub': '식사하셨어요? vs 밥 먹었어요?',
        'badge': AppStrings.category('Honorifics', _selectedLangCode),
        'color': const Color(0xFFEFF6FF),
        'borderColor': const Color(0xFFBFDBFE),
      },
      {
        'category': 'Particles',
        'emoji': '🧩',
        'title': AppStrings.category('Particles', _selectedLangCode),
        'sub': '은/는 vs 이/가',
        'badge': AppStrings.category('Grammar', _selectedLangCode),
        'color': const Color(0xFFF0FDF4),
        'borderColor': const Color(0xFFBBF7D0),
      },
      {
        'category': 'Real-life',
        'emoji': '🍲',
        'title': AppStrings.category('Real-life', _selectedLangCode),
        'sub': '저기요! vs 이모!',
        'badge': AppStrings.category('Practical', _selectedLangCode),
        'color': const Color(0xFFFFFBEB),
        'borderColor': const Color(0xFFFDE68A),
      },
      {
        'category': 'Nuances',
        'emoji': '💬',
        'title': AppStrings.category('Nuances', _selectedLangCode),
        'sub': '괜찮습니다 vs 싫어요',
        'badge': AppStrings.category('Nuances', _selectedLangCode),
        'color': const Color(0xFFFAF5FF),
        'borderColor': const Color(0xFFE9D5FF),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                AppStrings.tr('topics_header', _selectedLangCode),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _navigateToQuiz(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                AppStrings.tr('topics_cta', _selectedLangCode),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...topics.map((t) {
          final cat = t['category'] as String;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Material(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: () => _navigateToQuiz(context, category: cat),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
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
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: t['color'] as Color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: t['borderColor'] as Color),
                        ),
                        child: Text(
                          t['emoji'] as String,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    t['title'] as String,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (t['color'] as Color),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    t['badge'] as String,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF475569),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              t['sub'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF94A3B8),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInstructorTrustBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.tr('trust_banner_title', _selectedLangCode),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.tr('trust_banner_desc', _selectedLangCode),
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF334155),
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdMobBanner(BuildContext context, bool isDark) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.ad_units_rounded,
            size: 16,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              'AdMob Banner Ad (320x50)',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
