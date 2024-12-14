import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tenaga_kesehatan_model.dart';

class TenagaKesehatanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TenagaKesehatan>> getTenagaKesehatan(String userId) async {
    final snapshot = await _firestore
        .collection('tenaga_kesehatan')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => TenagaKesehatan.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> addTenagaKesehatan(TenagaKesehatan tenagaKesehatan) async {
    await _firestore.collection('tenaga_kesehatan').add({
      'nama': tenagaKesehatan.nama,
      'no_telp': tenagaKesehatan.noTelp,
      'email': tenagaKesehatan.email,
      'alamat': tenagaKesehatan.alamat,
      'userId': tenagaKesehatan.userId,
    });
  }

  Future<void> updateTenagaKesehatan(TenagaKesehatan tenagaKesehatan) async {
    await _firestore.collection('tenaga_kesehatan').doc(tenagaKesehatan.id).update({
      'nama': tenagaKesehatan.nama,
      'no_telp': tenagaKesehatan.noTelp,
      'email': tenagaKesehatan.email,
      'alamat': tenagaKesehatan.alamat,
    });
  }

  Future<void> deleteTenagaKesehatan(String id) async {
    final batch = _firestore.batch();

    // Hapus tenaga kesehatan
    final tenagaKesehatanDoc = _firestore.collection('tenaga_kesehatan').doc(id);
    batch.delete(tenagaKesehatanDoc);

    // Hapus jadwal kunjungan terkait
    final jadwalKunjunganQuery = await _firestore
        .collection('jadwal_kunjungan')
        .where('tenagaKesehatanId', isEqualTo: id)
        .get();

    for (var doc in jadwalKunjunganQuery.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}