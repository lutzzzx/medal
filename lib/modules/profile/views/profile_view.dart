import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/widgets/detail_card.dart';
import 'package:medal/widgets/expanded_button.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    final user = controller.user;

    if (user == null) {
      Future.microtask(() => Get.offAllNamed('/login'));
      return Scaffold();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: controller.signOut,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Margin samping 20 pixel
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              DetailCard(text: 'Nama: ${user.displayName ?? "-"}', icon: Icons.person,),
              DetailCard(text: 'Email: ${user.email ?? "-"}', icon: Icons.mail,),
              SizedBox(height: 30),
              ExpandedButton(text1: 'Tes Notifikasi Instan', press1: controller.showInstantNotification),
              ExpandedButton(text1: 'Tes Notifikasi Terjadwal (10 det)', press1: controller.scheduleNotification),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),

    );
  }
}
