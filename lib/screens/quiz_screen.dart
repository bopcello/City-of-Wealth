import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../widgets/icon_text.dart';
import '../theme/app_colors.dart';
import '../services/music_manager.dart';
import '../services/sfx_manager.dart';

class QuizMenuScreen extends StatelessWidget {
  final MusicManager music;
  final SfxManager sfx;
  final int currentKp;
  final int currentLevel;
  final Set<String> completedQuizzes;
  final void Function(int) onKpChange;
  final void Function(String) onQuizComplete;
  final Listenable? refreshListenable;
  final String playerName;

  const QuizMenuScreen({
    super.key,
    required this.music,
    required this.sfx,
    required this.currentKp,
    required this.currentLevel,
    required this.completedQuizzes,
    required this.onKpChange,
    required this.onQuizComplete,
    this.refreshListenable,
    required this.playerName,
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
    return Scaffold(
      appBar: AppBar(title: const Text("Quizzes")),
      body: ListenableBuilder(
        listenable: refreshListenable ?? ChangeNotifier(), // fallback if null
        builder: (context, _) {
          final quizzes = getQuizzesForLevel(currentLevel);
          return quizzes.isEmpty
              ? Center(
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
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
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
                        const SizedBox(height: 24),
                        Text(
                          'Please check back soon!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];
                    final scheme = quiz.markingScheme;
                    final isCompleted = completedQuizzes.contains(quiz.id);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isCompleted
                                ? AppColors.of(context, 'success')
                                : _getDifficultyColor(context, quiz.difficulty),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: isCompleted
                              ? AppColors.of(
                                  context,
                                  'success',
                                ).withValues(alpha: 0.1)
                              : Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        child: ListTile(
                          leading: Icon(
                            isCompleted ? Icons.check_circle : Icons.quiz,
                            color: isCompleted
                                ? AppColors.of(context, 'success')
                                : _getDifficultyColor(context, quiz.difficulty),
                          ),
                          title: Text(
                            quiz.title,
                            style: TextStyle(
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isCompleted
                                  ? Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.5)
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => QuizScreen(
                                  music: music,
                                  sfx: sfx,
                                  quiz: quiz,
                                  currentKp: currentKp,
                                  onKpChange: onKpChange,
                                  onQuizComplete: onQuizComplete,
                                  completedQuizzes: completedQuizzes,
                                  isCompleted: isCompleted,
                                  playerName: playerName,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final MusicManager music;
  final SfxManager sfx;
  final QuizMetadata quiz;
  final int currentKp;
  final void Function(int) onKpChange;
  final void Function(String) onQuizComplete;
  final Set<String> completedQuizzes;
  final bool isCompleted;
  final String playerName;

  const QuizScreen({
    super.key,
    required this.music,
    required this.sfx,
    required this.quiz,
    required this.currentKp,
    required this.onKpChange,
    required this.onQuizComplete,
    required this.completedQuizzes,
    this.isCompleted = false,
    required this.playerName,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int current = 0;
  int? selected;

  int correctCount = 0;
  List<bool> results = [];

  // Stores a shuffled list of indices [0, 1, 2, 3] for each question
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

  @override
  void dispose() {
    widget.music.playHomeMusic();
    super.dispose();
  }

  void selectAnswer(int uiIndex) {
    if (selected != null) return;

    final question = widget.quiz.questions[current];
    final originalIndex = _shuffledIndicesMap[current][uiIndex];
    final correct = originalIndex == question.correctIndex;

    if (correct) correctCount++;

    results.add(correct);

    setState(() {
      selected = uiIndex;
    });

    if (correct) {
      widget.sfx.playCorrect();
    } else {
      widget.sfx.playIncorrect();
    }

    // Show explanation popup
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
              widget.sfx.playClick();
              Navigator.pop(context);
              nextQuestion();
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
      // Calculate Final Award
      int award = 0;
      final scheme = widget.quiz.markingScheme;
      final wrongCount = widget.quiz.questions.length - correctCount;

      if (widget.isCompleted) {
        // Repeat attempt - use fixed awards based on difficulty
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
        debugPrint('🔁 REPEAT QUIZ: ${widget.quiz.title}, Award: $award');
      } else {
        // First-time attempt - use marking scheme
        debugPrint(
          '📊 MARKING SCHEME: correctPoints=${scheme.correctPoints}, wrongPoints=${scheme.wrongPoints}',
        );
        debugPrint('📊 SCORES: correct=$correctCount, wrong=$wrongCount');
        award =
            (scheme.correctPoints * correctCount) +
            (scheme.wrongPoints * wrongCount);
        debugPrint('✨ FIRST-TIME QUIZ: ${widget.quiz.title}, Award: $award');
      }

      int finalKpDelta = 0;
      final bool passed = correctCount >= widget.quiz.questions.length * 0.5;

      if (passed) {
        finalKpDelta = award;
        widget.onKpChange(finalKpDelta);
        widget.onQuizComplete(widget.quiz.id);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizAnalysisScreen(
            music: widget.music,
            sfx: widget.sfx,
            score: correctCount,
            total: widget.quiz.questions.length,
            currentKp: widget
                .currentKp, // + finalKpDelta handled in onKpChange listener update? No, currentKp is passed value. logic/state update happens via callback.
            // visual display needs to know the delta.
            deltaKp: finalKpDelta,
            results: results,
            currentQuizId: widget.quiz.id,
            level: widget.quiz.requiredLevel,
            completedQuizzes: widget.completedQuizzes,
            onKpChange: widget.onKpChange,
            onQuizComplete: widget.onQuizComplete,
            isCompleted: widget.isCompleted,
            passed: passed,
            playerName: widget.playerName,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.quiz.questions[current];
    final progress = (current + 1) / widget.quiz.questions.length;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text(widget.quiz.title)),
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
                        color: Theme.of(context).colorScheme.surfaceVariant,
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
                      Color bg = Theme.of(context).colorScheme.surfaceVariant;

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
                                color: Theme.of(context).colorScheme.onSurface,
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
    );
  }
}

class QuizAnalysisScreen extends StatelessWidget {
  final MusicManager music;
  final SfxManager sfx;
  final int score;
  final int total;
  final int currentKp;
  final int deltaKp;
  final List<bool> results;
  final String currentQuizId;
  final int level;
  final Set<String> completedQuizzes;
  final void Function(int) onKpChange;
  final void Function(String) onQuizComplete;
  final bool isCompleted;
  final bool passed;
  final String playerName;

  const QuizAnalysisScreen({
    super.key,
    required this.music,
    required this.sfx,
    required this.score,
    required this.total,
    required this.currentKp,
    required this.deltaKp,
    required this.results,
    required this.currentQuizId,
    required this.level,
    required this.completedQuizzes,
    required this.onKpChange,
    required this.onQuizComplete,
    required this.isCompleted,
    required this.passed,
    required this.playerName,
  });

  String get message {
    if (!passed) return "Almost there! Try again.";
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
        return "Almost there ${playerName}! Next one is in the bag, isn't it?";
      case 5:
        return "Perfection!";
      default:
        return "Good Job!";
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = score / total;
    final newKp = currentKp + deltaKp;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Confetti removed
          Center(
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
                          color: _getScoreColor(progress),
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
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Results Summary
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
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Text(
                      "KP: $currentKp ${deltaKp < 0 ? ' ' : '+ '}$deltaKp = $newKp",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
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
                                music: music,
                                sfx: sfx,
                                quiz: nextQuiz,
                                currentKp: currentKp + deltaKp,
                                onKpChange: onKpChange,
                                onQuizComplete: onQuizComplete,
                                completedQuizzes: completedQuizzes,
                                isCompleted: completedQuizzes.contains(
                                  nextQuiz.id,
                                ),
                                playerName: playerName,
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

  Color _getScoreColor(double progress) {
    if (progress >= 0.8) return Colors.green;
    if (progress >= 0.5) return Colors.orange;
    return Colors.red;
  }
}
