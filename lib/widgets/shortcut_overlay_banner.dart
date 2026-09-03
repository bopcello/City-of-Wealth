import 'package:flutter/material.dart';
import '../services/shortcut_manager_service.dart';
import '../theme/app_colors.dart';

class ShortcutOverlayBanner extends StatelessWidget {
  final String screenId;
  final List<String> shortcuts;
  final String? helpTip;

  const ShortcutOverlayBanner({
    super.key,
    required this.screenId,
    required this.shortcuts,
    this.helpTip,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ShortcutManagerService.instance,
      builder: (context, _) {
        if (!ShortcutManagerService.instance.shouldShowOverlay(screenId)) {
          return const SizedBox.shrink();
        }

        final surfaceColor = AppColors.of(context, 'surface');
        final outlineColor = AppColors.of(context, 'outline');
        final textColor = AppColors.of(context, 'onSurface');
        final subTextColor = AppColors.of(context, 'onSurfaceVariant');
        final brandColor = AppColors.of(context, 'kp');

        return Positioned(
          bottom: 20,
          right: 20,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(14),
            color: surfaceColor,
            child: Container(
              width: 380,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: outlineColor.withValues(alpha: 0.7),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.keyboard_outlined, size: 20, color: brandColor),
                      const SizedBox(width: 8),
                      Text(
                        "KEYBOARD QUICK GUIDE",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: brandColor,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          ShortcutManagerService.instance.hideOverlay(screenId);
                        },
                        icon: const Icon(Icons.visibility_off_outlined, size: 14),
                        label: const Text("Hide Hints"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: outlineColor.withValues(alpha: 0.15),
                          foregroundColor: textColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (helpTip != null && helpTip!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      helpTip!,
                      style: TextStyle(
                        fontSize: 12,
                        color: subTextColor,
                        height: 1.3,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: shortcuts
                        .map(
                          (s) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: outlineColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: outlineColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              s,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
