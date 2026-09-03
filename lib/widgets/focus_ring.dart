import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FocusRing extends StatefulWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;

  const FocusRing({
    super.key,
    required this.child,
    this.borderRadius,
    this.onPressed,
    this.focusNode,
  });

  @override
  State<FocusRing> createState() => _FocusRingState();
}

class _FocusRingState extends State<FocusRing> {
  late FocusNode _focusNode;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.of(context, 'primary');
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(8);

    return MouseRegion(
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Focus(
          focusNode: _focusNode,
          child: ListenableBuilder(
            listenable: _focusNode,
            builder: (context, child) {
              final isFocused = _focusNode.hasFocus;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(
                    color: isFocused
                        ? primaryColor
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: widget.child,
              );
            },
          ),
        ),
      ),
    );
  }
}
