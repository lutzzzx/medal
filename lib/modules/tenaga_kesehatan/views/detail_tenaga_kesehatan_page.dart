import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/modules/tenaga_kesehatan/views/edit_tenaga_kesehatan_page.dart';
import 'package:medal/widgets/detail_card.dart';
import 'package:medal/widgets/hapus_ubah.dart';
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
                DetailCard(
                  text: 'Nama: ${data.nama}',
                  icon: Icons.person,
                  isBold: true,
                ),
                DetailCard(
                  text: 'No Telepon: ${data.noTelp}',
                  icon: Icons.phone,
                ),
                DetailCard(
                  text: 'Email: ${data.email}',
                  icon: Icons.email,
                ),
                DetailCard(
                  text: 'Alamat: ${data.alamat}',
                  icon: Icons.location_on,
                ),
                SizedBox(height: 20),
                HapusUbah(
                  text1: 'Hapus',
                  text2: 'Edit',
                  press1: () {
                    controller.deleteTenagaKesehatan(data.id, data.userId);
                    Get.back();
                  },
                  press2: () {
                    Get.to(() => EditTenagaKesehatanPage(tenagaKesehatanId: data.id));
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

