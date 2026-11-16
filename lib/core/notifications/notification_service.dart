import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_10y.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Local notifications only; nothing leaves the device.
abstract interface class NotificationService {
  Future<void> init();

  /// Asks for notification permission (Android 13+, iOS). Returns whether it was granted.
  Future<bool> requestPermission();

  /// Fires when the rest timer ends, even with the screen off or the app closed.
  Future<void> scheduleRestEnd(
    DateTime at, {
    required String title,
    required String body,
    required bool sound,
  });
  Future<void> cancelRestEnd();

  /// Replaces all weekly workout reminders. [weekdays] uses ISO numbering (1 = Monday).
  Future<void> scheduleReminders(
    Set<int> weekdays,
    int minutesAfterMidnight, {
    required String title,
    required String body,
  });
}

/// Used in tests and on platforms without notification support.
class NoopNotificationService implements NotificationService {
  DateTime? restEnd;
  Set<int> reminderDays = {};

  @override
  Future<void> init() async {}
  @override
  Future<bool> requestPermission() async => true;
  @override
  Future<void> scheduleRestEnd(
    DateTime at, {
    required String title,
    required String body,
    required bool sound,
  }) async => restEnd = at;
  @override
  Future<void> cancelRestEnd() async => restEnd = null;
  @override
  Future<void> scheduleReminders(
    Set<int> weekdays,
    int minutesAfterMidnight, {
    required String title,
    required String body,
  }) async => reminderDays = weekdays;
}

class LocalNotificationService implements NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  static const _restId = 1;
  static const _reminderBaseId = 100; // + ISO weekday

  @override
  Future<void> init() async {
    tzdata.initializeTimeZones();
    try {
      tz.setLocalLocation(
        tz.getLocation((await FlutterTimezone.getLocalTimezone()).identifier),
      );
    } on Object catch (e) {
      debugPrint('Timezone lookup failed, reminders fall back to UTC: $e');
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  @override
  Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, sound: true) ?? false;
    }
    return false;
  }

  /// Exact alarms need a user-granted permission on Android 12+; fall back to inexact.
  Future<AndroidScheduleMode> _scheduleMode() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final exact = await android?.canScheduleExactNotifications() ?? true;
    return exact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  @override
  Future<void> scheduleRestEnd(
    DateTime at, {
    required String title,
    required String body,
    required bool sound,
  }) async {
    await _plugin.cancel(id: _restId);
    if (!at.isAfter(DateTime.now())) return;
    await _plugin.zonedSchedule(
      id: _restId,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(at, tz.UTC),
      androidScheduleMode: await _scheduleMode(),
      notificationDetails: NotificationDetails(
        // Sound is a channel property on Android, hence two channels.
        android: AndroidNotificationDetails(
          sound ? 'rest_timer' : 'rest_timer_silent',
          sound ? 'Rest timer' : 'Rest timer (silent)',
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.alarm,
          playSound: sound,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(
          presentBanner: true,
          presentSound: sound,
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),
    );
  }

  @override
  Future<void> cancelRestEnd() => _plugin.cancel(id: _restId);

  @override
  Future<void> scheduleReminders(
    Set<int> weekdays,
    int minutesAfterMidnight, {
    required String title,
    required String body,
  }) async {
    for (var day = 1; day <= 7; day++) {
      await _plugin.cancel(id: _reminderBaseId + day);
    }
    final now = tz.TZDateTime.now(tz.local);
    for (final day in weekdays) {
      var at = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        minutesAfterMidnight ~/ 60,
        minutesAfterMidnight % 60,
      );
      while (at.weekday != day || !at.isAfter(now)) {
        at = at.add(const Duration(days: 1));
      }
      await _plugin.zonedSchedule(
        id: _reminderBaseId + day,
        title: title,
        body: body,
        scheduledDate: at,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails('reminders', 'Workout reminders'),
          iOS: DarwinNotificationDetails(),
        ),
      );
    }
  }
}
