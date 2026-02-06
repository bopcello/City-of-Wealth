import 'package:flutter/material.dart';
import '../game_state.dart';

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

  // [DEBUG: PAUSE_INCOME] properties
  final bool incomePaused;
  final ValueChanged<bool> onPauseToggled;

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
    // [DEBUG: PAUSE_INCOME] parameters
    this.incomePaused = false,
    required this.onPauseToggled,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCareerHeader(),
          const SizedBox(height: 24),
          _buildEventSection(),
          const SizedBox(height: 24),
          _buildSummarySection(),
          const SizedBox(height: 32),
          // [DEBUG: PAUSE_INCOME] START
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Pause Income Cycles (Debug): "),
                Switch(value: incomePaused, onChanged: onPauseToggled),
              ],
            ),
          ),
          // [DEBUG: PAUSE_INCOME] END
        ],
      ),
    );
  }

  Widget _buildCareerHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.amber.shade700,
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
                "Track: ${trackLabel(career.track)} (Lvl ${career.level})",
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventSection() {
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
                onPressed: onClearEvents,
                child: const Text("Clear Log"),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
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
                            child: Text(
                              event,
                              style: const TextStyle(fontSize: 13),
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

  Widget _buildSummarySection() {
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
              color: Colors.blue.shade100,
            ),
            _SummaryChip(
              icon: Icons.restaurant,
              label: "Food",
              value: foodChoice != null ? foodData[foodChoice!]!.label : "None",
              color: Colors.green.shade100,
            ),
            _SummaryChip(
              icon: Icons.directions_car,
              label: "Transport",
              value: transportChoice != null
                  ? transportData[transportChoice!]!.label
                  : "None",
              color: Colors.purple.shade100,
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
                backgroundColor: Colors.amber.shade50,
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
