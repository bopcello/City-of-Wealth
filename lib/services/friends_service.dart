import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/city_sharing_models.dart';
import 'firestore_service.dart';

class FriendsService {
  static final FriendsService _instance = FriendsService._internal();
  factory FriendsService() => _instance;
  FriendsService._internal();

  final FirestoreService _firestoreService = FirestoreService();

  String? get currentUid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> sendRequest(String targetUid) async {
    final uid = currentUid;
    if (uid == null || uid == targetUid) return;
    await _firestoreService.sendFriendRequest(uid, targetUid);
  }

  Future<void> acceptRequest(String friendshipId) async {
    await _firestoreService.acceptFriendRequest(friendshipId);
  }

  Future<void> declineRequest(String friendshipId) async {
    await _firestoreService.declineFriendRequest(friendshipId);
  }

  Future<void> blockFriend(String friendshipId) async {
    final uid = currentUid;
    if (uid == null) return;
    await _firestoreService.blockUser(friendshipId, uid);
  }

  Future<void> unblockFriend(String friendshipId) async {
    await _firestoreService.unblockUser(friendshipId);
  }

  Future<void> toggleMuteFriend(String friendshipId, bool mute) async {
    final uid = currentUid;
    if (uid == null) return;
    await _firestoreService.toggleMuteFriend(friendshipId, uid, mute);
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    return await _firestoreService.searchUserByCodeOrName(query);
  }

  Stream<List<Friendship>> getFriendshipsStream() {
    final uid = currentUid;
    if (uid == null) return Stream.value([]);
    return _firestoreService.getFriendshipsStream(uid);
  }

  Stream<List<ActivityEntry>> getActivityFeedStream() {
    final uid = currentUid;
    if (uid == null) return Stream.value([]);
    return _firestoreService.getActivityFeedStream(uid);
  }

  Future<void> markAllAsSeen() async {
    final uid = currentUid;
    if (uid == null) return;
    await _firestoreService.markAllActivitiesAsSeen(uid);
  }

  Future<PublicCitySnapshot?> getFriendSnapshot(String friendUid) async {
    return await _firestoreService.getPublicCitySnapshot(friendUid);
  }

  /// Returns the activity-feed doc ID so it can be undone later.
  Future<String?> sendCheer(String targetUid, String myName) async {
    final uid = currentUid;
    if (uid == null) return null;

    // Write activity to target's feed
    final ref = await FirebaseFirestore.instance
        .collection('players')
        .doc(targetUid)
        .collection('activity_feed')
        .add({
          'sourcePlayerId': uid,
          'sourcePlayerName': myName,
          'targetPlayerId': targetUid,
          'type': 'cheer',
          'payload': {'text': 'Sent you a Cheer'},
          'createdAt': FieldValue.serverTimestamp(),
          'seen': false,
        });

    // Record our own cheer so we can check the 24-hr cooldown
    await FirebaseFirestore.instance
        .collection('players')
        .doc(uid)
        .collection('cheers_sent')
        .doc(targetUid)
        .set({
          'activityDocId': ref.id,
          'sentAt': FieldValue.serverTimestamp(),
        });

    return ref.id;
  }

  /// Returns the activityDocId if a cheer was sent within the last 24 hours,
  /// otherwise null (meaning the user can cheer again).
  Future<String?> getCheerStatus(String targetUid) async {
    final uid = currentUid;
    if (uid == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('players')
        .doc(uid)
        .collection('cheers_sent')
        .doc(targetUid)
        .get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    final sentAt = (data['sentAt'] as Timestamp?)?.toDate();
    if (sentAt == null) return null;

    final age = DateTime.now().difference(sentAt);
    if (age.inHours < 24) {
      return data['activityDocId'] as String?;
    }

    return null; // Expired — allow new cheer
  }

  /// Removes a previously sent cheer.
  Future<void> removeCheer(String targetUid, String activityDocId) async {
    final uid = currentUid;
    if (uid == null) return;

    // Delete from target's activity feed
    await FirebaseFirestore.instance
        .collection('players')
        .doc(targetUid)
        .collection('activity_feed')
        .doc(activityDocId)
        .delete();

    // Remove our local cheer record so the cooldown lifts
    await FirebaseFirestore.instance
        .collection('players')
        .doc(uid)
        .collection('cheers_sent')
        .doc(targetUid)
        .delete();
  }
}
