import 'package:flutter/material.dart';

class CounterChip extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color? color;

  const CounterChip({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        icon,
        size: 18,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
      label: Text(
        "$label: $value",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.surfaceVariant.withValues(alpha: 0.2),
      side: BorderSide(color: Theme.of(context).colorScheme.outline),
    );
  }
}
