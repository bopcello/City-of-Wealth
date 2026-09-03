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
import '../logic/tutorial_keys.dart';
import '../widgets/focus_ring.dart';
import '../widgets/responsive_widescreen.dart';
import '../widgets/shortcut_overlay_banner.dart';

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
      _MoneyTileData("Career", Icons.badge, "1"),
      _MoneyTileData("Assets", Icons.account_balance, "2"),
      _MoneyTileData("Liabilities", Icons.warning, "3"),
      _MoneyTileData("Passive Income", Icons.trending_up, "4"),
      _MoneyTileData("Quiz", Icons.quiz, "5"),
    ];


    if (isWidescreenDesktop(context)) {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Money Hub Operations",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return FocusRing(
                        onPressed: () => _handleTileTap(context, item.title),
                        child: _MoneyTile(
                          data: item,
                          onTap: () => _handleTileTap(context, item.title),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const ShortcutOverlayBanner(
            screenId: 'money_tab',
            helpTip: "Press keys [1-5] to instantly jump into Career, Assets, Liabilities, Passive Income, or Quiz.",
            shortcuts: ["[1] Career", "[2] Assets", "[3] Liabilities", "[4] Passive Income", "[5] Quiz"],
          ),

        ],
      );
    }


    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24, left: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back,",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  playerName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
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
                Key? tileKey;
                if (item.title == "Career") tileKey = TutorialKeys.careerTileKey;
                if (item.title == "Passive Income") tileKey = TutorialKeys.passiveIncomeTileKey;
                if (item.title == "Assets") tileKey = TutorialKeys.assetsTileKey;
                if (item.title == "Liabilities") tileKey = TutorialKeys.liabilitiesTileKey;
                if (item.title == "Quiz") tileKey = TutorialKeys.quizTileKey;

                return _MoneyTile(
                  key: tileKey,
                  data: item,
                  onTap: () => _handleTileTap(context, item.title),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleTileTap(BuildContext context, String title) {
    sfx.playClick();
    game.visitMoneyTile(title);
    final nav = Navigator.of(context, rootNavigator: true);
    final isPoppable = nav.canPop();
    Widget? nextScreen;

    if (title == "Quiz") {
      nextScreen = QuizMenuScreen(game: game, music: music, sfx: sfx);
    } else if (title == "Career") {
      nextScreen = CareerScreen(game: game, sfx: sfx);
    } else if (title == "Assets") {
      nextScreen = AssetsScreen(
        assets: game.assets,
        gems: game.gems,
        streak: game.dailyQuizStreak,
        onBuyAsset: (type) => game.buyAsset(type, 1, context),
        onSellAsset: (type) => game.sellAsset(type),
        sfx: sfx,
        game: game,
      );
    } else if (title == "Liabilities") {
      nextScreen = LiabilitiesScreen(
        game: game,
        currentRent: rent,
        currentFood: food,
        currentTransport: transport,
        onSelectionChanged: onLiabilitiesChange,
        sfx: sfx,
      );
    } else if (title == "Passive Income") {
      nextScreen = PassiveIncomeScreen(game: game, sfx: sfx);
    }

    if (nextScreen != null) {
      if (isPoppable) {
        nav.pushReplacement(MaterialPageRoute(builder: (_) => nextScreen!));
      } else {
        nav.push(MaterialPageRoute(builder: (_) => nextScreen!));
      }
    }
  }

}

class _MoneyTileData {
  final String title;
  final IconData icon;
  final String hotkey;

  _MoneyTileData(this.title, this.icon, [this.hotkey = ""]);
}

class _MoneyTile extends StatelessWidget {
  final _MoneyTileData data;
  final VoidCallback onTap;

  const _MoneyTile({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: const Offset(1, 2),
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0),
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

