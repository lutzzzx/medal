import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/widgets/custom_text_form_field.dart';
import 'package:medal/widgets/expanded_button.dart';
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
      final userId = FirebaseAuth.instance.currentUser?.uid;

      // Ambil nama berdasarkan tenaga kesehatan yang dipilih (jika ada)
      String? selectedNamaAhliKesehatan = _selectedTenagaKesehatanId == null
          ? null
          : controller.tenagaKesehatanList
          .firstWhere((tk) => tk.id == _selectedTenagaKesehatanId)
          .nama;

      // Cek apakah nama di inputan sama dengan nama tenaga kesehatan yang dipilih
      bool isNamaSama = _namaAhliKesehatanController.text == selectedNamaAhliKesehatan;

      final jadwalKunjungan = JadwalKunjungan(
        id: '',
        namaAhliKesehatan: isNamaSama
            ? selectedNamaAhliKesehatan!
            : _namaAhliKesehatanController.text,
        tanggal: _tanggalController.text,
        jam: _jamController.text,
        keterangan: _keteranganController.text,
        userId: userId!,
        tenagaKesehatanId: isNamaSama ? _selectedTenagaKesehatanId : null,
      );

      controller.addJadwalKunjungan(jadwalKunjungan);
      Get.back();
      Get.snackbar('Berhasil', 'Jadwal kunjungan berhasil ditambahkan');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Jadwal Kunjungan'), backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                icon: Icon(Icons.person),
                controller: _namaAhliKesehatanController,
                labelText: 'Nama Tenaga Kesehatan',
                onChanged: (value) async {
                  if (value.isNotEmpty) {
                    await controller.searchTenagaKesehatan(value);
                  }
                },
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

              Obx(() {
                if (controller.filteredTenagaKesehatanList.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.filteredTenagaKesehatanList.length,
                    itemBuilder: (context, index) {
                      final tenagaKesehatan = controller.filteredTenagaKesehatanList[index];
                      return ListTile(
                        title: Text(tenagaKesehatan.nama),
                        onTap: () {
                          _namaAhliKesehatanController.text = tenagaKesehatan.nama;
                          _selectedTenagaKesehatanId = tenagaKesehatan.id;
                          controller.filteredTenagaKesehatanList.clear(); // Clear suggestions
                        },
                      );
                    },
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
              CustomTextFormField(
                icon: Icon(Icons.calendar_today), // Ikon untuk tanggal
                controller: _tanggalController,
                labelText: 'Tanggal',
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    _tanggalController.text =
                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  }
                },
                validator: (value) => value!.isEmpty ? 'Tanggal harus diisi' : null,
              ),

              CustomTextFormField(
                icon: Icon(Icons.access_time), // Ikon untuk jam
                controller: _jamController,
                labelText: 'Jam',
                readOnly: true, // Hanya bisa dipilih via time picker
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    _jamController.text =
                    "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                  }
                },
                validator: (value) => value!.isEmpty ? 'Jam harus diisi' : null,
              ),

              CustomTextFormField(
                icon: Icon(Icons.note), // Ikon untuk keterangan
                controller: _keteranganController,
                labelText: 'Keterangan',
                validator: (value) {
                  if (value != null && value.length > 255) {
                    return 'Keterangan tidak boleh lebih dari 255 karakter';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              ExpandedButton(text1: 'Simpan', press1: _tambahJadwal)
            ],
          ),
        ),
      ),
    );
  }
}
