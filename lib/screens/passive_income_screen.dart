import 'package:flutter/material.dart';
import '../widgets/icon_text.dart';
import '../game_state.dart';
import 'dart:math';
import '../services/sfx_manager.dart';
import '../theme/app_colors.dart';
import '../logic/game_manager.dart';
import '../logic/tutorial_keys.dart';
import '../widgets/responsive_widescreen.dart';
import '../widgets/shiny_button.dart';
import '../widgets/shortcut_overlay_banner.dart';

IconData getPassiveIncomeIcon(PassiveIncomeType type) {
  switch (type) {
    case PassiveIncomeType.farm:
      return Icons.agriculture;
    case PassiveIncomeType.factory:
      return Icons.precision_manufacturing;
    case PassiveIncomeType.apartment:
      return Icons.apartment;
    case PassiveIncomeType.goodsExchange:
      return Icons.local_shipping;
    case PassiveIncomeType.xeroxShop:
      return Icons.computer;
  }
}

class PassiveIncomeScreen extends StatelessWidget {
  final GameManager game;
  final SfxManager sfx;

  const PassiveIncomeScreen({super.key, required this.game, required this.sfx});

  @override
  Widget build(BuildContext context) {
    final bool isBackAllowed =
        !game.isTutorialActive || game.isTutorialBackAllowed;

    return PopScope(
      canPop: isBackAllowed,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          if (game.isTutorialActive) {
            game.onTutorialBackStepTriggered?.call();
          }
          return;
        }
        if (game.isTutorialActive && !game.isTutorialBackAllowed) {
          game.onBackGestureIntercepted?.call();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Passive Income"),
          leading: BackButton(
            key: TutorialKeys.passiveIncomeBackKey,
            onPressed: () {
              if (game.isTutorialActive) {
                if (game.isTutorialBackAllowed) {
                  // Let the tutorial advance
                } else {
                  game.onBackGestureIntercepted?.call();
                  return;
                }
              }
              Navigator.pop(context);
            },
          ),
        ),
        body: ListenableBuilder(
          listenable: game,
          builder: (context, _) => Stack(
            children: [
              SingleChildScrollView(
                key: TutorialKeys.passiveIncomeBodyKey,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Invest in passive income sources",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Each investment unlocks a building. Once built, it generates passive income based on your assets.",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (isWidescreenDesktop(context))
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: passiveIncomeData.entries.length,
                        itemBuilder: (context, index) {
                          final entry = passiveIncomeData.entries.elementAt(index);
                          final info = entry.value;
                          final assetType = info.assetType;
                          final investedCount =
                              game.activePassiveIncomes[assetType] ?? 0;
                          final ownedAssets = game.assets.count(assetType);
                          final canInvest = investedCount < ownedAssets;
                          final rewards = getStreakRewards(game.dailyQuizStreak);
                          final discountedCost = (info.investmentCost *
                                  (1.0 - rewards.assetDiscount))
                              .round();
                          final canAfford = game.gems >= discountedCost;

                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Title & Logo below name
                                Column(
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        info.buildingName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Icon(
                                      getPassiveIncomeIcon(info.type),
                                      size: 36,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ],
                                ),
                                // Stats Tag
                                Column(
                                  children: [
                                    Text(
                                      "Invested: $investedCount / $ownedAssets",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ShinyButton(
                                        isShiny: canAfford && canInvest,
                                        backgroundColor: (canAfford && canInvest)
                                            ? AppColors.of(context, 'success')
                                            : Colors.transparent,
                                        foregroundColor: (canAfford && canInvest)
                                            ? Colors.white
                                            : AppColors.of(context, 'success'),
                                        shape: (canAfford && canInvest)
                                            ? const StadiumBorder()
                                            : StadiumBorder(
                                                side: BorderSide(
                                                  color: AppColors.of(
                                                    context,
                                                    'success',
                                                  ),
                                                  width: 1.5,
                                                ),
                                              ),
                                        useStadiumShape: true,
                                        elevation: 0,
                                        minimumSize: Size.zero,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        onPressed: canInvest
                                            ? () {
                                                sfx.playBuy();
                                                game.investInPassiveIncome(
                                                  assetType,
                                                );
                                              }
                                            : null,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: IconText(
                                            canInvest
                                                ? "Invest ($discountedCost [GEM])"
                                                : "Max Assets",
                                            style: const TextStyle(fontSize: 11),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    else
                      ...passiveIncomeData.entries.map((entry) {
                        final info = entry.value;
                        final assetType = info.assetType;
                        final investedCount =
                            game.activePassiveIncomes[assetType] ?? 0;
                        final hasBuilding = game.cityLayout.any(
                          (b) => b.name == info.buildingName,
                        );
                        final ownedAssets = game.assets.count(assetType);
                        final canInvest = investedCount < ownedAssets;

                        final multiplier = game.getPassiveIncomeMultiplier(
                          assetType,
                        );
                        final activeDisaster = game.getActiveDisasterForAsset(
                          assetType,
                        );

                        return _PassiveIncomeCard(
                          info: info,
                          ownedAssets: ownedAssets,
                          investedCount: investedCount,
                          hasBuilding: hasBuilding,
                          canInvest: canInvest,
                          multiplier: multiplier,
                          activeDisaster: activeDisaster,
                          gems: game.gems,
                          game: game,
                          onInvest: () {
                            sfx.playBuy();
                            game.investInPassiveIncome(assetType);
                          },
                        );
                      }),
                  ],
                ),
              ),
              if (isWidescreenDesktop(context))
                const ShortcutOverlayBanner(
                  screenId: 'passive_income_screen',
                  helpTip:
                      "Invest in passive income sources to generate background cashflow. Press [Esc] to go back.",
                  shortcuts: ["[Esc] Back"],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PassiveIncomeCard extends StatelessWidget {
  final PassiveIncomeInfo info;
  final int ownedAssets;
  final int investedCount;
  final bool hasBuilding;
  final bool canInvest;
  final double multiplier;
  final DisasterType? activeDisaster;
  final int gems;
  final GameManager game;
  final VoidCallback onInvest;

  const _PassiveIncomeCard({
    required this.info,
    required this.ownedAssets,
    required this.investedCount,
    required this.hasBuilding,
    required this.canInvest,
    required this.multiplier,
    this.activeDisaster,
    required this.gems,
    required this.game,
    required this.onInvest,
  });

  @override
  Widget build(BuildContext context) {
    final rewards = getStreakRewards(game.dailyQuizStreak);
    final potentialIncome = (investedCount > 0 && hasBuilding)
        ? min(ownedAssets, investedCount) * info.incomePerAsset
        : 0;

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      elevation: 0,
      surfaceTintColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  info.buildingName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (investedCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.of(context, 'success'),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "$investedCount Invested",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Based on: ${assetLabel(info.assetType)}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            IconText("Investment: ${info.investmentCost} [GEM]"),
            const SizedBox(height: 4),
            IconText(
              "Income: ${info.incomePerAsset} [GEM] per ${assetLabel(info.assetType).toLowerCase()}",
            ),
            Text(
              "You own: $ownedAssets ${assetLabel(info.assetType).toLowerCase()}",
            ),
            if (!hasBuilding && investedCount > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.of(context, 'surfaceVariant'),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.of(context, 'warning'),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.of(context, 'warning'),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "MISSING BUILDING",
                          style: TextStyle(
                            color: AppColors.of(context, 'warning'),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Build ${info.buildingName} in your city to start earning!",
                      style: const TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
            if (investedCount > 0 && hasBuilding) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.of(
                    context,
                    'success',
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.of(context, 'success')),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.of(context, 'success'),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                          children: [
                            const TextSpan(text: "Earning "),
                            if (multiplier != 1.0)
                              TextSpan(
                                text: "$potentialIncome",
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ...IconText.parseText(
                              " ${(potentialIncome * multiplier).round()} [GEM] per cycle!",
                              TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                              context,
                            ),
                            if (getStreakRewards(
                                  game.dailyQuizStreak,
                                ).passiveIncomeMultiplier >
                                1.0)
                              TextSpan(
                                text: " (${rewards.label} Bonus)",
                                style: TextStyle(
                                  color: AppColors.of(context, 'gem'),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            if (multiplier < 1.0 && activeDisaster != null)
                              TextSpan(
                                text:
                                    " (due to ${game.disasterLabel(activeDisaster!)})",
                                style: TextStyle(
                                  color: AppColors.of(context, 'error'),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (investedCount < ownedAssets) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canInvest ? onInvest : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canInvest
                        ? AppColors.of(context, 'success')
                        : Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: IconText(
                    canInvest
                        ? (investedCount == 0
                              ? "Invest (${info.investmentCost} [GEM])"
                              : "Invest in one more (${info.investmentCost} [GEM])")
                        : ownedAssets == 0
                        ? "Need ${assetLabel(info.assetType)} first"
                        : "Not enough [GEM] (need ${info.investmentCost})",
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
