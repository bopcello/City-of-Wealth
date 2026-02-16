import 'package:flutter/material.dart';
import '../game_state.dart';
import '../theme/app_colors.dart';

class DisasterReportDialog extends StatelessWidget {
  final List<DisasterResult> results;

  const DisasterReportDialog({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.warning, color: Colors.orange),
          SizedBox(width: 8),
          Flexible(child: Text("City Disaster Report")),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: results.length,
          separatorBuilder: (context, index) => const Divider(height: 32),
          itemBuilder: (context, index) {
            final result = results[index];
            String title = "";
            IconData icon = Icons.warning;
            Color color = Colors.orange;

            switch (result.type) {
              case DisasterType.flood:
                title = "Flood Alert!";
                icon = Icons.water;
                color = Colors.blue;
                break;
              case DisasterType.fire:
                title = "Fire Outbreak!";
                icon = Icons.local_fire_department;
                color = Colors.red;
                break;
              case DisasterType.earthquake:
                title = "Earthquake!";
                icon = Icons.landscape;
                color = Colors.brown;
                break;
              case DisasterType.economyCrash:
                title = "Economy Crash!";
                icon = Icons.trending_down;
                color = Colors.purple;
                break;
              case DisasterType.drought:
                title = "Severe Drought!";
                icon = Icons.wb_sunny;
                color = Colors.orange;
                break;
              case DisasterType.landslide:
                title = "Landslide!";
                icon = Icons.terrain;
                color = Colors.deepOrange;
                break;
              case DisasterType.massEmigration:
                title = "Mass Emigration!";
                icon = Icons.people_outline;
                color = Colors.blueGrey;
                break;
              case DisasterType.pandemic:
                title = "Pandemic!";
                icon = Icons.health_and_safety;
                color = Colors.teal;
                break;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (result.destroyedBuildings.isNotEmpty) ...[
                  const Text(
                    "Buildings Destroyed:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...result.destroyedBuildings.map((b) => Text("• $b")),
                  const SizedBox(height: 8),
                ],
                if (result.lostAssets.isNotEmpty) ...[
                  const Text(
                    "Assets Lost:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...result.lostAssets.entries.map(
                    (e) => Text("• ${assetLabel(e.key)}: ${e.value}"),
                  ),
                  const SizedBox(height: 8),
                ],
                if (result.insurancePayouts.isNotEmpty) ...[
                  Text(
                    "Insurance Protection Applied!",
                    style: TextStyle(
                      color: AppColors.of(context, 'success'),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...result.insurancePayouts.entries.map(
                    (e) => Text(
                      "• ${assetLabel(e.key)} payout: ${e.value} Gems",
                      style: TextStyle(color: AppColors.of(context, 'success')),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (result.kpPenalty > 0) ...[
                  Text(
                    "NO INSURANCE PENALTY!",
                    style: TextStyle(
                      color: AppColors.of(context, 'error'),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "• Deducted ${result.kpPenalty} KP for lack of insurance.",
                    style: TextStyle(color: AppColors.of(context, 'error')),
                  ),
                  const SizedBox(height: 8),
                ],
                if (result.passiveIncomeReduction != null) ...[
                  Text(
                    "Passive Income Impact:",
                    style: TextStyle(
                      color: AppColors.of(context, 'error'),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "• ${result.passiveIncomeReduction}",
                    style: TextStyle(color: AppColors.of(context, 'error')),
                  ),
                  const SizedBox(height: 8),
                ],
                if (result.deactivatedPassiveIncomes.isNotEmpty) ...[
                  Text(
                    "Passive Incomes Deactivated (Reinvest required):",
                    style: TextStyle(
                      color: AppColors.of(context, 'warning'),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...result.deactivatedPassiveIncomes.entries.map(
                    (e) => Text("• ${assetLabel(e.key)}: ${e.value} units"),
                  ),
                  const SizedBox(height: 8),
                ],
                if (!result.protected &&
                    result.kpPenalty == 0 &&
                    result.lostAssets.isEmpty &&
                    result.destroyedBuildings.isEmpty &&
                    result.deactivatedPassiveIncomes.isEmpty)
                  const Text(
                    "Luckily, no assets or passive income sources were lost.",
                  ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("I understand"),
        ),
      ],
    );
  }
}
