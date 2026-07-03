import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'services/firestore_service.dart';

enum CareerTrack { student, job, business }

enum AssetType { land, properties, machinery, vehicles, officeEquipment }

enum RentType { sharedStudio, smallApartment, luxuryHouse }

enum FoodType { cheap, balanced, buffet }

enum TransportType { public, cycle, car }

enum DisasterType {
  flood,
  fire,
  earthquake,
  economyCrash,
  drought,
  landslide,
  massEmigration,
  pandemic,
}

enum PassiveIncomeType { farm, factory, apartment, goodsExchange, xeroxShop }

class DisasterResult {
  final DisasterType type;
  final List<String> destroyedBuildings;
  final Map<AssetType, int> lostAssets;
  final Map<AssetType, int> insurancePayouts; // asset -> total gems
  final int kpPenalty;
  final bool protected;
  final Map<AssetType, int> deactivatedPassiveIncomes;
  final String? passiveIncomeReduction; // e.g., "Farms -75% for 15 cycles"

  DisasterResult({
    required this.type,
    required this.destroyedBuildings,
    required this.lostAssets,
    required this.insurancePayouts,
    required this.kpPenalty,
    required this.protected,
    this.deactivatedPassiveIncomes = const {},
    this.passiveIncomeReduction,
  });

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'destroyedBuildings': destroyedBuildings,
    'lostAssets': lostAssets.map((k, v) => MapEntry(k.name, v)),
    'insurancePayouts': insurancePayouts.map((k, v) => MapEntry(k.name, v)),
    'kpPenalty': kpPenalty,
    'protected': protected,
    'deactivatedPassiveIncomes': deactivatedPassiveIncomes.map(
      (k, v) => MapEntry(k.name, v),
    ),
    'passiveIncomeReduction': passiveIncomeReduction,
  };

  factory DisasterResult.fromJson(Map<String, dynamic> json) => DisasterResult(
    type: DisasterType.values.firstWhere((e) => e.name == json['type']),
    destroyedBuildings: List<String>.from(json['destroyedBuildings']),
    lostAssets: (json['lostAssets'] as Map<String, dynamic>).map(
      (k, v) =>
          MapEntry(AssetType.values.firstWhere((e) => e.name == k), v as int),
    ),
    insurancePayouts: (json['insurancePayouts'] as Map<String, dynamic>).map(
      (k, v) =>
          MapEntry(AssetType.values.firstWhere((e) => e.name == k), v as int),
    ),
    kpPenalty: json['kpPenalty'],
    protected: json['protected'],
    deactivatedPassiveIncomes:
        (json['deactivatedPassiveIncomes'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(
            AssetType.values.firstWhere((e) => e.name == k),
            v as int,
          ),
        ) ??
        const {},
    passiveIncomeReduction: json['passiveIncomeReduction'],
  );
}

class PassiveIncomeInfo {
  final PassiveIncomeType type;
  final AssetType assetType;
  final String buildingName;
  final int investmentCost;
  final int incomePerAsset;

  const PassiveIncomeInfo({
    required this.type,
    required this.assetType,
    required this.buildingName,
    required this.investmentCost,
    required this.incomePerAsset,
  });
}

const Map<PassiveIncomeType, PassiveIncomeInfo> passiveIncomeData = {
  PassiveIncomeType.farm: PassiveIncomeInfo(
    type: PassiveIncomeType.farm,
    assetType: AssetType.land,
    buildingName: "Farm",
    investmentCost: 80,
    incomePerAsset: 10,
  ),
  PassiveIncomeType.factory: PassiveIncomeInfo(
    type: PassiveIncomeType.factory,
    assetType: AssetType.machinery,
    buildingName: "Factory",
    investmentCost: 150,
    incomePerAsset: 12,
  ),
  PassiveIncomeType.apartment: PassiveIncomeInfo(
    type: PassiveIncomeType.apartment,
    assetType: AssetType.properties,
    buildingName: "Apartment",
    investmentCost: 400,
    incomePerAsset: 50,
  ),
  PassiveIncomeType.goodsExchange: PassiveIncomeInfo(
    type: PassiveIncomeType.goodsExchange,
    assetType: AssetType.vehicles,
    buildingName: "Distribution Center",
    investmentCost: 250,
    incomePerAsset: 35,
  ),
  PassiveIncomeType.xeroxShop: PassiveIncomeInfo(
    type: PassiveIncomeType.xeroxShop,
    assetType: AssetType.officeEquipment,
    buildingName: "IT Service Center",
    investmentCost: 120,
    incomePerAsset: 20,
  ),
};

const Map<AssetType, int> assetCosts = {
  AssetType.land: 100,
  AssetType.properties: 500,
  AssetType.machinery: 200,
  AssetType.vehicles: 300,
  AssetType.officeEquipment: 150,
};

const Map<AssetType, int> assetSellingPrices = {
  AssetType.land: 90,
  AssetType.properties: 450,
  AssetType.machinery: 150,
  AssetType.vehicles: 180,
  AssetType.officeEquipment: 100,
};

int assetCost(AssetType type, {int streak = 0}) {
  final baseCost = assetCosts[type] ?? 0;
  final rewards = getStreakRewards(streak);
  return (baseCost * (1.0 - rewards.assetDiscount)).round();
}

int assetSellPrice(AssetType type) => assetSellingPrices[type]!;

String assetLabel(AssetType type) {
  switch (type) {
    case AssetType.land:
      return "Land";
    case AssetType.properties:
      return "Buildings";
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

  String get iconPath {
    final Map<String, String> mapping = {
      "Idea Hub": "idea_hub.png",
      "Office Desk": "office_desk.png",
      "Coffee Stand": "coffee_stand.png",
      "Workshop": "workshop.png",
      "Storage Unit": "storage_unit.png",
      "Team Office": "team_office.png",
      "Logistics Garage": "logistics_garage.png",
      "Office Building": "office_building.png",
      "Analytics Center": "analytics_center.png",
      "Department Office": "department_office.png",
      "Conference Center": "conference_center.png",
      "R&D Center": "rd_center.png",
      "Global Operations": "global_operations.png",
      "Company Headquarters": "company_hq.png",
      "Boardroom Pavilion": "boardroom_pavilion.png",
      "Farm": "farm.png",
      "Factory": "factory.png",
      "Apartment": "apartment.png",
      "Distribution Center": "distribution_center.png",
      "IT Service Center": "it_service_center.png",
      "The Keystone": "keystone.png",
      "Palace": "palace.png",
    };
    return "lib/assets/buildings/${mapping[name] ?? 'default_building.png'}";
  }
}

const buildings = [
  // LEVEL 2
  Building(
    name: "Idea Hub",
    track: CareerTrack.business,
    requiredLevel: 2,
    requirements: {AssetType.properties: 5},
  ),
  Building(
    name: "Office Desk",
    track: CareerTrack.job,
    requiredLevel: 2,
    requirements: {AssetType.officeEquipment: 3},
  ),
  Building(
    name: "Coffee Stand",
    track: CareerTrack.job,
    requiredLevel: 2,
    requirements: {AssetType.officeEquipment: 5},
  ),

  // LEVEL 3
  Building(
    name: "Workshop",
    track: CareerTrack.business,
    requiredLevel: 3,
    requirements: {AssetType.properties: 10, AssetType.land: 5},
  ),
  Building(
    name: "Storage Unit",
    track: CareerTrack.business,
    requiredLevel: 3,
    requirements: {AssetType.properties: 15, AssetType.land: 8},
  ),
  Building(
    name: "Team Office",
    track: CareerTrack.job,
    requiredLevel: 3,
    requirements: {AssetType.officeEquipment: 8, AssetType.land: 10},
  ),
  Building(
    name: "Logistics Garage",
    track: CareerTrack.job,
    requiredLevel: 3,
    requirements: {AssetType.vehicles: 12, AssetType.land: 5},
  ),

  // LEVEL 4
  Building(
    name: "Office Building",
    track: CareerTrack.business,
    requiredLevel: 4,
    requirements: {AssetType.properties: 20, AssetType.officeEquipment: 10},
  ),
  Building(
    name: "Analytics Center",
    track: CareerTrack.business,
    requiredLevel: 4,
    requirements: {AssetType.officeEquipment: 15, AssetType.machinery: 5},
  ),
  Building(
    name: "Department Office",
    track: CareerTrack.job,
    requiredLevel: 4,
    requirements: {AssetType.officeEquipment: 15, AssetType.properties: 10},
  ),
  Building(
    name: "Conference Center",
    track: CareerTrack.job,
    requiredLevel: 4,
    requirements: {AssetType.properties: 20, AssetType.officeEquipment: 15},
  ),

  // LEVEL 5
  Building(
    name: "R&D Center",
    track: CareerTrack.business,
    requiredLevel: 5,
    requirements: {AssetType.properties: 50, AssetType.land: 20},
  ),
  Building(
    name: "Global Operations",
    track: CareerTrack.business,
    requiredLevel: 5,
    requirements: {AssetType.officeEquipment: 50, AssetType.properties: 50},
  ),
  Building(
    name: "Company Headquarters",
    track: CareerTrack.job,
    requiredLevel: 5,
    requirements: {AssetType.officeEquipment: 30, AssetType.properties: 25},
  ),
  Building(
    name: "Boardroom Pavilion",
    track: CareerTrack.job,
    requiredLevel: 5,
    requirements: {AssetType.properties: 45, AssetType.officeEquipment: 20},
  ),

  // Passive Income Buildings
  Building(
    name: "Farm",
    track: CareerTrack.student, // No track requirement
    requiredLevel: 1,
    requirements: {}, // Will check for passive income investment instead
  ),
  Building(
    name: "Factory",
    track: CareerTrack.student,
    requiredLevel: 1,
    requirements: {},
  ),
  Building(
    name: "Apartment",
    track: CareerTrack.student,
    requiredLevel: 1,
    requirements: {},
  ),
  Building(
    name: "Distribution Center",
    track: CareerTrack.student,
    requiredLevel: 1,
    requirements: {},
  ),
  Building(
    name: "IT Service Center",
    track: CareerTrack.student,
    requiredLevel: 1,
    requirements: {},
  ),
  Building(
    name: "The Keystone",
    track: CareerTrack.business,
    requiredLevel: 5,
    requirements: {},
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

const kpKey = 'kp';
const gemsKey = 'gems';
const careerTrackKey = 'careerTrack';
const careerLevelKey = 'careerLevel';
const lastIncomeTimeKey = 'lastIncomeTime';
const cityLayoutKey = 'cityLayout';
const assetsKey = 'assets';
const rentChoiceKey = 'rentChoice';
const foodChoiceKey = 'foodChoice';
const transportChoiceKey = 'transportChoice';
const insurancesKey = 'insurances';
const bankruptcyCountKey = 'bankruptcyCount';
const debtCycleCountKey = 'debtCycleCount';
const nextDestructionCycleKey = 'nextDestructionCycle';
const nextDisasterCycleKey = 'nextDisasterCycle';
const completedQuizzesKey = 'completedQuizzes';
const isWorkingOvertimeKey = 'isWorkingOvertime';
const overtimeStreakKey = 'overtimeStreak';
const activePassiveIncomesKey = 'activePassiveIncomes';
const playerNameKey = 'playerName';
const isDarkModeKey = 'isDarkMode';
const musicVolumeKey = 'musicVolume';
const sfxVolumeKey = 'sfxVolume';
const lastUpdatedKey = 'lastUpdated';
const dailyQuizStreakKey = 'dailyQuizStreak';
const lastDailyQuizDateKey = 'lastDailyQuizDate';
const solvedQuizHashesKey = 'solvedQuizHashes';
const streakRevivalsKey = 'streakRevivals';
const lastRevivalDateKey = 'lastRevivalDate';
const nextDisasterTypeKey = 'nextDisasterType';
const onboardingCompleteKey = 'onboardingComplete';
const wakeUpHourKey = 'wakeUpHour';
const wakeUpMinuteKey = 'wakeUpMinute';
const disasterAlertsEnabledKey = 'disasterAlertsEnabled';

class StreakRewards {
  final double assetDiscount; // e.g. 0.05 for 5%
  final double passiveIncomeMultiplier; // e.g. 1.05 for 5% increase
  final String label;

  const StreakRewards({
    this.assetDiscount = 0.0,
    this.passiveIncomeMultiplier = 1.0,
    this.label = "",
  });
}

StreakRewards getStreakRewards(int streak) {
  if (streak >= 100) {
    return const StreakRewards(
      assetDiscount: 0.10,
      passiveIncomeMultiplier: 1.05,
      label: "Master of Money",
    );
  } else if (streak >= 30) {
    return const StreakRewards(
      assetDiscount: 0.05,
      passiveIncomeMultiplier: 1.05,
      label: "Consistency Master",
    );
  } else if (streak >= 10) {
    return const StreakRewards(assetDiscount: 0.05, label: "Regular Customer");
  }
  return const StreakRewards();
}

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
  2: 5000,
  3: 10000,
  4: 20000,
  5: 50000,
};

const Map<int, int> jobKpRequirements = {2: 5000, 3: 10000, 4: 20000, 5: 50000};

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
  String? uid,
  bool syncToCloud = false,
  Map<String, dynamic>? partialData,
  // Fallback params if partialData is null
  int? kp,
  int? gems,
  CareerState? career,
  DateTime? lastIncomeTime,
  List<PlacedBuilding>? layout,
  AssetInventory? assets,
  RentType? rent,
  FoodType? food,
  TransportType? transport,
  Set<AssetType>? insurances,
  int? bankruptcyCount,
  int? debtCycleCount,
  int? nextDestructionCycle,
  int? nextDisasterCycle,
  bool? wall,
  Set<String>? completedQuizzes,
  bool? isWorkingOvertime,
  int? overtimeStreak,
  Map<AssetType, int>? activePassiveIncomes,
  Map<DisasterType, int>? activeDisasterEffects,
  String? playerName,
  bool? isDarkMode,
  double? musicVolume,
  double? sfxVolume,
  List<DisasterResult>? pendingDisasterResults,
  int? dailyQuizStreak,
  String? lastDailyQuizDate,
  Set<String>? solvedQuizHashes,
  int? streakRevivals,
  String? lastRevivalDate,
  DisasterType? nextDisasterType,
  bool? onboardingComplete,
  int? wakeUpHour,
  int? wakeUpMinute,
  bool? disasterAlertsEnabled,
  Map<String, dynamic>? stats,
}) async {
  final prefs = await SharedPreferences.getInstance();

  final Map<String, dynamic> data;
  if (partialData != null) {
    data = Map<String, dynamic>.from(partialData);
    if (!data.containsKey(lastUpdatedKey)) {
      data[lastUpdatedKey] = DateTime.now().millisecondsSinceEpoch;
    }
  } else {
    data = {
      kpKey: kp,
      gemsKey: gems,
      careerTrackKey: career?.track.name,
      careerLevelKey: career?.level,
      lastIncomeTimeKey: lastIncomeTime?.millisecondsSinceEpoch,
      bankruptcyCountKey: bankruptcyCount,
      playerNameKey: playerName,
      cityLayoutKey: layout != null
          ? jsonEncode(layout.map((b) => b.toJson()).toList())
          : null,
      assetsKey: assets != null ? jsonEncode(assets.toJson()) : null,
      rentChoiceKey: rent?.name,
      foodChoiceKey: food?.name,
      transportChoiceKey: transport?.name,
      insurancesKey: insurances?.map((e) => e.name).toList(),
      debtCycleCountKey: debtCycleCount,
      nextDestructionCycleKey: nextDestructionCycle,
      nextDisasterCycleKey: nextDisasterCycle,
      'hasWall': wall,
      completedQuizzesKey: completedQuizzes?.toList(),
      isWorkingOvertimeKey: isWorkingOvertime,
      overtimeStreakKey: overtimeStreak,
      activePassiveIncomesKey: activePassiveIncomes != null
          ? jsonEncode(activePassiveIncomes.map((k, v) => MapEntry(k.name, v)))
          : null,
      'activeDisasterEffects': activeDisasterEffects != null
          ? jsonEncode(activeDisasterEffects.map((k, v) => MapEntry(k.name, v)))
          : null,
      isDarkModeKey: isDarkMode,
      musicVolumeKey: musicVolume,
      sfxVolumeKey: sfxVolume,
      'pendingDisasterResults': pendingDisasterResults != null
          ? jsonEncode(pendingDisasterResults.map((e) => e.toJson()).toList())
          : null,
      solvedQuizHashesKey: solvedQuizHashes?.toList(),
      lastUpdatedKey: DateTime.now().millisecondsSinceEpoch,
      dailyQuizStreakKey: dailyQuizStreak,
      lastDailyQuizDateKey: lastDailyQuizDate,
      streakRevivalsKey: streakRevivals,
      lastRevivalDateKey: lastRevivalDate,
      nextDisasterTypeKey: nextDisasterType?.name,
      onboardingCompleteKey: onboardingComplete,
      wakeUpHourKey: wakeUpHour,
      wakeUpMinuteKey: wakeUpMinute,
      disasterAlertsEnabledKey: disasterAlertsEnabled,
      'stats': stats != null ? jsonEncode(stats) : null,
    };
    // Remove null values to avoid overwriting with null if not intended
    data.removeWhere((key, value) => value == null);
  }

  debugPrint("💾 SAVING GAME LOCALLY (${data.keys.length} fields updated)");

  // Local Save - Only iterate over keys in 'data'
  for (var entry in data.entries) {
    final key = entry.key;
    final value = entry.value;

    final scopedKey = uid != null ? "${uid}_$key" : key;

    if (value == null) {
      await prefs.remove(scopedKey);
    } else if (value is int) {
      await prefs.setInt(scopedKey, value);
    } else if (value is String) {
      await prefs.setString(scopedKey, value);
    } else if (value is bool) {
      await prefs.setBool(scopedKey, value);
    } else if (value is double) {
      await prefs.setDouble(scopedKey, value);
    } else if (value is List<String>) {
      await prefs.setStringList(scopedKey, value);
    }
  }

  for (final key in [
    isDarkModeKey,
    musicVolumeKey,
    sfxVolumeKey,
    lastUpdatedKey,
  ]) {
    if (!data.containsKey(key)) continue;
    final value = data[key];
    if (value == null) {
      await prefs.remove(key);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
  }

  // Cloud Save
  if (syncToCloud && uid != null) {
    await FirestoreService().savePlayerProgress(uid, data);
  }
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
    int,
    int?,
    int?,
    bool?,
    Set<String>,
    bool,
    int,
    Map<AssetType, int>,
    Map<DisasterType, int>,
    String,
    bool,
    double,
    double,
    List<DisasterResult>,
    int,
    String,
    Set<String>,
    int,
    String?,
    DisasterType?,
    bool,
    int,
    int,
    bool,
    Map<String, dynamic>?,
  )
>
loadGameState({String? uid, bool useCloud = false, bool force = false}) async {
  final prefs = await SharedPreferences.getInstance();

  // Helper to scope keys to current user ID
  String scopedKey(String key) {
    return uid != null ? "${uid}_$key" : key;
  }

  // One-time local data migration for this user
  if (uid != null) {
    final scopedLastUpdatedKey = "${uid}_$lastUpdatedKey";
    if (!prefs.containsKey(scopedLastUpdatedKey)) {
      if (prefs.containsKey(lastUpdatedKey)) {
        debugPrint(
          "🔄 Migrating unscoped local save data to user-scoped data for $uid",
        );
        final keysToMigrate = [
          kpKey,
          gemsKey,
          careerTrackKey,
          careerLevelKey,
          lastIncomeTimeKey,
          cityLayoutKey,
          assetsKey,
          rentChoiceKey,
          foodChoiceKey,
          transportChoiceKey,
          insurancesKey,
          bankruptcyCountKey,
          debtCycleCountKey,
          nextDestructionCycleKey,
          nextDisasterCycleKey,
          'hasWall',
          completedQuizzesKey,
          isWorkingOvertimeKey,
          overtimeStreakKey,
          activePassiveIncomesKey,
          'activeDisasterEffects',
          playerNameKey,
          isDarkModeKey,
          musicVolumeKey,
          sfxVolumeKey,
          'pendingDisasterResults',
          solvedQuizHashesKey,
          lastUpdatedKey,
          dailyQuizStreakKey,
          lastDailyQuizDateKey,
          streakRevivalsKey,
          lastRevivalDateKey,
          nextDisasterTypeKey,
          onboardingCompleteKey,
          wakeUpHourKey,
          wakeUpMinuteKey,
          disasterAlertsEnabledKey,
          'tutorialComplete',
          'new_quiz_ready',
        ];
        for (final key in keysToMigrate) {
          if (prefs.containsKey(key)) {
            final val = prefs.get(key);
            final sKey = "${uid}_$key";
            if (val is int) {
              await prefs.setInt(sKey, val);
            } else if (val is String) {
              await prefs.setString(sKey, val);
            } else if (val is bool) {
              await prefs.setBool(sKey, val);
            } else if (val is double) {
              await prefs.setDouble(sKey, val);
            } else if (val is List<String>) {
              await prefs.setStringList(sKey, val);
            }
            await prefs.remove(key);
          }
        }
      }
    }
  }

  Map<String, dynamic>? cloudData;
  if (uid != null && useCloud) {
    cloudData = await FirestoreService().getPlayerProgress(uid);
  }

  final localLastUpdated = prefs.getInt(scopedKey(lastUpdatedKey)) ?? 0;

  int cloudLastUpdated = 0;
  if (cloudData != null && cloudData.containsKey(lastUpdatedKey)) {
    final val = cloudData[lastUpdatedKey];
    if (val is int) {
      cloudLastUpdated = val;
    } else if (val is double) {
      cloudLastUpdated = val.toInt();
    } else if (val is Timestamp) {
      cloudLastUpdated = val.millisecondsSinceEpoch;
    }
  }

  // For completedQuizzes, we always merge them to avoid losing progress.
  final List<dynamic> localQuizzes =
      prefs.getStringList(scopedKey(completedQuizzesKey)) ?? [];
  final cloudQuizzesRaw = cloudData?[completedQuizzesKey];
  final List<dynamic> cloudQuizzes = (cloudQuizzesRaw is List)
      ? cloudQuizzesRaw
      : [];
  final mergedQuizzes = {
    ...localQuizzes.map((e) => e.toString()),
    ...cloudQuizzes.map((e) => e.toString()),
  };

  final List<dynamic> localSolvedHashes =
      prefs.getStringList(scopedKey(solvedQuizHashesKey)) ?? [];
  final cloudSolvedHashesRaw = cloudData?[solvedQuizHashesKey];
  final List<dynamic> cloudSolvedHashes = (cloudSolvedHashesRaw is List)
      ? cloudSolvedHashesRaw
      : [];
  final mergedSolvedHashes = {
    ...localSolvedHashes.map((e) => e.toString()),
    ...cloudSolvedHashes.map((e) => e.toString()),
  };

  // Decide whether to use cloud data for other fields
  bool preferCloud = false;
  if (cloudData != null) {
    if (force) {
      debugPrint("🔄 FORCING cloud data overwrite (user triggered)");
      preferCloud = true;
    } else if (cloudLastUpdated > localLastUpdated) {
      debugPrint(
        "🔄 Cloud data is newer ($cloudLastUpdated > $localLastUpdated). Using cloud.",
      );
      preferCloud = true;
    } else {
      debugPrint(
        "ℹ️ Local data is newer or equal ($localLastUpdated >= $cloudLastUpdated). Skipping cloud overwrite.",
      );
    }
  }

  final data = preferCloud ? cloudData! : {};

  final int kp =
      (data[kpKey] as num?)?.toInt() ?? prefs.getInt(scopedKey(kpKey)) ?? 0;
  final int gems =
      (data[gemsKey] as num?)?.toInt() ?? prefs.getInt(scopedKey(gemsKey)) ?? 0;
  final int bankruptcyCount =
      (data[bankruptcyCountKey] as num?)?.toInt() ??
      prefs.getInt(scopedKey(bankruptcyCountKey)) ??
      0;
  final int debtCycleCount =
      (data[debtCycleCountKey] as num?)?.toInt() ??
      prefs.getInt(scopedKey(debtCycleCountKey)) ??
      0;
  final int? nextDestructionCycle =
      (data[nextDestructionCycleKey] as num?)?.toInt() ??
      (prefs.containsKey(scopedKey(nextDestructionCycleKey))
          ? prefs.getInt(scopedKey(nextDestructionCycleKey))
          : null);
  final int? nextDisasterCycle =
      (data[nextDisasterCycleKey] as num?)?.toInt() ??
      (prefs.containsKey(scopedKey(nextDisasterCycleKey))
          ? prefs.getInt(scopedKey(nextDisasterCycleKey))
          : null);
  final bool isDarkMode =
      data[isDarkModeKey] == true ||
      (prefs.getBool(scopedKey(isDarkModeKey)) ?? false);
  final String playerName =
      data[playerNameKey]?.toString() ??
      prefs.getString(scopedKey(playerNameKey)) ??
      "User";
  final double musicVolume =
      (data[musicVolumeKey] as num?)?.toDouble() ??
      prefs.getDouble(scopedKey(musicVolumeKey)) ??
      0.7;
  final double sfxVolume =
      (data[sfxVolumeKey] as num?)?.toDouble() ??
      prefs.getDouble(scopedKey(sfxVolumeKey)) ??
      1.0;
  final int dailyQuizStreak =
      (data[dailyQuizStreakKey] as num?)?.toInt() ??
      prefs.getInt(scopedKey(dailyQuizStreakKey)) ??
      0;
  final String lastDailyQuizDate =
      data[lastDailyQuizDateKey]?.toString() ??
      prefs.getString(scopedKey(lastDailyQuizDateKey)) ??
      "";
  final Set<String> solvedQuizHashes = mergedSolvedHashes;
  final int streakRevivals =
      (data[streakRevivalsKey] as num?)?.toInt() ??
      prefs.getInt(scopedKey(streakRevivalsKey)) ??
      3;
  final String? lastRevivalDate =
      data[lastRevivalDateKey]?.toString() ??
      prefs.getString(scopedKey(lastRevivalDateKey));
  final String? nextDisasterTypeName =
      data[nextDisasterTypeKey]?.toString() ??
      prefs.getString(scopedKey(nextDisasterTypeKey));
  final DisasterType? nextDisasterType = nextDisasterTypeName != null
      ? DisasterType.values.firstWhere(
          (e) => e.name == nextDisasterTypeName,
          orElse: () => DisasterType.flood,
        )
      : null;

  final bool onboardingComplete =
      (data[onboardingCompleteKey] == true) ||
      (prefs.getBool(scopedKey(onboardingCompleteKey)) ?? false);
  final int wakeUpHour =
      (data[wakeUpHourKey] as num?)?.toInt() ??
      prefs.getInt(scopedKey(wakeUpHourKey)) ??
      8;
  final int wakeUpMinute =
      (data[wakeUpMinuteKey] as num?)?.toInt() ??
      prefs.getInt(scopedKey(wakeUpMinuteKey)) ??
      0;
  final bool disasterAlertsEnabled =
      (data[disasterAlertsEnabledKey] == true) ||
      (prefs.getBool(scopedKey(disasterAlertsEnabledKey)) ?? true);

  final String? trackName =
      data[careerTrackKey]?.toString() ??
      prefs.getString(scopedKey(careerTrackKey));
  final int level =
      (data[careerLevelKey] as num?)?.toInt() ??
      prefs.getInt(scopedKey(careerLevelKey)) ??
      1;

  final track = CareerTrack.values.firstWhere(
    (e) => e.name == trackName,
    orElse: () => CareerTrack.student,
  );

  int lastIncomeMillis;
  final cloudIncomeTime = data[lastIncomeTimeKey];
  if (cloudIncomeTime is int) {
    lastIncomeMillis = cloudIncomeTime;
  } else if (cloudIncomeTime is double) {
    lastIncomeMillis = cloudIncomeTime.toInt();
  } else if (cloudIncomeTime is Timestamp) {
    lastIncomeMillis = cloudIncomeTime.millisecondsSinceEpoch;
  } else {
    lastIncomeMillis =
        prefs.getInt(scopedKey(lastIncomeTimeKey)) ??
        DateTime.now().millisecondsSinceEpoch;
  }

  final layoutJson =
      data[cityLayoutKey] ?? prefs.getString(scopedKey(cityLayoutKey));
  List<PlacedBuilding> layout = [];
  if (layoutJson != null) {
    try {
      final List<dynamic> decoded = layoutJson is String
          ? jsonDecode(layoutJson)
          : (layoutJson is List ? layoutJson : []);
      layout = decoded.map((item) => PlacedBuilding.fromJson(item)).toList();
    } catch (e) {
      debugPrint("⚠️ Error decoding city layout: $e");
    }
  }

  final assetsJson = data[assetsKey] ?? prefs.getString(scopedKey(assetsKey));
  AssetInventory assets = const AssetInventory({});
  if (assetsJson != null) {
    try {
      final decoded = assetsJson is String
          ? jsonDecode(assetsJson)
          : (assetsJson is Map ? assetsJson : null);
      if (decoded != null) assets = AssetInventory.fromJson(decoded);
    } catch (e) {
      debugPrint("⚠️ Error decoding assets: $e");
    }
  }

  final rentName =
      data[rentChoiceKey] ?? prefs.getString(scopedKey(rentChoiceKey));
  final rent = rentName != null
      ? RentType.values.firstWhere((e) => e.name == rentName)
      : null;

  final foodName =
      data[foodChoiceKey] ?? prefs.getString(scopedKey(foodChoiceKey));
  final food = foodName != null
      ? FoodType.values.firstWhere((e) => e.name == foodName)
      : null;

  final transportName =
      data[transportChoiceKey] ??
      prefs.getString(scopedKey(transportChoiceKey));
  final transport = transportName != null
      ? TransportType.values.firstWhere((e) => e.name == transportName)
      : null;

  final List<dynamic> insuranceNamesRaw =
      data[insurancesKey] ??
      prefs.getStringList(scopedKey(insurancesKey)) ??
      [];
  final List<dynamic> insuranceNames = insuranceNamesRaw;
  final insurances = insuranceNames
      .map(
        (name) => AssetType.values.firstWhere(
          (e) => e.name == name.toString(),
          orElse: () => AssetType.properties,
        ),
      )
      .toSet();

  final bool? savedWall =
      (data['hasWall'] as bool?) ?? prefs.getBool(scopedKey('hasWall'));
  final completedQuizzes = mergedQuizzes;

  final bool isWorkingOvertime =
      (data[isWorkingOvertimeKey] == true) ||
      (prefs.getBool(scopedKey(isWorkingOvertimeKey)) ?? false);
  final int overtimeStreak =
      (data[overtimeStreakKey] as num?)?.toInt() ??
      prefs.getInt(scopedKey(overtimeStreakKey)) ??
      0;

  final passiveIncomeJson =
      data[activePassiveIncomesKey] ??
      prefs.getString(scopedKey(activePassiveIncomesKey));
  Map<AssetType, int> activePassiveIncomes = {};
  if (passiveIncomeJson != null) {
    try {
      final decodedRaw = passiveIncomeJson is String
          ? jsonDecode(passiveIncomeJson)
          : passiveIncomeJson;
      if (decodedRaw is Map) {
        activePassiveIncomes = decodedRaw.map(
          (k, v) => MapEntry(
            AssetType.values.firstWhere(
              (e) => e.name == k.toString(),
              orElse: () => AssetType.properties,
            ),
            (v as num?)?.toInt() ?? 0,
          ),
        );
      }
    } catch (e) {
      debugPrint("⚠️ Error decoding passive incomes: $e");
    }
  }

  final disasterEffectsJson =
      data['activeDisasterEffects'] ??
      prefs.getString(scopedKey('activeDisasterEffects'));
  Map<DisasterType, int> activeDisasterEffects = {};
  if (disasterEffectsJson != null) {
    try {
      final decodedRaw = disasterEffectsJson is String
          ? jsonDecode(disasterEffectsJson)
          : disasterEffectsJson;
      if (decodedRaw is Map) {
        activeDisasterEffects = decodedRaw.map(
          (k, v) => MapEntry(
            DisasterType.values.firstWhere(
              (e) => e.name == k.toString(),
              orElse: () => DisasterType.flood,
            ),
            (v as num?)?.toInt() ?? 0,
          ),
        );
      }
    } catch (e) {
      debugPrint("⚠️ Error decoding disaster effects: $e");
    }
  }

  final pendingResultsJson =
      data['pendingDisasterResults'] ??
      prefs.getString(scopedKey('pendingDisasterResults'));
  List<DisasterResult> pendingDisasterResults = [];
  if (pendingResultsJson != null) {
    try {
      final List<dynamic> decoded = pendingResultsJson is String
          ? jsonDecode(pendingResultsJson)
          : (pendingResultsJson is List ? pendingResultsJson : []);
      pendingDisasterResults = decoded
          .map((e) => DisasterResult.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint("⚠️ Error decoding pending disaster results: $e");
    }
  }

  final statsJson = data['stats'] ?? prefs.getString(scopedKey('stats'));
  Map<String, dynamic>? stats;
  if (statsJson != null) {
    try {
      stats = statsJson is String
          ? jsonDecode(statsJson)
          : (statsJson is Map ? Map<String, dynamic>.from(statsJson) : null);
    } catch (e) {
      debugPrint("⚠️ Error decoding stats: $e");
    }
  }

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
    debtCycleCount,
    nextDestructionCycle,
    nextDisasterCycle,
    savedWall,
    completedQuizzes,
    isWorkingOvertime,
    overtimeStreak,
    activePassiveIncomes,
    activeDisasterEffects,
    playerName,
    isDarkMode,
    musicVolume,
    sfxVolume,
    pendingDisasterResults,
    dailyQuizStreak,
    lastDailyQuizDate,
    solvedQuizHashes,
    streakRevivals,
    lastRevivalDate,
    nextDisasterType,
    onboardingComplete,
    wakeUpHour,
    wakeUpMinute,
    disasterAlertsEnabled,
    stats,
  );
}

// Helper methods for quiz progression
bool isMediumQuiz(String quizId) {
  // ID format: l{level}_q{num}
  final parts = quizId.split('_');
  if (parts.length != 2) return false;
  final numPart = parts[1].substring(1); // remove 'q'
  final num = int.tryParse(numPart);
  if (num == null) return false;
  return num >= 4 && num <= 18;
}

bool isHardQuiz(String quizId) {
  final parts = quizId.split('_');
  if (parts.length != 2) return false;
  final numPart = parts[1].substring(1);
  final num = int.tryParse(numPart);
  if (num == null) return false;
  return num >= 19 && num <= 20;
}

int countCompletedMediumQuizzes(Set<String> completed, int level) {
  final prefix = 'l${level}_';
  return completed
      .where((id) => id.startsWith(prefix) && isMediumQuiz(id))
      .length;
}

int countCompletedHardQuizzes(Set<String> completed, int level) {
  final prefix = 'l${level}_';
  return completed
      .where((id) => id.startsWith(prefix) && isHardQuiz(id))
      .length;
}

int countTotalCompletedQuizzesForLevel(Set<String> completed, int level) {
  final prefix = 'l${level}_';
  return completed.where((id) => id.startsWith(prefix)).length;
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
    unlockedBuildings: ["Idea Hub"],
  ),
  3: CareerLevelInfo(
    name: "Bootstrap",
    dailyIncome: 100,
    unlockedBuildings: ["Workshop", "Storage Unit"],
  ),
  4: CareerLevelInfo(
    name: "Funded",
    dailyIncome: 250,
    unlockedBuildings: ["Office Building", "Analytics Center"],
  ),
  5: CareerLevelInfo(
    name: "Unicorn",
    dailyIncome: 600,
    unlockedBuildings: ["R&D Center", "Global Operations"],
  ),
};

const Map<int, CareerLevelInfo> jobCareerInfo = {
  2: CareerLevelInfo(
    name: "Employee",
    dailyIncome: 40,
    unlockedBuildings: ["Office Desk", "Coffee Stand"],
  ),
  3: CareerLevelInfo(
    name: "Supervisor",
    dailyIncome: 80,
    unlockedBuildings: ["Team Office", "Logistics Garage"],
  ),
  4: CareerLevelInfo(
    name: "Manager",
    dailyIncome: 160,
    unlockedBuildings: ["Department Office", "Conference Center"],
  ),
  5: CareerLevelInfo(
    name: "CEO",
    dailyIncome: 400,
    unlockedBuildings: ["Company Headquarters", "Boardroom Pavilion"],
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
      case AssetType.properties:
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
  return assets.items.values.fold(0, (total, val) => total + val);
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
