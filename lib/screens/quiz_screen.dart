import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../widgets/icon_text.dart';
import '../services/music_manager.dart';
import '../services/sfx_manager.dart';
import '../services/firestore_service.dart';
import '../logic/game_manager.dart';

class QuizMenuScreen extends StatefulWidget {
  final GameManager game;
  final MusicManager music;
  final SfxManager sfx;

  const QuizMenuScreen({
    super.key,
    required this.game,
    required this.music,
    required this.sfx,
  });

  @override
  State<QuizMenuScreen> createState() => _QuizMenuScreenState();
}

class _QuizMenuScreenState extends State<QuizMenuScreen> {
  Map<String, dynamic>? _dailyQuiz;
  bool _isLoadingDaily = true;

  @override
  void initState() {
    super.initState();
    _fetchDailyQuiz();
  }

  Future<void> _fetchDailyQuiz() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final quiz = await FirestoreService().getDailyQuiz(today);
    if (mounted) {
      setState(() {
        _dailyQuiz = quiz;
        _isLoadingDaily = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.game,
      builder: (context, _) {
        final currentLevel = widget.game.career.level;
        return Scaffold(
          appBar: AppBar(title: const Text("Quizzes")),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildDailySection(),
              _buildLevelQuizzes(1),
              if (currentLevel >= 2) _buildLevelQuizzes(2),
              if (currentLevel >= 3) _buildLevelQuizzes(3),
              if (currentLevel >= 4) _buildLevelQuizzes(4),
              if (currentLevel >= 5) _buildLevelQuizzes(5),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDailySection() {
    if (_isLoadingDaily) {
      return const Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: CircularProgressIndicator(),
          ),
          Divider(),
        ],
      );
    }

    if (_dailyQuiz == null) return const SizedBox.shrink();

    final today = DateTime.now().toIso8601String().split('T')[0];
    final isCompleted = widget.game.lastDailyQuizDate == today;

    final quizMetadata = QuizMetadata(
      id: _dailyQuiz?['id'] ?? "daily_$today",
      title: _dailyQuiz?['title'] ?? "Daily Quiz",
      subtitle: _dailyQuiz?['subtitle'] ?? "Test your financial knowledge",
      difficulty: QuizDifficulty.values.firstWhere(
        (e) => e.name == (_dailyQuiz?['difficulty'] ?? "easy"),
        orElse: () => QuizDifficulty.easy,
      ),
      requiredLevel: 1,
      questions:
          (_dailyQuiz?['questions'] as List<dynamic>?)?.map((q) {
            return QuizQuestion(
              question: q['question'],
              options: List<String>.from(q['options']),
              correctIndex: q['correctIndex'],
              correctExplanation: q['correctExplanation'],
              wrongExplanation: q['wrongExplanation'],
            );
          }).toList() ??
          [],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "DAILY CHALLENGE",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 12),
        _buildQuizTile(
          quizMetadata,
          isDaily: true,
          isCompleted: isCompleted,
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLevelQuizzes(int level) {
    final levelQuizzes = getQuizzesForLevel(level);
    if (levelQuizzes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "LEVEL $level",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 12),
        ...levelQuizzes.map((quiz) => _buildQuizTile(quiz)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildQuizTile(
    QuizMetadata quiz, {
    bool isDaily = false,
    bool isCompleted = false,
  }) {
    final isLocked = !isDaily && quiz.requiredLevel > widget.game.career.level;
    final isFinished = isCompleted || widget.game.completedQuizzes.contains(quiz.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isDaily && !isFinished
                  ? Colors.blue.withOpacity(0.8)
                  : Colors.transparent,
          width: 2,
        ),
        boxShadow:
            isDaily && !isFinished
                ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
                : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor:
              isDaily
                  ? Colors.blue
                  : (isLocked
                      ? Colors.grey
                      : Theme.of(context).colorScheme.primary),
          child: Icon(
            isDaily ? Icons.event : Icons.quiz,
            color: Colors.white,
          ),
        ),
        title: Text(
          quiz.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isLocked ? Colors.grey : null,
          ),
        ),
        subtitle: Text(
          quiz.subtitle,
          style: TextStyle(color: isLocked ? Colors.grey : Colors.blueGrey),
        ),
        trailing:
            isFinished
                ? const Icon(Icons.check_circle, color: Colors.green)
                : (isLocked ? const Icon(Icons.lock) : null),
        onTap:
            (isLocked || isFinished)
                ? null
                : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => QuizScreen(
                            game: widget.game,
                            music: widget.music,
                            sfx: widget.sfx,
                            quiz: quiz,
                            isDailyQuiz: isDaily,
                          ),
                    ),
                  );
                },
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final GameManager game;
  final MusicManager music;
  final SfxManager sfx;
  final QuizMetadata quiz;
  final bool isDailyQuiz;

  const QuizScreen({
    super.key,
    required this.game,
    required this.music,
    required this.sfx,
    required this.quiz,
    this.isDailyQuiz = false,
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

    setState(() {
      selected = uiIndex;
    });

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
                IconText(question.wrongExplanation),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
              ],
              const Text(
                'Why This Answer is Correct',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              IconText(question.correctExplanation),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (current < widget.quiz.questions.length - 1) {
                setState(() {
                  selected = null;
                  current++;
                });
              } else {
                _finishQuiz();
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

  void _finishQuiz() {
    int award = 0;
    final scheme = widget.quiz.markingScheme;
    final wrongCount = widget.quiz.questions.length - correctCount;
    final bool isCompletedBefore = widget.game.completedQuizzes.contains(widget.quiz.id);

    if (isCompletedBefore && !widget.isDailyQuiz) {
      switch (widget.quiz.difficulty) {
        case QuizDifficulty.easy: award = 0; break;
        case QuizDifficulty.medium: award = 10; break;
        case QuizDifficulty.hard: award = 15; break;
      }
    } else {
      award = (scheme.correctPoints * correctCount) + (scheme.wrongPoints * wrongCount);
    }

    final bool passed = correctCount >= widget.quiz.questions.length * 0.5;
    int finalKpDelta = passed ? award : 0;

    if (passed) {
      widget.game.addKp(finalKpDelta);
    }

    if (widget.isDailyQuiz) {
      final today = DateTime.now().toIso8601String().split('T')[0];
      widget.game.completeDailyQuiz(passed, today);
    } else {
      widget.game.markQuizCompleted(widget.quiz.id);
    }

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
          isCompleted: isCompletedBefore,
          passed: passed,
          isDailyQuiz: widget.isDailyQuiz,
        ),
      ),
    );
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
          title: IconText(widget.quiz.title),
          actions: [
            if (widget.isDailyQuiz)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Chip(
                  avatar: const Icon(Icons.local_fire_department, color: Colors.orange),
                  label: Text('Streak: ${widget.game.dailyQuizStreak}'),
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
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
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Question ${current + 1}"),
                            const SizedBox(height: 12),
                            IconText(
                              q.question,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...List.generate(q.options.length, (uiIndex) {
                        final originalIndex = _shuffledIndicesMap[current][uiIndex];
                        Color bg = Theme.of(context).colorScheme.surfaceVariant;

                        if (selected != null) {
                          if (originalIndex == q.correctIndex) {
                            bg = Colors.green.withOpacity(0.3);
                          } else if (uiIndex == selected) {
                            bg = Colors.red.withOpacity(0.3);
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
                                style: const TextStyle(fontSize: 16),
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
  final bool isCompleted;
  final bool passed;
  final bool isDailyQuiz;

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
    required this.isCompleted,
    required this.passed,
    this.isDailyQuiz = false,
  });

  @override
  Widget build(BuildContext context) {
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
                        color: progress >= 0.8 ? Colors.green : (progress >= 0.5 ? Colors.orange : Colors.red),
                      ),
                      Text(
                        "$score/$total",
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  passed ? "Great Job!" : "Almost there! Try again.",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "KP: ${game.kp - deltaKp} + $deltaKp = ${game.kp}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isDailyQuiz) {
                        music.playHomeMusic();
                        Navigator.pop(context);
                        return;
                      }
                      // Regular quiz next logic...
                      final quizzes = getQuizzesForLevel(level);
                      final currentIndex = quizzes.indexWhere((q) => q.id == currentQuizId);
                      if (currentIndex != -1 && currentIndex < quizzes.length - 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              game: game,
                              music: music,
                              sfx: sfx,
                              quiz: quizzes[currentIndex + 1],
                            ),
                          ),
                        );
                      } else {
                        music.playHomeMusic();
                        Navigator.pop(context);
                      }
                    },
                    child: Text(isDailyQuiz ? "Back to Menu" : "Next Quiz"),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    music.playHomeMusic();
                    Navigator.pop(context);
                  },
                  child: const Text("Finish"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
