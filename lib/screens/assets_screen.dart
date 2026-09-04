import 'package:flutter/material.dart';
import '../game_state.dart';
import '../widgets/icon_text.dart';
import '../widgets/shiny_button.dart';
import '../services/sfx_manager.dart';
import '../logic/game_manager.dart';
import '../logic/tutorial_keys.dart';
import '../theme/app_colors.dart';
import '../widgets/responsive_widescreen.dart';
import '../widgets/shortcut_overlay_banner.dart';

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
            body: Stack(
              children: [
                isWidescreenDesktop(context)
                    ? SingleChildScrollView(
                        key: TutorialKeys.assetsBodyKey,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (discount > 0)
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.of(
                                    context,
                                    'gem',
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.of(
                                      context,
                                      'gem',
                                    ).withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.stars,
                                      color: AppColors.of(context, 'gem'),
                                      size: 28,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rewards.label,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: AppColors.of(context, 'gem'),
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
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.95,
                              ),
                              itemCount: AssetType.values.length,
                              itemBuilder: (context, index) {
                                final type = AssetType.values[index];
                                final originalCost = assetCosts[type]!;
                                final discountedCost =
                                    (originalCost * (1 - discount)).round();
                                final sellPrice = assetSellPrice(type);
                                final canAfford = gems >= discountedCost;
                                final ownedCount = game.assets.count(type);

                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline.withValues(alpha: 0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Title & Owned badge
                                      Column(
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              assetLabel(type),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              "Owned: $ownedCount",
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Stacked Buttons: Buy on top, Sell on bottom
                                      Column(
                                        children: [
                                          // BUY BUTTON (TOP)
                                          SizedBox(
                                            width: double.infinity,
                                            child: ShinyButton(
                                              isShiny: canAfford,
                                              backgroundColor: canAfford
                                                  ? AppColors.of(
                                                      context,
                                                      'success',
                                                    )
                                                  : Colors.transparent,
                                              foregroundColor: canAfford
                                                  ? Colors.white
                                                  : AppColors.of(
                                                      context,
                                                      'success',
                                                    ),
                                              shape: canAfford
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                  ),
                                              onPressed: () {
                                                sfx.playBuy();
                                                onBuyAsset(type);
                                              },
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    if (discount > 0) ...[
                                                      Text(
                                                        "$originalCost",
                                                        style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          fontSize: 10,
                                                          color: AppColors.of(
                                                            context,
                                                            'onSurfaceVariant',
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 4),
                                                    ],
                                                    IconText(
                                                      "Buy ($discountedCost [GEM])",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          // SELL BUTTON (BOTTOM)
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.of(
                                                  context,
                                                  'error',
                                                ).withValues(alpha: 0.1),
                                                foregroundColor: AppColors.of(
                                                  context,
                                                  'error',
                                                ),
                                                shape: const StadiumBorder(),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                elevation: 0,
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                minimumSize: Size.zero,
                                              ),
                                              onPressed: ownedCount > 0
                                                  ? () {
                                                      sfx.playSell();
                                                      onSellAsset(type);
                                                    }
                                                  : null,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: IconText(
                                                  "Sell ($sellPrice [GEM])",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
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
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        key: TutorialKeys.assetsBodyKey,
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (discount > 0)
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.of(
                                  context,
                                  'gem',
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.of(
                                    context,
                                    'gem',
                                  ).withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.stars,
                                    color: AppColors.of(context, 'gem'),
                                    size: 28,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          rewards.label,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppColors.of(context, 'gem'),
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
                            final discountedCost =
                                (originalCost * (1 - discount)).round();
                            final sellPrice = assetSellPrice(type);
                            final canAfford = gems >= discountedCost;
                            final ownedCount = game.assets.count(type);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline.withValues(alpha: 0.3),
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
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.of(
                                            context,
                                            'error',
                                          ).withValues(alpha: 0.1),
                                          foregroundColor: AppColors.of(
                                            context,
                                            'error',
                                          ),
                                          shape: const StadiumBorder(),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 10,
                                          ),
                                          elevation: 0,
                                          tapTargetSize: MaterialTapTargetSize
                                              .shrinkWrap,
                                          minimumSize: Size.zero,
                                        ),
                                        onPressed: ownedCount > 0
                                            ? () {
                                                sfx.playSell();
                                                onSellAsset(type);
                                              }
                                            : null,
                                        child: IconText(
                                          "Sell ($sellPrice [GEM])",
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ShinyButton(
                                        isShiny: canAfford,
                                        backgroundColor: canAfford
                                            ? AppColors.of(context, 'success')
                                            : Colors.transparent,
                                        foregroundColor: canAfford
                                            ? Colors.white
                                            : AppColors.of(
                                                context,
                                                'success',
                                              ),
                                        shape: canAfford
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
                                          horizontal: 14,
                                          vertical: 10,
                                        ),
                                        onPressed: () {
                                          sfx.playBuy();
                                          onBuyAsset(type);
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(width: 6),
                                            if (discount > 0) ...[
                                              Text(
                                                "$originalCost",
                                                style: TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontSize: 12,
                                                  color: AppColors.of(
                                                    context,
                                                    'onSurfaceVariant',
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                            ],
                                            IconText(
                                              "Buy ($discountedCost [GEM])",
                                            ),
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
                if (isWidescreenDesktop(context))
                  const ShortcutOverlayBanner(
                    screenId: 'assets_screen',
                    helpTip: "Buy and sell assets to grow your portfolio. Press [Esc] to go back.",
                    shortcuts: ["[Enter] Confirm", "[Esc] Back"],
                  ),
              ],
            ),

          ),
        );
      },
    );
  }
}
