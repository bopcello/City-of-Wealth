import 'package:flutter/material.dart';
import '../game_state.dart';
import '../theme/app_colors.dart';
import '../services/sfx_manager.dart';
import '../widgets/icon_text.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/focus_ring.dart';
import '../widgets/responsive_widescreen.dart';
import '../widgets/shortcut_overlay_banner.dart';

class HomeTab extends StatelessWidget {
  final int kp;
  final int gems;
  final CareerState career;
  final List<String> events;
  final RentType? rentChoice;
  final FoodType? foodChoice;
  final TransportType? transportChoice;
  final AssetInventory assets;
  final VoidCallback onClearEvents;
  final bool dailyQuizAvailable;
  final SfxManager sfx;
  final List<String> recentVisitedMoneyTiles;
  final void Function(String) onMoneyTileTap;
  final String playerName;
  final String profilePic;
  final String? dailyQuoteText;
  final String? dailyQuoteAuthor;

  const HomeTab({
    super.key,
    required this.kp,
    required this.gems,
    required this.career,
    required this.events,
    required this.rentChoice,
    required this.foodChoice,
    required this.transportChoice,
    required this.assets,
    required this.onClearEvents,
    required this.dailyQuizAvailable,
    required this.sfx,
    required this.recentVisitedMoneyTiles,
    required this.onMoneyTileTap,
    required this.playerName,
    required this.profilePic,
    this.dailyQuoteText,
    this.dailyQuoteAuthor,
  });

  @override
  Widget build(BuildContext context) {
    if (isWidescreenDesktop(context)) {
      return _buildDesktopWidescreen(context);
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dailyQuoteText != null && dailyQuoteText!.isNotEmpty) ...[
            _buildDailyQuoteBanner(context),
            const SizedBox(height: 16),
          ],
          _buildCareerHeader(context),
          const SizedBox(height: 24),
          _buildEventSection(context),
          const SizedBox(height: 24),
          _buildSummarySection(context),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDesktopWidescreen(BuildContext context) {
    final surfaceColor = AppColors.of(context, 'surface');
    final outlineColor = AppColors.of(context, 'outline');

    return Stack(
      children: [
        ThreeColumnLayout(
          leftFlex: 3,
          centerFlex: 6,
          rightFlex: 3,
          leftChild: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCareerHeader(context),
                const SizedBox(height: 20),
                _buildSummarySection(context),
              ],
            ),
          ),
          centerChild: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (dailyQuoteText != null && dailyQuoteText!.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: outlineColor.withValues(alpha: 0.5)),
                    ),
                    child: _buildDailyQuoteBanner(context),
                  ),
                  const SizedBox(height: 24),
                ],
                const Text(
                  "Financial Hub & Quick Actions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // 4 Quick Action Tiles Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.6,
                  children: [
                    _buildQuickActionTile(
                      context,
                      title: "Career",
                      subtitle: levelName(career.track, career.level),
                      icon: Icons.badge,
                      color: Colors.blue.shade600,
                    ),
                    _buildQuickActionTile(
                      context,
                      title: "Assets",
                      subtitle: "${assets.items.length} Asset Types Owned",
                      icon: Icons.account_balance,
                      color: Colors.teal.shade600,
                    ),
                    _buildQuickActionTile(
                      context,
                      title: "Liabilities",
                      subtitle: "Rent, Food, Transport",
                      icon: Icons.warning_rounded,
                      color: Colors.orange.shade700,
                    ),
                    _buildQuickActionTile(
                      context,
                      title: "Passive Income",
                      subtitle: "Invest & Compound",
                      icon: Icons.trending_up,
                      color: Colors.purple.shade600,
                    ),
                  ],
                ),
              ],
            ),
          ),
          rightChild: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildEventSection(context),
              ],
            ),
          ),
        ),
        const ShortcutOverlayBanner(
          screenId: 'home_tab',
          helpTip: "Use keys [1-4] to quickly open sub-hubs, or [F1-F4] to navigate tabs.",
          shortcuts: ["[1] Career", "[2] Assets", "[3] Liabilities", "[4] Passive Income", "[F1-F4] Tabs"],
        ),
      ],
    );
  }


  Widget _buildQuickActionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final surfaceColor = AppColors.of(context, 'surface');
    final outlineColor = AppColors.of(context, 'outline');

    return FocusRing(
      onPressed: () {
        sfx.playClick();
        onMoneyTileTap(title);
      },
      child: Material(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            sfx.playClick();
            onMoneyTileTap(title);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: outlineColor.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color, size: 22),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.of(context, 'onSurfaceVariant'),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildDailyQuoteBanner(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.format_quote_rounded,
              size: 20,
              color: AppColors.of(context, 'kp'),
            ),
            const SizedBox(width: 8),
            Text(
              "DAILY FINANCIAL QUOTE",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: AppColors.of(context, 'kp'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "\"${dailyQuoteText!}\"",
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
            color: AppColors.of(context, 'onSurface'),
          ),
        ),
        if (dailyQuoteAuthor != null && dailyQuoteAuthor!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "— ${dailyQuoteAuthor!}",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.of(context, 'onSurfaceVariant'),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCareerHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          ProfileAvatar(
            profilePic: profilePic,
            fallbackName: playerName,
            radius: 30,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                playerName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                levelName(career.track, career.level),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Events",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (events.isNotEmpty)
              TextButton(
                onPressed: () {
                  sfx.playClick();
                  onClearEvents();
                },
                child: const Text("Clear Log"),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: (events.isEmpty && !dailyQuizAvailable)
              ? Center(
                  child: Text(
                    "No events yet.\nChoices affect your daily cycle.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: events.length + (dailyQuizAvailable ? 1 : 0),
                  itemBuilder: (context, index) {
                    final allEvents = dailyQuizAvailable
                        ? ["New daily question available!", ...events]
                        : events;
                    final event =
                        allEvents[allEvents.length -
                            1 -
                            index]; // Show latest first
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "• ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: IconText(
                              event,
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Lifestyle & Assets Summary",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _SummaryChip(
              icon: Icons.home,
              label: "Rent",
              value: rentChoice != null ? rentData[rentChoice!]!.label : "None",
              color: AppColors.of(context, 'rent'),
            ),
            _SummaryChip(
              icon: Icons.restaurant,
              label: "Food",
              value: foodChoice != null ? foodData[foodChoice!]!.label : "None",
              color: AppColors.of(context, 'food'),
            ),
            _SummaryChip(
              icon: Icons.directions_car,
              label: "Transport",
              value: transportChoice != null
                  ? transportData[transportChoice!]!.label
                  : "None",
              color: AppColors.of(context, 'transport'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          "Owned Assets",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        if (assets.items.isEmpty)
          Text(
            "No assets owned yet.",
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          )
        else
          Wrap(
            spacing: 8,
            children: assets.items.entries.map((e) {
              return Chip(
                label: Text("${assetLabel(e.key)}: ${e.value}"),
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        if (recentVisitedMoneyTiles.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            "Recently Visited",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: recentVisitedMoneyTiles.map((title) {
              IconData icon = Icons.help;
              if (title == "Career") icon = Icons.badge;
              if (title == "Passive Income") icon = Icons.trending_up;
              if (title == "Assets") icon = Icons.account_balance;
              if (title == "Liabilities") icon = Icons.warning;
              if (title == "Quiz") icon = Icons.quiz;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      sfx.playClick();
                      onMoneyTileTap(title);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            icon,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(value, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
