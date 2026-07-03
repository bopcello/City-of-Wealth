import 'package:flutter/material.dart';
import '../game_state.dart';
import '../theme/app_colors.dart';
import '../services/sfx_manager.dart';
import '../widgets/icon_text.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.of(context, 'kp'),
            child: const Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                levelName(career.track, career.level),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Level: ${career.level}",
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
              ? const Center(
                  child: Text(
                    "No events yet.\nChoices affect your daily cycle.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
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
        const Text(
          "Owned Assets",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        if (assets.items.isEmpty)
          const Text(
            "No assets owned yet.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
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
          const Text(
            "Recently Visited",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
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
