import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/widgets/custom_text_form_field.dart';
import 'package:medal/widgets/expanded_button.dart';
import 'package:medal/widgets/hapus_ubah.dart';
import '../controllers/tenaga_kesehatan_controller.dart';
import '../../../data/models/tenaga_kesehatan_model.dart';

class EditTenagaKesehatanPage extends StatelessWidget {
  final String tenagaKesehatanId;
  final TenagaKesehatanController controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();

  EditTenagaKesehatanPage({required this.tenagaKesehatanId});

  void _loadData() async {
    final tenagaKesehatan = controller.tenagaKesehatanList.firstWhere((tk) => tk.id == tenagaKesehatanId);
    _namaController.text = tenagaKesehatan.nama;
    _noTelpController.text = tenagaKesehatan.noTelp;
    _emailController.text = tenagaKesehatan.email;
    _alamatController.text = tenagaKesehatan.alamat;
  }

  void _updateData() {
    if (_formKey.currentState!.validate()) {
      final updatedTenagaKesehatan = TenagaKesehatan(
        id: tenagaKesehatanId,
        nama: _namaController.text,
        noTelp: _noTelpController.text,
        email: _emailController.text,
        alamat: _alamatController.text,
        userId: controller.tenagaKesehatanList.firstWhere((tk) => tk.id == tenagaKesehatanId).userId,
      );
      controller.updateTenagaKesehatan(updatedTenagaKesehatan);
      Get.back();
    }
  }


  @override
  Widget build(BuildContext context) {
    _loadData();
    return Scaffold(
      appBar: AppBar(title: Text('Edit Tenaga Kesehatan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                icon: Icon(Icons.person),
                controller: _namaController,
                labelText: 'Nama',
                isEdit: true,
                validator: (value) => value!.isEmpty ? 'Nama harus diisi' : null,
              ),
              CustomTextFormField(
                icon: Icon(Icons.phone),
                controller: _noTelpController,
                labelText: 'No Telepon',
                isEdit: true,
                keyboardType: TextInputType.phone,
              ),
              CustomTextFormField(
                icon: Icon(Icons.email),
                controller: _emailController,
                labelText: 'Email',
                isEdit: true,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextFormField(
                icon: Icon(Icons.home),
                controller: _alamatController,
                labelText: 'Alamat',
                isEdit: true,
              ),
              SizedBox(height: 20),
              HapusUbah(
                text1: 'Hapus',
                text2: 'Update',
                press1: () {
                  controller.deleteTenagaKesehatan(tenagaKesehatanId, FirebaseAuth.instance.currentUser !.uid);
                  Get.back();
                  Get.snackbar('Sukses', 'Data berhasil dihapus');
                },
                press2: _updateData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}