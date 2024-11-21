import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medal/screens/home_screen.dart';
import 'package:medal/screens/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
  await NotificationService.initialize();
  await NotificationService.requestPermission();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medication Reminder',
      home: HomeScreen(), // Halaman pertama adalah login
    );
  }
}
