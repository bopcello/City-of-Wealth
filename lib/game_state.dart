import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum CareerTrack { student, job, business }

enum AssetType { land, realEstate, machinery, vehicles, officeEquipment }

int assetCost(AssetType type) {
  switch (type) {
    case AssetType.realEstate:
      return 20;
    case AssetType.land:
      return 30;
    case AssetType.machinery:
      return 40;
    case AssetType.vehicles:
      return 35;
    case AssetType.officeEquipment:
      return 25;
  }
}

String assetLabel(AssetType type) {
  switch (type) {
    case AssetType.land:
      return "Land";
    case AssetType.realEstate:
      return "Real Estate";
    case AssetType.machinery:
      return "Machinery";
    case AssetType.vehicles:
      return "Vehicles";
    case AssetType.officeEquipment:
      return "Office Equipment";
  }
}

class AssetInventory {
  final Map<AssetType, int> items;

  const AssetInventory(this.items);

  int count(AssetType type) => items[type] ?? 0;

  AssetInventory add(AssetType type, int amount) {
    return AssetInventory({...items, type: count(type) + amount});
  }

  Map<String, int> toJson() {
    return items.map((key, value) => MapEntry(key.name, value));
  }

  factory AssetInventory.fromJson(Map<String, dynamic> json) {
    final Map<AssetType, int> items = {};
    json.forEach((key, value) {
      final type = AssetType.values.firstWhere((e) => e.name == key);
      items[type] = value as int;
    });
    return AssetInventory(items);
  }
}

class Building {
  final String name;
  final CareerTrack track;
  final int requiredLevel;
  final Map<AssetType, int> requirements;

  const Building({
    required this.name,
    required this.track,
    required this.requiredLevel,
    required this.requirements,
  });
}

const buildings = [
  Building(
    name: "💡 Idea Hub",
    track: CareerTrack.business,
    requiredLevel: 2,
    requirements: {AssetType.realEstate: 5},
  ),
  Building(
    name: "🏭 Small Workshop",
    track: CareerTrack.business,
    requiredLevel: 3,
    requirements: {AssetType.realEstate: 10, AssetType.land: 5},
  ),
  Building(
    name: "📦 Storage Unit",
    track: CareerTrack.business,
    requiredLevel: 3,
    requirements: {AssetType.land: 8},
  ),
  Building(
    name: "🏢 Office Building",
    track: CareerTrack.business,
    requiredLevel: 4,
    requirements: {AssetType.realEstate: 20, AssetType.officeEquipment: 10},
  ),
  Building(
    name: "📊 Analytics Center",
    track: CareerTrack.business,
    requiredLevel: 4,
    requirements: {AssetType.officeEquipment: 15},
  ),
  Building(
    name: "🏙️ HQ Tower",
    track: CareerTrack.business,
    requiredLevel: 5,
    requirements: {AssetType.realEstate: 50, AssetType.land: 20},
  ),
  Building(
    name: "🌐 Global Operations",
    track: CareerTrack.business,
    requiredLevel: 5,
    requirements: {AssetType.officeEquipment: 50, AssetType.realEstate: 50},
  ),

  // JOB
  Building(
    name: "🪑 Office Desk",
    track: CareerTrack.job,
    requiredLevel: 2,
    requirements: {AssetType.officeEquipment: 3},
  ),
  Building(
    name: "👥 Team Office",
    track: CareerTrack.job,
    requiredLevel: 3,
    requirements: {AssetType.officeEquipment: 8},
  ),
  Building(
    name: "🏬 Department Office",
    track: CareerTrack.job,
    requiredLevel: 4,
    requirements: {AssetType.officeEquipment: 15, AssetType.realEstate: 10},
  ),
  Building(
    name: "🏢 Corporate HQ",
    track: CareerTrack.job,
    requiredLevel: 5,
    requirements: {AssetType.officeEquipment: 30, AssetType.realEstate: 25},
  ),
];

class CareerState {
  final CareerTrack track;
  final int level;

  const CareerState({required this.track, required this.level});

  CareerState copyWith({CareerTrack? track, int? level}) {
    return CareerState(track: track ?? this.track, level: level ?? this.level);
  }
}

const _kpKey = 'kp';
const _gemsKey = 'gems';
const _careerTrackKey = 'careerTrack';
const _careerLevelKey = 'careerLevel';
const _lastIncomeTimeKey = 'lastIncomeTime';
const _cityLayoutKey = 'cityLayout';
const _assetsKey = 'assets';

class PlacedBuilding {
  final String name;
  final int x;
  final int y;

  PlacedBuilding({required this.name, required this.x, required this.y});

  Map<String, dynamic> toJson() => {'name': name, 'x': x, 'y': y};

  factory PlacedBuilding.fromJson(Map<String, dynamic> json) =>
      PlacedBuilding(name: json['name'], x: json['x'], y: json['y']);
}

String trackLabel(CareerTrack track) {
  switch (track) {
    case CareerTrack.student:
      return "Student";
    case CareerTrack.business:
      return "Business";
    case CareerTrack.job:
      return "Job";
  }
}

int dailyIncome(CareerTrack track, int level) {
  if (track == CareerTrack.student) return 2;

  if (track == CareerTrack.business) {
    return [0, 4, 8, 15, 30][level];
  }

  if (track == CareerTrack.job) {
    return [0, 4, 7, 12, 20][level];
  }

  return 0;
}

int requiredKpFor(CareerTrack track, int nextLevel) {
  if (nextLevel <= 1) return 0;

  if (track == CareerTrack.business) {
    return [0, 0, 2000, 5000, 12000, 25000][nextLevel];
  }

  if (track == CareerTrack.job) {
    return [0, 0, 1500, 4000, 9000, 20000][nextLevel];
  }

  return 0;
}

String levelName(CareerTrack track, int level) {
  if (track == CareerTrack.student) return "Student";

  if (track == CareerTrack.business) {
    return ["", "Student", "Idea", "Bootstrap", "Funded", "Unicorn"][level];
  }

  if (track == CareerTrack.job) {
    return ["", "Student", "Employee", "Supervisor", "Manager", "CEO"][level];
  }

  return "";
}

Future<void> saveGameState({
  required int kp,
  required int gems,
  required CareerState career,
  required DateTime lastIncomeTime,
  required List<PlacedBuilding> layout,
  required AssetInventory assets,
}) async {
  final prefs = await SharedPreferences.getInstance();
  debugPrint("💾 SAVING GAME");
  debugPrint(
    "KP: $kp, Gems: $gems, Track: ${career.track}, Level: ${career.level}, Assets: ${assets.items.length}",
  );
  await prefs.setInt(_kpKey, kp);
  await prefs.setInt(_gemsKey, gems);
  await prefs.setString(_careerTrackKey, career.track.name);
  await prefs.setInt(_careerLevelKey, career.level);
  await prefs.setInt(_lastIncomeTimeKey, lastIncomeTime.millisecondsSinceEpoch);

  final layoutJson = jsonEncode(layout.map((b) => b.toJson()).toList());
  await prefs.setString(_cityLayoutKey, layoutJson);

  final assetsJson = jsonEncode(assets.toJson());
  await prefs.setString(_assetsKey, assetsJson);
}

Future<(int, int, CareerState, DateTime, List<PlacedBuilding>, AssetInventory)>
loadGameState() async {
  final prefs = await SharedPreferences.getInstance();
  final kp = prefs.getInt(_kpKey) ?? 0;
  final gems = prefs.getInt(_gemsKey) ?? 0;

  final trackName = prefs.getString(_careerTrackKey);
  final level = prefs.getInt(_careerLevelKey) ?? 1;

  final track = CareerTrack.values.firstWhere(
    (e) => e.name == trackName,
    orElse: () => CareerTrack.student,
  );

  final lastIncomeMillis =
      prefs.getInt(_lastIncomeTimeKey) ?? DateTime.now().millisecondsSinceEpoch;

  final layoutJson = prefs.getString(_cityLayoutKey);
  List<PlacedBuilding> layout = [];
  if (layoutJson != null) {
    final List<dynamic> decoded = jsonDecode(layoutJson);
    layout = decoded.map((item) => PlacedBuilding.fromJson(item)).toList();
  }

  final assetsJson = prefs.getString(_assetsKey);
  AssetInventory assets = const AssetInventory({});
  if (assetsJson != null) {
    assets = AssetInventory.fromJson(jsonDecode(assetsJson));
  }

  debugPrint("Loaded KP: $kp");
  debugPrint("Loaded Gems: $gems");
  debugPrint("Loaded Track: ${track.name}");
  debugPrint("Loaded Level: $level");
  debugPrint("Loaded Buildings: ${layout.length}");
  debugPrint("Loaded Assets: ${assets.items.length}");

  return (
    kp,
    gems,
    CareerState(track: track, level: level),
    DateTime.fromMillisecondsSinceEpoch(lastIncomeMillis),
    layout,
    assets,
  );
}

class BusinessLevel {
  final int level;
  final String name;
  final int requiredKp;

  const BusinessLevel({
    required this.level,
    required this.name,
    required this.requiredKp,
  });
}

const List<BusinessLevel> businessLevels = [
  BusinessLevel(level: 2, name: "Idea", requiredKp: 2000),
  BusinessLevel(level: 3, name: "Bootstrap", requiredKp: 5000),
  BusinessLevel(level: 4, name: "Funded", requiredKp: 10000),
  BusinessLevel(level: 5, name: "Unicorn", requiredKp: 25000),
];
const List<BusinessLevel> jobLevels = [
  BusinessLevel(level: 2, name: "Employee", requiredKp: 2000),
  BusinessLevel(level: 3, name: "Supervisor", requiredKp: 5000),
  BusinessLevel(level: 4, name: "Manager", requiredKp: 10000),
  BusinessLevel(level: 5, name: "CEO", requiredKp: 25000),
];

class CareerLevelInfo {
  final String name;
  final int dailyIncome;
  final List<String> unlockedBuildings;

  const CareerLevelInfo({
    required this.name,
    required this.dailyIncome,
    required this.unlockedBuildings,
  });
}

CareerLevelInfo? getCareerLevelInfo(CareerState career) {
  if (career.track == CareerTrack.business) {
    return businessCareerInfo[career.level];
  }
  if (career.track == CareerTrack.job) {
    return jobCareerInfo[career.level];
  }
  return null;
}

const Map<int, CareerLevelInfo> businessCareerInfo = {
  2: CareerLevelInfo(
    name: "Idea",
    dailyIncome: 5,
    unlockedBuildings: ["💡 Idea Hub"],
  ),
  3: CareerLevelInfo(
    name: "Bootstrap",
    dailyIncome: 10,
    unlockedBuildings: ["🏭 Small Workshop", "📦 Storage Unit"],
  ),
  4: CareerLevelInfo(
    name: "Funded",
    dailyIncome: 25,
    unlockedBuildings: ["🏢 Office Building", "📊 Analytics Center"],
  ),
  5: CareerLevelInfo(
    name: "Unicorn",
    dailyIncome: 60,
    unlockedBuildings: ["🏙️ HQ Tower", "🌐 Global Operations"],
  ),
};

const Map<int, CareerLevelInfo> jobCareerInfo = {
  2: CareerLevelInfo(
    name: "Employee",
    dailyIncome: 4,
    unlockedBuildings: ["🏢 Office Desk"],
  ),
  3: CareerLevelInfo(
    name: "Supervisor",
    dailyIncome: 8,
    unlockedBuildings: ["👥 Team Office"],
  ),
  4: CareerLevelInfo(
    name: "Manager",
    dailyIncome: 16,
    unlockedBuildings: ["🏬 Department Office"],
  ),
  5: CareerLevelInfo(
    name: "CEO",
    dailyIncome: 40,
    unlockedBuildings: ["🏙️ Corporate HQ"],
  ),
};

int getNextCareerLevel(CareerState career) {
  if (career.track == CareerTrack.business) {
    if (career.level == 1) return 2; // Student → Idea
    return career.level + 1;
  }
  return career.level;
}
