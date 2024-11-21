import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medal/screens/add_reminder_screen.dart';
import 'package:medal/screens/reminder_detail_screen.dart'; // Tambahkan import untuk halaman detail

class ReminderListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(child: Text('Silakan login untuk melihat pengingat.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengingat Obat'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reminders')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Belum ada pengingat obat.'));
          }

          final reminders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index]; // Dokumen Firestore
              final data = reminder.data() as Map<String, dynamic>; // Data dokumen

              return ListTile(
                title: Text(data['medicineName']),
                subtitle: Text(
                  'Jam Minum: ${List<String>.from(data['times']).join(', ')}\n'
                      'Dosis: ${data['doses']} ${data['medicineType']}',
                ),
                onTap: () {
                  // Navigasi ke halaman detail pengingat
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReminderDetailScreen(reminder: reminder),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReminderScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
