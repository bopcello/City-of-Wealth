import 'package:flutter/material.dart';
import '../game_state.dart';

class AssetsScreen extends StatefulWidget {
  final AssetInventory assets;
  final int gems;
  final void Function(AssetType type) onBuyAsset;

  const AssetsScreen({
    super.key,
    required this.assets,
    required this.gems,
    required this.onBuyAsset,
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
              child: Text(
                "Gems: $_currentGems 💎",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: AssetType.values.map((type) {
          final cost = assetCost(type);
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    assetLabel(type),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Text("Owned: ${_currentAssets.count(type)}"),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _currentGems >= cost
                      ? () {
                          setState(() {
                            _currentGems -= cost;
                            _currentAssets = _currentAssets.add(type, 1);
                          });
                          widget.onBuyAsset(type);
                        }
                      : null,
                  child: Text("Buy ($cost 💎)"),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
