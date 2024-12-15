import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medal/modules/tenaga_kesehatan/views/detail_tenaga_kesehatan_page.dart';
import 'package:medal/modules/tenaga_kesehatan/views/edit_jadwal_kunjungan_page.dart';
import 'package:medal/widgets/detail_card.dart';
import 'package:medal/widgets/expanded_button.dart';
import 'package:medal/widgets/hapus_ubah.dart'; // Import the HapusUbah widget
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DetailCard(
                        text: 'Nama: ${data.namaAhliKesehatan}',
                        icon: Icons.person,
                        isBold: true,
                      ),
                    ),
                    if (data.tenagaKesehatanId != null)
                      IconButton(
                        icon: Container(
                          margin: EdgeInsets.only(bottom: 12.0),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFFCAF0F8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_forward, color: const Color(0xFF03045E), size: 30.0),
                        ),
                        onPressed: () {
                          Get.to(() => DetailTenagaKesehatanPage(tenagaKesehatanId: data.tenagaKesehatanId!));
                        },
                        tooltip: 'Lihat Detail Tenaga Kesehatan',
                      ),
                  ],
                ),
                DetailCard(
                  text: 'Tanggal: ${data.tanggal}',
                  icon: Icons.calendar_today,
                ),
                DetailCard(
                  text: 'Jam: ${data.jam}',
                  icon: Icons.access_time,
                ),
                DetailCard(
                  text: 'Keterangan: ${data.keterangan}',
                  icon: Icons.info,
                ),
                const SizedBox(height: 16.0), // Add some spacing
                HapusUbah(
                  text1: 'Hapus Jadwal',
                  text2: 'Ubah Jadwal',
                  press1: () async {
                    // Call the delete function
                    controller.deleteJadwalKunjungan(jadwalKunjunganId, FirebaseAuth.instance.currentUser !.uid);
                    Get.back(); // Go back after deletion
                  },
                  press2: () {
                    // Navigate to the edit page
                    Get.to(() => EditJadwalKunjunganPage(jadwalKunjunganId: jadwalKunjunganId));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}