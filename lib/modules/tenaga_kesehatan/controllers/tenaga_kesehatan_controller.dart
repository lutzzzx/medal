import 'package:get/get.dart';
import '../../../data/models/tenaga_kesehatan_model.dart';
import '../../../data/models/jadwal_kunjungan_model.dart';
import '../../../data/repositories/tenaga_kesehatan_repository.dart';
import '../../../data/repositories/jadwal_kunjungan_repository.dart';

class TenagaKesehatanController extends GetxController {
  final TenagaKesehatanRepository _tenagaKesehatanRepo = TenagaKesehatanRepository();
  final JadwalKunjunganRepository _jadwalKunjunganRepo = JadwalKunjunganRepository();
  final filteredTenagaKesehatanList = <TenagaKesehatan>[].obs;

  var tenagaKesehatanList = <TenagaKesehatan>[].obs;
  var jadwalKunjunganList = <JadwalKunjungan>[].obs;

  void fetchTenagaKesehatan(String userId) async {
    tenagaKesehatanList.value = await _tenagaKesehatanRepo.getTenagaKesehatan(userId);
  }

  void fetchJadwalKunjungan(String userId) async {
    jadwalKunjunganList.value = await _jadwalKunjunganRepo.getJadwalKunjungan(userId);
  }

  void addTenagaKesehatan(TenagaKesehatan tenagaKesehatan) async {
    await _tenagaKesehatanRepo.addTenagaKesehatan(tenagaKesehatan);
    fetchTenagaKesehatan(tenagaKesehatan.userId);
  }

  void updateTenagaKesehatan(TenagaKesehatan tenagaKesehatan) async {
    await _tenagaKesehatanRepo.updateTenagaKesehatan(tenagaKesehatan);
    fetchTenagaKesehatan(tenagaKesehatan.userId);
  }

  void deleteTenagaKesehatan(String id, String userId) async {
    await _tenagaKesehatanRepo.deleteTenagaKesehatan(id);
    fetchTenagaKesehatan(userId);
    fetchJadwalKunjungan(userId);
  }

  void addJadwalKunjungan(JadwalKunjungan jadwalKunjungan) async {
    await _jadwalKunjunganRepo.addJadwalKunjungan(jadwalKunjungan);
    fetchJadwalKunjungan(jadwalKunjungan.userId);
  }

  void updateJadwalKunjungan(JadwalKunjungan jadwalKunjungan) async {
    await _jadwalKunjunganRepo.updateJadwalKunjungan(jadwalKunjungan);
    fetchJadwalKunjungan(jadwalKunjungan.userId);
  }

  void deleteJadwalKunjungan(String id, String userId) async {
    await _jadwalKunjunganRepo.deleteJadwalKunjungan(id);
    fetchJadwalKunjungan(userId);
  }

  Future<TenagaKesehatan> getTenagaKesehatanById(String id) async {
    return tenagaKesehatanList.firstWhere((tk) => tk.id == id);
  }

  Future<JadwalKunjungan> getJadwalKunjunganById(String id) async {
    return jadwalKunjunganList.firstWhere((j) => j.id == id);
  }

  Future<void> searchTenagaKesehatan(String query) async {
    try {
      if (query.isEmpty) {
        filteredTenagaKesehatanList.clear();
        return;
      }

      final results = tenagaKesehatanList
          .where((tk) => tk.nama.toLowerCase().contains(query.toLowerCase()))
          .toList();

      filteredTenagaKesehatanList.assignAll(results);
    } catch (e) {
      print('Error searching tenaga kesehatan: $e');
    }
  }
}