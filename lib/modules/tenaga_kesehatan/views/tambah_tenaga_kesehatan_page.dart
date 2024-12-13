import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Tenaga Kesehatan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) => value!.isEmpty ? 'Nama harus diisi' : null,
              ),
              TextFormField(
                controller: _noTelpController,
                decoration: InputDecoration(labelText: 'No Telepon'),
                validator: (value) => value!.isEmpty ? 'No Telepon harus diisi' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Email harus diisi' : null,
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) => value!.isEmpty ? 'Alamat harus diisi' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _tambahData,
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}