import 'package:city_of_wealth/services/sfx_manager.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/city_sharing_models.dart';
import '../game_state.dart';
import '../theme/app_colors.dart';
import '../services/friends_service.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/shiny_button.dart';

class CityViewerScreen extends StatefulWidget {
  final PublicCitySnapshot snapshot;
  final String myPlayerName;
  final SfxManager sfx;

  const CityViewerScreen({
    super.key,
    required this.snapshot,
    required this.myPlayerName,
    required this.sfx,
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
    widget.sfx.playClick();
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

                final double side =
                    gridSize * 52.0 +
                    200.0; // Account for the padding of 100 on each side
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
                              color: AppColors.of(context, 'kp'),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 6,
                                  offset: Offset(2, 4),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.shadow.withValues(alpha: 0.26),
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
                    ProfileAvatar(
                      profilePic: widget.snapshot.profilePic,
                      fallbackName: widget.snapshot.playerName,
                      radius: 24,
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
                            Icon(
                              Icons.flash_on,
                              color: AppColors.of(context, 'warning'),
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
                            Icon(
                              Icons.workspace_premium,
                              color: AppColors.of(context, 'kp'),
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

          // Cheer / Uncheer Floating Action Button (Item #32 with YouTube style pop & particle burst)
          Positioned(
            bottom: 24,
            right: 24,
            child: AnimatedCheerButton(
              isCheered: _activeCheerDocId != null,
              isLoading: _cheerLoading,
              playerName: widget.snapshot.playerName,
              onPressed: _toggleCheer,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedCheerButton extends StatefulWidget {
  final bool isCheered;
  final bool isLoading;
  final String playerName;
  final VoidCallback onPressed;

  const AnimatedCheerButton({
    super.key,
    required this.isCheered,
    required this.isLoading,
    required this.playerName,
    required this.onPressed,
  });

  @override
  State<AnimatedCheerButton> createState() => _AnimatedCheerButtonState();
}

class _AnimatedCheerButtonState extends State<AnimatedCheerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final List<_CheerParticle> _particles = [];
  bool? _justCheered;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.82), weight: 18),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.82,
          end: 1.25,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 52,
      ),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 1.0), weight: 30),
    ]).animate(_controller);

    _generateParticles();
  }

  void _generateParticles() {
    _particles.clear();
    final rand = math.Random();
    const particleIcons = [
      Icons.star,
      Icons.campaign,
      Icons.auto_awesome,
      Icons.favorite,
      Icons.bolt,
    ];
    const particleColors = [
      Color(0xFFFFD700),
      Color(0xFFFF4081),
      Color(0xFF00E5FF),
      Color(0xFF00E676),
      Color(0xFFFF9100),
    ];

    // 36 particles (3x particle count)
    for (int i = 0; i < 50; i++) {
      final angle = (i * 10 + rand.nextDouble() * 10) * math.pi / 180;
      final distance = 300.0 + rand.nextDouble() * 300.0;
      // Size randomized in range 0.1x to 2.5x of base 32.0px (3.2px to 80.0px)
      final scaleFactor = 0.1 + rand.nextDouble() * 2.4;
      final size = 32.0 * scaleFactor;
      _particles.add(
        _CheerParticle(
          angle: angle,
          distance: distance,
          icon: particleIcons[i % particleIcons.length],
          color: particleColors[i % particleColors.length],
          size: size,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    final bool willCheer = !widget.isCheered;
    setState(() {
      _justCheered = willCheer;
    });
    if (willCheer) {
      _generateParticles();
    } else {
      _particles.clear();
    }
    _controller.forward(from: 0.0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return FloatingActionButton(
        onPressed: null,
        backgroundColor: Theme.of(context).colorScheme.outline,
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }

    final bool isCheerSent = _justCheered ?? widget.isCheered;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;

        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // YouTube-style 360-degree Particle Explosion Burst (Only when cheer is being sent)
            if (isCheerSent && progress > 0.0 && progress < 1.0)
              ..._particles.map((p) {
                final curDistance = p.distance * progress;
                final opacity = (1.0 - progress).clamp(0.0, 1.0);
                final dx = math.cos(p.angle) * curDistance;
                final dy = math.sin(p.angle) * curDistance;
                final scale = (0.5 + progress * 0.8) * opacity;

                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: Transform.scale(
                    scale: scale,
                    child: Icon(
                      p.icon,
                      color: p.color.withValues(alpha: opacity),
                      size: p.size,
                    ),
                  ),
                );
              }),

            // Floating Toast/Label pop
            if (progress > 0.08 && progress < 0.95)
              Positioned(
                top: -45 - (progress * 30),
                child: Opacity(
                  opacity: (1.0 - progress).clamp(0.0, 1.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isCheerSent
                          ? AppColors.of(context, 'success')
                          : AppColors.of(context, 'error'),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: isCheerSent
                              ? AppColors.of(context, 'success')
                              : AppColors.of(context, 'error'),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      isCheerSent ? "Cheered!" : "Cheer Removed",
                      style: TextStyle(
                        color: AppColors.of(context, 'onSurface'),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

            // Shiny Animated Floating Button (Item #32)
            Transform.scale(
              scale: _scaleAnimation.value,
              child: ShinyWidgetWrapper(
                isShiny: !widget.isCheered,
                borderRadius: BorderRadius.circular(28),
                child: FloatingActionButton.extended(
                  onPressed: _handleTap,
                  elevation: widget.isCheered ? 0 : 4,
                  backgroundColor: widget.isCheered
                      ? Theme.of(context).colorScheme.surface
                      : AppColors.of(context, 'kp'),
                  foregroundColor: widget.isCheered
                      ? AppColors.of(context, 'success')
                      : Colors.white,
                  shape: widget.isCheered
                      ? StadiumBorder(
                          side: BorderSide(
                            color: AppColors.of(context, 'success'),
                            width: 2.0,
                          ),
                        )
                      : const StadiumBorder(),
                  icon: Icon(
                    widget.isCheered ? Icons.campaign : Icons.campaign_outlined,
                  ),
                  label: Text(
                    widget.isCheered
                        ? "Undo Cheer"
                        : "Cheer ${widget.playerName}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CheerParticle {
  final double angle;
  final double distance;
  final IconData icon;
  final Color color;
  final double size;

  _CheerParticle({
    required this.angle,
    required this.distance,
    required this.icon,
    required this.color,
    required this.size,
  });
}
