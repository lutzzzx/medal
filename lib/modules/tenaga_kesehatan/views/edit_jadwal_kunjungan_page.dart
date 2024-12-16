import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/data/models/tenaga_kesehatan_model.dart';
import 'package:medal/widgets/custom_text_form_field.dart';
import 'package:medal/widgets/expanded_button.dart';
import 'package:medal/widgets/hapus_ubah.dart';
import '../controllers/tenaga_kesehatan_controller.dart';
import '../../../data/models/jadwal_kunjungan_model.dart';
import 'detail_tenaga_kesehatan_page.dart'; // Import the detail page

class EditJadwalKunjunganPage extends StatelessWidget {
  final String jadwalKunjunganId;
  final TenagaKesehatanController controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _namaAhliKesehatanController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _jamController = TextEditingController();
  final _keteranganController = TextEditingController();
  String? _selectedTenagaKesehatanId;

  EditJadwalKunjunganPage({required this.jadwalKunjunganId});

  void _loadData() async {
    final jadwalKunjungan = controller.jadwalKunjunganList.firstWhere((j) => j.id == jadwalKunjunganId);
    _namaAhliKesehatanController.text = jadwalKunjungan.namaAhliKesehatan;
    _tanggalController.text = jadwalKunjungan.tanggal;
    _jamController.text = jadwalKunjungan.jam;
    _keteranganController.text = jadwalKunjungan.keterangan;
    _selectedTenagaKesehatanId = jadwalKunjungan.tenagaKesehatanId;
  }

  void _editJadwal() {
    if (_formKey.currentState!.validate()) {
      final updatedJadwalKunjungan = JadwalKunjungan(
        id: jadwalKunjunganId,
        namaAhliKesehatan: _selectedTenagaKesehatanId == null
            ? _namaAhliKesehatanController.text
            : controller.tenagaKesehatanList.firstWhere((tk) => tk.id == _selectedTenagaKesehatanId).nama,
        tanggal: _tanggalController.text,
        jam: _jamController.text,
        keterangan: _keteranganController.text,
        userId: controller.jadwalKunjunganList.firstWhere((j) => j.id == jadwalKunjunganId).userId,
        tenagaKesehatanId: _selectedTenagaKesehatanId,
      );
      controller.updateJadwalKunjungan(updatedJadwalKunjungan);
      Get.back();
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    _loadData();
    return Scaffold(
      appBar: AppBar(title: Text('Edit Jadwal Kunjungan'), backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      icon: Icon(Icons.person),
                      controller: _namaAhliKesehatanController,
                      labelText: 'Nama Tenaga Kesehatan',
                      isEdit: true,
                      readOnly: _selectedTenagaKesehatanId != null,
                      onChanged: (value) async {
                        if (value.isNotEmpty) {
                          await controller.searchTenagaKesehatan(value);
                        }
                      },
                      validator: (value) => value!.isEmpty ? 'Nama harus diisi' : null,
                    ),
                  ),
                  if (_selectedTenagaKesehatanId != null) // Show button only if a healthcare worker is selected
                    IconButton(
                      icon: Container(
                        margin: EdgeInsets.only(bottom: 12.0), // Add some space between the text field and the button
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFFCAF0F8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.arrow_forward, color: const Color(0xFF03045E), size: 30.0),
                      ),
                      onPressed: () {
                        Get.to(() => DetailTenagaKesehatanPage(tenagaKesehatanId: _selectedTenagaKesehatanId!));
                      },
                      tooltip: 'Lihat Detail Tenaga Kesehatan',
                    ),
                ],
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
                icon: Icon(Icons.calendar_today),
                controller: _tanggalController,
                labelText: 'Tanggal',
                readOnly: true,
                isEdit: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(_tanggalController.text),
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
                icon: Icon(Icons.access_time),
                controller: _jamController,
                labelText: 'Jam',
                readOnly: true,
                isEdit: true,
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
                icon: Icon(Icons.note),
                controller: _keteranganController,
                labelText: 'Keterangan',
                isEdit: true,
              ),
              SizedBox(height: 20),
              HapusUbah(
                text1 : 'Hapus',
                text2: 'Update',
                press1: () {
                  controller.deleteJadwalKunjungan(jadwalKunjunganId, FirebaseAuth.instance.currentUser !.uid);
                  Get.back();
                  Get.snackbar('Sukses', 'Data berhasil dihapus');
                },
                press2: _editJadwal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}