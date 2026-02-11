import 'package:flutter/material.dart';

class AppColors {
  // --- CORE COLORS ---
  static const Color primarySeed = Colors.amber;

  // --- LIGHT MODE COLORS ---
  static final Map<String, Color> light = {
    'primary': primarySeed,
    'background': const Color(0xFFF8F9FA),
    'surface': Colors.white,
    'surfaceVariant': Colors.amber.shade800.withValues(alpha: 0.2),
    'onBackground': const Color(0xFF202124),
    'onSurface': const Color(0xFF3C4043),
    'onSurfaceVariant': const Color(0xFF5F6368),
    'outline': const Color(0xFFDADCE0),
    'success': Colors.green.shade600,
    'error': Colors.red.shade600,
    'warning': Colors.orange.shade700,
    'gem': Colors.blue.shade700,
    'kp': Colors.amber.shade800,
    'passive': Colors.teal.shade600,
    'gridGreen': Colors.green.shade200,
    'rent': Colors.blue.shade100,
    'food': Colors.green.shade100,
    'transport': Colors.purple.shade100,
  };

  // --- DARK MODE COLORS ---
  static final Map<String, Color> dark = {
    'primary': const Color.fromARGB(255, 255, 255, 255),
    'background': const Color(0xFF121212),
    'surface': const Color(0xFF1E1E1E),
    'surfaceVariant': Colors.amber.shade400.withValues(alpha: 0.2),
    'onBackground': const Color(0xFFE8EAED),
    'onSurface': const Color(0xFFF1F3F4),
    'onSurfaceVariant': const Color(0xFFBDC1C6),
    'outline': const Color(0xFF3C4043),
    'success': Colors.green.shade400,
    'error': Colors.red.shade400,
    'warning': Colors.orange.shade400,
    'gem': Colors.blue.shade300,
    'kp': Colors.amber.shade400,
    'passive': Colors.teal.shade400,
    'gridGreen': Colors.green.shade800,
    'rent': Colors.indigo.shade900.withValues(alpha: 0.5),
    'food': Colors.green.shade900.withValues(alpha: 0.5),
    'transport': Colors.deepPurple.shade900.withValues(alpha: 0.5),
  };

  // Helper to get color based on context
  static Color of(BuildContext context, String key) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return (isDark ? dark[key] : light[key]) ??
        const Color.fromARGB(255, 100, 192, 40);
  }

  // ThemeData Builders
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarySeed,
      brightness: Brightness.light,
      background: light['background']!,
      surface: light['surface']!,
      surfaceVariant: light['surfaceVariant']!,
      onSurface: light['onSurface']!,
      onSurfaceVariant: light['onSurfaceVariant']!,
      outline: light['outline']!,
      error: light['error']!,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarySeed,
      brightness: Brightness.dark,
      background: dark['background']!,
      surface: dark['surface']!,
      surfaceVariant: dark['surfaceVariant']!,
      onSurface: dark['onSurface']!,
      onSurfaceVariant: dark['onSurfaceVariant']!,
      outline: dark['outline']!,
      error: dark['error']!,
    ),
  );
}
