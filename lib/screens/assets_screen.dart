import 'package:flutter/material.dart';
import '../game_state.dart';
import '../widgets/icon_text.dart';
import '../services/sfx_manager.dart';
import '../logic/game_manager.dart';
import '../logic/tutorial_keys.dart';

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
      builder: (context, _) {
        final bool isBackAllowed = !game.isTutorialActive || game.isTutorialBackAllowed;
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
              title: const Text("Assets"),
              leading: BackButton(
                key: TutorialKeys.assetsBackKey,
                onPressed: () {
                  if (game.isTutorialActive) {
                    if (game.isTutorialBackAllowed) {
                      // Let tutorial handle pop
                    } else {
                      game.onBackGestureIntercepted?.call();
                      return;
                    }
                  }
                  sfx.playClick();
                  Navigator.pop(context);
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Center(
                    child: CounterChip(
                      label: "[GEM]",
                      value: game.gems,
                      prefix: "Gems",
                    ),
                  ),
                ),
              ],
            ),
        body: ListView(
          key: TutorialKeys.assetsBodyKey,
          padding: const EdgeInsets.all(16),
          children: [
            if (discount > 0)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: Colors.blue, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rewards.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            "Enjoy a ${(discount * 100).toInt()}% discount on all assets and other benefits for your ${game.dailyQuizStreak}-day streak!",
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ...AssetType.values.map((type) {
              final originalCost = assetCosts[type]!;
              final discountedCost = (originalCost * (1 - discount)).round();
              final sellPrice = assetSellPrice(type);
              final ownedCount = game.assets.count(type);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
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
                            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          onPressed: () => onBuyAsset(type),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 6),
                              if (discount > 0) ...[
                                Text(
                                  "$originalCost",
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                                const SizedBox(width: 4),
                              ],
                              IconText("Buy ($discountedCost [GEM])"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  },
);
}
}
