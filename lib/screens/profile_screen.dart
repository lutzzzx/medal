import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth/login_screen.dart';
import 'package:medal/screens/reminder/notification_service.dart';

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
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut(); // Sign out Google account jika login menggunakan Google
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menampilkan foto profil jika tersedia
            if (user.photoURL != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.photoURL!),
              )
            else
              Icon(
                Icons.account_circle,
                size: 100,
              ),
            SizedBox(height: 20),
            // Menampilkan nama dan email pengguna
            Text('Name: ${user.displayName ?? "No Name"}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Email: ${user.email}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                // Menampilkan notifikasi instan
                await NotificationService.showInstantNotification(
                  title: "Tes Notifikasi Instan",
                  body: "Ini adalah notifikasi instan untuk pengujian.",
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                "Show Instant Notification",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Menjadwalkan notifikasi dalam 10 detik
                final scheduledTime = DateTime.now().add(Duration(seconds: 10));
                await NotificationService.scheduleNotification(
                  id: 0,
                  title: "Tes Notifikasi Terjadwal",
                  body: "Notifikasi $scheduledTime",
                  scheduleTime: scheduledTime,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Notifikasi dijadwalkan untuk $scheduledTime",
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
              ),
              child: Text(
                "Schedule Notification (10s)",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
