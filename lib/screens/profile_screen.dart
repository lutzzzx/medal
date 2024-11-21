import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medal/screens/notification_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
      return Scaffold();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No profile data found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Email: ${user.email}', style: TextStyle(fontSize: 20)),
                Text('Role: ${data['role']}', style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Logout'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final now = DateTime.now();
                    final scheduledTime = now.add(Duration(seconds: 10)); // 10 detik dari sekarang

                    await NotificationService.scheduleNotification(
                      id: 1, // ID notifikasi unik
                      title: 'Tes Reminder', // Judul notifikasi
                      body: 'Ini adalah notifikasi reminder.', // Isi notifikasi
                      scheduledTime: scheduledTime, // Waktu notifikasi
                    );

                    debugPrint("Notifikasi dijadwalkan untuk: $scheduledTime");
                  },
                  child: Text("Tes Reminder"), // Label tombol
                ),


              ],
            ),
          );
        },
      ),
    );
  }
}
