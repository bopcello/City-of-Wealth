import 'package:flutter/material.dart';
import '../game_state.dart';

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
            ] else if (career.level <= 4) ...[
              const SizedBox(height: 32),
              _CareerCard(
                career: CareerState(
                  track: career.track,
                  level: career.level + 1,
                ),
              ),
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

  CareerLevelInfo _currentInfo() {
    switch (career.track) {
      case CareerTrack.business:
        return businessCareerInfo[career.level]!;
      case CareerTrack.job:
        return jobCareerInfo[career.level]!;
      case CareerTrack.student:
        return const CareerLevelInfo(
          name: "Student",
          dailyIncome: 20,
          unlockedBuildings: [],
        );
    }
  }

  int _requiredKpForNext() {
    final nextLevel = career.level + 1;
    if (nextLevel > 5) return 0;
    if (career.track == CareerTrack.student) return 2000;

    final levels = career.track == CareerTrack.business
        ? businessLevels
        : jobLevels;
    final match = levels.where((l) => l.level == nextLevel);
    if (match.isEmpty) return 0;

    return match.first.requiredKp;
  }

  void _advance() {
    onCareerChange(CareerState(track: career.track, level: career.level + 1));
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _TrackChoiceTile(
                title: "Business",
                subtitle: "High risk, high reward",
                onTap: () {
                  Navigator.pop(context);
                  onCareerChange(
                    const CareerState(track: CareerTrack.business, level: 2),
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
                    const CareerState(track: CareerTrack.job, level: 2),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = _currentInfo();
    final hasNextLevel = career.level < 5;
    final requiredKpValue = hasNextLevel ? _requiredKpForNext() : 0;
    final canAdvance = hasNextLevel && currentKp >= requiredKpValue;

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
          Text(
            info.name,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
          const SizedBox(height: 20),
          if (hasNextLevel) ...[
            Row(
              children: [
                const Text("Required KP"),
                const Spacer(),
                Text(
                  "$requiredKpValue",
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
  const _CareerCard({required this.career});

  @override
  Widget build(BuildContext context) {
    final info = getCareerLevelInfo(career);
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
          const Text(
            "Next Level",
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 1.2,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            info.name,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
