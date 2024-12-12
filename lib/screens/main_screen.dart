import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medal/screens/calculator/bmi_calculator.dart';
import 'package:medal/screens/calculator/bmr_calculator.dart';
import 'package:medal/screens/calculator/calculator_list.dart';
import 'package:medal/screens/home_screen.dart';
import 'package:medal/screens/reminder/reminder_list_screen.dart';
import 'package:medal/screens/tenaga_kesehatan.dart';
import 'profile_screen.dart';
import 'auth/login_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    HomeScreen(),
    ReminderListScreen(),
    const Text('Page 3'),
    TenagaKesehatanMainPage(),
    CalculatorListPage(),
  ];

  static const List<String> _pageTitles = [
    'MedAl',
    'Pengingat Obat',
    'Cari Obat',
    'Daftar Kunjungan',
    'Kalkulator Tubuh',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Cek apakah pengguna sudah login
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Jika pengguna belum login, arahkan ke halaman login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
      return Scaffold(); // Tampilkan scaffold kosong sementara
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
