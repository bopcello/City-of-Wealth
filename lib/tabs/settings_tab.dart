import 'package:flutter/material.dart';
import '../game_state.dart';

class SettingsTab extends StatelessWidget {
  final CareerState career;
  final VoidCallback onDebugAdd;
  final void Function({CareerTrack? track}) onDebugLevelUp;
  final VoidCallback onDebugReset;

  const SettingsTab({
    super.key,
    required this.career,
    required this.onDebugAdd,
    required this.onDebugLevelUp,
    required this.onDebugReset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Settings",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            "Developer Options (Debug)",
            style: TextStyle(color: Colors.grey),
          ),
          const Divider(),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: onDebugAdd,
            icon: const Icon(Icons.add),
            label: const Text("Add 1,000 KP & 1,000 Gems"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              if (career.track == CareerTrack.student) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Choose Career Track"),
                    content: const Text(
                      "Which track would you like to advance into?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onDebugLevelUp(track: CareerTrack.job);
                        },
                        child: const Text("Job"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onDebugLevelUp(track: CareerTrack.business);
                        },
                        child: const Text("Business"),
                      ),
                    ],
                  ),
                );
              } else {
                onDebugLevelUp();
              }
            },
            icon: const Icon(Icons.upgrade),
            label: const Text("Debug: Advance to Next Level"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onDebugReset,
            icon: const Icon(Icons.refresh),
            label: const Text("Reset Career to Level 1"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
