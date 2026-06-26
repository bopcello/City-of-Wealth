import 'package:flutter/material.dart';
import '../logic/game_manager.dart';
import '../services/notification_service.dart';

class OnboardingScreen extends StatefulWidget {
  final GameManager game;

  const OnboardingScreen({super.key, required this.game});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();

  TimeOfDay _wakeUpTime = const TimeOfDay(hour: 8, minute: 0);
  bool _disasterAlertsEnabled = true;
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool get _isNextEnabled {
    if (_currentPage == 0) {
      return _nameController.text.trim().isNotEmpty &&
          _nameController.text.length <= 20;
    }
    return true;
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _wakeUpTime,
    );
    if (picked != null && picked != _wakeUpTime) {
      setState(() {
        _wakeUpTime = picked;
      });
    }
  }

  void _complete() async {
    // Request notification permission
    await NotificationService().requestPermission();

    // Schedule notifications
    await NotificationService().scheduleDailyMorningNotification(
      _nameController.text.trim(),
      _wakeUpTime.hour,
      _wakeUpTime.minute,
    );

    // Save and close
    widget.game.completeOnboarding(
      name: _nameController.text.trim(),
      hour: _wakeUpTime.hour,
      minute: _wakeUpTime.minute,
      alertsEnabled: _disasterAlertsEnabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [_buildWelcomePage(theme), _buildCheckInPage(theme)],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isNextEnabled
                      ? () {
                          if (_currentPage == 0) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _complete();
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentPage == 0 ? "Next →" : "Let's Build!",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to\nCity of Wealth",
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 40),
          Text("What should we call you?", style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            maxLength: 20,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: "Enter your name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
            ),
            onChanged: (val) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Text(
            "Your name will be displayed in notifications and challenges.",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInPage(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Daily Check-in",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "A new quiz question drops every morning — answer it to earn Knowledge Points and level up your city. When do you wake up?",
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          InkWell(
            onTap: _pickTime,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(12),
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 16),
                  Text("Wake-up Time", style: theme.textTheme.titleMedium),
                  const Spacer(),
                  Text(
                    _wakeUpTime.format(context),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Notify me when a disaster hits my city",
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Disasters can destroy up to 50% of your assets. Stay informed.",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _disasterAlertsEnabled,
                onChanged: (val) =>
                    setState(() => _disasterAlertsEnabled = val),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
