import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/reminder_model.dart';
import '../../../data/repositories/reminder_repository.dart';

class HomeController extends GetxController {
  final ReminderRepository _reminderRepository = ReminderRepository();
  final String userId = FirebaseAuth.instance.currentUser ?.uid ?? '';
  var reminders = <ReminderModel>[].obs;
  var selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _resetStatusIfNewDay();
    _fetchReminders();
  }

  void _fetchReminders() {
    _reminderRepository.getReminders(userId).listen((data) {
      reminders.value = data;
    });
  }

  Future<void> _resetStatusIfNewDay() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReset = prefs.getString('lastResetDate') ?? '';
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastReset != today) {
      final remindersSnapshot = await FirebaseFirestore.instance
          .collection('reminders')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in remindersSnapshot.docs) {
        Map<String, dynamic> statusMap = Map<String, dynamic>.from(doc['status']);
        statusMap.updateAll((key, value) => false);
        await doc.reference.update({'status': statusMap, 'date': today});
      }

      await prefs.setString('lastResetDate', today);
    }
  }

  void updateReminderStatus(ReminderModel reminder, String time, bool value) async {
    final newSupply = value ? reminder.supply - reminder.doses : reminder.supply + reminder.doses;
    if (newSupply < 0) {
      Get.snackbar('Error', 'Persediaan obat tidak mencukupi!');
      return;
    }
    final updatedStatus = Map<String, bool>.from(reminder.status);
    updatedStatus[time] = value;

    await FirebaseFirestore.instance
        .collection('reminders')
        .doc(reminder.id)
        .update({
      'status': updatedStatus,
      'supply': newSupply,
    });

    // Update local reminders
    reminder.status[time] = value;
    reminders.refresh();
  }
}