import 'package:flutter/material.dart';
import '../data/app_localization.dart';
import '../data/quiz_data.dart';
import '../models/quiz_question.dart';
import '../services/quiz_repository.dart';
import '../services/tts_service.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String initialLangCode;
  final String? category;
  final String? quizType; // 'word' or 'sentence'

  const QuizScreen({
    super.key,
    this.initialLangCode = 'KO',
    this.category,
    this.quizType,
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
    _questions = QuizRepository.getQuestions(
      type: widget.quizType,
      category: widget.category,
    );
  }

  @override
  void dispose() {
    TtsService().stop();
    super.dispose();
  }

  void _onOptionSelected(int index) {
    if (_isAnswered) return;

    final currentQuestion = _questions[_currentIndex];
    final isCorrect = index == currentQuestion.answerIndex;
    final selectedText = currentQuestion.options[index];

    // Play native TTS pronunciation for the selected Korean option
    TtsService().speak(selectedText);

    setState(() {
      _selectedOptionIndex = index;
      _isAnswered = true;
      if (isCorrect) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    TtsService().stop();
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

  String _getQuizTitle() {
    final currentType = (_questions.isNotEmpty && _currentIndex < _questions.length)
        ? _questions[_currentIndex].type
        : (widget.quizType ?? 'word');

    if (currentType == 'word') {
      switch (_currentLangCode) {
        case 'EN':
          return 'Basic Vocab Quiz';
        case 'VI':
          return 'Từ Vựng Cơ Bản';
        case 'ZH':
          return '基础词汇测验';
        case 'JA':
          return '基礎単語クイズ';
        case 'KO':
        default:
          return '기초 어휘 퀴즈';
      }
    } else {
      switch (_currentLangCode) {
        case 'EN':
          return 'Sentence Practice';
        case 'VI':
          return 'Luyện Câu Thực Tế';
        case 'ZH':
          return '实战句子练习';
        case 'JA':
          return '実践文練習';
        case 'KO':
        default:
          return '실전 문장 연습';
      }
    }
  }

  String _getExplanationHeader(String questionType) {
    if (questionType == 'word') {
      switch (_currentLangCode) {
        case 'EN':
          return 'Word Explanation & Tips';
        case 'VI':
          return 'Giải thích từ vựng & mẹo';
        case 'ZH':
          return '词汇解析与技巧';
        case 'JA':
          return '単語の解説＆ポイント';
        case 'KO':
        default:
          return '단어 해설 & 팁';
      }
    } else {
      switch (_currentLangCode) {
        case 'EN':
          return 'Sentence Explanation & Tips';
        case 'VI':
          return 'Giải thích câu & mẹo';
        case 'ZH':
          return '句子解析与技巧';
        case 'JA':
          return '文の解説＆ポイント';
        case 'KO':
        default:
          return '문장 해설 & 팁';
      }
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

  IconData _getSituationIcon(int id) {
    switch (id) {
      case 1:
        return Icons.business_center_rounded;
      case 2:
        return Icons.waving_hand_rounded;
      case 3:
        return Icons.restaurant_rounded;
      case 4:
        return Icons.front_hand_rounded;
      case 5:
        return Icons.record_voice_over_rounded;
      case 6:
        return Icons.local_library_rounded;
      case 7:
        return Icons.shopping_bag_rounded;
      case 8:
        return Icons.handshake_rounded;
      case 9:
        return Icons.directions_subway_rounded;
      case 10:
        return Icons.elderly_rounded;
      case 11:
        return Icons.backpack_rounded;
      case 12:
        return Icons.cookie_rounded;
      case 13:
        return Icons.style_rounded;
      case 14:
        return Icons.menu_book_rounded;
      case 15:
        return Icons.visibility_rounded;
      case 16:
        return Icons.directions_car_rounded;
      case 17:
        return Icons.healing_rounded;
      case 18:
        return Icons.thermostat_rounded;
      case 19:
        return Icons.compare_arrows_rounded;
      case 20:
        return Icons.bolt_rounded;
      default:
        return Icons.theater_comedy_rounded;
    }
  }

  String _getSituationTag(int id, String langCode) {
    switch (langCode) {
      case 'EN':
        switch (id) {
          case 1:
            return '🏢 School & Work';
          case 2:
            return '👋 Farewell';
          case 3:
            return '🍽️ Restaurant';
          case 4:
            return '🍵 Dining & Manners';
          case 5:
            return '🙋‍♂️ Daily Grammar';
          case 6:
            return '📚 Location & Study';
          case 7:
            return '🛒 Shopping & Price';
          case 8:
            return '🤝 First Meeting';
          case 9:
            return '🚇 Transit & Apology';
          case 10:
            return '👵 Respect & Elders';
          case 11:
            return '🎒 Item • Bag';
          case 12:
            return '🍪 Snack • Cookie';
          case 13:
            return '👞 Fashion • Shoes';
          case 14:
            return '📓 Study • Notebook';
          case 15:
            return '🏥 Clinic • Eye Doctor';
          case 16:
            return '🚗 Health • Motion Sickness';
          case 17:
            return '🩹 Pharmacy • Pain Patch';
          case 18:
            return '🌡️ Health • Fever';
          case 19:
            return '↔️ Antonym • Adjective';
          case 20:
            return '⚡ Personality • Hasty';
          default:
            return '💡 Situation';
        }
      case 'VI':
        switch (id) {
          case 1:
            return '🏢 Trường học & Đi làm';
          case 2:
            return '👋 Chào tạm biệt';
          case 3:
            return '🍽️ Quán ăn & Gọi món';
          case 4:
            return '🍵 Từ chối lịch sự';
          case 5:
            return '🙋‍♂️ Ngữ pháp chủ ngữ';
          case 6:
            return '📚 Địa điểm & Hành động';
          case 7:
            return '🛒 Mua sắm & Hỏi giá';
          case 8:
            return '🤝 Lần đầu gặp mặt';
          case 9:
            return '🚇 Tàu xe & Xin lỗi';
          case 10:
            return '👵 Kính trọng người lớn';
          case 11:
            return '🎒 Đồ vật • Cái cặp';
          case 12:
            return '🍪 Ăn vặt • Bánh kẹo';
          case 13:
            return '👞 Trang phục • Giày da';
          case 14:
            return '📓 Học tập • Vở ghi';
          case 15:
            return '🏥 Bệnh viện • Khoa mắt';
          case 16:
            return '🚗 Sức khỏe • Say xe';
          case 17:
            return '🩹 Hiệu thuốc • Cao dán';
          case 18:
            return '🌡️ Sức khỏe • Cơn sốt';
          case 19:
            return '↔️ Từ trái nghĩa';
          case 20:
            return '⚡ Tính cách • Nóng vội';
          default:
            return '💡 Tình huống';
        }
      case 'ZH':
        switch (id) {
          case 1:
            return '🏢 校园·职场';
          case 2:
            return '👋 告别·离开';
          case 3:
            return '🍽️ 餐厅·呼叫';
          case 4:
            return '🍵 礼貌谢绝';
          case 5:
            return '🙋‍♂️ 日常语法';
          case 6:
            return '📚 场所与动作';
          case 7:
            return '🛒 购物·询价';
          case 8:
            return '🤝 初次见面';
          case 9:
            return '🚇 交通·道歉';
          case 10:
            return '👵 尊老礼仪';
          case 11:
            return '🎒 物品·书包';
          case 12:
            return '🍪 零食·点心';
          case 13:
            return '👞 服饰·皮鞋';
          case 14:
            return '📓 文具·笔记本';
          case 15:
            return '🏥 医院·眼科';
          case 16:
            return '🚗 健康·晕车';
          case 17:
            return '🩹 药店·止痛贴';
          case 18:
            return '🌡️ 症状·发烧';
          case 19:
            return '↔️ 核心反义词';
          case 20:
            return '⚡ 性格·性急';
          default:
            return '💡 场景';
        }
      case 'JA':
        switch (id) {
          case 1:
            return '🏢 学校・職場';
          case 2:
            return '👋 別れの挨拶';
          case 3:
            return '🍽️ 飲食店・呼出';
          case 4:
            return '🍵 丁寧な辞退';
          case 5:
            return '🙋‍♂️ 日常文法';
          case 6:
            return '📚 場所と動作';
          case 7:
            return '🛒 買い物・値段';
          case 8:
            return '🤝 初対面・挨拶';
          case 9:
            return '🚇 交通・お詫び';
          case 10:
            return '👵 敬老・礼儀';
          case 11:
            return '🎒 持ち物・カバン';
          case 12:
            return '🍪 おやつ・お菓子';
          case 13:
            return '👞 服飾・革靴';
          case 14:
            return '📓 文房具・ノート';
          case 15:
            return '🏥 病院・眼科';
          case 16:
            return '🚗 体調・乗り物酔い';
          case 17:
            return '🩹 薬局・湿布';
          case 18:
            return '🌡️ 体調・発熱';
          case 19:
            return '↔️ 対義語・反対語';
          case 20:
            return '⚡ 性格・せっかち';
          default:
            return '💡 場面';
        }
      case 'KO':
      default:
        switch (id) {
          case 1:
            return '🏢 학교·직장';
          case 2:
            return '👋 작별·인사';
          case 3:
            return '🍽️ 식당·호출';
          case 4:
            return '🍵 식사·거절';
          case 5:
            return '🙋‍♂️ 일상·주어';
          case 6:
            return '📚 도서관·장소';
          case 7:
            return '🛒 쇼핑·가격';
          case 8:
            return '🤝 첫 만남·소개';
          case 9:
            return '🚇 대중교통·사과';
          case 10:
            return '👵 어르신·예절';
          case 11:
            return '🎒 사물·가방';
          case 12:
            return '🍪 간식·과자';
          case 13:
            return '👞 복장·구두';
          case 14:
            return '📓 문구·공책';
          case 15:
            return '🏥 병원·안과';
          case 16:
            return '🚗 건강·멀미';
          case 17:
            return '🩹 약국·파스';
          case 18:
            return '🌡️ 건강·발열';
          case 19:
            return '↔️ 반대말·형용사';
          case 20:
            return '⚡ 성격·급한 편';
          default:
            return '💡 상황 맥락';
        }
    }
  }

  void _showExitDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        title: Text(
          AppStrings.tr('quiz_quit_title', _currentLangCode),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        content: Text(
          AppStrings.tr('quiz_quit_desc', _currentLangCode),
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              AppStrings.tr('quiz_quit_continue', _currentLangCode),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppStrings.tr('quiz_quit_exit', _currentLangCode),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final total = _questions.length;
    final currentQuestion = _questions[_currentIndex];
    final isLastQuestion = _currentIndex == total - 1;
    final progress = (_currentIndex + 1) / total;
    final currentLang = _getCurrentLanguageOption();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 60,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _showExitDialog(context),
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
                    Icons.close_rounded,
                    size: 19,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          _getQuizTitle(),
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          // Dynamic Language Switcher Popup (Refined Pill)
          PopupMenuButton<String>(
            tooltip: 'Switch Explanation Language',
            initialValue: _currentLangCode,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            onSelected: (String newCode) {
              setState(() {
                _currentLangCode = newCode;
              });
            },
            itemBuilder: (BuildContext context) {
              return supportedLanguages.map((LanguageOption lang) {
                final isSelected = lang.code == _currentLangCode;
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
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 13.5,
                            color: isSelected
                                ? const Color(0xFF3B82F6)
                                : (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B)),
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: Color(0xFF3B82F6),
                        ),
                    ],
                  ),
                );
              }).toList();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
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
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(currentLang.flag, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 5),
                  Text(
                    currentLang.code,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
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
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E3A8A),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 4.5,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF3B82F6).withValues(alpha: 0.35)
                                : const Color(0xFFBFDBFE),
                            width: 1.1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.tag_rounded,
                              size: 13,
                              color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getCategoryLabel(currentQuestion.category),
                              style: TextStyle(
                                color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
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
                    if (currentQuestion.visual != null || currentQuestion.type == 'word')
                      _buildQuestionVisualCard(currentQuestion, isDark)
                    else ...[
                      // 1. Situation Context Card (In Selected Language)
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF0F172A) : const Color(0xFF334155),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _getSituationIcon(currentQuestion.id),
                                size: 18,
                                color: Colors.white,
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
                                          AppStrings.tr('quiz_situation_context', _currentLangCode),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            _getSituationTag(currentQuestion.id, 'KO'),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w700,
                                              color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    currentQuestion.getSituation('KO'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
                                      height: 1.4,
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
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(18),
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
                            Row(
                              children: [
                                Icon(
                                  Icons.help_outline_rounded,
                                  size: 17,
                                  color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
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
                                      color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              currentQuestion.getQuestion('KO'),
                              style: TextStyle(
                                fontSize: 17.5,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),

                    // 3. 4 Multiple Choice Options (Clean Korean Text)
                    ...List.generate(currentQuestion.options.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 11.0),
                        child: _buildOptionButton(
                          context: context,
                          index: index,
                          optionText: currentQuestion.options[index],
                          correctIndex: currentQuestion.answerIndex,
                          isDark: isDark,
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Bottom Area: Spot on! / Not quite!, Explanation & Next Button
            if (_isAnswered) _buildFeedbackBottomBar(context, isLastQuestion, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionVisualCard(QuizQuestion currentQuestion, bool isDark) {
    final visual = currentQuestion.visual ?? '🖼️';
    final isWordQuiz = currentQuestion.type == 'word';
    final rawQuestion = currentQuestion.getQuestion('KO');

    // Robust Dialogue Parsing
    final turns = _parseQuestionDialogue(rawQuestion);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFF64748B))
                .withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Instruction header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? const Color(0xFF2563EB) : const Color(0xFFBFDBFE),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isWordQuiz ? Icons.image_search_rounded : Icons.record_voice_over_rounded,
                      size: 13,
                      color: const Color(0xFF3B82F6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isWordQuiz ? '기초 단어' : '문장 연습',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  currentQuestion.getSituation('KO').startsWith('※')
                      ? currentQuestion.getSituation('KO')
                      : '※ ${currentQuestion.getSituation('KO')}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Central Picture Illustration Frame with Speech Bubble and Keyword Badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currentQuestion.speechBubble != null) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? const Color(0xFF3B82F6) : const Color(0xFF93C5FD),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('💬 ', style: TextStyle(fontSize: 12)),
                        Text(
                          currentQuestion.speechBubble!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Builder(
                  builder: (context) {
                    final isImagePath = visual.startsWith('assets/') ||
                        visual.endsWith('.webp') ||
                        visual.endsWith('.png') ||
                        visual.endsWith('.jpg');
                    if (isImagePath) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          visual,
                          width: 130,
                          height: 130,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Text(
                            '🖼️',
                            style: TextStyle(fontSize: 68),
                          ),
                        ),
                      );
                    }
                    return Text(
                      visual,
                      style: const TextStyle(fontSize: 68),
                    );
                  },
                ),
                if (currentQuestion.keyword != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      currentQuestion.keyword!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Symmetrical Dialogue Section: [철수] Question Row + Separated [영희] Answer Row
          ...List.generate(turns.length, (turnIndex) {
            final turn = turns[turnIndex];
            final isFirst = turn.isFirst;

            return Padding(
              padding: EdgeInsets.only(top: turnIndex > 0 ? 10.0 : 0.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isFirst
                      ? (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC))
                      : (isDark
                          ? const Color(0xFF1E293B).withValues(alpha: 0.85)
                          : const Color(0xFFF5F3FF)),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isFirst
                        ? (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1))
                        : (isDark
                            ? const Color(0xFF6366F1).withValues(alpha: 0.5)
                            : const Color(0xFFC7D2FE)),
                    width: isFirst ? 1.1 : 1.3,
                  ),
                  boxShadow: [
                    if (!isFirst)
                      BoxShadow(
                        color: (isDark ? const Color(0xFF6366F1) : const Color(0xFF818CF8))
                            .withValues(alpha: isDark ? 0.15 : 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    // Symmetrical Speaker Pill Badge (철수 vs 영희)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: isFirst
                            ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF))
                            : (isDark ? const Color(0xFF312E81) : const Color(0xFFEDE9FE)),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isFirst
                              ? (isDark ? const Color(0xFF3B82F6).withValues(alpha: 0.4) : const Color(0xFFBFDBFE))
                              : (isDark ? const Color(0xFF818CF8).withValues(alpha: 0.4) : const Color(0xFFDDD6FE)),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isFirst ? '🙋‍♂️' : '🙋‍♀️',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            turn.speakerName,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: isFirst
                                  ? (isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8))
                                  : (isDark ? const Color(0xFFC7D2FE) : const Color(0xFF4F46E5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 11),

                    // Dialogue content text
                    Expanded(
                      child: Text(
                        turn.content,
                        style: TextStyle(
                          fontSize: isFirst ? 16 : 16.5,
                          fontWeight: isFirst ? FontWeight.w700 : FontWeight.w800,
                          color: isFirst
                              ? (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A))
                              : (isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4338CA)),
                          letterSpacing: isFirst ? -0.2 : 0.2,
                          height: 1.35,
                        ),
                      ),
                    ),

                    // Trailing Action: TTS Button for Question, Edit hint icon for Answer
                    if (isFirst)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => TtsService().speak(turn.content),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.volume_up_rounded,
                              size: 18,
                              color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF312E81).withValues(alpha: 0.5)
                              : const Color(0xFFEDE9FE),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.edit_note_rounded,
                          size: 19,
                          color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4F46E5),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  List<_DialogueTurn> _parseQuestionDialogue(String rawQuestion) {
    // 1. Unescape literal '\n' and normalize all line breaks
    final normalized = rawQuestion
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\r\n', '\n')
        .replaceAll('\r', '\n');

    List<String> rawLines = [];
    if (normalized.contains('\n')) {
      rawLines = normalized.split('\n');
    } else if (normalized.contains(RegExp(r'(?:나|영희|지수|B)\s*:'))) {
      final match = RegExp(r'^(.*?)(?=(?:나|영희|지수|B)\s*:)').firstMatch(normalized);
      if (match != null && match.group(1) != null) {
        rawLines = [
          match.group(1)!,
          normalized.substring(match.group(1)!.length),
        ];
      } else {
        rawLines = [normalized];
      }
    } else {
      rawLines = [normalized];
    }

    final List<_DialogueTurn> turns = [];
    for (int i = 0; i < rawLines.length; i++) {
      final line = rawLines[i].trim();
      if (line.isEmpty) continue;

      String speakerName = (i == 0) ? '철수' : '영희';
      String content = line;

      // Extract speaker prefix if present
      final prefixMatch = RegExp(r'^(?:가|나|철수|영희|민수|지수|[A-D])\s*:\s*(.*)$').firstMatch(line);
      if (prefixMatch != null) {
        content = prefixMatch.group(1)!.trim();
        final rawSpeaker = line.split(':')[0].trim();
        if (rawSpeaker == '가' || rawSpeaker == '철수' || rawSpeaker == '민수' || rawSpeaker == 'A') {
          speakerName = '철수';
        } else if (rawSpeaker == '나' || rawSpeaker == '영희' || rawSpeaker == '지수' || rawSpeaker == 'B') {
          speakerName = '영희';
        } else {
          speakerName = rawSpeaker;
        }
      }

      turns.add(_DialogueTurn(
        speakerName: speakerName,
        content: content,
        isBlankTarget: content.contains('(') || content.contains('_____'),
        isFirst: (i == 0),
      ));
    }

    // Fallback if empty
    if (turns.isEmpty) {
      turns.add(_DialogueTurn(
        speakerName: '철수',
        content: rawQuestion,
        isBlankTarget: false,
        isFirst: true,
      ));
    }

    return turns;
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required int index,
    required String optionText,
    required int correctIndex,
    required bool isDark,
  }) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    Color badgeColor;
    Color badgeTextColor;
    Widget? trailingIcon;

    if (_isAnswered) {
      if (index == correctIndex) {
        backgroundColor = isDark
            ? const Color(0xFF064E3B).withValues(alpha: 0.35)
            : const Color(0xFFF0FDF4);
        borderColor = const Color(0xFF16A34A);
        textColor = isDark ? const Color(0xFF86EFAC) : const Color(0xFF14532D);
        badgeColor = const Color(0xFF16A34A);
        badgeTextColor = Colors.white;
        trailingIcon = const Icon(
          Icons.check_circle_rounded,
          color: Color(0xFF16A34A),
          size: 24,
        );
      } else if (index == _selectedOptionIndex) {
        backgroundColor = isDark
            ? const Color(0xFF7F1D1D).withValues(alpha: 0.35)
            : const Color(0xFFFEF2F2);
        borderColor = const Color(0xFFDC2626);
        textColor = isDark ? const Color(0xFFFCA5A5) : const Color(0xFF7F1D1D);
        badgeColor = const Color(0xFFDC2626);
        badgeTextColor = Colors.white;
        trailingIcon = const Icon(
          Icons.cancel_rounded,
          color: Color(0xFFDC2626),
          size: 24,
        );
      } else {
        backgroundColor = isDark
            ? const Color(0xFF0F172A).withValues(alpha: 0.5)
            : const Color(0xFFF8FAFC);
        borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
        textColor = isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);
        badgeColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
        badgeTextColor = isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8);
      }
    } else {
      backgroundColor = isDark ? const Color(0xFF1E293B) : Colors.white;
      borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
      textColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
      badgeColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
      badgeTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
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
                  color: (isDark ? Colors.black : const Color(0xFF64748B))
                      .withValues(alpha: isDark ? 0.25 : 0.04),
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
                  color: badgeColor,
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: badgeTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  optionText,
                  style: TextStyle(
                    fontSize: 18.5,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    height: 1.25,
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    Icons.volume_up_rounded,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    size: 21,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                  splashRadius: 18,
                  tooltip: '발음 듣기',
                  onPressed: () {
                    TtsService().speak(optionText);
                  },
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 4),
                trailingIcon,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackBottomBar(BuildContext context, bool isLastQuestion, bool isDark) {
    final currentQuestion = _questions[_currentIndex];
    final isCorrect = _selectedOptionIndex == currentQuestion.answerIndex;
    final currentLang = _getCurrentLanguageOption();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: isDark
            ? const Border(
                top: BorderSide(color: Color(0xFF334155), width: 1.2),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: isDark ? 0.4 : 0.12),
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
                color: isCorrect
                    ? (isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A))
                    : (isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626)),
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
                  color: isCorrect
                      ? (isDark ? const Color(0xFF4ADE80) : const Color(0xFF15803D))
                      : (isDark ? const Color(0xFFF87171) : const Color(0xFFB91C1C)),
                ),
              ),
            ],
          ),
          if (!isCorrect) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF064E3B).withValues(alpha: 0.3)
                    : const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF16A34A).withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '${AppStrings.tr('quiz_correct_answer_label', _currentLangCode)} ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF16A34A),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      currentQuestion.options[currentQuestion.answerIndex],
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.volume_up_rounded,
                      size: 20,
                      color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF16A34A),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    splashRadius: 16,
                    tooltip: '정답 발음 듣기',
                    onPressed: () {
                      TtsService().speak(currentQuestion.options[currentQuestion.answerIndex]);
                    },
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),

          // Certified Instructor Nuance Explanation in Selected Language
          Container(
            padding: const EdgeInsets.all(13),
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
                Icon(
                  Icons.psychology_alt_rounded,
                  size: 20,
                  color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
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
                              _getExplanationHeader(currentQuestion.type),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${currentLang.code})',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentQuestion.getExplanation(_currentLangCode),
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E293B),
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
              foregroundColor: Colors.white,
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

class _DialogueTurn {
  final String speakerName;
  final String content;
  final bool isBlankTarget;
  final bool isFirst;

  const _DialogueTurn({
    required this.speakerName,
    required this.content,
    required this.isBlankTarget,
    required this.isFirst,
  });
}
