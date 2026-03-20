import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Saves the player's progress to Firestore.
  /// The [uid] is the user's unique identifier from Firebase Auth.
  /// The [data] is a map containing all game state information.
  Future<void> savePlayerProgress(String uid, Map<String, dynamic> data) async {
    if (uid.isEmpty) {
      debugPrint("⚠️ Skipping Firestore save: UID is empty");
      return;
    }

    if (data.isEmpty) {
      debugPrint("⚠️ Skipping Firestore save for user $uid: Data map is empty");
      return;
    }

    try {
      debugPrint(
        "📤 CLOUD SAVE: Syncing ${data.keys.length} fields for user: $uid",
      );
      // debugPrint("📤 Full Data Map: $data"); // Uncomment if verbose debug is needed

      await _db.collection('players').doc(uid).set({
        ...data,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint("✅ CLOUD SAVE: Success");
    } catch (e) {
      debugPrint("❌ CLOUD SAVE: Error - $e");
      rethrow;
    }
  }

  /// Retrieves the player's progress from Firestore.
  /// Returns null if no progress is found.
  Future<Map<String, dynamic>?> getPlayerProgress(String uid) async {
    try {
      debugPrint("📥 CLOUD LOAD: Fetching progress for user: $uid");
      final doc = await _db.collection('players').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        debugPrint("✅ CLOUD LOAD: Success. doc.data(): $data");
        return data;
      } else {
        debugPrint("ℹ️ CLOUD LOAD: No document found");
        return null;
      }
    } catch (e) {
      debugPrint("❌ CLOUD LOAD: Error - $e");
      rethrow;
    }
  }

  /// Retrieves the daily quiz for a specific date.
  Future<Map<String, dynamic>?> getDailyQuiz(String date) async {
    try {
      final doc = await _db.collection('Daily questions').doc('daily_$date').get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      debugPrint("❌ Error fetching daily quiz: $e");
      return null;
    }
  }

  /// Updates the player's streak and last quiz date.
  Future<void> updatePlayerStreak(String uid, int streak, String date) async {
    try {
      await _db.collection('players').doc(uid).update({
        'dailyQuizStreak': streak,
        'lastDailyQuizDate': date,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("❌ Error updating streak: $e");
    }
  }
}
