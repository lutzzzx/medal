import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/modules/tenaga_kesehatan/views/detail_tenaga_kesehatan_page.dart';
import 'package:medal/modules/tenaga_kesehatan/views/edit_jadwal_kunjungan_page.dart';
import '../controllers/tenaga_kesehatan_controller.dart';
import '../../../data/models/jadwal_kunjungan_model.dart';

class DetailJadwalKunjunganPage extends StatelessWidget {
  final String jadwalKunjunganId;
  final TenagaKesehatanController controller = Get.find();

  DetailJadwalKunjunganPage({required this.jadwalKunjunganId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Jadwal Kunjungan'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Get.to(() => EditJadwalKunjunganPage(jadwalKunjunganId: jadwalKunjunganId));
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Hapus Jadwal'),
                  content: Text('Apakah Anda yakin ingin menghapus jadwal ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Hapus'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                controller.deleteJadwalKunjungan(jadwalKunjunganId, FirebaseAuth.instance.currentUser !.uid);
                Get.back();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<JadwalKunjungan>(
        future: controller.getJadwalKunjunganById(jadwalKunjunganId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Data tidak ditemukan'));
          }
          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama Ahli Kesehatan: ${data.namaAhliKesehatan}', style: TextStyle(fontSize: 18)),
                Text('Tanggal: ${data.tanggal}', style: TextStyle(fontSize: 18)),
                Text('Jam: ${data.jam}', style: TextStyle(fontSize: 18)),
                Text('Keterangan: ${data.keterangan}', style: TextStyle(fontSize: 18)),
                if (data.tenagaKesehatanId != null)
                  TextButton(
                    onPressed: () {
                      Get.to(() => DetailTenagaKesehatanPage(tenagaKesehatanId: data.tenagaKesehatanId!));
                    },
                    child: Text('Lihat Detail Tenaga Kesehatan'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}