import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Inisialisasi TimeZone
    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta')); // Set ke timezone lokal
      debugPrint('TimeZone berhasil diatur: ${tz.local}');
    } catch (e) {
      debugPrint('Gagal mengatur TimeZone: $e');
    }

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminder_channel',
      'Reminder Notifications',
      description: 'Channel for reminder notifications',
      importance: Importance.max,
    );

    final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    try {
      await androidPlugin?.createNotificationChannel(channel);
      debugPrint("Channel berhasil dibuat: ${channel.id}");
    } catch (e) {
      debugPrint("Gagal membuat channel: $e");
    }

    final channelList = await androidPlugin?.getNotificationChannels();
    if (channelList == null || channelList.isEmpty) {
      debugPrint("Tidak ada channel yang tersedia!");
    } else {
      debugPrint("Channels yang tersedia: $channelList");
    }

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint("Notification clicked: ${response.payload}");
      },
    );

    debugPrint("Notification service initialized.");
  }


  static Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      if (await _isAndroid13OrHigher()) {
        final status = await Permission.notification.request();
        if (status.isGranted) {
          debugPrint("Notification permission granted.");
        } else {
          debugPrint("Notification permission denied.");
        }
      } else {
        debugPrint("Notification permission not required for Android < 13.");
      }
    } else if (Platform.isIOS) {
      final iosPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final granted = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint("iOS notification permission granted: $granted");
    }
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final now = DateTime.now();

    debugPrint("Sekarang (local): $now");
    debugPrint("Dijadwalkan (local): $scheduledTime");
    debugPrint("Menggunakan ID notifikasi: $id");

    if (scheduledTime.isBefore(now)) {
      debugPrint("Waktu notifikasi sudah lewat: $scheduledTime");
      return;
    }

    try {
      final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);
      debugPrint("TimeZone lokal: ${tz.local}, Waktu terkonversi: $tzTime");

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel',
            'Reminder Notifications',
            channelDescription: 'Channel for reminder notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexact,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );

      debugPrint("Notifikasi berhasil dijadwalkan untuk $tzTime.");
    } catch (e) {
      debugPrint("Gagal menjadwalkan notifikasi: $e");
    }
  }


  static Future<bool> _isAndroid13OrHigher() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt >= 33;
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
    debugPrint("Notification with ID $id canceled.");
  }

  static Future<void> showTestNotification() async {
    try {
      await _notificationsPlugin.show(
        10,
        "Tes Notifikasi",
        "Apakah ini muncul?",
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel',
            'Reminder Notifications',
            channelDescription: 'Channel for reminder notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
        ),
      );

      debugPrint("Notifikasi instan berhasil ditampilkan.");
    } catch (e) {
      debugPrint("Error saat menampilkan notifikasi instan: $e");
    }
  }
}
