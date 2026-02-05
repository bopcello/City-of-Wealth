import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../game_state.dart';

class CityTab extends StatefulWidget {
  final CareerState career;
  final int gems;
  final AssetInventory assets;
  final List<PlacedBuilding> cityLayout;
  final void Function(AssetType type, int amount) onBuyAsset;
  final void Function(PlacedBuilding building) onPlaceBuilding;

  const CityTab({
    super.key,
    required this.career,
    required this.gems,
    required this.assets,
    required this.cityLayout,
    required this.onBuyAsset,
    required this.onPlaceBuilding,
  });

  @override
  State<CityTab> createState() => _CityTabState();
}

class _CityTabState extends State<CityTab> {
  Building? _selectedBuilding;
  int? _hoveredX;
  int? _hoveredY;
  Offset _mousePos = Offset.zero;

  void _onTileHover(int? x, int? y) {
    setState(() {
      _hoveredX = x;
      _hoveredY = y;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedBuilding = null;
      _hoveredX = null;
      _hoveredY = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int gridSize = (widget.career.level - 1) * 2 + 1;

    return MouseRegion(
      onHover: (event) {
        setState(() {
          _mousePos = event.localPosition;
        });
      },
      child: GestureDetector(
        onTap: () {
          if (_selectedBuilding != null) {
            if (_hoveredX != null && _hoveredY != null) {
              final hasBuilding = widget.cityLayout.any(
                (b) => b.x == _hoveredX && b.y == _hoveredY,
              );
              if (!hasBuilding) {
                debugPrint(
                  "🏗️ PLACING ${_selectedBuilding!.name} at ($_hoveredX, $_hoveredY)",
                );
                widget.onPlaceBuilding(
                  PlacedBuilding(
                    name: _selectedBuilding!.name,
                    x: _hoveredX!,
                    y: _hoveredY!,
                  ),
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
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateX(-math.pi / 6)
                  ..rotateZ(math.pi / 4),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _IsometricGrid(
                      gridSize: gridSize,
                      cityLayout: widget.cityLayout,
                      hoveredX: _hoveredX,
                      hoveredY: _hoveredY,
                      onHover: _onTileHover,
                    ),
                    Positioned(child: _Palace()),
                  ],
                ),
              ),
            ),
            if (_selectedBuilding != null)
              Positioned(
                left: _mousePos.dx - 25,
                top: _mousePos.dy - 25,
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
                        child: Text(
                          _selectedBuilding!.name.characters.first,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
                        onSelect: (building) {
                          Navigator.pop(context);
                          setState(() {
                            _selectedBuilding = building;
                          });
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
    );
  }
}

class _BuildingsBottomSheet extends StatelessWidget {
  final CareerState career;
  final AssetInventory assets;
  final Function(Building) onSelect;
  final VoidCallback onClose;

  const _BuildingsBottomSheet({
    required this.career,
    required this.assets,
    required this.onSelect,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final available = buildings.where((b) => b.track == career.track);

    return Container(
      height: 360,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black26)],
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
  final VoidCallback onSelect;

  const _BuildingCard({
    required this.building,
    required this.career,
    required this.assets,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final hasLevel = career.level >= building.requiredLevel;

    final hasAssets = building.requirements.entries.every(
      (e) => assets.count(e.key) >= e.value,
    );

    final canBuild = hasLevel && hasAssets;

    final widgetCard = Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: canBuild ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Row(
        children: [
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
                  "Requires level ${building.requiredLevel}",
                  style: TextStyle(
                    fontSize: 12,
                    color: hasLevel ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: building.requirements.entries.map((e) {
              final owned = assets.count(e.key);
              return Text(
                "${assetLabel(e.key)}: ${e.value}",
                style: TextStyle(
                  color: owned >= e.value ? Colors.green : Colors.red,
                ),
              );
            }).toList(),
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
  final List<PlacedBuilding> cityLayout;
  final int? hoveredX;
  final int? hoveredY;
  final Function(int?, int?) onHover;

  const _IsometricGrid({
    required this.gridSize,
    required this.cityLayout,
    required this.hoveredX,
    required this.hoveredY,
    required this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    const double tileSize = 50;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(gridSize, (y) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(gridSize, (x) {
            final buildingAt = cityLayout.where((b) => b.x == x && b.y == y);
            final hasBuilding = buildingAt.isNotEmpty;
            final isHovered = x == hoveredX && y == hoveredY;

            return MouseRegion(
              onEnter: (_) => onHover(x, y),
              onExit: (_) => onHover(null, null),
              child: Container(
                width: tileSize,
                height: tileSize,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: isHovered
                      ? (hasBuilding
                            ? Colors.red.shade200
                            : Colors.blue.shade200)
                      : Colors.green.shade300,
                  border: Border.all(color: Colors.green.shade700),
                ),
                child: hasBuilding
                    ? Center(
                        child: Text(
                          buildingAt.first.name.characters.first,
                          style: const TextStyle(fontSize: 32),
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
      child: const Center(child: Text("🏰", style: TextStyle(fontSize: 36))),
    );
  }
}
