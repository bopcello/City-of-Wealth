import 'package:flutter/material.dart';
import 'dart:math';

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
                  builder: (_) =>
                      QuizScreen(currentKp: currentKp, onKpChange: onKpChange),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final int currentKp;
  final void Function(int) onKpChange;

  const QuizScreen({
    super.key,
    required this.currentKp,
    required this.onKpChange,
  });

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
      ["Work once, earn repeatedly", "High salary", "Fast money", "Overtime"],
      0,
      "Passive income keeps generating cash with little daily effort.",
    ),
    _Question(
      "Best long-term investing strategy?",
      ["Timing the market", "Index funds", "Day trading", "Panic selling"],
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
      final deltaKp =
          correctCount * 50 - (questions.length - correctCount) * 10;
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
      appBar: AppBar(title: const Text("Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
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

  _Question(this.question, this.options, this.correctIndex, this.explanation);
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
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
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
              style: TextStyle(fontSize: 22.0 + random.nextDouble() * 12.0),
            ),
          );
        }),
      ),
    );
  }
}
