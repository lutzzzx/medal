import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tenaga_kesehatan_controller.dart';
import '../../../data/models/jadwal_kunjungan_model.dart';

class TambahJadwalKunjunganPage extends StatelessWidget {
  final TenagaKesehatanController controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _namaAhliKesehatanController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _jamController = TextEditingController();
  final _keteranganController = TextEditingController();
  String? _selectedTenagaKesehatanId;

  void _tambahJadwal() {
    if (_formKey.currentState!.validate()) {
      final userId = FirebaseAuth.instance.currentUser ?.uid;
      final jadwalKunjungan = JadwalKunjungan(
        id: '',
        namaAhliKesehatan: _selectedTenagaKesehatanId == null
            ? _namaAhliKesehatanController.text
            : controller.tenagaKesehatanList.firstWhere((tk) => tk.id == _selectedTenagaKesehatanId).nama,
        tanggal: _tanggalController.text,
        jam: _jamController.text,
        keterangan: _keteranganController.text,
        userId: userId!,
        tenagaKesehatanId: _selectedTenagaKesehatanId,
      );
      controller.addJadwalKunjungan(jadwalKunjungan);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Jadwal Kunjungan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                items: controller.tenagaKesehatanList
                    .map((doc) => DropdownMenuItem(
                  value: doc.id,
                  child: Text(doc.nama),
                ))
                    .toList(),
                onChanged: (value) {
                  _selectedTenagaKesehatanId = value as String?;
                },
                decoration: InputDecoration(labelText: 'Pilih Tenaga Kesehatan'),
              ),
              if (_selectedTenagaKesehatanId == null)
                TextFormField(
                  controller: _namaAhliKesehatanController,
                  decoration: InputDecoration(labelText: 'Nama Ahli Kesehatan'),
                  validator: (value) => value!.isEmpty ? 'Nama harus diisi' : null,
                ),
              TextFormField(
                controller: _tanggalController,
                decoration: InputDecoration(labelText: 'Tanggal'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    _tanggalController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  }
                },
                readOnly: true,
              ),
              TextFormField(
                controller: _jamController,
                decoration: InputDecoration(labelText: 'Jam'),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    _jamController.text = "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                  }
                },
                readOnly: true,
              ),
              TextFormField(
                controller: _keteranganController,
                decoration: InputDecoration(labelText: 'Keterangan'),
                validator: (value) => value!.isEmpty ? 'Keterangan harus diisi' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _tambahJadwal,
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}