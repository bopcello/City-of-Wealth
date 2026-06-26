import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LoadingScreen extends StatefulWidget {
  final double progress; // 0.0 to 1.0 (Kept for compatibility)

  const LoadingScreen({super.key, this.progress = 1.0});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gemColor = AppColors.of(context, 'gem');

    return Scaffold(
      backgroundColor: AppColors.of(context, 'background'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bigger Logo
            Image.asset('lib/assets/app_icon.png', height: 120),
            const SizedBox(height: 24),
            // Bigger Title
            Text(
              "City of Wealth",
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.of(context, 'onBackground'),
              ),
            ),
            const SizedBox(height: 80),
            // Spinning Gem Indicator
            RotationTransition(
              turns: _rotationController,
              child: Icon(
                Icons.diamond_outlined,
                color: gemColor,
                size: 80,
                shadows: [
                  Shadow(
                    color: gemColor.withValues(alpha: 0.5),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            // Subtext
            Text(
              "Master your Money",
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.of(context, 'onSurfaceVariant'),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
