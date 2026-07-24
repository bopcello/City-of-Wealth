import 'package:cloud_firestore/cloud_firestore.dart';
import '../game_state.dart';

class PublicCitySnapshot {
  final String playerId;
  final String playerName;
  final String friendCode;
  final String track;
  final int level;
  final String title;
  final int streak;
  final int kp;
  final List<PlacedBuilding> buildings;
  final int buildingCount;
  final DateTime lastUpdatedAt;

  PublicCitySnapshot({
    required this.playerId,
    required this.playerName,
    required this.friendCode,
    required this.track,
    required this.level,
    required this.title,
    required this.streak,
    required this.kp,
    required this.buildings,
    required this.buildingCount,
    required this.lastUpdatedAt,
  });

  Map<String, dynamic> toJson() => {
        'playerId': playerId,
        'playerName': playerName,
        'friendCode': friendCode,
        'track': track,
        'level': level,
        'title': title,
        'streak': streak,
        'kp': kp,
        'buildings': buildings.map((b) => b.toJson()).toList(),
        'buildingCount': buildingCount,
        'lastUpdatedAt': lastUpdatedAt,
      };

  factory PublicCitySnapshot.fromJson(Map<String, dynamic> json) {
    var rawBuildings = json['buildings'] as List? ?? [];
    List<PlacedBuilding> buildingsList =
        rawBuildings.map((b) => PlacedBuilding.fromJson(Map<String, dynamic>.from(b))).toList();
    
    DateTime parsedTime;
    if (json['lastUpdatedAt'] is Timestamp) {
      parsedTime = (json['lastUpdatedAt'] as Timestamp).toDate();
    } else if (json['lastUpdatedAt'] is String) {
      parsedTime = DateTime.parse(json['lastUpdatedAt']);
    } else {
      parsedTime = DateTime.now();
    }

    return PublicCitySnapshot(
      playerId: json['playerId'] ?? '',
      playerName: json['playerName'] ?? 'Unknown Player',
      friendCode: json['friendCode'] ?? '',
      track: json['track'] ?? 'student',
      level: json['level'] ?? 1,
      title: json['title'] ?? 'Student',
      streak: json['streak'] ?? 0,
      kp: json['kp'] ?? 0,
      buildings: buildingsList,
      buildingCount: json['buildingCount'] ?? buildingsList.length,
      lastUpdatedAt: parsedTime,
    );
  }
}

class Friendship {
  final String id;
  final String playerA;
  final String playerB;
  final String status; // "pending" | "accepted" | "blocked"
  final DateTime createdAt;
  final String requestedBy;
  final List<String> mutedBy; // UIDs of players who muted notifications

  Friendship({
    required this.id,
    required this.playerA,
    required this.playerB,
    required this.status,
    required this.createdAt,
    required this.requestedBy,
    required this.mutedBy,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'playerA': playerA,
        'playerB': playerB,
        'status': status,
        'createdAt': createdAt,
        'requestedBy': requestedBy,
        'mutedBy': mutedBy,
      };

  factory Friendship.fromJson(Map<String, dynamic> json, String docId) {
    DateTime parsedTime;
    if (json['createdAt'] is Timestamp) {
      parsedTime = (json['createdAt'] as Timestamp).toDate();
    } else if (json['createdAt'] is String) {
      parsedTime = DateTime.parse(json['createdAt']);
    } else {
      parsedTime = DateTime.now();
    }

    return Friendship(
      id: docId,
      playerA: json['playerA'] ?? '',
      playerB: json['playerB'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: parsedTime,
      requestedBy: json['requestedBy'] ?? '',
      mutedBy: List<String>.from(json['mutedBy'] ?? []),
    );
  }
}

class ActivityEntry {
  final String id;
  final String sourcePlayerId;
  final String sourcePlayerName;
  final String targetPlayerId;
  final String type; // "level_up" | "building_built" | "streak_milestone" | "bankruptcy"
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final bool seen;

  ActivityEntry({
    required this.id,
    required this.sourcePlayerId,
    required this.sourcePlayerName,
    required this.targetPlayerId,
    required this.type,
    required this.payload,
    required this.createdAt,
    required this.seen,
  });

  Map<String, dynamic> toJson() => {
        'sourcePlayerId': sourcePlayerId,
        'sourcePlayerName': sourcePlayerName,
        'targetPlayerId': targetPlayerId,
        'type': type,
        'payload': payload,
        'createdAt': createdAt,
        'seen': seen,
      };

  factory ActivityEntry.fromJson(Map<String, dynamic> json, String docId) {
    DateTime parsedTime;
    if (json['createdAt'] is Timestamp) {
      parsedTime = (json['createdAt'] as Timestamp).toDate();
    } else if (json['createdAt'] is String) {
      parsedTime = DateTime.parse(json['createdAt']);
    } else {
      parsedTime = DateTime.now();
    }

    return ActivityEntry(
      id: docId,
      sourcePlayerId: json['sourcePlayerId'] ?? '',
      sourcePlayerName: json['sourcePlayerName'] ?? '',
      targetPlayerId: json['targetPlayerId'] ?? '',
      type: json['type'] ?? '',
      payload: Map<String, dynamic>.from(json['payload'] ?? {}),
      createdAt: parsedTime,
      seen: json['seen'] ?? false,
    );
  }
}
