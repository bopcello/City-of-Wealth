import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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
    });
    _hoveredX.value = null;
    _hoveredY.value = null;
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
            if (_selectedBuilding != null) {
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
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateX(-math.pi / 6)
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(gridSize, (y) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(gridSize, (x) {
            final buildingAt = cityMap["$x,$y"];
            final hasBuilding = buildingAt != null;

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
                                ? Colors.red.shade200
                                : Colors.blue.shade200)
                          : Colors.green.shade300,
                      border: Border.all(color: Colors.green.shade700),
                    ),
                    child: child,
                  );
                },
                child: hasBuilding
                    ? Center(
                        child: Text(
                          buildingAt.name.characters.first,
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
      child: const Center(child: Text("🏰", style: TextStyle(fontSize: 36))),
    );
  }
}
