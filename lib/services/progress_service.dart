import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists learner progress: daily streak, daily XP goal,
/// theme mode preference, learned question IDs and mistakes.
class ProgressService extends ChangeNotifier {
  static final ProgressService _instance = ProgressService._internal();
  factory ProgressService() => _instance;
  ProgressService._internal();

  static const int dailyGoalXp = 50;
  static const int xpPerCorrect = 10;

  static const _kStreak = 'progress_streak';
  static const _kLastActive = 'progress_last_active';
  static const _kXpDate = 'progress_xp_date';
  static const _kXpToday = 'progress_xp_today';
  static const _kLearned = 'progress_learned_ids';
  static const _kWrong = 'progress_wrong_ids';
  static const _kThemeMode = 'app_theme_mode';
  static const _kLanguage = 'app_language';

  SharedPreferences? _prefs;
  int _streak = 0;
  String? _lastActive;
  String? _xpDate;
  int _xpToday = 0;
  Set<int> _learned = {};
  List<int> _wrong = [];
  ThemeMode _themeMode = ThemeMode.system;
  String _language = detectDefaultLanguage();

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _streak = _prefs!.getInt(_kStreak) ?? 0;
      _lastActive = _prefs!.getString(_kLastActive);
      _xpDate = _prefs!.getString(_kXpDate);
      _xpToday = _prefs!.getInt(_kXpToday) ?? 0;
      _learned = (_prefs!.getStringList(_kLearned) ?? [])
          .map(int.tryParse)
          .whereType<int>()
          .toSet();
      _wrong = (_prefs!.getStringList(_kWrong) ?? [])
          .map(int.tryParse)
          .whereType<int>()
          .toList();

      final savedLang = _prefs!.getString(_kLanguage);
      if (savedLang != null && savedLang.isNotEmpty) {
        _language = savedLang;
      } else {
        _language = detectDefaultLanguage();
      }

      final savedTheme = _prefs!.getString(_kThemeMode);
      if (savedTheme == 'light') {
        _themeMode = ThemeMode.light;
      } else if (savedTheme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
    } catch (e) {
      debugPrint('ProgressService init error: $e');
    }
  }

  static String detectDefaultLanguage() {
    try {
      final code = WidgetsBinding.instance.platformDispatcher.locale.languageCode.toLowerCase();
      if (code.startsWith('vi')) return 'VI';
      if (code.startsWith('zh')) return 'ZH';
      if (code.startsWith('ja')) return 'JA';
      if (code.startsWith('es')) return 'ES';
      if (code.startsWith('pt')) return 'PT';
      if (code.startsWith('ko')) return 'KO';
      return 'EN';
    } catch (_) {
      return 'VI';
    }
  }

  String get language => _language;

  void setLanguage(String code) {
    if (_language == code) return;
    _language = code;
    _prefs?.setString(_kLanguage, code);
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;

  /// Toggles between light and dark mode, saving the preference
  void toggleTheme(BuildContext context) {
    final isCurrentlyDark = _themeMode == ThemeMode.dark ||
        (_themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    _themeMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    _prefs?.setString(_kThemeMode, _themeMode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    final modeStr = mode == ThemeMode.dark
        ? 'dark'
        : mode == ThemeMode.light
            ? 'light'
            : 'system';
    _prefs?.setString(_kThemeMode, modeStr);
    notifyListeners();
  }

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String get _today => _dateKey(DateTime.now());
  String get _yesterday => _dateKey(DateTime.now().subtract(const Duration(days: 1)));

  /// Current streak (0 if the learner missed a day).
  int get streak {
    if (_lastActive == _today || _lastActive == _yesterday) return _streak;
    return 0;
  }

  bool get studiedToday => _lastActive == _today;
  int get xpToday => _xpDate == _today ? _xpToday : 0;
  bool get dailyGoalReached => xpToday >= dailyGoalXp;
  Set<int> get learnedIds => Set.unmodifiable(_learned);
  List<int> get wrongIds => List.unmodifiable(_wrong);
  bool isLearned(int id) => _learned.contains(id);

  /// Record a single answer.
  /// If [isRetry] is true (re-queued question within normal quiz session),
  /// answering correctly does not prematurely remove the question from the persistent mistake notebook,
  /// unless [isReview] is explicitly true (Review Mode).
  void recordAnswer(
    int questionId,
    bool isCorrect, {
    bool isRetry = false,
    bool isReview = false,
  }) {
    if (isCorrect) {
      _learned.add(questionId);
      if (!isRetry || isReview) {
        _wrong.remove(questionId);
      }
      if (_xpDate != _today) {
        _xpDate = _today;
        _xpToday = 0;
      }
      _xpToday += xpPerCorrect;
    } else if (!_wrong.contains(questionId)) {
      _wrong.add(questionId);
    }
    _persistAnswers();
    notifyListeners();
  }

  /// Called once when a session is finished – updates the daily streak.
  Future<void> completeSession() async {
    if (_lastActive != _today) {
      _streak = (_lastActive == _yesterday) ? _streak + 1 : 1;
      _lastActive = _today;
      await _prefs?.setInt(_kStreak, _streak);
      await _prefs?.setString(_kLastActive, _today);
    }
    notifyListeners();
  }

  void _persistAnswers() {
    final p = _prefs;
    if (p == null) return;
    p.setString(_kXpDate, _xpDate ?? _today);
    p.setInt(_kXpToday, _xpToday);
    p.setStringList(_kLearned, _learned.map((e) => '$e').toList());
    p.setStringList(_kWrong, _wrong.map((e) => '$e').toList());
  }
}
