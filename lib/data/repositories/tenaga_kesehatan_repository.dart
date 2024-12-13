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
    await _firestore.collection('tenaga_kesehatan').doc(id).delete();
  }
}