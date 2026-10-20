import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists learner progress: daily streak, daily XP goal,
/// learned (correctly answered) question IDs and mistakes to review.
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

  SharedPreferences? _prefs;
  int _streak = 0;
  String? _lastActive;
  String? _xpDate;
  int _xpToday = 0;
  Set<int> _learned = {};
  List<int> _wrong = [];

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
    } catch (e) {
      debugPrint('ProgressService init error: $e');
    }
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

  /// Record a single answer (called on the first attempt and on review retries).
  void recordAnswer(int questionId, bool isCorrect) {
    if (isCorrect) {
      _learned.add(questionId);
      _wrong.remove(questionId);
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
