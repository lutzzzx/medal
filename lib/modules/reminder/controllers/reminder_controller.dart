import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/reminder_model.dart';
import '../../../data/repositories/reminder_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medal/services/notification_service.dart';

class ReminderController extends GetxController {
  final ReminderRepository _repository = ReminderRepository();
  var reminders = <ReminderModel>[].obs;

  void fetchReminders(String userId) {
    _repository.getReminders(userId).listen((data) {
      reminders.value = data;
    });
  }

  Future<void> addReminder(ReminderModel reminder) {
    return _repository.addReminder(reminder);
  }

  Future<void> updateReminder(ReminderModel reminder) {
    return _repository.updateReminder(reminder);
  }

  Future<void> deleteReminder(String id) {
    return _repository.deleteReminder(id);
  }

  Future<void> createReminder(
      String medicineName,
      int dailyConsumption,
      int doses,
      String medicineType,
      String medicineUse,
      int supply,
      String notes,
      List<TimeOfDay> times,
      BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser ;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda harus login untuk menambah pengingat')),
      );
      return;
    }

    try {
      final today = DateTime.now();
      final dateString = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      Map<String, bool> statusMap = {};
      for (var time in times) {
        String formattedTime = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
        statusMap[formattedTime] = false;
      }

      final reminder = ReminderModel(
        id: '', // ID akan dihasilkan oleh Firestore
        userId: user.uid,
        medicineName: medicineName,
        dailyConsumption: dailyConsumption,
        doses: doses,
        medicineType: medicineType,
        medicineUse: medicineUse,
        supply: supply,
        notes: notes,
        times: times.map((time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}').toList(),
        status: statusMap,
        date: dateString,
      );

      await addReminder(reminder);

      for (int i = 0; i < times.length; i++) {
        final time = times[i];
        final now = DateTime.now();
        final scheduledTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );

        final adjustedScheduledTime = scheduledTime.isBefore(now)
            ? scheduledTime.add(Duration(days: 1))
            : scheduledTime;

        await NotificationService.scheduleNotification(
          id: reminder.id.hashCode + i,
          title: "Saatnya Minum Obat $medicineName",
          body: "Minum obat sebanyak $doses $medicineType. Diminum $medicineUse.",
          scheduleTime: adjustedScheduledTime,
        );
      }

      Get.back();
      Get.snackbar('Berhasil', 'Pengingat berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Gagal', 'Terjadi kesalahan $e');
    }
  }

  Future<void> updateExistingReminder(
      ReminderModel reminder,
      String medicineName,
      int dailyConsumption,
      int doses,
      String medicineType,
      String medicineUse,
      int supply,
      String notes,
      List<TimeOfDay> times,
      BuildContext context) async {
    try {
      final updatedReminder = ReminderModel(
        id: reminder.id,
        userId: reminder.userId,
        medicineName: medicineName,
        dailyConsumption: dailyConsumption,
        doses: doses,
        medicineType: medicineType,
        medicineUse: medicineUse,
        supply: supply,
        notes: notes,
        times: times.map((time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}').toList(),
        status: reminder.status,
        date: reminder.date,
      );

      await updateReminder(updatedReminder);

      // Cancel old notifications
      for (int i = 0; i < reminder.times.length; i++) {
        await NotificationService.cancelNotification(reminder.id.hashCode + i);
      }

      // Schedule new notifications
      for (int i = 0; i < times.length; i++) {
        final time = times[i];
        final now = DateTime.now();
        final scheduledTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );

        final adjustedScheduledTime = scheduledTime.isBefore(now)
            ? scheduledTime.add(Duration(days: 1))
            : scheduledTime;

        await NotificationService.scheduleNotification(
          id: updatedReminder.id.hashCode + i,
          title: "Saatnya Minum Obat $medicineName",
          body: "Minum obat sebanyak $doses $medicineType. $medicineUse",
          scheduleTime: adjustedScheduledTime,
        );
      }

      Get.back();
      Get.snackbar('Berhasil', 'Pengingat berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Gagal', 'Terjadi kesalahan $e');
    }
  }
}