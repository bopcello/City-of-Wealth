import 'package:flutter/material.dart';
import '../game_state.dart';

class HomeTab extends StatelessWidget {
  final int kp;
  final int gems;
  final CareerState career;
  final VoidCallback onDebugAdd;
  final VoidCallback onDebugReset;

  const HomeTab({
    super.key,
    required this.kp,
    required this.gems,
    required this.career,
    required this.onDebugAdd,
    required this.onDebugReset,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: onDebugAdd,
            child: const Text("💥 Add 1,000 KP and 10 gems (debug)"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onDebugReset,
            child: const Text("🔁 Reset career to Level 1 (debug)"),
          ),
        ],
      ),
    );
  }
}
