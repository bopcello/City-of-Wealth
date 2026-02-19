import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.of(context, 'background'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset('lib/assets/app_icon.png', height: 120),
            const SizedBox(height: 16),
            // Title
            Text(
              "City of Wealth",
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.of(context, 'onBackground'),
              ),
            ),
            const SizedBox(height: 8),
            // Subtext
            Text(
              "Master your Money",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.of(context, 'onSurfaceVariant'),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 48),
            // Loader
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
