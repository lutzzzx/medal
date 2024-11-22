import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medal/screens/home_screen.dart';
import 'package:medal/screens/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initialize();
  NotificationService.requestNotificationPermissionWithNotification();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medication Reminder',
      home: HomeScreen(),
    );
  }
}
