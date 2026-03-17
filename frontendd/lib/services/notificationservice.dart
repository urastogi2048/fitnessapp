import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:frontendd/core/logger.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const int _streakHour = 7;
  static const int _streakMinute = 20;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tzdata.initializeTimeZones();
    final localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone));
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    const AndroidNotificationChannel streakChannel = AndroidNotificationChannel(
      'streak_reminder_channel',
      'Streak Reminders',
      description: 'Daily reminders to maintain your workout streak',
      importance: Importance.max,
    );

    const AndroidNotificationChannel testChannel = AndroidNotificationChannel(
      'test_channel',
      'Test Notifications',
      description: 'Test notifications',
      importance: Importance.max,
    );

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(streakChannel);
    await androidPlugin?.createNotificationChannel(testChannel);

    _initialized = true;
    Logger.debug('Notification Service initialized with timezone: ${tz.local.name}');
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    Logger.debug('Notification tapped: ${response.payload}');
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final notificationStatus = await Permission.notification.request();
      Logger.debug('Permissions -> notifications=${notificationStatus.isGranted}');

      return notificationStatus.isGranted;
    } else if (Platform.isIOS) {
      final bool? granted = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }
    return true;
  }

  Future<void> scheduleDailyStreakReminder() async {
    await initialize();
    await cancelStreakReminder(); // Cancel existing first

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      _streakHour,
      _streakMinute,
      0,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    Logger.debug('Now: ${now.toLocal()} | Scheduled: ${scheduledDate.toLocal()}');

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'streak_reminder_channel',
          'Streak Reminders',
          channelDescription: 'Daily reminders to maintain your workout streak',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      0,
      '🔥 Keep Your Streak Alive!',
      'Don\'t break your streak! Complete a workout today to keep the fire burning.',
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    Logger.debug('Daily streak reminder scheduled for ${scheduledDate.toLocal()}');

    final pending = await _notificationsPlugin.pendingNotificationRequests();
    Logger.debug('Pending scheduled notifications: ${pending.length}');
    for (final p in pending) {
      Logger.debug(' - ID ${p.id}: ${p.title}');
    }
  }

  /// Show test notification
  Future<void> showTestNotification() async {
    await initialize();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          channelDescription: 'Test notifications',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      999,
      'Test Notification',
      'Notifications are working!',
      notificationDetails,
    );

    // Also schedule a 1-minute test to verify scheduled notifications
    await _scheduleTestInMinutes(1);
  }

  Future<void> _scheduleTestInMinutes(int minutes) async {
    final scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(Duration(minutes: minutes));

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          channelDescription: 'Test notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.zonedSchedule(
      998,
      '⏰ Scheduled Test',
      'If you see this, scheduled notifications work!',
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    Logger.debug('Scheduled test notification for ${scheduledDate.toLocal()}');

    final pending = await _notificationsPlugin.pendingNotificationRequests();
    Logger.debug('Total pending after test schedule: ${pending.length}');
  }

  /// Cancel the daily streak reminder
  Future<void> cancelStreakReminder() async {
    await _notificationsPlugin.cancel(0);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
