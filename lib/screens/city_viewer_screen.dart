import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/city_sharing_models.dart';
import '../game_state.dart';
import '../theme/app_colors.dart';
import '../services/friends_service.dart';

class CityViewerScreen extends StatefulWidget {
  final PublicCitySnapshot snapshot;
  final String myPlayerName;

  const CityViewerScreen({
    super.key,
    required this.snapshot,
    required this.myPlayerName,
  });

  @override
  State<CityViewerScreen> createState() => _CityViewerScreenState();
}

class _CityViewerScreenState extends State<CityViewerScreen> {
  final TransformationController _transformationController =
      TransformationController();
  final FriendsService _friendsService = FriendsService();

  // null  = not cheered yet (or cooldown expired)
  // non-null = activityDocId of the active cheer (still within 24 hrs)
  String? _activeCheerDocId;
  bool _cheerLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCheerStatus();
  }

  Future<void> _loadCheerStatus() async {
    try {
      final docId = await _friendsService.getCheerStatus(
        widget.snapshot.playerId,
      );
      if (mounted) {
        setState(() {
          _activeCheerDocId = docId;
        });
      }
    } catch (_) {
      // On any error just allow cheering (safe default)
    } finally {
      if (mounted) {
        setState(() {
          _cheerLoading = false;
        });
      }
    }
  }

  void _toggleCheer() async {
    if (_activeCheerDocId != null) {
      // --- Remove cheer ---
      final docId = _activeCheerDocId!;
      setState(() => _activeCheerDocId = null);
      try {
        await _friendsService.removeCheer(widget.snapshot.playerId, docId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Cheer removed from ${widget.snapshot.playerName}.",
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => _activeCheerDocId = docId); // revert
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to remove cheer: $e"),
              backgroundColor: AppColors.of(context, 'error'),
            ),
          );
        }
      }
    } else {
      // --- Send cheer ---
      try {
        final newDocId = await _friendsService.sendCheer(
          widget.snapshot.playerId,
          widget.myPlayerName,
        );
        if (mounted) {
          setState(() => _activeCheerDocId = newDocId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Sent cheer to ${widget.snapshot.playerName}!"),
              duration: const Duration(seconds: 2),
              backgroundColor: AppColors.of(context, 'success'),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to send cheer: $e"),
              backgroundColor: AppColors.of(context, 'error'),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, PlacedBuilding> cityMap = {
      for (var b in widget.snapshot.buildings) "${b.x},${b.y}": b,
    };
    final int gridSize = (widget.snapshot.level - 1) * 2 + 1;

    final careerTrack = CareerTrack.values.firstWhere(
      (e) => e.name == widget.snapshot.track,
      orElse: () => CareerTrack.student,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.snapshot.playerName}'s City"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // City Isometric view
          LayoutBuilder(
            builder: (context, constraints) {
              if (_transformationController.value == Matrix4.identity()) {
                final double vw = constraints.maxWidth;
                final double vh = constraints.maxHeight;

                final double side = gridSize * 52.0 + 200.0; // Account for the padding of 100 on each side
                final double tx = (vw - side) / 2;
                final double ty = (vh - side) / 2;

                _transformationController.value = Matrix4.translationValues(
                  tx,
                  ty,
                  0.0,
                );
              }

              return InteractiveViewer(
                transformationController: _transformationController,
                constrained: false,
                boundaryMargin: const EdgeInsets.all(500),
                minScale: 0.1,
                maxScale: 2.5,
                child: Center(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateX(-math.pi / 3.5)
                      ..rotateZ(math.pi / 4),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(100),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(gridSize, (row) {
                              final int half = (gridSize - 1) ~/ 2;
                              final y = row - half;
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(gridSize, (col) {
                                  final x = col - half;

                                  final placedBuilding = cityMap["$x,$y"];
                                  final hasBuilding = placedBuilding != null;
                                  final building = hasBuilding
                                      ? buildings.firstWhere(
                                          (b) => b.name == placedBuilding.name,
                                          orElse: () => buildings.first,
                                        )
                                      : null;

                                  Color cellColor = AppColors.of(
                                    context,
                                    'gridGreen',
                                  ).withValues(alpha: 0.5);

                                  return Container(
                                    width: 50,
                                    height: 50,
                                    margin: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: cellColor,
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.outline,
                                      ),
                                    ),
                                    child: hasBuilding
                                        ? Center(
                                            child: Image.asset(
                                              building!.iconPath,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.contain,
                                            ),
                                          )
                                        : null,
                                  );
                                }),
                              );
                            }),
                          ),
                        ),
                        // Yellow home square at the center of the grid
                        Positioned(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.amber.shade600,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 6,
                                  offset: Offset(2, 4),
                                  color: Colors.black26,
                                ),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // HUD overlay at the top
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              color: Theme.of(context).cardColor.withValues(alpha: 0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        widget.snapshot.playerName.isNotEmpty
                            ? widget.snapshot.playerName[0].toUpperCase()
                            : "?",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snapshot.playerName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "${widget.snapshot.title} · ${careerTrack == CareerTrack.student
                                ? 'Student'
                                : careerTrack == CareerTrack.business
                                ? 'Business'
                                : 'Job'}",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.flash_on,
                              color: Colors.orange,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${widget.snapshot.streak} Days",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.workspace_premium,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${widget.snapshot.kp} KP",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Cheer / Uncheer Floating Action Button
          Positioned(
            bottom: 24,
            right: 24,
            child: _cheerLoading
                ? const FloatingActionButton(
                    onPressed: null,
                    backgroundColor: Colors.grey,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                : FloatingActionButton.extended(
                    onPressed: _toggleCheer,
                    label: Text(
                      _activeCheerDocId != null ? "Undo Cheer" : "Cheer!",
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
