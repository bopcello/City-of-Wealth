import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;
import '../widgets/icon_text.dart';
import '../game_state.dart';

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
  });

  @override
  State<CityTab> createState() => _CityTabState();
}

class _CityTabState extends State<CityTab> {
  Building? _selectedBuilding;
  bool _isEditMode = false; // Track edit mode state
  final ValueNotifier<int?> _hoveredX = ValueNotifier(null);
  final ValueNotifier<int?> _hoveredY = ValueNotifier(null);
  final ValueNotifier<Offset> _mousePos = ValueNotifier(Offset.zero);
  double _zoomScale = 1.0;

  @override
  void initState() {
    super.initState();
    _updateAutoZoom();
  }

  @override
  void didUpdateWidget(CityTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.career.level != widget.career.level) {
      _updateAutoZoom();
    }
  }

  void _updateAutoZoom() {
    final int gridSize = (widget.career.level - 1) * 2 + 1;
    if (gridSize >= 9) {
      _zoomScale = 0.6; // Level 5+
    } else if (gridSize >= 7) {
      _zoomScale = 0.8; // Level 4
    } else {
      _zoomScale = 1.0;
    }
  }

  void _onTileHover(int? x, int? y) {
    _hoveredX.value = x;
    _hoveredY.value = y;
  }

  void _clearSelection() {
    setState(() {
      _selectedBuilding = null;
      _isEditMode = false;
    });
    _hoveredX.value = null;
    _hoveredY.value = null;
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      _selectedBuilding = null; // Clear any building selection
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, PlacedBuilding> cityMap = {
      for (var b in widget.cityLayout) "${b.x},${b.y}": b,
    };
    final int gridSize = (widget.career.level - 1) * 2 + 1;

    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          setState(() {
            _zoomScale = (_zoomScale - pointerSignal.scrollDelta.dy / 1000)
                .clamp(0.3, 2.0);
          });
        }
      },
      child: MouseRegion(
        onHover: (event) {
          _mousePos.value = event.localPosition;
        },
        child: GestureDetector(
          onTap: () {
            if (_isEditMode) {
              // Edit mode: select building to move it
              final hX = _hoveredX.value;
              final hY = _hoveredY.value;
              if (hX != null && hY != null) {
                final buildingKey = "$hX,$hY";
                if (cityMap.containsKey(buildingKey)) {
                  // Select the building and remove it from current position
                  final building = cityMap[buildingKey]!;
                  debugPrint(
                    "✏️ SELECTING ${building.name} at ($hX, $hY) for move",
                  );
                  setState(() {
                    _selectedBuilding = buildings.firstWhere(
                      (b) => b.name == building.name,
                    );
                  });
                  widget.onRemoveBuilding(building);
                } else if (_selectedBuilding != null) {
                  // Place the selected building at new location
                  debugPrint(
                    "🏗️ PLACING ${_selectedBuilding!.name} at ($hX, $hY)",
                  );
                  widget.onPlaceBuilding(
                    PlacedBuilding(name: _selectedBuilding!.name, x: hX, y: hY),
                  );
                  // Clear only the selection, stay in edit mode
                  setState(() {
                    _selectedBuilding = null;
                  });
                }
              }
            } else if (_selectedBuilding != null) {
              // Placement mode: place building
              final hX = _hoveredX.value;
              final hY = _hoveredY.value;
              if (hX != null && hY != null) {
                final hasBuilding = cityMap.containsKey("$hX,$hY");
                if (!hasBuilding) {
                  debugPrint(
                    "🏗️ PLACING ${_selectedBuilding!.name} at ($hX, $hY)",
                  );
                  widget.onPlaceBuilding(
                    PlacedBuilding(name: _selectedBuilding!.name, x: hX, y: hY),
                  );
                } else {
                  debugPrint("🚫 Cell occupied");
                }
              } else {
                debugPrint("❌ Placement cancelled");
              }
              _clearSelection();
            }
          },
          child: Stack(
            children: [
              Container(color: Colors.transparent), // Catch all taps
              Center(
                child: RepaintBoundary(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Wall image with independent transform tied to zoom
                      if (widget.hasWall)
                        Transform.translate(
                          offset: const Offset(0, 45) * _zoomScale,
                          child: Transform.scale(
                            scale: 1.8 * _zoomScale,
                            child: Image.asset(
                              "lib/assets/The Keystone.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      // Isometric grid with its own transform
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..rotateX(-math.pi / 3.5)
                          ..rotateZ(math.pi / 4)
                          ..scaleByDouble(_zoomScale, _zoomScale, 1.0, 1.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            _IsometricGrid(
                              gridSize: gridSize,
                              cityMap: cityMap,
                              hoveredXNotifier: _hoveredX,
                              hoveredYNotifier: _hoveredY,
                              onHover: _onTileHover,
                            ),
                            Positioned(child: _Palace()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_selectedBuilding != null)
                ValueListenableBuilder<Offset>(
                  valueListenable: _mousePos,
                  builder: (context, pos, child) {
                    final size = 50 * _zoomScale;
                    return Positioned(
                      left: pos.dx - size / 2,
                      top: pos.dy - size / 2,
                      child: Transform.scale(scale: _zoomScale, child: child!),
                    );
                  },
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.7,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.amber.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Image.asset(
                            _selectedBuilding!.iconPath,
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              // Edit button (bottom right, above Add buildings button)
              Positioned(
                right: 16,
                bottom: 90, // Position above the "Add buildings" button
                child: FloatingActionButton.extended(
                  onPressed: _toggleEditMode,
                  label: Text(_isEditMode ? "Done" : "Edit layout"),
                  icon: Icon(_isEditMode ? Icons.check : Icons.edit),
                  backgroundColor: _isEditMode ? Colors.green : null,
                ),
              ),
              // Add buildings button
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton.extended(
                  onPressed: () {
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
                          assets: widget.assets,
                          insurances: widget.insurances,
                          activePassiveIncomes: widget.activePassiveIncomes,
                          hasWall: widget.hasWall,
                          onSelect: (building) {
                            if (building.name == "The Keystone") {
                              widget.onBuyWall();
                              Navigator.pop(context);
                            } else {
                              Navigator.pop(context);
                              setState(() {
                                _selectedBuilding = building;
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
          ),
        ),
      ),
    );
  }
}

class _BuildingsBottomSheet extends StatelessWidget {
  final CareerState career;
  final AssetInventory assets;
  final Set<AssetType> insurances;
  final Map<AssetType, int> activePassiveIncomes;
  final bool hasWall;
  final Function(Building) onSelect;
  final VoidCallback onClose;

  const _BuildingsBottomSheet({
    required this.career,
    required this.assets,
    required this.insurances,
    required this.activePassiveIncomes,
    required this.hasWall,
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

      // Show if it matches career track OR if it's an invested passive income building
      if (b.track == career.track) return true;

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

      return false;
    });

    return Container(
      height: 360,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black26)],
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
                ? const Center(
                    child: Text(
                      "No buildings available yet.\nAdvance your career to unlock construction.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView(
                    children: available
                        .map(
                          (b) => _BuildingCard(
                            building: b,
                            career: career,
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
  final AssetInventory assets;
  final Set<AssetType> insurances;
  final VoidCallback onSelect;

  const _BuildingCard({
    required this.building,
    required this.career,
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
    if (isKeystone) {
      canBuild = isLevel5 && hasAllInsurances;
    } else {
      canBuild =
          career.level >= building.requiredLevel &&
          building.requirements.entries.every(
            (e) => assets.count(e.key) >= e.value,
          );
    }

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
          color: canBuild ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
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
                    color: hasLevel ? Colors.green : Colors.red,
                  ),
                ),
                if (building.requirements.isNotEmpty) ...[
                  IconText(
                    "Requires: ${building.requirements.entries.map((e) => "${e.value} ${assetLabel(e.key)}").join(", ")}",
                    style: const TextStyle(fontSize: 12),
                  ),
                  if (building.name == "The Keystone")
                    const IconText(
                      "Special: Requires all 5 Insurances",
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                ] else if (isPassive) ...[
                  const IconText(
                    "Passive Income Building",
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                  IconText(
                    "Cost: ${passiveIncomeData.values.firstWhere((e) => e.buildingName == building.name).investmentCost} [GEM]",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          if (canBuild)
            const Icon(Icons.check_circle, color: Colors.blue)
          else
            const Icon(Icons.lock, color: Colors.grey, size: 16),
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
  final ValueNotifier<int?> hoveredXNotifier;
  final ValueNotifier<int?> hoveredYNotifier;
  final Function(int?, int?) onHover;

  const _IsometricGrid({
    required this.gridSize,
    required this.cityMap,
    required this.hoveredXNotifier,
    required this.hoveredYNotifier,
    required this.onHover,
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

            return MouseRegion(
              onEnter: (_) => onHover(x, y),
              onExit: (_) => onHover(null, null),
              child: ValueListenableBuilder2<int?, int?>(
                first: hoveredXNotifier,
                second: hoveredYNotifier,
                builder: (context, hoveredX, hoveredY, child) {
                  final isHovered = x == hoveredX && y == hoveredY;
                  return Container(
                    width: tileSize,
                    height: tileSize,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: isHovered
                          ? (hasBuilding
                                ? Colors
                                      .blue
                                      .shade200 // Blue for occupied in edit mode
                                : Colors
                                      .red
                                      .shade200) // Red for empty in edit mode
                          : Colors.green.shade300,
                      border: Border.all(color: Colors.green.shade700),
                    ),
                    child: child,
                  );
                },
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
              ),
            );
          }),
        );
      }),
    );
  }
}

/// A helper class to listen to two [ValueListenable]s.
class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget? child;
  final Widget Function(BuildContext context, A a, B b, Widget? child) builder;

  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<A>(
    valueListenable: first,
    builder: (context, a, _) => ValueListenableBuilder<B>(
      valueListenable: second,
      builder: (context, b, _) => builder(context, a, b, child),
    ),
  );
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
