// lib/data/repositories/reminder_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reminder_model.dart';

class ReminderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReminder(ReminderModel reminder) async {
    await _firestore.collection('reminders').add(reminder.toMap());
  }

  Future<void> updateReminder(ReminderModel reminder) async {
    await _firestore.collection('reminders').doc(reminder.id).update(reminder.toMap());
  }

  Future<void> deleteReminder(String id) async {
    await _firestore.collection('reminders').doc(id).delete();
  }

  Stream<List<ReminderModel>> getReminders(String userId) {
    return _firestore
        .collection('reminders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ReminderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }
}