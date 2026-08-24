import 'package:flutter/material.dart';

/// A widget that wraps a button or widget and overlays a periodic, tilted
/// double white stripe animation (shiny sweep effect) typical in game UIs.
class ShinyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ButtonStyle? style;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final Size? maximumSize;
  final OutlinedBorder? shape;
  final MaterialTapTargetSize? tapTargetSize;
  final Duration shineDuration;
  final Duration shineInterval;
  final Color? shineColor;
  final double? elevation;
  final bool useStadiumShape;
  final bool isShiny;

  const ShinyButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.style,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.minimumSize,
    this.maximumSize,
    this.shape,
    this.tapTargetSize,
    this.shineDuration = const Duration(milliseconds: 2400),
    this.shineInterval = const Duration(milliseconds: 2200),
    this.shineColor,
    this.elevation,
    this.useStadiumShape = true,
    this.isShiny = true,
  });

  @override
  State<ShinyButton> createState() => _ShinyButtonState();
}

class _ShinyButtonState extends State<ShinyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    final totalMs =
        widget.shineDuration.inMilliseconds +
        widget.shineInterval.inMilliseconds;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    )..repeat();

    final shineEndFraction = widget.shineDuration.inMilliseconds / totalMs;
    // Extended begin/end range (-3.5 to 3.5) so animation spawns completely out of sight before moving
    _shineAnimation = Tween<double>(begin: -3.5, end: 3.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, shineEndFraction, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        widget.backgroundColor ?? Theme.of(context).colorScheme.primary;
    final fgColor = widget.foregroundColor ?? Colors.white;

    final OutlinedBorder buttonShape = widget.shape ??
        (widget.useStadiumShape
            ? const StadiumBorder()
            : RoundedRectangleBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
              ));

    final defaultStyle = ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      shape: buttonShape,
      padding:
          widget.padding ??
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      elevation: widget.elevation ?? 4.0,
      tapTargetSize:
          widget.tapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
      minimumSize: widget.minimumSize,
      maximumSize: widget.maximumSize,
    );

    final effectiveStyle =
        widget.style != null ? defaultStyle.merge(widget.style) : defaultStyle;

    final shineBaseColor = widget.shineColor ?? Colors.white;

    return AnimatedBuilder(
      animation: _shineAnimation,
      builder: (context, _) {
        final double pos = _shineAnimation.value;

        return ClipPath(
          clipper: ShapeBorderClipper(shape: buttonShape),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              // Main Button Body
              ElevatedButton(
                style: effectiveStyle,
                onPressed: widget.onPressed,
                onLongPress: widget.onLongPress,
                child: widget.child,
              ),
              // Tilted Double Stripe Shiny Sweep Overlay
              if (widget.isShiny)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(pos - 0.9, -1.4),
                          end: Alignment(pos + 0.9, 1.4),
                          colors: [
                            // Stripe 1
                            shineBaseColor.withValues(alpha: 0.0),
                            shineBaseColor.withValues(alpha: 0.75),
                            shineBaseColor.withValues(alpha: 0.75),
                            shineBaseColor.withValues(alpha: 0.0),
                            // Transparent Gap
                            shineBaseColor.withValues(alpha: 0.0),
                            shineBaseColor.withValues(alpha: 0.0),
                            // Stripe 2
                            shineBaseColor.withValues(alpha: 0.0),
                            shineBaseColor.withValues(alpha: 0.75),
                            shineBaseColor.withValues(alpha: 0.75),
                            shineBaseColor.withValues(alpha: 0.0),
                          ],
                          stops: const [
                            0.00, 0.08, 0.24, 0.32, // Stripe 1
                            0.32, 0.42,             // Gap
                            0.42, 0.50, 0.66, 0.74, // Stripe 2
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Helper wrapper to apply periodic double-stripe shine overlay to any custom widget/card.
class ShinyWidgetWrapper extends StatefulWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final Duration shineDuration;
  final Duration shineInterval;
  final bool isShiny;

  const ShinyWidgetWrapper({
    super.key,
    required this.child,
    this.borderRadius,
    this.shineDuration = const Duration(milliseconds: 2400),
    this.shineInterval = const Duration(milliseconds: 2200),
    this.isShiny = true,
  });

  @override
  State<ShinyWidgetWrapper> createState() => _ShinyWidgetWrapperState();
}

class _ShinyWidgetWrapperState extends State<ShinyWidgetWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    final totalMs =
        widget.shineDuration.inMilliseconds +
        widget.shineInterval.inMilliseconds;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    )..repeat();

    final shineEndFraction = widget.shineDuration.inMilliseconds / totalMs;
    // Extended begin/end range (-3.5 to 3.5) so animation spawns completely out of sight before moving
    _shineAnimation = Tween<double>(begin: -3.5, end: 3.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, shineEndFraction, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(16);

    return AnimatedBuilder(
      animation: _shineAnimation,
      builder: (context, _) {
        final double pos = _shineAnimation.value;

        return ClipRRect(
          borderRadius: radius,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              widget.child,
              // Tilted Double Stripe Shiny Sweep Overlay
              // 2 separate parallel stripes, each with a 50% solid center at 75% opacity and 25% edge gradients
              if (widget.isShiny)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(pos - 0.9, -1.4),
                          end: Alignment(pos + 0.9, 1.4),
                          colors: [
                            // Stripe 1
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white.withValues(alpha: 0.75),
                            Colors.white.withValues(alpha: 0.75),
                            Colors.white.withValues(alpha: 0.0),
                            // Transparent Gap
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white.withValues(alpha: 0.0),
                            // Stripe 2
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white.withValues(alpha: 0.75),
                            Colors.white.withValues(alpha: 0.75),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                          stops: const [
                            0.00, 0.08, 0.24, 0.32, // Stripe 1
                            0.32, 0.42,             // Gap
                            0.42, 0.50, 0.66, 0.74, // Stripe 2
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
