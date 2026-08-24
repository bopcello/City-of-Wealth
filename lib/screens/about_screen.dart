import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String _appVersion = '3.2.0';

  static const String _privacyPolicyUrl =
      'https://sites.google.com/view/city-of-wealth/privacy-policy';
  static const String _developerName = 'bopcello';
  static const String _developerEmail = 'bopcello@gmail.com';

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    bool launched = false;
    try {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      launched = false;
    }
    if (!launched && context.mounted) {
      _showSnack(context, "Couldn't open the link.");
    }
  }

  Future<void> _sendEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: _developerEmail,
      queryParameters: {'subject': 'City of Wealth — Feedback'},
    );
    bool launched = false;
    try {
      launched = await launchUrl(uri);
    } catch (_) {
      launched = false;
    }
    if (!launched && context.mounted) {
      _copyToClipboard(context, _developerEmail, 'Email address');
      _showSnack(context, 'No email app found — address copied instead.');
    }
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      _showSnack(context, '$label copied to clipboard');
    }
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandColor = AppColors.of(context, 'kp');
    final surfaceVariant = theme.colorScheme.surfaceContainerHighest;
    final outlineColor = theme.colorScheme.outline;

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'lib/assets/app_icon.png',
                      height: 96,
                      width: 96,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        height: 96,
                        width: 96,
                        decoration: BoxDecoration(
                          color: brandColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.location_city,
                          color: AppColors.of(context, 'onSurface'),
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'City of Wealth',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version $_appVersion',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            _sectionHeader(context, 'LEGAL'),
            Container(
              decoration: BoxDecoration(
                color: surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: outlineColor),
              ),
              child: ListTile(
                leading: Icon(Icons.privacy_tip_outlined, color: brandColor),
                title: const Text('Privacy Policy'),
                subtitle: const Text('How your data is collected and used'),
                trailing: Icon(Icons.open_in_new, color: brandColor, size: 18),
                onTap: () => _openUrl(context, _privacyPolicyUrl),
              ),
            ),
            const SizedBox(height: 24),

            _sectionHeader(context, 'DEVELOPER'),
            Container(
              decoration: BoxDecoration(
                color: surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: outlineColor),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person_outline, color: brandColor),
                    title: const Text('Developer'),
                    subtitle: const Text(_developerName),
                    onTap: () => _copyToClipboard(
                      context,
                      _developerName,
                      'Developer name',
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Icon(Icons.email_outlined, color: brandColor),
                    title: const Text('Contact'),
                    subtitle: const Text(_developerEmail),
                    trailing: Icon(
                      Icons.open_in_new,
                      color: brandColor,
                      size: 18,
                    ),
                    onTap: () => _sendEmail(context),
                    onLongPress: () => _copyToClipboard(
                      context,
                      _developerEmail,
                      'Email address',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Center(
              child: Text(
                '© ${DateTime.now().year} $_developerName. All rights reserved.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.of(context, 'kp'),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
