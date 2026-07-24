import 'package:flutter/material.dart';
import '../models/city_sharing_models.dart';
import '../theme/app_colors.dart';
import '../widgets/icon_text.dart';
import 'city_viewer_screen.dart';

class LeaderboardEntry {
  final String uid;
  final String name;
  final int kp;
  final int streak;
  final String title;
  final bool isSelf;
  final PublicCitySnapshot? snapshot;

  LeaderboardEntry({
    required this.uid,
    required this.name,
    required this.kp,
    required this.streak,
    required this.title,
    required this.isSelf,
    this.snapshot,
  });
}

class LeaderboardScreen extends StatelessWidget {
  final String currentUid;
  final String myPlayerName;
  final int myKp;
  final int myStreak;
  final String myTitle;
  final Map<String, PublicCitySnapshot> friendSnapshots;

  const LeaderboardScreen({
    super.key,
    required this.currentUid,
    required this.myPlayerName,
    required this.myKp,
    required this.myStreak,
    required this.myTitle,
    required this.friendSnapshots,
  });

  @override
  Widget build(BuildContext context) {
    final List<LeaderboardEntry> entries = [];

    // Add player themselves
    entries.add(LeaderboardEntry(
      uid: currentUid,
      name: myPlayerName,
      kp: myKp,
      streak: myStreak,
      title: myTitle,
      isSelf: true,
    ));

    // Add friends
    for (final entry in friendSnapshots.entries) {
      final friendUid = entry.key;
      final snap = entry.value;
      entries.add(LeaderboardEntry(
        uid: friendUid,
        name: snap.playerName,
        kp: snap.kp,
        streak: snap.streak,
        title: snap.title,
        isSelf: false,
        snapshot: snap,
      ));
    }

    // Sort by KP descending
    entries.sort((a, b) => b.kp.compareTo(a.kp));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "KP Leaderboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: entries.isEmpty
          ? const Center(
              child: Text(
                "No participants yet.\nAdd friends to compete!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                final rank = index + 1;

                Widget rankBadge;
                if (rank == 1) {
                  rankBadge = const Text("🥇", style: TextStyle(fontSize: 24));
                } else if (rank == 2) {
                  rankBadge = const Text("🥈", style: TextStyle(fontSize: 24));
                } else if (rank == 3) {
                  rankBadge = const Text("🥉", style: TextStyle(fontSize: 24));
                } else {
                  rankBadge = Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "#$rank",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }

                Color? borderColor;
                if (entry.isSelf) {
                  borderColor = Theme.of(context).colorScheme.primary;
                } else if (rank == 1) {
                  borderColor = Colors.amber;
                }

                return Card(
                  elevation: entry.isSelf ? 3 : 1,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: borderColor != null
                        ? BorderSide(color: borderColor, width: entry.isSelf ? 2 : 1.5)
                        : BorderSide.none,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: entry.isSelf || entry.snapshot == null
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CityViewerScreen(
                                  snapshot: entry.snapshot!,
                                  myPlayerName: myPlayerName,
                                ),
                              ),
                            );
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 36,
                            child: Center(child: rankBadge),
                          ),
                          const SizedBox(width: 12),
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: entry.isSelf
                                ? Theme.of(context).colorScheme.primary
                                : AppColors.of(context, 'primary'),
                            child: Text(
                              entry.name.isNotEmpty ? entry.name[0].toUpperCase() : "?",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        entry.name,
                                        style: TextStyle(
                                          fontWeight:
                                              entry.isSelf ? FontWeight.bold : FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (entry.isSelf) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.primaryContainer,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          "You",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                if (entry.title.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    entry.title,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                const SizedBox(height: 4),
                                IconText(
                                  "[KP] ${entry.kp}   [STREAK] ${entry.streak}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!entry.isSelf && entry.snapshot != null) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
