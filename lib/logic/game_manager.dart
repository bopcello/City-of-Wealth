import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../game_state.dart';
import 'game_stats.dart';
import '../services/notification_service.dart';
import '../services/firestore_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../services/music_manager.dart';
import '../widgets/icon_text.dart';

class GameManager extends ChangeNotifier with WidgetsBindingObserver {
  final FirestoreService firestoreService = FirestoreService();
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
  double musicVolume = 0.7;
  double sfxVolume = 1.0;
  String playerName = "User";
  int dailyQuizStreak = 0;
  String lastDailyQuizDate = "";
  Set<String> solvedQuizHashes = {};
  int streakRevivals = 3;
  String? lastRevivalDate;
  DisasterType? nextDisasterType;
  bool onboardingComplete = false;
  bool tutorialComplete = false;
  bool isTutorialActive = false;
  bool isTutorialBackAllowed = false;

  /// Set to true while a selection-result popup is open during the tutorial
  /// so the tutorial overlay knows to expand to fullscreen and allow the
  /// underlying dialog to receive touches.
  bool isTutorialPopupActive = false;

  void setTutorialPopupActive(bool value) {
    isTutorialPopupActive = value;
    notifyListeners();
  }

  VoidCallback? onBackGestureIntercepted;
  VoidCallback? onTutorialBackStepTriggered;
  int wakeUpHour = 8;
  int wakeUpMinute = 0;
  bool disasterAlertsEnabled = true;
  GameStats stats = GameStats();
  MusicManager? musicManager;
  int _selectedIndex = 0;
  String? _currentUid;
  DateTime? _lastSyncTime;
  bool _isSaving = false;
  bool _syncRequestedWhileLoading = false;

  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value) {
    if (_selectedIndex != value) {
      _selectedIndex = value;
      // Close edit mode if switching away from City tab (index 1)
      if (_selectedIndex != 1) {
        isEditMode = false;
        selectedBuilding = null;
      }
      notifyListeners();
    }
  }

  bool isEditMode = false;
  Building? selectedBuilding;

  void toggleEditMode() {
    isEditMode = !isEditMode;
    selectedBuilding = null;
    notifyListeners();
  }

  void setBuildingSelection(Building? building) {
    selectedBuilding = building;
    notifyListeners();
  }

  void clearSelection() {
    selectedBuilding = null;
    isEditMode = false;
    notifyListeners();
  }

  bool loaded = false;
  final List<String> pendingEvents = [];
  List<String> recentVisitedMoneyTiles = [];

  Timer? _cycleTimer;
  Timer? _notificationRescheduleTimer;

  GameManager() {
    final user = FirebaseAuth.instance.currentUser;
    _currentUid = user?.uid;
    _loadGame(useCloud: user != null);
    _cycleTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (loaded) _checkDailyCycle();
    });

    WidgetsBinding.instance.addObserver(this);

    // Listen to Auth state changes to reload data on login
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        if (_currentUid == null || _currentUid != user.uid) {
          _currentUid = user.uid;
          _loadGame(useCloud: true);
        }
      } else {
        _currentUid = null;
        _resetToDefault();
        SharedPreferences.getInstance().then((prefs) {
          prefs.setBool('new_quiz_ready', false);
        });
      }
    });
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    _notificationRescheduleTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void attachMusicManager(MusicManager mm) {
    musicManager = mm;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      debugPrint("📱 App state changed ($state): Triggering sync");
      musicManager?.pauseMusic();
      syncWithCloud(force: true);
      NotificationService().scheduleInactivityNotification(playerName);
    } else if (state == AppLifecycleState.resumed) {
      debugPrint("📱 App resumed: Resuming music, checking quiz flag, and rescheduling notifications");
      musicManager?.resumeMusic();
      _checkNewQuizFlag();
      _rescheduleNotificationsDebounced();
    }
  }

  void _rescheduleNotificationsDebounced() {
    _notificationRescheduleTimer?.cancel();
    _notificationRescheduleTimer = Timer(const Duration(seconds: 5), () async {
      if (!loaded || playerName == "User") return;
      try {
        debugPrint("🔔 Rescheduling all notifications (debounced)");
        await NotificationService().rescheduleAllNotifications(
          playerName: playerName,
          dailyQuizStreak: dailyQuizStreak,
          streakRevivals: streakRevivals,
          lastDailyQuizDate: lastDailyQuizDate,
          wakeUpHour: wakeUpHour,
          wakeUpMinute: wakeUpMinute,
        );
      } catch (e) {
        debugPrint("❌ Error rescheduling notifications: $e");
      }
    });
  }

  Future<void> _checkNewQuizFlag() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final newQuizReadyKeyScoped = uid != null
        ? "${uid}_new_quiz_ready"
        : 'new_quiz_ready';
    final bool newQuizReady =
        prefs.getBool(newQuizReadyKeyScoped) ??
        prefs.getBool('new_quiz_ready') ??
        false;
    if (newQuizReady) {
      await NotificationService().showNewQuizNotification(playerName);
      await prefs.setBool(newQuizReadyKeyScoped, false);
      await prefs.setBool('new_quiz_ready', false);
    }
  }

  void _resetToDefault() {
    kp = 0;
    gems = 0;
    career = const CareerState(track: CareerTrack.student, level: 1);
    lastIncomeTime = DateTime.now();
    assets = const AssetInventory({});
    cityLayout = [];
    rentChoice = null;
    foodChoice = null;
    transportChoice = null;
    insurances = {};
    bankruptcyCount = 0;
    debtCycleCount = 0;
    nextDestructionCycle = null;
    nextDisasterCycle = null;
    pendingDisasterResults = [];
    cycleTracker = 0;
    hasWall = false;
    completedQuizzes = {};
    isWorkingOvertime = false;
    overtimeStreak = 0;
    activePassiveIncomes = {};
    activeDisasterEffects = {};
    isDarkMode = false;
    musicVolume = 0.7;
    sfxVolume = 1.0;
    playerName = "User";
    dailyQuizStreak = 0;
    lastDailyQuizDate = "";
    solvedQuizHashes = {};
    streakRevivals = 3;
    lastRevivalDate = null;
    nextDisasterType = null;
    onboardingComplete = false;
    tutorialComplete = false;
    isTutorialActive = false;
    isTutorialBackAllowed = false;
    wakeUpHour = 8;
    wakeUpMinute = 0;
    disasterAlertsEnabled = true;
    stats = GameStats();
    recentVisitedMoneyTiles = [];
    loaded = false;
    notifyListeners();
  }

  Future<void> _loadGame({bool useCloud = false, bool force = false}) async {
    try {
      if (loaded) {
        loaded = false;
        notifyListeners();
      }
      final uid = FirebaseAuth.instance.currentUser?.uid;
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
        savedPlayerName,
        savedIsDarkMode,
        savedMusicVolume,
        savedSfxVolume,
        savedPendingDisasterResults,
        savedDailyQuizStreak,
        savedLastDailyQuizDate,
        savedSolvedQuizHashes,
        savedStreakRevivals,
        savedLastRevivalDate,
        savedNextDisasterType,
        savedOnboardingComplete,
        savedWakeUpHour,
        savedWakeUpMinute,
        savedDisasterAlertsEnabled,
        savedStats,
      ) = await loadGameState(
        uid: uid,
        useCloud: useCloud,
        force: force,
      );

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
      playerName = savedPlayerName;
      isDarkMode = savedIsDarkMode;
      musicVolume = savedMusicVolume;
      sfxVolume = savedSfxVolume;
      pendingDisasterResults = savedPendingDisasterResults;
      dailyQuizStreak = savedDailyQuizStreak;
      lastDailyQuizDate = savedLastDailyQuizDate;
      solvedQuizHashes = savedSolvedQuizHashes;
      streakRevivals = savedStreakRevivals;
      lastRevivalDate = savedLastRevivalDate;
      nextDisasterType = savedNextDisasterType;
      onboardingComplete = savedOnboardingComplete;
      wakeUpHour = savedWakeUpHour;
      wakeUpMinute = savedWakeUpMinute;
      disasterAlertsEnabled = savedDisasterAlertsEnabled;
      if (savedStats != null) {
        stats = GameStats.fromJson(savedStats);
      }

      final prefs = await SharedPreferences.getInstance();
      tutorialComplete =
          prefs.getBool(
            uid != null ? "${uid}_tutorialComplete" : 'tutorialComplete',
          ) ??
          false;
      final recentKey = uid != null ? "${uid}_recent_money_tiles" : "recent_money_tiles";
      recentVisitedMoneyTiles = prefs.getStringList(recentKey) ?? [];
      if (onboardingComplete && !tutorialComplete) {
        isTutorialActive = true;
      }

      loaded = true;
      notifyListeners();

      // Only start cycles if the player has already set their name.
      // This allows the NameEntryDialog to be the first thing the user sees.
      if (playerName != "User") {
        _checkDailyCycle();
        _checkStreakConsistency();
        _syncDailyQuiz(); // Check for new quiz on load
        _rescheduleNotificationsDebounced();
      }

      if (_syncRequestedWhileLoading) {
        _syncRequestedWhileLoading = false;
        syncWithCloud(force: true);
      }
    } catch (e) {
      debugPrint("❌ Error loading game: $e");
      // Fallback to local if cloud fails?
      if (useCloud) {
        debugPrint("🔄 Attempting fallback to local load...");
        await _loadGame(useCloud: false);
      } else {
        loaded = true; // Ensure we stop the loading state
        notifyListeners();
      }
    }
  }

  Future<void> forceCloudLoad() async {
    loaded = false;
    notifyListeners();
    await _loadGame(useCloud: true, force: true);
  }

  Future<void> syncWithCloud({bool force = false}) async {
    if (!loaded) {
      debugPrint("⚠️ Queueing cloud sync: Game manager not yet loaded");
      _syncRequestedWhileLoading = true;
      return;
    }

    final now = DateTime.now();
    if (!force &&
        _lastSyncTime != null &&
        now.difference(_lastSyncTime!) < const Duration(seconds: 5)) {
      debugPrint("⏳ Skipping cloud sync (already synced recently)");
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      debugPrint("⚠️ Skipping cloud sync: No authenticated user");
      return;
    }

    _lastSyncTime = now;
    final context = force ? " (Forced Sync)" : "";
    debugPrint("🔄 Triggering cloud sync for user $uid$context");

    await saveGameState(
      uid: uid,
      syncToCloud: true,
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
      playerName: playerName,
      isDarkMode: isDarkMode,
      musicVolume: musicVolume,
      sfxVolume: sfxVolume,
      pendingDisasterResults: pendingDisasterResults,
      dailyQuizStreak: dailyQuizStreak,
      lastDailyQuizDate: lastDailyQuizDate,
      solvedQuizHashes: solvedQuizHashes,
      streakRevivals: streakRevivals,
      lastRevivalDate: lastRevivalDate,
      nextDisasterType: nextDisasterType,
      onboardingComplete: onboardingComplete,
      wakeUpHour: wakeUpHour,
      wakeUpMinute: wakeUpMinute,
      disasterAlertsEnabled: disasterAlertsEnabled,
      stats: stats.toJson(),
    );
  }

  Future<void> save() async {
    if (!loaded || _isSaving) return;
    _isSaving = true;

    try {
      await saveGameState(
        uid: FirebaseAuth.instance.currentUser?.uid,
        syncToCloud: false,
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
        playerName: playerName,
        isDarkMode: isDarkMode,
        musicVolume: musicVolume,
        sfxVolume: sfxVolume,
        pendingDisasterResults: pendingDisasterResults,
        dailyQuizStreak: dailyQuizStreak,
        lastDailyQuizDate: lastDailyQuizDate,
        solvedQuizHashes: solvedQuizHashes,
        streakRevivals: streakRevivals,
        lastRevivalDate: lastRevivalDate,
        nextDisasterType: nextDisasterType,
        onboardingComplete: onboardingComplete,
        wakeUpHour: wakeUpHour,
        wakeUpMinute: wakeUpMinute,
        disasterAlertsEnabled: disasterAlertsEnabled,
        stats: stats.toJson(),
      );

      if (nextDisasterCycle != null && nextDisasterType != null) {
        final disasterTime = lastIncomeTime.add(
          Duration(days: nextDisasterCycle!),
        );
        NotificationService().scheduleDisasterNotification(
          playerName,
          disasterTime,
          nextDisasterType!,
          false,
        );
      }

      NotificationService().scheduleInactivityNotification(playerName);
      _updateDailyChallengeReminders();
    } finally {
      _isSaving = false;
    }
  }

  void _updateDailyChallengeReminders() {
    if (playerName == "User") return;

    NotificationService().scheduleDailyChallengeReminders(
      playerName: playerName,
      dailyQuizStreak: dailyQuizStreak,
      streakRevivals: streakRevivals,
      lastDailyQuizDate: lastDailyQuizDate,
    );
  }

  /// Saves only the specified fields to local storage (lightweight).
  Future<void> saveFields(Map<String, dynamic> fields) async {
    if (!loaded) return;
    final Map<String, dynamic> data = Map<String, dynamic>.from(fields);
    data[lastUpdatedKey] = DateTime.now().millisecondsSinceEpoch;
    await saveGameState(
      uid: FirebaseAuth.instance.currentUser?.uid,
      syncToCloud: false,
      partialData: data,
    );
  }

  void _checkDailyCycle() {
    final now = DateTime.now();
    final difference = now.difference(lastIncomeTime);

    const int cycleSeconds = 86400; // 24 hours
    if (difference.inSeconds >= cycleSeconds) {
      final cycles = difference.inSeconds ~/ cycleSeconds;
      _applyCycles(cycles);
    }
  }

  void _applyCycles(int cycles) {
    int totalKpChange = 0;
    int totalGemChange = 0;
    List<String> events = [];

    final streakRewards = getStreakRewards(dailyQuizStreak);

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

        passiveIncomeTotal +=
            (eligibleCount *
                    info.incomePerAsset *
                    multiplier *
                    streakRewards.passiveIncomeMultiplier)
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
        nextDisasterCycle = 15 + Random().nextInt(5);
        nextDisasterType =
            DisasterType.values[Random().nextInt(DisasterType.values.length)];
      } else {
        nextDisasterCycle = nextDisasterCycle! - 1;
        if (nextDisasterCycle! <= 0) {
          _triggerNaturalDisaster();
          nextDisasterCycle = 15 + Random().nextInt(5);
          nextDisasterType =
              DisasterType.values[Random().nextInt(DisasterType.values.length)];
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

        double rate = 0.0;
        int debtFactor = currentBalance.abs();
        if (debtFactor >= 5000) {
          rate = 0.20;
        } else if (debtFactor >= 2000) {
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
                NotificationService().showForeclosureNotification(
                  playerName,
                  removed.name,
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

    // --- Lifetime Stats Tracking ---
    if (cycles > 0) {
      // Gems earned from salary
      final int salaryEarned = dailyIncome(career.track, career.level) * cycles;
      stats.lifetimeGemsEarnedSalary += salaryEarned;

      // Gems earned from passive income (per cycle total)
      int passiveThisBatch = 0;
      activePassiveIncomes.forEach((assetType, investedCount) {
        final info = passiveIncomeData.values.firstWhere(
          (e) => e.assetType == assetType,
        );
        if (cityLayout.any((b) => b.name == info.buildingName)) {
          final ownedCount = assets.count(assetType);
          final eligibleCount = min(ownedCount, investedCount);
          final multiplier = getPassiveIncomeMultiplier(assetType);
          final streakRewards = getStreakRewards(dailyQuizStreak);
          passiveThisBatch += (eligibleCount * info.incomePerAsset * multiplier * streakRewards.passiveIncomeMultiplier).round() * cycles;
        }
      });
      stats.lifetimeGemsEarnedPassive += passiveThisBatch;
      stats.lifetimeGemsEarnedTotal = stats.lifetimeGemsEarnedSalary + stats.lifetimeGemsEarnedPassive;

      // Gems spent on living costs
      if (rentChoice != null) {
        final rc = getRentCost(career.track, career.level, rentChoice!) * cycles;
        stats.lifetimeGemsSpentTotal += rc;
        if (rentChoice == RentType.sharedStudio) {
          stats.lifetimeGemsSpentSharedStudio += rc;
        } else if (rentChoice == RentType.smallApartment) {
          stats.lifetimeGemsSpentSmallApartment += rc;
        } else if (rentChoice == RentType.luxuryHouse) {
          stats.lifetimeGemsSpentLuxuryHouse += rc;
        }
        stats.cyclesSpentSharedStudio += (rentChoice == RentType.sharedStudio) ? cycles : 0;
        stats.cyclesSpentSmallApartment += (rentChoice == RentType.smallApartment) ? cycles : 0;
        stats.cyclesSpentLuxuryHouse += (rentChoice == RentType.luxuryHouse) ? cycles : 0;
      }
      if (foodChoice != null) {
        final fc = getFoodCost(career.track, career.level, foodChoice!) * cycles;
        stats.lifetimeGemsSpentTotal += fc;
        if (foodChoice == FoodType.cheap) { stats.lifetimeGemsSpentCheapFood += fc; stats.cyclesSpentCheapFood += cycles; }
        else if (foodChoice == FoodType.balanced) { stats.lifetimeGemsSpentBalancedDiet += fc; stats.cyclesSpentBalancedDiet += cycles; }
        else if (foodChoice == FoodType.buffet) { stats.lifetimeGemsSpentBuffet += fc; stats.cyclesSpentBuffet += cycles; }
      }
      if (transportChoice != null) {
        final tc = getTransportCost(career.track, career.level, transportChoice!) * cycles;
        stats.lifetimeGemsSpentTotal += tc;
        if (transportChoice == TransportType.public) { stats.lifetimeGemsSpentPublicTransport += tc; stats.cyclesSpentPublicTransport += cycles; }
        else if (transportChoice == TransportType.cycle) { stats.lifetimeGemsSpentCycling += tc; stats.cyclesSpentCycling += cycles; }
        else if (transportChoice == TransportType.car) { stats.lifetimeGemsSpentCar += tc; stats.cyclesSpentCar += cycles; }
      }

      // Insurance costs
      if (insurances.isNotEmpty) {
        final insCost = insurances.length * 5 * cycles;
        stats.lifetimeGemsSpentInsurance += insCost;
        stats.totalPremiumsPaid += insCost;
        stats.totalCyclesInsured += cycles;
      } else {
        stats.currentUninsuredStreak += cycles;
        if (stats.currentUninsuredStreak > stats.longestGapUninsured) {
          stats.longestGapUninsured = stats.currentUninsuredStreak;
        }
      }

      // Debt tracking
      stats.totalDaysPlayed += cycles;
      if (gems < 0) {
        final wasAlreadyInDebt = stats.currentDebtStreak > 0;
        stats.totalCyclesSpentDebt += cycles;
        stats.currentDebtStreak += cycles;
        if (!wasAlreadyInDebt) stats.numberOfTimesDebtEntered++;
        if (stats.currentDebtStreak > stats.longestContinuousDebtStreak) {
          stats.longestContinuousDebtStreak = stats.currentDebtStreak;
        }
        if (gems.abs() > stats.maxDebtReached) stats.maxDebtReached = gems.abs();
      } else {
        stats.currentDebtStreak = 0;
      }

      // KP tracking
      if (totalKpChange > 0) {
        stats.lifetimeKpEarnedGross += totalKpChange;
      } else if (totalKpChange < 0) {
        stats.lifetimeKpLostGross += totalKpChange.abs();
      }
      if (kp > stats.highestKpReached) stats.highestKpReached = kp;
      if (kp < stats.lowestKpReached) stats.lowestKpReached = kp;

      // Peak gems
      if (gems > stats.peakGemsHeld) stats.peakGemsHeld = gems;

      // Per-cycle income/expenditure peaks
      final cycleIncome = totalGemChange > 0 ? totalGemChange : 0;
      if (cycleIncome > stats.highestSingleCycleIncome) stats.highestSingleCycleIncome = cycleIncome;
      final cycleExp = totalGemChange < 0 ? totalGemChange.abs() : 0;
      if (cycleExp > stats.highestSingleCycleExpenditure) stats.highestSingleCycleExpenditure = cycleExp;

      // Disaster-free streak
      stats.currentDisasterFreeStreak += cycles;
      if (stats.currentDisasterFreeStreak > stats.longestDisasterFreeStretch) {
        stats.longestDisasterFreeStretch = stats.currentDisasterFreeStreak;
      }
    }
    // --- End Stats Tracking ---

    notifyListeners();
    save();

    // Trigger debt notification if in debt after cycles
    if (gems < 0 && cycles > 0) {
      NotificationService().showDebtNotification(playerName);
    }
  }

  void clearEvents() {
    pendingEvents.clear();
    notifyListeners();
  }

  void toggleTheme(bool val) {
    isDarkMode = val;
    saveFields({isDarkModeKey: isDarkMode});
    notifyListeners();
  }

  void updateMusicVolume(double val, {bool saveToDisk = true}) {
    musicVolume = val;
    if (saveToDisk) saveFields({musicVolumeKey: musicVolume});
    notifyListeners();
  }

  void updateSfxVolume(double val, {bool saveToDisk = true}) {
    sfxVolume = val;
    if (saveToDisk) saveFields({sfxVolumeKey: sfxVolume});
    notifyListeners();
  }

  void setPlayerName(String name) {
    playerName = name.trim();

    // Add welcome message to events
    pendingEvents.add(
      "Welcome, $playerName! \n\n"
      "Welcome to City of Wealth! I hope this game helps you master your personal finance journey. "
      "Make smart financial choices, build your city, and have fun!\n\n"
      "- The Maker",
    );

    // Trigger cycles now that the player has entered their name
    _checkDailyCycle();
    _checkStreakConsistency();
    _syncDailyQuiz(); // Check for new quiz on load
    NotificationService().scheduleDailyNotifications(playerName);
    NotificationService().scheduleDailyMorningNotification(
      playerName,
      wakeUpHour,
      wakeUpMinute,
    );
    _updateDailyChallengeReminders();
    save();
    notifyListeners();
  }

  void updatePlayerName(String name) {
    if (name.trim().isEmpty) return;
    playerName = name.trim();
    saveFields({playerNameKey: playerName});

    // Reschedule notifications with the new name
    NotificationService().scheduleDailyNotifications(playerName);
    NotificationService().scheduleDailyMorningNotification(
      playerName,
      wakeUpHour,
      wakeUpMinute,
    );
    NotificationService().scheduleInactivityNotification(playerName);
    _updateDailyChallengeReminders();

    notifyListeners();
  }

  void placeBuilding(PlacedBuilding building) {
    cityLayout.add(building);
    saveFields({
      cityLayoutKey: jsonEncode(cityLayout.map((b) => b.toJson()).toList()),
    });
    notifyListeners();
  }

  void removeBuilding(PlacedBuilding building) {
    cityLayout.removeWhere((b) => b.x == building.x && b.y == building.y);
    saveFields({
      cityLayoutKey: jsonEncode(cityLayout.map((b) => b.toJson()).toList()),
    });
    notifyListeners();
  }

  void buyWall() {
    hasWall = true;
    saveFields({'hasWall': hasWall});
    notifyListeners();
  }

  void updateKp(int delta) {
    kp += delta;
    saveFields({kpKey: kp});
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
    saveFields({
      insurancesKey: insurances.map((e) => e.name).toList(),
      kpKey: kp,
    });
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
          "$playerName, over-purchasing ${assetLabel(type)} for your level is a bad decision: -100 [KP]";
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

    // Stats tracking for asset purchases
    stats.lifetimeGemsSpentTotal += cost;
    switch (type) {
      case AssetType.land:
        {
          stats.lifetimeGemsSpentLand += cost;
          stats.totalLandPurchased += amount;
          final pk = assets.count(AssetType.land);
          if (pk > stats.peakLandHeld) stats.peakLandHeld = pk;
        }
        break;
      case AssetType.properties:
        {
          stats.lifetimeGemsSpentProperties += cost;
          stats.totalPropertiesPurchased += amount;
          final pk = assets.count(AssetType.properties);
          if (pk > stats.peakPropertiesHeld) stats.peakPropertiesHeld = pk;
        }
        break;
      case AssetType.vehicles:
        {
          stats.lifetimeGemsSpentVehicles += cost;
          stats.totalVehiclesPurchased += amount;
          final pk = assets.count(AssetType.vehicles);
          if (pk > stats.peakVehiclesHeld) stats.peakVehiclesHeld = pk;
        }
        break;
      case AssetType.officeEquipment:
        {
          stats.lifetimeGemsSpentOfficeEquipment += cost;
          stats.totalOfficeEquipmentPurchased += amount;
          final pk = assets.count(AssetType.officeEquipment);
          if (pk > stats.peakOfficeEquipmentHeld) stats.peakOfficeEquipmentHeld = pk;
        }
        break;
      case AssetType.machinery:
        {
          stats.lifetimeGemsSpentMachinery += cost;
          stats.totalMachineryPurchased += amount;
          final pk = assets.count(AssetType.machinery);
          if (pk > stats.peakMachineryHeld) stats.peakMachineryHeld = pk;
        }
        break;
    }

    saveFields({
      gemsKey: gems,
      assetsKey: jsonEncode(assets.toJson()),
      kpKey: kp,
    });
    notifyListeners();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Asset Purchased, $playerName"),
        content: IconText(message),
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
    saveFields({gemsKey: gems, assetsKey: jsonEncode(assets.toJson())});
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
    dailyQuizStreak = 0;
    lastDailyQuizDate = "";

    save();
    notifyListeners();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Bankruptcy Declared, $playerName"),
        content: Text(
          "$playerName, all your assets were auctioned off and your debt was waived. "
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

  void addKp(int delta) {
    kp += delta;
    if (kp < 0) kp = 0;
    save();
    notifyListeners();
  }

  void markQuizCompleted(String quizId) {
    completedQuizzes.add(quizId);
    saveFields({completedQuizzesKey: completedQuizzes.toList()});
    notifyListeners();
  }

  void completeDailyQuiz(
    bool correct,
    String date,
    String? quizHash, {
    bool isPractice = false,
  }) {
    // If it's a daily quiz (not practice) and not already done today
    if (!isPractice && lastDailyQuizDate != date) {
      // Streak always increments when the daily quiz is attempted
      dailyQuizStreak++;
      stats.dailyQuizAttempted++;
      if (dailyQuizStreak % 10 == 0 && streakRevivals < 5) {
        streakRevivals++;
        stats.totalRevivalsEarned++;
      }
      if (dailyQuizStreak > stats.dailyQuizLongestStreak) stats.dailyQuizLongestStreak = dailyQuizStreak;
      if (dailyQuizStreak >= 10) stats.timesStreak10Reached++;
      if (dailyQuizStreak >= 30) stats.timesStreak30Reached++;
      if (dailyQuizStreak >= 100) stats.timesStreak100Reached++;

      if (correct) {
        kp += 20; // 20 KP for correct daily
        stats.dailyQuizCorrect++;
        stats.totalKpEarnedDailyQuiz += 20;
        stats.totalKpEarnedQuizzes += 20;
        stats.lifetimeKpEarnedGross += 20;
        if (quizHash != null) solvedQuizHashes.add(quizHash);
      }

      lastDailyQuizDate = date;

      if (_currentUid != null) {
        firestoreService.updatePlayerStreak(
          _currentUid!,
          dailyQuizStreak,
          date,
          streakRevivals,
          lastRevivalDate,
        );
      }
    } else if (isPractice && correct) {
      kp += 10; // 10 KP for correct practice
      stats.quizzesReplayed++;
      stats.totalKpEarnedReplays += 10;
      stats.totalKpEarnedQuizzes += 10;
      stats.lifetimeKpEarnedGross += 10;
      if (quizHash != null) solvedQuizHashes.add(quizHash);
    }

    save();
    notifyListeners();
  }

  void investInPassiveIncome(AssetType assetType) {
    final info = passiveIncomeData.values.firstWhere(
      (e) => e.assetType == assetType,
    );

    final currentInvested = activePassiveIncomes[assetType] ?? 0;
    final ownedCount = assets.count(assetType);

    if (currentInvested < ownedCount) {
      gems -= info.investmentCost;
      activePassiveIncomes[assetType] = currentInvested + 1;
      saveFields({
        gemsKey: gems,
        activePassiveIncomesKey: jsonEncode(
          activePassiveIncomes.map((k, v) => MapEntry(k.name, v)),
        ),
      });
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
    final rewards = getStreakRewards(dailyQuizStreak);
    multiplier *= rewards.passiveIncomeMultiplier;
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

    // Skip KP deduction only for students
    if (career.track != CareerTrack.student) {
      kp -= penalty;
      if (kp < 0) kp = 0;
      stats.totalKpLostOvertime += penalty;
      stats.totalKpLostOvertimePenalties += penalty;
      if (overtimeStreak > 10) stats.timesBurnoutPenaltyTriggered++;
    }

    stats.totalCyclesOvertime++;
    if (overtimeStreak > stats.longestOvertimeStreak) stats.longestOvertimeStreak = overtimeStreak;

    isWorkingOvertime = true;

    saveFields({
      kpKey: kp,
      isWorkingOvertimeKey: isWorkingOvertime,
      overtimeStreakKey: overtimeStreak,
    });
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
    final disasterType =
        nextDisasterType ?? allDisasters[rng.nextInt(allDisasters.length)];

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
      const duration = 20;
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

    // --- Disaster Stats Tracking ---
    stats.totalDisasters++;
    stats.currentDisasterFreeStreak = 0;
    switch (disasterType) {
      case DisasterType.flood: stats.numberOfFloods++; stats.landLostFlood += lostAssets[AssetType.land] ?? 0; break;
      case DisasterType.fire: stats.numberOfFires++; stats.propertiesVehiclesLostFire += (lostAssets[AssetType.properties] ?? 0) + (lostAssets[AssetType.vehicles] ?? 0); break;
      case DisasterType.earthquake: stats.numberOfEarthquakes++; stats.officeEquipMachineryLostEarthquake += (lostAssets[AssetType.officeEquipment] ?? 0) + (lostAssets[AssetType.machinery] ?? 0); break;
      case DisasterType.drought: stats.numberOfDroughts++; break;
      case DisasterType.landslide: stats.numberOfLandslides++; break;
      case DisasterType.economyCrash: stats.numberOfEconomyCrashes++; break;
      case DisasterType.massEmigration: stats.numberOfMassEmigrations++; break;
      case DisasterType.pandemic: stats.numberOfPandemics++; break;
    }
    if (hasAnyInsurance) {
      stats.disastersSurvivedInsured++;
    } else {
      stats.disastersSurvivedUninsured++;
    }
    if (lostAssets.isEmpty && deactivatedPassiveIncomes.isEmpty) stats.disastersZeroLoss++;
    // --- End Disaster Stats ---

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
    saveFields({'pendingDisasterResults': jsonEncode([])});
    notifyListeners();
  }

  Future<void> _syncDailyQuiz() async {
    try {
      final now = DateTime.now().toUtc().add(
        const Duration(hours: 5, minutes: 30),
      );
      final dateStr = DateFormat('yyyy-MM-dd').format(now);

      final quiz = await firestoreService.getDailyQuiz(dateStr);
      if (quiz != null) {
        debugPrint(
          "📅 Daily Quiz Sync (Load): Newest quiz for $dateStr is available.",
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint("❌ Daily Quiz Sync (Load) Error: $e");
    }
  }

  void _checkStreakConsistency() {
    if (lastDailyQuizDate.isEmpty) return;

    final now = DateTime.now().toUtc().add(
      const Duration(hours: 5, minutes: 30),
    );
    final today = DateFormat('yyyy-MM-dd').format(now);

    if (lastDailyQuizDate == today) return;

    try {
      DateTime lastDate = DateFormat('yyyy-MM-dd').parse(lastDailyQuizDate);
      DateTime todayDate = DateFormat('yyyy-MM-dd').parse(today);

      int daysDifference = todayDate.difference(lastDate).inDays;

      if (daysDifference > 1) {
        // User missed one or more days
        if (dailyQuizStreak > 0) {
          int daysToRevive = daysDifference - 1;

          while (daysToRevive > 0) {
            if (streakRevivals > 0) {
              streakRevivals--;
              daysToRevive--;
              lastRevivalDate = today; // Track when we last used revivals
            } else {
              // No more revivals
              dailyQuizStreak = 0;
              break;
            }
          }
        }

        // Update lastDailyQuizDate to yesterday so they can still play today
        if (dailyQuizStreak > 0) {
          final yesterday = todayDate.subtract(const Duration(days: 1));
          lastDailyQuizDate = DateFormat('yyyy-MM-dd').format(yesterday);
          debugPrint(
            "🛡️ Streak preserved using revivals. Remaining: $streakRevivals",
          );
        } else {
          final yesterday = todayDate.subtract(const Duration(days: 1));
          lastDailyQuizDate = DateFormat('yyyy-MM-dd').format(yesterday);
          debugPrint("💔 Streak reset due to inactivity.");
        }

        save();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("❌ Error in _checkStreakConsistency: $e");
    }
  }

  void completeOnboarding({
    required String name,
    required int hour,
    required int minute,
    required bool alertsEnabled,
  }) {
    wakeUpHour = hour;
    wakeUpMinute = minute;
    disasterAlertsEnabled = alertsEnabled;
    onboardingComplete = true;

    if (!tutorialComplete) {
      isTutorialActive = true;
    }

    // Call unified setPlayerName which handles event log additions, cycles, notifications, and saving
    setPlayerName(name);
  }

  Future<void> completeTutorial() async {
    tutorialComplete = true;
    isTutorialActive = false;
    final prefs = await SharedPreferences.getInstance();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await prefs.setBool(
      uid != null ? "${uid}_tutorialComplete" : 'tutorialComplete',
      true,
    );
    notifyListeners();
  }

  Future<void> restartTutorial() async {
    tutorialComplete = false;
    isTutorialActive = true;
    selectedIndex = 0; // Go back to Home tab where tutorial starts
    final prefs = await SharedPreferences.getInstance();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await prefs.setBool(
      uid != null ? "${uid}_tutorialComplete" : 'tutorialComplete',
      false,
    );
    notifyListeners();
  }

  void updateWakeUpTime(int hour, int minute) {
    wakeUpHour = hour;
    wakeUpMinute = minute;
    saveFields({wakeUpHourKey: wakeUpHour, wakeUpMinuteKey: wakeUpMinute});
    NotificationService().scheduleDailyMorningNotification(
      playerName,
      hour,
      minute,
    );
    notifyListeners();
  }

  void visitMoneyTile(String title) {
    recentVisitedMoneyTiles.remove(title);
    recentVisitedMoneyTiles.insert(0, title);
    if (recentVisitedMoneyTiles.length > 2) {
      recentVisitedMoneyTiles.removeLast();
    }
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final key = uid != null ? "${uid}_recent_money_tiles" : "recent_money_tiles";
      prefs.setStringList(key, recentVisitedMoneyTiles);
    });
  }
}
