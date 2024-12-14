import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/data/models/tenaga_kesehatan_model.dart';
import '../controllers/tenaga_kesehatan_controller.dart';
import '../../../data/models/jadwal_kunjungan_model.dart';

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
  Widget build(BuildContext context) {
    _loadData();
    return Scaffold(
      appBar: AppBar(title: Text('Edit Jadwal Kunjungan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaAhliKesehatanController,
                decoration: InputDecoration(labelText: 'Nama Tenaga Kesehatan'),
                onChanged: (value) async {
                  if (value.isNotEmpty) {
                    await controller.searchTenagaKesehatan(value);
                  }
                },
                validator: (value) => value!.isEmpty ? 'Nama harus diisi' : null,
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
              TextFormField(
                controller: _tanggalController,
                decoration: InputDecoration(labelText: 'Tanggal'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(_tanggalController.text),
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
                onPressed: _editJadwal,
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}