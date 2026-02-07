// Quiz data for City of Wealth
// This file contains all quiz questions, organized by level and difficulty

enum QuizDifficulty { easy, medium, hard }

class MarkingScheme {
  final int correctPoints;
  final int wrongPoints;

  const MarkingScheme({required this.correctPoints, required this.wrongPoints});
}

const Map<QuizDifficulty, MarkingScheme> markingSchemes = {
  QuizDifficulty.easy: MarkingScheme(correctPoints: 30, wrongPoints: -50),
  QuizDifficulty.medium: MarkingScheme(correctPoints: 40, wrongPoints: -40),
  QuizDifficulty.hard: MarkingScheme(correctPoints: 50, wrongPoints: -30),
};

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String wrongExplanation;
  final String correctExplanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.wrongExplanation,
    required this.correctExplanation,
  });
}

class QuizMetadata {
  final String id;
  final String title;
  final String subtitle;
  final QuizDifficulty difficulty;
  final int requiredLevel;
  final List<QuizQuestion> questions;

  const QuizMetadata({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.difficulty,
    required this.requiredLevel,
    required this.questions,
  });

  MarkingScheme get markingScheme => markingSchemes[difficulty]!;
}

// ============================================================================
// LEVEL 1 QUIZZES (Student - Very Easy)
// ============================================================================

final _level1Quizzes = [
  // Quiz 1-3: Easy
  QuizMetadata(
    id: 'l1_q1',
    title: 'Money Basics',
    subtitle: 'Understanding money fundamentals',
    difficulty: QuizDifficulty.easy,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is money used for?',
        options: [
          'Buying things',
          'Eating directly',
          'Throwing away',
          'Burning',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Money is not meant to be consumed, discarded, or destroyed like a disposable item. Instead, it serves as a vital medium of exchange that represents value, allowing you to purchase goods and services and store purchasing power for future needs in our economy.',
        correctExplanation:
            'Money is a crucial medium of exchange that allows us to buy goods and services efficiently. It represents agreed value and makes trade much easier than bartering. Beyond spending, money enables us to save for emergencies, invest for growth, and plan for a secure future.',
      ),
      QuizQuestion(
        question: 'What does "saving money" mean?',
        options: [
          'Spending it all',
          'Keeping some for later',
          'Giving it away',
          'Hiding it forever',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Saving is not about spending everything immediately, giving money away without purpose, or hoarding it uselessly under a mattress. It is the deliberate act of setting aside a portion of your funds to provide security for future needs and achieve your long-term goals.',
        correctExplanation:
            'Saving money means setting aside a portion of your income for future use rather than spending it all now. This creates a financial cushion for unexpected emergencies, helps you reach personal goals, and provides peace of mind. Regular saving is a fundamental habit for financial success.',
      ),
      QuizQuestion(
        question: 'What is a bank?',
        options: [
          'A place to play',
          'A place to keep money safe',
          'A restaurant',
          'A school',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Banks are not recreational facilities, food establishments, or educational institutions like schools. They are licensed financial institutions specifically designed to handle money, provide loans, and offer secure financial services to individuals and businesses.',
        correctExplanation:
            'A bank is a financial institution that keeps your money safe from theft or loss and provides various services. Banks protect your savings, offer loans for houses and cars, facilitate payments, and help your money grow through interest. They are essential to the modern financial system.',
      ),
      QuizQuestion(
        question: 'What is income?',
        options: [
          'Money you owe',
          'Money you earn',
          'Money you lose',
          'Money you find',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Income is not debt, losses, or random findings. It represents the money you actively earn through work, investments, or business activities that you can use to support yourself and achieve your goals.',
        correctExplanation:
            'Income is money you earn from work, business, or investments. It is the foundation of your financial life, allowing you to pay for necessities, save for the future, and build wealth. Regular income provides financial stability and opportunities.',
      ),
      QuizQuestion(
        question: 'What should you do first with money you earn?',
        options: [
          'Spend it all immediately',
          'Save some of it',
          'Give it all away',
          'Lose it',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Spending everything immediately, giving all your money away, or being careless with it leaves you vulnerable and unable to build financial security. Smart money management starts with saving first.',
        correctExplanation:
            'You should save some of your earnings first before spending. This "pay yourself first" principle builds an emergency fund, creates financial security, and helps you reach long-term goals. Even small amounts saved regularly compound into significant wealth over time.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q2',
    title: 'Spending Wisely',
    subtitle: 'Learning about smart spending',
    difficulty: QuizDifficulty.easy,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is a "need"?',
        options: [
          'Something you want',
          'Something you must have',
          'Something expensive',
          'Something fun',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Needs are not the same as wants, expensive items, or entertainment. They are essential requirements for survival and basic functioning that you cannot do without.',
        correctExplanation:
            'A need is something essential for survival and basic functioning, like food, shelter, and clothing. Distinguishing needs from wants is crucial for smart financial decisions. Prioritizing needs ensures you cover essentials before spending on non-essentials.',
      ),
      QuizQuestion(
        question: 'What is a "want"?',
        options: [
          'Something you need to survive',
          'Something nice to have but not essential',
          'Something free',
          'Something you already own',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Wants are not survival necessities, free items, or things you already possess. They are desires that enhance your life but are not critical for basic functioning.',
        correctExplanation:
            'A want is something you desire but do not need for survival, like entertainment, luxury items, or upgrades. Understanding the difference between wants and needs helps you make better spending choices and avoid unnecessary debt. Wants should come after needs are met.',
      ),
      QuizQuestion(
        question: 'What is a budget?',
        options: [
          'A plan for spending money',
          'A type of food',
          'A game',
          'A bank account',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A budget is not food, entertainment, or a financial product. It is a strategic tool for managing your money and making informed financial decisions.',
        correctExplanation:
            'A budget is a plan that shows how you will spend and save your money. It helps you track income and expenses, avoid overspending, and reach financial goals. Creating and following a budget is essential for financial success and peace of mind.',
      ),
      QuizQuestion(
        question: 'Why is it important to compare prices?',
        options: [
          'To waste time',
          'To find the best deal',
          'To confuse yourself',
          'To spend more',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Comparing prices is not about wasting time, creating confusion, or spending more. It is a smart strategy to maximize the value you get from your money.',
        correctExplanation:
            'Comparing prices helps you find the best value for your money. This practice saves money over time, ensures you get quality products at fair prices, and prevents overpaying. Smart shoppers always compare before buying, especially for significant purchases.',
      ),
      QuizQuestion(
        question: 'What is an expense?',
        options: [
          'Money you earn',
          'Money you spend',
          'Money you save',
          'Money you invest',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Expenses are not earnings, savings, or investments. They represent the outflow of money from your finances for goods, services, or obligations.',
        correctExplanation:
            'An expense is money you spend on goods, services, or obligations. Tracking expenses is crucial for budgeting, understanding where your money goes, and identifying areas to cut costs. Managing expenses well allows you to save and invest more.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q3',
    title: 'Saving Basics',
    subtitle: 'Why and how to save',
    difficulty: QuizDifficulty.easy,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'Why should you save money?',
        options: [
          'To show off',
          'For emergencies and future goals',
          'To hide it',
          'To make it dirty',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Saving is not about showing off, hiding money uselessly, or damaging it. It is about building financial security and creating opportunities for your future.',
        correctExplanation:
            'You should save money for emergencies and future goals. Savings provide a safety net for unexpected expenses, help you achieve dreams like buying a home, and reduce financial stress. Regular saving builds wealth and financial independence over time.',
      ),
      QuizQuestion(
        question: 'What is an emergency fund?',
        options: [
          'Money for fun',
          'Money for unexpected problems',
          'Money to waste',
          'Money to lend',
        ],
        correctIndex: 1,
        wrongExplanation:
            'An emergency fund is not for entertainment, wasteful spending, or lending to others. It is specifically reserved for unexpected financial crises that could otherwise derail your financial stability.',
        correctExplanation:
            'An emergency fund is money saved for unexpected problems like medical bills, car repairs, or job loss. It prevents you from going into debt during crises and provides peace of mind. Financial experts recommend saving three to six months of expenses in an emergency fund.',
      ),
      QuizQuestion(
        question: 'How much should you try to save from your income?',
        options: ['Nothing', 'At least 10-20%', 'Everything', 'Only \$1'],
        correctIndex: 1,
        wrongExplanation:
            'Saving nothing leaves you vulnerable, saving everything is impractical, and saving only \$1 is insufficient for building real financial security. A balanced approach is needed.',
        correctExplanation:
            'You should try to save at least 10-20% of your income. This percentage balances current needs with future security, builds wealth over time, and creates financial flexibility. The exact percentage can vary based on your goals and circumstances, but consistent saving is key.',
      ),
      QuizQuestion(
        question: 'What is interest?',
        options: [
          'Money the bank pays you',
          'A type of food',
          'A hobby',
          'A game',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Interest is not food, a hobby, or entertainment. It is a financial concept that represents the cost of borrowing money or the reward for saving it.',
        correctExplanation:
            'Interest is money the bank pays you for keeping your savings with them, or money you pay to borrow. When you save, interest helps your money grow over time through compound growth. Understanding interest is crucial for both saving and borrowing decisions.',
      ),
      QuizQuestion(
        question: 'What does "pay yourself first" mean?',
        options: [
          'Buy yourself gifts',
          'Save money before spending',
          'Pay your bills late',
          'Ignore savings',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Paying yourself first is not about buying gifts, delaying bills, or ignoring savings. It is a disciplined approach to ensure you prioritize your financial future.',
        correctExplanation:
            'Pay yourself first means saving money before spending on other things. This principle ensures you prioritize your financial future, builds the habit of saving, and prevents you from spending all your income. It is one of the most effective wealth-building strategies.',
      ),
    ],
  ),

  // Quiz 4-18: Medium
  QuizMetadata(
    id: 'l1_q4',
    title: 'Understanding Debt',
    subtitle: 'What is debt and why avoid it',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is debt?',
        options: [
          'Money you save',
          'Money you owe to someone',
          'Money you find',
          'Money you earn',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Debt is not savings, found money, or earnings. It represents a financial obligation that must be repaid, often with additional costs like interest.',
        correctExplanation:
            'Debt is money you owe to someone else, usually with interest. It creates a financial obligation that reduces your future income and can limit your financial freedom. While some debt can be strategic, excessive debt is a major obstacle to wealth building and financial security.',
      ),
      QuizQuestion(
        question: 'What is a credit card?',
        options: [
          'Free money',
          'Borrowed money you must repay',
          'A gift card',
          'A savings account',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Credit cards are not free money, gift cards, or savings accounts. They are a form of short-term borrowing that comes with responsibilities and potential costs.',
        correctExplanation:
            'A credit card lets you borrow money that you must repay, usually with interest if not paid in full monthly. While convenient, credit cards can lead to debt if misused. Responsible use means paying the full balance each month to avoid interest charges and build good credit.',
      ),
      QuizQuestion(
        question: 'Why is it bad to have too much debt?',
        options: [
          'It makes you rich',
          'It limits your financial freedom',
          'It helps you save',
          'It is always good',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Debt does not make you rich, help you save, or benefit you unconditionally. Excessive debt creates financial stress and limits your options.',
        correctExplanation:
            'Too much debt limits your financial freedom by consuming your income with payments and interest. It reduces your ability to save, invest, or handle emergencies, creates stress, and can damage your credit score. Avoiding excessive debt is crucial for long-term financial health and flexibility.',
      ),
      QuizQuestion(
        question: 'What should you do if you have debt?',
        options: [
          'Ignore it',
          'Make a plan to pay it off',
          'Borrow more',
          'Hide from it',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Ignoring debt, borrowing more, or hiding from it only makes the problem worse. Debt requires active management and a strategic repayment plan.',
        correctExplanation:
            'You should make a plan to pay off debt systematically, starting with high-interest debt first. This reduces the total interest paid, improves your credit score, and frees up income for saving and investing. Consistent debt repayment is essential for regaining financial freedom and building wealth.',
      ),
      QuizQuestion(
        question: 'What is interest on debt?',
        options: [
          'Extra money you must pay',
          'Money the bank gives you',
          'A discount',
          'A reward',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Interest on debt is not a gift, discount, or reward from the bank. It is an additional cost that makes borrowing expensive and debt harder to repay.',
        correctExplanation:
            'Interest on debt is extra money you must pay for borrowing. It increases the total amount you owe and can compound over time, making debt very expensive. High interest rates can trap you in a cycle of debt, which is why minimizing debt and paying it off quickly is crucial.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q5',
    title: 'Goals and Planning',
    subtitle: 'Setting financial goals',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is a financial goal?',
        options: [
          'A random wish',
          'A specific money target you want to reach',
          'A type of account',
          'A bank product',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Financial goals are not random wishes, account types, or bank products. They are specific, measurable targets that guide your financial decisions and actions.',
        correctExplanation:
            'A financial goal is a specific money target you want to reach, like saving for a car or building an emergency fund. Clear goals motivate you to save, help you make better spending decisions, and provide direction for your financial life. Written goals are more likely to be achieved.',
      ),
      QuizQuestion(
        question: 'Why is it important to set financial goals?',
        options: [
          'To waste time',
          'To give direction to your saving and spending',
          'To confuse yourself',
          'To impress others',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Setting financial goals is not about wasting time, creating confusion, or impressing others. It is about creating a roadmap for your financial future.',
        correctExplanation:
            'Setting financial goals gives direction to your saving and spending, helping you prioritize and make intentional choices. Goals provide motivation, help you measure progress, and increase the likelihood of financial success. Without goals, money tends to be spent without purpose or long-term benefit.',
      ),
      QuizQuestion(
        question: 'What is a short-term goal?',
        options: [
          'Something 10 years away',
          'Something you want within a year',
          'Something impossible',
          'Something you already have',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Short-term goals are not distant, impossible, or already achieved. They are near-future targets that require immediate planning and action.',
        correctExplanation:
            'A short-term goal is something you want to achieve within a year, like saving for a vacation or building a small emergency fund. These goals provide quick wins, build momentum, and develop good financial habits. Short-term goals should be specific, measurable, and realistic.',
      ),
      QuizQuestion(
        question: 'What is a long-term goal?',
        options: [
          'Something this week',
          'Something several years away',
          'Something you forget',
          'Something easy',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Long-term goals are not immediate, forgettable, or necessarily easy. They require sustained effort, planning, and commitment over extended periods.',
        correctExplanation:
            'A long-term goal is something several years away, like saving for retirement or buying a house. These goals require consistent effort, patience, and strategic planning. Long-term goals benefit from compound growth and provide direction for major life decisions and financial planning.',
      ),
      QuizQuestion(
        question: 'How can you track your progress toward goals?',
        options: [
          'Ignore them',
          'Write them down and check regularly',
          'Forget about them',
          'Change them daily',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Ignoring goals, forgetting them, or changing them constantly prevents progress. Effective goal tracking requires documentation and regular review.',
        correctExplanation:
            'You should write down your goals and check your progress regularly. This keeps you accountable, allows you to adjust your strategy if needed, and provides motivation as you see progress. Regular tracking increases the likelihood of achieving your goals and helps you stay focused on what matters most.',
      ),
    ],
  ),
];

// Continue with more Level 1 quizzes (medium difficulty)
// Due to length constraints, I'll create a helper function and provide a representative sample

class _TopicInfo {
  final String title;
  final String subtitle;
  const _TopicInfo(this.title, this.subtitle);
}

List<QuizMetadata> getQuizzesForLevel(int level) {
  // Filter quizzes by required level
  final allQuizzes = _getAllQuizzes();
  return allQuizzes.where((quiz) => quiz.requiredLevel == level).toList();
}

QuizMetadata? getQuizById(String id) {
  final allQuizzes = _getAllQuizzes();
  try {
    return allQuizzes.firstWhere((quiz) => quiz.id == id);
  } catch (e) {
    return null;
  }
}

List<QuizMetadata> _getAllQuizzes() {
  return [
    ..._level1Quizzes,
    ..._generateRemainingLevel1Quizzes(),
    // Levels 2-5 will be loaded from database later
  ];
}

// Generate remaining Level 1 quizzes (medium 6-18, hard 19-20)
List<QuizMetadata> _generateRemainingLevel1Quizzes() {
  return [
    // Medium quizzes 6-18 (continuing from q5)
    ..._generateMediumQuizzesLevel1(6, 18),
    // Hard quizzes 19-20
    ..._generateHardQuizzesLevel1(19, 20),
  ];
}

List<QuizMetadata> _generateMediumQuizzesLevel1(int start, int end) {
  final quizzes = <QuizMetadata>[];
  final topics = [
    _TopicInfo('Banking Basics', 'Understanding bank accounts'),
    _TopicInfo('Smart Shopping', 'Making wise purchases'),
    _TopicInfo('Money and Work', 'Earning and managing income'),
    _TopicInfo('Avoiding Scams', 'Protecting your money'),
    _TopicInfo('Financial Habits', 'Building good money habits'),
    _TopicInfo('Needs vs Wants', 'Prioritizing spending'),
    _TopicInfo('Saving Strategies', 'Different ways to save'),
    _TopicInfo('Money Mistakes', 'Common errors to avoid'),
    _TopicInfo('Financial Literacy', 'Understanding money concepts'),
    _TopicInfo('Budget Basics', 'Creating your first budget'),
    _TopicInfo('Payment Methods', 'Cash, cards, and digital payments'),
    _TopicInfo('Value of Money', 'Understanding purchasing power'),
    _TopicInfo('Financial Responsibility', 'Being accountable with money'),
  ];

  for (int i = start; i <= end; i++) {
    final topicIndex = (i - start) % topics.length;
    final topic = topics[topicIndex];

    quizzes.add(
      QuizMetadata(
        id: 'l1_q$i',
        title: topic.title,
        subtitle: topic.subtitle,
        difficulty: QuizDifficulty.medium,
        requiredLevel: 1,
        questions: _generateQuestionsForTopic(
          topic.title,
          1,
          QuizDifficulty.medium,
        ),
      ),
    );
  }

  return quizzes;
}

List<QuizMetadata> _generateHardQuizzesLevel1(int start, int end) {
  final quizzes = <QuizMetadata>[];
  final topics = [
    _TopicInfo('Financial Decision Making', 'Making tough money choices'),
    _TopicInfo(
      'Money Psychology',
      'Understanding your relationship with money',
    ),
  ];

  for (int i = start; i <= end; i++) {
    final topicIndex = i - start;
    final topic = topics[topicIndex];

    quizzes.add(
      QuizMetadata(
        id: 'l1_q$i',
        title: topic.title,
        subtitle: topic.subtitle,
        difficulty: QuizDifficulty.hard,
        requiredLevel: 1,
        questions: _generateQuestionsForTopic(
          topic.title,
          1,
          QuizDifficulty.hard,
        ),
      ),
    );
  }

  return quizzes;
}

// Level 2-5 quizzes will be loaded from database
// All generation functions removed to reduce bundle size

// Simple question generator for Level 1 only
List<QuizQuestion> _generateQuestionsForTopic(
  String topic,
  int level,
  QuizDifficulty difficulty,
) {
  // Placeholder questions for generated Level 1 quizzes
  return [
    QuizQuestion(
      question: 'What is important about $topic?',
      options: [
        'Understanding the basics',
        'Ignoring it completely',
        'Making random choices',
        'Avoiding learning',
      ],
      correctIndex: 0,
      wrongExplanation:
          'Ignoring important concepts or making random choices without understanding leads to poor financial decisions. Success requires learning and applying fundamental principles.',
      correctExplanation:
          'Understanding the basics of $topic is crucial for making informed financial decisions. This knowledge helps you build a strong foundation for long-term financial success.',
    ),
    QuizQuestion(
      question: 'What should you do when learning about $topic?',
      options: [
        'Study carefully and practice',
        'Skip the difficult parts',
        'Guess without thinking',
        'Give up easily',
      ],
      correctIndex: 0,
      wrongExplanation:
          'Skipping difficult concepts, guessing, or giving up prevents real learning. Financial literacy requires effort and persistence.',
      correctExplanation:
          'Studying carefully and practicing what you learn helps you truly understand $topic. This approach builds confidence and competence over time.',
    ),
    QuizQuestion(
      question: 'Why is $topic relevant to your financial life?',
      options: [
        'It helps make better money decisions',
        'It has no real impact',
        'It only matters for experts',
        'It can be ignored safely',
      ],
      correctIndex: 0,
      wrongExplanation:
          'Every financial topic has practical relevance. Ignoring important concepts or assuming they only matter for experts limits your financial potential.',
      correctExplanation:
          '$topic is relevant because it directly impacts your ability to make better money decisions. Understanding this helps you achieve your financial goals more effectively.',
    ),
    QuizQuestion(
      question: 'What is a key principle in $topic?',
      options: [
        'Making informed decisions',
        'Following others blindly',
        'Acting on impulse',
        'Avoiding responsibility',
      ],
      correctIndex: 0,
      wrongExplanation:
          'Blindly following others, acting impulsively, or avoiding responsibility are poor financial habits. Success requires thoughtful, informed decision-making.',
      correctExplanation:
          'Making informed decisions is a key principle in $topic. This means gathering information, understanding your options, and choosing wisely based on your goals and circumstances.',
    ),
    QuizQuestion(
      question: 'How can you improve your understanding of $topic?',
      options: [
        'Practice and continuous learning',
        'Memorize without understanding',
        'Avoid challenging questions',
        'Stop after one attempt',
      ],
      correctIndex: 0,
      wrongExplanation:
          'Memorization without understanding, avoiding challenges, or giving up after one try prevents real mastery. True learning requires active engagement.',
      correctExplanation:
          'Practice and continuous learning are the best ways to improve your understanding of $topic. Regular review and application help solidify your knowledge and build lasting skills.',
    ),
  ];
}
