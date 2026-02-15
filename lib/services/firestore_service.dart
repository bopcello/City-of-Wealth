import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Saves the player's progress to Firestore.
  /// The [uid] is the user's unique identifier from Firebase Auth.
  /// The [data] is a map containing all game state information.
  Future<void> savePlayerProgress(String uid, Map<String, dynamic> data) async {
    try {
      await _db.collection('players').doc(uid).set({
        ...data,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint("✅ Game progress saved to Firestore for user: $uid");
    } catch (e) {
      debugPrint("❌ Error saving progress to Firestore: $e");
      rethrow;
    }
  }

  /// Retrieves the player's progress from Firestore.
  /// Returns null if no progress is found.
  Future<Map<String, dynamic>?> getPlayerProgress(String uid) async {
    try {
      final doc = await _db.collection('players').doc(uid).get();
      if (doc.exists) {
        debugPrint("✅ Game progress loaded from Firestore for user: $uid");
        return doc.data();
      } else {
        debugPrint("ℹ️ No game progress found in Firestore for user: $uid");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Error loading progress from Firestore: $e");
      rethrow;
    }
  }
}
