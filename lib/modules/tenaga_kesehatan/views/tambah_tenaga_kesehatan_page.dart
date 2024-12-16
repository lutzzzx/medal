import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/widgets/custom_text_form_field.dart';
import 'package:medal/widgets/expanded_button.dart';
import '../controllers/tenaga_kesehatan_controller.dart';
import '../../../data/models/tenaga_kesehatan_model.dart';

class TambahTenagaKesehatanPage extends StatelessWidget {
  final TenagaKesehatanController controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();

  void _tambahData() {
    if (_formKey.currentState!.validate()) {
      final userId = FirebaseAuth.instance.currentUser ?.uid;
      final tenagaKesehatan = TenagaKesehatan(
        id: '',
        nama: _namaController.text,
        noTelp: _noTelpController.text,
        email: _emailController.text,
        alamat: _alamatController.text,
        userId: userId!,
      );
      controller.addTenagaKesehatan(tenagaKesehatan);
      Get.back();
      Get.snackbar('Berhasil', 'Tenaga kesehatan berhasil ditambahkan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Tenaga Kesehatan'), backgroundColor: Colors.white,),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama harus diisi';
                  }
                  if (value.length > 50) {
                    return 'Nama tidak boleh lebih dari 50 karakter';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                icon: Icon(Icons.phone),
                controller: _noTelpController,
                labelText: 'No Telepon',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                      return 'Masukkan nomor telepon yang valid (10-15 digit)';
                    }
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                icon: Icon(Icons.email),
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                      return 'Masukkan alamat email yang valid';
                    }
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                icon: Icon(Icons.home),
                controller: _alamatController,
                labelText: 'Alamat',
                validator: (value) {
                  if (value != null && value.length > 200) {
                    return 'Alamat tidak boleh lebih dari 200 karakter';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ExpandedButton(text1: 'Simpan', press1: _tambahData)
            ],
          ),
        ),
      ),
    );
  }
}