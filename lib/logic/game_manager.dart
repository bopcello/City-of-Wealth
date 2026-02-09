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
    final income = dailyIncome(career.track, career.level);

    bool hasWaste = false;
    int wastePenalty = 100;
    if (career.level == 1) {
      if (assets.items.isNotEmpty) {
        hasWaste = true;
        wastePenalty = 50;
      }
    } else {
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
        nextDisasterCycle = 15 + Random().nextInt(16);
      } else {
        nextDisasterCycle = nextDisasterCycle! - 1;
        if (nextDisasterCycle! <= 0) {
          _triggerNaturalDisaster();
          nextDisasterCycle = 15 + Random().nextInt(16);
        }
      }

      int dayKp = 0;
      int dayGems = 0;
      final dayNumber = pendingEvents.length + i + 1;

      if (hasAllEssentials) {
        dayGems += income;
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

      totalKpChange += dayKp;
      totalGemChange += dayGems;

      final balanceAfterDay = gems + totalGemChange;

      String event =
          "Day $dayNumber: Kp=${dayKp > 0 ? '+' : ''}$dayKp, Gems=${dayGems > 0 ? '+' : ''}$dayGems";
      if (interestCost > 0) {
        event += " (You're in debt! Interest: -$interestCost Gems, -300 KP)";
        if (balanceAfterDay < -5000) {
          event += " Consider declaring bankruptcy";
        }
      }
      if (maintenanceCost > 0) {
        event += " (Maintenance: -$maintenanceCost Gems)";
      }
      if (insuranceCost > 0) event += " (Insurance: -$insuranceCost Gems)";
      if (!hasAllEssentials) {
        event +=
            " (No income: Go to liabilities to select rent, food and transport to begin receiving income)";
      }
      if (hasWaste)
        event +=
            " (Unnecessary assets penalty: -$wastePenalty KP, sell unnecessary assets)";
      events.add(event);
    }

    kp += totalKpChange;
    gems += totalGemChange;
    lastIncomeTime = DateTime.now();
    pendingEvents.addAll(events);

    notifyListeners();
    save();
  }

  void clearEvents() {
    pendingEvents.clear();
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
    String message = "Purchasing necessary assets: +$kpBonus KP";

    final currentAssetsOfThisType = assets.count(type);
    final maxAllowedForThisType = getMaxRequirementForType(
      career.track,
      career.level,
      type,
    );

    if (currentAssetsOfThisType + amount > maxAllowedForThisType) {
      kpBonus = -100;
      message =
          "Over-purchasing ${assetLabel(type)} for your level is a bad decision: -100 KP";
    }

    if (career.level == 5) {
      if (kpBonus < 0) {
        kpBonus = 10 * amount;
        message = "Purchasing extra assets: +$kpBonus KP";
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
    final disasterType =
        DisasterType.values[rng.nextInt(DisasterType.values.length)];

    // Destroy up to 50% of buildings
    int buildingsToDestroyCount = (cityLayout.length * 0.5).ceil();
    if (buildingsToDestroyCount == 0 && cityLayout.isNotEmpty) {
      buildingsToDestroyCount = 1;
    }

    List<PlacedBuilding> toDestroy = [];
    List<PlacedBuilding> pool = List.from(cityLayout);

    // Weighted selection based on disaster type
    pool.sort((a, b) {
      final bA = buildings.firstWhere((e) => e.name == a.name);
      final bB = buildings.firstWhere((e) => e.name == b.name);

      bool aMatches = _doesBuildingMatchDisaster(bA, disasterType);
      bool bMatches = _doesBuildingMatchDisaster(bB, disasterType);

      if (aMatches && !bMatches) return -1;
      if (!aMatches && bMatches) return 1;
      return 0;
    });

    for (int i = 0; i < buildingsToDestroyCount && pool.isNotEmpty; i++) {
      toDestroy.add(pool.removeAt(0));
    }

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

    for (var pb in toDestroy) {
      destroyedNames.add(pb.name);
      cityLayout.remove(pb);

      final buildingData = buildings.firstWhere((e) => e.name == pb.name);
      for (var entry in buildingData.requirements.entries) {
        final type = entry.key;
        final reqCount = entry.value;

        // Calculate potential loss for this building (20% to 100% of its requirement)
        int potentialLoss = ((rng.nextDouble() * 0.8 + 0.2) * reqCount).ceil();

        // Enforce 50% cap of total owned assets of this type
        int maxAllowedLossForThisType = (initialAssetCounts[type]! * 0.5)
            .floor();
        int currentTotalLossForThisType = lostAssets[type] ?? 0;
        int remainingLossAllowed =
            maxAllowedLossForThisType - currentTotalLossForThisType;

        int assetLoss = potentialLoss;
        if (assetLoss > remainingLossAllowed) {
          assetLoss = remainingLossAllowed;
        }

        final currentOwned = assets.count(type);
        if (assetLoss > currentOwned) assetLoss = currentOwned;

        if (assetLoss > 0) {
          lostAssets[type] = (lostAssets[type] ?? 0) + assetLoss;
          assets = assets.add(type, -assetLoss);

          if (insurances.contains(type)) {
            final payout = (assetLoss * assetCost(type) * 0.8).round();
            insurancePayouts[type] = (insurancePayouts[type] ?? 0) + payout;
            gems += payout;
            hasAnyInsurance = true;
          }
        }
      }
    }

    if (!hasAnyInsurance && lostAssets.isNotEmpty) {
      kpPenalty = 1500;
      kp -= kpPenalty;
      if (kp < 0) kp = 0;
    }

    pendingDisasterResults.add(
      DisasterResult(
        type: disasterType,
        destroyedBuildings: destroyedNames,
        lostAssets: lostAssets,
        insurancePayouts: insurancePayouts,
        kpPenalty: kpPenalty,
        protected: hasAnyInsurance,
      ),
    );

    pendingEvents.add(
      "DISASTER: ${disasterType.name.toUpperCase()}! Check detail report for losses and insurance coverage.",
    );

    save();
    notifyListeners();
  }

  bool _doesBuildingMatchDisaster(Building b, DisasterType type) {
    switch (type) {
      case DisasterType.flood:
        return b.requirements.containsKey(AssetType.land);
      case DisasterType.fire:
        return b.requirements.containsKey(AssetType.properties) ||
            b.requirements.containsKey(AssetType.vehicles);
      case DisasterType.earthquake:
        return b.requirements.containsKey(AssetType.officeEquipment) ||
            b.requirements.containsKey(AssetType.machinery);
      case DisasterType.economyCrash:
        return true;
    }
  }

  void clearDisasterResults() {
    pendingDisasterResults.clear();
    notifyListeners();
  }

  void debugLevelUp() {
    if (career.track == CareerTrack.student) {
      updateCareer(const CareerState(track: CareerTrack.business, level: 2));
    } else if (career.level < 5) {
      updateCareer(career.copyWith(level: career.level + 1));
    } else {
      // If already level 5, maybe just add some resources
      debugAdd();
    }
  }
}
