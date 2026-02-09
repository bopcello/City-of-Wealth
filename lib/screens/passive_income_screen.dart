import 'package:flutter/material.dart';
import '../game_state.dart';
import 'dart:math';

import '../logic/game_manager.dart';

class PassiveIncomeScreen extends StatelessWidget {
  final GameManager game;

  const PassiveIncomeScreen({super.key, required this.game});

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
              const Text(
                "Each investment unlocks a building. Once built, it generates passive income based on your assets.",
                style: TextStyle(color: Colors.grey),
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
                  onInvest: () => game.investInPassiveIncome(assetType),
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
    required this.onInvest,
  });

  @override
  Widget build(BuildContext context) {
    final potentialIncome = (investedCount > 0 && hasBuilding)
        ? min(ownedAssets, investedCount) * info.incomePerAsset
        : 0;

    return Card(
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
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "$investedCount Invested",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Based on: ${assetLabel(info.assetType)}",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text("Investment: ${info.investmentCost} gems"),
            Text(
              "Income: ${info.incomePerAsset} gems per ${assetLabel(info.assetType).toLowerCase()}",
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
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "MISSING BUILDING",
                          style: TextStyle(
                            color: Colors.orange,
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
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(text: "Earning "),
                            if (multiplier < 1.0)
                              TextSpan(
                                text: "$potentialIncome",
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                            TextSpan(
                              text:
                                  " ${(potentialIncome * multiplier).round()} gems per cycle!",
                            ),
                            if (multiplier < 1.0 && activeDisaster != null)
                              TextSpan(
                                text: " (due to ${activeDisaster!.name})",
                                style: TextStyle(
                                  color: Colors.red.shade900,
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
                    backgroundColor: canInvest ? Colors.green : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    canInvest
                        ? (investedCount == 0
                              ? "Invest (${info.investmentCost} gems)"
                              : "Invest in one more (${info.investmentCost} gems)")
                        : ownedAssets == 0
                        ? "Need ${assetLabel(info.assetType)} first"
                        : "Not enough gems (need ${info.investmentCost})",
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
