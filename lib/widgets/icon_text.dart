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

    // Split by placeholders [GEM] and [KP]
    final regex = RegExp(r'(\[GEM\]|\[KP\])');
    final parts = text.split(regex);
    final matches = regex.allMatches(text).toList();

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        inlineSpans.add(TextSpan(text: parts[i], style: style));
      }
      if (i < matches.length) {
        final match = matches[i].group(0);
        if (match == '[GEM]') {
          inlineSpans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  Icons.diamond,
                  size: (style.fontSize ?? 14) * 1.2,
                  color: AppColors.of(context, 'gem'),
                ),
              ),
            ),
          );
        } else if (match == '[KP]') {
          inlineSpans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  Icons.school,
                  size: (style.fontSize ?? 14) * 1.2,
                  color: AppColors.of(context, 'kp'),
                ),
              ),
            ),
          );
        }
      }
    }
    return inlineSpans;
  }
}
