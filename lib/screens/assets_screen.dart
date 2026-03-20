import 'package:flutter/material.dart';
import '../game_state.dart';
import '../widgets/counter_chip.dart';
import '../services/sfx_manager.dart';

class AssetsScreen extends StatefulWidget {
  final AssetInventory assets;
  final int gems;
  final void Function(AssetType type) onBuyAsset;
  final void Function(AssetType type) onSellAsset;
  final int streak;
  final SfxManager sfx;

  const AssetsScreen({
    super.key,
    required this.assets,
    required this.gems,
    required this.onBuyAsset,
    required this.onSellAsset,
    required this.streak,
    required this.sfx,
  });

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  late AssetInventory _currentAssets;
  late int _currentGems;

  @override
  void initState() {
    super.initState();
    _currentAssets = widget.assets;
    _currentGems = widget.gems;
  }

  IconData assetIcon(AssetType type) {
    switch (type) {
      case AssetType.land:
        return Icons.landscape;
      case AssetType.properties:
        return Icons.business;
      case AssetType.machinery:
        return Icons.settings;
      case AssetType.vehicles:
        return Icons.directions_car;
      case AssetType.officeEquipment:
        return Icons.computer;
    }
  }

  String assetDescription(AssetType type) {
    switch (type) {
      case AssetType.land:
        return "Essential for farming and expansion.";
      case AssetType.properties:
        return "Generate rental income and house businesses.";
      case AssetType.machinery:
        return "Boost factory production and efficiency.";
      case AssetType.vehicles:
        return "Required for logistics and distribution.";
      case AssetType.officeEquipment:
        return "Necessary for IT and service centers.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assets"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: CounterChip(
                label: "Gems",
                value: _currentGems,
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
          final baseCost = assetCosts[type]!;
          final cost = assetCost(type, streak: widget.streak);
          final sellPrice = assetSellPrice(type);
          final canAfford = _currentGems >= cost;
          final ownedCount = _currentAssets.count(type);
          final hasDiscount = baseCost > cost;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(assetIcon(type), color: Theme.of(context).colorScheme.primary, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assetLabel(type),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              assetDescription(type),
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Owned: $ownedCount",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (hasDiscount)
                            Text(
                              "$baseCost [GEM]",
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          Text(
                            "$cost [GEM]",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: hasDiscount ? Colors.green : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: ownedCount > 0
                            ? () {
                                setState(() {
                                  _currentGems += sellPrice;
                                  _currentAssets = _currentAssets.add(type, -1);
                                });
                                widget.sfx.playSell();
                                widget.onSellAsset(type);
                              }
                            : null,
                        child: Text("Sell (+$sellPrice)"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canAfford ? Colors.green : null,
                          foregroundColor: canAfford ? Colors.white : null,
                        ),
                        onPressed: canAfford
                            ? () {
                                setState(() {
                                  _currentGems -= cost;
                                  _currentAssets = _currentAssets.add(type, 1);
                                });
                                widget.sfx.playBuy();
                                widget.onBuyAsset(type);
                              }
                            : null,
                        child: const Text("Buy One"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
