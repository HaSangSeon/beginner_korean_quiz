import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/app_localization.dart';
import '../data/dialogue_data.dart';
import '../data/quiz_data.dart';
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
  String? _expandedCategoryTrack;
  String _selectedTrack = 'survival'; // Default to 'survival' (K-라이프 실전) for high immersion
  String _selectedDialogueFilter = 'all'; // 'all', 'food', 'transit', 'life', 'public', 'health'
  bool _isDialogueExpanded = false;

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
        body: SafeArea(
          top: false,
          bottom: true,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTrackSwitcherSection(context, isDark),
                      const SizedBox(height: 12),
                      _buildMainStartButton(context, isDark),
                      const SizedBox(height: 20),

                      if (_selectedTrack == 'dialogue')
                        _buildDialogueSection(context, isDark)
                      else
                        _buildCategorySection(context, isDark),
                      const SizedBox(height: 20),

                      if (_selectedTrack != 'dialogue') ...[
                        _buildReviewCard(context, isDark),
                        _buildFavoritesCard(context, isDark),
                      ],
                      _buildHangulAlphabetBanner(context, isDark),
                      const SizedBox(height: 12),
                      _buildDailyGoalCard(context, isDark),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
            ),
            const BottomBannerAdWidget(fillSafeAreaWhenEmpty: false),
          ],
        ),
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
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoritesScreen()),
          );
        },
        child: Container(
          height: 40,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: hasFav ? 12 : 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: hasFav
                  ? const Color(0xFFF59E0B)
                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⭐', style: TextStyle(fontSize: 15)),
              if (hasFav) ...[
                const SizedBox(width: 5),
                Text(
                  '$favCount',
                  style: TextStyle(
                    fontSize: 13,
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
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showSettingsBottomSheet(context),
        child: Container(
          height: 40,
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              width: 1.0,
            ),
          ),
          child: Icon(
            Icons.settings_outlined,
            size: 20,
            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
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
                              final granted = await NotificationService().requestPermission();
                              if (!granted) {
                                progress.setNotificationEnabled(false);
                                await NotificationService().cancelAll();
                                return;
                              }
                              progress.setNotificationEnabled(true);
                              await NotificationService().scheduleDailyReminder();
                            } else {
                              progress.setNotificationEnabled(false);
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.insights_rounded,
                size: 20,
                color: Color(0xFF2563EB),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.tr('dashboard_title', _selectedLangCode),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.tr('dashboard_sub', _selectedLangCode),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Daily Goal XP Progress
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Goal Ring
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: ratio),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) => SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            value: value,
                            strokeWidth: 5,
                            strokeCap: StrokeCap.round,
                            backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              done ? const Color(0xFFF59E0B) : const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                      ),
                      Text(done ? '🏆' : '⚡', style: const TextStyle(fontSize: 19)),
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
                        maxLines: 2,
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
                              : const Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Mini stat Row
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
                    borderRadius: BorderRadius.circular(14),
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

  Widget _buildMiniStat({
    required bool isDark,
    required String emoji,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.3,
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFFEF4444).withValues(alpha: 0.5) : const Color(0xFFFCA5A5),
        ),
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
                    fontSize: 13,
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFFF59E0B).withValues(alpha: 0.5) : const Color(0xFFFCD34D),
        ),
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
                    fontSize: 13,
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
    const previewCount = 2;
    final showAll = _expandedCategoryTrack == _selectedTrack;
    final visibleCount = showAll || categories.length <= previewCount
        ? categories.length
        : previewCount;
    final progress = ProgressService();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.grid_view_rounded, size: 18, color: Color(0xFF2563EB)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                AppStrings.tr('categories_header', _selectedLangCode),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
            ),
            if (categories.length > previewCount)
              TextButton(
                onPressed: () => setState(() {
                  _expandedCategoryTrack = showAll ? null : _selectedTrack;
                }),
                child: Text(
                  AppStrings.tr(
                    showAll ? 'dialogue_collapse_btn' : 'categories_view_all',
                    _selectedLangCode,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Builder(
          builder: (context) {
            final screenWidth = MediaQuery.sizeOf(context).width;
            final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
            final double dynamicAspectRatio = (screenWidth < 360 || textScale > 1.1) ? 1.0 : 1.12;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: dynamicAspectRatio,
              ),
              itemCount: visibleCount,
              itemBuilder: (context, index) {
            final cat = categories[index];
            final catIds = QuizRepository.getIdsByCategory(cat);
            final total = catIds.length;
            final wrongSet = progress.wrongIds.toSet();
            final learned = catIds.where((id) => progress.isLearned(id) && !wrongSet.contains(id)).length;
            final attempted = catIds.where((id) => progress.isLearned(id) || wrongSet.contains(id)).length;
            final ratio = total > 0 ? (attempted / total).clamp(0.0, 1.0) : 0.0;
            final emoji = _categoryEmoji[cat] ?? '📌';
            final isComplete = learned == total && total > 0;
            final accentColor = _getCategoryAccentColor(cat);

            return Material(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: () => _onCategoryCardTap(context, cat, emoji, isDark),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isComplete
                          ? const Color(0xFF22C55E).withValues(alpha: 0.6)
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 1. Top row: Emoji + Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 24)),
                          if (isComplete)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF16A34A)),
                                const SizedBox(width: 3),
                                Text(
                                  AppStrings.tr('stage_completed', _selectedLangCode),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF16A34A),
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              '$attempted/$total',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
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
                                fontSize: 14.5,
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
                                  : (attempted > 0
                                      ? AppStrings.tr('category_progress', _selectedLangCode)
                                          .replaceAll('{done}', attempted.toString())
                                          .replaceAll('{total}', total.toString())
                                      : AppStrings.tr('cat_count_badge', _selectedLangCode)
                                          .replaceAll('{count}', total.toString())),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isComplete
                                    ? const Color(0xFF22C55E)
                                    : (attempted > 0
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
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(16),
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
    final filterCategories = const [
      {'key': 'all', 'emoji': '✨', 'labelKey': 'dialogue_filter_all'},
      {'key': 'food', 'emoji': '🍽️', 'labelKey': 'dialogue_filter_food'},
      {'key': 'transit', 'emoji': '🚇', 'labelKey': 'dialogue_filter_transit'},
      {'key': 'life', 'emoji': '🛍️', 'labelKey': 'dialogue_filter_life'},
      {'key': 'public', 'emoji': '🏛️', 'labelKey': 'dialogue_filter_public'},
      {'key': 'health', 'emoji': '🏥', 'labelKey': 'dialogue_filter_health'},
    ];

    final orderedDialogues = dialoguesInLearningOrder;
    final filteredDialogues = _selectedDialogueFilter == 'all'
        ? orderedDialogues
        : orderedDialogues.where((d) => d.category == _selectedDialogueFilter).toList();

    const int initialVisibleCount = 8;
    final bool hasMore = filteredDialogues.length > initialVisibleCount;
    final visibleDialogues = (_isDialogueExpanded || !hasMore)
        ? filteredDialogues
        : filteredDialogues.take(initialVisibleCount).toList();

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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFDB2777).withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${filteredDialogues.length}/${dialogues.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: isDark ? const Color(0xFFF472B6) : const Color(0xFFDB2777),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Horizontal Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filterCategories.map((cat) {
              final key = cat['key']!;
              final emoji = cat['emoji']!;
              final label = AppStrings.tr(cat['labelKey']!, _selectedLangCode);
              final isSelected = _selectedDialogueFilter == key;
              final count = key == 'all'
                  ? dialogues.length
                  : dialogues.where((d) => d.category == key).length;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Material(
                  color: isSelected
                      ? const Color(0xFFDB2777)
                      : (isDark ? const Color(0xFF1E293B) : Colors.white),
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      if (_selectedDialogueFilter != key) {
                        setState(() {
                          _selectedDialogueFilter = key;
                          _isDialogueExpanded = false;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFDB2777)
                              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                        ),
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
                                  ? Colors.white
                                  : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.25)
                                  : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$count',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
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
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),
        // Visible dialogues list
        ...visibleDialogues.map((d) {
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
        // Show More / Collapse Button
        if (hasMore) ...[
          const SizedBox(height: 4),
          Center(
            child: Material(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  setState(() {
                    _isDialogueExpanded = !_isDialogueExpanded;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFFDB2777).withValues(alpha: 0.45)
                          : const Color(0xFFF472B6),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isDialogueExpanded
                            ? AppStrings.tr('dialogue_collapse_btn', _selectedLangCode)
                            : AppStrings.tr('dialogue_more_btn', _selectedLangCode, {
                                'n': '${filteredDialogues.length - initialVisibleCount}',
                              }),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? const Color(0xFFF472B6) : const Color(0xFFDB2777),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _isDialogueExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: isDark ? const Color(0xFFF472B6) : const Color(0xFFDB2777),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ],
    );
  }

  Widget _buildTrackTabButton({
    required bool isDark,
    required bool isSelected,
    required String emoji,
    required String label,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF334155) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
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

  Widget _buildMainStartButton(BuildContext context, bool isDark) {
    final isWordTrack = _selectedTrack == 'word';
    final isSurvivalTrack = _selectedTrack == 'survival';
    final isDialogueTrack = _selectedTrack == 'dialogue';

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

    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () {
              if (isDialogueTrack) {
                if (dialogues.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DialogueScreen(dialogue: dialoguesInLearningOrder.first, langCode: _selectedLangCode),
                    ),
                  );
                }
              } else {
                _navigateToQuiz(context, quizType: _selectedTrack);
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          buttonTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          buttonSub,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 22,
                    color: Colors.white,
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
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HangulScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              const Text('🔤', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.tr('hangul_home_banner_title', _selectedLangCode),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                        letterSpacing: -0.2,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.tr('hangul_home_banner_sub', _selectedLangCode),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
