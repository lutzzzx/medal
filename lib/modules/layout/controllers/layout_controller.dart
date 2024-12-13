import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/modules/calculator/views/calculator_list_page.dart';
import 'package:medal/modules/home/views/home_view.dart';
import 'package:medal/modules/reminder/views/reminder_list_view.dart';
import 'package:medal/modules/search/search.dart';
import 'package:medal/modules/tenaga_kesehatan/views/tenaga_kesehatan_main_page.dart';

class LayoutController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> pages = <Widget>[
    HomeView(),
    ReminderListView(),
    Search(),
    TenagaKesehatanMainPage(),
    CalculatorListPage(),
  ];

  final List<String> pageTitles = [
    'MedAl',
    'Pengingat Obat',
    'Cari Obat',
    'Daftar Kunjungan',
    'Kalkulator Tubuh',
  ];

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
