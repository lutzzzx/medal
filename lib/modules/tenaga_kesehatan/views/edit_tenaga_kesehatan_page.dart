import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/widgets/custom_text_form_field.dart';
import 'package:medal/widgets/expanded_button.dart';
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
      Get.close(2);
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
              ExpandedButton(text1: 'Update', press1: _updateData)
            ],
          ),
        ),
      ),
    );
  }
}