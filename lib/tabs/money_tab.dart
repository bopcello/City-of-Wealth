import 'package:flutter/material.dart';
import '../game_state.dart';
import '../screens/quiz_screen.dart';
import '../screens/career_screen.dart';
import '../screens/assets_screen.dart';

class MoneyTab extends StatelessWidget {
  final int currentKp;
  final void Function(int) onKpChange;
  final CareerState career;
  final int gems;
  final AssetInventory assets;
  final void Function(CareerState) onCareerChange;
  final void Function(AssetType, int) onBuyAsset;

  const MoneyTab({
    super.key,
    required this.currentKp,
    required this.onKpChange,
    required this.career,
    required this.gems,
    required this.assets,
    required this.onCareerChange,
    required this.onBuyAsset,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _MoneyTileData("Career", Icons.badge),
      _MoneyTileData("Passive Income", Icons.trending_up),
      _MoneyTileData("Assets", Icons.account_balance),
      _MoneyTileData("Liabilities", Icons.warning),
      _MoneyTileData("Quiz", Icons.quiz),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _MoneyTile(
            data: item,
            onTap: () {
              if (item.title == "Quiz") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizMenuScreen(
                      currentKp: currentKp,
                      onKpChange: onKpChange,
                    ),
                  ),
                );
              }
              if (item.title == "Career") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CareerScreen(
                      career: career,
                      currentKp: currentKp,
                      onCareerChange: onCareerChange,
                    ),
                  ),
                );
              }
              if (item.title == "Assets") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AssetsScreen(
                      assets: assets,
                      gems: gems,
                      onBuyAsset: (type) => onBuyAsset(type, 1),
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class _MoneyTileData {
  final String title;
  final IconData icon;

  _MoneyTileData(this.title, this.icon);
}

class _MoneyTile extends StatelessWidget {
  final _MoneyTileData data;
  final VoidCallback onTap;

  const _MoneyTile({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              offset: Offset(2, 4),
              color: Colors.black12,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(data.icon, size: 42),
            const SizedBox(height: 12),
            Text(
              data.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
