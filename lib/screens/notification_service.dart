import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Inisialisasi timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    // Konfigurasi Android
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Ganti dengan ikon aplikasi Anda

    const InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);

    await _notificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static Future<void> requestNotificationPermissionWithNotification() async {
    var status = await Permission.notification.status;

    if (status.isGranted) {
      return; // Izin sudah diberikan
    }

    // Kirim notifikasi untuk meminta izin
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'permission_request_channel',
      'Permintaan Izin Notifikasi',
      channelDescription:
      'Gunakan izin ini untuk menampilkan pengingat obat secara tepat waktu.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      1, // ID notifikasi khusus untuk permintaan izin
      'Izin Notifikasi Dibutuhkan',
      'Berikan izin notifikasi agar pengingat obat dapat ditampilkan tepat waktu.',
      notificationDetails,
    );

    // Tunggu pengguna memberi izin
    Future.delayed(Duration(seconds: 5), () async {
      status = await Permission.notification.request();
      if (status.isGranted) {
        await _notificationsPlugin.cancel(1); // Hapus notifikasi permintaan
        await showInstantNotification(
          title: 'Terima Kasih!',
          body: 'Izin notifikasi berhasil diberikan.',
        );
      }
    });
  }

  static Future<void> showInstantNotification(
      {required String title, required String body}) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'instant_notification_channel',
      'Notifikasi Instan',
      channelDescription: 'Notifikasi untuk pengujian instan',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0, // ID Notifikasi
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> scheduleNotification({
    required int id, // ID unik untuk setiap notifikasi
    required String title,
    required String body,
    required DateTime scheduleTime,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id, // Gunakan ID unik
      title,
      body,
      tz.TZDateTime.from(scheduleTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_notification_channel',
          'Notifikasi Terjadwal',
          channelDescription: 'Notifikasi untuk pengingat jadwal',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

}
