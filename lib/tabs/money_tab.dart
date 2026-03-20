import 'package:flutter/material.dart';
import '../game_state.dart';
import '../services/music_manager.dart';
import '../services/sfx_manager.dart';
import '../screens/quiz_screen.dart';
import '../screens/career_screen.dart';
import '../screens/assets_screen.dart';
import '../screens/liabilities_screen.dart';
import '../screens/passive_income_screen.dart';

import '../logic/game_manager.dart';

class MoneyTab extends StatelessWidget {
  final GameManager game;
  final MusicManager music;
  final SfxManager sfx;
  final int currentKp;
  final void Function(int) onKpChange;
  final CareerState career;
  final int gems;
  final AssetInventory assets;
  final void Function(CareerState) onCareerChange;
  final void Function(AssetType, int) onBuyAsset;
  final RentType? rent;
  final FoodType? food;
  final TransportType? transport;
  final List<PlacedBuilding> cityLayout;
  final Set<AssetType> insurances;
  final void Function(RentType?, FoodType?, TransportType?) onLiabilitiesChange;
  final void Function(AssetType) onInsuranceToggle;
  final void Function(AssetType) onSellAsset;
  final VoidCallback onBankruptcy;
  final int bankruptcyCount;
  final Set<String> completedQuizzes;
  final void Function(String) onQuizComplete;
  final bool isWorkingOvertime;
  final VoidCallback onWorkOvertime;
  final Map<AssetType, int> activePassiveIncomes;
  final void Function(AssetType) onInvestInPassiveIncome;
  final Listenable? gameListenable;
  final String playerName;

  const MoneyTab({
    super.key,
    required this.game,
    required this.music,
    required this.sfx,
    required this.currentKp,
    required this.onKpChange,
    required this.career,
    required this.playerName,
    required this.gems,
    required this.assets,
    required this.onCareerChange,
    required this.onBuyAsset,
    required this.rent,
    required this.food,
    required this.transport,
    required this.cityLayout,
    required this.insurances,
    required this.onLiabilitiesChange,
    required this.onInsuranceToggle,
    required this.onSellAsset,
    required this.onBankruptcy,
    required this.bankruptcyCount,
    required this.completedQuizzes,
    required this.onQuizComplete,
    required this.isWorkingOvertime,
    required this.onWorkOvertime,
    required this.activePassiveIncomes,
    required this.onInvestInPassiveIncome,
    this.gameListenable,
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
              sfx.playClick();
              if (item.title == "Quiz") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizMenuScreen(
                      game: game,
                      music: music,
                      sfx: sfx,
                    ),
                  ),
                );
              }
              if (item.title == "Career") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CareerScreen(game: game, sfx: sfx),
                  ),
                );
              }
              if (item.title == "Assets") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AssetsScreen(
                      assets: game.assets,
                      gems: game.gems,
                      streak: game.dailyQuizStreak,
                      onBuyAsset: (type) => game.buyAsset(type, 1, context),
                      onSellAsset: (type) => game.sellAsset(type),
                      sfx: sfx,
                      game: game,
                    ),
                  ),
                );
              }
              if (item.title == "Liabilities") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LiabilitiesScreen(
                      game: game,
                      currentRent: rent,
                      currentFood: food,
                      currentTransport: transport,
                      onSelectionChanged: onLiabilitiesChange,
                      sfx: sfx,
                    ),
                  ),
                );
              }
              if (item.title == "Passive Income") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PassiveIncomeScreen(game: game, sfx: sfx),
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
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: const Offset(1, 2),
              color: Colors.black.withValues(alpha: 0.0),
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
