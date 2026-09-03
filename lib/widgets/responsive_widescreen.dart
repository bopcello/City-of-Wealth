import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool isWidescreenDesktop(BuildContext context) {
  if (kIsWeb) {
    return MediaQuery.of(context).size.width >= 900;
  }
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    return true;
  }
  return false;
}

class WidescreenContainer extends StatelessWidget {
  final Widget desktopChild;
  final Widget mobileChild;

  const WidescreenContainer({
    super.key,
    required this.desktopChild,
    required this.mobileChild,
  });

  @override
  Widget build(BuildContext context) {
    if (isWidescreenDesktop(context)) {
      return desktopChild;
    }
    return mobileChild;
  }
}

class SplitViewLayout extends StatelessWidget {
  final Widget leftChild;
  final Widget rightChild;
  final double leftRatio;
  final EdgeInsetsGeometry padding;

  const SplitViewLayout({
    super.key,
    required this.leftChild,
    required this.rightChild,
    this.leftRatio = 0.4,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: (leftRatio * 100).toInt(),
          child: Padding(padding: padding, child: leftChild),
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(
          flex: ((1 - leftRatio) * 100).toInt(),
          child: Padding(padding: padding, child: rightChild),
        ),
      ],
    );
  }
}

class ThreeColumnLayout extends StatelessWidget {
  final Widget leftChild;
  final Widget centerChild;
  final Widget rightChild;
  final int leftFlex;
  final int centerFlex;
  final int rightFlex;

  const ThreeColumnLayout({
    super.key,
    required this.leftChild,
    required this.centerChild,
    required this.rightChild,
    this.leftFlex = 3,
    this.centerFlex = 6,
    this.rightFlex = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: leftFlex,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: leftChild,
          ),
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(
          flex: centerFlex,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: centerChild,
          ),
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(
          flex: rightFlex,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: rightChild,
          ),
        ),
      ],
    );
  }
}
