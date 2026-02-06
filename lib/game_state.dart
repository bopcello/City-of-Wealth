import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum CareerTrack { student, job, business }

enum AssetType { land, realEstate, machinery, vehicles, officeEquipment }

enum RentType { sharedStudio, smallApartment, luxuryHouse }

enum FoodType { cheap, balanced, buffet }

enum TransportType { public, cycle, car }

const Map<AssetType, int> assetCosts = {
  AssetType.land: 100,
  AssetType.realEstate: 500,
  AssetType.machinery: 200,
  AssetType.vehicles: 300,
  AssetType.officeEquipment: 150,
};

const Map<AssetType, int> assetSellingPrices = {
  AssetType.land: 90,
  AssetType.realEstate: 450,
  AssetType.machinery: 150,
  AssetType.vehicles: 180,
  AssetType.officeEquipment: 100,
};

int assetCost(AssetType type) => assetCosts[type]!;
int assetSellPrice(AssetType type) => assetSellingPrices[type]!;

String assetLabel(AssetType type) {
  switch (type) {
    case AssetType.land:
      return "Land";
    case AssetType.realEstate:
      return "Properties";
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

int getBuildingLevel(String name) {
  final b = buildings.firstWhere(
    (e) => e.name == name,
    orElse: () => const Building(
      name: "",
      track: CareerTrack.student,
      requiredLevel: 1,
      requirements: {},
    ),
  );
  return b.requiredLevel;
}

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
const _rentChoiceKey = 'rentChoice';
const _foodChoiceKey = 'foodChoice';
const _transportChoiceKey = 'transportChoice';
const _insurancesKey = 'insurances';
const _bankruptcyCountKey = 'bankruptcyCount';

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

const Map<int, int> businessKpRequirements = {
  2: 2000,
  3: 5000,
  4: 12000,
  5: 25000,
};

const Map<int, int> jobKpRequirements = {2: 1500, 3: 4000, 4: 9000, 5: 20000};

const int studentNextLevelKp = 2000;

int requiredKpFor(CareerTrack track, int nextLevel) {
  if (nextLevel <= 1) return 0;
  if (nextLevel > 5) return 0;

  if (track == CareerTrack.student) return studentNextLevelKp;

  if (track == CareerTrack.business) {
    return businessKpRequirements[nextLevel] ?? 0;
  }

  if (track == CareerTrack.job) {
    return jobKpRequirements[nextLevel] ?? 0;
  }
  return 0;
}

const studentLevelInfo = CareerLevelInfo(
  name: "Student",
  dailyIncome: 20,
  unlockedBuildings: [],
);

int dailyIncome(CareerTrack track, int level) {
  if (track == CareerTrack.student) {
    return studentLevelInfo.dailyIncome;
  }
  final info = getCareerLevelInfo(CareerState(track: track, level: level));
  return info?.dailyIncome ?? 0;
}

String levelName(CareerTrack track, int level) {
  if (track == CareerTrack.student) {
    return studentLevelInfo.name;
  }

  final info = getCareerLevelInfo(CareerState(track: track, level: level));
  return info?.name ?? "Unknown Level";
}

Future<void> saveGameState({
  required int kp,
  required int gems,
  required CareerState career,
  required DateTime lastIncomeTime,
  required List<PlacedBuilding> layout,
  required AssetInventory assets,
  required RentType? rent,
  required FoodType? food,
  required TransportType? transport,
  required Set<AssetType> insurances,
  required int bankruptcyCount,
}) async {
  final prefs = await SharedPreferences.getInstance();
  debugPrint("💾 SAVING GAME");
  debugPrint(
    "KP: $kp, Gems: $gems, Track: ${career.track}, Level: ${career.level}, Assets: ${assets.items.length}, Bankruptcy: $bankruptcyCount",
  );
  await prefs.setInt(_kpKey, kp);
  await prefs.setInt(_gemsKey, gems);
  await prefs.setString(_careerTrackKey, career.track.name);
  await prefs.setInt(_careerLevelKey, career.level);
  await prefs.setInt(_lastIncomeTimeKey, lastIncomeTime.millisecondsSinceEpoch);
  await prefs.setInt(_bankruptcyCountKey, bankruptcyCount);

  final layoutJson = jsonEncode(layout.map((b) => b.toJson()).toList());
  await prefs.setString(_cityLayoutKey, layoutJson);

  final assetsJson = jsonEncode(assets.toJson());
  await prefs.setString(_assetsKey, assetsJson);

  if (rent != null) {
    await prefs.setString(_rentChoiceKey, rent.name);
  } else {
    await prefs.remove(_rentChoiceKey);
  }
  if (food != null) {
    await prefs.setString(_foodChoiceKey, food.name);
  } else {
    await prefs.remove(_foodChoiceKey);
  }
  if (transport != null) {
    await prefs.setString(_transportChoiceKey, transport.name);
  } else {
    await prefs.remove(_transportChoiceKey);
  }

  final insuranceNames = insurances.map((e) => e.name).toList();
  await prefs.setStringList(_insurancesKey, insuranceNames);
}

Future<
  (
    int,
    int,
    CareerState,
    DateTime,
    List<PlacedBuilding>,
    AssetInventory,
    RentType?,
    FoodType?,
    TransportType?,
    Set<AssetType>,
    int,
  )
>
loadGameState() async {
  final prefs = await SharedPreferences.getInstance();
  final kp = prefs.getInt(_kpKey) ?? 0;
  final gems = prefs.getInt(_gemsKey) ?? 0;
  final bankruptcyCount = prefs.getInt(_bankruptcyCountKey) ?? 0;

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

  final rentName = prefs.getString(_rentChoiceKey);
  final rent = rentName != null
      ? RentType.values.firstWhere((e) => e.name == rentName)
      : null;

  final foodName = prefs.getString(_foodChoiceKey);
  final food = foodName != null
      ? FoodType.values.firstWhere((e) => e.name == foodName)
      : null;

  final transportName = prefs.getString(_transportChoiceKey);
  final transport = transportName != null
      ? TransportType.values.firstWhere((e) => e.name == transportName)
      : null;

  final insuranceNames = prefs.getStringList(_insurancesKey) ?? [];
  final insurances = insuranceNames
      .map((name) => AssetType.values.firstWhere((e) => e.name == name))
      .toSet();

  debugPrint("Loaded KP: $kp");
  debugPrint("Loaded Gems: $gems");
  debugPrint("Loaded Track: ${track.name}");
  debugPrint("Loaded Level: $level");
  debugPrint("Loaded Buildings: ${layout.length}");
  debugPrint("Loaded Assets: ${assets.items.length}");
  debugPrint("Loaded Bankruptcy: $bankruptcyCount");

  return (
    kp,
    gems,
    CareerState(track: track, level: level),
    DateTime.fromMillisecondsSinceEpoch(lastIncomeMillis),
    layout,
    assets,
    rent,
    food,
    transport,
    insurances,
    bankruptcyCount,
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
    dailyIncome: 50,
    unlockedBuildings: ["💡 Idea Hub"],
  ),
  3: CareerLevelInfo(
    name: "Bootstrap",
    dailyIncome: 100,
    unlockedBuildings: ["🏭 Small Workshop", "📦 Storage Unit"],
  ),
  4: CareerLevelInfo(
    name: "Funded",
    dailyIncome: 250,
    unlockedBuildings: ["🏢 Office Building", "📊 Analytics Center"],
  ),
  5: CareerLevelInfo(
    name: "Unicorn",
    dailyIncome: 600,
    unlockedBuildings: ["🏙️ HQ Tower", "🌐 Global Operations"],
  ),
};

const Map<int, CareerLevelInfo> jobCareerInfo = {
  2: CareerLevelInfo(
    name: "Employee",
    dailyIncome: 40,
    unlockedBuildings: ["🏢 Office Desk"],
  ),
  3: CareerLevelInfo(
    name: "Supervisor",
    dailyIncome: 80,
    unlockedBuildings: ["👥 Team Office"],
  ),
  4: CareerLevelInfo(
    name: "Manager",
    dailyIncome: 160,
    unlockedBuildings: ["🏬 Department Office"],
  ),
  5: CareerLevelInfo(
    name: "CEO",
    dailyIncome: 400,
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

// Liability Data
class LiabilityInfo {
  final double incomePercent;
  final String label;
  final String description;

  const LiabilityInfo({
    required this.incomePercent,
    required this.label,
    required this.description,
  });
}

Map<RentType, LiabilityInfo> rentData = {
  RentType.sharedStudio: const LiabilityInfo(
    incomePercent: 0.3,
    label: "Shared Studio",
    description: "Affordable shared living, but difficult to work and rest.",
  ),
  RentType.smallApartment: const LiabilityInfo(
    incomePercent: 0.5,
    label: "Small Apartment",
    description: "A private cozy space. Balanced lifestyle.",
  ),
  RentType.luxuryHouse: const LiabilityInfo(
    incomePercent: 0.9,
    label: "Luxury House",
    description: "Extravagant living. Heavily affects your finances.",
  ),
};

Map<FoodType, LiabilityInfo> foodData = {
  FoodType.cheap: const LiabilityInfo(
    incomePercent: 0.1,
    label: "Cheap Food",
    description: "Lowest cost, but affects your health negatively.",
  ),
  FoodType.balanced: const LiabilityInfo(
    incomePercent: 0.25,
    label: "Balanced Diet",
    description: "Good nutrition for a steady mind and body.",
  ),
  FoodType.buffet: const LiabilityInfo(
    incomePercent: 0.5,
    label: "Buffet",
    description: "Rich and heavy. Expensive and not ideal for health.",
  ),
};

Map<TransportType, LiabilityInfo> transportData = {
  TransportType.public: const LiabilityInfo(
    incomePercent: 0.1,
    label: "Public Transport",
    description: "Efficient and eco-friendly common travel.",
  ),
  TransportType.cycle: const LiabilityInfo(
    incomePercent: 0.0,
    label: "Cycle",
    description: "Zero cost! But tolling on health and wastes time.",
  ),
  TransportType.car: const LiabilityInfo(
    incomePercent: 0.4, // Estimated 40% for maintenance/fuel
    label: "Car",
    description: "Convenient but very high recurring maintenance costs.",
  ),
};

int getMaxRequirementForType(CareerTrack track, int level, AssetType type) {
  // Return a small allowance for Level 1 (Student)
  if (level == 1) {
    switch (type) {
      case AssetType.land:
        return 0;
      case AssetType.realEstate:
        return 0;
      case AssetType.machinery:
        return 0;
      case AssetType.vehicles:
        return 0;
      case AssetType.officeEquipment:
        return 0;
    }
  }

  // Find buildings for this level and track (and below)
  final levelBuildings = buildings.where(
    (b) => b.track == track && b.requiredLevel <= level,
  );
  if (levelBuildings.isEmpty) return 0;

  int maxRequirement = 0;
  for (var b in levelBuildings) {
    final req = b.requirements[type] ?? 0;
    if (req > maxRequirement) maxRequirement = req;
  }
  return maxRequirement;
}

int getTotalAssetsCount(AssetInventory assets) {
  return assets.items.values.fold(0, (sum, val) => sum + val);
}

// Fixed Cost Maps (Scaled 10x)
const Map<String, int> rentCosts = {
  "student_1_sharedStudio": 5,
  "student_1_smallApartment": 10,
  "student_1_luxuryHouse": 20,
  "business_2_sharedStudio": 10,
  "business_2_smallApartment": 25,
  "business_2_luxuryHouse": 40,
  "business_3_sharedStudio": 20,
  "business_3_smallApartment": 50,
  "business_3_luxuryHouse": 90,
  "business_4_sharedStudio": 50,
  "business_4_smallApartment": 125,
  "business_4_luxuryHouse": 220,
  "business_5_sharedStudio": 60,
  "business_5_smallApartment": 300,
  "business_5_luxuryHouse": 500,
  "job_2_sharedStudio": 10,
  "job_2_smallApartment": 20,
  "job_2_luxuryHouse": 35,
  "job_3_sharedStudio": 20,
  "job_3_smallApartment": 40,
  "job_3_luxuryHouse": 70,
  "job_4_sharedStudio": 40,
  "job_4_smallApartment": 80,
  "job_4_luxuryHouse": 150,
  "job_5_sharedStudio": 60,
  "job_5_smallApartment": 200,
  "job_5_luxuryHouse": 380,
};

const Map<String, int> foodCosts = {
  "student_1_cheap": 2,
  "student_1_balanced": 5,
  "student_1_buffet": 10,
  "business_2_cheap": 5,
  "business_2_balanced": 10,
  "business_2_buffet": 40,
  "business_3_cheap": 10,
  "business_3_balanced": 25,
  "business_3_buffet": 50,
  "business_4_cheap": 20,
  "business_4_balanced": 75,
  "business_4_buffet": 150,
  "business_5_cheap": 30,
  "business_5_balanced": 150,
  "business_5_buffet": 250,
  "job_2_cheap": 5,
  "job_2_balanced": 10,
  "job_2_buffet": 20,
  "job_3_cheap": 10,
  "job_3_balanced": 20,
  "job_3_buffet": 40,
  "job_4_cheap": 15,
  "job_4_balanced": 40,
  "job_4_buffet": 60,
  "job_5_cheap": 20,
  "job_5_balanced": 50,
  "job_5_buffet": 100,
};

const Map<String, int> transportCosts = {
  "student_1_public": 3,
  "student_1_cycle": 0,
  "student_1_car": 10,
  "business_2_public": 5,
  "business_2_cycle": 0,
  "business_2_car": 20,
  "business_3_public": 10,
  "business_3_cycle": 0,
  "business_3_car": 30,
  "business_4_public": 20,
  "business_4_cycle": 0,
  "business_4_car": 60,
  "business_5_public": 50,
  "business_5_cycle": 0,
  "business_5_car": 120,
  "job_2_public": 5,
  "job_2_cycle": 0,
  "job_2_car": 20,
  "job_3_public": 10,
  "job_3_cycle": 0,
  "job_3_car": 30,
  "job_4_public": 10,
  "job_4_cycle": 0,
  "job_4_car": 50,
  "job_5_public": 20,
  "job_5_cycle": 0,
  "job_5_car": 80,
};

int getRentCost(CareerTrack track, int level, RentType type) {
  return rentCosts["${track.name}_${level}_${type.name}"] ?? 0;
}

int getFoodCost(CareerTrack track, int level, FoodType type) {
  return foodCosts["${track.name}_${level}_${type.name}"] ?? 0;
}

int getTransportCost(CareerTrack track, int level, TransportType type) {
  return transportCosts["${track.name}_${level}_${type.name}"] ?? 0;
}

const Map<String, int> rentKp = {
  "student_1_sharedStudio": 10,
  "student_1_smallApartment": 5,
  "student_1_luxuryHouse": -150,
  "business_2_sharedStudio": 5,
  "business_2_smallApartment": 15,
  "business_2_luxuryHouse": -100,
  "business_3_sharedStudio": 0,
  "business_3_smallApartment": 20,
  "business_3_luxuryHouse": -50,
  "business_4_sharedStudio": -20,
  "business_4_smallApartment": 10,
  "business_4_luxuryHouse": 20,
  "business_5_sharedStudio": -80,
  "business_5_smallApartment": -10,
  "business_5_luxuryHouse": 40,
  "job_2_sharedStudio": 5,
  "job_2_smallApartment": 15,
  "job_2_luxuryHouse": -100,
  "job_3_sharedStudio": 0,
  "job_3_smallApartment": 20,
  "job_3_luxuryHouse": -50,
  "job_4_sharedStudio": -20,
  "job_4_smallApartment": 15,
  "job_4_luxuryHouse": 20,
  "job_5_sharedStudio": -100,
  "job_5_smallApartment": 5,
  "job_5_luxuryHouse": 40,
};

const Map<String, int> transportKp = {
  "student_1_public": 20,
  "student_1_cycle": 10,
  "student_1_car": -80,
  "business_2_public": 30,
  "business_2_cycle": 5,
  "business_2_car": -60,
  "business_3_public": 20,
  "business_3_cycle": 0,
  "business_3_car": -30,
  "business_4_public": 10,
  "business_4_cycle": -30,
  "business_4_car": -10,
  "business_5_public": -20,
  "business_5_cycle": -80,
  "business_5_car": 60,
  "job_2_public": 30,
  "job_2_cycle": 5,
  "job_2_car": -60,
  "job_3_public": 20,
  "job_3_cycle": 0,
  "job_3_car": -30,
  "job_4_public": 10,
  "job_4_cycle": -30,
  "job_4_car": -10,
  "job_5_public": -20,
  "job_5_cycle": -100,
  "job_5_car": 50,
};

const Map<String, int> foodKp = {
  "student_1_cheap": -10,
  "student_1_balanced": 30,
  "student_1_buffet": -80,
  "business_2_cheap": -20,
  "business_2_balanced": 30,
  "business_2_buffet": -60,
  "business_3_cheap": -30,
  "business_3_balanced": 40,
  "business_3_buffet": -40,
  "business_4_cheap": -50,
  "business_4_balanced": 50,
  "business_4_buffet": -20,
  "business_5_cheap": -100,
  "business_5_balanced": 60,
  "business_5_buffet": 20,
  "job_2_cheap": -20,
  "job_2_balanced": 30,
  "job_2_buffet": -60,
  "job_3_cheap": -30,
  "job_3_balanced": 40,
  "job_3_buffet": -40,
  "job_4_cheap": -50,
  "job_4_balanced": 50,
  "job_4_buffet": -20,
  "job_5_cheap": -100,
  "job_5_balanced": 60,
  "job_5_buffet": 20,
};

int getRentKp(CareerTrack track, int level, RentType type) {
  return rentKp["${track.name}_${level}_${type.name}"] ?? 0;
}

int getFoodKp(CareerTrack track, int level, FoodType type) {
  return foodKp["${track.name}_${level}_${type.name}"] ?? 0;
}

int getTransportKp(CareerTrack track, int level, TransportType type) {
  return transportKp["${track.name}_${level}_${type.name}"] ?? 0;
}
