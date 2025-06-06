import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/modules/home/controllers/home_controller.dart';
import 'package:medal/widgets/reminder_card.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Daftar Obat Hari Ini'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Obx(() => Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0), // Menambahkan margin kiri dan kanan
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Mengubah menjadi rata kiri
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.selectedTab.value = 0;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.selectedTab.value == 0
                        ? const Color(0xFF0077B6)
                        : Colors.grey[200],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Belum Diminum',
                    style: TextStyle(
                      fontSize: 12,
                      color: controller.selectedTab.value == 0
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    controller.selectedTab.value = 1;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.selectedTab.value == 1
                        ? const Color(0xFF0077B6)
                        : Colors.grey[200],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Telah Diminum',
                    style: TextStyle(
                      fontSize: 12,
                      color: controller.selectedTab.value == 1
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          )),
          SizedBox(height: 10,),
          Expanded(
            child: Obx(() {
              if (controller.reminders.isEmpty) {
                return Center(
                    child: Text(
                        'Tidak ada pengingat obat untuk hari ini.'));
              }

              final now = DateTime.now();
              final formattedTime =
                  "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
              List<Widget> listToShow = [];

              for (var reminder in controller.reminders) {
                for (var time in reminder.times) {
                  final isDue = time.compareTo(formattedTime) <= 0;
                  final isChecked = reminder.status[time] ?? false;

                  if (controller.selectedTab.value == 0 &&
                      (!isDue || isChecked)) continue;
                  if (controller.selectedTab.value == 1 &&
                      (!isDue || !isChecked)) continue;

                  // final listItem = ListTile(
                  //   title: Text(
                  //     reminder.medicineName,
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       color: isDue && !isChecked ? Colors.red : Colors.black,
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //     "Waktu: $time - Dosis: ${reminder.doses} ${reminder.medicineType} (${reminder.medicineUse})",
                  //     style: TextStyle(color: Colors.grey),
                  //   ),
                  //   trailing: Checkbox(
                  //     value: isChecked,
                  //     onChanged: (value) {
                  //       if (value != null) {
                  //         controller.updateReminderStatus(reminder, time, value);
                  //       }
                  //     },

                  //   ),
                  // );

                  final listItem = ReminderCard(
                    medicineName: reminder.medicineName,
                    time: time,
                    medicineType: reminder.medicineType,
                    isDue: isDue,
                    isChecked: isChecked,
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateReminderStatus(reminder, time, value);
                      }
                    },
                  );

                  listToShow.add(listItem);
                }
              }

              if (listToShow.isEmpty) {
                return Center(
                  child: Text(controller.selectedTab.value == 0
                      ? 'Tidak ada obat yang belum diminum.'
                      : 'Tidak ada obat yang telah diminum.'),
                );
              }

              return ListView(children: listToShow);
            }),
          ),
        ],
      ),
    );
  }
}
