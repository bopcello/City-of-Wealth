import 'package:flutter/material.dart';
import '../game_state.dart';
import '../widgets/icon_text.dart';
import '../widgets/counter_chip.dart';
import '../theme/app_colors.dart';
import '../logic/game_manager.dart';
import '../services/sfx_manager.dart';

class LiabilitiesScreen extends StatefulWidget {
  final GameManager game;
  final RentType? currentRent;
  final FoodType? currentFood;
  final TransportType? currentTransport;
  final void Function(RentType?, FoodType?, TransportType?) onSelectionChanged;
  final SfxManager sfx;

  const LiabilitiesScreen({
    super.key,
    required this.game,
    required this.currentRent,
    required this.currentFood,
    required this.currentTransport,
    required this.onSelectionChanged,
    required this.sfx,
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
            Divider(height: 24),
            Text(
              "Other options would have been:",
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            ...others.map(
              (o) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: IconText(
                  "• ${o.$1}: ${o.$2 > 0 ? '+' : ''}${o.$2} [KP] (${o.$3} [GEM] cost)",
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.sfx.playClick();
              Navigator.pop(context);
            },
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
            title: const Text("Liabilities"),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: CounterChip(
                    label: "Gems",
                    value: widget.game.gems,
                    icon: Icons.diamond,
                    color: AppColors.of(context, 'gem'),
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
                      _SectionHeader(
                        title: "Lifestyle",
                        icon: Icons.favorite,
                        color: AppColors.of(context, 'onSurface'),
                      ),
                      _buildPanel(
                        "Rent",
                        Icons.home,
                        RentType.values,
                        rentData,
                        selectedRent,
                        theme: AppColors.of(context, 'onSurface'),
                        color: AppColors.of(context, 'onSurface'),
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
                        theme: AppColors.of(context, 'onSurface'),
                        color: AppColors.of(context, 'onSurface'),
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
                        theme: AppColors.of(context, 'onSurface'),
                        color: AppColors.of(context, 'onSurface'),
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
                      _buildMaintenanceSection(),
                      _buildInsuranceSection(),
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

  Widget _buildDebtSection(Color color) {
    if (widget.game.gems >= 0) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                "DEBT WARNING",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          IconText(
            "Current Debt: ${widget.game.gems.abs()} [GEM]",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Maintenance is suspended, but buildings will degrade!",
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceSection() {
    final Map<String, int> counts = {};
    for (var b in widget.game.cityLayout) {
      counts[b.name] = (counts[b.name] ?? 0) + 1;
    }

    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.build, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                const Text(
                  "Maintenance",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDebtSection(AppColors.of(context, 'onSurface')),
            if (counts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "No buildings placed yet. Maintenance will start once you build something.",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else ...[
              ...counts.entries.map((entry) {
                final level = getBuildingLevel(entry.key);
                final cost = level * entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.of(
                          context,
                          'gem',
                        ).withValues(alpha: 0.1),
                        child: Text(
                          "${level}L",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.of(context, 'gem'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(entry.key)),
                      IconText(
                        "-$cost [GEM]",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.of(context, 'error'),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Maintenance:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconText(
                    "-${_calculateTotalMaintenance(counts)} [GEM]",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.of(context, 'error'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  int _calculateTotalMaintenance(Map<String, int> counts) {
    int total = 0;
    counts.forEach((name, count) {
      total += getBuildingLevel(name) * count;
    });
    return total;
  }

  Widget _buildInsuranceSection() {
    List<AssetType> eligibleTypes = [];
    for (var type in AssetType.values) {
      if (widget.game.assets.count(type) > 0) {
        eligibleTypes.add(type);
      }
    }

    if (widget.game.career.level <= 1 || eligibleTypes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.verified_user,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Insurance",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...eligibleTypes.map((type) {
              final isInsured = widget.game.insurances.contains(type);
              return SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("${assetLabel(type)} Insurance"),
                subtitle: const Text(
                  "Cost: 5 [GEM]/cycle, 80% protection",
                  style: TextStyle(fontSize: 12),
                ),
                value: isInsured,
                onChanged: (val) {
                  widget.game.toggleInsurance(type);
                },
                activeTrackColor: AppColors.of(context, 'success'),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBankruptcySection(BuildContext context) {
    final remaining = 3 - widget.game.bankruptcyCount;
    final isAvailable = remaining > 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.emergency,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Emergency",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Column(
                children: [
                  Text(
                    "Declare Bankruptcy",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.of(context, 'error'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Resets progress, waives debt, and auctions assets at market value for gems.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Remaining Attempts: $remaining / 3",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isAvailable
                          ? AppColors.of(context, 'warning')
                          : AppColors.of(context, 'error'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAvailable
                          ? AppColors.of(context, 'error')
                          : Theme.of(context).colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.3),
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    onPressed: isAvailable
                        ? () {
                            widget.sfx.playClick();
                            _showBankruptcyConfirmation(context);
                          }
                        : null,
                    child: const Text("DECLARE BANKRUPTCY"),
                  ),
                ],
              ),
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
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.of(context, 'error'),
            ),
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
    int Function(T) kpGetter, {
    required Color theme,
    required Color color,
  }) {
    bool isLocked = selectedValue != null;
    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.surfaceVariant,
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
                  Text(
                    "Locked",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
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
                          color: isSelected
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: isLocked
                      ? null
                      : (selected) {
                          if (selected) {
                            widget.sfx.playClick();
                            onSelected(val);
                          }
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
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: color),
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
