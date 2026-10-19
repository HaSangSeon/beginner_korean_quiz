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
  String _selectedTrack = 'word'; // 'word' (기초 어휘) or 'sentence' (실전 문장·뉘앙스)
  bool _isWordBookmarked = false;

  @override
  void initState() {
    super.initState();
    QuizRepository.loadQuestions().then((_) {
      if (mounted) setState(() {});
    });
  }

  void _navigateToQuiz(BuildContext context, {String? category, String? quizType}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          initialLangCode: _selectedLangCode,
          category: category,
          quizType: quizType ?? _selectedTrack,
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

                    // 2. Language Selector Bar (5 Languages)
                    _buildLanguageSelectorSection(context, isDark),
                    const SizedBox(height: 16),

                    // 3. Track Switcher Segmented Control (📚 기초 어휘 vs 💬 실전 문장·뉘앙스)
                    _buildTrackSwitcherSection(context, isDark),
                    const SizedBox(height: 18),

                    // 4. Main Hero Card (Adapts to _selectedTrack)
                    _buildHeroQuizCard(context, isDark),
                    const SizedBox(height: 18),

                    // 5. Prominent [Start Quiz] CTA Button (Adapts to _selectedTrack)
                    _buildMainStartButton(context, isDark),
                    const SizedBox(height: 22),

                    // 6. Word & Nuance of the Day
                    _buildWordOfTheDayCard(context, isDark),
                    const SizedBox(height: 10),
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
                '${QuizRepository.getCountByType(_selectedTrack)}/$totalQuestions Qs',
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

  Widget _buildTrackSwitcherSection(BuildContext context, bool isDark) {
    final wordCount = QuizRepository.getCountByType('word');
    final sentenceCount = QuizRepository.getCountByType('sentence');

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Track 1: 기초 어휘 (Vocabulary)
          Expanded(
            child: _buildTrackTabButton(
              isDark: isDark,
              isSelected: _selectedTrack == 'word',
              label: AppStrings.tr('track_tab_vocab', _selectedLangCode),
              badge: '$wordCount Qs',
              activeColor: const Color(0xFF0D9488), // Teal 600
              onTap: () {
                if (_selectedTrack != 'word') {
                  setState(() => _selectedTrack = 'word');
                }
              },
            ),
          ),
          const SizedBox(width: 6),
          // Track 2: 실전 문장·뉘앙스 (Sentences & Nuances)
          Expanded(
            child: _buildTrackTabButton(
              isDark: isDark,
              isSelected: _selectedTrack == 'sentence',
              label: AppStrings.tr('track_tab_sentence', _selectedLangCode),
              badge: '$sentenceCount Qs',
              activeColor: const Color(0xFF2563EB), // Blue 600
              onTap: () {
                if (_selectedTrack != 'sentence') {
                  setState(() => _selectedTrack = 'sentence');
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
    required String label,
    required String badge,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? activeColor.withValues(alpha: 0.3) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(
                    color: isDark ? activeColor : const Color(0xFFBFDBFE),
                    width: 1.5,
                  )
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? (isDark ? Colors.white : const Color(0xFF0F172A))
                        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? activeColor : activeColor.withValues(alpha: 0.15))
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? (isDark ? Colors.white : activeColor)
                        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
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
        : const [
            Color(0xFF0F172A), // Slate 900
            Color(0xFF1E3A8A), // Indigo 900
            Color(0xFF1D4ED8), // Blue 700
          ];

    final watermarkText = isWordTrack ? '어휘' : '실전';
    final heroBadgeText = isWordTrack
        ? AppStrings.tr('hero_vocab_badge', _selectedLangCode)
        : AppStrings.tr('hero_badge', _selectedLangCode);
    final heroTitleText = isWordTrack
        ? AppStrings.tr('hero_vocab_title', _selectedLangCode)
        : AppStrings.tr('hero_title', _selectedLangCode);
    final heroDescText = isWordTrack
        ? AppStrings.tr('hero_vocab_desc', _selectedLangCode)
        : AppStrings.tr('hero_desc', _selectedLangCode);

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
                        isWordTrack ? '기초 단어' : '일상 대화',
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
                            icon: Icons.backpack_rounded,
                            label: AppStrings.category('Objects', _selectedLangCode),
                            bgColor: Colors.white.withValues(alpha: 0.15),
                            onTap: () => _navigateToQuiz(context, category: 'Objects'),
                          ),
                          _buildPillTag(
                            icon: Icons.local_hospital_rounded,
                            label: AppStrings.category('Health', _selectedLangCode),
                            bgColor: Colors.white.withValues(alpha: 0.15),
                            onTap: () => _navigateToQuiz(context, category: 'Health'),
                          ),
                          _buildPillTag(
                            icon: Icons.compare_arrows_rounded,
                            label: AppStrings.category('Antonyms', _selectedLangCode),
                            bgColor: Colors.white.withValues(alpha: 0.15),
                            onTap: () => _navigateToQuiz(context, category: 'Antonyms'),
                          ),
                          _buildPillTag(
                            icon: Icons.bolt_rounded,
                            label: AppStrings.category('Personality', _selectedLangCode),
                            bgColor: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                            iconColor: const Color(0xFFFDE047),
                            onTap: () => _navigateToQuiz(context, category: 'Personality'),
                          ),
                        ]
                      : [
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

  Widget _buildMainStartButton(BuildContext context, bool isDark) {
    final isWordTrack = _selectedTrack == 'word';
    final buttonGradient = isWordTrack
        ? const LinearGradient(
            colors: [
              Color(0xFF0D9488), // Teal 600
              Color(0xFF0F766E), // Teal 700
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
          );

    final trackCount = QuizRepository.getCountByType(_selectedTrack);
    final buttonSub = isWordTrack
        ? '$trackCount문제 • 사물·장소·필수 단어'
        : '$trackCount문제 • 일상 실전 대화 문장 연습';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: (isWordTrack ? const Color(0xFF0D9488) : const Color(0xFF2563EB))
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
                      color: isWordTrack ? const Color(0xFF0F766E) : const Color(0xFF1D4ED8),
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
