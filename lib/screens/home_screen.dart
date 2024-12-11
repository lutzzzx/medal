import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  Timer? _timer;
  DateTime _currentDate = DateTime.now();
  bool _showCompleted = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) => setState(() {}));
    _resetStatusIfNewDay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _resetStatusIfNewDay() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReset = prefs.getString('lastResetDate') ?? '';
    final today = "${_currentDate.year}-${_currentDate.month.toString().padLeft(2, '0')}-${_currentDate.day.toString().padLeft(2, '0')}";

    if (lastReset != today) {
      final reminders = await FirebaseFirestore.instance
          .collection('reminders')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in reminders.docs) {
        Map<String, dynamic> statusMap = Map<String, dynamic>.from(doc['status']);
        statusMap.updateAll((key, value) => false);
        await doc.reference.update({'status': statusMap, 'date': today});
      }

      await prefs.setString('lastResetDate', today);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Obat Harian'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reminders')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Tidak ada pengingat obat untuk hari ini.'));
          }

          final reminders = snapshot.data!.docs;
          final now = DateTime.now();
          final formattedTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

          // Pisahkan daftar obat menjadi dua kategori
          List<Widget> activeList = [];
          List<Widget> completedList = [];

          for (var reminder in reminders) {
            final medicineName = reminder['medicineName'];
            final doses = int.tryParse(reminder['doses']) ?? 0;
            final medicineType = reminder['medicineType'];
            final times = List<String>.from(reminder['times']);
            final statusMap = Map<String, bool>.from(reminder['status']);
            final supply = reminder['supply'] ?? 0;

            for (var time in times) {
              final isDue = time.compareTo(formattedTime) <= 0;
              final isChecked = statusMap[time] ?? false;

              // Jangan tampilkan obat yang belum waktunya
              if (!isDue) continue;

              final listItem = ListTile(
                title: Text(
                  medicineName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDue && !isChecked ? Colors.red : Colors.black,
                  ),
                ),
                subtitle: Text(
                  "Waktu: $time - Dosis: $doses $medicineType",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Checkbox(
                  value: isChecked,
                  onChanged: (value) async {
                    if (value != null) {
                      final newSupply = value ? supply - doses : supply + doses;
                      if (newSupply < 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Persediaan obat tidak mencukupi!')),
                        );
                        return;
                      }

                      await FirebaseFirestore.instance
                          .collection('reminders')
                          .doc(reminder.id)
                          .update({
                        'status.$time': value,
                        'supply': newSupply,
                      });
                    }
                  },
                ),
              );

              if (isChecked) {
                completedList.add(listItem);
              } else {
                activeList.add(listItem);
              }
            }
          }

          return ListView(
            children: [
              // Daftar obat aktif
              ...activeList,
              Divider(),
              // Bagian obat selesai diminum
              ListTile(
                title: Text(
                  'Obat yang telah selesai diminum',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: Icon(_showCompleted ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _showCompleted = !_showCompleted;
                    });
                  },
                ),
              ),
              if (_showCompleted) ...completedList,
            ],
          );
        },
      ),
    );
  }
}