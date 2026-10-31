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

  static const List<String> _builderInitials = ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'];
  static const List<String> _builderVowels = ['ㅏ', 'ㅑ', 'ㅓ', 'ㅕ', 'ㅗ', 'ㅛ', 'ㅜ', 'ㅠ', 'ㅡ', 'ㅣ', 'ㅐ', 'ㅔ'];
  static const List<String> _builderFinals = ['', 'ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ'];

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
        toolbarHeight: 62,
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
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            Text(
              AppStrings.tr('hangul_sub', _langCode),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        actions: [
          // Audio Speed Toggle (Normal / Slow 🐢)
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _isSlowAudio = !_isSlowAudio);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5.5),
                  decoration: BoxDecoration(
                    color: _isSlowAudio
                        ? const Color(0xFF10B981).withValues(alpha: 0.15)
                        : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _isSlowAudio
                          ? const Color(0xFF10B981)
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_isSlowAudio ? '🐢' : '🐰', style: const TextStyle(fontSize: 13)),
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
            padding: const EdgeInsets.only(right: 12.0),
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
                _buildPopupItem('ES', '🇪🇸 Español', isDark),
                _buildPopupItem('PT', '🇵🇹 Português', isDark),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5.5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
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
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: const Color(0xFF2563EB),
              indicatorWeight: 3,
              labelColor: const Color(0xFF2563EB),
              unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF2563EB),
        elevation: 6,
        icon: const Icon(Icons.headphones_rounded, color: Colors.white, size: 20),
        label: Text(
          AppStrings.tr('hangul_mini_quiz_btn', _langCode),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
            color: Colors.white,
            letterSpacing: -0.2,
          ),
        ),
        onPressed: () => _showMiniListeningQuiz(context, isDark),
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
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      children: [
        // Consonant Triad Filter Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildFilterChip('all', AppStrings.tr('hangul_filter_all', _langCode), isDark),
              const SizedBox(width: 6),
              _buildFilterChip('plain', AppStrings.tr('hangul_filter_plain', _langCode), isDark),
              const SizedBox(width: 6),
              _buildFilterChip('aspirated', AppStrings.tr('hangul_filter_aspirated', _langCode), isDark),
              const SizedBox(width: 6),
              _buildFilterChip('tense', AppStrings.tr('hangul_filter_tense', _langCode), isDark),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Helpful Tip Banner with Audio Speed Toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
            ),
          ),
          child: Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppStrings.tr('hangul_tip_tap_audio', _langCode),
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Letter Cards Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.88,
          ),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final item = filtered[index];
            return _buildHangulCard(item, isDark);
          },
        ),
      ],
    );
  }

  Widget _buildFilterChip(String filterKey, String label, bool isDark) {
    final isSelected = _consonantFilter == filterKey;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _consonantFilter = filterKey),
      selectedColor: const Color(0xFF2563EB),
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      labelStyle: TextStyle(
        fontSize: 12.5,
        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
        color: isSelected ? Colors.white : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
      ),
      side: BorderSide(
        color: isSelected ? const Color(0xFF2563EB) : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  Widget _buildVowelGrid(List<HangulLetter> letters, bool isDark) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
            ),
          ),
          child: Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppStrings.tr('hangul_tip_tap_audio', _langCode),
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.88,
          ),
          itemCount: letters.length,
          itemBuilder: (context, index) {
            final item = letters[index];
            return _buildHangulCard(item, isDark);
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
    final String typeTag;

    switch (item.categoryType) {
      case 'aspirated':
        badgeBg = isDark ? const Color(0xFF3B1F4E) : const Color(0xFFF3E8FF);
        badgeBorder = isDark ? const Color(0xFF9333EA) : const Color(0xFFD8B4FE);
        badgeText = isDark ? const Color(0xFFD8B4FE) : const Color(0xFF7E22CE);
        typeTag = '격음 💨';
        break;
      case 'tense':
        badgeBg = isDark ? const Color(0xFF4C1D1D) : const Color(0xFFFFF1F2);
        badgeBorder = isDark ? const Color(0xFFE11D48) : const Color(0xFFFECDD3);
        badgeText = isDark ? const Color(0xFFFDA4AF) : const Color(0xFFBE123C);
        typeTag = '경음 ⚡';
        break;
      case 'vowel':
        badgeBg = isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5);
        badgeBorder = isDark ? const Color(0xFF059669) : const Color(0xFFA7F3D0);
        badgeText = isDark ? const Color(0xFF6EE7B7) : const Color(0xFF047857);
        typeTag = '모음';
        break;
      default:
        badgeBg = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF);
        badgeBorder = isDark ? const Color(0xFF2563EB) : const Color(0xFFBFDBFE);
        badgeText = isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8);
        typeTag = '평음';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _playLetterAudio(item.letter, item.exampleKorean),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPlaying
                  ? const Color(0xFF2563EB)
                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: isPlaying ? 2.0 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: (isPlaying ? const Color(0xFF2563EB) : (isDark ? Colors.black : const Color(0xFF64748B)))
                    .withValues(alpha: isPlaying ? 0.35 : (isDark ? 0.35 : 0.06)),
                blurRadius: isPlaying ? 12 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Row: Category Type Badge & Sound
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6.5, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: badgeBorder),
                    ),
                    child: Text(
                      typeTag,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: badgeText,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.sound,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ),
              // Big Hangul Character with Playing Pulse
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    item.letter,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: isPlaying
                          ? const Color(0xFF2563EB)
                          : (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)),
                      letterSpacing: -1,
                    ),
                  ),
                  if (isPlaying)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2563EB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.volume_up_rounded, size: 12, color: Colors.white),
                      ),
                    ),
                ],
              ),
              // Phonetic Sound Tip
              Text(
                item.soundTip,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
              // Example Word Strip
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4.5, horizontal: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
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
                        '${item.exampleKorean} (${item.exampleRoman})',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
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

  Widget _buildSyllableBuilderView(bool isDark) {
    final currentSyllable = _buildCurrentSyllable();
    final romanized = KoreanRomanizer.romanize(currentSyllable);
    final discoveredWord = HangulData.discoveredWords[currentSyllable];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Syllable Stage Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [const Color(0xFFEFF6FF), Colors.white],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : const Color(0xFF2563EB))
                      .withValues(alpha: isDark ? 0.4 : 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  AppStrings.tr('hangul_block_title', _langCode),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.tr('hangul_block_desc', _langCode),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Dynamic Combination Math Formula Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF2563EB),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: isDark ? 0.3 : 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildBlockChip(_builderInitials[_selectedInitialIdx], '초성', isDark),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text('+', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          _buildBlockChip(_builderVowels[_selectedVowelIdx], '중성', isDark),
                          if (_builderFinals[_selectedFinalIdx].isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text('+', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            _buildBlockChip(_builderFinals[_selectedFinalIdx], '종성', isDark),
                          ],
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('=', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              currentSyllable,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '[$romanized]',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1D4ED8),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 10),
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 🎉 REAL WORD DISCOVERY CARD!
                if (discoveredWord != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF064E3B), const Color(0xFF047857)]
                            : [const Color(0xFFECFDF5), const Color(0xFFD1FAE5)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF10B981),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(discoveredWord.emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.tr('hangul_word_discovered', _langCode),
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF065F46),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${discoveredWord.word} [${discoveredWord.roman}] : ${discoveredWord.getMeaning(_langCode)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? Colors.white : const Color(0xFF064E3B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF10B981)),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            TtsService().speak(discoveredWord.word, isSlow: _isSlowAudio);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 1. Initial Consonant Selector
          _buildSelectorSection(
            title: AppStrings.tr('hangul_step1_initial', _langCode),
            options: _builderInitials,
            selectedIdx: _selectedInitialIdx,
            onSelected: (idx) {
              setState(() => _selectedInitialIdx = idx);
              TtsService().speak(_buildCurrentSyllable(), isSlow: _isSlowAudio);
            },
            isDark: isDark,
          ),
          const SizedBox(height: 16),

          // 2. Medial Vowel Selector
          _buildSelectorSection(
            title: AppStrings.tr('hangul_step2_vowel', _langCode),
            options: _builderVowels,
            selectedIdx: _selectedVowelIdx,
            onSelected: (idx) {
              setState(() => _selectedVowelIdx = idx);
              TtsService().speak(_buildCurrentSyllable(), isSlow: _isSlowAudio);
            },
            isDark: isDark,
          ),
          const SizedBox(height: 16),

          // 3. Final Consonant Selector
          _buildSelectorSection(
            title: AppStrings.tr('hangul_step3_final', _langCode),
            options: _builderFinals.map((e) => e.isEmpty ? '없음' : e).toList(),
            selectedIdx: _selectedFinalIdx,
            onSelected: (idx) {
              setState(() => _selectedFinalIdx = idx);
              TtsService().speak(_buildCurrentSyllable(), isSlow: _isSlowAudio);
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildBlockChip(String letter, String label, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
              width: 1.2,
            ),
          ),
          child: Text(
            letter,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectorSection({
    required String title,
    required List<String> options,
    required int selectedIdx,
    required ValueChanged<int> onSelected,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: List.generate(options.length, (idx) {
            final isSelected = idx == selectedIdx;
            return ChoiceChip(
              label: Text(options[idx]),
              selected: isSelected,
              onSelected: (_) => onSelected(idx),
              selectedColor: const Color(0xFF2563EB),
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              labelStyle: TextStyle(
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                color: isSelected
                    ? Colors.white
                    : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155)),
              ),
              side: BorderSide(
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                width: 1.2,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            );
          }),
        ),
      ],
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

  late final List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();
    // Build 5 fun audio questions
    final random = math.Random();
    final pool = [
      {'target': 'ㄱ', 'sound': 'ㄱ (giyeok)', 'options': ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ']},
      {'target': 'ㅏ', 'sound': 'ㅏ (a)', 'options': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ']},
      {'target': '물', 'sound': '물 (mul)', 'options': ['물', '불', '발', '말']},
      {'target': '밥', 'sound': '밥 (bap)', 'options': ['밥', '방', '밤', '봄']},
      {'target': '강', 'sound': '강 (gang)', 'options': ['강', '산', '달', '길']},
      {'target': 'ㅊ', 'sound': 'ㅊ (chieut)', 'options': ['ㅊ', 'ㅈ', 'ㅉ', 'ㅋ']},
      {'target': 'ㄲ', 'sound': 'ㄲ (ssang-giyeok)', 'options': ['ㄲ', 'ㄱ', 'ㅋ', 'ㄸ']},
    ]..shuffle(random);

    _questions = pool.take(5).toList();
    _playCurrentAudio();
  }

  void _playCurrentAudio() {
    if (_questionIdx < _questions.length) {
      final q = _questions[_questionIdx];
      TtsService().speak(q['target'] as String);
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

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 34),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.tr('hangul_mini_quiz_title', widget.langCode),
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              if (_questionIdx < _questions.length)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_questionIdx + 1} / ${_questions.length}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Quiz Body or Result Screen
          if (_questionIdx < _questions.length) ...[
            // Speaker Play Action Card
            Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(35),
                  onTap: _playCurrentAudio,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 36),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                AppStrings.tr('hangul_mini_quiz_desc', widget.langCode),
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ),
            const SizedBox(height: 22),

            // 4 Options Grid
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
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.8,
                ),
                itemCount: options.length,
                itemBuilder: (context, idx) {
                  final opt = options[idx];
                  final isChosen = _selectedChoice == idx;
                  final isTarget = opt == target;

                  Color bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
                  Color border = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
                  Color text = isDark ? Colors.white : const Color(0xFF0F172A);

                  if (_isAnswered) {
                    if (isTarget) {
                      bg = const Color(0xFF10B981).withValues(alpha: 0.2);
                      border = const Color(0xFF10B981);
                      text = const Color(0xFF10B981);
                    } else if (isChosen && !isTarget) {
                      bg = const Color(0xFFEF4444).withValues(alpha: 0.2);
                      border = const Color(0xFFEF4444);
                      text = const Color(0xFFEF4444);
                    }
                  }

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _onChoiceSelected(idx),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: border, width: 1.5),
                        ),
                        child: Text(
                          opt,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: text,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 20),

            if (_isAnswered)
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _nextQuestion,
                child: Text(
                  _questionIdx == _questions.length - 1 ? '결과 보기' : '다음 문제 ➔',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ),
          ] else ...[
            // Result View
            Center(
              child: Column(
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 54)),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.tr('hangul_quiz_score', widget.langCode)
                        .replaceAll('{score}', '$_score'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '+50 XP 획득!',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      ProgressService().recordAnswer(9999, true); // give bonus progress
                      Navigator.pop(context);
                    },
                    child: const Text('완료 (Done)', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
