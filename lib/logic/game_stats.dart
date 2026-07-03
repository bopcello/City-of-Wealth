class GameStats {
  // Gems - Economy (30 stats)
  int lifetimeGemsEarnedSalary = 0;
  int lifetimeGemsEarnedPassive = 0;
  int lifetimeGemsEarnedTotal = 0;
  int lifetimeGemsSpentTotal = 0;
  int lifetimeGemsSpentLand = 0;
  int lifetimeGemsSpentProperties = 0;
  int lifetimeGemsSpentVehicles = 0;
  int lifetimeGemsSpentOfficeEquipment = 0;
  int lifetimeGemsSpentMachinery = 0;
  int lifetimeGemsSpentInsurance = 0;
  int lifetimeGemsSpentSharedStudio = 0;
  int lifetimeGemsSpentSmallApartment = 0;
  int lifetimeGemsSpentLuxuryHouse = 0;
  int lifetimeGemsSpentBalancedDiet = 0;
  int lifetimeGemsSpentCheapFood = 0;
  int lifetimeGemsSpentBuffet = 0;
  int lifetimeGemsSpentPublicTransport = 0;
  int lifetimeGemsSpentCycling = 0;
  int lifetimeGemsSpentCar = 0;
  int lifetimeInterestPaidDebt = 0;
  int lifetimeInsurancePayoutsReceived = 0;
  int netGemsLostDisasters = 0;
  int peakGemsHeld = 0;
  int maxDebtReached = 0;
  int cyclesDebtInterest5 = 0;
  int cyclesDebtInterest10 = 0;
  int cyclesDebtInterest20 = 0;
  int highestSingleCycleIncome = 0;
  int highestSingleCycleExpenditure = 0;
  double averageDailyNetCashFlow = 0.0;

  // KP - Financial Wisdom (18 stats)
  int lifetimeKpEarnedGross = 0;
  int lifetimeKpLostGross = 0;
  int highestKpReached = 0;
  int lowestKpReached = 0;
  int totalKpLostDebt = 0;
  int totalKpLostWaste = 0;
  int totalKpLostOvertime = 0;
  int totalKpGainedInsurance = 0;
  int totalKpGainedQuizzes = 0;
  int totalKpGainedHousing = 0;
  int totalKpLostHousing = 0;
  int totalKpGainedFood = 0;
  int totalKpLostFood = 0;
  int totalKpGainedTransport = 0;
  int totalKpLostTransport = 0;
  int biggestSingleKpGain = 0;
  int biggestSingleKpLoss = 0;
  int wastePenaltyTriggeredCount = 0;

  // Career & Progression (5 stats)
  String currentTrackLevelTitle = "None";
  Map<String, int> daysSpentAtEachLevel = {};
  int totalDaysPlayed = 0;
  Map<String, int> fastestTimeToLevel = {};
  List<String> titleHistory = ["Student"];
  Map<String, int> currentTrackDaysSpent = {};

  // Assets & Buildings (30 stats)
  int totalBuildingsConstructed = 0;
  int buildingsCurrentlyStanding = 0;
  int officeDesksBuilt = 0;
  int coffeeStandsBuilt = 0;
  int teamOfficesBuilt = 0;
  int logisticsGaragesBuilt = 0;
  int departmentOfficesBuilt = 0;
  int conferenceCentersBuilt = 0;
  int companyHqBuilt = 0;
  int boardroomPavilionsBuilt = 0;
  int ideaHubsBuilt = 0;
  int workshopsBuilt = 0;
  int storageUnitsBuilt = 0;
  int officeBuildingsBuilt = 0;
  int analyticsCentersBuilt = 0;
  int rdCentersBuilt = 0;
  int globalOperationsBuilt = 0;
  int totalLandPurchased = 0;
  int totalPropertiesPurchased = 0;
  int totalVehiclesPurchased = 0;
  int totalOfficeEquipmentPurchased = 0;
  int totalMachineryPurchased = 0;
  int peakLandHeld = 0;
  int peakPropertiesHeld = 0;
  int peakVehiclesHeld = 0;
  int peakOfficeEquipmentHeld = 0;
  int peakMachineryHeld = 0;
  int buildingsLostForeclosure = 0;
  int totalBuildingRearrangements = 0;
  int demolitionSessionsCount = 0;

  // Passive Income (24 stats)
  int passiveIncomeFarmsEarned = 0;
  int passiveIncomeFactoriesEarned = 0;
  int passiveIncomeApartmentsEarned = 0;
  int passiveIncomeDistCentersEarned = 0;
  int passiveIncomeItServiceEarned = 0;
  int farmsBuilt = 0;
  int factoriesBuilt = 0;
  int apartmentsBuilt = 0;
  int distCentersBuilt = 0;
  int itServiceCentersBuilt = 0;
  int farmsLostDisaster = 0;
  int factoriesLostDisaster = 0;
  int apartmentsLostDisaster = 0;
  int distCentersLostDisaster = 0;
  int itServiceCentersLostDisaster = 0;
  int farmsSetupCostsPaid = 0;
  int factoriesSetupCostsPaid = 0;
  int apartmentsSetupCostsPaid = 0;
  int distCentersSetupCostsPaid = 0;
  int itServiceCentersSetupCostsPaid = 0;
  int highestSingleCyclePassiveIncome = 0;
  int passiveIncomeDestroyedReinvested = 0;
  double ratioPassiveToSalary = 0.0;
  int activePassiveIncomeTypesCount = 0;

  // Debt & Bankruptcy (9 stats)
  int totalCyclesSpentDebt = 0;
  int longestContinuousDebtStreak = 0;
  int currentDebtStreak = 0;
  int numberOfTimesDebtEntered = 0;
  int bankruptciesDeclared = 0;
  int totalAssetValueLostBankruptcy = 0;
  int closestCallForeclosure = 30;

  // Daily Living Choices (18 stats)
  int cyclesSpentSharedStudio = 0;
  int cyclesSpentSmallApartment = 0;
  int cyclesSpentLuxuryHouse = 0;
  int cyclesSpentBalancedDiet = 0;
  int cyclesSpentCheapFood = 0;
  int cyclesSpentBuffet = 0;
  int cyclesSpentPublicTransport = 0;
  int cyclesSpentCycling = 0;
  int cyclesSpentCar = 0;
  int kpGainedBalancedDiet = 0;
  int kpLostCheapFood = 0;
  int kpLostBuffet = 0;
  int kpLostCyclingTimeCost = 0;
  int luxuryHousePenaltyTriggered = 0;
  int gemsSpentCheapFood = 0;
  int gemsSpentBuffet = 0;
  int longestBalancedDietStreak = 0;
  int currentBalancedDietStreak = 0;
  int longestPublicTransportStreak = 0;
  int currentPublicTransportStreak = 0;

  // Insurance (7 stats)
  int totalCyclesInsured = 0;
  int totalPremiumsPaid = 0;
  int disastersSurvivedInsured = 0;
  int disastersSurvivedUninsured = 0;
  int longestGapUninsured = 0;
  int currentUninsuredStreak = 0;

  // Disasters (20 stats)
  int totalDisasters = 0;
  int numberOfFloods = 0;
  int numberOfFires = 0;
  int numberOfEarthquakes = 0;
  int numberOfDroughts = 0;
  int numberOfLandslides = 0;
  int numberOfEconomyCrashes = 0;
  int numberOfMassEmigrations = 0;
  int numberOfPandemics = 0;
  int landLostFlood = 0;
  int propertiesVehiclesLostFire = 0;
  int officeEquipMachineryLostEarthquake = 0;
  int farmsDestroyedDrought = 0;
  int distCentersDestroyedLandslide = 0;
  int factoriesDestroyedEconomyCrash = 0;
  int apartmentsDestroyedMassEmigration = 0;
  int itServiceCentersDestroyedPandemic = 0;
  int incomeReductionDisasters = 0;
  int longestDisasterFreeStretch = 0;
  int currentDisasterFreeStreak = 0;
  int disastersZeroLoss = 0;

  // Quiz Performance (22 stats)
  int totalQuizzesAttempted = 0;
  int correctEasyAnswers = 0;
  int wrongEasyAnswers = 0;
  int correctMediumAnswers = 0;
  int wrongMediumAnswers = 0;
  int correctHardAnswers = 0;
  int wrongHardAnswers = 0;
  double accuracyRateOverall = 0.0;
  double accuracyRateEasy = 0.0;
  double accuracyRateMedium = 0.0;
  double accuracyRateHard = 0.0;
  int totalKpEarnedQuizzes = 0;
  int totalKpLostWrongQuiz = 0;
  int quizzesReplayed = 0;
  int totalKpEarnedReplays = 0;
  int longestCorrectStreakQuizzes = 0;
  int dailyQuizAttempted = 0;
  int dailyQuizCorrect = 0;
  int dailyQuizLongestStreak = 0;
  int pastDailyQuizzesAttemptedRetroactive = 0;
  int totalKpEarnedDailyQuiz = 0;

  // Streaks & Revivals (10 stats)
  int totalRevivalsEarned = 3;
  int totalRevivalsUsed = 0;
  int streakResetToZero = 0;
  int timesStreak10Reached = 0;
  int timesStreak30Reached = 0;
  int timesStreak100Reached = 0;
  int gemsSavedStreakDiscounts = 0;
  int extraPassiveIncomeStreakBoosts = 0;

  // Overtime (4 stats)
  int totalCyclesOvertime = 0;
  int longestOvertimeStreak = 0;
  int totalKpLostOvertimePenalties = 0;
  int timesBurnoutPenaltyTriggered = 0;

  // Time & Engagement (10 stats)
  int totalTimeSpentApp = 0;
  int timeSpentCityTab = 0;
  int timeSpentQuizTab = 0;
  int timeSpentFriendsTab = 0;
  int timeSpentStatsTab = 0;
  int timeSpentSettingsTab = 0;
  int totalAppSessions = 0;
  double averageSessionLength = 0.0;
  String? firstPlayedTimestamp;
  int statsScreenOpenedCount = 0;

  // Helper maps (not shared stats directly but used to drive logic)
  Map<String, bool> passiveIncomeDestroyedMap = {};

  GameStats();

  Map<String, dynamic> toJson() {
    return {
      'lifetimeGemsEarnedSalary': lifetimeGemsEarnedSalary,
      'lifetimeGemsEarnedPassive': lifetimeGemsEarnedPassive,
      'lifetimeGemsEarnedTotal': lifetimeGemsEarnedTotal,
      'lifetimeGemsSpentTotal': lifetimeGemsSpentTotal,
      'lifetimeGemsSpentLand': lifetimeGemsSpentLand,
      'lifetimeGemsSpentProperties': lifetimeGemsSpentProperties,
      'lifetimeGemsSpentVehicles': lifetimeGemsSpentVehicles,
      'lifetimeGemsSpentOfficeEquipment': lifetimeGemsSpentOfficeEquipment,
      'lifetimeGemsSpentMachinery': lifetimeGemsSpentMachinery,
      'lifetimeGemsSpentInsurance': lifetimeGemsSpentInsurance,
      'lifetimeGemsSpentSharedStudio': lifetimeGemsSpentSharedStudio,
      'lifetimeGemsSpentSmallApartment': lifetimeGemsSpentSmallApartment,
      'lifetimeGemsSpentLuxuryHouse': lifetimeGemsSpentLuxuryHouse,
      'lifetimeGemsSpentBalancedDiet': lifetimeGemsSpentBalancedDiet,
      'lifetimeGemsSpentCheapFood': lifetimeGemsSpentCheapFood,
      'lifetimeGemsSpentBuffet': lifetimeGemsSpentBuffet,
      'lifetimeGemsSpentPublicTransport': lifetimeGemsSpentPublicTransport,
      'lifetimeGemsSpentCycling': lifetimeGemsSpentCycling,
      'lifetimeGemsSpentCar': lifetimeGemsSpentCar,
      'lifetimeInterestPaidDebt': lifetimeInterestPaidDebt,
      'lifetimeInsurancePayoutsReceived': lifetimeInsurancePayoutsReceived,
      'netGemsLostDisasters': netGemsLostDisasters,
      'peakGemsHeld': peakGemsHeld,
      'maxDebtReached': maxDebtReached,
      'cyclesDebtInterest5': cyclesDebtInterest5,
      'cyclesDebtInterest10': cyclesDebtInterest10,
      'cyclesDebtInterest20': cyclesDebtInterest20,
      'highestSingleCycleIncome': highestSingleCycleIncome,
      'highestSingleCycleExpenditure': highestSingleCycleExpenditure,
      'averageDailyNetCashFlow': averageDailyNetCashFlow,

      'lifetimeKpEarnedGross': lifetimeKpEarnedGross,
      'lifetimeKpLostGross': lifetimeKpLostGross,
      'highestKpReached': highestKpReached,
      'lowestKpReached': lowestKpReached,
      'totalKpLostDebt': totalKpLostDebt,
      'totalKpLostWaste': totalKpLostWaste,
      'totalKpLostOvertime': totalKpLostOvertime,
      'totalKpGainedInsurance': totalKpGainedInsurance,
      'totalKpGainedQuizzes': totalKpGainedQuizzes,
      'totalKpGainedHousing': totalKpGainedHousing,
      'totalKpLostHousing': totalKpLostHousing,
      'totalKpGainedFood': totalKpGainedFood,
      'totalKpLostFood': totalKpLostFood,
      'totalKpGainedTransport': totalKpGainedTransport,
      'totalKpLostTransport': totalKpLostTransport,
      'biggestSingleKpGain': biggestSingleKpGain,
      'biggestSingleKpLoss': biggestSingleKpLoss,
      'wastePenaltyTriggeredCount': wastePenaltyTriggeredCount,

      'currentTrackLevelTitle': currentTrackLevelTitle,
      'daysSpentAtEachLevel': daysSpentAtEachLevel,
      'totalDaysPlayed': totalDaysPlayed,
      'fastestTimeToLevel': fastestTimeToLevel,
      'titleHistory': titleHistory,
      'currentTrackDaysSpent': currentTrackDaysSpent,

      'totalBuildingsConstructed': totalBuildingsConstructed,
      'buildingsCurrentlyStanding': buildingsCurrentlyStanding,
      'officeDesksBuilt': officeDesksBuilt,
      'coffeeStandsBuilt': coffeeStandsBuilt,
      'teamOfficesBuilt': teamOfficesBuilt,
      'logisticsGaragesBuilt': logisticsGaragesBuilt,
      'departmentOfficesBuilt': departmentOfficesBuilt,
      'conferenceCentersBuilt': conferenceCentersBuilt,
      'companyHqBuilt': companyHqBuilt,
      'boardroomPavilionsBuilt': boardroomPavilionsBuilt,
      'ideaHubsBuilt': ideaHubsBuilt,
      'workshopsBuilt': workshopsBuilt,
      'storageUnitsBuilt': storageUnitsBuilt,
      'officeBuildingsBuilt': officeBuildingsBuilt,
      'analyticsCentersBuilt': analyticsCentersBuilt,
      'rdCentersBuilt': rdCentersBuilt,
      'globalOperationsBuilt': globalOperationsBuilt,
      'totalLandPurchased': totalLandPurchased,
      'totalPropertiesPurchased': totalPropertiesPurchased,
      'totalVehiclesPurchased': totalVehiclesPurchased,
      'totalOfficeEquipmentPurchased': totalOfficeEquipmentPurchased,
      'totalMachineryPurchased': totalMachineryPurchased,
      'peakLandHeld': peakLandHeld,
      'peakPropertiesHeld': peakPropertiesHeld,
      'peakVehiclesHeld': peakVehiclesHeld,
      'peakOfficeEquipmentHeld': peakOfficeEquipmentHeld,
      'peakMachineryHeld': peakMachineryHeld,
      'buildingsLostForeclosure': buildingsLostForeclosure,
      'totalBuildingRearrangements': totalBuildingRearrangements,
      'demolitionSessionsCount': demolitionSessionsCount,

      'passiveIncomeFarmsEarned': passiveIncomeFarmsEarned,
      'passiveIncomeFactoriesEarned': passiveIncomeFactoriesEarned,
      'passiveIncomeApartmentsEarned': passiveIncomeApartmentsEarned,
      'passiveIncomeDistCentersEarned': passiveIncomeDistCentersEarned,
      'passiveIncomeItServiceEarned': passiveIncomeItServiceEarned,
      'farmsBuilt': farmsBuilt,
      'factoriesBuilt': factoriesBuilt,
      'apartmentsBuilt': apartmentsBuilt,
      'distCentersBuilt': distCentersBuilt,
      'itServiceCentersBuilt': itServiceCentersBuilt,
      'farmsLostDisaster': farmsLostDisaster,
      'factoriesLostDisaster': factoriesLostDisaster,
      'apartmentsLostDisaster': apartmentsLostDisaster,
      'distCentersLostDisaster': distCentersLostDisaster,
      'itServiceCentersLostDisaster': itServiceCentersLostDisaster,
      'farmsSetupCostsPaid': farmsSetupCostsPaid,
      'factoriesSetupCostsPaid': factoriesSetupCostsPaid,
      'apartmentsSetupCostsPaid': apartmentsSetupCostsPaid,
      'distCentersSetupCostsPaid': distCentersSetupCostsPaid,
      'itServiceCentersSetupCostsPaid': itServiceCentersSetupCostsPaid,
      'highestSingleCyclePassiveIncome': highestSingleCyclePassiveIncome,
      'passiveIncomeDestroyedReinvested': passiveIncomeDestroyedReinvested,
      'ratioPassiveToSalary': ratioPassiveToSalary,
      'activePassiveIncomeTypesCount': activePassiveIncomeTypesCount,

      'totalCyclesSpentDebt': totalCyclesSpentDebt,
      'longestContinuousDebtStreak': longestContinuousDebtStreak,
      'currentDebtStreak': currentDebtStreak,
      'numberOfTimesDebtEntered': numberOfTimesDebtEntered,
      'bankruptciesDeclared': bankruptciesDeclared,
      'totalAssetValueLostBankruptcy': totalAssetValueLostBankruptcy,
      'closestCallForeclosure': closestCallForeclosure,

      'cyclesSpentSharedStudio': cyclesSpentSharedStudio,
      'cyclesSpentSmallApartment': cyclesSpentSmallApartment,
      'cyclesSpentLuxuryHouse': cyclesSpentLuxuryHouse,
      'cyclesSpentBalancedDiet': cyclesSpentBalancedDiet,
      'cyclesSpentCheapFood': cyclesSpentCheapFood,
      'cyclesSpentBuffet': cyclesSpentBuffet,
      'cyclesSpentPublicTransport': cyclesSpentPublicTransport,
      'cyclesSpentCycling': cyclesSpentCycling,
      'cyclesSpentCar': cyclesSpentCar,
      'kpGainedBalancedDiet': kpGainedBalancedDiet,
      'kpLostCheapFood': kpLostCheapFood,
      'kpLostBuffet': kpLostBuffet,
      'kpLostCyclingTimeCost': kpLostCyclingTimeCost,
      'luxuryHousePenaltyTriggered': luxuryHousePenaltyTriggered,
      'gemsSpentCheapFood': gemsSpentCheapFood,
      'gemsSpentBuffet': gemsSpentBuffet,
      'longestBalancedDietStreak': longestBalancedDietStreak,
      'currentBalancedDietStreak': currentBalancedDietStreak,
      'longestPublicTransportStreak': longestPublicTransportStreak,
      'currentPublicTransportStreak': currentPublicTransportStreak,

      'totalCyclesInsured': totalCyclesInsured,
      'totalPremiumsPaid': totalPremiumsPaid,
      'disastersSurvivedInsured': disastersSurvivedInsured,
      'disastersSurvivedUninsured': disastersSurvivedUninsured,
      'longestGapUninsured': longestGapUninsured,
      'currentUninsuredStreak': currentUninsuredStreak,

      'totalDisasters': totalDisasters,
      'numberOfFloods': numberOfFloods,
      'numberOfFires': numberOfFires,
      'numberOfEarthquakes': numberOfEarthquakes,
      'numberOfDroughts': numberOfDroughts,
      'numberOfLandslides': numberOfLandslides,
      'numberOfEconomyCrashes': numberOfEconomyCrashes,
      'numberOfMassEmigrations': numberOfMassEmigrations,
      'numberOfPandemics': numberOfPandemics,
      'landLostFlood': landLostFlood,
      'propertiesVehiclesLostFire': propertiesVehiclesLostFire,
      'officeEquipMachineryLostEarthquake': officeEquipMachineryLostEarthquake,
      'farmsDestroyedDrought': farmsDestroyedDrought,
      'distCentersDestroyedLandslide': distCentersDestroyedLandslide,
      'factoriesDestroyedEconomyCrash': factoriesDestroyedEconomyCrash,
      'apartmentsDestroyedMassEmigration': apartmentsDestroyedMassEmigration,
      'itServiceCentersDestroyedPandemic': itServiceCentersDestroyedPandemic,
      'incomeReductionDisasters': incomeReductionDisasters,
      'longestDisasterFreeStretch': longestDisasterFreeStretch,
      'currentDisasterFreeStreak': currentDisasterFreeStreak,
      'disastersZeroLoss': disastersZeroLoss,

      'totalQuizzesAttempted': totalQuizzesAttempted,
      'correctEasyAnswers': correctEasyAnswers,
      'wrongEasyAnswers': wrongEasyAnswers,
      'correctMediumAnswers': correctMediumAnswers,
      'wrongMediumAnswers': wrongMediumAnswers,
      'correctHardAnswers': correctHardAnswers,
      'wrongHardAnswers': wrongHardAnswers,
      'accuracyRateOverall': accuracyRateOverall,
      'accuracyRateEasy': accuracyRateEasy,
      'accuracyRateMedium': accuracyRateMedium,
      'accuracyRateHard': accuracyRateHard,
      'totalKpEarnedQuizzes': totalKpEarnedQuizzes,
      'totalKpLostWrongQuiz': totalKpLostWrongQuiz,
      'quizzesReplayed': quizzesReplayed,
      'totalKpEarnedReplays': totalKpEarnedReplays,
      'longestCorrectStreakQuizzes': longestCorrectStreakQuizzes,
      'dailyQuizAttempted': dailyQuizAttempted,
      'dailyQuizCorrect': dailyQuizCorrect,
      'dailyQuizLongestStreak': dailyQuizLongestStreak,
      'pastDailyQuizzesAttemptedRetroactive': pastDailyQuizzesAttemptedRetroactive,
      'totalKpEarnedDailyQuiz': totalKpEarnedDailyQuiz,

      'totalRevivalsEarned': totalRevivalsEarned,
      'totalRevivalsUsed': totalRevivalsUsed,
      'streakResetToZero': streakResetToZero,
      'timesStreak10Reached': timesStreak10Reached,
      'timesStreak30Reached': timesStreak30Reached,
      'timesStreak100Reached': timesStreak100Reached,
      'gemsSavedStreakDiscounts': gemsSavedStreakDiscounts,
      'extraPassiveIncomeStreakBoosts': extraPassiveIncomeStreakBoosts,

      'totalCyclesOvertime': totalCyclesOvertime,
      'longestOvertimeStreak': longestOvertimeStreak,
      'totalKpLostOvertimePenalties': totalKpLostOvertimePenalties,
      'timesBurnoutPenaltyTriggered': timesBurnoutPenaltyTriggered,

      'totalTimeSpentApp': totalTimeSpentApp,
      'timeSpentCityTab': timeSpentCityTab,
      'timeSpentQuizTab': timeSpentQuizTab,
      'timeSpentFriendsTab': timeSpentFriendsTab,
      'timeSpentStatsTab': timeSpentStatsTab,
      'timeSpentSettingsTab': timeSpentSettingsTab,
      'totalAppSessions': totalAppSessions,
      'averageSessionLength': averageSessionLength,
      'firstPlayedTimestamp': firstPlayedTimestamp,
      'statsScreenOpenedCount': statsScreenOpenedCount,

      'passiveIncomeDestroyedMap': passiveIncomeDestroyedMap,
    };
  }

  factory GameStats.fromJson(Map<String, dynamic> json) {
    final s = GameStats();
    s.lifetimeGemsEarnedSalary = json['lifetimeGemsEarnedSalary'] ?? 0;
    s.lifetimeGemsEarnedPassive = json['lifetimeGemsEarnedPassive'] ?? 0;
    s.lifetimeGemsEarnedTotal = json['lifetimeGemsEarnedTotal'] ?? 0;
    s.lifetimeGemsSpentTotal = json['lifetimeGemsSpentTotal'] ?? 0;
    s.lifetimeGemsSpentLand = json['lifetimeGemsSpentLand'] ?? 0;
    s.lifetimeGemsSpentProperties = json['lifetimeGemsSpentProperties'] ?? 0;
    s.lifetimeGemsSpentVehicles = json['lifetimeGemsSpentVehicles'] ?? 0;
    s.lifetimeGemsSpentOfficeEquipment = json['lifetimeGemsSpentOfficeEquipment'] ?? 0;
    s.lifetimeGemsSpentMachinery = json['lifetimeGemsSpentMachinery'] ?? 0;
    s.lifetimeGemsSpentInsurance = json['lifetimeGemsSpentInsurance'] ?? 0;
    s.lifetimeGemsSpentSharedStudio = json['lifetimeGemsSpentSharedStudio'] ?? 0;
    s.lifetimeGemsSpentSmallApartment = json['lifetimeGemsSpentSmallApartment'] ?? 0;
    s.lifetimeGemsSpentLuxuryHouse = json['lifetimeGemsSpentLuxuryHouse'] ?? 0;
    s.lifetimeGemsSpentBalancedDiet = json['lifetimeGemsSpentBalancedDiet'] ?? 0;
    s.lifetimeGemsSpentCheapFood = json['lifetimeGemsSpentCheapFood'] ?? 0;
    s.lifetimeGemsSpentBuffet = json['lifetimeGemsSpentBuffet'] ?? 0;
    s.lifetimeGemsSpentPublicTransport = json['lifetimeGemsSpentPublicTransport'] ?? 0;
    s.lifetimeGemsSpentCycling = json['lifetimeGemsSpentCycling'] ?? 0;
    s.lifetimeGemsSpentCar = json['lifetimeGemsSpentCar'] ?? 0;
    s.lifetimeInterestPaidDebt = json['lifetimeInterestPaidDebt'] ?? 0;
    s.lifetimeInsurancePayoutsReceived = json['lifetimeInsurancePayoutsReceived'] ?? 0;
    s.netGemsLostDisasters = json['netGemsLostDisasters'] ?? 0;
    s.peakGemsHeld = json['peakGemsHeld'] ?? 0;
    s.maxDebtReached = json['maxDebtReached'] ?? 0;
    s.cyclesDebtInterest5 = json['cyclesDebtInterest5'] ?? 0;
    s.cyclesDebtInterest10 = json['cyclesDebtInterest10'] ?? 0;
    s.cyclesDebtInterest20 = json['cyclesDebtInterest20'] ?? 0;
    s.highestSingleCycleIncome = json['highestSingleCycleIncome'] ?? 0;
    s.highestSingleCycleExpenditure = json['highestSingleCycleExpenditure'] ?? 0;
    s.averageDailyNetCashFlow = (json['averageDailyNetCashFlow'] as num?)?.toDouble() ?? 0.0;

    s.lifetimeKpEarnedGross = json['lifetimeKpEarnedGross'] ?? 0;
    s.lifetimeKpLostGross = json['lifetimeKpLostGross'] ?? 0;
    s.highestKpReached = json['highestKpReached'] ?? 0;
    s.lowestKpReached = json['lowestKpReached'] ?? 0;
    s.totalKpLostDebt = json['totalKpLostDebt'] ?? 0;
    s.totalKpLostWaste = json['totalKpLostWaste'] ?? 0;
    s.totalKpLostOvertime = json['totalKpLostOvertime'] ?? 0;
    s.totalKpGainedInsurance = json['totalKpGainedInsurance'] ?? 0;
    s.totalKpGainedQuizzes = json['totalKpGainedQuizzes'] ?? 0;
    s.totalKpGainedHousing = json['totalKpGainedHousing'] ?? 0;
    s.totalKpLostHousing = json['totalKpLostHousing'] ?? 0;
    s.totalKpGainedFood = json['totalKpGainedFood'] ?? 0;
    s.totalKpLostFood = json['totalKpLostFood'] ?? 0;
    s.totalKpGainedTransport = json['totalKpGainedTransport'] ?? 0;
    s.totalKpLostTransport = json['totalKpLostTransport'] ?? 0;
    s.biggestSingleKpGain = json['biggestSingleKpGain'] ?? 0;
    s.biggestSingleKpLoss = json['biggestSingleKpLoss'] ?? 0;
    s.wastePenaltyTriggeredCount = json['wastePenaltyTriggeredCount'] ?? 0;

    s.currentTrackLevelTitle = json['currentTrackLevelTitle'] ?? "None";
    s.daysSpentAtEachLevel = Map<String, int>.from(json['daysSpentAtEachLevel'] ?? {});
    s.totalDaysPlayed = json['totalDaysPlayed'] ?? 0;
    s.fastestTimeToLevel = Map<String, int>.from(json['fastestTimeToLevel'] ?? {});
    s.titleHistory = List<String>.from(json['titleHistory'] ?? ["Student"]);
    s.currentTrackDaysSpent = Map<String, int>.from(json['currentTrackDaysSpent'] ?? {});

    s.totalBuildingsConstructed = json['totalBuildingsConstructed'] ?? 0;
    s.buildingsCurrentlyStanding = json['buildingsCurrentlyStanding'] ?? 0;
    s.officeDesksBuilt = json['officeDesksBuilt'] ?? 0;
    s.coffeeStandsBuilt = json['coffeeStandsBuilt'] ?? 0;
    s.teamOfficesBuilt = json['teamOfficesBuilt'] ?? 0;
    s.logisticsGaragesBuilt = json['logisticsGaragesBuilt'] ?? 0;
    s.departmentOfficesBuilt = json['departmentOfficesBuilt'] ?? 0;
    s.conferenceCentersBuilt = json['conferenceCentersBuilt'] ?? 0;
    s.companyHqBuilt = json['companyHqBuilt'] ?? 0;
    s.boardroomPavilionsBuilt = json['boardroomPavilionsBuilt'] ?? 0;
    s.ideaHubsBuilt = json['ideaHubsBuilt'] ?? 0;
    s.workshopsBuilt = json['workshopsBuilt'] ?? 0;
    s.storageUnitsBuilt = json['storageUnitsBuilt'] ?? 0;
    s.officeBuildingsBuilt = json['officeBuildingsBuilt'] ?? 0;
    s.analyticsCentersBuilt = json['analyticsCentersBuilt'] ?? 0;
    s.rdCentersBuilt = json['rdCentersBuilt'] ?? 0;
    s.globalOperationsBuilt = json['globalOperationsBuilt'] ?? 0;
    s.totalLandPurchased = json['totalLandPurchased'] ?? 0;
    s.totalPropertiesPurchased = json['totalPropertiesPurchased'] ?? 0;
    s.totalVehiclesPurchased = json['totalVehiclesPurchased'] ?? 0;
    s.totalOfficeEquipmentPurchased = json['totalOfficeEquipmentPurchased'] ?? 0;
    s.totalMachineryPurchased = json['totalMachineryPurchased'] ?? 0;
    s.peakLandHeld = json['peakLandHeld'] ?? 0;
    s.peakPropertiesHeld = json['peakPropertiesHeld'] ?? 0;
    s.peakVehiclesHeld = json['peakVehiclesHeld'] ?? 0;
    s.peakOfficeEquipmentHeld = json['peakOfficeEquipmentHeld'] ?? 0;
    s.peakMachineryHeld = json['peakMachineryHeld'] ?? 0;
    s.buildingsLostForeclosure = json['buildingsLostForeclosure'] ?? 0;
    s.totalBuildingRearrangements = json['totalBuildingRearrangements'] ?? 0;
    s.demolitionSessionsCount = json['demolitionSessionsCount'] ?? 0;

    s.passiveIncomeFarmsEarned = json['passiveIncomeFarmsEarned'] ?? 0;
    s.passiveIncomeFactoriesEarned = json['passiveIncomeFactoriesEarned'] ?? 0;
    s.passiveIncomeApartmentsEarned = json['passiveIncomeApartmentsEarned'] ?? 0;
    s.passiveIncomeDistCentersEarned = json['passiveIncomeDistCentersEarned'] ?? 0;
    s.passiveIncomeItServiceEarned = json['passiveIncomeItServiceEarned'] ?? 0;
    s.farmsBuilt = json['farmsBuilt'] ?? 0;
    s.factoriesBuilt = json['factoriesBuilt'] ?? 0;
    s.apartmentsBuilt = json['apartmentsBuilt'] ?? 0;
    s.distCentersBuilt = json['distCentersBuilt'] ?? 0;
    s.itServiceCentersBuilt = json['itServiceCentersBuilt'] ?? 0;
    s.farmsLostDisaster = json['farmsLostDisaster'] ?? 0;
    s.factoriesLostDisaster = json['factoriesLostDisaster'] ?? 0;
    s.apartmentsLostDisaster = json['apartmentsLostDisaster'] ?? 0;
    s.distCentersLostDisaster = json['distCentersLostDisaster'] ?? 0;
    s.itServiceCentersLostDisaster = json['itServiceCentersLostDisaster'] ?? 0;
    s.farmsSetupCostsPaid = json['farmsSetupCostsPaid'] ?? 0;
    s.factoriesSetupCostsPaid = json['factoriesSetupCostsPaid'] ?? 0;
    s.apartmentsSetupCostsPaid = json['apartmentsSetupCostsPaid'] ?? 0;
    s.distCentersSetupCostsPaid = json['distCentersSetupCostsPaid'] ?? 0;
    s.itServiceCentersSetupCostsPaid = json['itServiceCentersSetupCostsPaid'] ?? 0;
    s.highestSingleCyclePassiveIncome = json['highestSingleCyclePassiveIncome'] ?? 0;
    s.passiveIncomeDestroyedReinvested = json['passiveIncomeDestroyedReinvested'] ?? 0;
    s.ratioPassiveToSalary = (json['ratioPassiveToSalary'] as num?)?.toDouble() ?? 0.0;
    s.activePassiveIncomeTypesCount = json['activePassiveIncomeTypesCount'] ?? 0;

    s.totalCyclesSpentDebt = json['totalCyclesSpentDebt'] ?? 0;
    s.longestContinuousDebtStreak = json['longestContinuousDebtStreak'] ?? 0;
    s.currentDebtStreak = json['currentDebtStreak'] ?? 0;
    s.numberOfTimesDebtEntered = json['numberOfTimesDebtEntered'] ?? 0;
    s.bankruptciesDeclared = json['bankruptciesDeclared'] ?? 0;
    s.totalAssetValueLostBankruptcy = json['totalAssetValueLostBankruptcy'] ?? 0;
    s.closestCallForeclosure = json['closestCallForeclosure'] ?? 30;

    s.cyclesSpentSharedStudio = json['cyclesSpentSharedStudio'] ?? 0;
    s.cyclesSpentSmallApartment = json['cyclesSpentSmallApartment'] ?? 0;
    s.cyclesSpentLuxuryHouse = json['cyclesSpentLuxuryHouse'] ?? 0;
    s.cyclesSpentBalancedDiet = json['cyclesSpentBalancedDiet'] ?? 0;
    s.cyclesSpentCheapFood = json['cyclesSpentCheapFood'] ?? 0;
    s.cyclesSpentBuffet = json['cyclesSpentBuffet'] ?? 0;
    s.cyclesSpentPublicTransport = json['cyclesSpentPublicTransport'] ?? 0;
    s.cyclesSpentCycling = json['cyclesSpentCycling'] ?? 0;
    s.cyclesSpentCar = json['cyclesSpentCar'] ?? 0;
    s.kpGainedBalancedDiet = json['kpGainedBalancedDiet'] ?? 0;
    s.kpLostCheapFood = json['kpLostCheapFood'] ?? 0;
    s.kpLostBuffet = json['kpLostBuffet'] ?? 0;
    s.kpLostCyclingTimeCost = json['kpLostCyclingTimeCost'] ?? 0;
    s.luxuryHousePenaltyTriggered = json['luxuryHousePenaltyTriggered'] ?? 0;
    s.gemsSpentCheapFood = json['gemsSpentCheapFood'] ?? 0;
    s.gemsSpentBuffet = json['gemsSpentBuffet'] ?? 0;
    s.longestBalancedDietStreak = json['longestBalancedDietStreak'] ?? 0;
    s.currentBalancedDietStreak = json['currentBalancedDietStreak'] ?? 0;
    s.longestPublicTransportStreak = json['longestPublicTransportStreak'] ?? 0;
    s.currentPublicTransportStreak = json['currentPublicTransportStreak'] ?? 0;

    s.totalCyclesInsured = json['totalCyclesInsured'] ?? 0;
    s.totalPremiumsPaid = json['totalPremiumsPaid'] ?? 0;
    s.disastersSurvivedInsured = json['disastersSurvivedInsured'] ?? 0;
    s.disastersSurvivedUninsured = json['disastersSurvivedUninsured'] ?? 0;
    s.longestGapUninsured = json['longestGapUninsured'] ?? 0;
    s.currentUninsuredStreak = json['currentUninsuredStreak'] ?? 0;

    s.totalDisasters = json['totalDisasters'] ?? 0;
    s.numberOfFloods = json['numberOfFloods'] ?? 0;
    s.numberOfFires = json['numberOfFires'] ?? 0;
    s.numberOfEarthquakes = json['numberOfEarthquakes'] ?? 0;
    s.numberOfDroughts = json['numberOfDroughts'] ?? 0;
    s.numberOfLandslides = json['numberOfLandslides'] ?? 0;
    s.numberOfEconomyCrashes = json['numberOfEconomyCrashes'] ?? 0;
    s.numberOfMassEmigrations = json['numberOfMassEmigrations'] ?? 0;
    s.numberOfPandemics = json['numberOfPandemics'] ?? 0;
    s.landLostFlood = json['landLostFlood'] ?? 0;
    s.propertiesVehiclesLostFire = json['propertiesVehiclesLostFire'] ?? 0;
    s.officeEquipMachineryLostEarthquake = json['officeEquipMachineryLostEarthquake'] ?? 0;
    s.farmsDestroyedDrought = json['farmsDestroyedDrought'] ?? 0;
    s.distCentersDestroyedLandslide = json['distCentersDestroyedLandslide'] ?? 0;
    s.factoriesDestroyedEconomyCrash = json['factoriesDestroyedEconomyCrash'] ?? 0;
    s.apartmentsDestroyedMassEmigration = json['apartmentsDestroyedMassEmigration'] ?? 0;
    s.itServiceCentersDestroyedPandemic = json['itServiceCentersDestroyedPandemic'] ?? 0;
    s.incomeReductionDisasters = json['incomeReductionDisasters'] ?? 0;
    s.longestDisasterFreeStretch = json['longestDisasterFreeStretch'] ?? 0;
    s.currentDisasterFreeStreak = json['currentDisasterFreeStreak'] ?? 0;
    s.disastersZeroLoss = json['disastersZeroLoss'] ?? 0;

    s.totalQuizzesAttempted = json['totalQuizzesAttempted'] ?? 0;
    s.correctEasyAnswers = json['correctEasyAnswers'] ?? 0;
    s.wrongEasyAnswers = json['wrongEasyAnswers'] ?? 0;
    s.correctMediumAnswers = json['correctMediumAnswers'] ?? 0;
    s.wrongMediumAnswers = json['wrongMediumAnswers'] ?? 0;
    s.correctHardAnswers = json['correctHardAnswers'] ?? 0;
    s.wrongHardAnswers = json['wrongHardAnswers'] ?? 0;
    s.accuracyRateOverall = (json['accuracyRateOverall'] as num?)?.toDouble() ?? 0.0;
    s.accuracyRateEasy = (json['accuracyRateEasy'] as num?)?.toDouble() ?? 0.0;
    s.accuracyRateMedium = (json['accuracyRateMedium'] as num?)?.toDouble() ?? 0.0;
    s.accuracyRateHard = (json['accuracyRateHard'] as num?)?.toDouble() ?? 0.0;
    s.totalKpEarnedQuizzes = json['totalKpEarnedQuizzes'] ?? 0;
    s.totalKpLostWrongQuiz = json['totalKpLostWrongQuiz'] ?? 0;
    s.quizzesReplayed = json['quizzesReplayed'] ?? 0;
    s.totalKpEarnedReplays = json['totalKpEarnedReplays'] ?? 0;
    s.longestCorrectStreakQuizzes = json['longestCorrectStreakQuizzes'] ?? 0;
    s.dailyQuizAttempted = json['dailyQuizAttempted'] ?? 0;
    s.dailyQuizCorrect = json['dailyQuizCorrect'] ?? 0;
    s.dailyQuizLongestStreak = json['dailyQuizLongestStreak'] ?? 0;
    s.pastDailyQuizzesAttemptedRetroactive = json['pastDailyQuizzesAttemptedRetroactive'] ?? 0;
    s.totalKpEarnedDailyQuiz = json['totalKpEarnedDailyQuiz'] ?? 0;

    s.totalRevivalsEarned = json['totalRevivalsEarned'] ?? 3;
    s.totalRevivalsUsed = json['totalRevivalsUsed'] ?? 0;
    s.streakResetToZero = json['streakResetToZero'] ?? 0;
    s.timesStreak10Reached = json['timesStreak10Reached'] ?? 0;
    s.timesStreak30Reached = json['timesStreak30Reached'] ?? 0;
    s.timesStreak100Reached = json['timesStreak100Reached'] ?? 0;
    s.gemsSavedStreakDiscounts = json['gemsSavedStreakDiscounts'] ?? 0;
    s.extraPassiveIncomeStreakBoosts = json['extraPassiveIncomeStreakBoosts'] ?? 0;

    s.totalCyclesOvertime = json['totalCyclesOvertime'] ?? 0;
    s.longestOvertimeStreak = json['longestOvertimeStreak'] ?? 0;
    s.totalKpLostOvertimePenalties = json['totalKpLostOvertimePenalties'] ?? 0;
    s.timesBurnoutPenaltyTriggered = json['timesBurnoutPenaltyTriggered'] ?? 0;

    s.totalTimeSpentApp = json['totalTimeSpentApp'] ?? 0;
    s.timeSpentCityTab = json['timeSpentCityTab'] ?? 0;
    s.timeSpentQuizTab = json['timeSpentQuizTab'] ?? 0;
    s.timeSpentFriendsTab = json['timeSpentFriendsTab'] ?? 0;
    s.timeSpentStatsTab = json['timeSpentStatsTab'] ?? 0;
    s.timeSpentSettingsTab = json['timeSpentSettingsTab'] ?? 0;
    s.totalAppSessions = json['totalAppSessions'] ?? 0;
    s.averageSessionLength = (json['averageSessionLength'] as num?)?.toDouble() ?? 0.0;
    s.firstPlayedTimestamp = json['firstPlayedTimestamp'];
    s.statsScreenOpenedCount = json['statsScreenOpenedCount'] ?? 0;

    if (json['passiveIncomeDestroyedMap'] != null) {
      s.passiveIncomeDestroyedMap = Map<String, bool>.from(json['passiveIncomeDestroyedMap']);
    }

    return s;
  }
}
