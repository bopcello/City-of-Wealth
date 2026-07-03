import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../logic/game_manager.dart';
import '../theme/app_colors.dart';

class StatsScreen extends StatefulWidget {
  final GameManager game;
  const StatsScreen({super.key, required this.game});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  static const _shareChannel = MethodChannel('com.example.city_of_wealth/share');
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────────────────────────────────
  bool _matches(String label) => _query.isEmpty || label.toLowerCase().contains(_query);

  Widget _row(BuildContext context, String label, String value) {
    if (!_matches(label)) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _category(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> rows,
  ) {
    // If searching, filter: only show if at least one row has visible content
    // (rows already return SizedBox.shrink for non-matching, so check title too)
    final hasMatch = _query.isEmpty || title.toLowerCase().contains(_query) ||
        rows.any((w) => w is! SizedBox);
    if (!hasMatch) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final brandColor = AppColors.of(context, 'kp');
    final surface = theme.colorScheme.surfaceContainerHighest;
    final outline = theme.colorScheme.outline;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: outline.withValues(alpha: 0.5)),
        ),
        child: Theme(
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: _query.isNotEmpty,
            leading: Icon(icon, color: brandColor, size: 20),
            title: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            iconColor: brandColor,
            collapsedIconColor: theme.colorScheme.onSurfaceVariant,
            childrenPadding: const EdgeInsets.only(bottom: 10),
            children: rows,
          ),
        ),
      ),
    );
  }

  // ── share ─────────────────────────────────────────────────────────────────
  Future<void> _shareStats() async {
    final s = widget.game.stats;
    final buf = StringBuffer();
    buf.writeln('City of Wealth — Lifetime Stats for ${widget.game.playerName}');
    buf.writeln('=' * 50);
    buf.writeln('\n💎 GEMS — ECONOMY');
    buf.writeln('Lifetime Gems Earned (Salary): ${s.lifetimeGemsEarnedSalary}');
    buf.writeln('Lifetime Gems Earned (Passive): ${s.lifetimeGemsEarnedPassive}');
    buf.writeln('Lifetime Gems Earned (Total): ${s.lifetimeGemsEarnedTotal}');
    buf.writeln('Lifetime Gems Spent: ${s.lifetimeGemsSpentTotal}');
    buf.writeln('Peak Gems Held: ${s.peakGemsHeld}');
    buf.writeln('Max Debt Reached: ${s.maxDebtReached}');
    buf.writeln('\n⭐ KP — FINANCIAL WISDOM');
    buf.writeln('Lifetime KP Earned: ${s.lifetimeKpEarnedGross}');
    buf.writeln('Lifetime KP Lost: ${s.lifetimeKpLostGross}');
    buf.writeln('Highest KP Reached: ${s.highestKpReached}');
    buf.writeln('\n🏗️ ASSETS & BUILDINGS');
    buf.writeln('Land Purchased: ${s.totalLandPurchased}');
    buf.writeln('Properties Purchased: ${s.totalPropertiesPurchased}');
    buf.writeln('Vehicles Purchased: ${s.totalVehiclesPurchased}');
    buf.writeln('\n📊 QUIZ PERFORMANCE');
    buf.writeln('Daily Quizzes Attempted: ${s.dailyQuizAttempted}');
    buf.writeln('Daily Quizzes Correct: ${s.dailyQuizCorrect}');
    buf.writeln('Longest Daily Streak: ${s.dailyQuizLongestStreak}');
    buf.writeln('\n⚡ DISASTERS');
    buf.writeln('Total Disasters: ${s.totalDisasters}');
    buf.writeln('Survived Insured: ${s.disastersSurvivedInsured}');
    buf.writeln('Survived Uninsured: ${s.disastersSurvivedUninsured}');
    buf.writeln('Disaster-Free Streak: ${s.currentDisasterFreeStreak} days');
    buf.writeln('\n📅 TOTAL DAYS PLAYED: ${s.totalDaysPlayed}');

    try {
      await _shareChannel.invokeMethod('shareText', {'text': buf.toString()});
    } catch (e) {
      debugPrint('Share error: $e');
    }
  }

  // ── build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandColor = AppColors.of(context, 'kp');
    final s = widget.game.stats;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        title: Text(
          'Stats',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: brandColor),
            tooltip: 'Share Stats',
            onPressed: _shareStats,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search stats…',
                prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, size: 18, color: theme.colorScheme.onSurfaceVariant),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                isDense: true,
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: brandColor, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 13),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [

                // ── GEMS — ECONOMY ────────────────────────────────────────
                _category(context, 'Gems — Economy', Icons.diamond_outlined, [
                  _row(context, 'Lifetime Gems Earned (Salary)', '${s.lifetimeGemsEarnedSalary}'),
                  _row(context, 'Lifetime Gems Earned (Passive)', '${s.lifetimeGemsEarnedPassive}'),
                  _row(context, 'Lifetime Gems Earned (Total)', '${s.lifetimeGemsEarnedTotal}'),
                  _row(context, 'Lifetime Gems Spent (Total)', '${s.lifetimeGemsSpentTotal}'),
                  _row(context, 'Gems Spent — Land', '${s.lifetimeGemsSpentLand}'),
                  _row(context, 'Gems Spent — Properties', '${s.lifetimeGemsSpentProperties}'),
                  _row(context, 'Gems Spent — Vehicles', '${s.lifetimeGemsSpentVehicles}'),
                  _row(context, 'Gems Spent — Office Equipment', '${s.lifetimeGemsSpentOfficeEquipment}'),
                  _row(context, 'Gems Spent — Machinery', '${s.lifetimeGemsSpentMachinery}'),
                  _row(context, 'Gems Spent — Insurance', '${s.lifetimeGemsSpentInsurance}'),
                  _row(context, 'Gems Spent — Shared Studio', '${s.lifetimeGemsSpentSharedStudio}'),
                  _row(context, 'Gems Spent — Small Apartment', '${s.lifetimeGemsSpentSmallApartment}'),
                  _row(context, 'Gems Spent — Luxury House', '${s.lifetimeGemsSpentLuxuryHouse}'),
                  _row(context, 'Gems Spent — Balanced Diet', '${s.lifetimeGemsSpentBalancedDiet}'),
                  _row(context, 'Gems Spent — Cheap Food', '${s.lifetimeGemsSpentCheapFood}'),
                  _row(context, 'Gems Spent — Buffet', '${s.lifetimeGemsSpentBuffet}'),
                  _row(context, 'Gems Spent — Public Transport', '${s.lifetimeGemsSpentPublicTransport}'),
                  _row(context, 'Gems Spent — Cycling', '${s.lifetimeGemsSpentCycling}'),
                  _row(context, 'Gems Spent — Car', '${s.lifetimeGemsSpentCar}'),
                  _row(context, 'Interest Paid (Debt)', '${s.lifetimeInterestPaidDebt}'),
                  _row(context, 'Peak Gems Held', '${s.peakGemsHeld}'),
                  _row(context, 'Max Debt Reached', '${s.maxDebtReached}'),
                  _row(context, 'Debt Interest Cycles @5%', '${s.cyclesDebtInterest5}'),
                  _row(context, 'Debt Interest Cycles @10%', '${s.cyclesDebtInterest10}'),
                  _row(context, 'Debt Interest Cycles @20%', '${s.cyclesDebtInterest20}'),
                  _row(context, 'Highest Single-Cycle Income', '${s.highestSingleCycleIncome}'),
                  _row(context, 'Highest Single-Cycle Expenditure', '${s.highestSingleCycleExpenditure}'),
                ]),

                // ── KP — FINANCIAL WISDOM ─────────────────────────────────
                _category(context, 'KP — Financial Wisdom', Icons.trending_up, [
                  _row(context, 'Lifetime KP Earned (Gross)', '${s.lifetimeKpEarnedGross}'),
                  _row(context, 'Lifetime KP Lost (Gross)', '${s.lifetimeKpLostGross}'),
                  _row(context, 'Highest KP Reached', '${s.highestKpReached}'),
                  _row(context, 'Lowest KP Reached', '${s.lowestKpReached}'),
                  _row(context, 'KP Lost — Debt', '${s.totalKpLostDebt}'),
                  _row(context, 'KP Lost — Waste Penalty', '${s.totalKpLostWaste}'),
                  _row(context, 'KP Lost — Overtime', '${s.totalKpLostOvertime}'),
                  _row(context, 'KP Gained — Insurance', '${s.totalKpGainedInsurance}'),
                  _row(context, 'KP Gained — Quizzes', '${s.totalKpGainedQuizzes}'),
                  _row(context, 'Biggest Single KP Gain', '${s.biggestSingleKpGain}'),
                  _row(context, 'Biggest Single KP Loss', '${s.biggestSingleKpLoss}'),
                  _row(context, 'Waste Penalties Triggered', '${s.wastePenaltyTriggeredCount}'),
                ]),

                // ── ASSETS & BUILDINGS ────────────────────────────────────
                _category(context, 'Assets & Buildings', Icons.business, [
                  _row(context, 'Land Purchased', '${s.totalLandPurchased}'),
                  _row(context, 'Properties Purchased', '${s.totalPropertiesPurchased}'),
                  _row(context, 'Vehicles Purchased', '${s.totalVehiclesPurchased}'),
                  _row(context, 'Office Equipment Purchased', '${s.totalOfficeEquipmentPurchased}'),
                  _row(context, 'Machinery Purchased', '${s.totalMachineryPurchased}'),
                  _row(context, 'Peak Land Held', '${s.peakLandHeld}'),
                  _row(context, 'Peak Properties Held', '${s.peakPropertiesHeld}'),
                  _row(context, 'Peak Vehicles Held', '${s.peakVehiclesHeld}'),
                  _row(context, 'Peak Office Equipment Held', '${s.peakOfficeEquipmentHeld}'),
                  _row(context, 'Peak Machinery Held', '${s.peakMachineryHeld}'),
                  _row(context, 'Buildings Lost (Foreclosure)', '${s.buildingsLostForeclosure}'),
                ]),

                // ── PASSIVE INCOME ────────────────────────────────────────
                _category(context, 'Passive Income', Icons.attach_money, [
                  _row(context, 'Total Earned — Farms', '${s.passiveIncomeFarmsEarned}'),
                  _row(context, 'Total Earned — Factories', '${s.passiveIncomeFactoriesEarned}'),
                  _row(context, 'Total Earned — Apartments', '${s.passiveIncomeApartmentsEarned}'),
                  _row(context, 'Total Earned — Dist. Centers', '${s.passiveIncomeDistCentersEarned}'),
                  _row(context, 'Total Earned — IT Services', '${s.passiveIncomeItServiceEarned}'),
                  _row(context, 'Farms Lost (Disaster)', '${s.farmsLostDisaster}'),
                  _row(context, 'Factories Lost (Disaster)', '${s.factoriesLostDisaster}'),
                  _row(context, 'Apartments Lost (Disaster)', '${s.apartmentsLostDisaster}'),
                  _row(context, 'Dist. Centers Lost (Disaster)', '${s.distCentersLostDisaster}'),
                  _row(context, 'IT Services Lost (Disaster)', '${s.itServiceCentersLostDisaster}'),
                  _row(context, 'Highest Single-Cycle Passive', '${s.highestSingleCyclePassiveIncome}'),
                ]),

                // ── DEBT & BANKRUPTCY ─────────────────────────────────────
                _category(context, 'Debt & Bankruptcy', Icons.warning_amber_rounded, [
                  _row(context, 'Total Cycles in Debt', '${s.totalCyclesSpentDebt}'),
                  _row(context, 'Longest Debt Streak', '${s.longestContinuousDebtStreak} days'),
                  _row(context, 'Current Debt Streak', '${s.currentDebtStreak} days'),
                  _row(context, 'Times Entered Debt', '${s.numberOfTimesDebtEntered}'),
                  _row(context, 'Bankruptcies Declared', '${s.bankruptciesDeclared}'),
                  _row(context, 'Max Debt Reached', '${s.maxDebtReached} 💎'),
                ]),

                // ── DAILY LIVING CHOICES ──────────────────────────────────
                _category(context, 'Daily Living Choices', Icons.home_outlined, [
                  _row(context, 'Days — Shared Studio', '${s.cyclesSpentSharedStudio}'),
                  _row(context, 'Days — Small Apartment', '${s.cyclesSpentSmallApartment}'),
                  _row(context, 'Days — Luxury House', '${s.cyclesSpentLuxuryHouse}'),
                  _row(context, 'Days — Balanced Diet', '${s.cyclesSpentBalancedDiet}'),
                  _row(context, 'Days — Cheap Food', '${s.cyclesSpentCheapFood}'),
                  _row(context, 'Days — Buffet', '${s.cyclesSpentBuffet}'),
                  _row(context, 'Days — Public Transport', '${s.cyclesSpentPublicTransport}'),
                  _row(context, 'Days — Cycling', '${s.cyclesSpentCycling}'),
                  _row(context, 'Days — Car', '${s.cyclesSpentCar}'),
                  _row(context, 'Longest Balanced Diet Streak', '${s.longestBalancedDietStreak} days'),
                  _row(context, 'Longest Public Transport Streak', '${s.longestPublicTransportStreak} days'),
                ]),

                // ── INSURANCE ─────────────────────────────────────────────
                _category(context, 'Insurance', Icons.shield_outlined, [
                  _row(context, 'Cycles Insured', '${s.totalCyclesInsured}'),
                  _row(context, 'Total Premiums Paid', '${s.totalPremiumsPaid} 💎'),
                  _row(context, 'Disasters Survived (Insured)', '${s.disastersSurvivedInsured}'),
                  _row(context, 'Disasters Survived (Uninsured)', '${s.disastersSurvivedUninsured}'),
                  _row(context, 'Longest Uninsured Gap', '${s.longestGapUninsured} days'),
                  _row(context, 'Current Uninsured Streak', '${s.currentUninsuredStreak} days'),
                ]),

                // ── DISASTERS ─────────────────────────────────────────────
                _category(context, 'Disasters', Icons.bolt, [
                  _row(context, 'Total Disasters', '${s.totalDisasters}'),
                  _row(context, 'Floods', '${s.numberOfFloods}'),
                  _row(context, 'Fires', '${s.numberOfFires}'),
                  _row(context, 'Earthquakes', '${s.numberOfEarthquakes}'),
                  _row(context, 'Droughts', '${s.numberOfDroughts}'),
                  _row(context, 'Landslides', '${s.numberOfLandslides}'),
                  _row(context, 'Economy Crashes', '${s.numberOfEconomyCrashes}'),
                  _row(context, 'Mass Emigrations', '${s.numberOfMassEmigrations}'),
                  _row(context, 'Pandemics', '${s.numberOfPandemics}'),
                  _row(context, 'Disasters with Zero Loss', '${s.disastersZeroLoss}'),
                  _row(context, 'Longest Disaster-Free Stretch', '${s.longestDisasterFreeStretch} days'),
                  _row(context, 'Current Disaster-Free Streak', '${s.currentDisasterFreeStreak} days'),
                ]),

                // ── QUIZ PERFORMANCE ──────────────────────────────────────
                _category(context, 'Quiz Performance', Icons.quiz_outlined, [
                  _row(context, 'Daily Quizzes Attempted', '${s.dailyQuizAttempted}'),
                  _row(context, 'Daily Quizzes Correct', '${s.dailyQuizCorrect}'),
                  _row(context, 'Daily Quiz Longest Streak', '${s.dailyQuizLongestStreak}'),
                  _row(context, 'Practice Replays', '${s.quizzesReplayed}'),
                  _row(context, 'KP Earned — Daily Quiz', '${s.totalKpEarnedDailyQuiz}'),
                  _row(context, 'KP Earned — Replays', '${s.totalKpEarnedReplays}'),
                  _row(context, 'KP Earned — Quizzes (Total)', '${s.totalKpEarnedQuizzes}'),
                ]),

                // ── STREAKS & REVIVALS ────────────────────────────────────
                _category(context, 'Streaks & Revivals', Icons.local_fire_department_outlined, [
                  _row(context, 'Revivals Earned', '${s.totalRevivalsEarned}'),
                  _row(context, 'Revivals Used', '${s.totalRevivalsUsed}'),
                  _row(context, 'Streak Resets to Zero', '${s.streakResetToZero}'),
                  _row(context, 'Times Streak ≥ 10', '${s.timesStreak10Reached}'),
                  _row(context, 'Times Streak ≥ 30', '${s.timesStreak30Reached}'),
                  _row(context, 'Times Streak ≥ 100', '${s.timesStreak100Reached}'),
                  _row(context, 'Gems Saved (Streak Discounts)', '${s.gemsSavedStreakDiscounts}'),
                ]),

                // ── OVERTIME ──────────────────────────────────────────────
                _category(context, 'Overtime', Icons.more_time, [
                  _row(context, 'Total Overtime Cycles', '${s.totalCyclesOvertime}'),
                  _row(context, 'Longest Overtime Streak', '${s.longestOvertimeStreak}'),
                  _row(context, 'KP Lost — Overtime Penalties', '${s.totalKpLostOvertimePenalties}'),
                  _row(context, 'Burnout Penalties Triggered', '${s.timesBurnoutPenaltyTriggered}'),
                ]),

                // ── PROGRESSION ───────────────────────────────────────────
                _category(context, 'Career & Progression', Icons.stairs, [
                  _row(context, 'Total Days Played', '${s.totalDaysPlayed}'),
                  _row(context, 'Current Level Title', s.currentTrackLevelTitle),
                ]),

                const SizedBox(height: 24),
                Center(
                  child: TextButton.icon(
                    onPressed: _shareStats,
                    icon: Icon(Icons.share, size: 18, color: brandColor),
                    label: Text(
                      'Share Stats',
                      style: TextStyle(color: brandColor, fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      side: BorderSide(color: brandColor.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
