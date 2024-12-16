import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/modules/tenaga_kesehatan/views/edit_jadwal_kunjungan_page.dart';
import 'package:medal/modules/tenaga_kesehatan/views/edit_tenaga_kesehatan_page.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Jadwal Kunjungan

            Obx(() {
              SizedBox(height: 20);
              if (controller.jadwalKunjunganList.isEmpty) {
                return Center(
                  child: Text('Belum ada jadwal kunjungan.'),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.jadwalKunjunganList.length,
                itemBuilder: (context, index) {
                  final data = controller.jadwalKunjunganList[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman detail
                      Get.to(() => EditJadwalKunjunganPage(jadwalKunjunganId: data.id));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16), // Margin samping dan atas/bawah
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCAF0F8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.calendar_today, // Ikon kunjungan
                              color: const Color(0xFF03045E),
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 12),
                          // Informasi jadwal
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data.tanggal} - ${data.jam}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0077B6),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                data.namaAhliKesehatan,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 16.0), // Margin atas, bawah, kiri, kanan
              child: Divider(
                color: const Color(0xFFCAF0F8),
                thickness: 2.0, // Ketebalan garis
              ),
            ),
            // Bagian Tenaga Kesehatan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Daftar Tenaga Kesehatan',
                  style: TextStyle(fontSize: 22,),
                ),
              ),
            ),

            Obx(() {
              if (controller.tenagaKesehatanList.isEmpty) {
                return Center(
                  child: Text('Belum ada data tenaga kesehatan.'),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.tenagaKesehatanList.length,
                itemBuilder: (context, index) {
                  final data = controller.tenagaKesehatanList[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman detail
                      Get.to(() => EditTenagaKesehatanPage(tenagaKesehatanId: data.id));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16), // Margin samping dan atas/bawah
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCAF0F8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Bulatan dengan ikon
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              color: const Color(0xFF03045E),
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 12), // Spasi antar elemen
                          // Informasi tenaga kesehatan
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.nama,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${data.noTelp} - ${data.alamat}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0077B6),
                                ),
                              ),
                              SizedBox(height: 4),
                            ],
                          ),
                        ],
                      ),
                    ),
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
            backgroundColor: Colors.white,
            context: context,
            builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.20, // Mengatur tinggi sheet
              child: Center( // Memastikan elemen berada di tengah
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      leading: Icon(Icons.add),
                      title: Text('Tambah Tenaga Kesehatan'),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => TambahTenagaKesehatanPage());
                      },
                    ),
                    SizedBox(height: 10),
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
              ),
            ),
          );
        },
        backgroundColor: Color(0xFF03045E),
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
