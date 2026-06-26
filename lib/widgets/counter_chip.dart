import 'package:flutter/material.dart';
import 'icon_text.dart';

class CounterChip extends StatelessWidget {
  final String label; // Use placeholders like [KP], [GEM], etc.
  final int value;
  final String prefix; // e.g. "KP" or "Gems" for the non-placeholder version

  const CounterChip({
    super.key,
    required this.label,
    required this.value,
    required this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSmall = MediaQuery.of(context).size.width < 300;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Chip(
        padding: EdgeInsets.zero,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        label: IconText(
          isSmall ? "$label $value" : "$label $prefix: $value",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),
        backgroundColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
    );
  }
}
