import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/app_localization.dart';
import '../data/quiz_data.dart';
import '../models/quiz_question.dart';
import '../services/ad_service.dart';
import '../services/progress_service.dart';
import '../services/quiz_repository.dart';
import '../services/tts_service.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String initialLangCode;
  final String? category;
  final String? quizType; // 'word' or 'sentence'
  final int? level; // Stage level (1, 2, 3...)
  final List<int>? reviewIds; // mistake review mode

  const QuizScreen({
    super.key,
    this.initialLangCode = 'KO',
    this.category,
    this.quizType,
    this.level,
    this.reviewIds,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<QuizQuestion> _questions;
  late String _currentLangCode;
  late int _sessionSize; // unique questions (excluding re-queued retries)
  final Set<int> _retryIndexes = {}; // indexes of re-queued (retry) questions
  int _currentIndex = 0;
  int _score = 0;
  int _combo = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;

  // Word assembly state for subjective unscramble questions
  List<String> _assembledChips = [];
  List<String> _bankChips = [];
  final Set<int> _usedBankChipIndices = {};

  void _initChipsForCurrentQuestion() {
    _assembledChips = [];
    _usedBankChipIndices.clear();
    if (_questions.isNotEmpty && _currentIndex < _questions.length) {
      final q = _questions[_currentIndex];
      if (q.chips != null && q.chips!.isNotEmpty) {
        _bankChips = List<String>.from(q.chips!)..shuffle();
      } else {
        _bankChips = [];
      }
    } else {
      _bankChips = [];
    }
  }

  void _submitAssembledAnswer() {
    if (_isAnswered || _assembledChips.isEmpty) return;

    final currentQuestion = _questions[_currentIndex];
    final correctAnswer = currentQuestion.options[currentQuestion.answerIndex];

    final userText = _assembledChips.join(' ').replaceAll(' ', '').trim();
    final targetText = correctAnswer.replaceAll(' ', '').trim();

    final isCorrect = userText == targetText;

    if (isCorrect) {
      _onOptionSelected(currentQuestion.answerIndex);
    } else {
      _onOptionSelected(-1);
    }
  }

  void _onChipTapped(int bankIndex) {
    if (_isAnswered) return;
    if (_usedBankChipIndices.contains(bankIndex)) return;
    HapticFeedback.selectionClick();
    setState(() {
      _usedBankChipIndices.add(bankIndex);
      _assembledChips.add(_bankChips[bankIndex]);
    });
  }

  void _onAssembledChipRemoved(int slotIndex) {
    if (_isAnswered) return;
    HapticFeedback.selectionClick();
    setState(() {
      final chipText = _assembledChips.removeAt(slotIndex);
      for (final idx in _usedBankChipIndices.toList()) {
        if (_bankChips[idx] == chipText) {
          _usedBankChipIndices.remove(idx);
          break;
        }
      }
    });
  }

  void _resetAssembledChips() {
    if (_isAnswered) return;
    HapticFeedback.selectionClick();
    setState(() {
      _assembledChips.clear();
      _usedBankChipIndices.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _currentLangCode = widget.initialLangCode;
    final isReview = widget.reviewIds != null && widget.reviewIds!.isNotEmpty;
    _questions = QuizRepository.getQuestions(
      type: isReview ? null : widget.quizType,
      category: isReview ? null : widget.category,
      level: isReview ? null : widget.level,
      ids: isReview ? widget.reviewIds : null,
      limit: QuizRepository.sessionSize,
    );
    _sessionSize = _questions.length;
    _initChipsForCurrentQuestion();
  }

  @override
  void dispose() {
    TtsService().stop();
    super.dispose();
  }

  bool get _isRetryQuestion => _retryIndexes.contains(_currentIndex);

  /// Copy a question with freshly shuffled options (used when re-queuing a mistake)
  QuizQuestion _reshuffled(QuizQuestion q) {
    final correct = q.options[q.answerIndex];
    final options = List<String>.from(q.options)..shuffle();
    return QuizQuestion(
      id: q.id,
      category: q.category,
      type: q.type,
      visual: q.visual,
      keyword: q.keyword,
      speechBubble: q.speechBubble,
      situations: q.situations,
      questions: q.questions,
      options: options,
      answerIndex: options.indexOf(correct),
      explanations: q.explanations,
      chips: q.chips != null ? List<String>.from(q.chips!) : null,
    );
  }

  /// Replace the blank "(     )" in a dialogue line with [answer]
  static final RegExp _blankPattern = RegExp(r'\(\s*\)|_{3,}');
  String _fillBlank(String line, String answer) => line.replaceFirst(_blankPattern, answer);

  /// Full Korean answer line with the correct option filled in (for TTS)
  String _completedAnswerLine(QuizQuestion q) {
    final turns = _parseQuestionDialogue(q.getQuestion('KO'));
    final answer = q.options[q.answerIndex];
    final target = turns.firstWhere(
      (t) => _blankPattern.hasMatch(t.content),
      orElse: () => turns.last,
    );
    return _blankPattern.hasMatch(target.content) ? _fillBlank(target.content, answer) : answer;
  }

  void _onOptionSelected(int index) {
    if (_isAnswered) return;

    final currentQuestion = _questions[_currentIndex];
    final isCorrect = index == currentQuestion.answerIndex;

    if (isCorrect) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.heavyImpact();
    }

    ProgressService().recordAnswer(currentQuestion.id, isCorrect);

    setState(() {
      _selectedOptionIndex = index;
      _isAnswered = true;
      if (isCorrect) {
        if (!_isRetryQuestion) _score++;
        _combo++;
      } else {
        _combo = 0;
        // Duolingo-style: ask a missed question once more at the end of the session
        if (!_isRetryQuestion) {
          _questions.add(_reshuffled(currentQuestion));
          _retryIndexes.add(_questions.length - 1);
        }
      }
    });
  }

  Future<void> _nextQuestion() async {
    TtsService().stop();
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
        _isAnswered = false;
        _initChipsForCurrentQuestion();
      });
    } else {
      await ProgressService().completeSession();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: _score,
            totalQuestions: _sessionSize,
            langCode: _currentLangCode,
            quizType: widget.quizType,
            category: widget.category,
            level: widget.level,
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
        case 'ES':
          return 'Quiz de Vocabulario';
        case 'PT':
          return 'Quiz de Vocabulário';
        case 'KO':
        default:
          return '기초 단어 퀴즈';
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
        case 'ES':
          return 'Práctica de Frases';
        case 'PT':
          return 'Prática de Frases';
        case 'KO':
        default:
          return '생활 대화 연습';
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
        case 'ES':
          return 'Explicación del Vocabulario';
        case 'PT':
          return 'Explicação do Vocabulário';
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
        case 'ES':
          return 'Explicación de la Frase';
        case 'PT':
          return 'Explicação da Frase';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = _questions.length;
    final currentNumber = _currentIndex + 1;
    final progressFraction = total > 0 ? (currentNumber / total).clamp(0.0, 1.0) : 0.0;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss Exit Dialog',
      barrierColor: Colors.black.withValues(alpha: isDark ? 0.72 : 0.45),
      transitionDuration: const Duration(milliseconds: 280),
      transitionBuilder: (context, anim, secondaryAnim, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: curved,
          child: FadeTransition(opacity: anim, child: child),
        );
      },
      pageBuilder: (ctx, anim, secondaryAnim) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 380),
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1.3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.16),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Warm, friendly hero icon with dual ring glow
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? const Color(0xFF78350F).withValues(alpha: 0.35)
                          : const Color(0xFFFEF3C7),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFFF59E0B).withValues(alpha: 0.4)
                            : const Color(0xFFFDE68A),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF59E0B)
                              .withValues(alpha: isDark ? 0.25 : 0.18),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEA580C)
                                  .withValues(alpha: isDark ? 0.4 : 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.sentiment_dissatisfied_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // 2. Title
                Text(
                  AppStrings.tr('quiz_quit_title', _currentLangCode),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                    color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),

                // 3. Description
                Text(
                  AppStrings.tr('quiz_quit_desc', _currentLangCode),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    letterSpacing: -0.2,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Current progress card (gentle reminder of progress achieved)
                if (total > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.tr('quiz_question_progress', _currentLangCode, {
                                'current': '$currentNumber',
                                'total': '$total',
                              }),
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
                              ),
                            ),
                            Text(
                              '${(progressFraction * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: progressFraction,
                            minHeight: 6,
                            backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),

                // 5. Primary Tactile Button: Continue (Keep learning)
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      // 3D tactile edge
                      const BoxShadow(
                        color: Color(0xFF1D4ED8),
                        offset: Offset(0, 3.2),
                        blurRadius: 0,
                      ),
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: isDark ? 0.4 : 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.pop(ctx),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              AppStrings.tr('quiz_quit_continue', _currentLangCode),
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // 6. Secondary Button: Quit (Exit quiz)
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F172A).withValues(alpha: 0.6)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          AppStrings.tr('quiz_quit_exit', _currentLangCode),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: Text(_getQuizTitle()),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.school_rounded, size: 52, color: Color(0xFF2563EB)),
                const SizedBox(height: 16),
                Text(
                  AppStrings.tr('quiz_quit_desc', _currentLangCode),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppStrings.tr('result_home', _currentLangCode)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final total = _questions.length;
    final currentQuestion = _questions[_currentIndex];
    final isLastQuestion = _currentIndex == total - 1;
    final progress = (_currentIndex + 1) / total;
    final currentLang = _getCurrentLanguageOption();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showExitDialog(context);
      },
      child: Scaffold(
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
        bottom: false,
        child: Column(
          children: [
            // Top: Progress Bar, Question Counter & Category Badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Question Counter (Multilingual Safe with Ellipsis)
                      Expanded(
                        child: Text(
                          AppStrings.tr('quiz_question_progress', _currentLangCode, {
                            'current': '${_currentIndex + 1}',
                            'total': '$total',
                          }),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E3A8A),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Retry (re-queued mistake) badge
                      if (_isRetryQuestion) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF78350F).withValues(alpha: 0.45)
                                : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? const Color(0xFFF59E0B) : const Color(0xFFFCD34D),
                              width: 1.1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.replay_rounded,
                                size: 13,
                                color: isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                AppStrings.tr('quiz_review_badge', _currentLangCode),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],

                      // Category Badge with Flexible constraint
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
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
                              Flexible(
                                child: Text(
                                  _getCategoryLabel(currentQuestion.category),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Premium Rounded Capsule Progress Bar
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress),
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          minHeight: 8,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _combo >= 3 ? const Color(0xFFF59E0B) : const Color(0xFF22C55E),
                          ),
                        ),
                      ),
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

                    // 3. Choice Options (Assembly or Multiple Choice)
                    if (currentQuestion.chips != null && currentQuestion.chips!.isNotEmpty) ...[
                      _buildWordAssemblySection(context, currentQuestion, isDark),
                    ] else ...[
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
                    ],
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Bottom Area: Spot on! / Not quite!, Explanation & Next Button
            if (_isAnswered) _buildFeedbackBottomBar(context, isLastQuestion, isDark),
            const BottomBannerAdWidget(),
          ],
        ),
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

    // The keyword caption must not give away the answer (e.g. 🇯🇵 + "일본" → answer "일본")
    final correctAnswer = currentQuestion.options[currentQuestion.answerIndex];
    final keyword = currentQuestion.keyword;
    final keywordRevealsAnswer = keyword != null && correctAnswer.contains(keyword);
    final showKeyword = keyword != null && (!keywordRevealsAnswer || _isAnswered);
    final answeredCorrectly = _isAnswered && _selectedOptionIndex == currentQuestion.answerIndex;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
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
                .withValues(alpha: isDark ? 0.38 : 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFF64748B))
                .withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Sleek, uncluttered Type Badge Header (Detailed situation text removed as requested)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0F172A)
                      : (isWordQuiz ? const Color(0xFFF0FDF4) : const Color(0xFFEFF6FF)),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? (isWordQuiz ? const Color(0xFF10B981) : const Color(0xFF3B82F6)).withValues(alpha: 0.4)
                        : (isWordQuiz ? const Color(0xFFBBF7D0) : const Color(0xFFBFDBFE)),
                    width: 1.1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isWordQuiz ? Icons.auto_awesome_rounded : Icons.forum_rounded,
                      size: 13.5,
                      color: isWordQuiz
                          ? (isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A))
                          : (isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isWordQuiz ? '기초 단어' : '문장 연습',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? (isWordQuiz ? const Color(0xFF86EFAC) : const Color(0xFF93C5FD))
                            : (isWordQuiz ? const Color(0xFF15803D) : const Color(0xFF1D4ED8)),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              // Clean Category / Context hint pill
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A).withValues(alpha: 0.6) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.headphones_rounded,
                        size: 12,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          AppStrings.tr('quiz_listen_pronunciation', _currentLangCode),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. Central Picture Illustration Frame with Speech Bubble and Visual
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                    : [const Color(0xFFF8FAFC), const Color(0xFFF1F5F9)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1.1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currentQuestion.speechBubble != null) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4.5),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF3B82F6).withValues(alpha: 0.5)
                            : const Color(0xFFBFDBFE),
                        width: 1.1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isDark ? Colors.black : const Color(0xFF3B82F6))
                              .withValues(alpha: isDark ? 0.3 : 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('💬 ', style: TextStyle(fontSize: 12)),
                        Flexible(
                          child: Text(
                            currentQuestion.speechBubble!,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                              letterSpacing: -0.2,
                            ),
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
                    final imgSize = isWordQuiz ? 104.0 : 58.0;
                    if (isImagePath) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          visual,
                          width: imgSize,
                          height: imgSize,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Text(
                            '🖼️',
                            style: TextStyle(fontSize: isWordQuiz ? 56 : 30),
                          ),
                        ),
                      );
                    }
                    return Text(
                      visual,
                      style: TextStyle(
                        fontSize: isWordQuiz ? 56 : 32,
                        letterSpacing: 2,
                      ),
                    );
                  },
                ),
                if (showKeyword) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      currentQuestion.keyword!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. Symmetrical, Luxurious Dialogue Rows
          ...List.generate(turns.length, (turnIndex) {
            final turn = turns[turnIndex];
            final isFirst = turn.isFirst;
            final isTargetRow = turn.isBlankTarget;

            // Background & Border styling tuned for context vs active interactive row
            final rowBg = isTargetRow
                ? (isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.95)
                    : const Color(0xFFF5F3FF))
                : (isDark
                    ? const Color(0xFF0F172A).withValues(alpha: 0.8)
                    : const Color(0xFFF8FAFC));

            final rowBorder = isTargetRow
                ? (isDark
                    ? const Color(0xFF6366F1).withValues(alpha: 0.55)
                    : const Color(0xFFC7D2FE))
                : (isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0));

            return Padding(
              padding: EdgeInsets.only(top: turnIndex > 0 ? 8.0 : 0.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: rowBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: rowBorder,
                    width: isTargetRow ? 1.3 : 1.0,
                  ),
                  boxShadow: [
                    if (isTargetRow)
                      BoxShadow(
                        color: (isDark ? const Color(0xFF6366F1) : const Color(0xFF818CF8))
                            .withValues(alpha: isDark ? 0.2 : 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Dynamic Speaker Pill Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: isFirst
                            ? (isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.35) : const Color(0xFFEFF6FF))
                            : (isDark ? const Color(0xFF312E81).withValues(alpha: 0.35) : const Color(0xFFFAF5FF)),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isFirst
                              ? (isDark ? const Color(0xFF3B82F6).withValues(alpha: 0.4) : const Color(0xFFBFDBFE))
                              : (isDark ? const Color(0xFF818CF8).withValues(alpha: 0.4) : const Color(0xFFE9D5FF)),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            turn.emoji,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            turn.speakerName,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: isFirst
                                  ? (isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8))
                                  : (isDark ? const Color(0xFFC7D2FE) : const Color(0xFF6B21A8)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Dialogue content text with non-breaking, stylish interactive blank capsule
                    Expanded(
                      child: _buildDialogueContent(
                        line: turn.content,
                        isFirst: isFirst,
                        correctAnswer: correctAnswer,
                        answeredCorrectly: answeredCorrectly,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Trailing Action: Interactive Korean TTS button for ALL dialogue lines
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          final textToSpeak = turn.isBlankTarget
                              ? (_isAnswered ? _fillBlank(turn.content, correctAnswer) : turn.content.replaceAll(_blankPattern, ''))
                              : turn.content;
                          if (textToSpeak.trim().isNotEmpty) {
                            TtsService().speak(textToSpeak);
                          }
                        },
                        child: Container(
                          width: 33,
                          height: 33,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                              width: 1.1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 1.5),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.volume_up_rounded,
                            size: 16.5,
                            color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                          ),
                        ),
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

  /// Builds dialogue text with non-breaking, stylish interactive blank capsule
  Widget _buildDialogueContent({
    required String line,
    required bool isFirst,
    required String correctAnswer,
    required bool answeredCorrectly,
    required bool isDark,
  }) {
    final hasBlank = _blankPattern.hasMatch(line);
    final baseStyle = TextStyle(
      fontSize: 15.5,
      fontWeight: FontWeight.w700,
      color: isFirst
          ? (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A))
          : (isDark ? const Color(0xFFA5B4FC) : const Color(0xFF3730A3)),
      letterSpacing: -0.25,
      height: 1.45,
    );

    if (!hasBlank) {
      return Text(line, style: baseStyle);
    }

    final match = _blankPattern.firstMatch(line)!;
    final prefix = line.substring(0, match.start);
    final suffix = line.substring(match.end);

    final endsWithPunctuation = suffix.startsWith('.') ||
        suffix.startsWith('?') ||
        suffix.startsWith('!') ||
        suffix.startsWith(',');

    Widget blankWidget;
    if (_isAnswered) {
      final answerBg = answeredCorrectly
          ? (isDark
              ? const Color(0xFF064E3B).withValues(alpha: 0.6)
              : const Color(0xFFDCFCE7))
          : (isDark
              ? const Color(0xFF7F1D1D).withValues(alpha: 0.5)
              : const Color(0xFFFEE2E2));
      final answerBorder = answeredCorrectly
          ? (isDark ? const Color(0xFF22C55E) : const Color(0xFF16A34A))
          : (isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626));
      final answerTextColor = answeredCorrectly
          ? (isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D))
          : (isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C));

      blankWidget = Container(
        margin: EdgeInsets.only(left: 4, right: endsWithPunctuation ? 1 : 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
        decoration: BoxDecoration(
          color: answerBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: answerBorder,
            width: 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: (answeredCorrectly ? const Color(0xFF16A34A) : const Color(0xFFDC2626))
                  .withValues(alpha: isDark ? 0.3 : 0.12),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (answeredCorrectly) ...[
                const Icon(Icons.check_rounded, size: 14, color: Color(0xFF16A34A)),
                const SizedBox(width: 3),
              ],
              Text(
                correctAnswer,
                softWrap: false,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  color: answerTextColor,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Luxury interactive blank slot: inviting capsule awaiting user selection
      blankWidget = Container(
        margin: EdgeInsets.only(left: 4, right: endsWithPunctuation ? 1 : 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF312E81).withValues(alpha: 0.4)
              : const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark
                ? const Color(0xFF818CF8)
                : const Color(0xFF6366F1),
            width: 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark ? const Color(0xFF6366F1) : const Color(0xFF818CF8))
                  .withValues(alpha: isDark ? 0.25 : 0.12),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          '   ?   ',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
            color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4F46E5),
            letterSpacing: 1.0,
          ),
        ),
      );
    }

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          if (prefix.isNotEmpty) TextSpan(text: prefix),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: blankWidget,
          ),
          if (suffix.isNotEmpty) TextSpan(text: suffix),
        ],
      ),
    );
  }

  static String _getSpeakerEmoji(String speaker, bool isFirst) {
    final s = speaker.toLowerCase().trim();
    if (s.contains('선생님') || s.contains('교사') || s.contains('교수')) return '👩‍🏫';
    if (s.contains('학생')) return '🧑‍🎓';
    if (s.contains('의사')) return '👨‍⚕️';
    if (s.contains('약사') || s.contains('간호사')) return '👩‍⚕️';
    if (s.contains('환자')) return '🤒';
    if (s.contains('알바') || s.contains('점원') || s.contains('직원') || s.contains('주인')) return '🏪';
    if (s.contains('손님') || s.contains('고객')) return '🙋';
    if (s.contains('기사') || s.contains('운전')) return '🚕';
    if (s.contains('승객')) return '🙋';
    if (s.contains('선배')) return '🧑‍💼';
    if (s.contains('후배')) return '🙋';
    if (s.contains('친구')) return '🧑‍🤝‍🧑';
    if (s.contains('외국인') || s.contains('관광객')) return '🌏';
    if (s.contains('한국인') || s.contains('주민')) return '🇰🇷';
    if (s.contains('엄마') || s.contains('어머니')) return '👩';
    if (s.contains('아빠') || s.contains('아버지')) return '👨';
    if (s.contains('할머니')) return '👵';
    if (s.contains('할아버지')) return '👴';
    if (s.contains('동료') || s.contains('부장') || s.contains('과장') || s.contains('팀장')) return '👔';
    if (s.contains('경찰')) return '👮';
    if (s.contains('배달') || s.contains('라이더')) return '🛵';
    if (s.contains('철수') || s.contains('민수') || s == '가' || s == 'a') return '🙋‍♂️';
    if (s.contains('영희') || s.contains('지수') || s == '나' || s == 'b') return '🙋‍♀️';
    return isFirst ? '🙋‍♂️' : '🙋‍♀️';
  }

  List<_DialogueTurn> _parseQuestionDialogue(String rawQuestion) {
    // 1. Unescape literal '\n' and normalize all line breaks
    var normalized = rawQuestion
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\r\n', '\n')
        .replaceAll('\r', '\n');

    // Normalize excessive spaces inside parentheses (e.g. "(                 )" -> "(   )")
    normalized = normalized.replaceAll(RegExp(r'\(\s{2,}\)'), '(   )');

    List<String> rawLines = [];
    if (normalized.contains('\n')) {
      rawLines = normalized.split('\n');
    } else {
      // Split if secondary speaker prefix occurs inline: e.g. "선생님: ... 학생들: ..."
      final inlineSpeakerPattern = RegExp(r'(?<=[.?!~])\s+(?=[^:\n\r]{1,8}\s*:)');
      if (inlineSpeakerPattern.hasMatch(normalized)) {
        rawLines = normalized.split(inlineSpeakerPattern);
      } else {
        rawLines = [normalized];
      }
    }

    final List<_DialogueTurn> turns = [];
    for (int i = 0; i < rawLines.length; i++) {
      final line = rawLines[i].trim();
      if (line.isEmpty) continue;

      String speakerName = (i == 0) ? '가' : '나';
      String content = line;

      // Extract ANY speaker prefix: e.g. "선생님: ...", "학생들: ...", "철수: ..."
      final prefixMatch = RegExp(r'^([^:\n\r]{1,10})\s*:\s*(.*)$').firstMatch(line);
      if (prefixMatch != null) {
        speakerName = prefixMatch.group(1)!.trim();
        content = prefixMatch.group(2)!.trim();
      }

      // Compact any remaining multi-spaces inside parentheses
      content = content.replaceAll(RegExp(r'\(\s{2,}\)'), '(   )');

      final emoji = _getSpeakerEmoji(speakerName, i == 0);

      turns.add(_DialogueTurn(
        speakerName: speakerName,
        emoji: emoji,
        content: content,
        isBlankTarget: _blankPattern.hasMatch(content),
        isFirst: (i == 0),
      ));
    }

    // Fallback if empty
    if (turns.isEmpty) {
      turns.add(_DialogueTurn(
        speakerName: '가',
        emoji: '🙋‍♂️',
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
    final isCorrect = _isAnswered && index == correctIndex;
    final isSelectedWrong = _isAnswered && index == _selectedOptionIndex && index != correctIndex;
    final isOtherUnselected = _isAnswered && index != correctIndex && index != _selectedOptionIndex;

    // Premium Uniform Color Palette & 3D Tactile Shadows
    Color cardBg;
    Color borderColor;
    Color bottom3dBaseColor;
    Color textColor;
    Color badgeBg;
    Color badgeTextColor;
    Color badgeBorderColor;
    Widget? statusBadge;

    if (isCorrect) {
      cardBg = isDark
          ? const Color(0xFF064E3B).withValues(alpha: 0.5)
          : const Color(0xFFECFDF5);
      borderColor = const Color(0xFF16A34A);
      bottom3dBaseColor = const Color(0xFF15803D);
      textColor = isDark ? const Color(0xFF86EFAC) : const Color(0xFF14532D);
      badgeBg = const Color(0xFF16A34A);
      badgeTextColor = Colors.white;
      badgeBorderColor = const Color(0xFF15803D);
      statusBadge = Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Color(0xFF16A34A),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 17,
        ),
      );
    } else if (isSelectedWrong) {
      cardBg = isDark
          ? const Color(0xFF7F1D1D).withValues(alpha: 0.45)
          : const Color(0xFFFEF2F2);
      borderColor = const Color(0xFFDC2626);
      bottom3dBaseColor = const Color(0xFF991B1B);
      textColor = isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B);
      badgeBg = const Color(0xFFDC2626);
      badgeTextColor = Colors.white;
      badgeBorderColor = const Color(0xFF991B1B);
      statusBadge = Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Color(0xFFDC2626),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close_rounded,
          color: Colors.white,
          size: 17,
        ),
      );
    } else if (isOtherUnselected) {
      cardBg = isDark
          ? const Color(0xFF0F172A).withValues(alpha: 0.35)
          : const Color(0xFFF8FAFC);
      borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
      bottom3dBaseColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFCBD5E1);
      textColor = isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8);
      badgeBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
      badgeTextColor = isDark ? const Color(0xFF334155) : const Color(0xFF94A3B8);
      badgeBorderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    } else {
      // Default interactive state: crisp, tactile, clean
      cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
      borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
      bottom3dBaseColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFCBD5E1);
      textColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
      badgeBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
      badgeTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
      badgeBorderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    }

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
          width: isCorrect || isSelectedWrong ? 1.8 : 1.4,
        ),
        boxShadow: [
          // 3D tactile hard base
          BoxShadow(
            color: bottom3dBaseColor,
            offset: const Offset(0, 3.2),
            blurRadius: 0,
          ),
          if (!_isAnswered)
            BoxShadow(
              color: (isDark ? Colors.black : const Color(0xFF64748B))
                  .withValues(alpha: isDark ? 0.35 : 0.07),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: _isAnswered ? null : () => _onOptionSelected(index),
          borderRadius: BorderRadius.circular(18),
          splashColor: (isDark ? const Color(0xFF3B82F6) : const Color(0xFF60A5FA))
              .withValues(alpha: 0.15),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                // 3D tactile squircle keycap index badge
                Container(
                  width: 35,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: badgeBorderColor,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withValues(alpha: 0.3) : const Color(0xFFCBD5E1),
                        offset: const Offset(0, 1.5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                      color: badgeTextColor,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Option Korean text
                Expanded(
                  child: Text(
                    optionText,
                    softWrap: true,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: isCorrect || isSelectedWrong ? FontWeight.w800 : FontWeight.w700,
                      color: textColor,
                      height: 1.3,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),

                // Pronunciation TTS Button in rounded capsule
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => TtsService().speak(optionText),
                    child: Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0F172A).withValues(alpha: 0.6)
                            : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155).withValues(alpha: 0.6)
                              : const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.volume_up_rounded,
                        size: 19,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),

                // Trailing Status Badge (Checkmark or Cross)
                if (statusBadge != null) ...[
                  const SizedBox(width: 8),
                  statusBadge,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWordAssemblySection(
    BuildContext context,
    QuizQuestion currentQuestion,
    bool isDark,
  ) {
    final isCorrect = _isAnswered && _selectedOptionIndex == currentQuestion.answerIndex;
    final isWrong = _isAnswered && _selectedOptionIndex != currentQuestion.answerIndex;

    Color assemblyBorderColor;
    Color assemblyBgColor;
    if (isCorrect) {
      assemblyBorderColor = const Color(0xFF22C55E);
      assemblyBgColor = isDark ? const Color(0xFF14532D).withValues(alpha: 0.3) : const Color(0xFFF0FDF4);
    } else if (isWrong) {
      assemblyBorderColor = const Color(0xFFEF4444);
      assemblyBgColor = isDark ? const Color(0xFF7F1D1D).withValues(alpha: 0.3) : const Color(0xFFFEF2F2);
    } else if (_assembledChips.isNotEmpty) {
      assemblyBorderColor = const Color(0xFF3B82F6);
      assemblyBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    } else {
      assemblyBorderColor = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
      assemblyBgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Mode badge indicator
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.25 : 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.extension_rounded,
                    size: 14,
                    color: Color(0xFF6366F1),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    AppStrings.tr('quiz_assembly_tag', _currentLangCode),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (_assembledChips.isNotEmpty && !_isAnswered)
              GestureDetector(
                onTap: _resetAssembledChips,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.restart_alt_rounded,
                      size: 16,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppStrings.tr('quiz_reset_chips', _currentLangCode),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        // 1. Assembled Sentence Slot
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(minHeight: 88),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: assemblyBgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: assemblyBorderColor, width: 1.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _assembledChips.isEmpty
              ? Center(
                  child: Text(
                    AppStrings.tr('quiz_assembly_hint', _currentLangCode),
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    ),
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: List.generate(_assembledChips.length, (slotIdx) {
                    final chip = _assembledChips[slotIdx];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _isAnswered ? null : () => _onAssembledChipRemoved(slotIdx),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? const Color(0xFF3B82F6) : const Color(0xFF60A5FA),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                chip,
                                style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                                ),
                              ),
                              if (!_isAnswered) ...[
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.close_rounded,
                                  size: 15,
                                  color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
        ),
        const SizedBox(height: 18),

        // 2. Word Bank (Chip Pool)
        Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(_bankChips.length, (bankIdx) {
              final chip = _bankChips[bankIdx];
              final isUsed = _usedBankChipIndices.contains(bankIdx);

              if (isUsed) {
                // Ghost placeholder holding physical layout position
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B).withValues(alpha: 0.25)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      style: BorderStyle.solid,
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    chip,
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? const Color(0xFF475569).withValues(alpha: 0.5)
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                );
              }

              // Active Word Chip
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: _isAnswered ? null : () => _onChipTapped(bankIdx),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? const Color(0xFF0F172A).withValues(alpha: 0.6)
                              : const Color(0xFF94A3B8).withValues(alpha: 0.35),
                          offset: const Offset(0, 2.8),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      chip,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                        color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 22),

        // 3. Tactile [Check Answer] CTA Button
        if (!_isAnswered)
          Container(
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: _assembledChips.isNotEmpty
                  ? const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  : null,
              color: _assembledChips.isEmpty
                  ? (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))
                  : null,
              boxShadow: _assembledChips.isNotEmpty
                  ? [
                      const BoxShadow(
                        color: Color(0xFF1E40AF),
                        offset: Offset(0, 3.2),
                        blurRadius: 0,
                      ),
                      BoxShadow(
                        color: const Color(0xFF2563EB)
                            .withValues(alpha: isDark ? 0.4 : 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _assembledChips.isNotEmpty ? _submitAssembledAnswer : null,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: _assembledChips.isNotEmpty
                            ? Colors.white
                            : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.tr('quiz_check_answer', _currentLangCode),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2,
                          color: _assembledChips.isNotEmpty
                              ? Colors.white
                              : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFeedbackBottomBar(BuildContext context, bool isLastQuestion, bool isDark) {
    final currentQuestion = _questions[_currentIndex];
    final isCorrect = _selectedOptionIndex == currentQuestion.answerIndex;
    final currentLang = _getCurrentLanguageOption();

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.65,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: isDark
            ? const Border(
                top: BorderSide(color: Color(0xFF334155), width: 1.2),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: isDark ? 0.45 : 0.12),
            blurRadius: 16,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Subtle top indicator pill
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isCorrect
                    ? const Color(0xFF22C55E).withValues(alpha: 0.6)
                    : const Color(0xFFEF4444).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
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
                      Expanded(
                        child: Text(
                          isCorrect
                              ? AppStrings.tr('quiz_correct_feedback', _currentLangCode)
                              : AppStrings.tr('quiz_incorrect_feedback', _currentLangCode),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isCorrect
                                ? (isDark ? const Color(0xFF4ADE80) : const Color(0xFF15803D))
                                : (isDark ? const Color(0xFFF87171) : const Color(0xFFB91C1C)),
                          ),
                        ),
                      ),
                      if (isCorrect) ...[
                        const SizedBox(width: 8),
                        TweenAnimationBuilder<double>(
                          key: ValueKey('combo_$_currentIndex'),
                          tween: Tween(begin: 0.6, end: 1.0),
                          duration: const Duration(milliseconds: 380),
                          curve: Curves.elasticOut,
                          builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF78350F).withValues(alpha: 0.45)
                                  : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark ? const Color(0xFFF59E0B) : const Color(0xFFFCD34D),
                              ),
                            ),
                            child: Text(
                              _combo >= 2
                                  ? '🔥 ${AppStrings.tr('quiz_combo', _currentLangCode, {'n': '$_combo'})}'
                                  : '+${ProgressService.xpPerCorrect} XP',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                              TtsService().speak(_completedAnswerLine(currentQuestion));
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

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
              backgroundColor: isCorrect ? const Color(0xFF16A34A) : const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 2,
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
  final String emoji;
  final String content;
  final bool isBlankTarget;
  final bool isFirst;

  const _DialogueTurn({
    required this.speakerName,
    required this.emoji,
    required this.content,
    required this.isBlankTarget,
    required this.isFirst,
  });
}
