import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../data/app_localization.dart';
import 'progress_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();

      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      );

      await _notificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (response) {
          debugPrint('Notification tapped: ${response.payload}');
        },
      );

      _isInitialized = true;

      // Check notification preference and schedule
      await scheduleDailyReminder();
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
  }

  /// Request permissions for Android 13+ and iOS
  Future<bool> requestPermission() async {
    try {
      final androidPlatform = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlatform != null) {
        final granted = await androidPlatform.requestNotificationsPermission();
        return granted ?? false;
      }

      final iosPlatform = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      if (iosPlatform != null) {
        final granted = await iosPlatform.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
    } catch (e) {
      debugPrint('requestPermission error: $e');
    }
    return true;
  }

  /// Schedule daily smart reminder at 20:30 (8:30 PM) in user's native language
  Future<void> scheduleDailyReminder() async {
    try {
      final progress = ProgressService();
      if (!progress.isNotificationEnabled) {
        await cancelAll();
        return;
      }

      final langCode = progress.language;
      final title = AppStrings.tr('notif_title_daily', langCode);
      final body = AppStrings.tr('notif_body_daily', langCode);

      const androidDetails = AndroidNotificationDetails(
        'daily_study_reminder',
        'Daily Study Reminder',
        channelDescription:
            'Reminds learners to complete their daily Korean quiz goal',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const notifDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );

      // Cancel previous scheduled to avoid duplicates
      await _notificationsPlugin.cancel(id: 1001);

      // Compute next 20:30
      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, 20, 30);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _notificationsPlugin.zonedSchedule(
        id: 1001,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: notifDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'daily_quiz',
      );
    } catch (e) {
      debugPrint('scheduleDailyReminder error: $e');
    }
  }

  Future<void> cancelAll() async {
    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      debugPrint('cancelAll error: $e');
    }
  }
}
