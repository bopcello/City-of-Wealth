import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../game_state.dart';

class GameManager extends ChangeNotifier {
  int kp = 0;
  int gems = 0;
  CareerState career = const CareerState(track: CareerTrack.student, level: 1);
  DateTime lastIncomeTime = DateTime.now();
  AssetInventory assets = const AssetInventory({});
  List<PlacedBuilding> cityLayout = [];

  RentType? rentChoice;
  FoodType? foodChoice;
  TransportType? transportChoice;
  Set<AssetType> insurances = {};
  int bankruptcyCount = 0;
  int debtCycleCount = 0;
  int? nextDestructionCycle;
  int? nextDisasterCycle;
  List<DisasterResult> pendingDisasterResults = [];
  int cycleTracker = 0;
  bool hasWall = false;
  Set<String> completedQuizzes = {};
  bool isWorkingOvertime = false;
  int overtimeStreak = 0;
  Map<AssetType, int> activePassiveIncomes = {};
  Map<DisasterType, int> activeDisasterEffects = {};
  bool isDarkMode = false;

  bool loaded = false;
  bool incomePaused = false;
  final List<String> pendingEvents = [];

  Timer? _cycleTimer;

  GameManager() {
    _loadGame();
    _cycleTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (loaded) _checkDailyCycle();
    });
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadGame() async {
    final (
      savedKp,
      savedGems,
      savedCareer,
      savedIncomeTime,
      savedLayout,
      savedAssets,
      savedRent,
      savedFood,
      savedTransport,
      savedInsurances,
      savedBankruptcyCount,
      savedDebtCycleCount,
      savedNextDestructionCycle,
      savedNextDisasterCycle,
      savedWall,
      savedCompletedQuizzes,
      savedIsWorkingOvertime,
      savedOvertimeStreak,
      savedActivePassiveIncomes,
      savedActiveDisasterEffects,
      savedIsDarkMode,
    ) = await loadGameState();

    kp = savedKp;
    gems = savedGems;
    career = savedCareer;
    lastIncomeTime = savedIncomeTime;
    cityLayout = savedLayout;
    assets = savedAssets;
    rentChoice = savedRent;
    foodChoice = savedFood;
    transportChoice = savedTransport;
    insurances = savedInsurances;
    bankruptcyCount = savedBankruptcyCount;
    debtCycleCount = savedDebtCycleCount;
    nextDestructionCycle = savedNextDestructionCycle;
    nextDisasterCycle = savedNextDisasterCycle;
    hasWall = savedWall ?? false;
    completedQuizzes = savedCompletedQuizzes;
    isWorkingOvertime = savedIsWorkingOvertime;
    overtimeStreak = savedOvertimeStreak;
    activePassiveIncomes = savedActivePassiveIncomes;
    activeDisasterEffects = savedActiveDisasterEffects;
    isDarkMode = savedIsDarkMode;
    loaded = true;

    notifyListeners();
    _checkDailyCycle();
  }

  void save() {
    saveGameState(
      kp: kp,
      gems: gems,
      career: career,
      lastIncomeTime: lastIncomeTime,
      layout: cityLayout,
      assets: assets,
      rent: rentChoice,
      food: foodChoice,
      transport: transportChoice,
      insurances: insurances,
      bankruptcyCount: bankruptcyCount,
      debtCycleCount: debtCycleCount,
      nextDestructionCycle: nextDestructionCycle,
      nextDisasterCycle: nextDisasterCycle,
      wall: hasWall,
      completedQuizzes: completedQuizzes,
      isWorkingOvertime: isWorkingOvertime,
      overtimeStreak: overtimeStreak,
      activePassiveIncomes: activePassiveIncomes,
      activeDisasterEffects: activeDisasterEffects,
      isDarkMode: isDarkMode,
    );
  }

  void _checkDailyCycle() {
    final now = DateTime.now();
    final difference = now.difference(lastIncomeTime);

    const int cycleSeconds = 10;
    if (difference.inSeconds >= cycleSeconds) {
      if (incomePaused) {
        lastIncomeTime = now;
        return;
      }
      final cycles = difference.inSeconds ~/ cycleSeconds;
      _applyCycles(cycles);
    }
  }

  void _applyCycles(int cycles) {
    int totalKpChange = 0;
    int totalGemChange = 0;
    List<String> events = [];

    final hasAllEssentials =
        rentChoice != null && foodChoice != null && transportChoice != null;
    int income = dailyIncome(career.track, career.level);

    int passiveIncomeTotal = 0;
    activePassiveIncomes.forEach((assetType, investedCount) {
      final multiplier = getPassiveIncomeMultiplier(assetType);
      final info = passiveIncomeData.values.firstWhere(
        (e) => e.assetType == assetType,
      );
      // Only add income if the corresponding building exists
      if (cityLayout.any((b) => b.name == info.buildingName)) {
        final ownedCount = assets.count(assetType);
        final eligibleCount = min(ownedCount, investedCount);

        passiveIncomeTotal += (eligibleCount * info.incomePerAsset * multiplier)
            .round();
      }
    });

    bool hasWaste = false;
    int wastePenalty = 100;
    if (career.level == 1) {
      if (assets.items.isNotEmpty) {
        hasWaste = true;
        wastePenalty = 50;
      }
    } else if (career.level < 5) {
      for (var type in AssetType.values) {
        if (assets.count(type) >
            getMaxRequirementForType(career.track, career.level, type)) {
          hasWaste = true;
          break;
        }
      }
    }

    for (int i = 0; i < cycles; i++) {
      cycleTracker++;
      if (nextDisasterCycle == null) {
        nextDisasterCycle = 20 + Random().nextInt(20);
      } else {
        nextDisasterCycle = nextDisasterCycle! - 1;
        if (nextDisasterCycle! <= 0) {
          _triggerNaturalDisaster();
          nextDisasterCycle = 20 + Random().nextInt(20);
        }
      }

      // Update active disaster effects
      final expiredEffectTypes = <DisasterType>[];
      activeDisasterEffects.forEach((type, remaining) {
        if (remaining <= 1) {
          expiredEffectTypes.add(type);
        } else {
          activeDisasterEffects[type] = remaining - 1;
        }
      });
      for (var type in expiredEffectTypes) {
        activeDisasterEffects.remove(type);
        events.add("The effect of ${type.name} has ended.");
      }

      int dayKp = 0;
      int dayGems = 0;
      final dayNumber = pendingEvents.length + i + 1;

      int currentIncome = income;
      if (isWorkingOvertime && i == 0) {
        currentIncome = (currentIncome * 1.5).round();
      }

      if (hasAllEssentials) {
        dayGems += currentIncome;
      }

      int rCost = rentChoice != null
          ? getRentCost(career.track, career.level, rentChoice!)
          : 0;
      int fCost = foodChoice != null
          ? getFoodCost(career.track, career.level, foodChoice!)
          : 0;
      int tCost = transportChoice != null
          ? getTransportCost(career.track, career.level, transportChoice!)
          : 0;

      int insuranceCost = insurances.length * 5;
      int insuranceKp = insurances.length * 20;

      int maintenanceCost = 0;
      int interestCost = 0;

      final currentBalance = gems + totalGemChange;

      if (currentBalance < 0) {
        debtCycleCount++;

        double rate = 0.05;
        int debtFactor = currentBalance.abs();
        if (debtFactor >= 2000) {
          rate = 0.20;
        } else if (debtFactor >= 1500) {
          rate = 0.10;
        } else if (debtFactor >= 1000) {
          rate = 0.05;
        }
        interestCost = (debtFactor * rate).round();

        if (debtCycleCount > 30) {
          if (cityLayout.isNotEmpty) {
            if (nextDestructionCycle == null || nextDestructionCycle! <= 0) {
              final rng = Random();
              nextDestructionCycle = dayNumber + rng.nextInt(6);
            }

            if (dayNumber >= nextDestructionCycle!) {
              final rng = Random();
              if (cityLayout.isNotEmpty) {
                final indexToRemove = rng.nextInt(cityLayout.length);
                final removed = cityLayout.removeAt(indexToRemove);
                events.add(
                  "${removed.name} was foreclosed/destroyed due to unpaid maintainance costs since you were in debt for more than 30 days!",
                );
                nextDestructionCycle = dayNumber + rng.nextInt(6);
              }
            }
          }
        }
      } else {
        debtCycleCount = 0;
        nextDestructionCycle = null;

        if (dayNumber % 10 == 0) {
          for (var b in cityLayout) {
            maintenanceCost += getBuildingLevel(b.name);
          }
        }
      }

      dayKp +=
          (rentChoice != null
              ? getRentKp(career.track, career.level, rentChoice!)
              : 0) +
          (foodChoice != null
              ? getFoodKp(career.track, career.level, foodChoice!)
              : 0) +
          (transportChoice != null
              ? getTransportKp(career.track, career.level, transportChoice!)
              : 0) +
          insuranceKp;

      if (hasWaste) {
        dayKp -= wastePenalty;
      }

      if (currentBalance < 0) {
        dayKp -= 200;
      }

      dayGems -=
          (rCost +
          fCost +
          tCost +
          insuranceCost +
          maintenanceCost +
          interestCost);

      dayGems += passiveIncomeTotal;

      totalKpChange += dayKp;
      totalGemChange += dayGems;

      final balanceAfterDay = gems + totalGemChange;

      String event =
          "Day $dayNumber: [KP]=${dayKp > 0 ? '+' : ''}$dayKp, [GEM]=${dayGems > 0 ? '+' : ''}$dayGems";
      if (isWorkingOvertime && i == 0) {
        event += " (Worked overtime! Earned 50% extra income)";
      }
      if (interestCost > 0) {
        event += " (You're in debt! Interest: -$interestCost [GEM], -300 [KP])";
        if (balanceAfterDay < -10000) {
          event += " Consider declaring bankruptcy";
        }
      }
      if (maintenanceCost > 0) {
        event += " (Maintenance: -$maintenanceCost [GEM])";
      }
      if (insuranceCost > 0) event += " (Insurance: -$insuranceCost [GEM])";
      if (!hasAllEssentials) {
        event +=
            " (No income: Go to liabilities to select rent, food and transport to begin receiving income)";
      }
      if (hasWaste) {
        event +=
            " (Unnecessary assets penalty: -$wastePenalty KP, sell unnecessary assets)";
      }
      if (passiveIncomeTotal > 0) {
        event += " (Passive Income: +$passiveIncomeTotal [GEM])";
      }
      events.add(event);
    }

    if (cycles > 1) {
      events.add(
        "--- TOTAL SUMMARY: ${totalKpChange > 0 ? '+' : ''}$totalKpChange [KP], ${totalGemChange > 0 ? '+' : ''}$totalGemChange [GEM] across $cycles cycles ---",
      );
    }

    kp += totalKpChange;
    gems += totalGemChange;

    if (isWorkingOvertime && cycles > 0) {
      isWorkingOvertime = false;
    } else if (cycles > 0) {
      overtimeStreak = 0;
    }

    lastIncomeTime = DateTime.now();
    pendingEvents.addAll(events);

    notifyListeners();
    save();
  }

  void clearEvents() {
    pendingEvents.clear();
    notifyListeners();
  }

  void toggleTheme(bool val) {
    isDarkMode = val;
    save();
    notifyListeners();
  }

  void togglePause(bool val) {
    incomePaused = val;
    notifyListeners();
  }

  void placeBuilding(PlacedBuilding building) {
    cityLayout.add(building);
    save();
    notifyListeners();
  }

  void removeBuilding(PlacedBuilding building) {
    cityLayout.removeWhere((b) => b.x == building.x && b.y == building.y);
    save();
    notifyListeners();
  }

  void buyWall() {
    hasWall = true;
    save();
    notifyListeners();
  }

  void updateKp(int delta) {
    kp += delta;
    save();
    notifyListeners();
  }

  void updateCareer(CareerState newCareer) {
    if (newCareer.level > career.level) {
      rentChoice = null;
      foodChoice = null;
      transportChoice = null;
    }
    career = newCareer;
    save();
    notifyListeners();
  }

  void updateLiabilities(RentType? r, FoodType? f, TransportType? t) {
    int kpDelta = 0;
    if (rentChoice == null && r != null) {
      kpDelta += getRentKp(career.track, career.level, r);
    }
    if (foodChoice == null && f != null) {
      kpDelta += getFoodKp(career.track, career.level, f);
    }
    if (transportChoice == null && t != null) {
      kpDelta += getTransportKp(career.track, career.level, t);
    }

    rentChoice = r;
    foodChoice = f;
    transportChoice = t;
    kp += kpDelta;
    save();
    notifyListeners();
  }

  void toggleInsurance(AssetType type) {
    if (insurances.contains(type)) {
      insurances.remove(type);
    } else {
      insurances.add(type);
      kp += 100;
    }
    save();
    notifyListeners();
  }

  void buyAsset(AssetType type, int amount, BuildContext context) {
    final cost = assetCost(type) * amount;

    int kpBonus = 10 * amount;
    String message = "Purchasing necessary assets: +$kpBonus [KP]";

    final currentAssetsOfThisType = assets.count(type);
    final maxAllowedForThisType = getMaxRequirementForType(
      career.track,
      career.level,
      type,
    );

    if (currentAssetsOfThisType + amount > maxAllowedForThisType) {
      kpBonus = -100;
      message =
          "Over-purchasing ${assetLabel(type)} for your level is a bad decision: -100 [KP]";
    }

    if (career.level == 5) {
      if (kpBonus < 0) {
        kpBonus = 10 * amount;
        message = "Purchasing extra assets: +$kpBonus [KP]";
      }
    }

    gems -= cost;
    assets = assets.add(type, amount);
    kp += kpBonus;

    save();
    notifyListeners();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Asset Purchased"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Ok!"),
          ),
        ],
      ),
    );
  }

  void sellAsset(AssetType type) {
    if (assets.count(type) <= 0) return;
    final sellPrice = assetSellPrice(type);
    gems += sellPrice;
    assets = assets.add(type, -1);
    save();
    notifyListeners();
  }

  void declareBankruptcy(BuildContext context) {
    if (bankruptcyCount >= 3) return;

    int totalLiquidationValue = 0;
    for (var type in AssetType.values) {
      totalLiquidationValue += assets.count(type) * assetSellPrice(type);
    }

    final gemsRecovered = (totalLiquidationValue * 0.2).round();

    bankruptcyCount++;
    kp = 0;
    gems = gemsRecovered;
    career = const CareerState(track: CareerTrack.student, level: 1);
    cityLayout = [];
    assets = const AssetInventory({});
    insurances = {};
    rentChoice = null;
    foodChoice = null;
    transportChoice = null;
    debtCycleCount = 0;
    nextDestructionCycle = null;
    hasWall = false;
    activePassiveIncomes = {};
    activeDisasterEffects = {};
    completedQuizzes = {};

    save();
    notifyListeners();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Bankruptcy Declared"),
        content: Text(
          "All your assets were auctioned off and your debt was waived. "
          "Thankfully, the bank recovered $gemsRecovered gems more than your debt.\n\n"
          "You are now back to being a Level 1 Student. Good luck starting over!",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("I understand"),
          ),
        ],
      ),
    );
  }

  void markQuizCompleted(String quizId) {
    if (!completedQuizzes.contains(quizId)) {
      completedQuizzes.add(quizId);
      save();
      notifyListeners();
    }
  }

  void investInPassiveIncome(AssetType assetType) {
    final info = passiveIncomeData.values.firstWhere(
      (e) => e.assetType == assetType,
    );

    final currentInvested = activePassiveIncomes[assetType] ?? 0;
    final ownedCount = assets.count(assetType);

    if (gems >= info.investmentCost && currentInvested < ownedCount) {
      gems -= info.investmentCost;
      activePassiveIncomes[assetType] = currentInvested + 1;
      save();
      notifyListeners();
    }
  }

  DisasterType? getActiveDisasterForAsset(AssetType type) {
    if (type == AssetType.land &&
        activeDisasterEffects.containsKey(DisasterType.drought)) {
      return DisasterType.drought;
    } else if (type == AssetType.vehicles &&
        activeDisasterEffects.containsKey(DisasterType.landslide)) {
      return DisasterType.landslide;
    } else if (type == AssetType.machinery &&
        activeDisasterEffects.containsKey(DisasterType.economyCrash)) {
      return DisasterType.economyCrash;
    } else if (type == AssetType.properties &&
        activeDisasterEffects.containsKey(DisasterType.massEmigration)) {
      return DisasterType.massEmigration;
    } else if (type == AssetType.officeEquipment &&
        activeDisasterEffects.containsKey(DisasterType.pandemic)) {
      return DisasterType.pandemic;
    }
    return null;
  }

  double getPassiveIncomeMultiplier(AssetType type) {
    double multiplier = 1.0;
    if (type == AssetType.land &&
        activeDisasterEffects.containsKey(DisasterType.drought)) {
      multiplier *= 0.25;
    } else if (type == AssetType.vehicles &&
        activeDisasterEffects.containsKey(DisasterType.landslide)) {
      multiplier *= 0.20;
    } else if (type == AssetType.machinery &&
        activeDisasterEffects.containsKey(DisasterType.economyCrash)) {
      multiplier *= 0.40;
    } else if (type == AssetType.properties &&
        activeDisasterEffects.containsKey(DisasterType.massEmigration)) {
      multiplier *= 0.20;
    } else if (type == AssetType.officeEquipment &&
        activeDisasterEffects.containsKey(DisasterType.pandemic)) {
      multiplier *= 0.10;
    }
    return multiplier;
  }

  void workOvertime() {
    if (isWorkingOvertime) return;

    overtimeStreak++;
    int penalty = 50;
    if (overtimeStreak > 10) {
      penalty = 50 + (overtimeStreak - 10) * 50;
      if (penalty > 1000) penalty = 1000;
    }

    kp -= penalty;
    if (kp < 0) kp = 0;
    isWorkingOvertime = true;

    save();
    notifyListeners();
  }

  void debugAdd() {
    kp += 1000;
    gems += 1000;
    save();
    notifyListeners();
  }

  void debugReset() {
    career = const CareerState(track: CareerTrack.student, level: 1);
    cityLayout = [];
    assets = const AssetInventory({});
    rentChoice = null;
    foodChoice = null;
    transportChoice = null;
    completedQuizzes = {};
    pendingEvents.clear();
    save();
    notifyListeners();
  }

  void _triggerNaturalDisaster() {
    if (cityLayout.isEmpty) return;

    final rng = Random();
    final assetDisasters = [
      DisasterType.flood,
      DisasterType.fire,
      DisasterType.earthquake,
    ];
    final passiveIncomeDisasters = [
      DisasterType.economyCrash,
      DisasterType.drought,
      DisasterType.landslide,
      DisasterType.massEmigration,
      DisasterType.pandemic,
    ];

    final allDisasters = [...assetDisasters, ...passiveIncomeDisasters];
    final disasterType = allDisasters[rng.nextInt(allDisasters.length)];

    List<String> destroyedNames = [];
    Map<AssetType, int> lostAssets = {};
    Map<AssetType, int> insurancePayouts = {};
    int kpPenalty = 0;
    bool hasAnyInsurance = false;

    // Capture initial asset counts to enforce 50% cap
    Map<AssetType, int> initialAssetCounts = {};
    for (var type in AssetType.values) {
      initialAssetCounts[type] = assets.count(type);
    }

    if (assetDisasters.contains(disasterType)) {
      // ASSET DISASTERS: Destroy raw assets directly (up to 50%)
      List<AssetType> targets = [];
      if (disasterType == DisasterType.flood) {
        targets = [AssetType.land];
      } else if (disasterType == DisasterType.fire) {
        targets = [AssetType.properties, AssetType.vehicles];
      } else if (disasterType == DisasterType.earthquake) {
        targets = [AssetType.officeEquipment, AssetType.machinery];
      }

      for (var type in targets) {
        int owned = initialAssetCounts[type]!;
        if (owned > 0) {
          int toDestroyCount = (rng.nextDouble() * 0.5 * owned).ceil();
          if (toDestroyCount > 0) {
            lostAssets[type] = toDestroyCount;
            assets = assets.add(type, -toDestroyCount);

            if (insurances.contains(type)) {
              final payout = (toDestroyCount * assetCost(type) * 0.8).round();
              insurancePayouts[type] = payout;
              gems += payout;
              hasAnyInsurance = true;
            }
          }
        }
      }
    }

    Map<AssetType, int> deactivatedPassiveIncomes = {};
    String? passiveIncomeReduction;

    if (passiveIncomeDisasters.contains(disasterType)) {
      // PASSIVE INCOME DISASTERS: Reduce yield and deactivate units
      const duration = 30;
      activeDisasterEffects[disasterType] = duration;

      switch (disasterType) {
        case DisasterType.drought:
          passiveIncomeReduction = "Farms -75% for $duration cycles";
          break;
        case DisasterType.landslide:
          passiveIncomeReduction =
              "Distribution Center -80% for $duration cycles";
          break;
        case DisasterType.economyCrash:
          passiveIncomeReduction = "Factory -60% for $duration cycles";
          break;
        case DisasterType.massEmigration:
          passiveIncomeReduction = "Apartment -80% for $duration cycles";
          break;
        case DisasterType.pandemic:
          passiveIncomeReduction =
              "IT Service Center -90% for $duration cycles";
          break;
        default:
          break;
      }

      // 20% chance of unit deactivation for specifically Passive Income Disasters
      activePassiveIncomes.forEach((type, count) {
        if (count > 0 && rng.nextDouble() < 0.20) {
          activePassiveIncomes[type] = count - 1;
          deactivatedPassiveIncomes[type] =
              (deactivatedPassiveIncomes[type] ?? 0) + 1;
        }
      });
    }

    // Link asset destruction to passive income deactivation
    lostAssets.forEach((assetType, lostCount) {
      final currentInvested = activePassiveIncomes[assetType] ?? 0;
      final currentOwned = assets.count(
        assetType,
      ); // assets already subtracted above
      if (currentInvested > currentOwned) {
        final loss = currentInvested - currentOwned;
        activePassiveIncomes[assetType] = currentOwned;
        deactivatedPassiveIncomes[assetType] =
            (deactivatedPassiveIncomes[assetType] ?? 0) + loss;
      }
    });

    // Remove buildings whose passive income units are now 0
    deactivatedPassiveIncomes.forEach((type, deactivatedCount) {
      if ((activePassiveIncomes[type] ?? 0) <= 0 && deactivatedCount > 0) {
        final info = passiveIncomeData.values.firstWhere(
          (e) => e.assetType == type,
        );
        // Find if this building exists in city
        bool exists = cityLayout.any((b) => b.name == info.buildingName);
        if (exists) {
          cityLayout.removeWhere((b) => b.name == info.buildingName);
          if (!destroyedNames.contains(info.buildingName)) {
            destroyedNames.add(info.buildingName);
          }
        }
      }
    });

    pendingDisasterResults.add(
      DisasterResult(
        type: disasterType,
        destroyedBuildings: destroyedNames,
        lostAssets: lostAssets,
        insurancePayouts: insurancePayouts,
        kpPenalty: kpPenalty,
        protected: hasAnyInsurance,
        deactivatedPassiveIncomes: deactivatedPassiveIncomes,
        passiveIncomeReduction: passiveIncomeReduction,
      ),
    );

    pendingEvents.add(
      "DISASTER: ${disasterLabel(disasterType)}! Check the detail report for losses and insurance coverage.",
    );

    save();
    notifyListeners();
  }

  String disasterLabel(DisasterType type) {
    switch (type) {
      case DisasterType.flood:
        return "Flood";
      case DisasterType.fire:
        return "Fire";
      case DisasterType.earthquake:
        return "Earthquake";
      case DisasterType.economyCrash:
        return "Economy Crash";
      case DisasterType.drought:
        return "Drought";
      case DisasterType.landslide:
        return "Landslide";
      case DisasterType.massEmigration:
        return "Mass Emigration";
      case DisasterType.pandemic:
        return "Pandemic";
    }
  }

  void clearDisasterResults() {
    pendingDisasterResults.clear();
    notifyListeners();
  }

  void debugLevelUp({CareerTrack? track}) {
    if (career.track == CareerTrack.student) {
      updateCareer(CareerState(track: track ?? CareerTrack.business, level: 2));
    } else if (career.level < 5) {
      updateCareer(career.copyWith(level: career.level + 1));
    } else {
      // If already level 5, maybe just add some resources
      debugAdd();
    }
  }
}
