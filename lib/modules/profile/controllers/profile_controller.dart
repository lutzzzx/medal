import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medal/services/notification_service.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get user => _auth.currentUser;

  void signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    Get.offAllNamed('/login');
  }

  Future<void> showInstantNotification() async {
    await NotificationService.showInstantNotification(
      title: "Tes Notifikasi Instan",
      body: "Ini adalah notifikasi instan untuk pengujian.",
    );
  }

  Future<void> scheduleNotification() async {
    final scheduledTime = DateTime.now().add(Duration(seconds: 10));
    await NotificationService.scheduleNotification(
      id: 0,
      title: "Tes Notifikasi Terjadwal",
      body: "Notifikasi $scheduledTime",
      scheduleTime: scheduledTime,
    );

    Get.snackbar(
      "Notifikasi",
      "Notifikasi dijadwalkan untuk $scheduledTime",
    );
  }
}
