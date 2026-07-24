import 'package:flutter/material.dart';

class TutorialKeys {
  TutorialKeys._();

  // =========================
  // TOP HUD
  // =========================

  static final GlobalKey kpKey = GlobalKey(debugLabel: 'tutorial_kp');

  static final GlobalKey gemsKey = GlobalKey(debugLabel: 'tutorial_gems');

  static final GlobalKey streakKey = GlobalKey(debugLabel: 'tutorial_streak');

  static final GlobalKey revivalsKey = GlobalKey(
    debugLabel: 'tutorial_revivals',
  );

  // =========================
  // BOTTOM NAVIGATION
  // =========================

  static final GlobalKey tabCityKey = GlobalKey(
    debugLabel: 'tutorial_tab_city',
  );

  static final GlobalKey tabMoneyKey = GlobalKey(
    debugLabel: 'tutorial_tab_money',
  );

  static final GlobalKey tabSettingsKey = GlobalKey(
    debugLabel: 'tutorial_tab_settings',
  );

  // =========================
  // MONEY TAB TILES
  // =========================

  static final GlobalKey careerTileKey = GlobalKey(
    debugLabel: 'tutorial_career_tile',
  );

  static final GlobalKey passiveIncomeTileKey = GlobalKey(
    debugLabel: 'tutorial_passive_income_tile',
  );

  static final GlobalKey assetsTileKey = GlobalKey(
    debugLabel: 'tutorial_assets_tile',
  );

  static final GlobalKey liabilitiesTileKey = GlobalKey(
    debugLabel: 'tutorial_liabilities_tile',
  );

  static final GlobalKey quizTileKey = GlobalKey(
    debugLabel: 'tutorial_quiz_tile',
  );

  // =========================
  // SCREEN BODY KEYS
  // =========================

  static final GlobalKey cityBodyKey = GlobalKey(
    debugLabel: 'tutorial_city_body',
  );

  static final GlobalKey settingsBodyKey = GlobalKey(
    debugLabel: 'tutorial_settings_body',
  );

  static final GlobalKey liabilitiesContentKey = GlobalKey(
    debugLabel: 'tutorial_liabilities_content',
  );

  static final GlobalKey quizDailyPanelKey = GlobalKey(
    debugLabel: 'tutorial_quiz_daily_panel',
  );

  static final GlobalKey assetsBodyKey = GlobalKey(
    debugLabel: 'tutorial_assets_body',
  );

  // =========================
  // CAREER SCREEN
  // =========================

  static final GlobalKey careerHeroCardKey = GlobalKey(
    debugLabel: 'tutorial_career_hero',
  );

  static final GlobalKey careerOvertimeKey = GlobalKey(
    debugLabel: 'tutorial_career_overtime',
  );

  static final GlobalKey careerBackKey = GlobalKey(
    debugLabel: 'tutorial_career_back',
  );

  // =========================
  // PASSIVE INCOME SCREEN
  // =========================

  static final GlobalKey passiveIncomeBackKey = GlobalKey(
    debugLabel: 'tutorial_passive_income_back',
  );

  static final GlobalKey passiveIncomeBodyKey = GlobalKey(
    debugLabel: 'tutorial_passive_income_body',
  );

  // =========================
  // QUIZ SCREEN
  // =========================

  static final GlobalKey quizBackKey = GlobalKey(
    debugLabel: 'tutorial_quiz_back',
  );

  // =========================
  // ASSETS SCREEN
  // =========================

  static final GlobalKey assetsBackKey = GlobalKey(
    debugLabel: 'tutorial_assets_back',
  );

  // =========================
  // LIABILITIES SCREEN
  // =========================

  static final GlobalKey liabilitiesBackKey = GlobalKey(
    debugLabel: 'tutorial_liabilities_back',
  );

  static final GlobalKey liabilitiesRentKey = GlobalKey(
    debugLabel: 'tutorial_liabilities_rent',
  );

  static final GlobalKey liabilitiesFoodKey = GlobalKey(
    debugLabel: 'tutorial_liabilities_food',
  );

  static final GlobalKey liabilitiesTransportKey = GlobalKey(
    debugLabel: 'tutorial_liabilities_transport',
  );

  // =========================
  // SETTINGS SCREEN
  // =========================

  static final GlobalKey settingsManualKey = GlobalKey(
    debugLabel: 'tutorial_settings_manual',
  );

  // =========================
  // FRIENDS SYSTEM
  // =========================

  static final GlobalKey cityTabKey = GlobalKey(
    debugLabel: 'tutorial_city_tab',
  );

  static final GlobalKey friendsSegmentKey = GlobalKey(
    debugLabel: 'tutorial_friends_segment',
  );

  static final GlobalKey addFriendButtonKey = GlobalKey(
    debugLabel: 'tutorial_add_friend_button',
  );

  static final GlobalKey leaderboardButtonKey = GlobalKey(
    debugLabel: 'tutorial_leaderboard_button',
  );

  static final GlobalKey activityFeedButtonKey = GlobalKey(
    debugLabel: 'tutorial_activity_feed_button',
  );
}
