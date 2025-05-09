import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:medal/modules/layout/controllers/layout_controller.dart';

class LayoutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User ? user) {
      if (user == null) {
        print('User  logged out, navigating to login page.');
        Get.offAllNamed('/login');
      }
    });

    final LayoutController layoutController = Get.find<LayoutController>();

    return Obx(() {
      final index = layoutController.selectedIndex.value;
      if (index < 0 || index >= layoutController.pages.length) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: Text('Invalid page index')),
        );
      }

      final user = FirebaseAuth.instance.currentUser ;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(layoutController.pageTitles[index]),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: user != null && user.photoURL != null
                  ? CircleAvatar(
                backgroundImage: NetworkImage(user.photoURL!),
              )
                  : Icon(Icons.account_circle),
              onPressed: () {
                Get.toNamed('/profile');
              },
            ),
          ],
        ),
        body: Center(
          child: layoutController.pages[index],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              label: 'Pengingat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Cari',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Kunjungan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate),
              label: 'Kalkulator',
            ),
          ],
          currentIndex: index,
          selectedItemColor: const Color(0xFF0077B6),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 30,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          onTap: layoutController.onItemTapped,
        ),
      );
    });
  }
}