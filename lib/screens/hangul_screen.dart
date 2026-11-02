import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/app_localization.dart';
import '../data/hangul_data.dart';
import '../services/progress_service.dart';
import '../services/tts_service.dart';
import '../utils/korean_romanizer.dart';

class HangulScreen extends StatefulWidget {
  const HangulScreen({super.key});

  @override
  State<HangulScreen> createState() => _HangulScreenState();
}

class _HangulScreenState extends State<HangulScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _langCode;
  bool _isSlowAudio = false;
  String? _currentlyPlayingLetter;
  String _consonantFilter = 'all'; // 'all', 'plain', 'aspirated', 'tense'

  // Syllable Builder interactive state
  int _selectedInitialIdx = 0; // ㄱ
  int _selectedVowelIdx = 0; // ㅏ
  int _selectedFinalIdx = 0; // None (0)
  int _activeBuilderStep = 1; // 1: 초성, 2: 중성, 3: 종성
  bool _isAllInOneView = false;

  static const List<String> _builderInitials = [
    'ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
  ];
  static const List<String> _builderVowels = [
    'ㅏ', 'ㅑ', 'ㅓ', 'ㅕ', 'ㅗ', 'ㅛ', 'ㅜ', 'ㅠ', 'ㅡ', 'ㅣ', 'ㅐ', 'ㅔ'
  ];
  static const List<String> _builderFinals = [
    '', 'ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _langCode = ProgressService().language;
  }

  @override
  void dispose() {
    _tabController.dispose();
    TtsService().stop();
    super.dispose();
  }

  void _playLetterAudio(String letter, String exampleKorean) async {
    HapticFeedback.lightImpact();
    setState(() => _currentlyPlayingLetter = letter);
    await TtsService().speak('$letter. $exampleKorean', isSlow: _isSlowAudio);
    if (mounted) {
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (mounted && _currentlyPlayingLetter == letter) {
          setState(() => _currentlyPlayingLetter = null);
        }
      });
    }
  }

  String _buildCurrentSyllable() {
    final initialChar = _builderInitials[_selectedInitialIdx];
    final vowelChar = _builderVowels[_selectedVowelIdx];
    final finalChar = _builderFinals[_selectedFinalIdx];

    const allInitials = [
      'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ',
      'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
    ];
    const allVowels = [
      'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ',
      'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ'
    ];
    const allFinals = [
      '', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ',
      'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ',
      'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
    ];

    final initIdx = allInitials.indexOf(initialChar);
    final vowIdx = allVowels.indexOf(vowelChar);
    final finIdx = allFinals.indexOf(finalChar);

    if (initIdx == -1 || vowIdx == -1 || finIdx == -1) return '가';

    final code = 0xAC00 + (initIdx * 21 + vowIdx) * 28 + finIdx;
    return String.fromCharCode(code);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        centerTitle: false,
        titleSpacing: 0,
        toolbarHeight: 64,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.tr('hangul_title', _langCode),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 17.5,
                fontWeight: FontWeight.w900,
                color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              AppStrings.tr('hangul_sub', _langCode),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        actions: [
          // Audio Speed Toggle (Normal 🐰 / Slow 🐢)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _isSlowAudio = !_isSlowAudio);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isSlowAudio
                        ? const Color(0xFF10B981).withValues(alpha: 0.16)
                        : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isSlowAudio
                          ? const Color(0xFF10B981)
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      width: 1.3,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_isSlowAudio ? '🐢' : '🐰', style: const TextStyle(fontSize: 13.5)),
                      const SizedBox(width: 4),
                      Text(
                        _isSlowAudio ? '0.7x' : '1.0x',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: _isSlowAudio
                              ? const Color(0xFF10B981)
                              : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Language Switcher
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: PopupMenuButton<String>(
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
                setState(() => _langCode = code);
                ProgressService().setLanguage(code);
              },
              itemBuilder: (context) => [
                _buildPopupItem('KO', '🇰🇷 한국어', isDark),
                _buildPopupItem('EN', '🇺🇸 English', isDark),
                _buildPopupItem('VI', '🇻🇳 Tiếng Việt', isDark),
                _buildPopupItem('ZH', '🇨🇳 中文', isDark),
                _buildPopupItem('JA', '🇯🇵 日本語', isDark),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _langCode,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 15,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: const Color(0xFF2563EB),
              indicatorWeight: 3.2,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: const Color(0xFF2563EB),
              unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              tabs: [
                Tab(text: '${AppStrings.tr('hangul_tab_basic_cons', _langCode)} (19)'),
                Tab(text: '${AppStrings.tr('hangul_tab_basic_vow', _langCode)} (10)'),
                Tab(text: '${AppStrings.tr('hangul_tab_compound_vow', _langCode)} (11)'),
                Tab(text: '🧩 ${AppStrings.tr('hangul_tab_syllable', _langCode)}'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConsonantView(isDark),
          _buildVowelGrid(HangulData.basicVowels, isDark),
          _buildVowelGrid(HangulData.compoundVowels, isDark),
          _buildSyllableBuilderView(isDark),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withValues(alpha: 0.38),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF2563EB),
          elevation: 0,
          highlightElevation: 2,
          icon: const Icon(Icons.headphones_rounded, color: Colors.white, size: 21),
          label: Text(
            AppStrings.tr('hangul_mini_quiz_btn', _langCode),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
          onPressed: () => _showMiniListeningQuiz(context, isDark),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(String code, String label, bool isDark) {
    return PopupMenuItem<String>(
      value: code,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: _langCode == code ? FontWeight.w800 : FontWeight.w500,
          color: _langCode == code
              ? const Color(0xFF2563EB)
              : (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)),
        ),
      ),
    );
  }

  Widget _buildConsonantView(bool isDark) {
    final allConsonants = [...HangulData.basicConsonants, ...HangulData.doubleConsonants];
    final filtered = allConsonants.where((item) {
      if (_consonantFilter == 'plain') return item.categoryType == 'plain';
      if (_consonantFilter == 'aspirated') return item.categoryType == 'aspirated';
      if (_consonantFilter == 'tense') return item.categoryType == 'tense';
      return true;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 88),
      physics: const BouncingScrollPhysics(),
      children: [
        // Filter Pills Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildFilterChip('all', '${AppStrings.tr('hangul_filter_all', _langCode)} (19)', isDark),
              const SizedBox(width: 8),
              _buildFilterChip('plain', '${AppStrings.tr('hangul_filter_plain', _langCode)} (10)', isDark),
              const SizedBox(width: 8),
              _buildFilterChip('aspirated', '${AppStrings.tr('hangul_filter_aspirated', _langCode)} (5)', isDark),
              const SizedBox(width: 8),
              _buildFilterChip('tense', '${AppStrings.tr('hangul_filter_tense', _langCode)} (4)', isDark),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Helpful Tip Banner
        _buildTipBanner(isDark),
        const SizedBox(height: 14),

        // Letter Cards Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.81,
          ),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            return _buildHangulCard(filtered[index], isDark);
          },
        ),
      ],
    );
  }

  Widget _buildFilterChip(String filterKey, String label, bool isDark) {
    final isSelected = _consonantFilter == filterKey;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _consonantFilter = filterKey);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2563EB)
                : (isDark ? const Color(0xFF1E293B) : Colors.white),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.28),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : [],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Text('💡', style: TextStyle(fontSize: 17)),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              AppStrings.tr('hangul_tip_tap_audio', _langCode),
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVowelGrid(List<HangulLetter> letters, bool isDark) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 88),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildTipBanner(isDark),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.81,
          ),
          itemCount: letters.length,
          itemBuilder: (context, index) {
            return _buildHangulCard(letters[index], isDark);
          },
        ),
      ],
    );
  }

  Widget _buildHangulCard(HangulLetter item, bool isDark) {
    final isPlaying = _currentlyPlayingLetter == item.letter;

    // Category type styling
    final Color badgeBg;
    final Color badgeBorder;
    final Color badgeText;
    final String typeTag = HangulData.getCategoryTag(item.categoryType, _langCode);

    switch (item.categoryType) {
      case 'aspirated':
        badgeBg = isDark ? const Color(0xFF3B1F4E) : const Color(0xFFF3E8FF);
        badgeBorder = isDark ? const Color(0xFF9333EA) : const Color(0xFFD8B4FE);
        badgeText = isDark ? const Color(0xFFD8B4FE) : const Color(0xFF7E22CE);
        break;
      case 'tense':
        badgeBg = isDark ? const Color(0xFF4C1D1D) : const Color(0xFFFFF1F2);
        badgeBorder = isDark ? const Color(0xFFE11D48) : const Color(0xFFFECDD3);
        badgeText = isDark ? const Color(0xFFFDA4AF) : const Color(0xFFBE123C);
        break;
      case 'vowel':
        badgeBg = isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5);
        badgeBorder = isDark ? const Color(0xFF059669) : const Color(0xFFA7F3D0);
        badgeText = isDark ? const Color(0xFF6EE7B7) : const Color(0xFF047857);
        break;
      default:
        badgeBg = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF);
        badgeBorder = isDark ? const Color(0xFF2563EB) : const Color(0xFFBFDBFE);
        badgeText = isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _playLetterAudio(item.letter, item.exampleKorean),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isPlaying
                  ? const Color(0xFF2563EB)
                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: isPlaying ? 2.2 : 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: (isPlaying
                        ? const Color(0xFF2563EB)
                        : (isDark ? Colors.black : const Color(0xFF64748B)))
                    .withValues(alpha: isPlaying ? 0.38 : (isDark ? 0.35 : 0.07)),
                blurRadius: isPlaying ? 14 : 9,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Row: Category Type Badge & Sound Pill
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: badgeBorder, width: 1),
                      ),
                      child: Text(
                        typeTag,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: badgeText,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 3),
                    decoration: BoxDecoration(
                      color: isPlaying
                          ? const Color(0xFF2563EB)
                          : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isPlaying) ...[
                          const Icon(Icons.volume_up_rounded, size: 12, color: Colors.white),
                          const SizedBox(width: 3),
                        ],
                        Text(
                          item.sound,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: isPlaying
                                ? Colors.white
                                : (isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Center: Big Hangul Character with Letter Name & Audio Indicator
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.letter,
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      color: isPlaying
                          ? const Color(0xFF2563EB)
                          : (isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A)),
                      letterSpacing: -1,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Letter's Official Korean Name + Audio Indicator
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
                        ),
                      ),
                      if (isPlaying) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.volume_up_rounded,
                          size: 14,
                          color: Color(0xFF2563EB),
                        ),
                      ],
                    ],
                  ),
                ],
              ),

              // Phonetic Sound Tip (Localized for selected language)
              Text(
                item.getSoundTip(_langCode),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),

              // Bottom Example Word Strip
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.emoji, style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        '${item.exampleKorean} · ${item.getMeaning(_langCode)}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B),
                        ),
                      ),
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

  String _getStepTitle(int step) {
    switch (step) {
      case 1:
        switch (_langCode) {
          case 'KO': return '초성 (첫소리 자음)';
          case 'VI': return 'Phụ âm đầu (Âm đầu)';
          case 'ZH': return '初声 (首辅音)';
          case 'JA': return '初声 (最初の子音)';
          default: return 'Initial Consonant';
        }
      case 2:
        switch (_langCode) {
          case 'KO': return '중성 (가운데 모음)';
          case 'VI': return 'Nguyên âm giữa (Âm giữa)';
          case 'ZH': return '中声 (中间元音)';
          case 'JA': return '中声 (真ん中の母音)';
          default: return 'Medial Vowel';
        }
      case 3:
      default:
        switch (_langCode) {
          case 'KO': return '종성 (받침 자음)';
          case 'VI': return 'Phụ âm cuối (Batchim)';
          case 'ZH': return '终声 (收音 Batchim)';
          case 'JA': return '終声 (パッチム)';
          default: return 'Final Consonant (Batchim)';
        }
    }
  }

  String _getStepSub(int step) {
    switch (step) {
      case 1:
        switch (_langCode) {
          case 'KO': return '14개 기본 자음 중 하나를 골라보세요';
          case 'VI': return 'Chọn 1 trong 14 phụ âm cơ bản';
          case 'ZH': return '选择14个基础辅音之一';
          case 'JA': return '14個の基本子音から選択';
          default: return 'Choose 1 of 14 basic consonants';
        }
      case 2:
        switch (_langCode) {
          case 'KO': return '12개 모음으로 소리를 완성하세요';
          case 'VI': return 'Chọn 1 trong 12 nguyên âm';
          case 'ZH': return '选择12个核心元音之一';
          case 'JA': return '12個の母音から選択';
          default: return 'Choose 1 of 12 medial vowels';
        }
      case 3:
      default:
        switch (_langCode) {
          case 'KO': return '음절 아래에 받쳐지는 받침 (선택)';
          case 'VI': return 'Phụ âm bên dưới âm tiết (Tùy chọn)';
          case 'ZH': return '字块底部的收音（可不选）';
          case 'JA': return '文字の下に付くパッチム (任意)';
          default: return 'Bottom consonant of the block (Optional)';
        }
    }
  }

  String _getNoneLabel() {
    switch (_langCode) {
      case 'KO': return 'ø 없음';
      case 'VI': return 'ø Không';
      case 'ZH': return 'ø 无';
      case 'JA': return 'ø なし';
      default: return 'ø None';
    }
  }

  String _getBlockLabel(int blockType) {
    switch (blockType) {
      case 1:
        switch (_langCode) {
          case 'KO': return '초성';
          case 'VI': return 'Âm đầu';
          case 'ZH': return '初声';
          case 'JA': return '初声';
          default: return 'Initial';
        }
      case 2:
        switch (_langCode) {
          case 'KO': return '중성';
          case 'VI': return 'Âm giữa';
          case 'ZH': return '中声';
          case 'JA': return '中声';
          default: return 'Medial';
        }
      case 3:
      default:
        switch (_langCode) {
          case 'KO': return '받침';
          case 'VI': return 'Batchim';
          case 'ZH': return '收音';
          case 'JA': return 'パッチム';
          default: return 'Final';
        }
    }
  }

  Widget _buildSyllableBuilderView(bool isDark) {
    final currentSyllable = _buildCurrentSyllable();
    final romanized = KoreanRomanizer.romanize(currentSyllable);
    final discoveredWord = HangulData.discoveredWords[currentSyllable];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🔬 Top Syllable Lab Showcase Stage (Compact & Modern)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [const Color(0xFFF0F7FF), Colors.white],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
                width: 1.3,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : const Color(0xFF2563EB))
                      .withValues(alpha: isDark ? 0.35 : 0.07),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top Header Row with View Mode Switcher
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔬', style: TextStyle(fontSize: 13)),
                          const SizedBox(width: 5),
                          Text(
                            AppStrings.tr('hangul_block_title', _langCode),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Quick View Mode Switcher Button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _isAllInOneView = !_isAllInOneView);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isAllInOneView ? Icons.tab_rounded : Icons.dashboard_customize_rounded,
                                size: 14,
                                color: const Color(0xFF2563EB),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _isAllInOneView
                                    ? (_langCode == 'KO' ? '탭 모드' : 'Tab View')
                                    : (_langCode == 'KO' ? '전체 펼치기' : 'All in One'),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
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
                const SizedBox(height: 12),

                // Dynamic Combination Formula Equation (Overflow-proof)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Initial Consonant (초성 - Blue)
                        _buildBlockChip(
                          _builderInitials[_selectedInitialIdx],
                          _getBlockLabel(1),
                          const Color(0xFF2563EB),
                          1,
                          isDark,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '+',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                        // Medial Vowel (중성 - Purple)
                        _buildBlockChip(
                          _builderVowels[_selectedVowelIdx],
                          _getBlockLabel(2),
                          const Color(0xFF7C3AED),
                          2,
                          isDark,
                        ),
                        if (_builderFinals[_selectedFinalIdx].isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '+',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                          // Final Consonant (종성/받침 - Emerald)
                          _buildBlockChip(
                            _builderFinals[_selectedFinalIdx],
                            _getBlockLabel(3),
                            const Color(0xFF059669),
                            3,
                            isDark,
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '=',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                        // Result Combined Syllable Button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              TtsService().speak(currentSyllable, isSlow: _isSlowAudio);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    currentSyllable,
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.volume_up_rounded, color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Pronunciation chip & Listen row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
                        ),
                      ),
                      child: Text(
                        '[$romanized]',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w900,
                          color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1D4ED8),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 1,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        TtsService().speak(currentSyllable, isSlow: _isSlowAudio);
                      },
                      icon: const Icon(Icons.volume_up_rounded, size: 16),
                      label: Text(
                        AppStrings.tr('wotd_listen', _langCode),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),

                // 🎉 Discovered Word Banner (Compact & Delightful)
                if (discoveredWord != null) ...[
                  const SizedBox(height: 10),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        TtsService().speak(discoveredWord.word, isSlow: _isSlowAudio);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [const Color(0xFF064E3B), const Color(0xFF047857)]
                                : [const Color(0xFFECFDF5), const Color(0xFFD1FAE5)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF10B981),
                            width: 1.4,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(discoveredWord.emoji, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '🎉 ${discoveredWord.word} [${discoveredWord.roman}] : ${discoveredWord.getMeaning(_langCode)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? Colors.white : const Color(0xFF064E3B),
                                ),
                              ),
                            ),
                            const Icon(Icons.volume_up_rounded, size: 18, color: Color(0xFF10B981)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 🎛️ CONTROLLER AREA: 100% Zero-Scroll Segmented Studio or All-in-One View
          if (!_isAllInOneView) ...[
            // 3-Segment Selector Bar (Step 1 초성 | Step 2 중성 | Step 3 받침)
            Row(
              children: [
                Expanded(
                  child: _buildStepSegmentTab(
                    stepNumber: 1,
                    title: _getBlockLabel(1),
                    activeLetter: _builderInitials[_selectedInitialIdx],
                    themeColor: const Color(0xFF2563EB),
                    isActive: _activeBuilderStep == 1,
                    isDark: isDark,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _activeBuilderStep = 1);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStepSegmentTab(
                    stepNumber: 2,
                    title: _getBlockLabel(2),
                    activeLetter: _builderVowels[_selectedVowelIdx],
                    themeColor: const Color(0xFF7C3AED),
                    isActive: _activeBuilderStep == 2,
                    isDark: isDark,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _activeBuilderStep = 2);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStepSegmentTab(
                    stepNumber: 3,
                    title: _getBlockLabel(3),
                    activeLetter: _builderFinals[_selectedFinalIdx].isEmpty
                        ? 'ø'
                        : _builderFinals[_selectedFinalIdx],
                    themeColor: const Color(0xFF059669),
                    isActive: _activeBuilderStep == 3,
                    isDark: isDark,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _activeBuilderStep = 3);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Active Step Keyboard Pad (Takes minimal height, fits entirely on 1 screen)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? Colors.black : const Color(0xFF64748B))
                        .withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step Title & Helper Text
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getActiveThemeColor(),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'STEP $_activeBuilderStep',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getStepSub(_activeBuilderStep),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Button Pad Grid
                  Wrap(
                    spacing: 7.5,
                    runSpacing: 7.5,
                    children: _buildActivePadButtons(isDark),
                  ),
                ],
              ),
            ),
          ] else ...[
            // All-in-One Compact View (All 3 rows visible simultaneously)
            _buildCompactAllInOneSection(1, _getStepTitle(1), _builderInitials, _selectedInitialIdx, const Color(0xFF2563EB), false, isDark),
            const SizedBox(height: 12),
            _buildCompactAllInOneSection(2, _getStepTitle(2), _builderVowels, _selectedVowelIdx, const Color(0xFF7C3AED), false, isDark),
            const SizedBox(height: 12),
            _buildCompactAllInOneSection(3, _getStepTitle(3), _builderFinals, _selectedFinalIdx, const Color(0xFF059669), true, isDark),
          ],
        ],
      ),
    );
  }

  Color _getActiveThemeColor() {
    switch (_activeBuilderStep) {
      case 1:
        return const Color(0xFF2563EB);
      case 2:
        return const Color(0xFF7C3AED);
      case 3:
      default:
        return const Color(0xFF059669);
    }
  }

  Widget _buildStepSegmentTab({
    required int stepNumber,
    required String title,
    required String activeLetter,
    required Color themeColor,
    required bool isActive,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isActive
                ? themeColor.withValues(alpha: isDark ? 0.22 : 0.12)
                : (isDark ? const Color(0xFF1E293B) : Colors.white),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? themeColor
                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: isActive ? 2 : 1.1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: themeColor.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Text(
                'STEP $stepNumber · $title',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: isActive
                      ? themeColor
                      : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                activeLetter,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: isActive
                      ? themeColor
                      : (isDark ? Colors.white : const Color(0xFF0F172A)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActivePadButtons(bool isDark) {
    final themeColor = _getActiveThemeColor();
    final List<String> options;
    final int selectedIdx;
    final bool isFinal = _activeBuilderStep == 3;

    if (_activeBuilderStep == 1) {
      options = _builderInitials;
      selectedIdx = _selectedInitialIdx;
    } else if (_activeBuilderStep == 2) {
      options = _builderVowels;
      selectedIdx = _selectedVowelIdx;
    } else {
      options = _builderFinals;
      selectedIdx = _selectedFinalIdx;
    }

    return List.generate(options.length, (idx) {
      final isSelected = idx == selectedIdx;
      final isNoneOption = isFinal && idx == 0;
      final label = isNoneOption ? _getNoneLabel() : options[idx];

      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() {
              if (_activeBuilderStep == 1) {
                _selectedInitialIdx = idx;
              } else if (_activeBuilderStep == 2) {
                _selectedVowelIdx = idx;
              } else {
                _selectedFinalIdx = idx;
              }
            });
            TtsService().speak(_buildCurrentSyllable(), isSlow: _isSlowAudio);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            constraints: BoxConstraints(
              minWidth: isNoneOption ? 70 : 42,
              minHeight: 42,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isNoneOption ? 10 : 8,
              vertical: 8,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [themeColor, themeColor.withValues(alpha: 0.85)],
                    )
                  : null,
              color: isSelected
                  ? null
                  : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? themeColor
                    : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                width: isSelected ? 1.8 : 1.1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: themeColor.withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: isNoneOption ? 11.5 : 16,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                color: isSelected
                    ? Colors.white
                    : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155)),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCompactAllInOneSection(
    int step,
    String title,
    List<String> options,
    int selectedIdx,
    Color themeColor,
    bool isFinal,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6.5, vertical: 2),
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'STEP $step',
                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
              const SizedBox(width: 7),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(options.length, (idx) {
              final isSelected = idx == selectedIdx;
              final isNoneOption = isFinal && idx == 0;
              final label = isNoneOption ? _getNoneLabel() : options[idx];

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      if (step == 1) _selectedInitialIdx = idx;
                      if (step == 2) _selectedVowelIdx = idx;
                      if (step == 3) _selectedFinalIdx = idx;
                    });
                    TtsService().speak(_buildCurrentSyllable(), isSlow: _isSlowAudio);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    constraints: BoxConstraints(
                      minWidth: isNoneOption ? 64 : 38,
                      minHeight: 38,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isNoneOption ? 8 : 6,
                      vertical: 6,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? themeColor
                          : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? themeColor
                            : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                      ),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: isNoneOption ? 11 : 15,
                        fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockChip(String letter, String label, Color accentColor, int targetStep, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            _activeBuilderStep = targetStep;
            _isAllInOneView = false;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.65),
                  width: 1.6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: isDark ? 0.25 : 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.5, vertical: 1.5),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🎧 Mini 5-Question Audio Quiz Modal
  void _showMiniListeningQuiz(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _HangulMiniQuizModal(langCode: _langCode, isDark: isDark),
    );
  }
}

// -------------------------------------------------------------
// 🎧 LUXURIOUS HANGUL SOUND QUIZ MODAL
// -------------------------------------------------------------
class _HangulMiniQuizModal extends StatefulWidget {
  final String langCode;
  final bool isDark;

  const _HangulMiniQuizModal({required this.langCode, required this.isDark});

  @override
  State<_HangulMiniQuizModal> createState() => _HangulMiniQuizModalState();
}

class _HangulMiniQuizModalState extends State<_HangulMiniQuizModal> {
  int _questionIdx = 0;
  int _score = 0;
  int? _selectedChoice;
  bool _isAnswered = false;
  bool _isSlowAudio = false;

  late final List<Map<String, dynamic>> _allPool;
  late List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();
    _initQuizPool();
    _startNewSession();
  }

  void _initQuizPool() {
    _allPool = [
      // Consonants
      {
        'target': 'ㄱ',
        'soundLabel': '기역 [g / k]',
        'meaning': '가방 (Bag)',
        'options': ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ'],
      },
      {
        'target': 'ㄴ',
        'soundLabel': '니은 [n]',
        'meaning': '나무 (Tree)',
        'options': ['ㄴ', 'ㄷ', 'ㅁ', 'ㄹ'],
      },
      {
        'target': 'ㄷ',
        'soundLabel': '디귿 [d / t]',
        'meaning': '다리 (Bridge / Leg)',
        'options': ['ㄷ', 'ㅌ', 'ㄸ', 'ㅂ'],
      },
      {
        'target': 'ㄹ',
        'soundLabel': '리을 [r / l]',
        'meaning': '라면 (Ramen)',
        'options': ['ㄹ', 'ㄴ', 'ㅁ', 'ㅇ'],
      },
      {
        'target': 'ㅁ',
        'soundLabel': '미음 [m]',
        'meaning': '모자 (Hat)',
        'options': ['ㅁ', 'ㅂ', 'ㅇ', 'ㄴ'],
      },
      {
        'target': 'ㅂ',
        'soundLabel': '비읍 [b / p]',
        'meaning': '바나나 (Banana)',
        'options': ['ㅂ', 'ㅍ', 'ㅃ', 'ㅁ'],
      },
      {
        'target': 'ㅅ',
        'soundLabel': '시옷 [s]',
        'meaning': '사자 (Lion)',
        'options': ['ㅅ', 'ㅆ', 'ㅈ', 'ㅊ'],
      },
      {
        'target': 'ㅇ',
        'soundLabel': '이응 [silent / ng]',
        'meaning': '아기 (Baby)',
        'options': ['ㅇ', 'ㅁ', 'ㅎ', 'ㅂ'],
      },
      {
        'target': 'ㅈ',
        'soundLabel': '지읒 [j]',
        'meaning': '지도 (Map)',
        'options': ['ㅈ', 'ㅊ', 'ㅉ', 'ㅅ'],
      },
      {
        'target': 'ㅊ',
        'soundLabel': '치읓 [ch]',
        'meaning': '치마 (Skirt)',
        'options': ['ㅊ', 'ㅈ', 'ㅉ', 'ㅋ'],
      },
      {
        'target': 'ㅋ',
        'soundLabel': '키읔 [k]',
        'meaning': '카메라 (Camera)',
        'options': ['ㅋ', 'ㄱ', 'ㄲ', 'ㅌ'],
      },
      {
        'target': 'ㅌ',
        'soundLabel': '티읕 [t]',
        'meaning': '토마토 (Tomato)',
        'options': ['ㅌ', 'ㄷ', 'ㄸ', 'ㅋ'],
      },
      {
        'target': 'ㅍ',
        'soundLabel': '피읖 [p]',
        'meaning': '포도 (Grape)',
        'options': ['ㅍ', 'ㅂ', 'ㅃ', 'ㅎ'],
      },
      {
        'target': 'ㅎ',
        'soundLabel': '히읗 [h]',
        'meaning': '하늘 (Sky)',
        'options': ['ㅎ', 'ㅇ', 'ㅋ', 'ㅌ'],
      },
      // Double Consonants
      {
        'target': 'ㄲ',
        'soundLabel': '쌍기역 [kk]',
        'meaning': '꼬리 (Tail)',
        'options': ['ㄲ', 'ㄱ', 'ㅋ', 'ㄸ'],
      },
      {
        'target': 'ㄸ',
        'soundLabel': '쌍디귿 [tt]',
        'meaning': '딸기 (Strawberry)',
        'options': ['ㄸ', 'ㄷ', 'ㅌ', 'ㅃ'],
      },
      {
        'target': 'ㅃ',
        'soundLabel': '쌍비읍 [pp]',
        'meaning': '뿌리 (Root)',
        'options': ['ㅃ', 'ㅂ', 'ㅍ', 'ㅉ'],
      },
      {
        'target': 'ㅆ',
        'soundLabel': '쌍시옷 [ss]',
        'meaning': '쓰레기 (Trash)',
        'options': ['ㅆ', 'ㅅ', 'ㅉ', 'ㅈ'],
      },
      {
        'target': 'ㅉ',
        'soundLabel': '쌍지읒 [jj]',
        'meaning': '찌개 (Stew)',
        'options': ['ㅉ', 'ㅈ', 'ㅊ', 'ㅃ'],
      },
      // Vowels
      {
        'target': 'ㅏ',
        'soundLabel': 'ㅏ [a]',
        'meaning': '아이 (Child)',
        'options': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ'],
      },
      {
        'target': 'ㅓ',
        'soundLabel': 'ㅓ [eo]',
        'meaning': '어머니 (Mother)',
        'options': ['ㅓ', 'ㅏ', 'ㅗ', 'ㅕ'],
      },
      {
        'target': 'ㅗ',
        'soundLabel': 'ㅗ [o]',
        'meaning': '오이 (Cucumber)',
        'options': ['ㅗ', 'ㅜ', 'ㅡ', 'ㅛ'],
      },
      {
        'target': 'ㅜ',
        'soundLabel': 'ㅜ [u]',
        'meaning': '우유 (Milk)',
        'options': ['ㅜ', 'ㅗ', 'ㅠ', 'ㅡ'],
      },
      {
        'target': 'ㅡ',
        'soundLabel': 'ㅡ [eu]',
        'meaning': '음식 (Food)',
        'options': ['ㅡ', 'ㅣ', 'ㅜ', 'ㅓ'],
      },
      {
        'target': 'ㅣ',
        'soundLabel': 'ㅣ [i]',
        'meaning': '이름 (Name)',
        'options': ['ㅣ', 'ㅡ', 'ㅏ', 'ㅓ'],
      },
      {
        'target': 'ㅐ',
        'soundLabel': 'ㅐ [ae]',
        'meaning': '배 (Pear / Ship)',
        'options': ['ㅐ', 'ㅔ', 'ㅒ', 'ㅖ'],
      },
      {
        'target': 'ㅔ',
        'soundLabel': 'ㅔ [e]',
        'meaning': '베개 (Pillow)',
        'options': ['ㅔ', 'ㅐ', 'ㅖ', 'ㅢ'],
      },
      // Real 1-Syllable Words
      {
        'target': '물',
        'soundLabel': '물 [mul]',
        'meaning': '💧 물 (Water)',
        'options': ['물', '불', '발', '말'],
      },
      {
        'target': '밥',
        'soundLabel': '밥 [bap]',
        'meaning': '🍚 밥 (Rice / Meal)',
        'options': ['밥', '방', '밤', '봄'],
      },
      {
        'target': '강',
        'soundLabel': '강 [gang]',
        'meaning': '🌊 강 (River)',
        'options': ['강', '산', '달', '길'],
      },
      {
        'target': '불',
        'soundLabel': '불 [bul]',
        'meaning': '🔥 불 (Fire / Light)',
        'options': ['불', '물', '풀', '발'],
      },
      {
        'target': '산',
        'soundLabel': '산 [san]',
        'meaning': '⛰️ 산 (Mountain)',
        'options': ['산', '강', '달', '눈'],
      },
      {
        'target': '달',
        'soundLabel': '달 [dal]',
        'meaning': '🌙 달 (Moon)',
        'options': ['달', '별', '해', '산'],
      },
      {
        'target': '눈',
        'soundLabel': '눈 [nun]',
        'meaning': '❄️ 눈 (Snow / Eye)',
        'options': ['눈', '손', '발', '문'],
      },
      {
        'target': '손',
        'soundLabel': '손 [son]',
        'meaning': '✋ 손 (Hand)',
        'options': ['손', '눈', '발', '돈'],
      },
      {
        'target': '발',
        'soundLabel': '발 [bal]',
        'meaning': '🦶 발 (Foot)',
        'options': ['발', '손', '팔', '말'],
      },
      {
        'target': '집',
        'soundLabel': '집 [jip]',
        'meaning': '🏠 집 (House)',
        'options': ['집', '방', '문', '길'],
      },
      {
        'target': '길',
        'soundLabel': '길 [gil]',
        'meaning': '🛣️ 길 (Road)',
        'options': ['길', '집', '산', '달'],
      },
      {
        'target': '꽃',
        'soundLabel': '꽃 [kkot]',
        'meaning': '🌸 꽃 (Flower)',
        'options': ['꽃', '꿈', '끝', '별'],
      },
      {
        'target': '봄',
        'soundLabel': '봄 [bom]',
        'meaning': '🌸 봄 (Spring)',
        'options': ['봄', '밤', '곰', '몸'],
      },
    ];
  }

  void _startNewSession() {
    final random = math.Random();
    final shuffled = List<Map<String, dynamic>>.from(_allPool)..shuffle(random);
    _questions = shuffled.take(5).toList();
    _questionIdx = 0;
    _score = 0;
    _selectedChoice = null;
    _isAnswered = false;

    Future.microtask(() {
      if (mounted) _playCurrentAudio();
    });
  }

  void _playCurrentAudio() {
    if (_questionIdx < _questions.length) {
      final q = _questions[_questionIdx];
      TtsService().speak(q['target'] as String, isSlow: _isSlowAudio);
    }
  }

  void _onChoiceSelected(int idx) {
    if (_isAnswered) return;
    final q = _questions[_questionIdx];
    final options = q['options'] as List<String>;
    final isCorrect = options[idx] == q['target'];

    if (isCorrect) {
      HapticFeedback.lightImpact();
      _score++;
    } else {
      HapticFeedback.heavyImpact();
    }

    setState(() {
      _selectedChoice = idx;
      _isAnswered = true;
    });
  }

  void _nextQuestion() {
    if (_questionIdx < _questions.length - 1) {
      setState(() {
        _questionIdx++;
        _selectedChoice = null;
        _isAnswered = false;
      });
      _playCurrentAudio();
    } else {
      setState(() {
        _questionIdx++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final screenHeight = MediaQuery.of(context).size.height;
    final modalHeight = (screenHeight * 0.78).clamp(480.0, 620.0);

    return Container(
      height: modalHeight,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.2),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 44,
              height: 4.5,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Header Bar (100% Overflow-proof on all screen sizes)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.headphones_rounded,
                  color: Color(0xFF2563EB),
                  size: 19,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppStrings.tr('hangul_mini_quiz_title', widget.langCode),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Audio Speed Toggle
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _isSlowAudio = !_isSlowAudio);
                    _playCurrentAudio();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.5, vertical: 5),
                    decoration: BoxDecoration(
                      color: _isSlowAudio
                          ? const Color(0xFF10B981).withValues(alpha: 0.18)
                          : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _isSlowAudio
                            ? const Color(0xFF10B981)
                            : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_isSlowAudio ? '🐢' : '🐰', style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 3.5),
                        Text(
                          _isSlowAudio ? '0.7x' : '1.0x',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: _isSlowAudio
                                ? const Color(0xFF10B981)
                                : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Stepper Progress Pills
          if (_questionIdx < _questions.length) ...[
            Row(
              children: List.generate(_questions.length, (idx) {
                final isDone = idx < _questionIdx;
                final isCurrent = idx == _questionIdx;
                return Expanded(
                  child: Container(
                    height: 5.5,
                    margin: EdgeInsets.only(right: idx < _questions.length - 1 ? 6 : 0),
                    decoration: BoxDecoration(
                      color: isDone
                          ? const Color(0xFF10B981)
                          : (isCurrent
                              ? const Color(0xFF2563EB)
                              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),

            // Middle Content: Speaker + Options
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      // Hero Audio Center Stage
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF2563EB).withValues(alpha: isDark ? 0.15 : 0.08),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(38),
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    _playCurrentAudio();
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                                          blurRadius: 16,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 34),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.tr('hangul_mini_quiz_desc', widget.langCode),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '🔊 탭하여 다시 듣기 (Tap to listen again)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // 4 Options Grid (2x2)
                      Builder(builder: (context) {
                        final q = _questions[_questionIdx];
                        final options = q['options'] as List<String>;
                        final target = q['target'] as String;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2.1,
                          ),
                          itemCount: options.length,
                          itemBuilder: (context, idx) {
                            final opt = options[idx];
                            final isChosen = _selectedChoice == idx;
                            final isTarget = opt == target;

                            Color bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
                            Color border = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
                            Color text = isDark ? Colors.white : const Color(0xFF0F172A);
                            Widget? statusIcon;

                            if (_isAnswered) {
                              if (isTarget) {
                                bg = const Color(0xFF10B981).withValues(alpha: 0.18);
                                border = const Color(0xFF10B981);
                                text = const Color(0xFF10B981);
                                statusIcon = const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20);
                              } else if (isChosen && !isTarget) {
                                bg = const Color(0xFFEF4444).withValues(alpha: 0.18);
                                border = const Color(0xFFEF4444);
                                text = const Color(0xFFEF4444);
                                statusIcon = const Icon(Icons.cancel_rounded, color: Color(0xFFEF4444), size: 20);
                              }
                            }

                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => _onChoiceSelected(idx),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: bg,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: border,
                                      width: (isChosen || (isTarget && _isAnswered)) ? 2.2 : 1.4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (isDark ? Colors.black : const Color(0xFF64748B))
                                            .withValues(alpha: isDark ? 0.2 : 0.05),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          opt,
                                          style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w900,
                                            color: text,
                                          ),
                                        ),
                                      ),
                                      if (statusIcon != null) ...[
                                        const SizedBox(width: 6),
                                        statusIcon,
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Fixed Bottom Action Area (Always takes exact same height)
            SizedBox(
              height: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isAnswered) ...[
                    // Educational Feedback Strip when Answered
                    Builder(builder: (context) {
                      final q = _questions[_questionIdx];
                      final target = q['target'] as String;
                      final soundLabel = q['soundLabel'] as String;
                      final meaning = q['meaning'] as String;
                      final isCorrect = (_selectedChoice != null) &&
                          (q['options'][_selectedChoice!] == target);

                      return Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isCorrect
                              ? const Color(0xFF10B981).withValues(alpha: 0.14)
                              : const Color(0xFFEF4444).withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              isCorrect ? '🎉' : '💡',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isCorrect
                                        ? AppStrings.tr('quiz_correct_feedback', widget.langCode)
                                        : "${AppStrings.tr('quiz_correct_answer_label', widget.langCode)} '$target'",
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w900,
                                      color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                                    ),
                                  ),
                                  Text(
                                    '$soundLabel · $meaning',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.volume_up_rounded, size: 20),
                              color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: _playCurrentAudio,
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                        ),
                        onPressed: _nextQuestion,
                        child: Text(
                          _questionIdx == _questions.length - 1
                              ? AppStrings.tr('quiz_see_results', widget.langCode)
                              : '${AppStrings.tr('quiz_next_question', widget.langCode)} ➔',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Pre-Answer Guide Prompt Container (occupies exact same height)
                    Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A).withValues(alpha: 0.5) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('👆', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              widget.langCode == 'KO'
                                  ? '소리를 듣고 정답 보기를 선택하세요'
                                  : (widget.langCode == 'VI'
                                      ? 'Nghe âm thanh và chọn đáp án đúng'
                                      : (widget.langCode == 'ZH'
                                          ? '仔细收听发音并选择正确答案'
                                          : (widget.langCode == 'JA'
                                              ? '音声を聞いて正しい文字を選んでください'
                                              : 'Listen to the sound and choose the answer'))),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        onPressed: null,
                        child: Text(
                          widget.langCode == 'KO'
                              ? '보기를 선택해 주세요'
                              : (widget.langCode == 'VI'
                                  ? 'Vui lòng chọn đáp án'
                                  : (widget.langCode == 'ZH'
                                      ? '请选择选项'
                                      : (widget.langCode == 'JA'
                                          ? '選択肢を選んでください'
                                          : 'Please select an option'))),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isDark ? const Color(0xFF64748B) : Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ] else ...[
            // Result View fills the Expanded height cleanly (Scrollable on small devices)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _score == 5 ? '🏆' : (_score >= 3 ? '🌟' : '💪'),
                        style: const TextStyle(fontSize: 58),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      AppStrings.tr('hangul_quiz_score', widget.langCode)
                          .replaceAll('{score}', '$_score'),
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _score == 5
                          ? (widget.langCode == 'KO'
                              ? '완벽해요! 원어민의 귀를 가지셨네요! 💯'
                              : (widget.langCode == 'VI'
                                  ? 'Tuyệt vời! Bạn có đôi tai bản xứ! 💯'
                                  : (widget.langCode == 'ZH'
                                      ? '太棒了！拥有母语者般的听力！💯'
                                      : (widget.langCode == 'JA'
                                          ? '完璧です！ネイティブの耳を持っています！💯'
                                          : 'Perfect! You have a native ear! 💯'))))
                          : (_score >= 3
                              ? (widget.langCode == 'KO'
                                  ? '대단해요! 소리를 잘 구분하고 있어요! 👏'
                                  : (widget.langCode == 'VI'
                                      ? 'Rất giỏi! Bạn phân biệt âm rất tốt! 👏'
                                      : (widget.langCode == 'ZH'
                                          ? '很棒！发音辨析非常准确！👏'
                                          : (widget.langCode == 'JA'
                                              ? '素晴らしい！音をしっかり聞き分けられています！👏'
                                              : 'Great job! You distinguish sounds well! 👏'))))
                              : (widget.langCode == 'KO'
                                  ? '다시 한 번 도전해서 만점에 도전해 보세요! 🔥'
                                  : (widget.langCode == 'VI'
                                      ? 'Hãy thử lại để đạt điểm tối đa nhé! 🔥'
                                      : (widget.langCode == 'ZH'
                                          ? '再试一次，争取拿到满分！🔥'
                                          : (widget.langCode == 'JA'
                                              ? 'もう一度挑戦して満点を目指しましょう！🔥'
                                              : 'Try again for a perfect score! 🔥'))))),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF10B981), width: 1.2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('✨', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            widget.langCode == 'KO'
                                ? '+50 XP 보너스 획득!'
                                : (widget.langCode == 'VI'
                                    ? '+50 Điểm thưởng XP!'
                                    : (widget.langCode == 'ZH'
                                        ? '+50 奖励 XP！'
                                        : (widget.langCode == 'JA'
                                            ? '+50 XP ボーナス獲得！'
                                            : '+50 Bonus XP Earned!'))),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              setState(() {
                                _startNewSession();
                              });
                            },
                            child: Text(
                              '${AppStrings.tr('result_retry', widget.langCode)} 🔄',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 2,
                            ),
                            onPressed: () {
                              ProgressService().recordAnswer(9999, true); // give bonus progress
                              Navigator.pop(context);
                            },
                            child: Text(
                              '${AppStrings.tr('result_home', widget.langCode)} ✨',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        ],
      ),
    );
  }
}
