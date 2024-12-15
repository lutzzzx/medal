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
              CustomTextFormField(
                icon: Icon(Icons.person),
                controller: _namaController,
                labelText: 'Nama',
                validator: (value) => value!.isEmpty ? 'Nama harus diisi' : null,
              ),
              CustomTextFormField(
                icon: Icon(Icons.phone),
                controller: _noTelpController,
                labelText: 'No Telepon',
                keyboardType: TextInputType.phone,
              ),
              CustomTextFormField(
                icon: Icon(Icons.email),
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextFormField(
                icon: Icon(Icons.home),
                controller: _alamatController,
                labelText: 'Alamat',
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