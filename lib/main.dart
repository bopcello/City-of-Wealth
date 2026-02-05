import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

enum CareerTrack {
  student,
  job,
  business,
}

enum AssetType {
  land,
  realEstate,
  machinery,
  vehicles,
  officeEquipment,
}

int assetCost(AssetType type) {
  switch (type) {
    case AssetType.realEstate:
      return 20;
    case AssetType.land:
      return 30;
    case AssetType.machinery:
      return 40;
    case AssetType.vehicles:
      return 35;
    case AssetType.officeEquipment:
      return 25;
  }
}

String assetLabel(AssetType type) {
  switch (type) {
    case AssetType.land:
      return "Land";
    case AssetType.realEstate:
      return "Real Estate";
    case AssetType.machinery:
      return "Machinery";
    case AssetType.vehicles:
      return "Vehicles";
    case AssetType.officeEquipment:
      return "Office Equipment";
  }
}

class AssetInventory {
  final Map<AssetType, int> items;

  const AssetInventory(this.items);

  int count(AssetType type) => items[type] ?? 0;

  AssetInventory add(AssetType type, int amount) {
    return AssetInventory({
      ...items,
      type: count(type) + amount,
    });
  }
}

class Building {
  final String name;
  final CareerTrack track;
  final int requiredLevel;
  final Map<AssetType, int> requirements;

  const Building({
    required this.name,
    required this.track,
    required this.requiredLevel,
    required this.requirements,
  });
}


const buildings = [
  Building(
    name: "💡 Idea Hub",
    track: CareerTrack.business,
    requiredLevel: 2,
    requirements: {
      AssetType.realEstate: 5,
    },
  ),
  Building(
    name: "🏭 Small Workshop",
    track: CareerTrack.business,
    requiredLevel: 3,
    requirements: {
      AssetType.realEstate: 10,
      AssetType.land: 5,
    },
  ),
  Building(
    name: "📦 Storage Unit",
    track: CareerTrack.business,
    requiredLevel: 3,
    requirements: {
      AssetType.land: 8,
    },
  ),
  Building(
    name: "🏢 Office Building",
    track: CareerTrack.business,
    requiredLevel: 4,
    requirements: {
      AssetType.realEstate: 20,
      AssetType.officeEquipment: 10,
    },
  ),
  Building(
    name: "📊 Analytics Center",
    track: CareerTrack.business,
    requiredLevel: 4,
    requirements: {
      AssetType.officeEquipment: 15,
    },
  ),
  Building(
    name: "🏙️ HQ Tower",
    track: CareerTrack.business,
    requiredLevel: 5,
    requirements: {
      AssetType.realEstate: 50,
      AssetType.land: 20,
    },
  ),

  // JOB
  Building(
    name: "🪑 Office Desk",
    track: CareerTrack.job,
    requiredLevel: 2,
    requirements: {
      AssetType.officeEquipment: 3,
    },
  ),
  Building(
    name: "👥 Team Office",
    track: CareerTrack.job,
    requiredLevel: 3,
    requirements: {
      AssetType.officeEquipment: 8,
    },
  ),
  Building(
    name: "🏬 Department Office",
    track: CareerTrack.job,
    requiredLevel: 4,
    requirements: {
      AssetType.officeEquipment: 15,
      AssetType.realEstate: 10,
    },
  ),
  Building(
    name: "🏢 Corporate HQ",
    track: CareerTrack.job,
    requiredLevel: 5,
    requirements: {
      AssetType.officeEquipment: 30,
      AssetType.realEstate: 25,
    },
  ),
];


class CareerState {
  final CareerTrack track;
  final int level;

  const CareerState({
    required this.track,
    required this.level,
  });

  CareerState copyWith({
    CareerTrack? track,
    int? level,
  }) {
    return CareerState(
      track: track ?? this.track,
      level: level ?? this.level,
    );
  }
}

const _kpKey = 'kp';
const _gemsKey = 'gems';
const _careerTrackKey = 'careerTrack';
const _careerLevelKey = 'careerLevel';
const _lastIncomeTimeKey = 'lastIncomeTime';

String trackLabel(CareerTrack track) {
  switch (track) {
    case CareerTrack.student:
      return "Student";
    case CareerTrack.business:
      return "Business";
    case CareerTrack.job:
      return "Job";
  }
}

int dailyIncome(CareerTrack track, int level) {
  if (track == CareerTrack.student) return 2;

  if (track == CareerTrack.business) {
    return [0, 4, 8, 15, 30][level];
  }

  if (track == CareerTrack.job) {
    return [0, 4, 7, 12, 20][level];
  }

  return 0;
}

int requiredKpFor(CareerTrack track, int nextLevel) {
  if (nextLevel <= 1) return 0;

  if (track == CareerTrack.business) {
    return [0, 0, 2000, 5000, 12000, 25000][nextLevel];
  }

  if (track == CareerTrack.job) {
    return [0, 0, 1500, 4000, 9000, 20000][nextLevel];
  }

  return 0;
}

String levelName(CareerTrack track, int level) {
  if (track == CareerTrack.student) return "Student";

  if (track == CareerTrack.business) {
    return ["", "Student", "Idea", "Bootstrap", "Funded", "Unicorn"][level];
  }

  if (track == CareerTrack.job) {
    return ["", "Student", "Employee", "Supervisor", "Manager", "CEO"][level];
  }

  return "";
}


Future<void> saveGameState({
  required int kp,
  required int gems,
  required CareerState career,
  required DateTime lastIncomeTime,
}) async {
  final prefs = await SharedPreferences.getInstance();
  debugPrint("💾 SAVING GAME");
  debugPrint("KP: $kp, Gems: $gems, Track: ${career.track}, Level: ${career.level}");
  await prefs.setInt(_kpKey, kp);
  await prefs.setInt(_gemsKey, gems);
  await prefs.setString(_careerTrackKey, career.track.name);
  await prefs.setInt(_careerLevelKey, career.level);
  await prefs.setInt(
    _lastIncomeTimeKey,
    lastIncomeTime.millisecondsSinceEpoch,
  );
}

Future<(int, int, CareerState, DateTime)> loadGameState() async {
  final prefs = await SharedPreferences.getInstance();
  final kp = prefs.getInt(_kpKey) ?? 0;
  final gems = prefs.getInt(_gemsKey) ?? 0;

  final trackName = prefs.getString(_careerTrackKey);
  final level = prefs.getInt(_careerLevelKey) ?? 1;

  final track = CareerTrack.values.firstWhere(
    (e) => e.name == trackName,
    orElse: () => CareerTrack.student,
  );

  final lastIncomeMillis =
      prefs.getInt(_lastIncomeTimeKey) ??
      DateTime.now().millisecondsSinceEpoch;

  debugPrint("Loaded KP: $kp");
  debugPrint("Loaded Gems: $gems");
  debugPrint("Loaded Track: ${track.name}");
  debugPrint("Loaded Level: $level");

  return (
    kp,
    gems,
    CareerState(track: track, level: level),
    DateTime.fromMillisecondsSinceEpoch(lastIncomeMillis),
  );
}


class BusinessLevel {
  final int level;
  final String name;
  final int requiredKp;

  const BusinessLevel({
    required this.level,
    required this.name,
    required this.requiredKp,
  });
}

const List<BusinessLevel> businessLevels = [
  BusinessLevel(level: 2, name: "Idea", requiredKp: 2000),
  BusinessLevel(level: 3, name: "Bootstrap", requiredKp: 5000),
  BusinessLevel(level: 4, name: "Funded", requiredKp: 10000),
  BusinessLevel(level: 5, name: "Unicorn", requiredKp: 25000),
];
const List<BusinessLevel> jobLevels = [
  BusinessLevel(level: 2, name: "Employee", requiredKp: 2000),
  BusinessLevel(level: 3, name: "Supervisor", requiredKp: 5000),
  BusinessLevel(level: 4, name: "Manager", requiredKp: 10000),
  BusinessLevel(level: 5, name: "CEO", requiredKp: 25000),
];



class CareerLevelInfo {
  final String name;
  final int dailyIncome;
  final List<String> unlockedBuildings;

  const CareerLevelInfo({
    required this.name,
    required this.dailyIncome,
    required this.unlockedBuildings,
  });
}

CareerLevelInfo? getCareerLevelInfo(CareerState career) {
  if (career.track == CareerTrack.business) {
    return businessCareerInfo[career.level];
  }
  return null;
}

const Map<int, CareerLevelInfo> businessCareerInfo = {
  2: CareerLevelInfo(
    name: "Idea",
    dailyIncome: 5,
    unlockedBuildings: [
      "💡 Idea Hub",
    ],
  ),
  3: CareerLevelInfo(
    name: "Bootstrap",
    dailyIncome: 10,
    unlockedBuildings: [
      "🏭 Small Workshop",
      "📦 Storage Unit",
    ],
  ),
  4: CareerLevelInfo(
    name: "Funded",
    dailyIncome: 25,
    unlockedBuildings: [
      "🏢 Office Building",
      "📊 Analytics Center",
    ],
  ),
  5: CareerLevelInfo(
    name: "Unicorn",
    dailyIncome: 60,
    unlockedBuildings: [
      "🏙️ HQ Tower",
      "🌐 Global Operations",
    ],
  ),
};

const Map<int, CareerLevelInfo> jobCareerInfo = {
  2: CareerLevelInfo(
    name: "Employee",
    dailyIncome: 4,
    unlockedBuildings: [
      "🏢 Office Desk",
    ],
  ),
  3: CareerLevelInfo(
    name: "Supervisor",
    dailyIncome: 8,
    unlockedBuildings: [
      "🧑‍🤝‍🧑 Team Office",
    ],
  ),
  4: CareerLevelInfo(
    name: "Manager",
    dailyIncome: 16,
    unlockedBuildings: [
      "🏬 Department Office",
    ],
  ),
  5: CareerLevelInfo(
    name: "CEO",
    dailyIncome: 40,
    unlockedBuildings: [
      "🏙️ Corporate HQ",
    ],
  ),
};

int getNextCareerLevel(CareerState career) {
  if (career.track == CareerTrack.business) {
    if (career.level == 1) return 2; // Student → Idea
    return career.level + 1;
  }
  return career.level;
}

void main() {
  runApp(const CityOfWealthApp());
}

class CityOfWealthApp extends StatelessWidget {
  const CityOfWealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.amber,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  late int kp;
  late int gems;
  late CareerState career;
  late DateTime lastIncomeTime;
  late AssetInventory assets;

  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  Future<void> _loadGame() async {
    final (savedKp, savedGems, savedCareer, savedIncomeTime) =
        await loadGameState();

    setState(() {
      kp = savedKp;
      gems = savedGems;
      career = savedCareer;
      lastIncomeTime = savedIncomeTime;
      assets = const AssetInventory({});
      _loaded = true;
    });
  }

  void _save() {
    saveGameState(
      kp: kp,
      gems: gems,
      career: career,
      lastIncomeTime: lastIncomeTime,
    );
  }

  Widget _buildBody() {
    switch (selectedIndex) {
      case 0:
        // HOME (Debug tools for now)
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    kp += 1000;
                    gems += 10;
                  });
                  _save();
                },
                child: const Text("💥 Add 1,000 KP and 10 gems (debug)"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    career = const CareerState(
                      track: CareerTrack.student,
                      level: 1,
                    );
                  });
                  _save();
                },
                child: const Text("🔁 Reset career to Level 1 (debug)"),
              ),
            ],
          ),
        );
      case 1:
        // CITY
        return CityView(
          career: career,
          gems: gems,
          assets: assets, // 👈 ADD THIS
          onBuyAsset: (type, amount) {
            // simple v1 logic: each asset costs 10 gems
            if (gems < 10 * amount) return;

            setState(() {
              gems -= 10 * amount;
              assets = assets.add(type, amount);
            });
            _save();
          },
        );

      case 2:
        // MONEY
        return MoneyView(
          currentKp: kp,
          career: career,
          gems: gems,
          onKpChange: (delta) {
            setState(() => kp += delta);
            _save();
          },
          onCareerChange: (newCareer) {
            setState(() => career = newCareer);
            _save();
          },
        );

      case 3:
        // SETTINGS
        return const Center(
          child: Text("Settings", style: TextStyle(fontSize: 22)),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
appBar: AppBar(
  title: const Text("City of Wealth"),
  actions: [
    _CounterChip(label: "KP", value: kp, icon: Icons.school),
    const SizedBox(width: 8),
    _CounterChip(label: "Gems", value: gems, icon: Icons.diamond),
    const SizedBox(width: 12),
  ],
),
body: _buildBody(),


      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() => selectedIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.amber.shade700,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            label: "City",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: "Money",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

class _CounterChip extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;

  const _CounterChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text("$label: $value"),
    );
  }
}

class CityView extends StatefulWidget {
  final CareerState career;
  final int gems;
  final AssetInventory assets;
  final void Function(AssetType type, int amount) onBuyAsset;


  const CityView({
    super.key,
    required this.career,
    required this.gems,
    required this.assets,
    required this.onBuyAsset,
  });

  @override
  State<CityView> createState() => _CityViewState();
}


class _CityViewState extends State<CityView> {
  void _openBuildingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BuildingsBottomSheet(
        career: widget.career,
        assets: widget.assets,
        onClose: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ✅ YOUR BELOVED GRID — UNTOUCHED
        Center(
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateX(-math.pi / 6)
              ..rotateZ(math.pi / 4),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _IsometricGridOld(),
                Positioned(
                  child: _PalaceOld(),
                ),
              ],
            ),
          ),
        ),

        // 👇 ADD BUILDINGS BUTTON
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (_) {
                  return _BuildingsBottomSheet(
                    career: widget.career,
                    assets: widget.assets,
                    onClose: () {
                      Navigator.pop(context); // 👈 THIS is onClose
                      setState(() {});         // optional refresh
                    },
                  );
                },
              );
            },
            label: const Text("Add buildings"),
            icon: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}



class _BuildingsBottomSheet extends StatelessWidget {
  final CareerState career;
  final AssetInventory assets;
  final VoidCallback onClose;

  const _BuildingsBottomSheet({
    required this.career,
    required this.assets,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final available = buildings.where(
      (b) => b.track == career.track,
    );

    return Container(
      height: 360,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: const [
          BoxShadow(blurRadius: 20, color: Colors.black26),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              const Text(
                "Available Buildings",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // List
          Expanded(
            child: available.isEmpty
                ? const Center(
                    child: Text(
                      "No buildings available yet.\nAdvance your career to unlock construction.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView(
                    children: available
                        .map(
                          (b) => _BuildingCard(
                            building: b,
                            career: career,
                            assets: assets,
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => this,
    );
  }
}


class _BuildingCard extends StatelessWidget {
  final Building building;
  final CareerState career;
  final AssetInventory assets;

  const _BuildingCard({
    required this.building,
    required this.career,
    required this.assets,
  });

  @override
  Widget build(BuildContext context) {
    final hasLevel = career.level >= building.requiredLevel;

    final hasAssets = building.requirements.entries.every(
      (e) => assets.count(e.key) >= e.value,
    );

    final canBuild = hasLevel && hasAssets;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: canBuild ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  building.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Requires level ${building.requiredLevel}",
                  style: TextStyle(
                    fontSize: 12,
                    color: hasLevel ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: building.requirements.entries.map((e) {
              final owned = assets.count(e.key);
              return Text(
                "${assetLabel(e.key)}: ${e.value}",
                style: TextStyle(
                  color: owned >= e.value ? Colors.green : Colors.red,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _CityBuildMenu extends StatelessWidget {
  final AssetInventory assets;
  final int gems;
  final void Function(AssetType, int) onBuyAsset;

  const _CityBuildMenu({
    required this.assets,
    required this.gems,
    required this.onBuyAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(blurRadius: 8, color: Colors.black12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Assets",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            children: AssetType.values.map((type) {
              return ElevatedButton(
                onPressed: gems >= 10
                    ? () => onBuyAsset(type, 1)
                    : null,
                child: Text(
                  "${type.name} (${assets.count(type)})",
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class MoneyView extends StatelessWidget {
  final int currentKp;
  final void Function(int) onKpChange;
  final CareerState career;
  final int gems;
  final void Function(CareerState) onCareerChange;

  const MoneyView({
    super.key,
    required this.currentKp,
    required this.onKpChange,
    required this.career,
    required this.gems,
    required this.onCareerChange,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _MoneyTileData("Career", Icons.badge),
      _MoneyTileData("Passive Income", Icons.trending_up),
      _MoneyTileData("Assets", Icons.account_balance),
      _MoneyTileData("Liabilities", Icons.warning),
      _MoneyTileData("Quiz", Icons.quiz),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _MoneyTile(
            data: item,
            onTap: () {
              if (item.title == "Quiz") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizMenuScreen(
                      currentKp: currentKp,
                      onKpChange: onKpChange,
                    ),
                  ),
                );
              }
              if (item.title == "Career") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CareerScreen(
                      career: career,
                      currentKp: currentKp,
                      onCareerChange: onCareerChange,
                    ),
                  ),
                );
              }
              if (item.title == "Assets") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AssetsScreen(
                      assets: const AssetInventory({}),
                      gems: gems,
                      onBuyAsset: (type) {
                        // Handle asset purchase
                      },
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class AssetsScreen extends StatelessWidget {
  final AssetInventory assets;
  final int gems;
  final void Function(AssetType type) onBuyAsset;

  const AssetsScreen({
    super.key, 
    required this.assets,
    required this.gems,
    required this.onBuyAsset,    
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assets")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: AssetType.values.map((type) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    assetLabel(type),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Text("Owned: ${assets.count(type)}"),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: gems >= assetCost(type)
                      ? () => onBuyAsset(type)
                      : null,
                  child: Text("Buy (${assetCost(type)} 💎)"),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MoneyTileData {
  final String title;
  final IconData icon;

  _MoneyTileData(this.title, this.icon);
}

class _MoneyTile extends StatelessWidget {
  final _MoneyTileData data;
  final VoidCallback onTap;

  const _MoneyTile({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              offset: Offset(2, 4),
              color: Colors.black12,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(data.icon, size: 42),
            const SizedBox(height: 12),
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
class QuizScreen extends StatefulWidget {
  final int currentKp;
  final void Function(int) onKpChange;

  const QuizScreen({super.key, required this.currentKp, required this.onKpChange});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int current = 0;
  int? selected;
  bool showExplanation = false;
  int correctCount = 0;

  final questions = [
    _Question(
      "What should you build first?",
      ["Car fund", "Emergency fund", "Stocks", "Crypto"],
      1,
      "An emergency fund protects you from job loss, medical bills, and unexpected expenses.",
    ),
    _Question(
      "Which of these is a liability?",
      ["Rental house", "Education", "Credit card debt", "Index fund"],
      2,
      "Liabilities take money out of your pocket instead of putting money in.",
    ),
    _Question(
      "What does passive income mean?",
      [
        "Work once, earn repeatedly",
        "High salary",
        "Fast money",
        "Overtime"
      ],
      0,
      "Passive income keeps generating cash with little daily effort.",
    ),
    _Question(
      "Best long-term investing strategy?",
      [
        "Timing the market",
        "Index funds",
        "Day trading",
        "Panic selling"
      ],
      1,
      "Index funds give diversification, low fees, and long-term growth.",
    ),
    _Question(
      "Emergency fund should cover?",
      ["1 month", "3–6 months", "10 years", "Only rent"],
      1,
      "3–6 months gives enough buffer to recover from income shocks.",
    ),
  ];

  void selectAnswer(int index) {
    if (selected != null) return;

    final correct = index == questions[current].correctIndex;
    if (correct) correctCount++;

    widget.onKpChange(correct ? 50 : -10);

    setState(() {
      selected = index;
      showExplanation = true;
    });
  }


  void nextQuestion() {
    if (current < questions.length - 1) {
      setState(() {
      selected = null;
        showExplanation = false;
        current++;
      });
    } else {
      final deltaKp = correctCount * 50 - (questions.length - correctCount) * 10;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizAnalysisScreen(
            score: correctCount,
            total: questions.length,
            currentKp: widget.currentKp,
            deltaKp: deltaKp,
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final q = questions[current];
    final progress = (current + 1) / questions.length;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Quiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress bar (fixed)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade300,
                color: Colors.amber.shade600,
              ),
            ),

            const SizedBox(height: 16),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Question card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(0, 6),
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Question ${current + 1}",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            q.question,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Answers
                    ...List.generate(q.options.length, (i) {
                      Color bg = Colors.white;

                      if (selected != null) {
                        if (i == q.correctIndex) {
                          bg = Colors.green.shade200;
                        } else if (i == selected) {
                          bg = Colors.red.shade200;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => selectAnswer(i),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                  color: Colors.black12,
                                ),
                              ],
                            ),
                            child: Text(
                              q.options[i],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 16),

                    // Explanation
                    if (showExplanation)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Why?",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(q.explanation),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Bottom button (fixed)
            if (showExplanation)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: nextQuestion,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text("Next"),
                ),
              ),
          ],
        ),
      ),

    );
  }
}

class _Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  _Question(
    this.question,
    this.options,
    this.correctIndex,
    this.explanation,
  );
}

class QuizAnalysisScreen extends StatelessWidget {
  final int score;
  final int total;
  final int currentKp;
  final int deltaKp;

  const QuizAnalysisScreen({
    super.key,
    required this.score,
    required this.total,
    required this.currentKp,
    required this.deltaKp,
  });

  String get message {
    switch (score) {
      case 0:
        return "Don't lose hope, keep playing";
      case 1:
        return "Focus on the good part, you still get to learn";
      case 2:
        return "Not bad, Keep going!";
      case 3:
        return "Good job, you got this!";
      case 4:
        return "Almost there user! Next one is in the bag, isn't it?";
      case 5:
        return "Perfection!";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = score / total;
    final newKp = currentKp + deltaKp;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const _ConfettiLayer(),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Score ring
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 100,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.green,
                        ),
                        Text(
                          "$score/$total",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Message
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // KP summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "KP: $currentKp + $deltaKp = $newKp",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Next Quiz"),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, (r) => r.isFirst);
                    },
                    child: const Text("Back to quizzes"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfettiLayer extends StatelessWidget {
  const _ConfettiLayer();

  @override
  Widget build(BuildContext context) {
    final Random random = Random();
    final Size size = MediaQuery.of(context).size;

    return IgnorePointer(
      child: Stack(
        children: List.generate(25, (i) {
          return Positioned(
            left: random.nextDouble() * size.width,
            top: random.nextDouble() * size.height,
            child: Text(
              ["🎉", "✨", "🎊"][random.nextInt(3)],
              style: TextStyle(
                fontSize: 22.0 + random.nextDouble() * 12.0,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class QuizMenuScreen extends StatelessWidget {
  final int currentKp;
  final void Function(int) onKpChange;

  const QuizMenuScreen({
    super.key,
    required this.currentKp,
    required this.onKpChange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quizzes")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text("Quiz 1"),
            subtitle: const Text("Foundations of finance"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizScreen(
                    currentKp: currentKp,
                    onKpChange: onKpChange,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CareerScreen extends StatefulWidget {
  final CareerState career;
  final int currentKp;
  final void Function(CareerState) onCareerChange;

  const CareerScreen({
    super.key,
    required this.career,
    required this.currentKp,
    required this.onCareerChange,
  });

  @override
  State<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends State<CareerScreen> {
  late CareerState career;

  @override
  void initState() {
    super.initState();
    career = widget.career;
  }

  void _updateCareer(CareerState newCareer) {
    setState(() {
      career = newCareer;
      widget.onCareerChange(newCareer);
    });
    _save();
  }

  void _save() {
    saveGameState(
      kp: widget.currentKp,
      gems: 0,
      career: career,
      lastIncomeTime: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Career")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CareerHeroCard(
              key: ValueKey('${career.track}-${career.level}'),
              career: career,
              currentKp: widget.currentKp,
              onCareerChange: _updateCareer,
            ),

            const SizedBox(height: 24),

            _CareerProgress(career: career),

            if (career.level == 1) ...[
              const SizedBox(height: 32),
              _CareerHint(),
            ] 
            else if(career.level <= 4)...[
              const SizedBox(height: 32),
              _CareerCard(career: CareerState(
                track: career.track,
                level: career.level + 1,
              )),
            ],
          ],
        ),
      ),
    );
  }
}

class _CareerHeroCard extends StatelessWidget {
  final CareerState career;
  final int currentKp;
  final void Function(CareerState) onCareerChange;

  const _CareerHeroCard({
    super.key,
    required this.career,
    required this.currentKp,
    required this.onCareerChange,
  });

  // ---------- HELPERS ----------

  CareerLevelInfo _currentInfo() {
    switch (career.track) {
      case CareerTrack.business:
        return businessCareerInfo[career.level]!;
      case CareerTrack.job:
        return jobCareerInfo[career.level]!;
      case CareerTrack.student:
        return const CareerLevelInfo(
          name: "Student",
          dailyIncome: 2,
          unlockedBuildings: [],
        );
    }
  }

  int _requiredKpForNext() {
    final nextLevel = career.level + 1;

    // Max level reached
    if (nextLevel > 5) return 0;

    // Student → first real level
    if (career.track == CareerTrack.student) {
      return 2000;
    }

    final levels = career.track == CareerTrack.business
        ? businessLevels
        : jobLevels;

    final match = levels.where((l) => l.level == nextLevel);

    if (match.isEmpty) {
      debugPrint("⚠️ No KP requirement for level $nextLevel");
      return 0; // graceful fallback
    }

    return match.first.requiredKp;
  }


  void _advance() {
    onCareerChange(
      CareerState(
        track: career.track,
        level: career.level + 1,
      ),
    );
  }

  void _openCareerChoice(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Choose your career path",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _TrackChoiceTile(
                title: "Business",
                subtitle: "High risk, high reward",
                onTap: () {
                  Navigator.pop(context);
                  onCareerChange(
                    const CareerState(
                      track: CareerTrack.business,
                      level: 2,
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              _TrackChoiceTile(
                title: "Job",
                subtitle: "Stable growth, steady income",
                onTap: () {
                  Navigator.pop(context);
                  onCareerChange(
                    const CareerState(
                      track: CareerTrack.job,
                      level: 2,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final info = _currentInfo();
    final hasNextLevel = career.level < 5;
    final requiredKp = hasNextLevel ? _requiredKpForNext() : 0;
    final canAdvance = hasNextLevel && currentKp >= requiredKp;
debugPrint(
  "CareerHeroCard → ${career.track} L${career.level}",
);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Text(
            career.track == CareerTrack.student
                ? "Current status"
                : career.track == CareerTrack.business
                    ? "Business career"
                    : "Job career",
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 1.2,
              color: Colors.brown.shade400,
            ),
          ),

          const SizedBox(height: 8),

          // LEVEL NAME
          Text(
            info.name,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // DAILY INCOME
          Row(
            children: [
              const Text("Daily income"),
              const Spacer(),
              Text(
                "💎 ${info.dailyIncome} Gems",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ACTION AREA
          if (hasNextLevel) ...[
            Row(
              children: [
                const Text("Required KP"),
                const Spacer(),
                Text(
                  "$requiredKp",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: canAdvance ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canAdvance
                    ? () {
                        if (career.track == CareerTrack.student) {
                          _openCareerChoice(context);
                        } else {
                          _advance();
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAdvance
                      ? Colors.green.shade600
                      : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  career.track == CareerTrack.student
                      ? "Choose career path"
                      : "Advance to next level",
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CareerProgress extends StatelessWidget {
  final CareerState career;

  const _CareerProgress({required this.career});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Career Progress",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(5, (index) {
            final level = index + 1;
            final isActive = level <= career.level;

            return Expanded(
              child: Container(
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green.shade400
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _CareerHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "Complete your student phase to unlock your next big decision:\n\n"
        "• Build a business\n"
        "• Or climb the corporate ladder\n\n"
        "Choose wisely — both paths shape your city differently.",
        style: TextStyle(fontSize: 15, height: 1.4),
      ),
    );
  }
}

class _CareerCard extends StatelessWidget {
  final CareerState career;

  const _CareerCard({
    required this.career,
  });

  CareerLevelInfo? _info() {
    if (career.track == CareerTrack.business) {
      return businessCareerInfo[career.level];
    }
    if (career.track == CareerTrack.job) {
      return jobCareerInfo[career.level];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final info = _info();

    if (info == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            career.track == CareerTrack.business ? "Next Level" : "Next Level",
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 1.2,
              color: Colors.brown.shade400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            info.name,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text("Daily income"),
              const Spacer(),
              Text(
                "💎 ${info.dailyIncome} Gems",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Unlocked in your city",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...info.unlockedBuildings.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text("• $b"),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackChoiceTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TrackChoiceTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int kp;
  late int gems;
  late CareerState career;
  late DateTime lastIncomeTime;

  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadGame();
  }
  void _collectDailyIncome(int dailyIncome) {
    final now = DateTime.now();
    final diff = now.difference(lastIncomeTime);

    if (diff.inHours >= 24) {
      final cycles = diff.inHours ~/ 24;

      setState(() {
        gems += dailyIncome * cycles;
        lastIncomeTime =
            lastIncomeTime.add(Duration(hours: 24 * cycles));
      });

      _save();
    }
  }
  void _save() {
    saveGameState(
      kp: kp,
      gems: gems,
      career: career,
      lastIncomeTime: lastIncomeTime,
    );
  }

  Future<void> _loadGame() async {
    final (savedKp, savedGems, savedCareer, savedIncomeTime) =
        await loadGameState();

      debugPrint("LOADED KP: $savedKp");
      debugPrint("LOADED CAREER: ${savedCareer.track} L${savedCareer.level}");

    setState(() {
      kp = savedKp;
      gems = savedGems;
      career = savedCareer;
      lastIncomeTime = savedIncomeTime;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Home Screen"),
      ),
    );
  }
}
class _IsometricGridOld extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const int gridSize = 5;
    const double tileSize = 50;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(gridSize, (y) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(gridSize, (x) {
            return Container(
              width: tileSize,
              height: tileSize,
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.green.shade300,
                border: Border.all(color: Colors.green.shade700),
              ),
            );
          }),
        );
      }),
    );
  }
}

class _PalaceOld extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.amber.shade600,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(2, 4),
            color: Colors.black26,
          )
        ],
      ),
      child: const Icon(
        Icons.account_balance,
        size: 36,
        color: Colors.white,
      ),
    );
  }
}