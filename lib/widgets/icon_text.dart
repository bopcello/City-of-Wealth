import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class IconText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final Color? color;

  const IconText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    var defaultStyle = style ?? DefaultTextStyle.of(context).style;
    if (color != null) {
      defaultStyle = defaultStyle.copyWith(color: color);
    }

    return Text.rich(
      TextSpan(children: parseText(text, defaultStyle, context)),
      textAlign: textAlign,
      style: defaultStyle,
    );
  }

  static List<InlineSpan> parseText(
    String text,
    TextStyle style,
    BuildContext context,
  ) {
    final inlineSpans = <InlineSpan>[];
    final styleStack = <TextStyle>[style];

    final regex = RegExp(
        r'(\[GEM\]|\[KP\]|\[STREAK\]|\[REVIVAL\]|\[\/?(?:success|error|warning|gem|kp|passive)\])');
    final parts = text.split(regex);
    final matches = regex.allMatches(text).toList();

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        inlineSpans.add(TextSpan(text: parts[i], style: styleStack.last));
      }
      if (i < matches.length) {
        final match = matches[i].group(0) ?? '';

        if (match.startsWith('[/')) {
          if (styleStack.length > 1) {
            styleStack.removeLast();
          }
        } else if (match.startsWith('[') &&
            (match.endsWith(']') &&
                (match == '[success]' ||
                    match == '[error]' ||
                    match == '[warning]' ||
                    match == '[gem]' ||
                    match == '[kp]' ||
                    match == '[passive]'))) {
          final key = match.substring(1, match.length - 1);
          final color = AppColors.of(context, key);
          styleStack.add(styleStack.last.copyWith(color: color));
        } else {
          IconData? icon;
          Color? iconColor;

          if (match == '[GEM]') {
            icon = Icons.diamond;
            iconColor = AppColors.of(context, 'gem');
          } else if (match == '[KP]') {
            icon = Icons.school;
            iconColor = AppColors.of(context, 'kp');
          } else if (match == '[STREAK]') {
            icon = Icons.bolt;
            iconColor = AppColors.of(context, 'warning');
          } else if (match == '[REVIVAL]') {
            icon = Icons.favorite;
            iconColor = AppColors.of(context, 'error');
          }

          if (icon != null) {
            inlineSpans.add(
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    icon,
                    size: (styleStack.last.fontSize ?? 14) * 1.2,
                    color: iconColor,
                  ),
                ),
              ),
            );
          }
        }
      }
    }
    return inlineSpans;
  }
}

class CounterChip extends StatelessWidget {
  final String label; // Use placeholders like [KP], [GEM], etc.
  final int value;
  final String prefix; // e.g. "KP" or "Gems" for the non-placeholder version
  final bool? compact;

  const CounterChip({
    super.key,
    required this.label,
    required this.value,
    required this.prefix,
    this.compact,
  });

  static bool needsCompactLayout(
    BuildContext context,
    List<(String prefix, int value)> counters,
  ) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 11);
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    var requiredWidth = 8.0; // AppBar end padding.
    for (final (prefix, value) in counters) {
      final text = '$prefix: $value';
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: direction,
        textScaler: scaler,
      )..layout();
      // Icon, icon gap, chip padding, and the chip's horizontal margin.
      requiredWidth += painter.width + 16 + 4 + 16 + 4;
    }
    return requiredWidth > MediaQuery.sizeOf(context).width;
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompact = compact ?? false;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Chip(
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.symmetric(horizontal: isCompact ? 5 : 8),
        label: IconText(
          isCompact ? "$label $value" : "$label $prefix: $value",
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
