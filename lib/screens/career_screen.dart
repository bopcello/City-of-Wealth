import 'package:flutter/material.dart';
import '../game_state.dart';
import '../widgets/icon_text.dart';
import '../theme/app_colors.dart';
import '../services/sfx_manager.dart';

import '../logic/game_manager.dart';

class CareerScreen extends StatefulWidget {
  final GameManager game;
  final SfxManager sfx;

  const CareerScreen({super.key, required this.game, required this.sfx});

  @override
  State<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends State<CareerScreen> {
  late CareerState career;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.game,
      builder: (context, _) => _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Career")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CareerHeroCard(
              key: ValueKey(
                '${widget.game.career.track}-${widget.game.career.level}',
              ),
              career: widget.game.career,
              sfx: widget.sfx,
              currentKp: widget.game.kp,
              cityLayout: widget.game.cityLayout,
              onCareerChange: widget.game.updateCareer,
              completedQuizzes: widget.game.completedQuizzes,
              isWorkingOvertime: widget.game.isWorkingOvertime,
              onWorkOvertime: widget.game.workOvertime,
            ),
            const SizedBox(height: 24),
            _CareerProgress(career: widget.game.career),
            if (widget.game.career.level == 1) ...[
              const SizedBox(height: 32),
              _CareerHint(),
            ] else if (widget.game.career.level <= 4) ...[
              const SizedBox(height: 32),
              _CareerCard(
                career: CareerState(
                  track: widget.game.career.track,
                  level: widget.game.career.level + 1,
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
  final SfxManager sfx;
  final int currentKp;
  final List<PlacedBuilding> cityLayout;
  final void Function(CareerState) onCareerChange;
  final Set<String> completedQuizzes;
  final bool isWorkingOvertime;
  final VoidCallback onWorkOvertime;

  const _CareerHeroCard({
    super.key,
    required this.career,
    required this.sfx,
    required this.currentKp,
    required this.cityLayout,
    required this.onCareerChange,
    required this.completedQuizzes,
    required this.isWorkingOvertime,
    required this.onWorkOvertime,
  });

  CareerLevelInfo _currentInfo() {
    return (getCareerLevelInfo(career) ?? studentLevelInfo);
  }

  int _requiredKpForNext() {
    return requiredKpFor(career.track, career.level + 1);
  }

  List<String> _getMissingBuildings() {
    if (career.level == 1) return [];
    final info = getCareerLevelInfo(career);
    if (info == null) return [];

    List<String> missing = [];
    for (var bName in info.unlockedBuildings) {
      bool exists = cityLayout.any((pb) => pb.name == bName);
      if (!exists) missing.add(bName);
    }
    return missing;
  }

  bool _hasMetQuizRequirements() {
    // Current level requirements: 10 Medium, 1 Hard
    final mediumCount = countCompletedMediumQuizzes(
      completedQuizzes,
      career.level,
    );
    final hardCount = countCompletedHardQuizzes(completedQuizzes, career.level);

    final hasMetCurrentLevelReqs = mediumCount >= 10 && hardCount >= 1;

    return hasMetCurrentLevelReqs;
  }

  int _getMediumQuizCount() =>
      countCompletedMediumQuizzes(completedQuizzes, career.level);
  int _getHardQuizCount() =>
      countCompletedHardQuizzes(completedQuizzes, career.level);

  void _advance() {
    sfx.playLevelUp();
    onCareerChange(CareerState(track: career.track, level: career.level + 1));
  }

  void _openCareerChoice(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      routeSettings: const RouteSettings(name: 'mute_back_sound'),
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
                  sfx.playLevelUp();
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
                  sfx.playLevelUp();
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
    final missingBuildings = _getMissingBuildings();
    final hasAllBuildings = missingBuildings.isEmpty;
    final hasKeyQuizRequirements = _hasMetQuizRequirements();

    // Only apply quiz requirements for levels > 1
    final isQuizRequirementMet = hasKeyQuizRequirements;

    final canAdvance =
        hasNextLevel &&
        currentKp >= requiredKpValue &&
        hasAllBuildings &&
        isQuizRequirementMet;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
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
              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
              IconText(
                "[GEM] ${info.dailyIncome}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.of(context, 'gem'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (hasNextLevel) ...[
            Row(
              children: [
                const Text(
                  "Required KP",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
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
            if (hasNextLevel && !hasAllBuildings) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "To advance, build at least one of each:",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...missingBuildings.map(
                      (b) => Text(
                        "• $b",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.of(context, 'error'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (hasNextLevel && !isQuizRequirementMet) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Required Quizzes:",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "• Medium Quizzes: ${_getMediumQuizCount()}/10",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.of(context, 'error'),
                      ),
                    ),
                    Text(
                      "• Hard Quizzes: ${_getHardQuizCount()}/1",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.of(context, 'error'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
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
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: isWorkingOvertime
                    ? null
                    : () {
                        sfx.playClick();
                        onWorkOvertime();
                      },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isWorkingOvertime
                        ? Colors.grey.shade400
                        : Colors.amber.shade700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Column(
                  children: [
                    Text(
                      isWorkingOvertime
                          ? (career.track == CareerTrack.student
                                ? "Extra pocket money!"
                                : "Working overtime")
                          : (career.track == CareerTrack.student
                                ? "Ask for extra pocket money"
                                : "Work overtime"),
                      style: TextStyle(
                        color: isWorkingOvertime
                            ? Colors.grey.shade600
                            : Colors.amber.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      career.track == CareerTrack.student
                          ? "Ask parents for more allowance"
                          : "Boost income by 50% at the cost of health and time",
                      style: TextStyle(
                        fontSize: 10,
                        color: isWorkingOvertime
                            ? Colors.grey.shade500
                            : Colors.brown.shade400,
                      ),
                    ),
                  ],
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
                      ? AppColors.of(context, 'success')
                      : AppColors.of(context, 'outline'),
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
        color: Theme.of(context).colorScheme.surfaceVariant,
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
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Next Level",
            style: TextStyle(fontSize: 14, letterSpacing: 1.2),
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
              IconText(
                "[GEM] ${info.dailyIncome}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.of(context, 'gem'),
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
              child: Text(
                "• $b",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
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
          color: Theme.of(context).colorScheme.surfaceVariant,
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
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
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
