import 'package:flutter/material.dart';
import '../game_state.dart';
import '../widgets/icon_text.dart';
import '../widgets/counter_chip.dart';

class AssetsScreen extends StatefulWidget {
  final AssetInventory assets;
  final int gems;
  final void Function(AssetType type) onBuyAsset;
  final void Function(AssetType type) onSellAsset;

  const AssetsScreen({
    super.key,
    required this.assets,
    required this.gems,
    required this.onBuyAsset,
    required this.onSellAsset,
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
          final cost = assetCosts[type]!;
          final sellPrice = assetSellPrice(type);
          final canAfford = _currentGems >= cost;
          final ownedCount = _currentAssets.count(type);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: canAfford
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                    : Colors.red.withOpacity(0.5),
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
                        backgroundColor: Colors.red.withOpacity(0.1),
                        foregroundColor: Colors.red.shade400,
                      ),
                      onPressed: ownedCount > 0
                          ? () {
                              setState(() {
                                _currentGems += sellPrice;
                                _currentAssets = _currentAssets.add(type, -1);
                              });
                              widget.onSellAsset(type);
                            }
                          : null,
                      child: IconText("Sell ($sellPrice [GEM])"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canAfford ? Colors.green : null,
                        foregroundColor: canAfford ? Colors.white : null,
                      ),
                      onPressed: () {
                        setState(() {
                          _currentGems -= cost;
                          _currentAssets = _currentAssets.add(type, 1);
                        });
                        widget.onBuyAsset(type);
                      },
                      child: IconText("Buy ($cost [GEM])"),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
