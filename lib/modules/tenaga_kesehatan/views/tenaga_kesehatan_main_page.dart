import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tenaga_kesehatan_controller.dart';
import 'tambah_tenaga_kesehatan_page.dart';
import 'tambah_jadwal_kunjungan_page.dart';
import 'detail_tenaga_kesehatan_page.dart';
import 'detail_jadwal_kunjungan_page.dart';

class TenagaKesehatanMainPage extends StatelessWidget {
  final TenagaKesehatanController controller = Get.put(TenagaKesehatanController());

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser ?.uid;

    controller.fetchTenagaKesehatan(userId!);
    controller.fetchJadwalKunjungan(userId);

    return Scaffold(
      appBar: AppBar(title: Text('Tenaga Kesehatan')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Tenaga Kesehatan
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Daftar Tenaga Kesehatan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Obx(() {
              if (controller.tenagaKesehatanList.isEmpty) {
                return Center(child: Text('Belum ada data tenaga kesehatan.'));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.tenagaKesehatanList.length,
                itemBuilder: (context, index) {
                  final data = controller.tenagaKesehatanList[index];
                  return ListTile(
                    title: Text(data.nama),
                    subtitle: Text(data.noTelp),
                    onTap: () {
                      Get.to(() => DetailTenagaKesehatanPage(tenagaKesehatanId: data.id));
                    },
                  );
                },
              );
            }),
            Divider(),
            // Bagian Jadwal Kunjungan
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Daftar Jadwal Kunjungan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Obx(() {
              if (controller.jadwalKunjunganList.isEmpty) {
                return Center(child: Text('Belum ada jadwal kunjungan.'));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.jadwalKunjunganList.length,
                itemBuilder: (context, index) {
                  final data = controller.jadwalKunjunganList[index];
                  return ListTile(
                    title: Text(data.namaAhliKesehatan),
                    subtitle: Text('${data.tanggal} - ${data.jam}'),
                    onTap: () {
                      Get.to(() => DetailJadwalKunjunganPage(jadwalKunjunganId: data.id));
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Tambah Tenaga Kesehatan'),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => TambahTenagaKesehatanPage());
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Tambah Jadwal Kunjungan'),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => TambahJadwalKunjunganPage());
                },
              ),
            ],
          ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}