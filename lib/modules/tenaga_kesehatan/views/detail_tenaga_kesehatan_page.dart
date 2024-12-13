import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/modules/tenaga_kesehatan/views/edit_tenaga_kesehatan_page.dart';
import '../controllers/tenaga_kesehatan_controller.dart';
import '../../../data/models/tenaga_kesehatan_model.dart';

class DetailTenagaKesehatanPage extends StatelessWidget {
  final String tenagaKesehatanId;
  final TenagaKesehatanController controller = Get.find();

  DetailTenagaKesehatanPage({required this.tenagaKesehatanId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Tenaga Kesehatan')),
      body: FutureBuilder<TenagaKesehatan>(
        future: controller.getTenagaKesehatanById(tenagaKesehatanId),
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
                Text('Nama: ${data.nama}', style: TextStyle(fontSize: 18)),
                Text('No Telepon: ${data.noTelp}', style: TextStyle(fontSize: 18)),
                Text('Email: ${data.email}', style: TextStyle(fontSize: 18)),
                Text('Alamat: ${data.alamat}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => EditTenagaKesehatanPage(tenagaKesehatanId: data.id));
                      },
                      child: Text('Edit'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Hapus Tenaga Kesehatan'),
                            content: Text('Apakah Anda yakin ingin menghapus data ini?'),
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
                          controller.deleteTenagaKesehatan(data.id, data.userId);
                          Get.back();
                        }
                      },
                      child: Text('Hapus'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}