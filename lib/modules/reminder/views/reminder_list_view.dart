// lib/modules/reminder/views/reminder_list_view.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reminder_controller.dart';
import 'add_reminder_view.dart';
import 'edit_reminder_view.dart';
import 'package:medal/widgets/reminder_info_card.dart';

class ReminderListView extends StatelessWidget {
  final ReminderController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser ;

    if (user == null) {
      return Scaffold(
        body: Center(child: Text('Silakan login untuk melihat pengingat.')),
      );
    }

    controller.fetchReminders(user.uid);

    return Scaffold(
      body: Obx(() {
        if (controller.reminders.isEmpty) {
          return Center(child: Text('Belum ada pengingat obat.'));
        }

        // return ListView.builder(
        //   itemCount: controller.reminders.length,
        //   itemBuilder: (context, index) {
        //     final reminder = controller.reminders[index];

        //     return ListTile(
        //       title: Text(reminder.medicineName),
        //       subtitle: Text(
        //         'Jam Minum: ${reminder.times.join(', ')}\n'
        //             'Dosis: ${reminder.doses} ${reminder.medicineType}',
        //       ),
        //       onTap: () {
        //         Get.to(ReminderDetailView(reminder: reminder));
        //       },
        //     );
        //   },
        // );

        return ListView.builder(
          itemCount: controller.reminders.length,
          itemBuilder: (context, index) {
            final reminder = controller.reminders[index];
            return ReminderInfoCard(
              medicineName: reminder.medicineName,
              times: reminder.times,
              supply: reminder.supply,
              medicineType: reminder.medicineType,
              onTap: () {
                Get.to(EditReminderView(reminder: reminder));
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddReminderView());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}