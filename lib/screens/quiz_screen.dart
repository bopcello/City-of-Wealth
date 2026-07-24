import 'package:flutter/material.dart';
import '../game_state.dart';
import '../data/quiz_data.dart';
import '../widgets/icon_text.dart';
import '../theme/app_colors.dart';
import '../services/music_manager.dart';
import '../services/sfx_manager.dart';
import '../logic/game_manager.dart';
import '../logic/tutorial_keys.dart';
import 'package:intl/intl.dart';

class QuizMenuScreen extends StatelessWidget {
  final GameManager game;
  final MusicManager music;
  final SfxManager sfx;

  const QuizMenuScreen({
    super.key,
    required this.game,
    required this.music,
    required this.sfx,
  });

  Color _getDifficultyColor(BuildContext context, QuizDifficulty difficulty) {
    switch (difficulty) {
      case QuizDifficulty.easy:
        return AppColors.of(context, 'success');
      case QuizDifficulty.medium:
        return AppColors.of(context, 'warning');
      case QuizDifficulty.hard:
        return AppColors.of(context, 'error');
    }
  }

  String _getDifficultyLabel(QuizDifficulty difficulty) {
    switch (difficulty) {
      case QuizDifficulty.easy:
        return 'Easy';
      case QuizDifficulty.medium:
        return 'Medium';
      case QuizDifficulty.hard:
        return 'Hard';
    }
  }

  int _getRepeatAward(QuizDifficulty difficulty) {
    switch (difficulty) {
      case QuizDifficulty.easy:
        return 0;
      case QuizDifficulty.medium:
        return 10;
      case QuizDifficulty.hard:
        return 15;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: game,
      builder: (context, _) {
        final currentLevel = game.career.level;
        final quizzes = getQuizzesForLevel(currentLevel);
        // Align with IST (GTM+5:30) used by the generator script
        final istTime = DateTime.now().toUtc().add(
          const Duration(hours: 5, minutes: 30),
        );
        final today = DateFormat('yyyy-MM-dd').format(istTime);
        debugPrint(
          "🧩 QuizMenuScreen: today(IST)=$today, level=$currentLevel, quizCount=${quizzes.length}",
        );
        final isDailyCompleted = game.lastDailyQuizDate == today;

        final bool isBackAllowed =
            !game.isTutorialActive || game.isTutorialBackAllowed;

        return PopScope(
          canPop: isBackAllowed,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              if (game.isTutorialActive) {
                game.onTutorialBackStepTriggered?.call();
              }
              return;
            }
            if (game.isTutorialActive && !game.isTutorialBackAllowed) {
              game.onBackGestureIntercepted?.call();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Quizzes"),
              leading: BackButton(
                key: TutorialKeys.quizBackKey,
                onPressed: () {
                  if (game.isTutorialActive) {
                    if (game.isTutorialBackAllowed) {
                      // Let the tutorial advance
                    } else {
                      game.onBackGestureIntercepted?.call();
                      return;
                    }
                  }
                  Navigator.pop(context);
                },
              ),
            ),
            body: Column(
              children: [
                // DAILY QUIZ PANEL AT THE TOP
                _buildDailyQuizPanel(context, today, isDailyCompleted),

                Expanded(
                  child: quizzes.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: quizzes.length,
                          itemBuilder: (context, index) {
                            final quiz = quizzes[index];
                            final scheme = quiz.markingScheme;
                            final isCompleted = game.completedQuizzes.contains(
                              quiz.id,
                            );

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isCompleted
                                        ? AppColors.of(context, 'success')
                                        : _getDifficultyColor(
                                            context,
                                            quiz.difficulty,
                                          ),
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: isCompleted
                                      ? AppColors.of(
                                          context,
                                          'success',
                                        ).withValues(alpha: 0.1)
                                      : Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    isCompleted
                                        ? Icons.check_circle
                                        : Icons.quiz,
                                    color: isCompleted
                                        ? AppColors.of(context, 'success')
                                        : _getDifficultyColor(
                                            context,
                                            quiz.difficulty,
                                          ),
                                  ),
                                  title: IconText(
                                    quiz.title,
                                    style: TextStyle(
                                      decoration: isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: isCompleted
                                          ? Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.5)
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                    ),
                                  ),
                                  subtitle: IconText(
                                    isCompleted
                                        ? '${quiz.subtitle}\n${_getDifficultyLabel(quiz.difficulty)} • Repeat Award: +${_getRepeatAward(quiz.difficulty)} KP'
                                        : '${quiz.subtitle}\n${_getDifficultyLabel(quiz.difficulty)} • +${scheme.correctPoints}/${scheme.wrongPoints} KP',
                                    style: TextStyle(
                                      color: isCompleted
                                          ? Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant
                                                .withValues(alpha: 0.7)
                                          : null,
                                    ),
                                  ),
                                  isThreeLine: true,
                                  trailing: const Icon(Icons.arrow_forward),
                                  onTap: () {
                                    sfx.playClick();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => QuizScreen(
                                          game: game,
                                          music: music,
                                          sfx: sfx,
                                          quiz: quiz,
                                          isCompleted: isCompleted,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyQuizPanel(
    BuildContext context,
    String today,
    bool isCompleted,
  ) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: game.firestoreService.getDailyQuiz(today),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint("❌ Daily Quiz Error: ${snapshot.error}");
          return const SizedBox.shrink(); // Hide if serious error, or show error box
        }

        final dailyData = snapshot.data;
        debugPrint(
          "🔍 Daily Quiz Check: date=$today, found=${dailyData != null}",
        );
        final title = dailyData?['title'] ?? "Daily Financial Challenge";
        final subtitle =
            dailyData?['subtitle'] ?? "Test your knowledge & earn rewards!";
        final isAvailable = dailyData != null;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            key: TutorialKeys.quizDailyPanelKey,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCompleted
                    ? Colors.grey.withValues(alpha: 0.5)
                    : (isAvailable
                          ? Colors.blue
                          : Colors.grey.withValues(alpha: 0.5)),
                width: isCompleted ? 1 : 3,
              ),
              color: isCompleted
                  ? Colors.grey.withValues(alpha: 0.1)
                  : (isAvailable
                        ? Colors.blue.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1)),
              boxShadow: (isAvailable && !isCompleted)
                  ? [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: InkWell(
              onTap: () async {
                sfx.playClick();
                if (isCompleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Daily quiz already completed! Check back tomorrow.",
                      ),
                    ),
                  );
                  return;
                }

                if (!isAvailable) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Daily quiz not available yet. Please try again later.",
                      ),
                    ),
                  );
                  return;
                }

                final dailyQuiz = QuizMetadata(
                  id: dailyData['id'],
                  title: dailyData['title'],
                  subtitle: dailyData['subtitle'],
                  difficulty: _parseDifficulty(dailyData['difficulty']),
                  requiredLevel: 1,
                  questions: (dailyData['options'] != null)
                      ? [
                          QuizQuestion(
                            question: dailyData['question'],
                            options: List<String>.from(dailyData['options']),
                            correctIndex: dailyData['correctIndex'],
                            correctExplanation: dailyData['correctExplanation'],
                            wrongExplanation: dailyData['wrongExplanation'],
                          ),
                        ]
                      : [],
                );

                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(
                        game: game,
                        music: music,
                        sfx: sfx,
                        quiz: dailyQuiz,
                        isDaily: true,
                        dailyDate: today,
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0), // Bigger box
                child: Row(
                  children: [
                    Icon(
                      isCompleted ? Icons.event_available : Icons.auto_awesome,
                      size: 48, // Bigger icon
                      color: isCompleted ? Colors.grey : Colors.blue,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "DAILY CHALLENGE",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: isCompleted
                                      ? Colors.grey
                                      : Colors.blue.shade700,
                                ),
                              ),
                              if (isAvailable && !isCompleted) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    "NEW",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 22, // Bigger title
                              fontWeight: FontWeight.bold,
                              color: isCompleted
                                  ? Colors.grey
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              CounterChip(
                                label: "[STREAK]",
                                value: game.dailyQuizStreak,
                                prefix: "Streak",
                              ),
                              CounterChip(
                                label: "[REVIVAL]",
                                value: game.streakRevivals,
                                prefix: "Revivals",
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              sfx.playClick();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PastQuizzesScreen(
                                    game: game,
                                    music: music,
                                    sfx: sfx,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.history, size: 16),
                            label: const Text(
                              "Past Challenges",
                              style: TextStyle(fontSize: 12),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: isCompleted
                                  ? Colors.grey
                                  : Colors.blue,
                              side: BorderSide(
                                color: isCompleted ? Colors.grey : Colors.blue,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isCompleted && isAvailable)
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.blue,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  QuizDifficulty _parseDifficulty(String? diff) {
    if (diff == 'medium') return QuizDifficulty.medium;
    if (diff == 'hard') return QuizDifficulty.hard;
    return QuizDifficulty.easy;
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: AppColors.of(context, 'warning'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Quizzes Coming Soon!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'We apologize for the inconvenience.\nOur quiz database for this level is still being curated.',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
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
  final GameManager game;
  final MusicManager music;
  final SfxManager sfx;
  final QuizMetadata quiz;
  final bool isCompleted;
  final bool isDaily;
  final bool isPractice;
  final String? dailyDate;

  const QuizScreen({
    super.key,
    required this.game,
    required this.music,
    required this.sfx,
    required this.quiz,
    this.isCompleted = false,
    this.isDaily = false,
    this.isPractice = false,
    this.dailyDate,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int current = 0;
  int? selected;
  int correctCount = 0;
  List<bool> results = [];
  late List<List<int>> _shuffledIndicesMap;

  @override
  void initState() {
    super.initState();
    _initializeShuffledIndices();
    widget.music.playQuizMusic();
  }

  void _initializeShuffledIndices() {
    _shuffledIndicesMap = widget.quiz.questions.map((q) {
      final indices = List.generate(q.options.length, (index) => index);
      indices.shuffle();
      return indices;
    }).toList();
  }

  void selectAnswer(int uiIndex) {
    if (selected != null) return;
    final question = widget.quiz.questions[current];
    final originalIndex = _shuffledIndicesMap[current][uiIndex];
    final correct = originalIndex == question.correctIndex;
    if (correct) correctCount++;
    results.add(correct);
    widget.game.recordQuestionResult(widget.quiz.difficulty, correct);
    setState(() => selected = uiIndex);
    if (correct) {
      widget.sfx.playCorrect();
    } else {
      widget.sfx.playIncorrect();
    }
    _showExplanationDialog(correct, question);
  }

  void _showExplanationDialog(bool wasCorrect, QuizQuestion question) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          wasCorrect ? 'Correct!' : 'Incorrect',
          style: TextStyle(
            color: wasCorrect ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!wasCorrect) ...[
                const Text(
                  'Why Your Answer is Wrong',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(question.wrongExplanation),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
              ],
              const Text(
                'Why This Answer is Correct',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(question.correctExplanation),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (current < widget.quiz.questions.length - 1) {
                nextQuestion();
              } else {
                if (!widget.isDaily && !widget.isPractice) {
                  widget.game.markQuizCompleted(widget.quiz.id);
                }
                nextQuestion();
              }
            },
            child: Text(
              current < widget.quiz.questions.length - 1 ? 'Next' : 'Finish',
            ),
          ),
        ],
      ),
    );
  }

  void nextQuestion() {
    if (current < widget.quiz.questions.length - 1) {
      setState(() {
        selected = null;
        current++;
      });
    } else {
      int award = 0;
      final scheme = widget.quiz.markingScheme;
      if (widget.isDaily) {
        award = 20; // Correct answer in daily quiz gives 20 KP
      } else if (widget.isPractice) {
        award = 10; // Practice questions give 10 KP
      } else if (widget.isCompleted) {
        switch (widget.quiz.difficulty) {
          case QuizDifficulty.easy:
            award = 0;
            break;
          case QuizDifficulty.medium:
            award = 10;
            break;
          case QuizDifficulty.hard:
            award = 15;
            break;
        }
      } else {
        award =
            (scheme.correctPoints * correctCount) +
            (scheme.wrongPoints *
                (widget.quiz.questions.length - correctCount));
      }

      int finalKpDelta = 0;
      final bool passed = correctCount >= widget.quiz.questions.length * 0.5;

      if (passed) {
        if (widget.isDaily && widget.dailyDate != null) {
          widget.game.completeDailyQuiz(
            true,
            widget.dailyDate!,
            widget.quiz.hash,
            isPractice: false,
          );
          finalKpDelta =
              20; // Daily correct = 20 KP (handled inside completeDailyQuiz)
        } else if (widget.isPractice && widget.dailyDate != null) {
          widget.game.completeDailyQuiz(
            true,
            widget.dailyDate!,
            widget.quiz.hash,
            isPractice: true,
          );
          finalKpDelta =
              10; // Practice correct = 10 KP (handled inside completeDailyQuiz)
        } else {
          finalKpDelta = award;
          widget.game.addKp(finalKpDelta);
        }
      } else if (widget.isDaily && widget.dailyDate != null) {
        widget.game.completeDailyQuiz(
          false,
          widget.dailyDate!,
          widget.quiz.hash,
          isPractice: false,
        );
      }

      widget.game.recordQuizCompleted(
        quizId: widget.quiz.id,
        difficulty: widget.quiz.difficulty,
        score: correctCount,
        totalQuestions: widget.quiz.questions.length,
        kpEarned: finalKpDelta,
        isDaily: widget.isDaily,
        isPractice: widget.isPractice,
        isReplay: widget.isCompleted,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizAnalysisScreen(
            game: widget.game,
            music: widget.music,
            sfx: widget.sfx,
            score: correctCount,
            total: widget.quiz.questions.length,
            deltaKp: finalKpDelta,
            results: results,
            currentQuizId: widget.quiz.id,
            level: widget.quiz.requiredLevel,
            passed: passed,
            isDaily: widget.isDaily,
            isPractice: widget.isPractice,
            dailyDate: widget.dailyDate,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.quiz.questions[current];
    final progress = (current + 1) / widget.quiz.questions.length;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) return;
        widget.music.playHomeMusic();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(widget.quiz.title),
          actions: [
            if (widget.isDaily || widget.isPractice)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: CounterChip(
                    label: "[STREAK]",
                    value: widget.game.dailyQuizStreak,
                    prefix: "Streak",
                  ),
                ),
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  color: Colors.amber.shade600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Question ${current + 1}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            IconText(
                              q.question,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...List.generate(q.options.length, (uiIndex) {
                        final originalIndex =
                            _shuffledIndicesMap[current][uiIndex];
                        Color bg = Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest;
                        if (selected != null) {
                          if (originalIndex == q.correctIndex) {
                            bg = Colors.green.withValues(alpha: 0.3);
                          } else if (uiIndex == selected) {
                            bg = Colors.red.withValues(alpha: 0.3);
                          }
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () => selectAnswer(uiIndex),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: bg,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: IconText(
                                q.options[originalIndex],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizAnalysisScreen extends StatelessWidget {
  final GameManager game;
  final MusicManager music;
  final SfxManager sfx;
  final int score;
  final int total;
  final int deltaKp;
  final List<bool> results;
  final String currentQuizId;
  final int level;
  final bool passed;
  final bool isDaily;
  final bool isPractice;
  final String? dailyDate;

  const QuizAnalysisScreen({
    super.key,
    required this.game,
    required this.music,
    required this.sfx,
    required this.score,
    required this.total,
    required this.deltaKp,
    required this.results,
    required this.currentQuizId,
    required this.level,
    required this.passed,
    this.isDaily = false,
    this.isPractice = false,
    this.dailyDate,
  });

  String get message {
    if (isDaily) {
      return passed
          ? "Spot on, ${game.playerName}! You've mastered today's financial challenge."
          : "Not quite this time, ${game.playerName}. But every mistake is a lesson in wealth.";
    }
    if (isPractice) {
      return passed
          ? "Great practice, ${game.playerName}! You got the answer right this time."
          : "Practice makes perfect, ${game.playerName}! Keep learning and you'll master this soon.";
    }
    if (!passed) return "Almost there, ${game.playerName}! Try again.";
    switch (score) {
      case 0:
        return "Don't lose hope ${game.playerName}, keep playing";
      case 1:
        return "Focus on the good part ${game.playerName}, you still get to learn";
      case 2:
        return "Not bad ${game.playerName}, Keep going!";
      case 3:
        return "Good job ${game.playerName}, you got this!";
      case 4:
        return "Almost there ${game.playerName}! Next one is in the bag, isn't it?";
      case 5:
        return "Perfection, ${game.playerName}!";
      default:
        return "Good Job!";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isDaily && passed) {
      // Check for milestones to show a special popup
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAndShowMilestonePopup(context);
      });
    }
    final progress = score / total;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) return;
        music.playHomeMusic();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 50,
                        color: progress >= 0.8
                            ? Colors.green
                            : (progress >= 0.5 ? Colors.orange : Colors.red),
                      ),
                      Text(
                        "$score/$total",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (isDaily && passed) ...[
                  const SizedBox(height: 12),
                  CounterChip(
                    label: "[STREAK]",
                    value: game.dailyQuizStreak,
                    prefix: "Streak",
                  ),
                  if (getStreakRewards(
                    game.dailyQuizStreak,
                  ).label.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Text(
                        getStreakRewards(game.dailyQuizStreak).label,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ],
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: List.generate(results.length, (index) {
                    final isCorrect = results[index];
                    return Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: isCorrect ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCorrect ? Icons.check : Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Text(
                    "KP: ${game.kp - deltaKp} ${deltaKp < 0 ? ' ' : '+ '}$deltaKp = ${game.kp}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                if (!isDaily)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        sfx.playClick();
                        final quizzes = getQuizzesForLevel(level);
                        final currentIndex = quizzes.indexWhere(
                          (q) => q.id == currentQuizId,
                        );
                        if (currentIndex != -1 &&
                            currentIndex < quizzes.length - 1) {
                          final nextQuiz = quizzes[currentIndex + 1];
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizScreen(
                                game: game,
                                music: music,
                                sfx: sfx,
                                quiz: nextQuiz,
                                isCompleted: game.completedQuizzes.contains(
                                  nextQuiz.id,
                                ),
                              ),
                            ),
                          );
                        } else {
                          music.playHomeMusic();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Next Quiz"),
                    ),
                  ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    music.playHomeMusic();
                    Navigator.pop(context);
                  },
                  child: Text(
                    isDaily || isPractice ? "Back to Menu" : "Back to quizzes",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkAndShowMilestonePopup(BuildContext context) {
    final streak = game.dailyQuizStreak;
    if (streak == 10 || streak == 30 || streak == 100) {
      final rewards = getStreakRewards(streak);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.stars, color: Colors.amber),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  rewards.label.isNotEmpty
                      ? rewards.label
                      : "Milestone Reached!",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Incredible consistency! You've reached a streak of:",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CounterChip(label: "[STREAK]", value: streak, prefix: "Streak"),
              const SizedBox(height: 16),
              const Text(
                "Current Rewards:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (rewards.assetDiscount > 0)
                IconText(
                  "• ${(rewards.assetDiscount * 100).toInt()}% Asset Discount",
                ),
              if (rewards.passiveIncomeMultiplier > 1.0)
                IconText(
                  "• ${((rewards.passiveIncomeMultiplier - 1.0) * 100).toInt()}% Passive Income Bonus",
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Awesome!"),
            ),
          ],
        ),
      );
    }
  }
}

class PastQuizzesScreen extends StatelessWidget {
  final GameManager game;
  final MusicManager music;
  final SfxManager sfx;

  const PastQuizzesScreen({
    super.key,
    required this.game,
    required this.music,
    required this.sfx,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Past Challenges")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: game.firestoreService.getRecentDailyQuizzes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text("No past challenges found."));
          }

          final quizzes = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final data = quizzes[index];
              final dateString = data['dateString'] ?? "Unknown Date";
              String displayDate = dateString;
              try {
                final parts = dateString.split('-');
                if (parts.length == 3) {
                  final year = int.tryParse(parts[0]);
                  final month = int.tryParse(parts[1]);
                  final day = int.tryParse(parts[2]);
                  if (year != null && month != null && day != null) {
                    final dt = DateTime(year, month, day);
                    displayDate = DateFormat('dd/MM/yyyy').format(dt);
                  }
                }
              } catch (_) {}

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.history, color: Colors.blue),
                  title: Text(data['title'] ?? "Daily Challenge"),
                  subtitle: Text(displayDate),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () {
                    sfx.playClick();
                    final quizData = QuizMetadata(
                      id: data['id'],
                      title: data['title'],
                      subtitle: data['subtitle'],
                      difficulty: QuizDifficulty.medium,
                      requiredLevel: 1,
                      questions: [
                        QuizQuestion(
                          question: data['question'],
                          options: List<String>.from(data['options']),
                          correctIndex: data['correctIndex'],
                          correctExplanation: data['correctExplanation'],
                          wrongExplanation: data['wrongExplanation'],
                        ),
                      ],
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizScreen(
                          game: game,
                          music: music,
                          sfx: sfx,
                          quiz: quizData,
                          isPractice: true,
                          dailyDate: dateString,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
