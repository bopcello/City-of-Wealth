import 'package:flutter/material.dart';
import '../game_state.dart';
import '../widgets/icon_text.dart';
import '../widgets/counter_chip.dart';
import '../services/sfx_manager.dart';
import '../logic/game_manager.dart';

class AssetsScreen extends StatelessWidget {
  final AssetInventory assets;
  final int gems;
  final int streak;
  final void Function(AssetType type) onBuyAsset;
  final void Function(AssetType type) onSellAsset;
  final SfxManager sfx;
  final GameManager game;

  const AssetsScreen({
    super.key,
    required this.assets,
    required this.gems,
    required this.streak,
    required this.onBuyAsset,
    required this.onSellAsset,
    required this.sfx,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    // Get rewards to show discounts
    final rewards = getStreakRewards(streak);
    final discount = rewards.assetDiscount;

    return ListenableBuilder(
      listenable: game,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text("Assets"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: CounterChip(
                  label: "Gems",
                  value: game.gems,
                  icon: Icons.diamond,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: AssetType.values.map((type) {
            final originalCost = assetCosts[type]!;
            final discountedCost = (originalCost * (1 - discount)).round();
            final sellPrice = assetSellPrice(type);
            final canAfford = game.gems >= discountedCost;
            final ownedCount = game.assets.count(type);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: canAfford
                      ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
                      : Colors.red.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          assetLabel(type),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "Owned: $ownedCount",
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withValues(alpha: 0.1),
                          foregroundColor: Colors.red.shade400,
                        ),
                        onPressed: ownedCount > 0
                            ? () {
                                sfx.playSell();
                                onSellAsset(type);
                              }
                            : null,
                        child: IconText("Sell ($sellPrice [GEM])"),
                      ),
                      const SizedBox(width: 8),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: canAfford ? Colors.green : null,
                              foregroundColor: canAfford ? Colors.white : null,
                            ),
                            onPressed: canAfford ? () => onBuyAsset(type) : null,
                            child: IconText("Buy ($discountedCost [GEM])"),
                          ),
                          if (discount > 0)
                            Positioned(
                              top: -10,
                              right: -5,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "-${(discount * 100).toInt()}%",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (discount > 0)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, right: 8),
                        child: Text(
                          "Originally: $originalCost [GEM]",
                          style: const TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
