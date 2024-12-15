import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medal/routes/app_routes.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(''),
            accountEmail: Text(FirebaseAuth.instance.currentUser?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              child: Text(
                FirebaseAuth.instance.currentUser?.email?.substring(0, 1) ?? '',
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.medical_services),
            title: Text('Pengingat Obat'),
            onTap: () {
              Get.offAllNamed('reminder');
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Jadwal Kunjungan'),
            onTap: () {
              // Navigate to Jadwal Kunjungan
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: Text('Kalkulator Tubuh'),
            onTap: () {
              Get.offAllNamed('calculator_list');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            // onTap: () async {
            //   await AuthService().signout(context: context);
            // },
          ),
        ],
      ),
    );
  }
}
