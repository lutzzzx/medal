import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/jadwal_kunjungan_model.dart';

class JadwalKunjunganRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<JadwalKunjungan>> getJadwalKunjungan(String userId) async {
    final snapshot = await _firestore
        .collection('jadwal_kunjungan')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => JadwalKunjungan.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> addJadwalKunjungan(JadwalKunjungan jadwalKunjungan) async {
    await _firestore.collection('jadwal_kunjungan').add({
      'nama_ahli_kesehatan': jadwalKunjungan.namaAhliKesehatan,
      'tanggal': jadwalKunjungan.tanggal,
      'jam': jadwalKunjungan.jam,
      'keterangan': jadwalKunjungan.keterangan,
      'userId': jadwalKunjungan.userId,
      'tenagaKesehatanId': jadwalKunjungan.tenagaKesehatanId,
    });
  }

  Future<void> updateJadwalKunjungan(JadwalKunjungan jadwalKunjungan) async {
    await _firestore.collection('jadwal_kunjungan').doc(jadwalKunjungan.id).update({
      'nama_ahli_kesehatan': jadwalKunjungan.namaAhliKesehatan,
      'tanggal': jadwalKunjungan.tanggal,
      'jam': jadwalKunjungan.jam,
      'keterangan': jadwalKunjungan.keterangan,
      'tenagaKesehatanId': jadwalKunjungan.tenagaKesehatanId,
    });
  }

  Future<void> deleteJadwalKunjungan(String id) async {
    await _firestore.collection('jadwal_kunjungan').doc(id).delete();
  }
}