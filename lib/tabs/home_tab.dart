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
  final SfxManager sfx;

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
    required this.sfx,
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
        color: Theme.of(context).colorScheme.surfaceVariant,
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
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: events.isEmpty
              ? const Center(
                  child: Text(
                    "No events yet.\nChoices affect your daily cycle.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event =
                        events[events.length - 1 - index]; // Show latest first
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
