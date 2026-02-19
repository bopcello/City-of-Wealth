import 'package:flutter/material.dart';
import '../widgets/icon_text.dart';
import '../game_state.dart';
import 'dart:math';
import '../services/sfx_manager.dart';
import '../theme/app_colors.dart';

import '../logic/game_manager.dart';

class PassiveIncomeScreen extends StatelessWidget {
  final GameManager game;
  final SfxManager sfx;

  const PassiveIncomeScreen({super.key, required this.game, required this.sfx});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Passive Income")),
      body: ListenableBuilder(
        listenable: game,
        builder: (context, _) => SingleChildScrollView(
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
              ...passiveIncomeData.entries.map((entry) {
                final info = entry.value;
                final assetType = info.assetType;
                final investedCount = game.activePassiveIncomes[assetType] ?? 0;
                final hasBuilding = game.cityLayout.any(
                  (b) => b.name == info.buildingName,
                );
                final ownedAssets = game.assets.count(assetType);
                final canInvest =
                    investedCount < ownedAssets &&
                    game.gems >= info.investmentCost;

                final multiplier = game.getPassiveIncomeMultiplier(assetType);
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
    final potentialIncome = (investedCount > 0 && hasBuilding)
        ? min(ownedAssets, investedCount) * info.incomePerAsset
        : 0;

    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
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
                            if (multiplier < 1.0)
                              TextSpan(
                                text: "$potentialIncome",
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
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
