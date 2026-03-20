import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;
import '../widgets/icon_text.dart';
import '../theme/app_colors.dart';
import '../services/sfx_manager.dart';
import '../game_state.dart';
import '../logic/game_manager.dart';

class CityTab extends StatefulWidget {
  final CareerState career;
  final int gems;
  final AssetInventory assets;
  final List<PlacedBuilding> cityLayout;
  final Set<AssetType> insurances;
  final Map<AssetType, int> activePassiveIncomes;
  final bool hasWall;
  final void Function(AssetType type, int amount) onBuyAsset;
  final void Function(PlacedBuilding building) onPlaceBuilding;
  final void Function(PlacedBuilding building) onRemoveBuilding;
  final VoidCallback onBuyWall;
  final SfxManager sfx;
  final GameManager game;

  const CityTab({
    super.key,
    required this.career,
    required this.gems,
    required this.assets,
    required this.cityLayout,
    required this.insurances,
    required this.activePassiveIncomes,
    required this.hasWall,
    required this.onBuyAsset,
    required this.onPlaceBuilding,
    required this.onRemoveBuilding,
    required this.onBuyWall,
    required this.sfx,
    required this.game,
  });

  @override
  State<CityTab> createState() => _CityTabState();
}

class _CityTabState extends State<CityTab> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _clearSelection() {
    widget.game.clearSelection();
  }

  void _toggleEditMode() {
    widget.game.toggleEditMode();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, PlacedBuilding> cityMap = {
      for (var b in widget.cityLayout) "${b.x},${b.y}": b,
    };
    final int gridSize = (widget.career.level - 1) * 2 + 1;

    return GestureDetector(
      onTap: () {
        if (widget.game.selectedBuilding != null) {
          if (widget.game.isEditMode) {
            widget.game.setBuildingSelection(null);
          } else {
            _clearSelection();
          }
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (_transformationController.value == Matrix4.identity()) {
            final double vw = constraints.maxWidth;
            final double vh = constraints.maxHeight;

            final double side = gridSize * 52.0;
            final double tx = (vw - side) / 2;
            final double ty = (vh - side) / 2;

            _transformationController.value = Matrix4.identity()
              ..translate(tx, ty);
          }

          return Stack(
            children: [
              Container(color: Colors.transparent),
              InteractiveViewer(
                transformationController: _transformationController,
                constrained: false,
                boundaryMargin: const EdgeInsets.all(500),
                minScale: 0.1,
                maxScale: 2.5,
                child: RepaintBoundary(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (widget.hasWall)
                        Transform.translate(
                          offset: const Offset(0, 45),
                          child: Transform.scale(
                            scale: 1.8,
                            child: Image.asset(
                              "lib/assets/buildings/The Keystone.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..rotateX(-math.pi / 3.5)
                          ..rotateZ(math.pi / 4),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(100),
                              child: _IsometricGrid(
                                gridSize: gridSize,
                                cityMap: cityMap,
                                selectedBuilding: widget.game.selectedBuilding,
                                isEditMode: widget.game.isEditMode,
                                onTileTap: (x, y) {
                                  final buildingKey = "$x,$y";
                                  final hasBuilding = cityMap.containsKey(
                                    buildingKey,
                                  );

                                  if (widget.game.selectedBuilding != null) {
                                    if (hasBuilding) {
                                      if (widget.game.isEditMode) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Cell is already occupied",
                                            ),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      }
                                      return;
                                    }
                                    widget.sfx.playBuy();
                                    widget.onPlaceBuilding(
                                      PlacedBuilding(
                                        name:
                                            widget.game.selectedBuilding!.name,
                                        x: x,
                                        y: y,
                                      ),
                                    );
                                    if (widget.game.isEditMode) {
                                      widget.game.setBuildingSelection(null);
                                    } else {
                                      _clearSelection();
                                    }
                                  } else if (widget.game.isEditMode &&
                                      hasBuilding) {
                                    final building = cityMap[buildingKey]!;
                                    widget.game.setBuildingSelection(
                                      buildings.firstWhere(
                                        (b) => b.name == building.name,
                                      ),
                                    );
                                    widget.onRemoveBuilding(building);
                                  }
                                },
                              ),
                            ),
                            Positioned(child: _Palace()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.game.selectedBuilding != null)
                Positioned(
                  left: 16,
                  top: 16,
                  child: Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.of(context, 'kp').withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.of(context, 'success'),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      widget.game.selectedBuilding!.iconPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              Positioned(
                right: 16,
                bottom: 90,
                child: FloatingActionButton.extended(
                  heroTag: "city_layout_fab",
                  onPressed: () {
                    widget.sfx.playClick();
                    _toggleEditMode();
                  },
                  label: Text(widget.game.isEditMode ? "Done" : "Edit layout"),
                  icon: Icon(widget.game.isEditMode ? Icons.check : Icons.edit),
                  backgroundColor: widget.game.isEditMode
                      ? AppColors.of(context, 'success')
                      : null,
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton.extended(
                  heroTag: "city_add_fab",
                  onPressed: () {
                    widget.sfx.playClick();
                    // Close edit mode if it's on
                    if (widget.game.isEditMode) {
                      widget.game.toggleEditMode();
                    }
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      builder: (_) {
                        return _BuildingsBottomSheet(
                          career: widget.career,
                          gems: widget.gems,
                          assets: widget.assets,
                          insurances: widget.insurances,
                          activePassiveIncomes: widget.activePassiveIncomes,
                          hasWall: widget.hasWall,
                          sfx: widget.sfx,
                          onSelect: (building) {
                            if (building.name == "The Keystone") {
                              widget.sfx.playBuy();
                              widget.onBuyWall();
                              Navigator.pop(context);
                            } else {
                              widget.sfx.playClick();
                              Navigator.pop(context);
                              setState(() {
                                widget.game.setBuildingSelection(building);
                              });
                            }
                          },
                          onClose: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                  label: const Text("Add buildings"),
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BuildingsBottomSheet extends StatelessWidget {
  final CareerState career;
  final int gems;
  final AssetInventory assets;
  final Set<AssetType> insurances;
  final Map<AssetType, int> activePassiveIncomes;
  final bool hasWall;
  final SfxManager sfx;
  final Function(Building) onSelect;
  final VoidCallback onClose;

  const _BuildingsBottomSheet({
    required this.career,
    required this.gems,
    required this.assets,
    required this.insurances,
    required this.activePassiveIncomes,
    required this.hasWall,
    required this.sfx,
    required this.onSelect,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final available = buildings.where((b) {
      if (b.name == "The Keystone") {
        // Only show Keystone if: Level 5, all 5 insurances, and not already owned
        if (hasWall) return false;
        if (career.level < 5) return false;
        if (insurances.length < 5) return false;
        return true;
      }

      final isPassiveIncomeBuilding = passiveIncomeData.values.any(
        (info) => info.buildingName == b.name,
      );
      if (isPassiveIncomeBuilding) {
        final passiveInfo = passiveIncomeData.values.firstWhere(
          (info) => info.buildingName == b.name,
        );
        final investedCount = activePassiveIncomes[passiveInfo.assetType] ?? 0;
        return investedCount > 0;
      }

      // Show if it matches career track and level
      return b.track == career.track && career.level >= b.requiredLevel;
    });

    return Container(
      height: 360,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black54
                : Colors.black12,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Available Buildings",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close), onPressed: onClose),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: available.isEmpty
                ? Center(
                    child: Text(
                      "No buildings available yet.\nAdvance your career to unlock construction.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView(
                    children: available
                        .map(
                          (b) => _BuildingCard(
                            building: b,
                            career: career,
                            gems: gems,
                            assets: assets,
                            insurances: insurances,
                            onSelect: () => onSelect(b),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _BuildingCard extends StatelessWidget {
  final Building building;
  final CareerState career;
  final int gems;
  final AssetInventory assets;
  final Set<AssetType> insurances;
  final VoidCallback onSelect;

  const _BuildingCard({
    required this.building,
    required this.career,
    required this.gems,
    required this.assets,
    required this.insurances,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isKeystone = building.name == "The Keystone";
    final isLevel5 = career.level >= 5;
    final hasAllInsurances = insurances.length >= 5;
    final isPassive = passiveIncomeData.values.any(
      (info) => info.buildingName == building.name,
    );

    // Keystone Requirements: Level 5 + 5 Insurances (simplified check)
    bool canBuild = false;
    final hasAssetRequirements = building.requirements.entries.every(
      (e) => assets.count(e.key) >= e.value,
    );

    if (isKeystone) {
      canBuild = isLevel5 && hasAllInsurances;
    } else {
      canBuild = career.level >= building.requiredLevel && hasAssetRequirements;
    }

    final hasPassiveInvestment =
        isPassive &&
        gems >=
            passiveIncomeData.values
                .firstWhere((e) => e.buildingName == building.name)
                .investmentCost;

    final hasLevel = isKeystone
        ? isLevel5
        : career.level >= building.requiredLevel;

    final widgetCard = Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: canBuild
              ? AppColors.of(context, 'success')
              : AppColors.of(context, 'error'),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              building.iconPath,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  building.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Level: ${building.requiredLevel}",
                  style: TextStyle(
                    fontSize: 12,
                    color: hasLevel
                        ? AppColors.of(context, 'success')
                        : AppColors.of(context, 'error'),
                  ),
                ),
                if (building.requirements.isNotEmpty) ...[
                  IconText(
                    "Requires: ${building.requirements.entries.map((e) => "${e.value} ${assetLabel(e.key)}").join(", ")}",
                    style: const TextStyle(fontSize: 12),
                    color: hasAssetRequirements
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : AppColors.of(context, 'error'),
                  ),
                  if (building.name == "The Keystone")
                    IconText(
                      "Special: Requires all 5 Insurances",
                      style: const TextStyle(fontSize: 12),
                      color: hasAllInsurances
                          ? AppColors.of(context, 'gem')
                          : AppColors.of(context, 'error'),
                    ),
                ] else if (isPassive) ...[
                  IconText(
                    "Passive Income Building",
                    style: const TextStyle(fontSize: 12),
                    color: AppColors.of(context, 'success'),
                  ),
                ],
              ],
            ),
          ),
          if (canBuild)
            Icon(Icons.check_circle, color: AppColors.of(context, 'success'))
          else
            Icon(
              Icons.lock,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 16,
            ),
        ],
      ),
    );

    if (canBuild) {
      return GestureDetector(onTap: onSelect, child: widgetCard);
    }

    return widgetCard;
  }
}

class _IsometricGrid extends StatelessWidget {
  final int gridSize;
  final Map<String, PlacedBuilding> cityMap;
  final Building? selectedBuilding;
  final bool isEditMode;
  final Function(int, int) onTileTap;

  const _IsometricGrid({
    required this.gridSize,
    required this.cityMap,
    required this.selectedBuilding,
    required this.isEditMode,
    required this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    const double tileSize = 50;

    final int half = (gridSize - 1) ~/ 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(gridSize, (row) {
        final y = row - half;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(gridSize, (col) {
            final x = col - half;

            final placedBuilding = cityMap["$x,$y"];
            final hasBuilding = placedBuilding != null;
            final building = hasBuilding
                ? buildings.firstWhere((b) => b.name == placedBuilding.name)
                : null;

            return GestureDetector(
              onTap: () => onTileTap(x, y),
              child: Builder(
                builder: (context) {
                  Color cellColor;

                  if (selectedBuilding != null) {
                    // Building is selected for placement
                    if (!hasBuilding) {
                      // Empty cells highlighted in blue
                      cellColor = AppColors.of(
                        context,
                        'gem',
                      ).withValues(alpha: 0.6);
                    } else {
                      // Occupied cells highlighted in red
                      cellColor = AppColors.of(
                        context,
                        'error',
                      ).withValues(alpha: 0.6);
                    }
                  } else {
                    // No building selected - show default green grid
                    cellColor = AppColors.of(
                      context,
                      'gridGreen',
                    ).withValues(alpha: 0.5);
                  }

                  return Container(
                    width: tileSize,
                    height: tileSize,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: cellColor,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: hasBuilding
                        ? Center(
                            child: Image.asset(
                              building!.iconPath,
                              width: tileSize * 0.8,
                              height: tileSize * 0.8,
                              fit: BoxFit.contain,
                            ),
                          )
                        : null,
                  );
                },
              ),
            );
          }),
        );
      }),
    );
  }
}

class _Palace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.amber.shade600,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(blurRadius: 6, offset: Offset(2, 4), color: Colors.black26),
        ],
      ),
      child: Center(
        child: Image.asset(
          "lib/assets/buildings/palace.png",
          width: 48,
          height: 48,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
