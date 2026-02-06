import 'package:flutter/material.dart';
import '../game_state.dart';

class LiabilitiesScreen extends StatefulWidget {
  final CareerState career;
  final RentType? currentRent;
  final FoodType? currentFood;
  final TransportType? currentTransport;
  final void Function(RentType?, FoodType?, TransportType?) onSelectionChanged;

  const LiabilitiesScreen({
    super.key,
    required this.career,
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
            Text("KP Result: ${choiceKp > 0 ? '+' : ''}$choiceKp KP"),
            Text("Cost: $cost Gems"),
            const Divider(height: 24),
            const Text(
              "Other options would have been:",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            ...others.map(
              (o) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "• ${o.$1}: ${o.$2 > 0 ? '+' : ''}${o.$2} KP (${o.$3} Gems cost)",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
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
    return Scaffold(
      appBar: AppBar(title: const Text("Liabilities & Lifestyle")),
      body: Column(
        children: [
          // Top Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.amber.shade50,
              child: ListView(
                children: [
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
                          widget.career.track,
                          widget.career.level,
                          val,
                        ),
                        RentType.values
                            .where((e) => e != val)
                            .map(
                              (e) => (
                                rentData[e]!.label,
                                getRentKp(
                                  widget.career.track,
                                  widget.career.level,
                                  e,
                                ),
                                getRentCost(
                                  widget.career.track,
                                  widget.career.level,
                                  e,
                                ),
                              ),
                            )
                            .toList(),
                        getRentCost(
                          widget.career.track,
                          widget.career.level,
                          val,
                        ),
                        rentData[val]!.description,
                      );
                    },
                    (v) => getRentCost(
                      widget.career.track,
                      widget.career.level,
                      v,
                    ),
                    (v) =>
                        getRentKp(widget.career.track, widget.career.level, v),
                  ),
                  const SizedBox(height: 16),
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
                          widget.career.track,
                          widget.career.level,
                          val,
                        ),
                        FoodType.values
                            .where((e) => e != val)
                            .map(
                              (e) => (
                                foodData[e]!.label,
                                getFoodKp(
                                  widget.career.track,
                                  widget.career.level,
                                  e,
                                ),
                                getFoodCost(
                                  widget.career.track,
                                  widget.career.level,
                                  e,
                                ),
                              ),
                            )
                            .toList(),
                        getFoodCost(
                          widget.career.track,
                          widget.career.level,
                          val,
                        ),
                        foodData[val]!.description,
                      );
                    },
                    (v) => getFoodCost(
                      widget.career.track,
                      widget.career.level,
                      v,
                    ),
                    (v) =>
                        getFoodKp(widget.career.track, widget.career.level, v),
                  ),
                  const SizedBox(height: 16),
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
                          widget.career.track,
                          widget.career.level,
                          val,
                        ),
                        TransportType.values
                            .where((e) => e != val)
                            .map(
                              (e) => (
                                transportData[e]!.label,
                                getTransportKp(
                                  widget.career.track,
                                  widget.career.level,
                                  e,
                                ),
                                getTransportCost(
                                  widget.career.track,
                                  widget.career.level,
                                  e,
                                ),
                              ),
                            )
                            .toList(),
                        getTransportCost(
                          widget.career.track,
                          widget.career.level,
                          val,
                        ),
                        transportData[val]!.description,
                      );
                    },
                    (v) => getTransportCost(
                      widget.career.track,
                      widget.career.level,
                      v,
                    ),
                    (v) => getTransportKp(
                      widget.career.track,
                      widget.career.level,
                      v,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Section
          Container(
            height: 100,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                "Insurance system coming soon",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
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
                Icon(icon, color: Colors.amber.shade800),
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
                      Text(
                        "$cost Gems",
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
                  selectedColor: Colors.amber.shade200,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
