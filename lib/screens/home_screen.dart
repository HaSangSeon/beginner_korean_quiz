import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/app_localization.dart';
import '../data/dialogue_data.dart';
import '../data/quiz_data.dart';
import '../data/survival_phrases_data.dart';
import '../services/ad_service.dart';
import '../services/notification_service.dart';
import '../services/progress_service.dart';
import '../services/quiz_repository.dart';
import '../services/tts_service.dart';
import 'dialogue_screen.dart';
import 'favorites_screen.dart';
import 'hangul_screen.dart';
import 'privacy_policy_dialog.dart';
import 'quiz_screen.dart';

/// Emoji icon per quiz category (0-byte vector icons)
const Map<String, String> _categoryEmoji = {
  // Word track (기초단어)
  '음식·음료': '🍎',
  '신체·건강': '🩺',
  '자연·날씨': '🌿',
  '생활·사물': '🏠',
  '패션·의류': '👕',
  '교통·이동': '🚌',

  // Sentence track (문장연습)
  '자기소개·직업': '👤',
  '일상생활·장소': '🏙️',
  '식당·외식·이동': '🍽️',
  '핵심표현·의사소통': '💡',
  '시간·일정·문장완성': '🗓️',

  // Survival track (서바이벌 K-Life - 6대 실전 상황)
  '카페·식당·외식문화': '☕',
  '편의점·마트·쇼핑': '🏪',
  '교통·길찾기·택시': '🚇',
  '병원·약국·응급': '💊',
  '배달·생활편의': '🛵',
  'K-컬처·소통·신조어': '✨',
  '식음료·편의점': '☕',
  '쇼핑·교통·외출': '🛍️',
  'K-컬처·소통': '✨',

  // Legacy fallback compatibility
  '생활·대화': '🗣️',
  '능력·가능': '💪',
  '목적·이동': '🚶',
  '국적·소개': '🌏',
  '출신·인사': '✈️',
  '직업·소개': '💼',
  '장소·생활': '🏙️',
  '의류·잡화': '👕',
  '자연': '🌿',
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

Color _getCategoryAccentColor(String cat) {
  switch (cat) {
    case '카페·식당·외식문화':
    case '식음료·편의점':
    case '음식·음료':
    case '카페·테이크아웃':
    case '식당·주문':
      return const Color(0xFFF59E0B); // Warm Amber
    case '편의점·마트·쇼핑':
    case '편의점·서바이벌':
    case '쇼핑·교통·외출':
    case '쇼핑·결제':
      return const Color(0xFF10B981); // Emerald
    case '교통·길찾기·택시':
    case '교통·이동':
    case '길찾기·교통':
    case '배달·택시 실전':
      return const Color(0xFF3B82F6); // Cobalt Blue
    case '병원·약국·응급':
    case '신체·건강':
      return const Color(0xFFF43F5E); // Rose
    case '배달·생활편의':
    case '생활·사물':
    case '생활·대화':
    case '생활대화':
      return const Color(0xFF8B5CF6); // Purple
    case 'K-컬처·소통·신조어':
    case 'K-컬처·소통':
    case 'K-컬처·팬문화':
    case '카톡·SNS 뉘앙스':
    case 'K-리액션·감탄사':
      return const Color(0xFFEC4899); // Pink
    case '자연·날씨':
    case '자연':
      return const Color(0xFF14B8A6); // Teal
    case '패션·의류':
    case '의류·잡화':
    case '의류·패션':
    case '패션·신발':
      return const Color(0xFF6366F1); // Indigo
    case '자기소개·직업':
    case '직업·소개':
    case '국적·소개':
    case '출신·인사':
      return const Color(0xFF0EA5E9); // Sky
    case '일상생활·장소':
    case '장소·생활':
      return const Color(0xFF64748B); // Slate
    case '식당·외식·이동':
      return const Color(0xFFEA580C); // Orange
    case '핵심표현·의사소통':
    case '희망·의도':
    case '요청·예절':
    case '이유·원인':
      return const Color(0xFFEAB308); // Gold
    case '시간·일정·문장완성':
    case '시간·일과':
      return const Color(0xFF0284C7); // Ocean Blue
    default:
      return const Color(0xFF2563EB); // Modern Primary Blue
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String get _selectedLangCode => ProgressService().language;
  String _selectedTrack = 'survival'; // Default to 'survival' (K-라이프 실전) for high immersion
  bool _isWordBookmarked = false;

  @override
  void initState() {
    super.initState();
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
    _navigateToQuiz(
      context,
      category: cat,
      quizType: _selectedTrack,
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
                    const SizedBox(height: 14),

                    // 1.5. Hangul Alphabet Quick Learning Card (왕초보 한글 장벽 해소)
                    _buildHangulAlphabetBanner(context, isDark),
                    const SizedBox(height: 16),

                    // 2. Word & Expression of the Day (오늘의 생존 한국어)
                    _buildWordOfTheDayCard(context, isDark),
                    const SizedBox(height: 18),

                    // 3. Track Switcher Segmented Control (📚 기초 어휘 vs 💬 실전 문장·뉘앙스)
                    _buildTrackSwitcherSection(context, isDark),
                    const SizedBox(height: 18),

                    // 4. Main Hero Card (Adapts to all 4 tracks: K-Life, Daily Sentences, Basic Words, Dialogues)
                    _buildHeroQuizCard(context, isDark),
                    const SizedBox(height: 16),

                    // 5. Prominent [Start] CTA Button (Adapts to all 4 tracks)
                    _buildMainStartButton(context, isDark),
                    const SizedBox(height: 24),

                    // 6. Track specific content
                    if (_selectedTrack == 'dialogue') ...[
                      _buildDialogueSection(context, isDark),
                    ] else ...[
                      // Mistake Review (only when there are mistakes in this track)
                      _buildReviewCard(context, isDark),

                      // User Bookmarked Favorites Card (prominent when expressions are saved)
                      _buildFavoritesCard(context, isDark),

                      // Topic list with per-topic progress
                      _buildCategorySection(context, isDark),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            const BottomBannerAdWidget(fillSafeAreaWhenEmpty: true),
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
        _buildFavoritesButton(context, isDark),
        const SizedBox(width: 8),
        _buildSettingsButton(context, isDark),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildFavoritesButton(BuildContext context, bool isDark) {
    final progress = ProgressService();
    final favCount = progress.favoriteIds.length;
    final hasFav = favCount > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(19),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoritesScreen()),
          );
        },
        child: Container(
          height: 38,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: hasFav ? 10 : 9),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: hasFav
                  ? const Color(0xFFF59E0B)
                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: (hasFav ? const Color(0xFFF59E0B) : (isDark ? Colors.black : const Color(0xFF64748B)))
                    .withValues(alpha: hasFav ? 0.28 : (isDark ? 0.3 : 0.05)),
                blurRadius: 4,
                offset: const Offset(0, 1.5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⭐', style: TextStyle(fontSize: 14)),
              if (hasFav) ...[
                const SizedBox(width: 4),
                Text(
                  '$favCount',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(19),
        onTap: () => _showSettingsBottomSheet(context),
        child: Container(
          height: 38,
          width: 38,
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
          child: Icon(
            Icons.settings_outlined,
            size: 20,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (modalCtx) {
        return ListenableBuilder(
          listenable: ProgressService(),
          builder: (ctx, _) {
            final progress = ProgressService();
            final isNotifEnabled = progress.isNotificationEnabled;
            final isDarkNow = Theme.of(ctx).brightness == Brightness.dark;
            final currentLang = supportedLanguages.firstWhere(
              (l) => l.code == _selectedLangCode,
              orElse: () => supportedLanguages.first,
            );

            return Container(
              decoration: BoxDecoration(
                color: isDarkNow ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDarkNow ? 0.5 : 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDarkNow ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Icon(Icons.settings_rounded, size: 22, color: Color(0xFF3B82F6)),
                      const SizedBox(width: 10),
                      Text(
                        AppStrings.tr('settings_title', _selectedLangCode),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDarkNow ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 1. Language Selection Tile
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDarkNow ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkNow ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(currentLang.flag, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.tr('lang_selector_title', _selectedLangCode),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkNow ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                currentLang.label,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDarkNow ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          initialValue: _selectedLangCode,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isDarkNow ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          color: isDarkNow ? const Color(0xFF1E293B) : Colors.white,
                          onSelected: (code) {
                            ProgressService().setLanguage(code);
                            setState(() {});
                          },
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
                                            : (isDarkNow ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B)),
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
                              color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Change',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF3B82F6),
                                  ),
                                ),
                                SizedBox(width: 2),
                                Icon(Icons.arrow_drop_down, color: Color(0xFF3B82F6), size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2. Daily Study Notification Toggle
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDarkNow ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkNow ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isNotifEnabled ? Icons.notifications_active_rounded : Icons.notifications_off_outlined,
                          color: isNotifEnabled ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.tr('settings_notif_title', _selectedLangCode),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDarkNow ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                AppStrings.tr('settings_notif_desc', _selectedLangCode),
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDarkNow ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: isNotifEnabled,
                          activeThumbColor: const Color(0xFF3B82F6),
                          onChanged: (val) async {
                            if (val) {
                              await NotificationService().requestPermission();
                            }
                            progress.setNotificationEnabled(val);
                            if (val) {
                              await NotificationService().scheduleDailyReminder();
                            } else {
                              await NotificationService().cancelAll();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3. Dark/Light Theme Toggle
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDarkNow ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkNow ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isDarkNow ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          color: isDarkNow ? const Color(0xFFFCD34D) : const Color(0xFFF59E0B),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            AppStrings.tr('settings_theme_title', _selectedLangCode),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDarkNow ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        Switch(
                          value: isDarkNow,
                          activeThumbColor: const Color(0xFF3B82F6),
                          onChanged: (_) {
                            progress.toggleTheme(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3.5. Pronunciation Hint Toggle
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDarkNow ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkNow ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.record_voice_over_rounded,
                          color: Color(0xFF3B82F6),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.tr('quiz_hint_badge', _selectedLangCode),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDarkNow ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                AppStrings.tr('quiz_hint_toggle_tooltip', _selectedLangCode),
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDarkNow ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: progress.showPronunciationHint,
                          activeThumbColor: const Color(0xFF3B82F6),
                          onChanged: (_) {
                            progress.togglePronunciationHint();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3.8. Hangul Alphabet Learning Tile
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.of(modalCtx).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HangulScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isDarkNow ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDarkNow ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text('🔤', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.tr('hangul_title', _selectedLangCode),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: isDarkNow ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  AppStrings.tr('hangul_sub', _selectedLangCode),
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: isDarkNow ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: isDarkNow ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 4. Privacy Policy Tile
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.of(modalCtx).pop();
                      PrivacyPolicyDialog.show(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isDarkNow ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDarkNow ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shield_outlined, color: Color(0xFF3B82F6), size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              AppStrings.tr('settings_privacy_title', _selectedLangCode),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isDarkNow ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: isDarkNow ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
                  emoji: '✅',
                  value: '${AppStrings.tr('stat_progress', _selectedLangCode)} $learned/$total',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                      );
                    },
                    child: _buildMiniStat(
                      isDark: isDark,
                      emoji: '⭐',
                      value: '${AppStrings.tr('favorites_title', _selectedLangCode)} ${progress.favoriteIds.length}',
                    ),
                  ),
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

  Widget _buildFavoritesCard(BuildContext context, bool isDark) {
    final progress = ProgressService();
    final favoriteIds = progress.favoriteIds.toList();

    if (favoriteIds.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFFF59E0B).withValues(alpha: 0.5) : const Color(0xFFFCD34D),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.2 : 0.08),
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
                  ? const Color(0xFF78350F).withValues(alpha: 0.5)
                  : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text('⭐', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.tr('favorites_title', _selectedLangCode),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? const Color(0xFFFDE68A) : const Color(0xFFB45309),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.tr('favorites_desc', _selectedLangCode, {'count': '${favoriteIds.length}'}),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: const Color(0xFF78350F),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              AppStrings.tr('favorites_open', _selectedLangCode),
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
        const SizedBox(height: 14),
        Builder(
          builder: (context) {
            final screenWidth = MediaQuery.sizeOf(context).width;
            final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
            final double dynamicAspectRatio = (screenWidth < 360 || textScale > 1.1) ? 1.08 : 1.18;

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
            final accentColor = _getCategoryAccentColor(cat);

            return Material(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => _onCategoryCardTap(context, cat, emoji, isDark),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        isDark ? const Color(0xFF1E293B) : Colors.white,
                        accentColor.withValues(alpha: isDark ? 0.08 : 0.035),
                      ],
                    ),
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
                      // 1. Top row: Theme Accent Emoji Badge + Status Pill
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: isDark ? 0.20 : 0.12),
                              borderRadius: BorderRadius.circular(11),
                              border: Border.all(
                                color: accentColor.withValues(alpha: isDark ? 0.35 : 0.22),
                                width: 0.9,
                              ),
                            ),
                            child: Text(emoji, style: const TextStyle(fontSize: 20)),
                          ),
                          if (isComplete)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF22C55E).withValues(alpha: isDark ? 0.2 : 0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF22C55E).withValues(alpha: 0.35),
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle_rounded, size: 11, color: Color(0xFF22C55E)),
                                  const SizedBox(width: 3),
                                  Text(
                                    AppStrings.tr('stage_completed', _selectedLangCode),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF22C55E),
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (learned > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: isDark ? 0.20 : 0.10),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: accentColor.withValues(alpha: isDark ? 0.35 : 0.20),
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                '${(ratio * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: accentColor,
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Text(
                                '$learned/$total',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                        ],
                      ),

                      // 2. Center: Topic Title & Subtitle Info (eliminating awkward emptiness)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.category(cat, _selectedLangCode),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                                letterSpacing: -0.2,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isComplete
                                  ? AppStrings.tr('category_progress', _selectedLangCode)
                                      .replaceAll('{done}', learned.toString())
                                      .replaceAll('{total}', total.toString())
                                  : (learned > 0
                                      ? AppStrings.tr('category_progress', _selectedLangCode)
                                          .replaceAll('{done}', learned.toString())
                                          .replaceAll('{total}', total.toString())
                                      : AppStrings.tr('cat_count_badge', _selectedLangCode)
                                          .replaceAll('{count}', total.toString())),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isComplete
                                    ? const Color(0xFF22C55E)
                                    : (learned > 0
                                        ? (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569))
                                        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 3. Bottom: Sleek Rounded Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: ratio,
                          minHeight: 5.0,
                          backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isComplete ? const Color(0xFF22C55E) : accentColor,
                          ),
                        ),
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
          const SizedBox(width: 5),
          // Track 4: 대화문 암기 (Situational Dialogues)
          Expanded(
            child: _buildTrackTabButton(
              isDark: isDark,
              isSelected: _selectedTrack == 'dialogue',
              emoji: '📖',
              label: AppStrings.tr('track_tab_dialogue', _selectedLangCode),
              badge: '${dialogues.length}',
              activeColor: const Color(0xFFDB2777), // Pink 600
              onTap: () {
                if (_selectedTrack != 'dialogue') {
                  setState(() => _selectedTrack = 'dialogue');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogueSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(Icons.forum_rounded, size: 18, color: Color(0xFFDB2777)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                AppStrings.tr('dialogue_header', _selectedLangCode),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...dialogues.map((d) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DialogueScreen(dialogue: d, langCode: _selectedLangCode),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDB2777).withValues(alpha: isDark ? 0.22 : 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(d.emoji, style: const TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              d.title(_selectedLangCode),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              d.lines.first.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.tr('dialogue_lines', _selectedLangCode, {'n': '${d.lines.length}'}),
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? const Color(0xFFF9A8D4) : const Color(0xFFDB2777),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
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
    final isDialogueTrack = _selectedTrack == 'dialogue';

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
            : (isDialogueTrack
                ? const [
                    Color(0xFF500724), // Rose 950
                    Color(0xFF9D174D), // Rose 700
                    Color(0xFFDB2777), // Pink 600
                  ]
                : const [
                    Color(0xFF0F172A), // Slate 900
                    Color(0xFF1E3A8A), // Indigo 900
                    Color(0xFF1D4ED8), // Blue 700
                  ]));

    final watermarkText = isWordTrack
        ? '단어'
        : (isSurvivalTrack ? 'K-생존' : (isDialogueTrack ? '회화' : '대화'));
    final heroBadgeText = isWordTrack
        ? AppStrings.tr('hero_vocab_badge', _selectedLangCode)
        : (isSurvivalTrack
            ? AppStrings.tr('hero_survival_badge', _selectedLangCode)
            : (isDialogueTrack
                ? AppStrings.tr('hero_dialogue_badge', _selectedLangCode)
                : AppStrings.tr('hero_badge', _selectedLangCode)));
    final heroTitleText = isWordTrack
        ? AppStrings.tr('hero_vocab_title', _selectedLangCode)
        : (isSurvivalTrack
            ? AppStrings.tr('hero_survival_title', _selectedLangCode)
            : (isDialogueTrack
                ? AppStrings.tr('hero_dialogue_title', _selectedLangCode)
                : AppStrings.tr('hero_title', _selectedLangCode)));
    final heroDescText = isWordTrack
        ? AppStrings.tr('hero_vocab_desc', _selectedLangCode)
        : (isSurvivalTrack
            ? AppStrings.tr('hero_survival_desc', _selectedLangCode)
            : (isDialogueTrack
                ? AppStrings.tr('hero_dialogue_desc', _selectedLangCode)
                : AppStrings.tr('hero_desc', _selectedLangCode)));

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
            color: (isWordTrack
                    ? const Color(0xFF0F766E)
                    : (isDialogueTrack ? const Color(0xFF9D174D) : const Color(0xFF1E3A8A)))
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
                            icon: Icons.restaurant_rounded,
                            label: AppStrings.category('음식·음료', _selectedLangCode),
                            bgColor: Colors.white.withValues(alpha: 0.15),
                            onTap: () => _onCategoryCardTap(context, '음식·음료', _categoryEmoji['음식·음료'] ?? '🍎', isDark),
                          ),
                          _buildPillTag(
                            icon: Icons.favorite_rounded,
                            label: AppStrings.category('신체·건강', _selectedLangCode),
                            bgColor: Colors.white.withValues(alpha: 0.15),
                            onTap: () => _onCategoryCardTap(context, '신체·건강', _categoryEmoji['신체·건강'] ?? '🩺', isDark),
                          ),
                          _buildPillTag(
                            icon: Icons.checkroom_rounded,
                            label: AppStrings.category('패션·의류', _selectedLangCode),
                            bgColor: Colors.white.withValues(alpha: 0.15),
                            onTap: () => _onCategoryCardTap(context, '패션·의류', _categoryEmoji['패션·의류'] ?? '👕', isDark),
                          ),
                          _buildPillTag(
                            icon: Icons.park_rounded,
                            label: AppStrings.category('자연·날씨', _selectedLangCode),
                            bgColor: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                            iconColor: const Color(0xFFFDE047),
                            onTap: () => _onCategoryCardTap(context, '자연·날씨', _categoryEmoji['자연·날씨'] ?? '🌿', isDark),
                          ),
                        ]
                      : (isSurvivalTrack
                          ? [
                              _buildPillTag(
                                icon: Icons.local_cafe_rounded,
                                label: AppStrings.category('카페·식당·외식문화', _selectedLangCode),
                                bgColor: Colors.white.withValues(alpha: 0.15),
                                onTap: () => _onCategoryCardTap(context, '카페·식당·외식문화', _categoryEmoji['카페·식당·외식문화'] ?? '☕', isDark),
                              ),
                              _buildPillTag(
                                icon: Icons.storefront_rounded,
                                label: AppStrings.category('편의점·마트·쇼핑', _selectedLangCode),
                                bgColor: Colors.white.withValues(alpha: 0.15),
                                onTap: () => _onCategoryCardTap(context, '편의점·마트·쇼핑', _categoryEmoji['편의점·마트·쇼핑'] ?? '🏪', isDark),
                              ),
                              _buildPillTag(
                                icon: Icons.subway_rounded,
                                label: AppStrings.category('교통·길찾기·택시', _selectedLangCode),
                                bgColor: Colors.white.withValues(alpha: 0.15),
                                onTap: () => _onCategoryCardTap(context, '교통·길찾기·택시', _categoryEmoji['교통·길찾기·택시'] ?? '🚇', isDark),
                              ),
                              _buildPillTag(
                                icon: Icons.local_hospital_rounded,
                                label: AppStrings.category('병원·약국·응급', _selectedLangCode),
                                bgColor: const Color(0xFFEF4444).withValues(alpha: 0.25),
                                iconColor: const Color(0xFFFCA5A5),
                                onTap: () => _onCategoryCardTap(context, '병원·약국·응급', _categoryEmoji['병원·약국·응급'] ?? '💊', isDark),
                              ),
                            ]
                          : (isDialogueTrack
                              ? dialogues.take(4).map((d) {
                                  return _buildPillTag(
                                    icon: Icons.chat_bubble_outline_rounded,
                                    label: d.title(_selectedLangCode),
                                    bgColor: Colors.white.withValues(alpha: 0.16),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DialogueScreen(dialogue: d, langCode: _selectedLangCode),
                                      ),
                                    ),
                                  );
                                }).toList()
                              : [
                                  _buildPillTag(
                                    icon: Icons.badge_rounded,
                                    label: AppStrings.category('자기소개·직업', _selectedLangCode),
                                    bgColor: Colors.white.withValues(alpha: 0.15),
                                    onTap: () => _onCategoryCardTap(context, '자기소개·직업', _categoryEmoji['자기소개·직업'] ?? '👤', isDark),
                                  ),
                                  _buildPillTag(
                                    icon: Icons.apartment_rounded,
                                    label: AppStrings.category('일상생활·장소', _selectedLangCode),
                                    bgColor: Colors.white.withValues(alpha: 0.15),
                                    onTap: () => _onCategoryCardTap(context, '일상생활·장소', _categoryEmoji['일상생활·장소'] ?? '🏙️', isDark),
                                  ),
                                  _buildPillTag(
                                    icon: Icons.restaurant_rounded,
                                    label: AppStrings.category('식당·외식·이동', _selectedLangCode),
                                    bgColor: Colors.white.withValues(alpha: 0.15),
                                    onTap: () => _onCategoryCardTap(context, '식당·외식·이동', _categoryEmoji['식당·외식·이동'] ?? '🍽️', isDark),
                                  ),
                                  _buildPillTag(
                                    icon: Icons.lightbulb_rounded,
                                    label: AppStrings.category('핵심표현·의사소통', _selectedLangCode),
                                    bgColor: Colors.white.withValues(alpha: 0.15),
                                    onTap: () => _onCategoryCardTap(context, '핵심표현·의사소통', _categoryEmoji['핵심표현·의사소통'] ?? '💡', isDark),
                                  ),
                                  _buildPillTag(
                                    icon: Icons.calendar_month_rounded,
                                    label: AppStrings.category('시간·일정·문장완성', _selectedLangCode),
                                    bgColor: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                                    iconColor: const Color(0xFFFDE047),
                                    onTap: () => _onCategoryCardTap(context, '시간·일정·문장완성', _categoryEmoji['시간·일정·문장완성'] ?? '🗓️', isDark),
                                  ),
                                ])),
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
    final isDialogueTrack = _selectedTrack == 'dialogue';

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
            : (isDialogueTrack
                ? const LinearGradient(
                    colors: [
                      Color(0xFFDB2777), // Pink 600
                      Color(0xFFBE185D), // Pink 700
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
                  )));

    final trackCount = QuizRepository.getCountByType(_selectedTrack);
    final buttonTitle = isDialogueTrack
        ? AppStrings.tr('btn_start_dialogue', _selectedLangCode)
        : AppStrings.tr('start_quiz_btn', _selectedLangCode);
    final buttonSub = isWordTrack
        ? AppStrings.tr('btn_sub_vocab', _selectedLangCode, {'count': '$trackCount'})
        : (isSurvivalTrack
            ? AppStrings.tr('btn_sub_survival', _selectedLangCode, {'count': '$trackCount'})
            : (isDialogueTrack
                ? AppStrings.tr('btn_sub_dialogue', _selectedLangCode)
                : AppStrings.tr('btn_sub_sentence', _selectedLangCode, {'count': '$trackCount'})));

    final shadowColor = isWordTrack
        ? const Color(0xFF0D9488)
        : (isSurvivalTrack
            ? const Color(0xFFEA580C)
            : (isDialogueTrack ? const Color(0xFFDB2777) : const Color(0xFF2563EB)));

    final playIconColor = isWordTrack
        ? const Color(0xFF0F766E)
        : (isSurvivalTrack
            ? const Color(0xFFC2410C)
            : (isDialogueTrack ? const Color(0xFFBE185D) : const Color(0xFF1D4ED8)));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.35),
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
            onTap: () {
              if (isDialogueTrack) {
                if (dialogues.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DialogueScreen(dialogue: dialogues.first, langCode: _selectedLangCode),
                    ),
                  );
                }
              } else {
                _navigateToQuiz(context, quizType: _selectedTrack);
              }
            },
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
                      color: playIconColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          buttonTitle,
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


  Widget _buildHangulAlphabetBanner(BuildContext context, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HangulScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                  : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFC7D2FE),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : const Color(0xFF4F46E5))
                    .withValues(alpha: isDark ? 0.35 : 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text('🔤', style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6.5, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF312E81) : const Color(0xFFDBEAFE),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'BEGINNER GUIDE',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                              color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF1D4ED8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      AppStrings.tr('hangul_home_banner_title', _selectedLangCode),
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E1B4B),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.tr('hangul_home_banner_sub', _selectedLangCode),
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF4338CA),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF312E81) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF4338CA) : const Color(0xFFC7D2FE),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'START',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4F46E5),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4F46E5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWordOfTheDayCard(BuildContext context, bool isDark) {
    final phrase = SurvivalPhraseRepository.getTodayPhrase();

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
                phrase.korean,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    TtsService().speak(phrase.korean);
                    final toastTemplate = AppStrings.tr('wotd_listen_toast', _selectedLangCode);
                    final toastMsg = toastTemplate.contains('[')
                        ? toastTemplate.replaceAll(RegExp(r'\[.*?\]'), '[${phrase.korean}]')
                        : '$toastTemplate: [${phrase.korean}]';

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(toastMsg),
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
            phrase.getMeaning(_selectedLangCode),
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
                    phrase.getTip(_selectedLangCode),
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
