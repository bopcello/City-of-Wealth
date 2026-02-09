import 'package:flutter/material.dart';
import '../game_state.dart';
import '../widgets/icon_text.dart';
import '../widgets/counter_chip.dart';
import '../logic/game_manager.dart';

class LiabilitiesScreen extends StatefulWidget {
  final GameManager game;
  final RentType? currentRent;
  final FoodType? currentFood;
  final TransportType? currentTransport;
  final void Function(RentType?, FoodType?, TransportType?) onSelectionChanged;

  const LiabilitiesScreen({
    super.key,
    required this.game,
    required this.currentRent,
    required this.currentFood,
    required this.currentTransport,
    required this.onSelectionChanged,
  });

  @override
  State<LiabilitiesScreen> createState() => _LiabilitiesScreenState();
}

class _LiabilitiesScreenState extends State<LiabilitiesScreen> {
  late RentType? selectedRent;
  late FoodType? selectedFood;
  late TransportType? selectedTransport;

  @override
  void initState() {
    super.initState();
    selectedRent = widget.currentRent;
    selectedFood = widget.currentFood;
    selectedTransport = widget.currentTransport;
  }

  void _showResultPopup(
    String category,
    String choiceLabel,
    int choiceKp,
    List<(String, int, int)> others,
    int cost,
    String description,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("$category: $choiceLabel"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            IconText("KP Result: ${choiceKp > 0 ? '+' : ''}$choiceKp [KP]"),
            IconText("Cost: $cost [GEM]"),
            const Divider(height: 24),
            const Text(
              "Other options would have been:",
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(121, 158, 158, 158),
              ),
            ),
            ...others.map(
              (o) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: IconText(
                  "• ${o.$1}: ${o.$2 > 0 ? '+' : ''}${o.$2} [KP] (${o.$3} [GEM] cost)",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(121, 158, 158, 158),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Understood"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.game,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Liabilities & Lifestyle"),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: CounterChip(
                    label: "Gems",
                    value: widget.game.gems,
                    icon: Icons.diamond,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Top Section
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.surface,
                  child: ListView(
                    children: [
                      _SectionHeader(title: "Lifestyle", icon: Icons.favorite),
                      _buildPanel(
                        "Rent",
                        Icons.home,
                        RentType.values,
                        rentData,
                        selectedRent,
                        (val) {
                          if (selectedRent != null) return; // Locked
                          setState(() => selectedRent = val);
                          widget.onSelectionChanged(
                            selectedRent,
                            selectedFood,
                            selectedTransport,
                          );
                          _showResultPopup(
                            "Rent",
                            rentData[val]!.label,
                            getRentKp(
                              widget.game.career.track,
                              widget.game.career.level,
                              val,
                            ),
                            RentType.values
                                .where((e) => e != val)
                                .map(
                                  (e) => (
                                    rentData[e]!.label,
                                    getRentKp(
                                      widget.game.career.track,
                                      widget.game.career.level,
                                      e,
                                    ),
                                    getRentCost(
                                      widget.game.career.track,
                                      widget.game.career.level,
                                      e,
                                    ),
                                  ),
                                )
                                .toList(),
                            getRentCost(
                              widget.game.career.track,
                              widget.game.career.level,
                              val,
                            ),
                            rentData[val]!.description,
                          );
                        },
                        (v) => getRentCost(
                          widget.game.career.track,
                          widget.game.career.level,
                          v,
                        ),
                        (v) => getRentKp(
                          widget.game.career.track,
                          widget.game.career.level,
                          v,
                        ),
                      ),
                      _buildPanel(
                        "Food",
                        Icons.restaurant,
                        FoodType.values,
                        foodData,
                        selectedFood,
                        (val) {
                          if (selectedFood != null) return; // Locked
                          setState(() => selectedFood = val);
                          widget.onSelectionChanged(
                            selectedRent,
                            selectedFood,
                            selectedTransport,
                          );
                          _showResultPopup(
                            "Food",
                            foodData[val]!.label,
                            getFoodKp(
                              widget.game.career.track,
                              widget.game.career.level,
                              val,
                            ),
                            FoodType.values
                                .where((e) => e != val)
                                .map(
                                  (e) => (
                                    foodData[e]!.label,
                                    getFoodKp(
                                      widget.game.career.track,
                                      widget.game.career.level,
                                      e,
                                    ),
                                    getFoodCost(
                                      widget.game.career.track,
                                      widget.game.career.level,
                                      e,
                                    ),
                                  ),
                                )
                                .toList(),
                            getFoodCost(
                              widget.game.career.track,
                              widget.game.career.level,
                              val,
                            ),
                            foodData[val]!.description,
                          );
                        },
                        (v) => getFoodCost(
                          widget.game.career.track,
                          widget.game.career.level,
                          v,
                        ),
                        (v) => getFoodKp(
                          widget.game.career.track,
                          widget.game.career.level,
                          v,
                        ),
                      ),
                      _buildPanel(
                        "Transport",
                        Icons.directions_car,
                        TransportType.values,
                        transportData,
                        selectedTransport,
                        (val) {
                          if (selectedTransport != null) return; // Locked
                          setState(() => selectedTransport = val);
                          widget.onSelectionChanged(
                            selectedRent,
                            selectedFood,
                            selectedTransport,
                          );
                          _showResultPopup(
                            "Transport",
                            transportData[val]!.label,
                            getTransportKp(
                              widget.game.career.track,
                              widget.game.career.level,
                              val,
                            ),
                            TransportType.values
                                .where((e) => e != val)
                                .map(
                                  (e) => (
                                    transportData[e]!.label,
                                    getTransportKp(
                                      widget.game.career.track,
                                      widget.game.career.level,
                                      e,
                                    ),
                                    getTransportCost(
                                      widget.game.career.track,
                                      widget.game.career.level,
                                      e,
                                    ),
                                  ),
                                )
                                .toList(),
                            getTransportCost(
                              widget.game.career.track,
                              widget.game.career.level,
                              val,
                            ),
                            transportData[val]!.description,
                          );
                        },
                        (v) => getTransportCost(
                          widget.game.career.track,
                          widget.game.career.level,
                          v,
                        ),
                        (v) => getTransportKp(
                          widget.game.career.track,
                          widget.game.career.level,
                          v,
                        ),
                      ),
                      const Divider(height: 32),
                      _SectionHeader(title: "Maintenance", icon: Icons.build),
                      _buildDebtSection(),
                      _buildMaintenanceSection(),
                      const Divider(height: 32),
                      _SectionHeader(
                        title: "Insurance",
                        icon: Icons.verified_user,
                      ),
                      _buildInsuranceSection(),
                      const Divider(height: 32),
                      _SectionHeader(title: "Emergency", icon: Icons.emergency),
                      _buildBankruptcySection(context),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDebtSection() {
    if (widget.game.gems >= 0) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
              const SizedBox(width: 12),
              IconText(
                "Debt: ${widget.game.gems.abs()} [GEM]",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "You will not pay maintainance to help you get out of debt faster, but it will cause your buildings to degrade over time!",
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.red.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceSection() {
    // Group buildings by name to show counts
    final Map<String, int> counts = {};
    for (var b in widget.game.cityLayout) {
      counts[b.name] = (counts[b.name] ?? 0) + 1;
    }

    if (counts.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "No buildings placed yet. Maintenance will start once you build something.",
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ),
      );
    }

    int totalCost = 0;
    return Column(
      children: [
        ...counts.entries.map((entry) {
          final level = getBuildingLevel(entry.key);
          final cost = level * entry.value;
          totalCost += cost;
          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: Text(
                  "${level}L",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade400,
                  ),
                ),
              ),
              title: Text(entry.key),
              subtitle: IconText(
                "${entry.value} buildings (@ $level [GEM] / 10 cycles)",
              ),
              trailing: IconText(
                "-$cost [GEM]",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const IconText(
                "Total Maintenance (every 10 cycles):",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconText(
                "-$totalCost [GEM]",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsuranceSection() {
    List<AssetType> eligibleTypes = [];
    for (var type in AssetType.values) {
      if (widget.game.assets.count(type) > 0) {
        eligibleTypes.add(type);
      }
    }

    if (eligibleTypes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Text(
            "Available Insurances",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...eligibleTypes.map((type) {
          final isInsured = widget.game.insurances.contains(type);
          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 8),
            child: SwitchListTile(
              title: Text("${assetLabel(type)} Insurance"),
              subtitle: const IconText(
                "Cost: 5 [GEM]/cycle, Provides 80% protection from losses",
              ),
              value: isInsured,
              onChanged: (val) {
                widget.game.toggleInsurance(type);
              },
              activeTrackColor: Colors.green,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBankruptcySection(BuildContext context) {
    final remaining = 3 - widget.game.bankruptcyCount;
    final isAvailable = remaining > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Declare Bankruptcy",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Resets your progress. Your debt will be waived and you will receive the remaining gems from auctioning off all your assets at market value.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),
            Text(
              "Remaining Attempts: $remaining / 3",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isAvailable ? Colors.orange.shade800 : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isAvailable ? Colors.red : Colors.grey,
                foregroundColor: Colors.white,
              ),
              onPressed: isAvailable
                  ? () {
                      _showBankruptcyConfirmation(context);
                    }
                  : null,
              child: const Text("DECLARE BANKRUPTCY"),
            ),
          ],
        ),
      ),
    );
  }

  void _showBankruptcyConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Auction Assets & Waive Debt?"),
        content: const Text(
          "This will reset your career to Level 1 Student and liquidate all your assets. "
          "This is a fresh start. You can only do this 3 times per game.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit screen
              widget.game.declareBankruptcy(context);
            },
            child: const Text("YES, I AM SURE"),
          ),
        ],
      ),
    );
  }

  Widget _buildPanel<T>(
    String title,
    IconData icon,
    List<T> values,
    Map<T, LiabilityInfo> data,
    T? selectedValue,
    void Function(T) onSelected,
    int Function(T) costGetter,
    int Function(T) kpGetter,
  ) {
    bool isLocked = selectedValue != null;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isLocked) ...[
                  const Spacer(),
                  const Icon(Icons.lock, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  const Text(
                    "Locked",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: values.map((val) {
                final info = data[val]!;
                final isSelected = val == selectedValue;
                final cost = costGetter(val);
                return ChoiceChip(
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(info.label),
                      IconText(
                        "$cost [GEM]",
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: isLocked
                      ? null
                      : (selected) {
                          if (selected) onSelected(val);
                        },
                  selectedColor: Theme.of(context).colorScheme.surfaceVariant,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
