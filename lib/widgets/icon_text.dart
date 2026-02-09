import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  const IconText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = style ?? DefaultTextStyle.of(context).style;
    final inlineSpans = <InlineSpan>[];

    // Split by placeholders [GEM] and [KP]
    final regex = RegExp(r'(\[GEM\]|\[KP\])');
    final parts = text.split(regex);
    final matches = regex.allMatches(text).toList();

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        inlineSpans.add(TextSpan(text: parts[i], style: defaultStyle));
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
                  size: (defaultStyle.fontSize ?? 14) * 1.2,
                  color: Colors.blue.shade400,
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
                  size: (defaultStyle.fontSize ?? 14) * 1.2,
                  color: Colors.orange.shade400,
                ),
              ),
            ),
          );
        }
      }
    }

    return RichText(
      textAlign: textAlign,
      text: TextSpan(children: inlineSpans),
    );
  }
}
