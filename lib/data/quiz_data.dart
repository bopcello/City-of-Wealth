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
          'Eating directly',
          'Throwing away',
          'Buying things',
          'Burning',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Money is not for eating, burning, or throwing in the trash. It is a special tool we use to buy things we need and want every day.',
        correctExplanation:
            'Money is used to buy goods like food and toys. It helps people trade with each other easily without needing to swap their own items directly.',
      ),
      QuizQuestion(
        question: 'What does "saving" mean?',
        options: [
          'Spending it all',
          'Giving it away',
          'Keeping some for later',
          'Hiding it',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Saving is not about spending all your cash or just giving it away. It means you are keeping a portion of your money to use later.',
        correctExplanation:
            'When you save, you set aside some money instead of spending it now. This helps you have money ready for a day when you don\'t get pocket money after a fight with your dad.',
      ),
      QuizQuestion(
        question: 'What is a bank?',
        options: ['A place for money', 'A restaurant', 'A school', 'A park'],
        correctIndex: 0,
        wrongExplanation:
            'A bank is not a place to eat food, go to school, or play in the park. It is a building meant for financial security only.',
        correctExplanation:
            'A bank is a very safe place where you can keep your money while the bank pays you interest periodically. They help protect your savings from being lost or stolen at your home.',
      ),
      QuizQuestion(
        question: 'What is income?',
        options: [
          'Money you owe',
          'Money you lose',
          'Money you find',
          'Money you earn',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Income is not money that you owe to others or money that you lose by accident. It is always money that you get for doing work.',
        correctExplanation:
            'Income is the money you receive for doing a job or providing a service. It is the reward for your hard work and helps you buy what you need.',
      ),
      QuizQuestion(
        question: 'What is a coin?',
        options: ['Paper money', 'Metal money', 'A toy', 'A snack'],
        correctIndex: 1,
        wrongExplanation:
            'A coin is not made of paper, and it is definitely not a toy or a tasty snack to eat. It is a solid financial tool.',
        correctExplanation:
            'Coins are small, round pieces of metal used as money. They come in different values like pennies and quarters to help you pay in small denominations.',
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
          'Something for fun',
          'Something you must have',
          'Something expensive',
          'A gift',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Needs are not just things for fun, expensive items, or gifts from friends. They are the most important things you require to stay healthy and happy.',
        correctExplanation:
            'A need is something essential for your life, like water or a home. You should always make sure your needs are covered before buying your wants.',
      ),
      QuizQuestion(
        question: 'What is a "want"?',
        options: [
          'Must have to live',
          'Nice to have for fun',
          'Free items',
          'Old toys',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Wants are not things you require for survival, like air or water. They are also not always free or just old things you already own today.',
        correctExplanation:
            'A want is something that is fun to have but not required to survive. Examples include new video games, tasty candy, or a fancy new bike.',
      ),
      QuizQuestion(
        question: 'What is a plan for money?',
        options: ['A game', 'A toy', 'A budget', 'A box'],
        correctIndex: 2,
        wrongExplanation:
            'A plan for your money is not a game you play or a simple box you keep. It is a smart way to track your spending and save with a certain timeline.',
        correctExplanation:
            'A budget is a plan that shows how you will spend and save your money. It helps you make sure you have enough for your needs and select your most desired wants.',
      ),
      QuizQuestion(
        question: 'What is "spending"?',
        options: [
          'Buying things',
          'Saving money',
          'Finding money',
          'Giving money',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Spending is not about keeping your money for later or finding coins on the ground. It is the act of using your cash to get something you want or need.',
        correctExplanation:
            'Spending happens when you give your money to a store in exchange for something you want or need. It is how you buy your daily necessities.',
      ),
      QuizQuestion(
        question: 'What is a receipt?',
        options: ['A toy', 'A gift', 'A map', 'A record of buying'],
        correctIndex: 3,
        wrongExplanation:
            'A receipt is not a toy, a gift from a friend, or a map to find hidden treasure. It is a record of your business.',
        correctExplanation:
            'A receipt is a piece of paper that proves you paid for something at a store. It shows what you bought and how much you paid.',
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
        question: 'Why should you save?',
        options: [
          'For future goals',
          'To show off',
          'To hide it',
          'To lose it',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Saving is not for showing off to others or hiding your money away. It is also definitely not meant for losing your hard-earned cash.',
        correctExplanation:
            'You should save money so you can buy big things later or be ready for surprises. Saving helps you reach your dreams for the future.',
      ),
      QuizQuestion(
        question: 'What is a piggy bank?',
        options: ['A home for coins', 'A real pig', 'A toy car', 'A snack'],
        correctIndex: 0,
        wrongExplanation:
            'A piggy bank is not a live animal, a toy car, or a snack you can eat. It is a tool for your home savings.',
        correctExplanation:
            'A piggy bank is a container used to store coins and small bills safely at home. It is a great way to start your saving.',
      ),
      QuizQuestion(
        question: 'What is an emergency?',
        options: [
          'A fun party',
          'A new toy',
          'A movie',
          'An unexpected problem',
        ],
        correctIndex: 3,
        wrongExplanation:
            'An emergency is not a fun party, a shiny new toy, or a movie. It is a serious situation that needs your money and attention.',
        correctExplanation:
            'An emergency is a sudden problem that costs money, like a broken window or a sick pet. Having savings helps you fix these problems fast.',
      ),
      QuizQuestion(
        question: 'What is a savings goal?',
        options: [
          'A math problem',
          'Something to save for',
          'A secret',
          'A game',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A savings goal is not a math problem, a secret you keep, or a game you play. It is a target for your savings.',
        correctExplanation:
            'A savings goal is a specific thing you are saving your money to buy, like a new bike. It helps you stay focused on your goal and avoid distractions like candy or toys.',
      ),
      QuizQuestion(
        question: 'Why use a safe place to store your savings?',
        options: [
          'To protect it from monsters',
          'To show off the safety of the place',
          'To keep it safe from thieves',
          'To be mean to your friends',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Safe places are not for hiding from people or showing off how much you have. They are also not meant for being mean to your friends.',
        correctExplanation:
            'Using a safe place like a bank or a strong box keeps your money from getting lost or stolen. It gives you peace of mind about your savings.',
      ),
    ],
  ),

  // Quiz 4-18: Medium
  ..._mediumQuizzes,

  // Quiz 19-20: Hard
  ..._hardQuizzes,
];

final List<QuizMetadata> _mediumQuizzes = [
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
          'Money you find',
          'Money you earn',
          'Money you save',
          'Money you owe to someone',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Saving money, finding money, or earning it through hard work are positive financial actions. These do not create a legal requirement for you to pay someone back.',
        correctExplanation:
            'Debt is money you have borrowed from a person or bank that you must pay back later. It usually includes extra costs like interest for borrowing.',
      ),
      QuizQuestion(
        question: 'What is a credit card?',
        options: [
          'Free money',
          'A gift card',
          'A savings account',
          'Borrowed money for later',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Credit cards are not gifts, free money from the government, or a place to store your own savings. Using one means you are taking a loan.',
        correctExplanation:
            'A credit card allows you to buy things now using the bank\'s money. You must pay this money back later, often with extra interest if late.',
      ),
      QuizQuestion(
        question: 'Why is too much debt bad?',
        options: [
          'Makes you rich',
          'Limits financial freedom',
          'Helps you save',
          'It is always good',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Debt does not make you wealthy, help you save for the future, or provide permanent benefits. Instead, it takes away money you could use for yourself.',
        correctExplanation:
            'Having too much debt means you must spend your future earnings on old bills. This limits your ability to buy new things or save for goals.',
      ),
      QuizQuestion(
        question: 'What is interest on debt?',
        options: [
          'A bank gift',
          'A discount',
          'Extra money to pay',
          'A reward',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Interest on a loan is never a gift, a discount on the price, or a reward for the borrower. It is a cost added to debt.',
        correctExplanation:
            'Interest is the extra fee you pay to a lender for using their money. It makes the total amount you owe higher than what you borrowed.',
      ),
      QuizQuestion(
        question: 'How should you handle debt?',
        options: [
          'Make a plan to pay it',
          'Ignore it',
          'Borrow more',
          'Hide from it',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Ignoring your debts, hiding from collectors, or borrowing even more money will make your financial problems much worse. You must face your debts with a plan.',
        correctExplanation:
            'The best way to handle debt is to create a careful plan to pay it back. Paying on time helps you avoid expensive late fee charges.',
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
          'A bank account',
          'A shiny toy',
          'A specific saving or fund',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Financial goals are not just random wishes, basic bank accounts, or objects you want. They are structured plans designed to help you achieve a specific result.',
        correctExplanation:
            'A financial goal is a specific target you want to reach with your money. Examples include saving for a bike or building an emergency fund soon.',
      ),
      QuizQuestion(
        question: 'Why set financial goals?',
        options: [
          'To guide your spending',
          'To waste time',
          'To get confused',
          'To impress friends',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Setting goals is not a waste of time and should not be done just to impress others. It helps prevent confusion about how to use money.',
        correctExplanation:
            'Goals give you a clear map for your money. They help you decide what is truly important so you do not spend on things you don\'t.',
      ),
      QuizQuestion(
        question: 'What is a short-term goal?',
        options: [
          'A 20-year plan',
          'Goal for lunch',
          'A secret dream',
          'Goal reached within a year',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Short-term goals are not distant plans for twenty years from now or a goal for lunchtime. They are realistic targets that you can reach in a short time.',
        correctExplanation:
            'A short-term goal is something you want to achieve very soon, usually within a year. Saving for a video game is a great example of this.',
      ),
      QuizQuestion(
        question: 'What is a long-term goal?',
        options: [
          'Goal for next week',
          'Something easy',
          'Goal many years away',
          'A goal for dinner',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Long-term goals are not simple tasks you finish in a week or a goal for dinner. They require a lot of time, patience, and many years of saving.',
        correctExplanation:
            'A long-term goal is a major target that takes several years to reach. Saving for college or buying a house are common examples of long-term goals.',
      ),
      QuizQuestion(
        question: 'How do you track goals?',
        options: [
          'Remember them mentally',
          'Write them down',
          'Change them daily',
          'Keep them secret',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you keep your goals in your mind, change them every day, or keep them totally secret, you might lose focus or forget them. You need to see your progress to succeed.',
        correctExplanation:
            'Writing your goals down and checking them often helps you stay on track. This lets you see how close you are to reaching your big dream.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q6',
    title: 'Banking Basics',
    subtitle: 'Understanding bank accounts',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is a savings account?',
        options: [
          'A place to spend',
          'A credit card',
          'A place to store money',
          'A plastic box',
        ],
        correctIndex: 2,
        wrongExplanation:
            'A savings account is not a place for quick spending or a simple plastic box at home. It is also different from a debt-creating credit card.',
        correctExplanation:
            'A savings account is a secure place at a bank to keep your money. The bank often pays you a small amount of interest for keeping.',
      ),
      QuizQuestion(
        question: 'What is a withdrawal?',
        options: [
          'Putting money in',
          'Taking money out',
          'Losing money',
          'Finding money',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Withdrawal does not mean adding more money to your account (that\'s something else, if you know it, you\'ll know the answer of the next question), losing cash by mistake, or finding some money on the street. It is a planned action.',
        correctExplanation:
            'A withdrawal happens when you take money out of your bank account. You can do this at the bank or use an ATM to get cash.',
      ),
      QuizQuestion(
        question: 'What is a deposit?',
        options: [
          'Taking money out',
          'Buying a toy',
          'Putting money in',
          'Paying a bill',
        ],
        correctIndex: 2,
        wrongExplanation:
            'A deposit is not related to taking money out, buying a new toy, or paying a monthly bill. It refers specifically to adding funds to accounts.',
        correctExplanation:
            'A deposit is when you add money to your bank account. You can deposit cash or checks you received from work or as a nice gift.',
      ),
      QuizQuestion(
        question: 'What is an ATM?',
        options: [
          'A money machine',
          'A video game',
          'A type of car',
          'A grocery store',
        ],
        correctIndex: 0,
        wrongExplanation:
            'An ATM is not a video game, a fast car, or a place to buy groceries. It is a specialized machine used for banking and money.',
        correctExplanation:
            'An ATM is an Automated Teller Machine that lets you get cash or check your balance. You can use it even when the bank is closed.',
      ),
      QuizQuestion(
        question: 'Why use a bank?',
        options: [
          'To lose money',
          'To hide from law',
          'To get free toys',
          'To keep money safe',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Banks are not places to lose your hard-earned cash, hide from the law, or get free toys. Their main job is to provide financial security.',
        correctExplanation:
            'Banks keep your money safe from theft and fire. They also provide records that help you track how much you have saved over a long time.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q7',
    title: 'Smart Shopping',
    subtitle: 'Making wise purchases',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is unit price?',
        options: [
          'The total cost',
          'Cost per one item',
          'A discount code',
          'The tax amount',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The unit price is not the total bill you pay, a special discount code, or the tax collected by the government. It focuses on single items.',
        correctExplanation:
            'Unit price tells you how much one single ounce, pound, or piece costs. Comparing unit prices helps you find the best deal at the grocery.',
      ),
      QuizQuestion(
        question: 'What is a "sale"?',
        options: [
          'A higher price',
          'A free gift',
          'A lower price',
          'A broken item',
        ],
        correctIndex: 2,
        wrongExplanation:
            'A sale is not a trick to charge you a higher price, a free gift with no cost, or a way to sell broken or old.',
        correctExplanation:
            'A sale is when a store lowers the price of an item for a short time. Buying on sale can help you save a lot of.',
      ),
      QuizQuestion(
        question: 'Why compare prices?',
        options: [
          'To waste gas',
          'To save money',
          'To get tired',
          'To buy more',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Comparing prices should not be done just to waste gas or get tired. It is a strategy to ensure you do not overspend on simple.',
        correctExplanation:
            'Price comparison helps you find which store offers the lowest price for the same item. Using your phone to check prices can save you money.',
      ),
      QuizQuestion(
        question: 'What is impulse buying?',
        options: [
          'Planned shopping',
          'Returning items',
          'Saving for later',
          'Buying without thinking',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Impulse buying is not part of a planned shopping trip, returning things you don\'t want, or saving money. It is a quick and unplanned action.',
        correctExplanation:
            'Impulse buying is when you purchase something suddenly without having it on your list. This often leads to spending money on things you do not need.',
      ),
      QuizQuestion(
        question: 'What are generic brands?',
        options: [
          'Stores\' own brands',
          'Famous brands',
          'Broken products',
          'Luxury items',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Generic brands are not famous names you see on TV, broken products, or expensive luxury items. They are usually simple and very affordable options in.',
        correctExplanation:
            'Generic brands are versions of products made by the store itself. They usually cost much less than famous names but have the same quality and taste.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q8',
    title: 'Earning Income',
    subtitle: 'Ways to get money',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is a wage?',
        options: [
          'Money paid per hour',
          'A tax payment',
          'A gift from mom',
          'A type of debt',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A wage is not a tax you pay to the government, a random gift, or a debt you owe. It is money earned through your time.',
        correctExplanation:
            'A wage is money you earn for every hour you work. Many people who work in stores or restaurants are paid an hourly wage for service.',
      ),
      QuizQuestion(
        question: 'What is a salary?',
        options: [
          'Hourly pay',
          'A bank loan',
          'Money you find',
          'Fixed yearly pay',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Salary is not calculated by the hour, nor is it a bank loan or money you found by luck. It is a steady form of earnings.',
        correctExplanation:
            'A salary is a fixed amount of money you are paid every year, no matter how many hours you work. It is usually paid every month.',
      ),
      QuizQuestion(
        question: 'What is an entrepreneur?',
        options: [
          'A business owner',
          'A store worker',
          'A bank teller',
          'A teacher',
        ],
        correctIndex: 0,
        wrongExplanation:
            'An entrepreneur is not just a person who works in a store, a bank teller, or a teacher. They are the ones who create companies.',
        correctExplanation:
            'An entrepreneur is someone who starts and runs their own business. They take risks to create new products or services for people to buy and use.',
      ),
      QuizQuestion(
        question: 'What is "commission"?',
        options: [
          'A tax fee',
          'Pay based on sales',
          'A monthly bill',
          'Free money',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Commission is not a tax, a monthly bill you must pay, or free money. It is a reward for selling things to other people for income.',
        correctExplanation:
            'A commission is extra money paid to a worker based on how much they sell. Car salespeople often earn commissions for every vehicle they successfully sell.',
      ),
      QuizQuestion(
        question: 'What is professional skill?',
        options: [
          'A heavy box',
          'A shiny toy',
          'Ability learned for work',
          'A fast car',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Professional skills are not heavy objects like boxes, shiny toys, or fast cars. They are mental or physical abilities used to perform a specific job well.',
        correctExplanation:
            'Skills are things you learn to do a job well, like coding or fixing cars. Having more skills often helps you earn a much higher.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q9',
    title: 'Protecting Money',
    subtitle: 'Avoiding scams and theft',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is a scam?',
        options: [
          'A fun game',
          'A trick to steal',
          'A bank gift',
          'A job offer',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Scams are never fun games, gifts from your bank, or real job offers. They are dangerous tricks used by bad people to take your money away.',
        correctExplanation:
            'A scam is a dishonest plan used to trick you out of your money. Scammers often pretend to be someone you trust to steal your cash.',
      ),
      QuizQuestion(
        question: 'What is a strong ATM pin?',
        options: [
          '"1234"',
          'Your birth year',
          'A unique number',
          'A few digits of your mobile number',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Using your birth year, simple numbers like 1234, or some digits of your mobile number is very dangerous. These are easy for bad people to guess and enter your accounts.',
        correctExplanation:
            'A strong password uses a unique number. This makes it very hard for hackers to guess your ATM pin.',
      ),
      QuizQuestion(
        question: 'What should you do with private information?',
        options: [
          'Keep it secret',
          'Share it online',
          'Post it on social media',
          'Tell strangers',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Sharing private information online, posting it for friends to see, or telling strangers is risky. It can lead to identity theft and loss of your money.',
        correctExplanation:
            'You must keep private information like your bank PIN and social security number a secret. Only share this data with your parents or trusted bank workers.',
      ),
      QuizQuestion(
        question: 'If a deal seems too good to be true...',
        options: [
          'Buy it fast',
          'It is probably a scam',
          'It is a lucky break',
          'Tell everyone',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Buying something too fast or thinking it is just a lucky break can lead to trouble. Most amazing deals that seem impossible are actually clever tricks.',
        correctExplanation:
            'If a deal seems too good to be true, it is likely a scam. You should always be careful and ask an adult before spending your money.',
      ),
      QuizQuestion(
        question: "What is the 'Phishing' scam?",
        options: [
          'Catching fish',
          'A sport',
          'Buying a boat',
          'Fake emails for info',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Phishing is not about catching real fish, playing a sport, or buying a boat. It is a digital crime used to steal your personal financial information.',
        correctExplanation:
            'Phishing is when scammers send fake emails or texts that look real. They want to trick you into clicking links or giving away your private passwords.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q10',
    title: 'Financial Habits',
    subtitle: 'Building good money habits',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is a good money habit?',
        options: [
          'Spending all now',
          'Losing your wallet',
          'Ignoring prices',
          'Saving some every month',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Spending everything you earn, losing your wallet often, or ignoring price tags are bad habits. These actions will prevent you from ever becoming financially stable.',
        correctExplanation:
            'Saving a small part of your money every single month is a great habit. It helps your savings grow over time so you have more later.',
      ),
      QuizQuestion(
        question: 'What does "frugal" mean?',
        options: [
          'Being careful with money',
          'Being cheap',
          'Being rich',
          'Being lazy',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Being frugal is not the same as being mean or cheap. It also does not mean you are already rich or that you are a lazy.',
        correctExplanation:
            'Being frugal means you are careful with your money and avoid wasting it. You look for ways to save money while still getting the things.',
      ),
      QuizQuestion(
        question: 'Why track daily spending?',
        options: [
          'To be bored',
          'To waste paper',
          'To see where money goes',
          'To feel bad',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Tracking your spending is not done to be bored, waste paper, or make you feel bad. It is a tool for understanding your own financial situation.',
        correctExplanation:
            'Tracking spending helps you see exactly how you use your money each day. This lets you find small things you can cut back on to save more.',
      ),
      QuizQuestion(
        question: 'What is "delayed gratification"?',
        options: [
          'Buying now',
          'Getting angry',
          'Being late',
          'Waiting for something better',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Delayed gratification is not about buying things immediately, getting angry, or just being late. It is about having the patience to wait for a bigger reward.',
        correctExplanation:
            'Delayed gratification is waiting to buy something later so you can save for it. This often leads to better choices and more happiness in the future.',
      ),
      QuizQuestion(
        question: 'Who should you ask for money advice?',
        options: [
          'Social media',
          'Trusted adults',
          'Random strangers',
          'Nobody',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Social media, random strangers, or refusing to ask anyone can lead to poor choices. Most people online do not have your best interest in mind at all times.',
        correctExplanation:
            'You should always ask trusted adults like your parents or teachers for money advice. They have more experience and can help you make very smart decisions.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q11',
    title: 'Needs vs Wants',
    subtitle: 'Prioritizing spending',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is an example of a need?',
        options: ['Video games', 'Designer shoes', 'Healthy food', 'A new toy'],
        correctIndex: 2,
        wrongExplanation:
            'Video games, expensive designer shoes, and new toys are all things we want. They are fun to have but your body does not require them to live.',
        correctExplanation:
            'Healthy food is a need because your body must have it to stay strong and alive. You should always buy your needs before spending on wants.',
      ),
      QuizQuestion(
        question: 'What is an example of a want?',
        options: [
          'Drinking water',
          'A movie ticket',
          'A house',
          'Warm clothes',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Drinking water, having a safe house, and wearing warm clothes are all essential needs. Without these things, it would be very hard to stay healthy.',
        correctExplanation:
            'A movie ticket is a want because it is for entertainment only. You can live a happy life without seeing every new movie at the theater every week.',
      ),
      QuizQuestion(
        question: 'What should you pay for first?',
        options: [
          'Gifts for friends',
          'Luxury items',
          'Your wants',
          'Your needs',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Paying for wants, gifts, or luxury items before your essentials can lead to debt. You might run out of money for important things like your.',
        correctExplanation:
            'You should always pay for your needs first, like rent and food. Once your needs are met, you can decide how much for your other wants.',
      ),
      QuizQuestion(
        question: 'Is a cell phone a need or a want?',
        options: [
          'Always a need',
          'Always a want',
          'It can be both',
          'Neither',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Saying a phone is always a need or always a want is not quite correct. It really depends on how the phone is being used everyday.',
        correctExplanation:
            'A phone can be a need for safety and work, but an expensive new model is a want. It is important to know the difference between needs and wants.',
      ),
      QuizQuestion(
        question: 'How do you decide between two wants?',
        options: [
          'Pick what adds more value',
          'Flip a coin',
          'Buy both',
          'Guess',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Flipping a coin, buying both when you don\'t have the money, or guessing are poor choices. You should think about what will truly make you happy.',
        correctExplanation:
            'When picking between wants, choose the thing that adds the most value to your life. Think about which one you will use and enjoy the most.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q12',
    title: 'Saving Strategies',
    subtitle: 'Methods to save money',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is "paying yourself first"?',
        options: [
          'Saving before spending',
          'Buying a gift',
          'Paying bills late',
          'Eating out',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Paying yourself first is not about buying gifts, paying your bills late, or eating at restaurants. These actions actually put your own financial future last.',
        correctExplanation:
            'Paying yourself first means putting money into your savings account as soon as you get paid. You save before you have a chance to spend it.',
      ),
      QuizQuestion(
        question: 'What is a home savings jar used for?',
        options: ['A real pig', 'A bank building', 'A toy', 'A home for coins'],
        correctIndex: 3,
        wrongExplanation:
            'A piggy bank is not a live animal, a large bank building, or just a toy. It is a simple tool for starting your saving journey.',
        correctExplanation:
            'A piggy bank is a small container used to store coins and bills at home. It is a great way for kids to start saving money.',
      ),
      QuizQuestion(
        question: 'Why have a savings goal?',
        options: [
          'To feel sad',
          'To help you stay focused',
          'To waste time',
          'To be mean',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Having a goal is not meant to make you sad, waste your time, or make you mean. It is a positive way to reach your dreams.',
        correctExplanation:
            'A savings goal helps you stay focused on what you are saving for. When you have a target, it is much easier to resist spending.',
      ),
      QuizQuestion(
        question: 'How often should you save?',
        options: [
          'Every time you get money',
          'Once a year',
          'Never',
          'Only on birthdays',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Saving once a year or only on birthdays is not enough to build wealth. Never saving will leave you with no money for emergencies later on.',
        correctExplanation:
            'You should try to save a little bit of money every single time you receive some. Consistent saving is the best way to reach your financial goals.',
      ),
      QuizQuestion(
        question: 'What is the "50/30/20 rule"?',
        options: [
          'A math test',
          'A phone number',
          'A budgeting method',
          'A secret code',
        ],
        correctIndex: 2,
        wrongExplanation:
            'This rule is not a math test, a phone number, or a secret code. It is a simple way for adults and kids to manage their money.',
        correctExplanation:
            'The 50/30/20 rule says to spend 50% on needs, 30% on wants, and 20% on savings. It is a simple way to balance your money.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q13',
    title: 'Money Mistakes',
    subtitle: 'What to avoid',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is a common mistake?',
        options: [
          'Spending more than earned',
          'Saving monthly',
          'Comparing prices',
          'Budgeting',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Monthly saving, comparing prices, and budgeting are all smart habits. These actions help you build wealth and avoid financial stress as you grow up.',
        correctExplanation:
            'Spending more money than you earn is a very big mistake. This leads to debt and makes it impossible for you to save for emergencies and your future goals.',
      ),
      QuizQuestion(
        question: 'Why avoid late fees?',
        options: [
          'They are fun',
          'They are gifts',
          'They waste money',
          'They help banks',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Late fees are never fun and they are certainly not gifts to you. While they help banks make money, they are a total waste of your hard earned money.',
        correctExplanation:
            'Late fees are extra charges you pay when you miss a deadline. Avoiding them keeps more of your own money in your pocket for actual needs and wants.',
      ),
      QuizQuestion(
        question: 'Is it bad to have no savings?',
        options: [
          'No, spending is better',
          'It doesn\'t matter',
          'Only for adults',
          'Yes, for emergencies',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Thinking that spending is better or that it doesn\'t matter will lead to trouble. Everyone, including kids, should have some money set aside for the future.',
        correctExplanation:
            'Yes, it is risky to have no savings because unexpected problems always happen. An emergency fund keeps you safe when you need to buy something unavoidable.',
      ),
      QuizQuestion(
        question: 'What happens if you lose your receipt?',
        options: [
          'Nothing',
          'The store closes',
          'You can\'t return items',
          'You go to jail',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Losing a receipt won\'t close the store or send you to jail, but it is still a mistake. You must keep records of what you buy.',
        correctExplanation:
            'If you lose your receipt, most stores will not let you return an item. Keeping your receipts safe is a very important habit for smart and responsible shopping.',
      ),
      QuizQuestion(
        question: 'Why is lending to friends risky?',
        options: [
          'It isn\'t risky',
          'You might not get paid',
          'It is always good',
          'Friends are rich',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Lending money is always risky, even with friends who seem rich. Assuming it is always good can lead to lost money and a broken friendship.',
        correctExplanation:
            'Lending money to friends is risky because they might not pay you back. It is often better to only lend what you can afford to.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q14',
    title: 'Financial Responsibility',
    subtitle: 'Being accountable with money',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'Who is responsible for your money?',
        options: ['The bank', 'You are', 'Your friends', 'The government'],
        correctIndex: 1,
        wrongExplanation:
            'While banks keep money safe and governments make rules, your friends have no control. Ultimately, nobody else can care for your cash as well as you.',
        correctExplanation:
            'You are the only person responsible for your own money and how you spend it. Being accountable helps you make smarter choices for your own secure financial future.',
      ),
      QuizQuestion(
        question: 'What is a "financial obligation"?',
        options: [
          'A fun party',
          'A free gift',
          'A shiny toy',
          'Something you must pay',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Obligations are not fun parties, free gifts from your family, or shiny new toys. They are serious weights that you must carry until they are finally paid off.',
        correctExplanation:
            'A financial obligation is a promise to pay money for something, like a bill or a loan. You must fulfill these promises to keep a good reputation.',
      ),
      QuizQuestion(
        question: 'Why keep financial records?',
        options: [
          'To track your money',
          'To waste time',
          'To use more ink',
          'To show off',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Financial records are not meant for wasting time, using up extra ink, or showing off to others. They are tools for managing your own personal finances.',
        correctExplanation:
            'Keeping records helps you see where your money goes and prevents you from losing track. This makes it much easier to plan for your future.',
      ),
      QuizQuestion(
        question: 'What is "integrity" in money?',
        options: [
          'Being rich',
          'Having a bank',
          'Being famous',
          'Being honest and fair',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Integrity is not about having a lot of wealth, owning a bank, or being famous. It is about the moral choices you make every single day.',
        correctExplanation:
            'Integrity means being honest with your money and others, even when nobody is watching. Honest people are trusted more in the business world and in life.',
      ),
      QuizQuestion(
        question: 'How do you fix a money mistake?',
        options: ['Hide it', 'Give up', 'Learn and fix it', 'Blame others'],
        correctIndex: 2,
        wrongExplanation:
            'Hiding your errors, giving up completely, or blaming other people will never solve the problem. These actions will only make your difficult situation much worse.',
        correctExplanation:
            'The best way to fix a mistake is to admit it and learn how to do better next time. Finding a solution now prevents bigger problems later on.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q15',
    title: 'Budgeting Basics',
    subtitle: 'Creating your first budget',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is a "balanced budget"?',
        options: [
          'Spending all',
          'Having no money',
          'Income equals spending',
          'Finding a coin and balancing it on your nose',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Spending all your cash or having no money at all means your budget is not balanced. Finding a random coin on the street also does not create a budget.',
        correctExplanation:
            'A balanced budget means the money you spend is not more than the money you earn. This balance ensures you do not fall into expensive debt.',
      ),
      QuizQuestion(
        question: "What is the best definition of a 'fixed expense'?",
        options: [
          'Cost that stays the same',
          'A broken toy',
          'A gift',
          'A random bill',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Fixed expenses are not broken items, happy gifts, or random bills that pop up. They are costs that you can predict because they never change much.',
        correctExplanation:
            'A fixed expense is a cost that is the same amount every single month, like rent or insurance. These are the easiest bills to plan for.',
      ),
      QuizQuestion(
        question: "What is the best definition of a 'variable expense'?",
        options: [
          'A constant cost',
          'Cost that changes',
          'A free item',
          'A car',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Variable expenses are the opposite of constant costs and are certainly not free. While a car has costs, the term describes how the price itself changes.',
        correctExplanation:
            'A variable expense is a cost that changes from month to month, like a grocery bill. You have more control over these costs by shopping carefully.',
      ),
      QuizQuestion(
        question: 'Why use a budget app or paper?',
        options: [
          'To organize spending',
          'To look busy',
          'To play games',
          'To waste paper',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Looking busy, playing games, or wasting paper are not the goals of a budget. These tools are meant to bring order to your messy financial life.',
        correctExplanation:
            'Using a tool helps you organize your spending and see where you can save. It makes the math easier so you don\'t have to remember everything.',
      ),
      QuizQuestion(
        question: 'What is "disposable income"?',
        options: [
          'Garbage money',
          'Debt money',
          'Tax money',
          'Money left after needs',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Disposable income is not money you throw in the garbage, money you owe as debt, or taxes. It is the part you get to keep.',
        correctExplanation:
            'Disposable income is the money you have left over after you pay for all your needs. You can choose to save it or spend it.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q16',
    title: 'Payment Methods',
    subtitle: 'Cash, cards, and digital',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is "cash"?',
        options: [
          'Metal coins',
          'A credit card',
          'A check',
          'Physical bills and coins',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Cash is not just metal coins, nor is it a credit card or a paper check. These are all different ways to pay for things today.',
        correctExplanation:
            'Cash includes both the physical paper bills and metal coins you carry in your wallet. It is accepted almost everywhere for small and large daily.',
      ),
      QuizQuestion(
        question: 'What is a debit card?',
        options: [
          'Borrowed money',
          'Your own bank money',
          'A gift card',
          'A library card',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Debit cards are not for borrowing money, and they are not gift cards or library cards. They are linked directly to what you already have saved.',
        correctExplanation:
            'A debit card takes money directly out of your bank account when you buy something. You can only spend what you actually have in the bank.',
      ),
      QuizQuestion(
        question: 'What is a "digital wallet"?',
        options: [
          'A metal box',
          'A video game',
          'An app that stores cards',
          'A website',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Digital wallets are not metal boxes, video games, or just any website. They are specialized apps designed to store your payment information safely on your phone.',
        correctExplanation:
            'A digital wallet is an app on your phone that stores your credit and debit cards. It lets you pay at stores without carrying a wallet.',
      ),
      QuizQuestion(
        question: 'Why use a check?',
        options: [
          'To be slow',
          'To pay large amounts',
          'To draw on',
          'To throw away',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Checks are not meant for being slow, drawing pictures, or throwing away. They are formal documents used for sending money safely when you don\'t have cash.',
        correctExplanation:
            'A check is a paper document that tells your bank to pay someone a specific amount. People often use them for big bills like rent.',
      ),
      QuizQuestion(
        question: 'What is a "transaction"?',
        options: ['A money exchange', 'A car', 'A secret', 'A gift'],
        correctIndex: 0,
        wrongExplanation:
            'A transaction is not a type of car, a secret you keep, or a simple gift. it is a business action between two people or companies today.',
        correctExplanation:
            'A transaction is any time you exchange money for a good or service. Buying a snack at a store is a simple example of a common business action.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q17',
    title: 'Value of Money',
    subtitle: 'Understanding purchasing power',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is "purchasing power"?',
        options: [
          'Strength to buy',
          'Cost of a car',
          'How much money buys',
          'Having a job',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Purchasing power is not physical strength, the cost of a single car, or just having a job. It is about what your money can actually buy.',
        correctExplanation:
            'Purchasing power is the amount of goods and services that one denomination of money can buy. When prices go up, your purchasing power starts to go down.',
      ),
      QuizQuestion(
        question: 'What is "scarcity"?',
        options: [
          'Having too much',
          'Being scared',
          'A type of fruit',
          'Not having enough',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Scarcity is not about having too much of something, being scared of the dark, or a fruit. It is a fundamental rule about limited global resources.',
        correctExplanation:
            'Scarcity means there is not enough of something for everyone who wants it. Scarcity usually makes the price of an item go up much higher.',
      ),
      QuizQuestion(
        question: 'Why does money have value?',
        options: [
          'It is pretty',
          'It is made of gold',
          'People agree it does',
          'It is old',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Money is not valuable just because it looks pretty, is made of gold, or is old. Its value comes from the trust of the entire community.',
        correctExplanation:
            'Money has value because everyone in a country agrees to use it for trade. The government also stands behind it to make sure it stays.',
      ),
      QuizQuestion(
        question: 'What is "bartering"?',
        options: [
          'Trading items directly',
          'Buying with cash',
          'Saving coins',
          'Working hard',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Bartering is not using cash, saving coins in a bank, or just working hard. It is an ancient way to get things without using any money.',
        correctExplanation:
            'Bartering is trading one thing you have for something someone else has. For example, you might trade a shiny apple for a tasty pear at school.',
      ),
      QuizQuestion(
        question: 'How do prices change?',
        options: [
          'They never change',
          'Supply and demand',
          'By magic',
          'By accident',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Prices do not stay the same forever, and they certainly don\'t change by magic or by accident. They follow very specific rules of the national economy.',
        correctExplanation:
            'Prices change based on supply and demand in the market. If many people want something but there is not much of it, the price rises.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q18',
    title: 'Charitable Giving',
    subtitle: 'Helping others with money',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is a "charity"?',
        options: [
          'A big store',
          'A bank',
          'A type of food',
          'An organization that helps',
        ],
        correctIndex: 3,
        wrongExplanation:
            'A charity is not a store that sells items for profit, a bank, or a type of food. It is a group with a special purpose.',
        correctExplanation:
            'A charity is a group that raises money to help people, animals, or the environment. They do not try to make a profit for themselves.',
      ),
      QuizQuestion(
        question: 'What is "donating"?',
        options: [
          'Giving money/items free',
          'Selling toys',
          'Borrowing a book',
          'Eating lunch',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Donating is not selling your old toys for cash, borrowing a book from the library, or eating lunch. It is a selfless act for others.',
        correctExplanation:
            'Donating means giving your money, time, or items to help others without expecting anything back. It is a kind way to support your local community.',
      ),
      QuizQuestion(
        question: 'Why give to others?',
        options: [
          'To be famous',
          'To lose money',
          'To be cool',
          'To help the community',
        ],
        correctIndex: 3,
        wrongExplanation:
            'You should not give money just to be famous or cool. While you do lose that money, the goal is not to be poor but to help others in need.',
        correctExplanation:
            'Giving helps solve problems in your community and makes the world a better place. It also makes you feel good to know you helped someone.',
      ),
      QuizQuestion(
        question: 'What is "volunteering"?',
        options: [
          'A paid job',
          'Giving your time free',
          'Going to school',
          'Playing games',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Volunteering is not a job where you get paid, going to school, or just playing games. It is a valuable gift of your precious time.',
        correctExplanation:
            'Volunteering is when you give your time to help others for free. You might help at an animal shelter or clean up a local park.',
      ),
      QuizQuestion(
        question: 'How much should you give to charity?',
        options: [
          'Everything you own',
          'Nothing',
          'What you can afford',
          'At least one thousand',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Giving everything you own is not wise, and giving nothing is not helpful. You should also not feel pressured to give a specific large amount.',
        correctExplanation:
            'You should give what you can afford after taking care of your own needs. Even a small amount can make a big difference to someone.',
      ),
    ],
  ),
];

final List<QuizMetadata> _hardQuizzes = [
  QuizMetadata(
    id: 'l1_q19',
    title: 'Financial Decision Making',
    subtitle: 'Making tough money choices',
    difficulty: QuizDifficulty.hard,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is "opportunity cost"?',
        options: [
          'What you give up when you make a purchase',
          'The price of a toy',
          'A bank fee',
          'Total savings',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Opportunity cost is not the sticker price, a bank fee, or your total savings. It is a hidden cost that every person faces when choosing between two or more things.',
        correctExplanation:
            'Opportunity cost is the thing you give up when you make a purchase. If you spend money on a movie, you give up the opportunity to buy a new book.',
      ),
      QuizQuestion(
        question: 'How do you analyze a purchase?',
        options: [
          'Guess',
          'Think about cost vs value',
          'Buy immediately',
          'Ask a friend',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Guessing or buying immediately are poor ways to handle your money. While friends can help, you need to think for yourself about the true value of the purchase.',
        correctExplanation:
            'To analyze a purchase, you should think about how much it costs and how much value it brings. This helps you avoid wasting your hard-earned money.',
      ),
      QuizQuestion(
        question: 'What is "risk" in finance?',
        options: [
          'Chance for loss or gain',
          'A fun game',
          'A sure thing',
          'A bank',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Risk is not a fun board game, a sure thing with no chance of failure, or a bank building. It is the possibility of failure.',
        correctExplanation:
            'Risk is the chance that you might lose money or gain money on a choice. Smart people study the risks before they ever invest their money.',
      ),
      QuizQuestion(
        question: 'Why should you wait before a big purchase?',
        options: [
          'To be slow',
          'To miss the sale',
          'To avoid impulse choices',
          'To get tired',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Waiting is not about being slow or wanting to miss a good sale. It is a mental tool to help you stay in control.',
        correctExplanation:
            'Waiting 24 hours before a big purchase helps you avoid making a choice based on emotions. This simple rule can save you from big purchases that you regret later.',
      ),
      QuizQuestion(
        question: 'What is a "trade-off"?',
        options: [
          'A type of car',
          'A secret',
          'A discount',
          'Giving up one for another',
        ],
        correctIndex: 3,
        wrongExplanation:
            'A trade-off is not a car, a secret, or a discount. It is a decision where you must choose between two things you really want.',
        correctExplanation:
            'A trade-off is when you give up one thing to get something else you want more. Life and money are full of these important decisions.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l1_q20',
    title: 'Money Psychology',
    subtitle: 'Relationship with money',
    difficulty: QuizDifficulty.hard,
    requiredLevel: 1,
    questions: [
      QuizQuestion(
        question: 'What is "peer pressure" in spending?',
        options: [
          'A math tool',
          'Buying to fit in',
          'A type of gas',
          'A gym class',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Peer pressure is not a math tool, a type of gas, or a gym class. It is a social force that can hurt your wallet and ruin your financial future.',
        correctExplanation:
            'Peer pressure is when you feel like you must buy something because your friends have it. It is important to make choices based on your own needs and wants, not what others are doing.',
      ),
      QuizQuestion(
        question: 'How do advertisers try to trick you?',
        options: [
          'They tell only facts',
          'They give free toys',
          'They use emotional appeal',
          'They can\'t trick me',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Ads rarely tell just the plain facts and they don\'t usually give away free things. Most ads are designed to make you feel a specific emotion.',
        correctExplanation:
            'Advertisements often use music and happy people to make you feel like you need their product. Knowing their tricks helps you shop logic over emotion.',
      ),
      QuizQuestion(
        question: 'What is "consumerism"?',
        options: [
          'Focus on buying more',
          'A type of plant',
          'A bank',
          'A sport',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Consumerism is not a plant, a bank, or a sport. It is a way that society thinks about buying and owning many new things.',
        correctExplanation:
            'Consumerism is the idea that buying more things will make you happier. However, true happiness usually comes from experiences and relationships, not from owning more things.',
      ),
      QuizQuestion(
        question: 'Why does "brand name" matter?',
        options: [
          'Better quality only',
          'It is cheaper',
          'It is magic',
          'It costs more for name',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Brand names are not always better quality and they are definitely not cheaper or magic. You are often paying extra just for the popular brand name.',
        correctExplanation:
            'A brand name often costs more because of the company\'s reputation and advertising. Sometimes the same product without the name brand is much cheaper for the same quality.',
      ),
      QuizQuestion(
        question: 'What is a "money mindset"?',
        options: [
          'Your attitude on money',
          'A brain disease',
          'A math skill',
          'A bank',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Money mindset is not a brain disease, a simple math skill, or a physical bank. It is the way your mind thinks about your own finances carefully.',
        correctExplanation:
            'Your money mindset is your beliefs and feelings about money. A positive mindset helps you believe that you can learn to manage your money well over time.',
      ),
    ],
  ),
];

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

final List<QuizMetadata> _level2Quizzes = [
  QuizMetadata(
    id: 'l2_q1',
    title: 'Interest: Growing Money',
    subtitle: 'Understanding how money grows',
    difficulty: QuizDifficulty.easy,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is interest in a savings account?',
        options: [
          'A fee you pay to the bank',
          'Money the bank pays you for keeping your money there',
          'A type of tax',
          'A physical coin',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Interest in a savings account is a reward, not a fee or a tax. The bank pays you to use your money.',
        correctExplanation:
            'Interest is essentially "rent" that the bank pays you to use the money you keep in your account.',
      ),
      QuizQuestion(
        question: 'What is "compound interest"?',
        options: [
          'Interest earned only on the principal',
          'Interest earned on principal plus previous interest',
          'A very difficult math problem',
          'Interest that never changes',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Interest only on the principal is simple interest. Compound interest builds on itself over time.',
        correctExplanation:
            'Compound interest is like a snowball effect; your interest earns its own interest, making your money grow much faster.',
      ),
      QuizQuestion(
        question:
            'Which of these makes your money grow the most over 10 years?',
        options: [
          'Keeping it in a jar at home',
          'Simple interest',
          'Compound interest',
          'Spending it immediately',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Simple interest grows steadily, but compound interest accelerates growth by building on previous earnings.',
        correctExplanation:
            'Compound interest is the most powerful tool for long-term wealth because it grows exponentially.',
      ),
      QuizQuestion(
        question: 'Why is a high interest rate bad when you OWE money (debt)?',
        options: [
          'It makes your debt disappear',
          'It makes your debt grow faster',
          'It makes no difference',
          'It makes the bank happy',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Interest works against you in debt. High rates mean you pay back much more than you borrowed.',
        correctExplanation:
            'Just like interest helps savings grow, it makes debt grow too. High rates can make debt very hard to pay off.',
      ),
      QuizQuestion(
        question: 'Why is it better to start saving earlier in life?',
        options: [
          'You have more time for interest to compound',
          'You have less money to spend',
          'It is easier to find banks',
          'Older people aren\'t allowed to save',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Anyone can save, but time is the most important factor for compound interest to work its magic.',
        correctExplanation:
            'The longer your money sits in an interest-bearing account, the more cycles of compounding it goes through.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q2',
    title: 'Credit Scores: Your Reputation',
    subtitle: 'How banks decide to trust you',
    difficulty: QuizDifficulty.easy,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is a credit score?',
        options: [
          'Your total bank balance',
          'A rating of how likely you are to pay back a loan',
          'A grade from your math teacher',
          'The number of credit cards you have',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s not your balance or teacher grade. It\'s a numerical "trust rating" used by lenders.',
        correctExplanation:
            'A credit score is a number that tells banks and lenders how responsible you have been with borrowed money in the past.',
      ),
      QuizQuestion(
        question: 'Which of these helps improve your credit score?',
        options: [
          'Paying your bills late',
          'Paying your bills on time, every time',
          'Maxing out all your credit cards',
          'Avoiding all forms of money',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Late payments and high debt hurt your score. Consistency is key to a good score.',
        correctExplanation:
            'The most important factor in a good credit score is a history of paying what you owe on time.',
      ),
      QuizQuestion(
        question: 'Who might check your credit score?',
        options: [
          'Your friends',
          'Social media companies',
          'Landlords and banks',
          'Only your parents',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Social media and friends don\'t check it, but people who you want to borrow from or rent from will.',
        correctExplanation:
            'Landlords use it to see if you\'ll pay rent, and banks use it to decide if they should give you a loan.',
      ),
      QuizQuestion(
        question: 'What is a "credit report"?',
        options: [
          'A report card for school',
          'A list of all your financial earnings',
          'A history of your borrowing and payments',
          'A list of things you want to buy',
        ],
        correctIndex: 2,
        wrongExplanation:
            'It\'s not about school or earnings. It\'s the detailed history used to calculate your credit score.',
        correctExplanation:
            'A credit report is the record of your credit history, including loans, credit cards, and payment history.',
      ),
      QuizQuestion(
        question: 'Why is it beneficial to have a high credit score?',
        options: [
          'You get free groceries',
          'You can get lower interest rates on loans',
          'You never have to pay taxes',
          'It makes you taller',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It won\'t skip taxes or give free food, but it saves you massive amounts of money on house or car loans.',
        correctExplanation:
            'A high score shows you are reliable, so banks offer you lower interest rates because you are a "low risk" borrower.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q3',
    title: 'Taxes: Supporting Society',
    subtitle: 'Why we pay and where it goes',
    difficulty: QuizDifficulty.easy,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is "sales tax"?',
        options: [
          'A discount on items',
          'An extra percentage added to the price of items you buy',
          'The price of a product',
          'A fee for using a credit card',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Sales tax is not a discount; it\'s an additional cost that goes to the government.',
        correctExplanation:
            'Sales tax is a tax paid to a governing body for the sales of certain goods and services.',
      ),
      QuizQuestion(
        question: 'What is "income tax"?',
        options: [
          'A tax on the items you sell',
          'A tax on the money you earn from a job',
          'Money the government gives you',
          'A fee to open a bank account',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Income tax is taken from your earnings, not from sales or bank fees.',
        correctExplanation:
            'Income tax is a type of tax that governments impose on income generated by businesses and individuals.',
      ),
      QuizQuestion(
        question: 'What are some things that tax money pays for?',
        options: [
          'Video games for everyone',
          'Roads, schools, and public safety',
          'Private vacations for government workers',
          'Only big businesses',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Taxes are meant for public services that benefit the whole community.',
        correctExplanation:
            'Taxes fund essential services like public education, infrastructure repair, and emergency services.',
      ),
      QuizQuestion(
        question: 'What is "Net Pay" on a paycheck?',
        options: [
          'The total amount you earned before taxes',
          'The amount you actually take home after taxes and deductions',
          'A bonus for good work',
          'A fee for working',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Before taxes is "Gross Pay." Net Pay is what is actually available in your bank account.',
        correctExplanation:
            'Net pay is the amount of money an employee takes home after all deductions have been made from their gross pay.',
      ),
      QuizQuestion(
        question: 'Why should you include tax when planning a big purchase?',
        options: [
          'Because the final price will be higher than the price tag',
          'To help the store make more money',
          'Because taxes are optional',
          'To get a refund later',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Taxes aren\'t optional and they don\'t help the store profit; they just increase the total cost you must pay.',
        correctExplanation:
            'Since sales tax is added at the register, the "sticker price" isn\'t the total amount of money you need to have.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q4',
    title: 'Inflation: When Prices Rise',
    subtitle: 'Understanding why things cost more',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is "inflation"?',
        options: [
          'When prices for everything generaly go up over time',
          'When the value of money increases',
          'A type of car tire',
          'When it is easy to find a job',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Inflation is about prices rising, which actually makes the value of your money go down.',
        correctExplanation:
            'Inflation is a general increase in prices and fall in the purchasing value of money.',
      ),
      QuizQuestion(
        question: 'How does inflation affect your savings?',
        options: [
          'It makes your savings more valuable',
          'It buys less over time if interest doesn\'t keep up',
          'It has no effect on savings',
          'It adds free money to your account',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Inflation "eats" your savings by making everything more expensive in the future.',
        correctExplanation:
            'If prices go up 5% but your savings only grow 1%, you actually lose "purchasing power."',
      ),
      QuizQuestion(
        question:
            'If inflation is 3% and your bank interest is 1%, are you gaining purchasing power?',
        options: [
          'Yes, because 1% is growth',
          'No, you are losing purchasing power because prices rise faster than your interest',
          'It stays exactly the same',
          'Banks don\'t care about inflation',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Even if you have more dollars, those dollars buy 3% less stuff, while you only have 1% more dollars.',
        correctExplanation:
            'To "win" against inflation, your money must grow faster than the rate at which prices are rising.',
      ),
      QuizQuestion(
        question:
            'What usually happens to inflation if too much money is printed?',
        options: [
          'Prices go down',
          'Prices go up because money becomes less rare',
          'Nothing happens',
          'Everyone becomes a billionaire',
        ],
        correctIndex: 1,
        wrongExplanation:
            'When money is too common, people charge more for goods, leading to higher inflation.',
        correctExplanation:
            'If everyone has too much money chasing the same amount of goods, the prices of those goods will rise.',
      ),
      QuizQuestion(
        question: 'Why are historical prices (like 1950) usually much lower?',
        options: [
          'People were nicer back then',
          'Because of long-term inflation over decades',
          'Because money didn\'t exist yet',
          'Items were made of cheaper materials',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s not about the quality; it\'s about the steady rise of prices over many years.',
        correctExplanation:
            'Over long periods, small amounts of inflation add up, making a certain amount of money in 1950 much more purchasing power than today.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q5',
    title: 'Opportunity Cost: Choices',
    subtitle: 'What are you giving up?',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: "What is the primary definition of 'opportunity cost'?",
        options: [
          'The price tag on an item',
          'The value of the next best thing you give up when making a choice',
          'The cost of an opportunity to work',
          'A type of luxury tax',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s not a dollar cost on a tag; it\'s the "lost value" of the choice you didn\'t pick.',
        correctExplanation:
            'Every time you spend money on A, you lose the chance to use that same money on B. B is the opportunity cost.',
      ),
      QuizQuestion(
        question:
            'If you spend 💎50 on a video game instead of saving it, what is the opportunity cost?',
        options: [
          'The video game itself',
          'The 💎50 plus any future interest it could have earned',
          'The time spent playing the game',
          'Nothing, the 💎50 is gone anyway',
        ],
        correctIndex: 1,
        wrongExplanation:
            'You have the game, but you lost the growth potentially offered by saving or investing that 💎50.',
        correctExplanation:
            'Opportunity cost includes both the money and what that money *could have become* in the future.',
      ),
      QuizQuestion(
        question: 'Does a "free" activity have an opportunity cost?',
        options: [
          'No, because it is free',
          'Yes, because you give up the time you could have used for something else',
          'Only if it requires a ticket',
          'Free things are never worth it',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Time is money! Using 2 hours on something "free" means you didn\'t use those 2 hours to earn or learn.',
        correctExplanation:
            'Time is a limited resource. Using it for one thing means you can\'t use it for another.',
      ),
      QuizQuestion(
        question: 'Why is understanding opportunity cost important for wealth?',
        options: [
          'It helps you realize the true impact of spending',
          'It makes you stop buying everything',
          'It lowers your taxes',
          'It helps you find discounts',
        ],
        correctIndex: 0,
        wrongExplanation:
            'It doesn\'t lower taxes, but it makes you a much smarter "chooser" of where your money goes.',
        correctExplanation:
            'By seeing what you lose (long term growth) for what you gain (short term fun), you make better financial choices.',
      ),
      QuizQuestion(
        question: 'Every financial choice involves...',
        options: [
          'A trip to the bank',
          'Giving something up to get something else',
          'Winning the lottery',
          'Calling a lawyer',
        ],
        correctIndex: 1,
        wrongExplanation:
            'You don\'t always need a bank, but you ALWAYS give up an alternative when you choose.',
        correctExplanation:
            'In a world of limited money and time, every choice is a trade-off.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q6',
    title: 'Entrepreneurs & Profit',
    subtitle: 'Being your own boss',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is an "entrepreneur"?',
        options: [
          'A government worker',
          'Someone who starts and runs their own business',
          'A type of high-end manager',
          'A bank employee',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Entrepreneurs take the initiative to create something new rather than working for an existing system.',
        correctExplanation:
            'An entrepreneur organizes, manages, and assumes the risks of a business or enterprise.',
      ),
      QuizQuestion(
        question: 'How do you calculate "Profit"?',
        options: [
          'Total Income + Total Expenses',
          'Total Income - Total Expenses',
          'Total Bank Balance',
          'The number of employees you have',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Adding expenses would be bad! You must subtract what you spend from what you make.',
        correctExplanation:
            'Profit is the money left over after all the bills and costs of the business are paid.',
      ),
      QuizQuestion(
        question: 'What is "Revenue"?',
        options: [
          'The total money a business receives from selling goods/services',
          'The profit after taxes',
          'The amount of debt a company has',
          'A type of new product',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Revenue is the "top line" - all the money coming in before any expenses are subtracted.',
        correctExplanation:
            'Revenue is the total amount of money generated by the sale of goods or services associated with the business.',
      ),
      QuizQuestion(
        question: 'What is the main "Risk" for an entrepreneur?',
        options: [
          'Having too many customers',
          'Losing their own money and time if the business fails',
          'Having to work too little',
          'Getting a promotion',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The risk is that the "Profit" might be negative, meaning the owner loses money instead of making it.',
        correctExplanation:
            'Entrepreneurs often invest their own money and time with no guarantee of success.',
      ),
      QuizQuestion(
        question: 'Why might a business fail even if it has many customers?',
        options: [
          'Because customers pay too much',
          'Because its expenses are higher than its income',
          'Because the owner is too happy',
          'Because it has no competition',
        ],
        correctIndex: 1,
        wrongExplanation:
            'More customers can sometimes mean more loss if every sale costs more to produce than the sales price.',
        correctExplanation:
            'Sustainability requires that Revenue is consistently higher than Expenses.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q7',
    title: 'Stocks vs Bonds',
    subtitle: 'Where to put your investment',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is a "Stock"?',
        options: [
          'A loan to a company',
          'Partial ownership of a company',
          'A type of insurance',
          'A government guarantee',
        ],
        correctIndex: 1,
        wrongExplanation: 'Bonds are loans; stocks are pieces of ownership.',
        correctExplanation:
            'When you buy a stock, you become a "shareholder," meaning you own a tiny part of the company.',
      ),
      QuizQuestion(
        question: 'What is a "Bond"?',
        options: [
          'A loan you give to a company or government',
          'Buying a piece of a company',
          'A promise to work harder',
          'A type of digital currency',
        ],
        correctIndex: 0,
        wrongExplanation:
            'It\'s not ownership; it\'s a debt instrument where they promise to pay you back with interest.',
        correctExplanation:
            'A bond is essentially an I.O.U. from a government or corporation that pays you interest for a set period.',
      ),
      QuizQuestion(
        question: 'Which investment is generally "Higher Risk, Higher Reward"?',
        options: [
          'Savings accounts',
          'Government bonds',
          'Stocks',
          'Keeping cash',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Bonds and savings are safer but grow slower. Stocks can go up 50% or down 50%.',
        correctExplanation:
            'Stocks have high potential for growth but also a high chance of losing value.',
      ),
      QuizQuestion(
        question: 'What is a "Dividend"?',
        options: [
          'A type of tax on stocks',
          'A share of the company\'s profits paid to stockholders',
          'A fee for selling a stock',
          'The price of a bond',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s a reward! Companies share their success by sending cash to their owners.',
        correctExplanation:
            'Many profitable companies pay out dividends regularly to thank investors for holding their stock.',
      ),
      QuizQuestion(
        question: 'Why would someone choose a Bond over a Stock?',
        options: [
          'They want to own the company',
          'They want more predictable income and lower risk',
          'Bonds are always more profitable',
          'Bonds are more exciting',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Stocks are usually more profitable long-term, but bonds provide safety and steady interest.',
        correctExplanation:
            'Bonds are used for "stability" - knowing exactly how much you will get back and when.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q8',
    title: 'Net Worth: Financial Health',
    subtitle: 'The big picture of your money',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is an "Asset"?',
        options: [
          'Money you owe to others',
          'Something you own that has value',
          'A type of financial mistake',
          'Only cash in your wallet',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Money you owe is a liability. Assets include cash, properties, cars, and investments.',
        correctExplanation:
            'An asset is anything of value that can be converted into cash.',
      ),
      QuizQuestion(
        question: 'What is a "Liability"?',
        options: [
          'Something you own',
          'Money you owe to someone else (debt)',
          'Your total income',
          'A high credit score',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Assets are owned; liabilities are owed. Examples include loans and credit card debt.',
        correctExplanation:
            'A liability is a financial obligation or debt that you must pay to others.',
      ),
      QuizQuestion(
        question: 'How do you calculate "Net Worth"?',
        options: [
          'Total Assets + Total Liabilities',
          'Total Assets - Total Liabilities',
          'Monthly Income - Monthly Rent',
          'Total Cash in Bank',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you have 💎1000 but owe 💎900, your net worth is only 💎100. Adding them would be wrong!',
        correctExplanation:
            'Net worth is the most accurate measure of wealth, as it counts what you own minus what you owe.',
      ),
      QuizQuestion(
        question:
            'If you have a 💎20,000 car but own it with a 💎15,000 loan, what is your net worth related to that car?',
        options: ['💎20,000', '💎15,000', '💎5,000', '💎35,000'],
        correctIndex: 2,
        wrongExplanation:
            'You must subtract the loan (💎15k) from the value (💎20k) to see your actual equity.',
        correctExplanation:
            'Your equity (actual wealth) in the car is the value minus the debt: 💎5,000.',
      ),
      QuizQuestion(
        question:
            'Why is Net Worth more important than just having a high salary?',
        options: [
          'It isn\'t, salary is all that matters',
          'It shows if you are actually keeping your money or just spending it',
          'Because it sounds more professional',
          'It helps you get more vacation time',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Someone with a 💎1M salary who spends 💎1.1M is actually getting poorer (negative net worth).',
        correctExplanation:
            'Wealth is built by growing assets and shrinking liabilities, not just by having a high income.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q9',
    title: 'Good Debt vs Bad Debt',
    subtitle: 'Which loans help you grow?',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is generally considered "Good Debt"?',
        options: [
          'Debt used for things that lose value quickly',
          'Debt that helps you increase your wealth or income long-term',
          'Any debt with a high interest rate',
          'Debt you never plan to pay back',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Good debt is an investment in your future, like a student loan for education or a business loan.',
        correctExplanation:
            'Good debt is viewed as an investment in oneself or a business that will generate more income than the cost of the loan.',
      ),
      QuizQuestion(
        question: 'What is an example of "Bad Debt"?',
        options: [
          'A student loan for a useful degree',
          'A business loan for a profitable shop',
          'High-interest credit card debt for luxury clothes',
          'A mortgage for a home you can afford',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Loans for education or houses can build wealth. High-interest debt for "stuff" that disappears or loses value is bad.',
        correctExplanation:
            'Bad debt usually has high interest and is used for things that don\'t increase your future wealth.',
      ),
      QuizQuestion(
        question: 'Is a house loan (mortgage) usually good or bad debt?',
        options: [
          'Always bad, because it is a huge amount',
          'Usually good, because houses often increase in value over time',
          'It doesn\'t count as debt',
          'Only bad if the house has a garden',
        ],
        correctIndex: 1,
        wrongExplanation:
            'While it\'s a large debt, a mortgage helps you own an asset that usually grows in value.',
        correctExplanation:
            'A mortgage is often called good debt because it allows you to build equity in an asset that historically appreciates.',
      ),
      QuizQuestion(
        question: 'Why are "Payday Loans" considered very bad debt?',
        options: [
          'They are too easy to get',
          'They have extremely high interest rates (often over 300%)',
          'They are only for weekends',
          'The banks are too friendly',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The speed of the loan is a trap. The interest rates are so high they make it almost impossible to pay back.',
        correctExplanation:
            'Payday loans are predatory because their interest rates are astronomically high compared to traditional bank loans.',
      ),
      QuizQuestion(
        question: 'Borrowing money to start a business is good debt if...',
        options: [
          'The business makes more profit than the loan interest costs',
          'The owner gets a fancy office',
          'The loan is never repaid',
          'The business has a cool name',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A business loan is only "good" if the business actually succeeds and generates a return on that investment.',
        correctExplanation:
            'If your business earns 15% return but your loan costs 5%, you are "winning" with good debt.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q10',
    title: 'Identity Theft & Scams',
    subtitle: 'Protecting your digital money',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is "Phishing"?',
        options: [
          'A type of outdoor sport',
          'Fake emails or texts designed to steal your passwords or info',
          'Buying too many fish online',
          'A new way to invest in stocks',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s a digital trap. Scammers "fish" for your private information by pretending to be a bank or company.',
        correctExplanation:
            'Phishing is a common scam where someone pretends to be a trusted source to get you to reveal secrets.',
      ),
      QuizQuestion(
        question:
            'What should you do if a "bank worker" calls and asks for your password?',
        options: [
          'Give it to them so they can help you',
          'Hang up immediately because real banks never ask for passwords on the phone',
          'Ask them for their password first',
          'Give them a fake password',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Never share passwords. Real banks already have access to your account and don\'t need your secret password.',
        correctExplanation:
            'Protecting your credentials is your #1 defense against identity theft. Banks will never ask for your password.',
      ),
      QuizQuestion(
        question: 'Which of these is a sign of a "Ponzi Scheme"?',
        options: [
          'A business selling high-quality products',
          'A deal that promises "guaranteed high returns with zero risk"',
          'A bank with low interest rates',
          'A store with a big sale',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Real investing ALWAYS has some risk. Anyone promising "guaranteed" huge money is usually lying.',
        correctExplanation:
            'Ponzi schemes use money from new members to pay "profits" to old members until the whole system collapses.',
      ),
      QuizQuestion(
        question: 'How can you protect your money when using an ATM?',
        options: [
          'Tell the person behind you your PIN',
          'Cover the keypad when typing your PIN',
          'Leave your receipt in the machine',
          'Use the ATM in the middle of the night in a dark alley',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Hidden cameras or "skimmers" can steal your info if you don\'t shield the keypad.',
        correctExplanation:
            'Shielding your PIN is a simple and effective physical security measure.',
      ),
      QuizQuestion(
        question:
            'If an online deal sounds "too good to be true," it usually is...',
        options: [
          'A lucky break',
          'A scam designed to take your money',
          'A gift from the internet',
          'A mistake by the website owners',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Scammers use greed to blind people. If someone offers 💎1000 for 💎10, they are going to steal your 💎10.',
        correctExplanation:
            'Skepticism is a vital financial skill. Always research and double-check "amazing" offers.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q11',
    title: 'Emergency Funds',
    subtitle: 'Your financial safety net',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is an "Emergency Fund"?',
        options: [
          'Money saved specifically for unexpected crises',
          'A fund for your next vacation',
          'Money you use for daily snacks',
          'A pile of cash for a new car',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Vacations and cars are planned. Emergency funds are for things you CAN\'T plan for, like a medical bill.',
        correctExplanation:
            'An emergency fund provides a buffer that prevents you from going into debt when life goes wrong.',
      ),
      QuizQuestion(
        question: 'How much should you ideally have in an emergency fund?',
        options: [
          'One week of spending',
          '3 to 6 months of essential living expenses',
          '💎100 is enough',
          'All the money you will ever earn',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A week or 💎100 isn\'t enough if you lose a job. You need enough to live on while you recover.',
        correctExplanation:
            'Having several months of expenses saved gives you peace of mind and true financial security.',
      ),
      QuizQuestion(
        question:
            'Which of these is a valid reason to use your emergency fund?',
        options: [
          'A big sale on your favorite clothes',
          'Losing your job or a major medical emergency',
          'Wanting to upgrade to a newer phone',
          'Buying a birthday gift for a friend',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Sales and gifts are not emergencies. Emergencies are threats to your safety, health, or ability to work.',
        correctExplanation:
            'Rule of thumb: If it can wait until next month, it\'s not an emergency.',
      ),
      QuizQuestion(
        question:
            'Why is an emergency fund better than using a credit card for crises?',
        options: [
          'Credit cards are illegal for emergencies',
          'It avoids high interest debt and added stress',
          'Credit cards have no limit',
          'Emergency funds are more stylish',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Using a credit card in a crisis means you have a crisis PLUS a new, expensive debt to pay back.',
        correctExplanation:
            'Paying with your own savings is "interest-free" and helps you stay out of the debt trap.',
      ),
      QuizQuestion(
        question: 'Where is the best place to keep an emergency fund?',
        options: [
          'Under your mattress',
          'A liquid savings account that is easy to access',
          'Invested in risky startup stocks',
          'In a locked box with no key',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Mattresses can be stolen/burned, and stocks can lose value when you need the money most. You need safety and access.',
        correctExplanation:
            'A high-yield savings account is ideal because it is safe, earns a little interest, and you can get the cash quickly.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q12',
    title: 'Risk and Diversification',
    subtitle: 'Managing your investment safety',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What does "Diversification" mean in investing?',
        options: [
          'Buying only one very good stock',
          'Spreading your money across many different types of investments',
          'Changing your bank every month',
          'Learning to speak different languages',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Focusing on one thing is the opposite of diversification. Spreading out lowers your risk.',
        correctExplanation:
            'Diversification is the strategy of "not putting all your eggs in one basket."',
      ),
      QuizQuestion(
        question:
            'If you only own stock in ONE company, what is your biggest risk?',
        options: [
          'The company might become too successful',
          'If that one company fails, you lose all your money',
          'Dividends might be too high',
          'You won\'t be able to buy more',
        ],
        correctIndex: 1,
        wrongExplanation:
            'No company is perfectly safe. By owning only one, you are tied 100% to its survival.',
        correctExplanation:
            'Single-stock risk is high. Diversifying across 20+ companies makes one failure less painful.',
      ),
      QuizQuestion(
        question: 'What is a "Mutual Fund"?',
        options: [
          'A fund owned by two friends',
          'A collection of many stocks/bonds managed together',
          'A type of bank account for kids',
          'A loan from a family member',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s like a "basket" of investments that makes it easy for you to diversify with a small amount of money.',
        correctExplanation:
            'Mutual funds allow small investors to own a piece of hundreds of companies at once.',
      ),
      QuizQuestion(
        question:
            'Generally, what is the relationship between "Risk" and "Reward"?',
        options: [
          'Higher risk always means lower reward',
          'Higher potential reward usually requires taking on higher risk',
          'Risk and reward are not related',
          'Safe investments always pay the most',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If an investment were safe AND paid huge money, everyone would do it and the reward would drop. You must pay with risk for high gains.',
        correctExplanation:
            'This is the fundamental trade-off in finance. To grow fast, you must accept the chance of loss.',
      ),
      QuizQuestion(
        question: 'Which of these is a "Diversified" portfolio?',
        options: [
          'Owned 100% in one tech company',
          'Owned 100% in gold',
          'Owned across stocks, bonds, real estate, and cash',
          'Owned 100% in Bitcoin',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Owning 100% of any single category is risky. Mix it up to protect your wealth.',
        correctExplanation:
            'True diversification means owning different *asset classes* that don\'t all go down at the same time.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q13',
    title: 'Buying vs Leasing',
    subtitle: 'Ownership vs Renting',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What does it mean to "Lease" a car?',
        options: [
          'To buy it with a loan',
          'To pay to use it for a few years then return it (like a long-term rental)',
          'To borrow it from a friend',
          'To build the car yourself',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Leasing is not ownership. You are paying for the "use" and the "depreciation" while you have it.',
        correctExplanation:
            'Leasing often has lower monthly payments than buying, but you own nothing at the end.',
      ),
      QuizQuestion(
        question: 'What is a "Depreciating Asset"?',
        options: [
          'Something that grows in value over time',
          'Something that loses value over time (like a car or phone)',
          'A bank account that is locked',
          'A type of valuable gold',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Most physical things (cars, electronics) wear out or become old, so they depreciate (lose value).',
        correctExplanation:
            'Understanding depreciation helps you realize why some "assets" are actually money-losers.',
      ),
      QuizQuestion(
        question: 'When you "Buy" a home with a mortgage, you are building...',
        options: [
          'Rent debt',
          'Equity (your actual ownership value)',
          'A new road',
          'Nothing for yourself',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Part of every mortgage payment goes toward "owning" more of the house. This is called building equity.',
        correctExplanation:
            'Equity is the difference between the home\'s value and the loan balance. It is part of your Net Worth.',
      ),
      QuizQuestion(
        question: 'What is a major advantage of Renting/Leasing?',
        options: [
          'You build wealth every month',
          'You have more flexibility to move and fewer maintenance costs',
          'It is always cheaper in the long run',
          'You own the property eventually',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Renting doesn\'t build wealth, but it lets you leave easily and someone else pays if the roof leaks.',
        correctExplanation:
            'Leasing/Renting is often better for people who prioritize flexibility or don\'t have a down payment.',
      ),
      QuizQuestion(
        question:
            'Which of these usually helps your long-term Net Worth the most?',
        options: [
          'Leasing a new luxury car every 3 years',
          'Buying a used car and keeping it for 10 years',
          'Taking high-interest loans for clothes',
          'Renting indefinitely with no savings',
        ],
        correctIndex: 1,
        wrongExplanation:
            'New cars depreciate fastest. Keeping a reliable car and avoiding new car payments is a huge wealth builder.',
        correctExplanation:
            'Saving and investing the money you *don\'t* spend on luxury car leases is a key to financial freedom.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q14',
    title: 'Pay Yourself First',
    subtitle: 'The secret to consistent saving',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What does "Pay Yourself First" mean?',
        options: [
          'Buying yourself a gift as soon as you get paid',
          'Setting aside savings immediately before paying other bills or spending',
          'Only working for yourself instead of a boss',
          'Paying your own taxes directly',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s not about spending; it\'s about making your future "self" a priority by saving first.',
        correctExplanation:
            'By treating savings like a non-negotiable bill, you ensure your wealth grows before you spend the rest.',
      ),
      QuizQuestion(
        question:
            'Why is this more effective than saving "whatever is left over"?',
        options: [
          'Because usually there is nothing left over at the end of the month',
          'Because banks prefer it that way',
          'Because it is required by law',
          'It isn\'t, saving at the end is exactly the same',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Human nature is to spend what we have. If you save what\'s left, you will usually find reasons to spend it all.',
        correctExplanation:
            'Automatic savings at the start of the month remove the temptation to spend that money.',
      ),
      QuizQuestion(
        question: 'Where should "Pay Yourself First" money ideally go?',
        options: [
          'Into a checking account for shopping',
          'Into a high-yield savings or investment account',
          'Into a physical piggy bank at home',
          'To your friends',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Checking accounts are for spending. You want this money to grow where it is harder to spend on impulse.',
        correctExplanation:
            'Investing or saving in a separate account helps protect that money from being used for daily expenses.',
      ),
      QuizQuestion(
        question: 'If you "Pay Yourself Last," you are essentially...',
        options: [
          'Making yourself a priority',
          'Giving your money to everyone else first and hoping some is left',
          'Saving more money',
          'Avoiding taxes',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Landlords, grocers, and streaming services get paid first, and you only get what they didn\'t take.',
        correctExplanation:
            'Flipping the script ensures you build your own wealth before enriching others.',
      ),
      QuizQuestion(
        question:
            'Even saving 💎5 from every paycheck is better than 💎0 because...',
        options: [
          'It builds a powerful lifelong habit of saving',
          'You can buy a car with 💎5',
          'It lowers your rent',
          'The bank gives you a free gift',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The amount matters less than the HABIT. Once you start, it becomes easier to increase the amount later.',
        correctExplanation:
            'Habits are the foundation of wealth. Starting small is better than never starting.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q15',
    title: 'Understanding Insurance',
    subtitle: 'Managing life\'s big risks',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is the primary purpose of "Insurance"?',
        options: [
          'To make money from the bank',
          'To protect yourself from large financial losses you couldn\'t pay alone',
          'To get free repairs on old items',
          'To avoid following laws',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Insurance isn\'t for making profit; it\'s a safety net for when something expensive goes wrong.',
        correctExplanation:
            'By paying a small amount regularly, you transfer the risk of a huge bill to the insurance company.',
      ),
      QuizQuestion(
        question: 'What is an insurance "Premium"?',
        options: [
          'The amount you pay every month/year to keep the insurance active',
          'A special award for being a good driver',
          'The amount you pay when you have an accident',
          'The maximum amount the insurance will pay you',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The premium is the "subscription fee" for the protection provided.',
        correctExplanation:
            'You must pay your premium consistently, or your insurance coverage will stop.',
      ),
      QuizQuestion(
        question: 'What is a "Deductible"?',
        options: [
          'The part of a bill YOU must pay before the insurance covers the rest',
          'The money the insurance company pays you',
          'A type of discount for new customers',
          'The total value of your car',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If you have a 💎500 deductible and a 💎2000 repair, you pay 💎500 and the insurance pays 💎1500.',
        correctExplanation:
            'Higher deductibles usually mean lower monthly premiums, but higher costs if you have an accident.',
      ),
      QuizQuestion(
        question: 'Which of these is NOT a typical type of insurance?',
        options: [
          'Health Insurance',
          'Car Insurance',
          'Video Game Victory Insurance',
          'Life Insurance',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Insurance is for real-world financial risks like health, property, and life, not for fun/games.',
        correctExplanation:
            'Insurance focuses on high-impact events that would cause significant financial hardship.',
      ),
      QuizQuestion(
        question: 'Is insurance an "Investment"?',
        options: [
          'Yes, it always makes you money',
          'No, it is a risk management tool that costs money for protection',
          'Only if you have an accident',
          'It depends on the color of the car',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Ideally, you NEVER want to use your insurance! It is a cost you pay to avoid bankruptcy from a crisis.',
        correctExplanation:
            'Wealth is built through investments; wealth is *protected* through insurance.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q16',
    title: 'Retirement: Starting Early',
    subtitle: 'Planning for your future self',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is "Retirement"?',
        options: [
          'When you are too old to have fun',
          'When you stop working and live off your savings and investments',
          'A long vacation from school',
          'When you move to a different country',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Retirement is the stage of life where your "money works for you" so you don\'t have to.',
        correctExplanation:
            'The goal of retirement planning is to have enough wealth to maintain your lifestyle without a paycheck.',
      ),
      QuizQuestion(
        question: 'Why is starting at age 20 better than starting at age 40?',
        options: [
          'You have more time for compound interest to grow your money',
          'Young people get higher interest rates',
          'Older people aren\'t allowed to save',
          'There is no difference if you save the same total amount',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Time is the "engine" of compound interest. Doubling your time can quadruple your final wealth.',
        correctExplanation:
            'Starting early allows your early contributions to grow for decades, making it much easier to reach your goals.',
      ),
      QuizQuestion(
        question: 'What is a "Pension"?',
        options: [
          'A type of writing tool',
          'Regular payments from an employer or government after you retire',
          'A fee for being late to work',
          'Money you pay for insurance',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Pensions are becoming rare, but they act as a steady stream of income for retirees.',
        correctExplanation:
            'A pension is a fund into which a sum of money is added during an employee\'s employment years.',
      ),
      QuizQuestion(
        question: 'How does "Inflation" affect your retirement plan?',
        options: [
          'It makes things cheaper in the future',
          'It means you will need MORE money in the future to buy the same things',
          'It has no effect on retirement',
          'It doubles your savings automatically',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If 💎1 buys a loaf of bread today, it might cost 💎5 in the future. You must plan for rising costs.',
        correctExplanation:
            'Successful retirement planning must account for the decreasing purchasing power of money over time.',
      ),
      QuizQuestion(
        question: 'What is the "Biggest Factor" in growing a retirement fund?',
        options: [
          'Having a fancy bank',
          'TIME and consistency',
          'Winning the lottery once',
          'Only choosing the stock that goes up the most',
        ],
        correctIndex: 1,
        wrongExplanation:
            'You can\'t control the market, but you CAN control how early you start and how often you contribute.',
        correctExplanation:
            'Consistent investing over a long period is the most reliable path to a wealthy retirement.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q17',
    title: 'Unit Price Shopping',
    subtitle: 'Being a smart consumer',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is "Unit Price"?',
        options: [
          'The total price on the tag',
          'The cost per weight or volume (e.g., cost per ounce or per piece)',
          'The price of a single item in a pack',
          'A type of special discount',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Total price doesn\'t tell you the value. Unit price lets you compare different sizes fairly.',
        correctExplanation:
            'Understanding unit price helps you see which box of cereal or bottle of juice is actually the best deal.',
      ),
      QuizQuestion(
        question: 'Why is it helpful to check the unit price?',
        options: [
          'To see which color box is better',
          'To find which brand or size is actually the cheapest for the amount you get',
          'Because the store requires you to',
          'To help the store employees',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Big boxes are usually cheaper per ounce, but not ALWAYS. Unit price reveals the truth.',
        correctExplanation:
            'It prevents you from being tricked by "marketing" or "bulk" packaging that isn\'t actually a deal.',
      ),
      QuizQuestion(
        question:
            'If a 10oz box is 💎5 and a 20oz box is 💎8, which is the better value?',
        options: [
          'The 10oz box',
          'The 20oz box',
          'They are the same',
          'It is impossible to tell',
        ],
        correctIndex: 1,
        wrongExplanation:
            '10oz at 💎5 is 50c per oz. 20oz at 💎8 is 40c per oz. The bigger box is cheaper per unit.',
        correctExplanation:
            'In this case, the larger box saves you 10 cents on every ounce of the product.',
      ),
      QuizQuestion(
        question: 'Does "Bulk Pricing" always save you money?',
        options: [
          'Yes, big is always cheaper',
          'No, sometimes a smaller item on sale has a lower unit price',
          'Only at specific stores',
          'Bulk items are always better quality',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Always check the tag! A "Family Size" box can sometimes cost more per ounce than two regular boxes on sale.',
        correctExplanation:
            'Smart shoppers always compare the small unit price numbers on the shelf tags.',
      ),
      QuizQuestion(
        question: 'What is a "Marketing Trap" related to pricing?',
        options: [
          'Putting expensive items at eye level',
          'Using "Bulk Buy" signs for items that aren\'t actually cheaper',
          'Using the color red for "discounts"',
          'All of the above',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Stores use many tricks to make you spend. Unit pricing is your best tool to avoid them.',
        correctExplanation:
            'Being aware of how stores influence your choices helps you keep more of your own money.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q18',
    title: 'Fixed vs Variable Expenses',
    subtitle: 'Understanding your bills',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is a "Fixed Expense"?',
        options: [
          'An expense that changes every month',
          'An expense that stays the same every month (like rent or a phone plan)',
          'Something you only pay for once',
          'A broken item that needs fixing',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Fixed expenses are predictable. You know exactly how much they will cost ahead of time.',
        correctExplanation:
            'Monthly rent, car payments, and consistent subscriptions are examples of fixed expenses.',
      ),
      QuizQuestion(
        question: 'What is a "Variable Expense"?',
        options: [
          'An expense that stays the same',
          'An expense that changes depending on your choices (like groceries or gas)',
          'Money you find in the street',
          'A type of investment',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Variable expenses are harder to predict but easier to CONTROL and reduce.',
        correctExplanation:
            'Eating out, entertainment, and utility bills usually vary from month to month.',
      ),
      QuizQuestion(
        question:
            'If you need to save money quickly, which should you cut first?',
        options: [
          'Fixed expenses',
          'Variable expenses',
          'Your income',
          'Your taxes',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Fixed expenses (like rent) are hard to change quickly. Variable expenses (like snacks) can be cut today.',
        correctExplanation:
            'Reducing variable spending is the most effective way to improve your cash flow immediately.',
      ),
      QuizQuestion(
        question:
            'Is a gym membership (with a monthly contract) usually fixed or variable?',
        options: ['Fixed', 'Variable', 'Random', 'Optional'],
        correctIndex: 0,
        wrongExplanation:
            'If you pay the same 💎30 every month, it is a fixed expense, even if you don\'t go to the gym!',
        correctExplanation:
            'Contracted monthly services are almost always fixed expenses.',
      ),
      QuizQuestion(
        question:
            'Why are utility bills (like water and power) considered variable?',
        options: [
          'They stay the same every month',
          'The amount depends on how much water or power you use',
          'They aren\'t real expenses',
          'The government pays them',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you take shorter showers or turn off lights, the bill goes down. That makes it variable.',
        correctExplanation:
            'Variable expenses often give you the power to save money through more efficient habits.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q19',
    title: 'Financial Independence',
    subtitle: 'Reaching the ultimate goal',
    difficulty: QuizDifficulty.hard,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is "Financial Independence"?',
        options: [
          'Having a very high-paying job',
          'When your investment income covers all your living expenses',
          'Winning the lottery',
          'Never paying for anything again',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A job requires you to WORK. Independence means your MONEY does the work for you.',
        correctExplanation:
            'At this point, you choose to work because you want to, not because you have to pay the bills.',
      ),
      QuizQuestion(
        question: 'What is the "4% Rule" in retirement planning?',
        options: [
          'You should save 4% of your income',
          'A guideline for safely withdrawing 4% of your savings annually in retirement',
          'The interest rate of every bank',
          'The tax rate for millionaires',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s a strategy to ensure your money lasts for 30+ years by not taking too much out at once.',
        correctExplanation:
            'The 4% rule assumes that if you withdraw only 4%, your investments will likely grow enough to last forever.',
      ),
      QuizQuestion(
        question:
            'If you need 💎40,000 a year to live, how much savings do you need using the "4% Rule"?',
        options: ['💎400,000', '💎1,000,000', '💎2,000,000', '💎40,000'],
        correctIndex: 1,
        wrongExplanation:
            'Take your annual expenses and multiply by 25 (💎40k * 25 = 💎1M). 4% of 💎1M is 💎40k.',
        correctExplanation:
            'Reaching 💎1 Million in investments would allow you to withdraw 💎40,000 a year potentially forever.',
      ),
      QuizQuestion(
        question: 'Achieving financial independence early usually requires...',
        options: [
          'A high savings rate (saving 30-50% of income)',
          'Constant spending on luxury items',
          'Only saving in a checking account',
          'Pure luck',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The more of your income you save, the faster your "wealth snowballs" into independence.',
        correctExplanation:
            'By living below your means and investing the difference, you "buy" your future freedom.',
      ),
      QuizQuestion(
        question: 'What does the acronym "FIRE" stand for in finance?',
        options: [
          'Financial Independence, Retire Early',
          'Federal Income Revenue Exchange',
          'Fixed Interest Rate Earnings',
          'Funding Investment Real Estate',
        ],
        correctIndex: 0,
        wrongExplanation:
            'FIRE is a movement of people focused on reaching financial freedom as quickly as possible.',
        correctExplanation:
            'The core idea of FIRE is prioritize freedom and time over material possessions.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q20',
    title: 'Evaluating Business Ideas',
    subtitle: 'Thinking like an investor',
    difficulty: QuizDifficulty.hard,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is a business "Value Proposition"?',
        options: [
          'The price of the business',
          'The unique benefit or solution a business offers its customers',
          'The name of the company',
          'The location of the office',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It answers: "Why should a customer choose YOU over everyone else?"',
        correctExplanation:
            'A strong value proposition solves a specific problem or fulfills a specific need better than others.',
      ),
      QuizQuestion(
        question:
            'Why is "Market Research" critical before starting a business?',
        options: [
          'To find the cheapest office rent',
          'To see if enough people actually want to buy what you are selling',
          'To avoid paying taxes',
          'Market research is optional',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Even the best idea will fail if there are no customers willing to pay for it.',
        correctExplanation:
            'Understanding your audience and competition prevents you from wasting time and money on a product nobody wants.',
      ),
      QuizQuestion(
        question: 'What does "Scalability" mean for a business?',
        options: [
          'Fitting more people in an office',
          'The ability of a business to grow income much faster than its costs',
          'How many scales the company owns',
          'A type of fish business',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A scalable business (like software) can serve 1 million people almost as cheaply as 1,000 people.',
        correctExplanation:
            'Scalability is key to explosive growth and massive profitability in the long run.',
      ),
      QuizQuestion(
        question:
            'If a product costs 💎10 to make and sells for 💎12, what is the problem?',
        options: [
          'The price is too high',
          'The "Profit Margin" is too low to cover marketing and other hidden costs',
          'It is illegal to sell for 💎12',
          'There is no problem',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A 💎2 profit is very small. If it costs 💎3 to find a customer (marketing), you are losing money on every sale.',
        correctExplanation:
            'Healthy margins are necessary to cover the "overhead" costs of running a real business.',
      ),
      QuizQuestion(
        question: 'Successful businesses primarily focus on...',
        options: [
          'Solving a customer\'s problem or fulfilling a desire',
          'Having the coolest logo',
          'Taking as much money as possible from people',
          'Only hiring family members',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Money is a "result" of providing value. If you solve a problem, people will gladly pay you.',
        correctExplanation:
            'Focusing on the customer\'s needs is the most sustainable way to build a long-term business.',
      ),
    ],
  ),
];

final List<QuizMetadata> _level3Quizzes = [
  // Quiz 1-3: Easy (Level 3)
  QuizMetadata(
    id: 'l3_q1',
    title: 'Advanced Tax Concepts',
    subtitle: 'Understanding the systemic impact of taxes',
    difficulty: QuizDifficulty.easy,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is a "Progressive Tax" system?',
        options: [
          'Everyone pays the same percentage',
          'Higher income earners pay a higher percentage of their income in tax',
          'Tax that only applies to progress in school',
          'A tax that decreases as you earn more',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A progressive tax doesn\'t mean a flat rate. It means your tax rate increases as your income climbs into higher brackets.',
        correctExplanation:
            'In a progressive system, those with the "ability to pay" contribute a larger share of their earnings to support public services.',
      ),
      QuizQuestion(
        question: 'What is a "Tax Deduction"?',
        options: [
          'A penalty for paying taxes late',
          'An amount that reduces your total taxable income',
          'A special gift from the government',
          'The total amount of tax you owe',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s not a penalty or the final bill. It\'s a specific expense you can subtract from your income *before* the tax is calculated.',
        correctExplanation:
            'Deductions (like student loan interest or charitable gifts) lower the amount of income the government is allowed to tax.',
      ),
      QuizQuestion(
        question: 'What is the purpose of a "W-4 Form"?',
        options: [
          'To apply for a new job',
          'To tell your employer how much tax to withhold from your paycheck',
          'To file your year-end taxes',
          'To request a raise',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A W-4 isn\'t a job application or the final tax return. It is an internal document that determines your "withholding" amount.',
        correctExplanation:
            'Filling out a W-4 accurately ensures you don\'t owe a huge bill at the end of the year or give the government too much of your money for free.',
      ),
      QuizQuestion(
        question: 'What does "FICA" tax usually fund?',
        options: [
          'National Parks only',
          'Social Security and Medicare',
          'Military spending',
          'Space exploration',
        ],
        correctIndex: 1,
        wrongExplanation:
            'FICA is a specific payroll tax. While income tax goes to many things, FICA is strictly for retirement and health programs.',
        correctExplanation:
            'FICA contributions ensure that workers have a safety net for healthcare and income when they get older.',
      ),
      QuizQuestion(
        question: 'Why do some people receive a "Tax Refund"?',
        options: [
          'They won a government contest',
          'They overpaid their taxes throughout the year',
          'The government had extra money left over',
          'They didn\'t work enough',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A refund isn\'t "free money." It\'s just the government returning interest-free money that you accidentally overpaid.',
        correctExplanation:
            'Ideally, you want your withholding to be accurate so you don\'t give the government an interest-free loan all year.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q2',
    title: 'Credit vs. Debit Cards',
    subtitle: 'Choosing the right tool for payment',
    difficulty: QuizDifficulty.easy,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'When you use a "Debit Card," the money comes from...',
        options: [
          'A loan from the bank',
          'Your existing checking account balance',
          'Your future salary',
          'A central pool of gems',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Debit cards aren\'t loans. They are digital keys to money you *already* have in the bank.',
        correctExplanation:
            'Debit cards are great for staying out of debt because you can\'t spend more than you actually own.',
      ),
      QuizQuestion(
        question: 'When you use a "Credit Card," you are...',
        options: [
          'Spending your own money',
          'Taking a short-term loan from the bank',
          'Getting free items from the store',
          'Decreasing your debt',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It feels like your money, but it\'s the bank\'s money! You are promising to pay them back later, potentially with interest.',
        correctExplanation:
            'Credit cards offer convenience and protection, but they required discipline to avoid high-interest charges.',
      ),
      QuizQuestion(
        question:
            'Which card usually offers better "Fraud Protection" for shoppers?',
        options: [
          'Debit Card',
          'Credit Card',
          'Both are exactly the same',
          'Cash',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If a debit card is stolen, your actual cash is gone until the bank fixes it. With credit, the bank\'s money is at risk, not yours.',
        correctExplanation:
            'Credit cards have stronger legal protections, making it easier to cancel charges if you are scammed.',
      ),
      QuizQuestion(
        question: 'What is a "Credit Limit"?',
        options: [
          'The minimum you must spend',
          'The maximum amount the bank allows you to borrow on the card',
          'The number of cards you can own',
          'A time limit on your purchases',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s not about time or minimums. It\'s the "ceiling" of debt you are allowed to have at one time.',
        correctExplanation:
            'Keeping your balance well below your credit limit (low utilization) is a great way to boost your credit score.',
      ),
      QuizQuestion(
        question:
            'What happens if you only pay the "Minimum Balance" on a credit card?',
        options: [
          'You become debt-free quickly',
          'You pay a huge amount of interest and the debt lasts for years',
          'Nothing, it is the best strategy',
          'The bank gives you a bonus',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Paying the minimum is a trap. Most of that payment goes to interest, not the actual debt you owe.',
        correctExplanation:
            'Always aim to pay the "Full Balance" every month to use the bank\'s money for free!',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q3',
    title: 'Advanced Insurance',
    subtitle: 'Liability and Comprehensive coverage',
    difficulty: QuizDifficulty.easy,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What does "Liability Coverage" in car insurance pay for?',
        options: [
          'Repairs for your own car',
          'Damage or injuries YOU cause to OTHER people or their property',
          'Theft of your car',
          'A new car for you',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Liability is about your "legal responsibility" to others. It doesn\'t fix your own car at all.',
        correctExplanation:
            'Liability is usually required by law because it ensures you can pay for the mistakes you make on the road.',
      ),
      QuizQuestion(
        question: 'What is "Comprehensive Coverage"?',
        options: [
          'Insurance for everything in the world',
          'Protection against non-accident events like theft, fire, or weather damage',
          'A type of health insurance',
          'Insurance that only works on weekends',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Collision covers crashes. Comprehensive covers almost everything else that can happen to your car while it\'s parked.',
        correctExplanation:
            'If a tree falls on your car, "Comprehensive" is the coverage that saves your budget.',
      ),
      QuizQuestion(
        question:
            'Why might a 💎1,000 deductible be better than a 💎250 deductible?',
        options: [
          'It is cheaper when you have an accident',
          'It lowers your monthly premium (the regular cost of insurance)',
          'It means the insurance pays more',
          'It has no advantage',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A higher deductible is more "risk" for you, so the insurance company rewards you with a lower monthly bill.',
        correctExplanation:
            'If you have an emergency fund of 💎1,000, choosing a higher deductible can save you hundreds of gems per year.',
      ),
      QuizQuestion(
        question: 'What is "Disability Insurance"?',
        options: [
          'Insurance for your car',
          'Insurance that replaces part of your income if you are too sick or injured to work',
          'Insurance for old people only',
          'A type of life insurance',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Health insurance pays the doctor. Disability insurance pays YOUR bills (rent, food) while you can\'t work.',
        correctExplanation:
            'Many experts call this the most important insurance because it protects your "greatest asset": your ability to earn money.',
      ),
      QuizQuestion(
        question: 'An insurance "Claim" is...',
        options: [
          'A request to the insurance company to pay for a loss',
          'The amount you pay every month',
          'A type of bank account',
          'The total value of your home',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Monthly pay is the "Premium." A "Claim" is when you actually ask for the money back after something goes wrong.',
        correctExplanation:
            'Filing a claim starts the process of the insurance company evaluating and paying for a covered loss.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q4',
    title: 'Compound Interest Mastery',
    subtitle: 'The math of geometric growth',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is the "Rule of 72" used for?',
        options: [
          'Estimating how long it takes for an investment to double',
          'Calculating your total tax debt',
          'Determining the price of a house',
          'Finding the best interest rate at a bank',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The Rule of 72 is a mental shortcut for growth. Divide 72 by the annual interest rate to find the years until your gems double.',
        correctExplanation:
            'For example, at a 10% return, your 💎1,000 becomes 💎2,000 in about 7.2 years (72 / 10).',
      ),
      QuizQuestion(
        question:
            'Compound interest is often called the "Eighth Wonder of the World" because...',
        options: [
          'It is very old',
          'It allows you to earn interest on your previous interest',
          'Only seven other things are better',
          'It is required by law for all accounts',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Simple interest only pays on the principal. Compound interest pays on the principal PLUS the accumulated growth!',
        correctExplanation:
            'Over decades, compounding can turn small monthly savings into massive piles of gems.',
      ),
      QuizQuestion(
        question:
            'Which factor has the BIGGEST impact on compound interest growth?',
        options: [
          'The initial amount of gems',
          'The number of years the money stays invested',
          'The color of your bank card',
          'The name of the investment',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Starting with more gems helps, but "time" is the multiplier. Starting 10 years earlier is often worth more than saving 💎10,000 later.',
        correctExplanation:
            'Time allows the exponential curve of compounding to really take off.',
      ),
      QuizQuestion(
        question: 'What is the "APY" (Annual Percentage Yield)?',
        options: [
          'The name of a bank',
          'The real interest rate you earn including compounding',
          'A penalty for early withdrawal',
          'The total gems in your account',
        ],
        correctIndex: 1,
        wrongExplanation:
            'APR is the basic rate. APY accounts for how often the interest is added (daily, monthly), giving you the TRUE return.',
        correctExplanation:
            'Always compare APY when choosing where to store your gems to see who is actually paying you more.',
      ),
      QuizQuestion(
        question: 'Inflation is the "enemy" of compound interest because...',
        options: [
          'It makes the bank close',
          'It reduces the "purchasing power" of the gems you earn',
          'It increases your tax rate',
          'It stops the math from working',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If your interest is 5% but inflation is 3%, your "real" growth is only 2%. You have more gems, but they buy less bread.',
        correctExplanation:
            'To build true wealth, your investments must grow significantly faster than the rate of inflation.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q5',
    title: 'The Stock Market',
    subtitle: 'Owning a piece of the economy',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What actually IS a "Share of Stock"?',
        options: [
          'A loan to a company',
          'A certificate of partial ownership in a corporation',
          'A type of lottery ticket',
          'A promise of free products',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Bonds are loans. Stocks are equity. If you own 100 shares, you actually own a tiny piece of the company\'s buildings, ideas, and profits.',
        correctExplanation:
            'As the company grows and becomes more valuable, your piece of the pie (the share price) usually goes up.',
      ),
      QuizQuestion(
        question: 'What are "Dividends"?',
        options: [
          'Fees you pay to a stockbroker',
          'A portion of a company\'s profit paid out to stockholders',
          'The price of a share',
          'A type of company debt',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Dividends aren\'t fees or prices. They are a "thank you" check sent to owners when the company made good profit.',
        correctExplanation:
            'Many investors use dividends to buy even more shares, further accelerating their compound growth.',
      ),
      QuizQuestion(
        question: 'What does a "Diversified Portfolio" mean?',
        options: [
          'Buying only one very expensive stock',
          'Spreading your gems across many different types of companies and industries',
          'Selling all your stocks every day',
          'Investing only in your local town',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Putting all your 💎10,000 into one company is like putting all your eggs in one basket. If that company fails, you lose everything.',
        correctExplanation:
            'Diversity protects you. If tech stocks go down but energy stocks go up, your total wealth stays stable.',
      ),
      QuizQuestion(
        question: 'What is a "Market Index" (like the S&P 500)?',
        options: [
          'A list of the best prices in town',
          'A tool that tracks the performance of a specific group of stocks',
          'The name of the main stock exchange',
          'A tax on stock market gains',
        ],
        correctIndex: 1,
        wrongExplanation:
            'An index isn\'t a stock itself. It\'s a "scoreboard" that tells you how the overall market is doing.',
        correctExplanation:
            'Many successful investors simply buy "Index Funds" that track these scores rather than trying to pick individual winners.',
      ),
      QuizQuestion(
        question: 'A "Bear Market" occurs when...',
        options: [
          'Stock prices are rising rapidly',
          'Stock prices have fallen by 20% or more over a period of time',
          'Bears start working at the stock exchange',
          'Companies are giving out free gems',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Bulls charge up (rising prices). Bears swipe down (falling prices). It describes the "mood" of the market.',
        correctExplanation:
            'Bear markets can be scary, but for long-term investors, they can be a great time to buy shares at a "discount."',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q6',
    title: 'Bonds and Fixed Income',
    subtitle: 'Lending your gems for profit',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is a "Bond" in the financial world?',
        options: [
          'An agreement to work for a company',
          'An I.O.U. where you lend gems to a government or corporation for interest',
          'A type of insurance policy',
          'A permanent partnership',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Shares make you an owner. Bonds make you a "Lender." You give them gems now, and they promise to pay them back with interest.',
        correctExplanation:
            'Bonds are generally considered safer than stocks, but they usually offer lower potential growth.',
      ),
      QuizQuestion(
        question: 'What is the "Coupon Rate" of a bond?',
        options: [
          'A discount on local groceries',
          'The fixed interest rate the bond issuer pays to the lender',
          'The price of the bond',
          'The date the bond expires',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s named after old paper bonds that had physical coupons you clipped to get paid. It\'s just your interest rate.',
        correctExplanation:
            'If you buy a 💎1,000 bond with a 5% coupon, you get 💎50 every year until the bond matures.',
      ),
      QuizQuestion(
        question: 'What is "Maturity Date"?',
        options: [
          'The day you are old enough to invest',
          'The date the borrower must pay back the full original loan amount',
          'The day the company was founded',
          'The best day to sell a stock',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Maturity isn\'t about your age. It\'s the "end of the contract" for a bond.',
        correctExplanation:
            'On the maturity date, the company gives you back your initial 💎1,000 and the contract is finished.',
      ),
      QuizQuestion(
        question: 'Which bond is typically considered the SAFEST?',
        options: [
          'Corporate Bond from a new startup',
          'U.S. Treasury Bond',
          'International Bond from a small country',
          'Bond from an amusement park',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Startups can go broke. Small countries can have trouble. The U.S. government has the strongest history of paying its debts.',
        correctExplanation:
            'Because they are so safe, Treasury bonds often have the lowest interest rates in the whole market.',
      ),
      QuizQuestion(
        question: 'What is a "Municipal Bond"?',
        options: [
          'A bond issued by a city or state to fund public projects',
          'A bond used to buy a new car',
          'A bond for private individuals only',
          'A bond that never pays interest',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Municipalities are local governments. They use these bonds to build schools, bridges, and parks in your town.',
        correctExplanation:
            'A special benefit of "Munis" is that the interest you earn is often tax-free!',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q7',
    title: 'Mutual Funds & ETFs',
    subtitle: 'Group investing made easy',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is an "Index Fund"?',
        options: [
          'A list of the most expensive companies',
          'A type of mutual fund or ETF designed to track the performance of a specific market index',
          'A fund that only invests in index cards',
          'A government savings bond',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It isn\'t just a list. It\'s a "passive" investment that buys every company in an index (like the S&P 500) so you can match the market\'s growth.',
        correctExplanation:
            'Index funds are famous for having the lowest fees (expense ratios) because they don\'t need expensive managers to pick stocks.',
      ),
      QuizQuestion(
        question: 'What does "ETF" stand for?',
        options: [
          'Electronic Total Fund',
          'Exchange-Traded Fund',
          'Easy Tax Filing',
          'Every Trading Friday',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The name is the clue: it\'s a fund that is traded on a stock "Exchange," just like an individual stock.',
        correctExplanation:
            'ETFs are very popular because they usually have lower fees than traditional mutual funds.',
      ),
      QuizQuestion(
        question: 'What is an "Expense Ratio"?',
        options: [
          'The percentage of your investment taken each year for management fees',
          'The total gems you spend on lunch',
          'The ratio of your debt to your income',
          'The cost of buying a single share',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Investing isn\'t free! The people running the fund take a small cut (like 0.1% or 1%) to pay for their office and work.',
        correctExplanation:
            'Choosing a fund with a LOW expense ratio can save you tens of thousands of gems over your lifetime.',
      ),
      QuizQuestion(
        question: 'What is "Dollar-Cost Averaging" (DCA)?',
        options: [
          'Trying to buy only when prices are the lowest',
          'Investing a fixed amount of gems at regular intervals, regardless of price',
          'Trading one currency for another',
          'Calculating the average price of a house',
        ],
        correctIndex: 1,
        wrongExplanation:
            'DCA removes the stress of "timing the market." You buy more shares when prices are low and fewer when they are high.',
        correctExplanation:
            'This is a proven strategy for long-term wealth because it forces you to keep saving through both good and bad times.',
      ),
      QuizQuestion(
        question:
            'The primary advantage of Index Funds over Active Funds is...',
        options: [
          'They always have higher returns',
          'They have much lower fees and generally better long-term performance',
          'They are only for rich people',
          'They are guaranteed by the government',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Active managers try to "beat" the market but often fail. Index funds just "be" the market for a very low cost.',
        correctExplanation:
            'By keeping fees low, more of your gems stay in your account to compound over time.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q8',
    title: 'Mastering Credit Scores',
    subtitle: 'Your financial reputation',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is a "FICO Score"?',
        options: [
          'The secret name of a bank',
          'A three-digit number representing your creditworthiness',
          'A grade in your economics class',
          'The total gems you have in savings',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s like a "grade point average" for how you handle borrowed money. Scores range from 300 to 850.',
        correctExplanation:
            'A high score (700+) proves to banks that you are a safe person to lend gems to.',
      ),
      QuizQuestion(
        question: 'Which factor has the LARGEST impact on your credit score?',
        options: [
          'How much money you earn',
          'Payment History (paying bills on time)',
          'The number of cards you own',
          'The type of car you drive',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Surprise! You can earn 💎1 Million a year and still have a bad score if you forget to pay your 💎50 phone bill.',
        correctExplanation:
            'One single late payment can stay on your record for 7 years and drop your score significantly.',
      ),
      QuizQuestion(
        question: 'What is "Credit Utilization"?',
        options: [
          'The amount of time you spend using a card',
          'The percentage of your total available credit that you are currently using',
          'The total number of loans you have',
          'Paying for things with cash',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If your limit is 💎1,000 and you owe 💎900, your utilization is 90%. Banks hate this; it looks like you are struggling.',
        correctExplanation:
            'Financial experts suggest keeping your utilization below 30% to maintain a high score.',
      ),
      QuizQuestion(
        question: 'Why does "Length of Credit History" matter?',
        options: [
          'It doesn\'t matter at all',
          'It shows the bank you have long-term experience managing debt',
          'It determines your retirement age',
          'It makes the card look cooler',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A person who has credit for 10 years is more "predictable" than someone who just started 2 months ago.',
        correctExplanation:
            'This is why it is often smart to keep your oldest credit card open, even if you don\'t use it often.',
      ),
      QuizQuestion(
        question: 'Hard inquiries (checking your credit for a new loan) can...',
        options: [
          'Raise your score',
          'Slightly lower your score for a short period',
          'Make your score disappear',
          'Give you a tax refund',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Applying for 10 credit cards in one week makes you look "desperate" for gems, which scares the bank.',
        correctExplanation:
            'Only apply for credit when you actually need it to avoid unnecessary "dips" in your score.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q9',
    title: 'Real Estate & Mortgages',
    subtitle: 'Buying your first home',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is a "Mortgage"?',
        options: [
          'A monthly fee for renting',
          'A long-term loan specifically used for buying real estate',
          'A type of home insurance',
          'The total cost of a house',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Rent is for space someone else owns. A mortgage is a loan you use to eventually own the space yourself.',
        correctExplanation:
            'Mortgages allow you to buy a 💎500,000 house without having all the gems upfront. The house itself acts as "collateral" for the loan.',
      ),
      QuizQuestion(
        question: 'What is the "Down Payment" on a house?',
        options: [
          'The final payment of the loan',
          'The upfront gems you pay out of pocket before the mortgage starts',
          'A fee for moving in',
          'The monthly interest rate',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s the "initial" payment. Usually, banks want you to pay 5% to 20% of the home price in cash (gems) at the very start.',
        correctExplanation:
            'A larger down payment means you borrow fewer gems, which lowers your monthly interest costs.',
      ),
      QuizQuestion(
        question: 'What is a "Fixed-Rate Mortgage"?',
        options: [
          'A loan where the interest rate stays the same for the entire life of the loan',
          'A loan where the price of the house is fixed',
          'A loan that must be paid in 5 years',
          'A loan that changes interest rates every month',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Adjustable rates (ARM) change with the market. Fixed rates stay identical from the first day to the last, providing stability.',
        correctExplanation:
            'If you have a 30-year fixed mortgage at 4%, your interest rate will still be 4% even if the market rate jumps to 10% later.',
      ),
      QuizQuestion(
        question: 'What is "Escrow" in home ownership?',
        options: [
          'The name of the front door key',
          'An account where gems are held to pay for property taxes and home insurance',
          'A legal way to avoid paying rent',
          'The total square footage of the backyard',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s a "holding pen" for gems. Every month, you pay a bit extra to the bank, and they use it to pay your big annual tax and insurance bills for you.',
        correctExplanation:
            'Escrow ensures that your vital bills (like taxes) are always paid on time so you don\'t lose your home.',
      ),
      QuizQuestion(
        question: 'What is "Equity"?',
        options: [
          'The total gems you still owe the bank',
          'The difference between the market value of your home and the amount you still owe on your mortgage',
          'The number of rooms in your house',
          'A monthly maintenance fee',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Debt is what the bank owns. Equity is what YOU own. If your house is worth 💎300k and you owe 💎200k, your equity is 💎100k.',
        correctExplanation:
            'Building equity is one of the most powerful ways for families to build wealth over a long period of time.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q10',
    title: 'Advanced Automobile Finance',
    subtitle: 'Managing the costs of driving',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is "Depreciation" in cars?',
        options: [
          'The increase in value over time',
          'The rapid decrease in value as a car gets older and used',
          'The cost of gasoline',
          'The interest rate on a car loan',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Most cars aren\'t investments. They lose value the moment you drive them off the lot. A 💎30,000 new car might only be worth 💎15,000 in 5 years.',
        correctExplanation:
            'Understanding depreciation is why many smart savers choose to buy slightly "used" cars rather than brand-new ones.',
      ),
      QuizQuestion(
        question: 'What is a "Lease" for a car?',
        options: [
          'A loan where you eventually own the car',
          'A long-term rental agreement where you pay to use the car but don\'t own it',
          'An insurance policy for tires',
          'A gift from the car dealership',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Leasing is like renting. You get a new car for a lower monthly cost, but after 3 years, you have to give it back and have zero equity.',
        correctExplanation:
            'Leasing can be good for people who want a new car every few years, but it is generally more expensive than owning in the long run.',
      ),
      QuizQuestion(
        question: 'What is "Collision Coverage"?',
        options: [
          'Insurance that pays to fix YOUR car after an accident you cause',
          'Insurance that only pays for other people\'s cars',
          'Insurance that covers theft only',
          'Insurance that makes accidents impossible',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Liability (already learned) pays for the OTHER guy. Collision is what pays to fix YOUR shiny car.',
        correctExplanation:
            'If your car is old and worth very little, you might choose to cancel collision coverage to save gems every month.',
      ),
      QuizQuestion(
        question: 'What is a "Balloon Payment"?',
        options: [
          'A party favor given at the bank',
          'A large, final payment due at the end of some car or home loans',
          'A fee for inflating your tires',
          'A gift from the government',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Balloon payments are risky! They make your monthly bills look low, but then you suddenly owe 💎10,000 all at once at the very end.',
        correctExplanation:
            'Many people are forced into debt because they wasn\'t prepared for a massive balloon payment.',
      ),
      QuizQuestion(
        question:
            'Why is a 60-month car loan often worse than a 36-month loan?',
        options: [
          'The monthly payments are higher',
          'You pay much more in total interest over the longer time',
          'The car becomes illegal after 3 years',
          'The 36-month loan is more expensive in total gems',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Longer loans have lower "monthly" bills, which tricks people. But because you are borrowing for longer, the bank earns way more gems from you.',
        correctExplanation:
            'Always calculate the "Total Cost" (Monthly payment * Number of months) when choosing a loan.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q11',
    title: 'Health & Life Insurance',
    subtitle: 'Protecting your health and family',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is a "Premium"?',
        options: [
          'A special high-quality insurance',
          'The regular amount you pay (usually monthly) to keep your insurance active',
          'The amount you pay when you have a car crash',
          'A reward for not getting sick',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The deductible is paid when a problem happens. The premium is the "subscription fee" you pay even when everything is perfect.',
        correctExplanation:
            'If you stop paying your premium, your insurance coverage disappears instantly.',
      ),
      QuizQuestion(
        question: 'What is a "Co-pay"?',
        options: [
          'A payment made by your friend',
          'A small, fixed-gem amount you pay for a specific service, like a doctor visit',
          'The total cost of a surgery',
          'The amount the insurance company owes you',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s a flat fee. For example, your insurance might cover the whole 💎200 checkup, but you are required to pay a 💎20 co-pay at the front desk.',
        correctExplanation:
            'Co-pays make you "share the cost" so that people don\'t go to the doctor for every tiny scratch.',
      ),
      QuizQuestion(
        question: 'What is "Term Life Insurance"?',
        options: [
          'Insurance that lasts your entire life',
          'Insurance that pays a set amount to your family if you die within a specific time (term)',
          'Insurance for your furniture',
          'Insurance that only works during your school term',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Term insurance is simple and cheap. It acts like a safety net for your kids or spouse while they need your income to live.',
        correctExplanation:
            'Once the "term" (e.g., 20 years) is over, the insurance ends. It is usually the best choice for most young families.',
      ),
      QuizQuestion(
        question: 'What is an "Umbrella Policy"?',
        options: [
          'Insurance specifically for rain damage',
          'Extra liability insurance that protects you beyond your basic car or home policies',
          'A policy that covers your summer vacation',
          'Insurance for your business partner',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Think of a real umbrella—it covers everything underneath it. If you are sued for 💎1 Million but your car insurance only covers 💎300k, the umbrella pays the rest.',
        correctExplanation:
            'Umbrella policies are very cheap ways to protect your total net worth from rare but massive disasters.',
      ),
      QuizQuestion(
        question: 'What is a "Pre-existing Condition"?',
        options: [
          'A health problem you already had before your new insurance started',
          'A condition of your car before you bought it',
          'A requirement to pay your bills on time',
          'A type of emergency fund',
        ],
        correctIndex: 0,
        wrongExplanation:
            'In the past, insurance companies could refuse to help you if you were already sick. New laws in many places now require them to cover everyone.',
        correctExplanation:
            'Knowing how these conditions are handled is vital when you are choosing between different health plans.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q12',
    title: 'Retirement Foundations',
    subtitle: 'Planning for your 80-year-old self',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is a "401(k)" plan?',
        options: [
          'A type of bank savings account',
          'A retirement savings plan offered by an employer that often includes matching gems',
          'The total gems you need to retire',
          'A government tax form',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s an investment account, not just savings. The gems are taken from your paycheck *before* taxes, which is a huge benefit.',
        correctExplanation:
            'Many companies offer a "Match." If you put in 💎1, they give you 💎1 for free! This is a 100% return on your gems instantly.',
      ),
      QuizQuestion(
        question: 'What does "Vesting" mean?',
        options: [
          'The right to keep all the gems your employer contributed to your retirement account',
          'Buying a new suit for work',
          'Investing in the stock market',
          'Paying your monthly insurance premium',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Employers want you to stay! They might say you are "fully vested" after 3 years. If you leave sooner, they take back their matching gems.',
        correctExplanation:
            'Knowing your "Vesting Schedule" is very important before you decide to quit a job.',
      ),
      QuizQuestion(
        question: 'What is a "Traditional IRA"?',
        options: [
          'A savings account with no taxes',
          'An Individual Retirement Account where you get a tax break NOW, but pay taxes when you withdraw later',
          'A retirement account for groups only',
          'A way to avoid the stock market',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Traditional = Tax-deferred. You save 💎30 in taxes today for every 💎100 you save for the future.',
        correctExplanation:
            'IRAs are great because YOU control the account, even if you change jobs 20 different times.',
      ),
      QuizQuestion(
        question: 'What is the special benefit of a "Roth IRA"?',
        options: [
          'You get a tax break now',
          'Your gems grow and are withdrawn 100% TAX-FREE in retirement',
          'The government gives you free gems',
          'It has no special benefits',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Roth = Tax-free later. You pay the tax today, but you never pay a single gem to the government on the growth ever again.',
        correctExplanation:
            'If your 💎5,000 grows into 💎50,000 inside a Roth IRA, you keep all 💎50,000 for your retirement.',
      ),
      QuizQuestion(
        question:
            'At what age can you usually withdraw retirement funds without a "10% Penalty"?',
        options: ['18', '59.5', '100', 'Anytime you want'],
        correctIndex: 1,
        wrongExplanation:
            'Retirement accounts have strict rules! If you take the gems out at age 30 to buy a fancy car, the government takes a huge 10% penalty plus taxes.',
        correctExplanation:
            'These rules exist to "force" you to leave your wealth alone so it has time to compound for 40+ years.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q13',
    title: 'Economic Indicators',
    subtitle: 'Reading the pulse of the country',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is "GDP" (Gross Domestic Product)?',
        options: [
          'The total gems in the national bank',
          'The total value of all goods and services produced in a country in one year',
          'The price of food at the grocery store',
          'The number of people who have jobs',
        ],
        correctIndex: 1,
        wrongExplanation:
            'GDP is like the "National Paycheck." If GDP is growing, the economy is healthy and people are providing more value to each other.',
        correctExplanation:
            'When GDP shrinks for several months in a row, it usually signals a "Recession" is coming.',
      ),
      QuizQuestion(
        question: 'What does the "CPI" (Consumer Price Index) measure?',
        options: [
          'The total number of consumers',
          'The average change in price for a "basket" of common goods (inflation)',
          'The profit of large corporations',
          'The interest rate at the bank',
        ],
        correctIndex: 1,
        wrongExplanation:
            'CPI tracks the prices of eggs, milk, gas, and rent. It tells us how much the cost of living has changed.',
        correctExplanation:
            'If the CPI is up 6% from last year, your 💎100 only has the purchasing power that 💎94 had before.',
      ),
      QuizQuestion(
        question: 'What is the "Federal Reserve"?',
        options: [
          'The place where all gems are stored',
          'The central bank of the U.S. that controls interest rates and money supply',
          'A department that collects taxes',
          'A type of military base',
        ],
        correctIndex: 1,
        wrongExplanation:
            'They are the "Bank for the Banks." They raise interest rates to slow down inflation or lower them to help the economy grow.',
        correctExplanation:
            'Decisions made by the Federal Reserve impact your car loan, mortgage, and savings account interest rates.',
      ),
      QuizQuestion(
        question: 'What is "Unemployment Rate"?',
        options: [
          'The percentage of everyone who doesn\'t have a job',
          'The percentage of people who WANT to work but currently don\'t have a job',
          'The total number of people in the country',
          'A tax paid by workers',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It doesn\'t count children or retired people. It only tracks adults who are actively looking for a job.',
        correctExplanation:
            'A low unemployment rate means the economy is strong and companies are competing for workers.',
      ),
      QuizQuestion(
        question: 'What is a "Trade Deficit"?',
        options: [
          'When a country buys (imports) more from others than it sells (exports)',
          'When a country has zero gems left',
          'A law that stops trading',
          'A type of bank robbery',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Imports = Buying from neighbors. Exports = Selling to neighbors. A deficit means more gems are leaving the country than coming in.',
        correctExplanation:
            'Trade deficits aren\'t always bad, but they can impact the value of a country\'s currency and its manufacturing jobs.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q14',
    title: 'Identity Theft Protection',
    subtitle: 'Securing your digital wealth',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is "Ransomware"?',
        options: [
          'A reward for finding a lost pet',
          'Malware that locks your files or device and demands gems to unlock them',
          'A type of very expensive software',
          'A way to donate gems to charity',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It isn\'t a reward or a donation. It\'s "digital kidnapping." The criminal holds your data hostage until you pay a "ransom."',
        correctExplanation:
            'The best defense against ransomware is having regular "Offline Backups" of your important files and gems.',
      ),
      QuizQuestion(
        question: 'What should you do if you suspect "Identity Theft"?',
        options: [
          'Wait and see if it stops',
          'Contact your bank and place a "Credit Freeze" on your accounts',
          'Delete all your social media',
          'Tell your friends but do nothing else',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Waiting is the worst thing you can do. Every hour you wait, the criminal can borrow more gems in your name.',
        correctExplanation:
            'A credit freeze stops anyone (including you) from opening new soul-crushing debts in your name until you unlock it.',
      ),
      QuizQuestion(
        question: 'What is "Two-Factor Authentication" (2FA)?',
        options: [
          'A way to pay two bills at once',
          'Using two different security steps (like a password AND a code from your phone) to log in',
          'Having two bank accounts',
          'A type of very expensive lock',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s not about two accounts. It\'s about "two proofs" that you are who you say you are. This stops 99% of hackers.',
        correctExplanation:
            'Even if a hacker steals your password, they can\'t get in without the secret code sent to your physical device.',
      ),
      QuizQuestion(
        question:
            'How often are you legally entitled to a FREE credit report from each bureau?',
        options: [
          'Once every 10 years',
          'Once every 12 months',
          'Only when you are buying a house',
          'Never, you always have to pay',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Don\'t pay for what is free! You can use AnnualCreditReport.com to check for errors or fake accounts once a year for free.',
        correctExplanation:
            'Monitoring your report is the best way to spot identity theft before it destroys your credit score.',
      ),
      QuizQuestion(
        question: 'Why is it dangerous to use public Wi-Fi for your bank app?',
        options: [
          'It is too slow',
          'Hackers can "sniff" the data being sent between your phone and the bank',
          'The battery will die faster',
          'It costs extra gems to use',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Speed isn\'t the issue. Public Wi-Fi has no walls. Someone sitting in the same coffee shop could see everything you type.',
        correctExplanation:
            'Always use your phone\'s cellular data (5G/LTE) or a VPN when handling your gems in public.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q15',
    title: 'Estate Planning Basics',
    subtitle: 'Leaving a legacy',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is a "Will"?',
        options: [
          'A person\'s name',
          'A legal document that explains how you want your wealth and property distributed after you die',
          'A plan for your next vacation',
          'A type of savings account',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s not just a wish; it\'s a legal map. Without a will, the government (the court) decides who gets your gems.',
        correctExplanation:
            'Having a will ensures that your family is taken care of according to your specific wishes.',
      ),
      QuizQuestion(
        question: 'What is an "Executor"?',
        options: [
          'A person who carries out the instructions in a will',
          'A professional athlete',
          'A type of expensive lawyer',
          'The person who gets all the money',
        ],
        correctIndex: 0,
        wrongExplanation:
            'They aren\'t the "heir." They are the "manager." They do the hard work of paying bills and giving gems to the right people.',
        correctExplanation:
            'Choose an executor you trust completely, as they handle your entire life\'s work after you are gone.',
      ),
      QuizQuestion(
        question: 'What is a "Trust"?',
        options: [
          'Just being a nice person',
          'A legal arrangement where a third party (trustee) holds assets for a beneficiary',
          'A type of bank loan',
          'A secret password',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s more than a feeling. It\'s a "legal bucket." You put your gems in the bucket with strict rules on when people can take them out.',
        correctExplanation:
            'Trusts can help families avoid "Probate" (a long, expensive court process) and reduce death taxes.',
      ),
      QuizQuestion(
        question: 'What is a "Power of Attorney"?',
        options: [
          'The right to be a lawyer',
          'A document that gives someone else the power to make financial or medical decisions for you',
          'A type of very strong battery',
          'A requirement to join the military',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s about "agency." If you are in a coma or have a bad accident, this person can pay your rent and talk to your doctors for you.',
        correctExplanation:
            'This is a vital part of planning for emergencies at any age, not just for old people.',
      ),
      QuizQuestion(
        question:
            'The people who receive assets from a will or insurance are called...',
        options: ['Executors', 'Beneficiaries', 'Trustees', 'Policyholders'],
        correctIndex: 1,
        wrongExplanation:
            'An executor works. A trustee guards. A "Beneficiary" is the one who receives the "benefit" (the gems).',
        correctExplanation:
            'Always keep your beneficiary designations updated on your bank and insurance accounts!',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q16',
    title: 'College & Education Funding',
    subtitle: 'Investing in your brain',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is a "529 Plan"?',
        options: [
          'A plan to work 5 days and save 29 gems',
          'A tax-advantaged savings account specifically for education costs',
          'A type of credit card for students',
          'A government scholarship program',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s an investment account like a 401k, but for school. The gems grow tax-free if you use them for tuition, books, or room and board.',
        correctExplanation:
            'Starting a 529 plan when a child is born can turn a small amount into a full college degree through decades of compounding.',
      ),
      QuizQuestion(
        question: 'What is the "FAFSA"?',
        options: [
          'A type of fast food',
          'The "Free Application for Federal Student Aid"',
          'A law that makes college free',
          'A student loan company',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It isn\'t the loan itself. It\'s the "entrance form." You must fill it out to see if the government will give you grants or low-interest loans.',
        correctExplanation:
            'Almost every college student should fill out the FAFSA every year to find the most affordable way to study.',
      ),
      QuizQuestion(
        question: 'What is a "Student Loan Subsidized" by the government?',
        options: [
          'A loan that never has to be repaid',
          'A loan where the government pays the interest while you are in school',
          'A loan for rich people only',
          'A loan that must be paid back in one year',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Subsidized = Help! The government "subsidizes" the interest so your debt doesn\'t grow while you are busy studying.',
        correctExplanation:
            'These are the best types of student loans because they are much cheaper than private bank loans.',
      ),
      QuizQuestion(
        question: 'What is a "Grant"?',
        options: [
          'Money for college that NEVER has to be paid back',
          'A loan with 0% interest',
          'A person\'s name',
          'A type of university building',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Loans are borrowed. Grants are "gifted." Usually, they are given based on financial need.',
        correctExplanation:
            'Winning grants is the "holy grail" of education funding because they have zero cost to you.',
      ),
      QuizQuestion(
        question:
            'Why is "Average Starting Salary" important when choosing a degree?',
        options: [
          'It isn\'t important at all',
          'It helps you determine if the cost of the degree is a good investment',
          'It tells you how many hours you will work',
          'It determines your retirement date',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If a degree costs 💎100,000 but you only earn 💎30,000 a year, you will be in debt forever. The "ROI" (Return on Investment) is low.',
        correctExplanation:
            'Treating your education as an investment helps you make smarter choices about how many gems to borrow.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q17',
    title: 'Advanced Budgeting Rules',
    subtitle: 'The 50/30/20 lifestyle',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'In the "50/30/20 Rule," what does the 50% stand for?',
        options: [
          'Wants and fun',
          'Needs (Rent, Groceries, Utilities)',
          'Savings and Debt',
          'Taxes',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Needs = Survival. Half of your net income should cover the absolute basics. If it\'s higher, your lifestyle is too expensive!',
        correctExplanation:
            'Keeping needs at 50% leaves plenty of room for both fun and future building.',
      ),
      QuizQuestion(
        question: 'In the "50/30/20 Rule," what does the 30% represent?',
        options: [
          'Savings',
          'Wants (Hobbies, Dining out, Subscriptions)',
          'Insurance',
          'Gifts',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Wants = Lifestyle. This is the 30% that makes life enjoyable. If you cut this to zero, you might get "budget burnout."',
        correctExplanation:
            'The key to being rich isn\'t suffering—it\'s making sure your "fun" stays within its 30% boundary.',
      ),
      QuizQuestion(
        question: 'In the "50/30/20 Rule," what is the most important 20%?',
        options: [
          'Clothing',
          'Financial Priorities (Savings, Investing, Extra debt payments)',
          'Vacations',
          'Car maintenance',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The 20% is your "Future Self." If you don\'t save this, you will never build wealth or own assets.',
        correctExplanation:
            'By automating this 20% to leave your account on payday, you ensure you get rich "slowly but surely."',
      ),
      QuizQuestion(
        question: 'What is "Lifestyle Creep"?',
        options: [
          'A suspicious person in your neighborhood',
          'Increasing your spending every time your income goes up',
          'Moving to a more expensive city',
          'Buying things you don\'t like',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you get a 💎5,000 raise but immediately buy a 💎5,000 more expensive car, you are still "broke" at a higher level.',
        correctExplanation:
            'Fighting lifestyle creep allows you to keep your 50/30/20 rule stable while your net worth explodes.',
      ),
      QuizQuestion(
        question: 'A "Zero-Based Budget" means...',
        options: [
          'You have zero gems left in your bank',
          'Every single gem of income has a specific "job" assigned to it',
          'You spend zero gems for a whole month',
          'You don\'t believe in budgeting',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It doesn\'t mean you are broke! It means (Income - Expenses = 0). You "assign" your savings just like you assign your rent.',
        correctExplanation:
            'When every gem has a destination, "mystery spending" disappears and you stay in control.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q18',
    title: 'Business & Entrepreneurship',
    subtitle: 'Starting your own empire',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is "Revenue" in a business?',
        options: [
          'The profit you keep',
          'The total amount of gems the business brings in from sales',
          'The taxes you owe',
          'The number of employees',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Revenue is "Top Line." If you sell 100 apples for 💎1 each, your revenue is 💎100. It doesn\'t count your costs yet.',
        correctExplanation:
            'High revenue is great, but a business can still fail if its costs are higher than its revenue.',
      ),
      QuizQuestion(
        question: 'What is "Net Profit"?',
        options: [
          'The gems left over after ALL expenses and taxes are paid',
          'The total gems you spend on advertising',
          'A type of fishing net',
          'The amount you pay your boss',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Net Profit is the "Bottom Line." (Revenue - Costs = Profit). This is the actual wealth the business created.',
        correctExplanation:
            'Smart business owners focus on increasing profit margins, not just total sales numbers.',
      ),
      QuizQuestion(
        question: 'What does "LLC" stand for?',
        options: [
          'Large Local Company',
          'Limited Liability Company',
          'Long Lasting Capital',
          'Low Level Corporation',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The word "Limited" is the key. It protects your PERSONAL gems if your business gets sued or goes into debt.',
        correctExplanation:
            'Forming an LLC is a standard step for new entrepreneurs to protect their personal life from business risks.',
      ),
      QuizQuestion(
        question: 'What is a "Business Plan"?',
        options: [
          'A map of the office building',
          'A document describing a business, its goals, and how it will achieve them',
          'A requirement for all employees to wear suits',
          'A type of life insurance',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s the "blueprint" of the company. It explains what you sell, who buys it, and how you will make more gems than you spend.',
        correctExplanation:
            'Banks and investors will almost never lend you gems without a professional business plan.',
      ),
      QuizQuestion(
        question: 'What is "Equity Financing"?',
        options: [
          'Borrowing gems from a bank',
          'Selling a piece of your business ownership to investors in exchange for gems',
          'Buying new equipment with cash',
          'Getting a government grant',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Loans (Debt) must be paid back with interest. Equity (Shares) means you give up a piece of the pie forever but you don\'t have a monthly bill.',
        correctExplanation:
            'Many "unicorns" (successful startups) use equity financing to grow extremely fast.',
      ),
    ],
  ),
  // Batch 5 Coming Soon...
  QuizMetadata(
    id: 'l3_q19',
    title: 'Time Value of Money (TVM)',
    subtitle: 'Why gems today are worth more',
    difficulty: QuizDifficulty.hard,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is the core concept of "Time Value of Money"?',
        options: [
          'Gems are only valuable in the morning',
          '💎1 today is worth more than 💎1 in the future because of its potential to earn interest',
          'Wealth is measured by the number of hours you work',
          'The value of gems never changes',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you have 💎1,000 today, you can invest it and have 💎1,050 next year. If you wait a year to receive it, you lose that growth.',
        correctExplanation:
            'Understanding TVM is the reason why lenders charge interest—they are being paid for the "time" they don\'t have their gems.',
      ),
      QuizQuestion(
        question: 'In TVM, what does "Future Value" (FV) calculate?',
        options: [
          'The amount of gems an investment will be worth at a specific date in the future',
          'The price of gasoline in 10 years',
          'How many years until you retire',
          'The total amount of gems you have already spent',
        ],
        correctIndex: 0,
        wrongExplanation:
            'It\'s a forward-looking calculation. It answers: "If I invest 💎1,000 at 5% for 10 years, how many gems will I have?"',
        correctExplanation:
            'FV calculations help you set realistic goals for big purchases like a house or a college degree.',
      ),
      QuizQuestion(
        question: 'What does "Present Value" (PV) tell an investor?',
        options: [
          'The current price of a movie ticket',
          'The value TODAY of a specific amount of gems to be received in the future',
          'How much wealth you have right now',
          'The number of years it takes to double your gems',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If someone promises you 💎1,000 in five years, it isn\'t worth 💎1,000 today. PV "discounts" that future amount back to the present.',
        correctExplanation:
            'PV is vital for comparing different investments to see which one is actually the "better deal" in today\'s gems.',
      ),
      QuizQuestion(
        question: 'How does the "Discount Rate" affect Present Value?',
        options: [
          'A higher discount rate makes the future gems worth LESS today',
          'A higher discount rate makes the future gems worth MORE today',
          'The discount rate only applies to coupons',
          'It has no effect on gems',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Think of it as "opportunity cost." If you could earn 10% elsewhere (the discount rate), waiting for gems becomes much more expensive.',
        correctExplanation:
            'Choosing the right discount rate is one of the most difficult and important parts of professional financial analysis.',
      ),
      QuizQuestion(
        question: 'An "Annuity" is a financial product that...',
        options: [
          'Pays you a lump sum once',
          'Provides a series of equal payments at regular intervals over a period of time',
          'Is used only for buying cars',
          'Has zero interest',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A lottery prize paid out over 20 years is an annuity. A retirement plan that pays you 💎2,000 every month is also an annuity.',
        correctExplanation:
            'Annuities are often used in retirement to ensure a person never runs out of gems to live on.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q20',
    title: 'Risk, Return & CAPM',
    subtitle: 'The professional investor\'s mindset',
    difficulty: QuizDifficulty.hard,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is the "Risk-Return Tradeoff"?',
        options: [
          'Higher potential rewards usually come with higher potential risks of losing gems',
          'You should always take the biggest risk possible',
          'Risk and reward are not related',
          'The government guarantees all rewards',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If someone offers you a "guaranteed" 50% return, they are lying. To get big growth, you must be willing to accept "volatility" (prices going up and down).',
        correctExplanation:
            'A balanced investor chooses a level of risk they can "stomach" without panicking when the market dips.',
      ),
      QuizQuestion(
        question: 'What does "Beta" measure in a stock?',
        options: [
          'How many products the company sells',
          'The volatility of a stock relative to the overall market',
          'The total debt of a company',
          'The age of the CEO',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Beta looks at "movement." A Beta of 1.0 means the stock moves with the market. A Beta of 2.0 means if the market goes up 10%, your stock might jump 20%.',
        correctExplanation:
            'High-beta stocks (like tech startups) are "riskier" but offer much faster growth in a "Bull" market.',
      ),
      QuizQuestion(
        question: 'What is "Systematic Risk" (Market Risk)?',
        options: [
          'Risk that only affects one company',
          'Risk that affects the entire market (like a recession or war) and cannot be avoided by diversifying',
          'Risk of a fire in a warehouse',
          'Risk of an employee quitting',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Diversifying (buying 500 stocks) won\'t save you from a global economic collapse. This "system-wide" risk is always present.',
        correctExplanation:
            'Because systematic risk cannot be escaped, investors "demand" a higher return for carrying it.',
      ),
      QuizQuestion(
        question: 'The "Capital Asset Pricing Model" (CAPM) is used to...',
        options: [
          'Determine the exact price of a house',
          'Calculate the "required rate of return" for an investment based on its risk',
          'Find the cheapest stocks to buy',
          'Avoid paying taxes',
        ],
        correctIndex: 1,
        wrongExplanation:
            'CAPM says: "If this stock is twice as risky as the market, I need a much bigger reward to bother buying it."',
        correctExplanation:
            'While complex, the intuition of CAPM helps professional investors decide if a specific stock is worth its current price.',
      ),
      QuizQuestion(
        question:
            'What is the "Standard Deviation" of an investment used to measure?',
        options: [
          'How many gems it costs',
          'Total Risk (how much the price varies from the average)',
          'The name of the fund manager',
          'The growth rate of the economy',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If a stock\'s return is usually 8% but sometimes it\'s -20% or +40%, it has a high standard deviation (and high risk).',
        correctExplanation:
            'Stable investments like bonds have low standard deviation, making them "boring" but safe for short-term goals.',
      ),
    ],
  ),
];

final List<QuizMetadata> _level4Quizzes = [
  // Quiz 1-3: Easy (Level 4)
  QuizMetadata(
    id: 'l4_q1',
    title: 'Advanced Corporate Structures',
    subtitle: 'The legal framework of global business',
    difficulty: QuizDifficulty.easy,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question:
            'What is the primary difference between a "C-Corporation" and an "S-Corporation"?',
        options: [
          'C-Corps are only for small businesses',
          'S-Corps avoid "Double Taxation" by passing profits directly to shareholders',
          'C-Corps cannot issue stock',
          'S-Corps have unlimited liability for owners',
        ],
        correctIndex: 1,
        wrongExplanation:
            'C-Corps pay tax at the corporate level AND shareholders pay on dividends. S-Corps are "pass-through" entities that avoid this double hit.',
        correctExplanation:
            'S-Corps are popular for smaller high-growth companies because they provide corporate protection while maintaining a simple tax structure.',
      ),
      QuizQuestion(
        question: 'What does "Limited Liability" actually protect?',
        options: [
          'The business from losing any gems',
          'The personal assets of the owners from being seized to pay business debts',
          'The employees from being fired',
          'The products from being stolen',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The business can still lose everything. Limited Liability ensures that if the business fails, your personal house and 💎1,000 savings stay safe.',
        correctExplanation:
            'This legal "shield" is the foundation of modern capitalism, allowing people to take risks without risking their entire life.',
      ),
      QuizQuestion(
        question: 'A "Partnership" differs from a Corporation because...',
        options: [
          'It is easier to sell shares',
          'Partners often have "Unlimited Liability" for the business debts',
          'It never pays taxes',
          'It can only have two employees',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Corporations are separate legal "people." In a general partnership, if your partner makes a 💎50,000 mistake, YOU are personally responsible to pay it back.',
        correctExplanation:
            'General partnerships are simple to start but carry high personal risk compared to LLCs or Corporations.',
      ),
      QuizQuestion(
        question: 'What is a "Non-Profit 501(c)(3)" organization?',
        options: [
          'A business that is banned from making gems',
          'A corporation that uses all profits for a social or charitable mission and is exempt from most taxes',
          'A business that doesn\'t have to pay employees',
          'A government agency',
        ],
        correctIndex: 1,
        wrongExplanation:
            'They can make millions in profit! The difference is the profit must be reinvested in the mission, not given to owners.',
        correctExplanation:
            'Donors to these organizations can often deduct their gifts from their own personal tax bills.',
      ),
      QuizQuestion(
        question: 'What is a "Publicly Traded" company?',
        options: [
          'A company owned by the government',
          'A corporation that has sold shares to the general public on a stock exchange',
          'A company that gives away free products',
          'A company where everyone can see the office',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Public doesn\'t mean government-owned. It means common people (the public) are allowed to buy "equities" in the business.',
        correctExplanation:
            'Being public allows a company to raise massive amounts of gems, but requires them to follow strict transparency and reporting laws.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q2',
    title: 'Market Cycles & Volatility',
    subtitle: 'Understanding the tides of the economy',
    difficulty: QuizDifficulty.easy,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What does "Market Volatility" measure?',
        options: [
          'The total number of stocks sold',
          'The frequency and size of price movements over a period (the "swing" of the market)',
          'The speed of the internet at the exchange',
          'The total profit of all companies',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Volatility isn\'t about the direction (Up or Down). It\'s about the "noise." High volatility means prices are jumping wildly in both directions.',
        correctExplanation:
            'Investors use the "VIX" index (the fear gauge) to see how much volatility the market expects in the coming weeks.',
      ),
      QuizQuestion(
        question: 'What is a "Correction" in the stock market?',
        options: [
          'The government fixing a mistake in the price',
          'A price drop of 10% or more from a recent peak',
          'A day where no stocks are traded',
          'A sudden 50% increase in prices',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A 20% drop is a "Bear Market." a 10% drop is a "Correction." It is considered a normal, healthy part of a functioning market cycle.',
        correctExplanation:
            'Corrections often provide a "buying opportunity" for long-term investors who believe in the systemic growth of the economy.',
      ),
      QuizQuestion(
        question: 'What is "Market Sentiment"?',
        options: [
          'The total gems in the economy',
          'The overall attitude or "mood" of investors toward the market',
          'The specific price of a stock',
          'A tax on emotional trading',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Sentiment is psychological. If everyone is optimistic, it\'s "Bullish." if everyone is scared, it\'s "Bearish."',
        correctExplanation:
            'Successful investors often act "Contrarian," being greedy when sentiment is fearful and fearful when sentiment is greedy.',
      ),
      QuizQuestion(
        question: 'What defines a "Recession" (the technical definition)?',
        options: [
          'When prices for groceries go up',
          'Two consecutive quarters (6 months) of declining GDP growth',
          'When the stock market drops on a Monday',
          'When unemployment is exactly 10%',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s not just one bad day. It is a systematic shrinking of the whole economy\'s value over at least half a year.',
        correctExplanation:
            'During a recession, businesses sell less, fewer people are hired, and gems become harder to earn.',
      ),
      QuizQuestion(
        question: 'A "Bubble" occurs when...',
        options: [
          'Stock prices match the value of the companies',
          'Prices rise rapidly to levels far above the actual value of the assets',
          'The government prints new gems',
          'Interest rates are very high',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Bubbles are fueled by "irrational exuberance." People buy because they think they can sell to someone else for more, ignoring the "math."',
        correctExplanation:
            'When the bubble "pops," prices crash back down to reality, often causing 💎billions in losses for late investors.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q3',
    title: 'Marginal vs. Effective Tax',
    subtitle: 'The math of the tax bracket',
    difficulty: QuizDifficulty.easy,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is a "Marginal Tax Rate"?',
        options: [
          'The total tax you pay divided by your income',
          'The tax rate applied ONLY to the last dollar you earned in your highest bracket',
          'A tax that only applies to banks',
          'The lowest tax rate in the country',
        ],
        correctIndex: 1,
        wrongExplanation:
            'You don\'t pay your highest rate on ALL your gems! You pay 10% on the first batch, 12% on the next, and so on. The margin is just the "top" slice.',
        correctExplanation:
            'Understanding marginal rates prevents the myth that "a raise can make you take home fewer gems" due to higher taxes.',
      ),
      QuizQuestion(
        question: 'What is an "Effective Tax Rate"?',
        options: [
          'The rate on your last dollar',
          'The ACTUAL percentage of your total income paid in taxes (Total Tax / Total Income)',
          'A tax that works effectively',
          'The tax rate for corporations only',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Your effective rate is ALWAYS lower than your marginal rate because of the lower brackets and deductions you used.',
        correctExplanation:
            'Effective rate is the "true" number that tells you how much of your wealth the government actually took.',
      ),
      QuizQuestion(
        question: 'What is "Taxable Income"?',
        options: [
          'Every gem you received during the year',
          'Your Gross Income minus any adjustments, deductions, and exemptions',
          'The money you have in the bank',
          'The amount the government owes you',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you earn 💎50,000 but have 💎12,000 in deductions, the government only looks at 💎38,000 when calculating your bill.',
        correctExplanation:
            'Smart tax planning focuses on legally reducing your taxable income so you keep more of your hard-earned gems.',
      ),
      QuizQuestion(
        question: 'A "Regressive Tax" is one where...',
        options: [
          'Rich people pay a higher percentage',
          'Lower-income earners pay a HIGHER percentage of their income than the wealthy',
          'Taxes are going back in time',
          'No one has to pay',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Sales tax is often regressive. A 💎1 tax on bread is a tiny slice for a billionaire, but a huge slice for someone earning 💎10 a day.',
        correctExplanation:
            'Developing a fair tax system requires balancing progressive income taxes with regressive sales or gas taxes.',
      ),
      QuizQuestion(
        question: 'What is "Capital Gains Tax"?',
        options: [
          'A tax on your paycheck',
          'A tax on the PROFIT made from selling an investment like stocks or real estate',
          'A tax on the total value of your car',
          'A fee for visiting the capital city',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you buy a stock for 💎10 and sell for 💎15, you only pay tax on the 💎5 you "gained," not the whole 💎15.',
        correctExplanation:
            'Capital gains rates are often LOWER than income tax rates to encourage people to invest their gems in the economy.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q4',
    title: 'Asset Allocation & Strategy',
    subtitle: 'The 12th grade guide to diversification',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is the primary goal of "Asset Allocation"?',
        options: [
          'To pick the single best stock to buy',
          'To balance risk and reward by dividing gems among different categories like stocks, bonds, and cash',
          'To avoid paying any taxes whatsoever',
          'To spend all your gems as fast as possible',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It isn\'t about picking one winner. It\'s about building a "team" of investments that don\'t all crash at the same time.',
        correctExplanation:
            'How you divide your gems (e.g., 80% stocks, 20% bonds) usually has a bigger impact on your long-term wealth than whether you picked Apple or Microsoft.',
      ),
      QuizQuestion(
        question: 'What does it mean for two investments to be "Uncorrelated"?',
        options: [
          'They both always go up together',
          'The price of one doesn\'t move in lockstep with the other',
          'They are both owned by the same person',
          'They are both illegal to own',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If they both go up and down together, your risk is high. True diversification requires "uncorrelated" assets (like Gold vs. Tech Stocks).',
        correctExplanation:
            'In a perfect portfolio, when one asset drops, another stays steady or rises, protecting your total 💎 levels.',
      ),
      QuizQuestion(
        question: 'What is "Rebalancing" a portfolio?',
        options: [
          'Selling all your stocks to buy a car',
          'The process of buying and selling assets to return to your original target allocation percentages',
          'Waiting for the market to fix itself',
          'Changing your bank password',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Rebalancing forces you to "Sell High" (the assets that grew too much) and "Buy Low" (the assets that lagged), which is a proven wealth secret.',
        correctExplanation:
            'If your 80/20 split becomes 90/10 because stocks went up, you must rebalance to keep your risk level where you want it.',
      ),
      QuizQuestion(
        question: 'What is a "Target Date Fund"?',
        options: [
          'A fund that only exists for 24 hours',
          'A mutual fund that automatically shifts from high-risk to low-risk as you get closer to your retirement year',
          'A fund used to pay for a wedding date',
          'A type of lottery ticket',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s for the "Set it and Forget it" investor. It manages the asset allocation for you as you age.',
        correctExplanation:
            'These are very popular in 401k plans because they ensure a 25-year-old takes high risk and a 64-year-old stays safe.',
      ),
      QuizQuestion(
        question:
            'Why does an investor\'s "Time Horizon" matter for allocation?',
        options: [
          'It tells you what time the market opens',
          'A longer time horizon allows you to take more risk because you have time to recover from crashes',
          'It determines which bank you use',
          'It has no effect on investment choices',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you need your gems in 2 years, don\'t put them in the stock market! High risk is only for gems you don\'t need for a decade or more.',
        correctExplanation:
            'Time is the "buffer" against volatility. The more time you have, the more aggressive you can be with your asset mix.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q5',
    title: 'Derivatives & Hedging',
    subtitle: 'Managing risk like a pro',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is a "Derivative" in finance?',
        options: [
          'A type of new bank account',
          'A financial contract that gets its value from an underlying asset (like a stock or a commodity)',
          'A way to calculate your taxes',
          'A loan that never ends',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A derivative isn\'t the asset itself. It\'s a "side bet" or a "promise" based on what that asset does.',
        correctExplanation:
            'Common derivatives include options, futures, and swaps. They are powerful tools but can be very dangerous for beginners.',
      ),
      QuizQuestion(
        question: 'What is the primary purpose of "Hedging"?',
        options: [
          'To make the most gems possible',
          'To reduce or cancel out the risk of a price drop in an investment you already own',
          'To avoid telling your friends about your losses',
          'To buy things you don\'t need',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Hedging is like "insurance" for your portfolio. You spend a few gems to protect against a catastrophic loss.',
        correctExplanation:
            'Farmers often use derivatives to hedge the price of their corn so they know exactly how many gems they will have for the harvest.',
      ),
      QuizQuestion(
        question: 'In options trading, what is a "Call Option"?',
        options: [
          'The right to SELL a stock at a specific price',
          'The right to BUY a stock at a specific price within a certain timeframe',
          'A phone call from your broker',
          'An obligation to buy a whole company',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A Call is a "Bet on Up." You pay for the "option" to buy a stock cheaply even if its price rockets to the moon.',
        correctExplanation:
            'If you don\'t use the option, you only lose the small "premium" (price) you paid for the contract.',
      ),
      QuizQuestion(
        question: 'In options trading, what is a "Put Option"?',
        options: [
          'The right to SELL a stock at a specific price',
          'The right to buy 100 shares of a stock',
          'Putting your gems into a savings account',
          'A way to cancel your bank account',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A Put is a "Bet on Down." It lets you sell a stock for 💎100 even if the market price has crashed to 💎20.',
        correctExplanation:
            'Puts are the most common way professional investors hedge their portfolios against a sudden market crash.',
      ),
      QuizQuestion(
        question: 'What occurs during "Short Selling"?',
        options: [
          'Buying a stock for a short period of time',
          'Borrowing shares to sell them now, hoping to buy them back later at a lower price',
          'Selling your assets because you are short on gems',
          'A way to pay half price for a stock',
        ],
        correctIndex: 1,
        wrongExplanation:
            'In a short sale, you want the company to FAIL. You sell "air" now and hope to replace it with cheap shares later.',
        correctExplanation:
            'Shorting is extremely risky! If the stock price goes up, there is no limit to how many gems you could lose.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q6',
    title: 'Global Macro & Forex',
    subtitle: 'Wealth on a global scale',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What does "Forex" (FX) stand for?',
        options: [
          'Financial Optional Rewards Exchange',
          'Foreign Exchange Market',
          'Forward Expense Ratio',
          'Fast Online Retail Exports',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Forex is the largest market in the world, where trillions of 💎s worth of different countries\' currencies are traded every day.',
        correctExplanation:
            'Everything you buy from overseas (like a car or a phone) depends on the Forex rates between countries.',
      ),
      QuizQuestion(
        question: 'When a currency "Appreciates," what does that mean?',
        options: [
          'It becomes less valuable',
          'Its value increases compared to another currency',
          'The government stops printing it',
          'It can no longer be used for trade',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Appreciate = Grow. If the Dollar appreciates against the Euro, you can buy more European goods with the same amount of 💎s.',
        correctExplanation:
            'A strong currency makes imports cheaper but makes it harder for local companies to sell their products to other countries.',
      ),
      QuizQuestion(
        question: 'What is a "Trade Deficit"?',
        options: [
          'When a country exports more than it imports',
          'When a country buys more goods from other countries than it sells to them',
          'When a country has no gems in the bank',
          'A type of tax on imports',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s like a family spending more than they earn. The country is "sending" its currency overseas in exchange for more stuff.',
        correctExplanation:
            'Continuous trade deficits can lead to a weaker currency over long periods of time.',
      ),
      QuizQuestion(
        question: 'What is a "Tariff"?',
        options: [
          'A gift from one country to another',
          'A tax imposed by a government on imported goods',
          'A type of high-speed train',
          'A special license to trade stocks',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Tariffs make foreign goods more expensive. This is usually done to protect local businesses from being "outsourced" to cheaper countries.',
        correctExplanation:
            'While tariffs protect local jobs, they often lead to higher prices for you, the consumer.',
      ),
      QuizQuestion(
        question: 'What is "Hyperinflation"?',
        options: [
          'When prices go up by 2% a year',
          'Extremely rapid, out-of-control price increases (usually over 50% per month)',
          'When the stock market grows too fast',
          'A way to save gems faster',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Inflation is normal. Hyperinflation is a total system collapse where gems become literally worthless as fast as you earn them.',
        correctExplanation:
            'Hyperinflation is almost always caused by governments printing massive amounts of gems to pay off debts they can\'t afford.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q7',
    title: 'Advanced Mortgages',
    subtitle: 'The 💎100,000 math of a home',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is a "Fixed-Rate Mortgage"?',
        options: [
          'The price of the house never changes',
          'A loan where the interest rate stays the same for the entire life of the loan',
          'A mortgage that must be paid in one year',
          'A loan only for rich people',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Fixed-rate loans provide "certainty." Even if the world economy changes, your monthly payment will stay exactly the same for 30 years.',
        correctExplanation:
            'These are very popular when interest rates are LOW, as you "lock in" the cheap price for decades.',
      ),
      QuizQuestion(
        question: 'How does an "ARM" (Adjustable-Rate Mortgage) work?',
        options: [
          'The borrower must pay with their physical labor',
          'The interest rate changes over time based on the market conditions',
          'The bank can take your house at any time',
          'A loan that has zero interest for life',
        ],
        correctIndex: 1,
        wrongExplanation:
            'ARMs usually start with a "teaser" low rate, but after a few years, the rate can jump, making your monthly bill much more expensive.',
        correctExplanation:
            'ARMs are risky! If interest rates go up across the whole country, your mortgage payment could suddenly double.',
      ),
      QuizQuestion(
        question: 'What is a "Mortgage Amortization Schedule"?',
        options: [
          'A list of the house\'s features',
          'A table showing how each monthly payment is split between interest and paying down the actual debt (Principal)',
          'A plan for moving day',
          'A contract with the neighbors',
        ],
        correctIndex: 1,
        wrongExplanation:
            'In the beginning, almost 100% of your payment is just "interest" (the bank\'s profit). You don\'t actually own much more of the house until years later.',
        correctExplanation:
            'Looking at an amortization table is the best way to see how much a 💎200,000 house actually costs (often 💎400,000+ after interest).',
      ),
      QuizQuestion(
        question: 'What is "Home Equity"?',
        options: [
          'The current market price of the house',
          'The portion of the home\'s value that YOU actually own (Market Value - Remaining Mortgage)',
          'The size of the backyard',
          'A type of home insurance',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If your house is worth 💎300,000 but you owe the bank 💎250,000, you only have 💎50,000 in equity. The bank owns the rest!',
        correctExplanation:
            'Building equity is the main way middle-class families build long-term wealth over their lifetimes.',
      ),
      QuizQuestion(
        question: 'What is a "Refinance" (Refi)?',
        options: [
          'Painting the house to sell it',
          'Replacing an existing mortgage with a new one, usually to get a lower interest rate',
          'Buying a second house next door',
          'Paying the mortgage off early with cash',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If interest rates drop from 6% to 3%, you "Refi" to lower your monthly bill and save 💎thousands in interest over time.',
        correctExplanation:
            'Refinancing costs gems upfront in fees, so you must calculate if the monthly savings are worth the initial cost.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q8',
    title: 'Corporate Valuation',
    subtitle: 'Is a stock "Cheap" or "Expensive"?',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is the "P/E Ratio"?',
        options: [
          'The Price divided by the Earnings per share',
          'The Profit divided by the Expenses',
          'The Percentage of Employees',
          'The Price divided by the Energy used',
        ],
        correctIndex: 0,
        wrongExplanation:
            'P/E tells you "how many gems you are paying for every 💎1 of profit." A P/E of 20 means you pay 💎20 to own 💎1 of the company\'s annual earnings.',
        correctExplanation:
            'High P/E usually means investors expect the company to grow very fast in the future.',
      ),
      QuizQuestion(
        question: 'What does "Market Capitalization" (Market Cap) mean?',
        options: [
          'The total number of buildings a company owns',
          'The total market value of all a company\'s outstanding shares (Share Price x Total Shares)',
          'The city where the company is headquartered',
          'The amount of gems the company has in the bank',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Market Cap is the "Price Tag" of the whole company. Small-cap companies are risky but growth-heavy; Large-cap companies (like Walmart) are stable.',
        correctExplanation:
            'Don\'t look at share price alone! A 💎100 stock might be a "Smaller" company than a 💎10 stock if there are few shares.',
      ),
      QuizQuestion(
        question: 'What is "EBITDA"?',
        options: [
          'A type of professional degree',
          'Earnings Before Interest, Taxes, Depreciation, and Amortization',
          'A government agency for trade',
          'The total amount of gems spent on advertising',
        ],
        correctIndex: 1,
        wrongExplanation:
            'EBITDA is used to see how "Cash Flow" positive a business is without all the complicated accounting and tax rules getting in the way.',
        correctExplanation:
            'Investors use EBITDA to compare two different companies in different countries with different tax laws.',
      ),
      QuizQuestion(
        question: 'What is a "Dividend Yield"?',
        options: [
          'The total amount of dividends paid in history',
          'The annual dividend payment divided by the stock price, shown as a percentage',
          'The number of people who own the stock',
          'A way to measure the risk of a stock',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If a 💎100 stock pays 💎4 a year in dividends, the yield is 4%. It is like the "Interest Rate" of your investment.',
        correctExplanation:
            'High-dividend stocks (like Utility companies) are favored by retirees who need a steady stream of gems every month.',
      ),
      QuizQuestion(
        question: 'What is "Book Value"?',
        options: [
          'The price of a textbook',
          'The total value of a company\'s physical assets if it were closed down and sold today',
          'The number of books in the CEO\'s library',
          'The amount of gems spent on legal fees',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Book value represents the "floor" of a company. Some tech companies have low book value (they only own computers and code) but high market value.',
        correctExplanation:
            'Value investors look for stocks trading BELOW their book value, hoping to find a "bargain" that the market has ignored.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q9',
    title: 'Monetary Policy & The Fed',
    subtitle: 'The 💎trillion-dollar levers of power',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question:
            'What is the primary role of the "Federal Reserve" (The Fed)?',
        options: [
          'To collect taxes for the government',
          'To manage the nation\'s money supply and set interest rates to control inflation',
          'To print every gem used in the game',
          'To provide free insurance to all citizens',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The IRS collects taxes. The Fed is the "Central Bank" that acts like the thermostat of the economy, cooling it down or heating it up.',
        correctExplanation:
            'By raising or lowering interest rates, The Fed influences how many gems businesses borrow and how much consumers spend.',
      ),
      QuizQuestion(
        question: 'What happens when The Fed "Raises" interest rates?',
        options: [
          'Borrowing becomes cheaper and spending increases',
          'Borrowing becomes more expensive, which usually cools down inflation',
          'The government gives out free gems to everyone',
          'The stock market always goes up immediately',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Higher rates = Higher cost. If a car loan goes from 3% to 8%, fewer people buy cars, which slows down the flow of gems.',
        correctExplanation:
            'The Fed raises rates when they are worried the economy is "overheating" and prices are rising too fast.',
      ),
      QuizQuestion(
        question: 'What is "Quantitative Easing" (QE)?',
        options: [
          'A way to count all the gems in the country',
          'When the central bank buys large amounts of government bonds to inject gems into the economy',
          'A tax on high-income earners',
          'A rule that limits how many shares you can buy',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It isn\'t just "printing money" in the traditional sense. It is a tool used when interest rates are already zero to force gems into the financial system.',
        correctExplanation:
            'QE lowers long-term interest rates and encourages banks to lend more gems to businesses and homebuyers.',
      ),
      QuizQuestion(
        question: 'What is the "Dual Mandate" of the Federal Reserve?',
        options: [
          'To protect banks and collect taxes',
          'Maximum employment and stable prices (low inflation)',
          'To print gems and stop counterfeiters',
          'To manage the military and the post office',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The Fed only has two main "jobs" assigned by law. They want as many people working as possible without causing gems to lose their value.',
        correctExplanation:
            'Often these two goals conflict: low unemployment can lead to high inflation, forcing The Fed to make difficult choices.',
      ),
      QuizQuestion(
        question: 'What are "Reserve Requirements"?',
        options: [
          'The amount of gems you must have in your savings account',
          'The percentage of deposits a bank MUST keep in its vaults and not lend out',
          'A requirement to join the army',
          'The number of employees a business must have',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Banks don\'t just "hold" your gems; they lend them to others. Reserve requirements ensure they don\'t lend out every single gem, which prevents bank runs.',
        correctExplanation:
            'By lowering reserve requirements, the government allows banks to create more "credit" (digital gems) in the economy.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q10',
    title: 'Fiscal Policy & Debt',
    subtitle: 'How the government spends your wealth',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question:
            'What is the main difference between Monetary and "Fiscal Policy"?',
        options: [
          'Fiscal policy is managed by the Central Bank',
          'Fiscal policy is the use of government spending and taxation to influence the economy',
          'Monetary policy only affects poor people',
          'There is no difference between them',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Monetary = Interest Rates (The Fed). Fiscal = Spending/Taxes (The President and Congress). Both are huge levers of economic power.',
        correctExplanation:
            'Fiscal policy is often used to build "Public Goods" like roads, schools, and the military using gems collected from citizens.',
      ),
      QuizQuestion(
        question: 'What is a "Budget Deficit"?',
        options: [
          'When the government has zero gems',
          'When the government spends MORE gems in a year than it collects in taxes',
          'When a person forgets to pay their rent',
          'A type of tax on imports',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Deficit is a yearly number. If you earn 💎100 and spend 💎120, your deficit for that year is 💎20.',
        correctExplanation:
            'To pay for the deficit, the government borrows gems from investors by selling "Treasury Bonds."',
      ),
      QuizQuestion(
        question: 'What is the "National Debt"?',
        options: [
          'The total amount of gems all citizens owe to banks',
          'The total accumulation of all past yearly deficits that the government has not yet paid back',
          'The gems the government gives away as grants',
          'A tax on the whole country',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The Debt is the "Total Balance" on the country\'s credit card. The Deficit is just the "New spending" added this year.',
        correctExplanation:
            'A high national debt means a large portion of future tax gems must be spent just on paying "interest" to lenders.',
      ),
      QuizQuestion(
        question: 'What does the "Debt-to-GDP Ratio" measure?',
        options: [
          'How much every person owes in gems',
          'A country\'s total debt compared to the total value of everything its economy produces in a year',
          'The percentage of taxes that go to the military',
          'The number of years it takes to pay off a loan',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A 💎1,000 debt is small for a billionaire but huge for a student. Debt-to-GDP tells you if the "size" of the debt is sustainable for that country.',
        correctExplanation:
            'Economists watch this ratio to see if a country is at risk of "Defaulting" (refusing to pay back) its lenders.',
      ),
      QuizQuestion(
        question: 'What is "Discretionary Spending" in a government budget?',
        options: [
          'Spending that must happen by law (like Social Security)',
          'Spending that Congress must approve every year (like education or defense)',
          'Spending on secret government missions',
          'Spending by private citizens',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Most gems go to "Mandatory" spending (programs that the law says MUST be paid). Discretionary gems are the ones the government actually debates and chooses to spend.',
        correctExplanation:
            'When the government wants to "balance the budget," they usually look at discretionary spending first because it\'s easier to cut.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q11',
    title: 'Behavioral Finance',
    subtitle: 'The psychology of the 💎 market',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is "Loss Aversion" in psychology?',
        options: [
          'The fear of being lost in a city',
          'The tendency for people to feel the pain of a loss twice as strongly as the joy of a gain',
          'Winning more gems than you lose',
          'Forgetting about your bank account',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Losing 💎100 "hurts" more than finding 💎100 "feels good." This causes investors to make irrational choices, like holding onto a crashing stock for too long.',
        correctExplanation:
            'Being aware of your loss aversion can help you stick to your long-term plan even when the market is red.',
      ),
      QuizQuestion(
        question: 'What is the "Sunk Cost Fallacy"?',
        options: [
          'Continuing an investment only because you have already put so many gems into it',
          'The cost of building a ship',
          'Thinking that prices will always go up',
          'Investing only in safe assets',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The gems you spent are "sunk"—they are gone forever. You should only stay in an investment if it has a GOOD future, not because of its past cost.',
        correctExplanation:
            'Professional investors are willing to "cut their losses" and move their remaining gems to better opportunities.',
      ),
      QuizQuestion(
        question: 'What is "Herd Mentality" in the stock market?',
        options: [
          'Buying animals for a farm',
          'Following what everyone else is doing without doing your own research',
          'Owning many different types of gems',
          'A requirement to join a professional investment club',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Just because everyone on social media is buying a stock doesn\'t mean it is a good investment. The "herd" is often the last to know a bubble is popping.',
        correctExplanation:
            'Successful investors like Warren Buffett often do the OPPOSITE of the herd (the Contrarian approach).',
      ),
      QuizQuestion(
        question: 'What is "Confirmation Bias"?',
        options: [
          'Getting a text when your trade is complete',
          'Only looking for information that agrees with what you already believe about an investment',
          'Telling everyone about your wins',
          'Asking a professional for help',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you love a company, you might ignore bad news about them. This "blind spot" leads to huge avoidable losses.',
        correctExplanation:
            'To be a pro, you should actively look for reasons why your investment might be WRONG.',
      ),
      QuizQuestion(
        question: 'What is "FOMO" (Fear Of Missing Out)?',
        options: [
          'A type of high-interest loan',
          'The anxiety that others are getting rich while you are sitting on the sidelines',
          'The cost of trading too often',
          'A law that limits your profit',
        ],
        correctIndex: 1,
        wrongExplanation:
            'FOMO causes people to buy at the "Top" (maximum price) just because they see others making gems.',
        correctExplanation:
            'The best way to fight FOMO is to have a "Rules-Based" system and never chase a stock that has already rocketed.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q12',
    title: 'Advanced Retirement',
    subtitle: 'Surviving the Golden Years',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is the "4% Rule" in retirement planning?',
        options: [
          'A rule that says you should save 4% of your income',
          'A guideline that says you can safely withdraw 4% of your portfolio each year without running out of gems',
          'The minimum interest you get in a savings account',
          'The maximum tax you pay when you retire',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you have 💎1,000,000, the 4% rule says you can live on 💎40,000 a year forever. It assumes your gems keep growing while you spend them.',
        correctExplanation:
            'The 4% rule is the gold standard for "Financial Independence" (the point where work becomes optional).',
      ),
      QuizQuestion(
        question: 'What is "Sequence of Returns Risk"?',
        options: [
          'The risk of the stock market closing',
          'The risk that a market crash happens during the FIRST FEW YEARS of your retirement',
          'The order in which you pay your bills',
          'Having too many different bank accounts',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If the market crashes when you are 30, you don\'t care. If it crashes the year you stop working and you have to sell cheap shares to buy food, your wealth might never recover.',
        correctExplanation:
            'Retirees use "Cash Buckets" to hold 2 years of gems so they never have to sell stocks during a crash.',
      ),
      QuizQuestion(
        question: 'What is a "Roth Conversion"?',
        options: [
          'Changing your name to Roth',
          'Moving gems from a Traditional 401k to a Roth IRA to ensure all future growth is TAX-FREE',
          'Selling your house to buy an apartment',
          'A way to double your gems overnight',
        ],
        correctIndex: 1,
        wrongExplanation:
            'You pay tax now on the gems you move, but you never pay tax on that folder again. It\'s a strategy used when you expect taxes to be higher in the future.',
        correctExplanation:
            'Strategic conversions can save 💎hundreds of thousands in taxes over a 30-year retirement.',
      ),
      QuizQuestion(
        question: 'What is a "Required Minimum Distribution" (RMD)?',
        options: [
          'The smallest paycheck you can receive',
          'A government rule that forces you to start taking gems out of your 401k/IRA at age 73 (so they can tax it)',
          'The minimum gems required to open an account',
          'The least amount you can give to charity',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The government gave you a "Tax Break" to save. RMDs are their way of saying: "Time up! We want our tax gems now."',
        correctExplanation:
            'Planning for RMDs is vital because if you don\'t take them, the penalty is a massive 25% of the gems you were supposed to withdraw.',
      ),
      QuizQuestion(
        question:
            'What is an "HSA" (Health Savings Account) used as a retirement tool?',
        options: [
          'It can only be used for band-aids',
          'A "Triple Tax Advantaged" account where gems go in tax-free, grow tax-free, and come out tax-free for medical needs',
          'A type of car insurance',
          'A savings account for buying a gym',
        ],
        correctIndex: 1,
        wrongExplanation:
            'HSAs are the "best" accounts. After age 65, you can use the gems for ANYTHING (paying tax like an IRA), or for medical needs (paying zero tax).',
        correctExplanation:
            'Treating an HSA as a long-term investment account is an "Advanced Move" for building massive wealth.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q13',
    title: 'Economic Indicators',
    subtitle: 'Predicting the economic future',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question:
            'What are the four components of "GDP" (Gross Domestic Product)?',
        options: [
          'Stocks, Bonds, Cash, Real Estate',
          'Consumption, Investment, Government Spending, and Net Exports',
          'Taxes, Fees, Fines, and Grants',
          'Apples, Oranges, Cars, and Planes',
        ],
        correctIndex: 1,
        wrongExplanation:
            'GDP measures the "Girth" of the economy. If one of these drops (like consumption during a lockdown), the whole GDP shrinks.',
        correctExplanation:
            'Consumption (people buying things) is usually the largest part of the US economy (about 70%).',
      ),
      QuizQuestion(
        question: 'What is the "CPI" (Consumer Price Index)?',
        options: [
          'A measure of the total number of people in a country',
          'The weighted average prices of a "basket" of consumer goods (used to calculate inflation)',
          'The current price of the stock market',
          'A tax on buying clothes',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Economists "shop" for the same basket of milk, rent, and shoes every month. If the basket price goes from 💎100 to 💎108, the inflation rate is 8%.',
        correctExplanation:
            'The Fed uses "Core CPI" (which ignores food and energy) to get a clearer picture of long-term price trends.',
      ),
      QuizQuestion(
        question: 'What is a "Leading Economic Indicator"?',
        options: [
          'An indicator that tells you what happened last year',
          'A data point that changes BEFORE the rest of the economy (like New Housing Permits)',
          'The name of a successful company',
          'A tax that leads to higher growth',
        ],
        correctIndex: 1,
        wrongExplanation:
            'GDP is a "Lagging" indicator (it tells you where you WERE). Building permits are "Leading" because they show how many houses will be built next year.',
        correctExplanation:
            'Investors watch leading indicators to predict when a recession might be coming before it actually starts.',
      ),
      QuizQuestion(
        question: 'What is "Stagflation"?',
        options: [
          'When the economy grows very fast with zero inflation',
          'A dangerous combo of "Stagnant" economic growth, high unemployment, and high inflation',
          'When prices stay the same for 10 years',
          'A way to measure the height of buildings',
        ],
        correctIndex: 1,
        wrongExplanation:
            'This is an economic nightmare. Usually, inflation drops during a recession. In stagflation, you are broke AND prices are going up at the same time.',
        correctExplanation:
            'Stagflation last occurred in the 1970s and required very aggressive interest rate hikes to stop.',
      ),
      QuizQuestion(
        question: 'What is the "Yield Curve" (and why is it a warning)?',
        options: [
          'The shape of a banana',
          'A graph showing the interest rates of bonds with different maturity dates',
          'The path of a stock price over a week',
          'A way to measure the depth of the ocean',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Usually, long-term bonds pay HIGHER interest. If short-term rates become higher (an "Inverted Yield Curve"), it almost always predicts a recession is coming.',
        correctExplanation:
            'An inverted yield curve means investors are more scared of the near future than the long-term future.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q14',
    title: 'Venture Capital & Equity',
    subtitle: 'Fueling the next big unicorn',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is the primary role of a "Venture Capital" (VC) firm?',
        options: [
          'To provide loans to homeowners',
          'To invest gems in early-stage, high-potential startups in exchange for ownership equity',
          'To manage the government\'s tax collection',
          'To sell insurance to small businesses',
        ],
        correctIndex: 1,
        wrongExplanation:
            'VCs aren\'t banks. They don\'t want "interest." They want to own 10% of a company that might become the next Google or Amazon.',
        correctExplanation:
            'VCs take massive risks! 9 out of 10 startups fail, but the one that succeeds can return 💎billions to the investors.',
      ),
      QuizQuestion(
        question: 'What happens during a "Series A" funding round?',
        options: [
          'The founder uses their own savings to start the business',
          'A startup raises its first major round of outside venture capital to scale its operations',
          'The company goes bankrupt and sells its computers',
          'The company pays its first dividend to shareholders',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Founders start with "Seed" funding. Series A is when the business is proven and needs 💎millions to grow fast.',
        correctExplanation:
            'Each letter (Series A, B, C) usually represents a larger amount of gems and a higher valuation for the company.',
      ),
      QuizQuestion(
        question: 'What is a "Unicorn" in the business world?',
        options: [
          'A company that sells mythical toys',
          'A private startup company valued at over 💎1 Billion',
          'A company with zero employees',
          'A business that never pays taxes',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It\'s called a unicorn because they used to be rare. Today, there are hundreds of them, though reaching 💎1 Billion is still extremely difficult.',
        correctExplanation:
            'Unicorn status is a major milestone that usually leads to an IPO (going public) or being bought by a larger company.',
      ),
      QuizQuestion(
        question: 'What is an "Exit Strategy" for a founder or investor?',
        options: [
          'A plan to leave the building during a fire',
          'The method by which they intend to sell their ownership and "cash out" their gems (like an IPO or Merger)',
          'A way to fire all the employees',
          'A plan to close the business and move to a new country',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Gems in a private company are "illiquid" (you can\'t spend them). The exit is the moment those shares turn back into spendable 💎s.',
        correctExplanation:
            'Common exits include being bought by a larger company (Acquisition) or selling shares to the public (IPO).',
      ),
      QuizQuestion(
        question: 'What is "Burn Rate"?',
        options: [
          'The speed at which a company spends its gems before it becomes profitable',
          'A measure of how fast a computer runs',
          'The temperature inside a factory',
          'The percentage of products that are broken',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If a startup has 💎1,000,000 in the bank and spends 💎100,000 a month, its "runway" is 10 months. If it doesn\'t make profit by then, it dies.',
        correctExplanation:
            'Managing burn rate is the #1 job of a startup CEO, ensuring they don\'t run out of gems before reaching success.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q15',
    title: 'IPOs & The Public Market',
    subtitle: 'Ringing the bell on Wall Street',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is an "IPO" (Initial Public Offering)?',
        options: [
          'Choosing a new CEO',
          'The first time a private company sells its shares to the general public on an exchange',
          'An Important Price Office',
          'A way to pay employees with gems instead of cash',
        ],
        correctIndex: 1,
        wrongExplanation:
            'An IPO is the "Graduation Day" of a company. It moves from being owned by founders and VCs to being owned by anyone with 💎s.',
        correctExplanation:
            'IPOs allow a company to raise massive wealth to build new products and expand globally.',
      ),
      QuizQuestion(
        question: 'What is an "Underwriter" (Investment Bank)?',
        options: [
          'The person who writes the company\'s ads',
          'A bank that helps a company prepare for an IPO and finds investors to buy the shares',
          'A type of insurance agent',
          'A secret investor who hides their identity',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Underwriters (like Goldman Sachs) act as the "Midwives" of the public market, taking a fee to ensure the IPO is successful.',
        correctExplanation:
            'They often "guarantee" a certain price for the shares, taking on a huge risk to help the company go public.',
      ),
      QuizQuestion(
        question: 'What is an "S-1 Filing"?',
        options: [
          'A tax return for a small business',
          'The detailed legal document a company must file with the SEC before it can go public',
          'A secret code used by stock traders',
          'A form used to hire new employees',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The S-1 contains EVERY secret about the company—its risks, its profits, and its plans. Investors read it to decide if the stock is a good deal.',
        correctExplanation:
            'Transparency is a requirement for the public market. You can\'t hide your losses when you want the public\'s gems.',
      ),
      QuizQuestion(
        question: 'What is a "Lock-up Period" after an IPO?',
        options: [
          'When the stock exchange is closed for a holiday',
          'A period (usually 180 days) where insiders/employees are FORBIDDEN from selling their shares',
          'A time when you can\'t log into your bank app',
          'A penalty for trading too fast',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Lock-ups prevent the price from crashing because everyone tries to sell on day one. It proves the insiders believe in the long-term future.',
        correctExplanation:
            'When the lock-up ends, stock prices often drop because a massive wave of new shares hits the market.',
      ),
      QuizQuestion(
        question: 'What is a "Direct Listing" (compared to a traditional IPO)?',
        options: [
          'Selling shares only to the government',
          'Going public without using investment banks or raising new gems—just letting existing shares trade',
          'Listing products on a website',
          'A rule that requires you to buy a stock every month',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Direct listings (like Spotify or Slack) save millions in fees but don\'t give the company "new" gems immediately.',
        correctExplanation:
            'It is considered a "fairest" way to list because it doesn\'t give big banks a "special deal" before the public can buy.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q16',
    title: 'Hedge Funds & Investing',
    subtitle: 'Chasing "Alpha" in the 💎 market',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question:
            'What is the main difference between an Index Fund and a "Hedge Fund"?',
        options: [
          'Index funds are only for poor people',
          'Hedge funds use aggressive strategies (like shorting and leverage) to try and beat the market, while index funds just follow it',
          'Index funds charge much higher fees',
          'Hedge funds are owned by the government',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Index funds are "Passive" (cheap and easy). Hedge funds are "Active" (expensive and complex). 90% of hedge funds actually FAIL to beat the index over time.',
        correctExplanation:
            'Hedge funds are usually only for "Accredited Investors" (people who already have 💎millions) because they are so risky.',
      ),
      QuizQuestion(
        question: 'In investing, what does "Alpha" represent?',
        options: [
          'The first stock ever traded',
          'The "Excess Return" of an investment above its benchmark or the overall market',
          'The total number of employees in a company',
          'A type of very strong gem',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If the market goes up 10% and you go up 15%, your "Alpha" is 5%. It is the measure of an investor\'s actual skill.',
        correctExplanation:
            'Chasing Alpha is the goal of every professional trader, but for most people, "Beta" (just matching the market) is the better path.',
      ),
      QuizQuestion(
        question: 'What is "Leverage" in trading?',
        options: [
          'Buying stocks with your own savings',
          'Using BORROWED gems to increase the size of your investment and potential profit (or loss)',
          'Asking a manager for a raise',
          'A way to trade stocks without a phone',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Leverage is a double-edged sword. If you use 10x leverage, a 1% gain becomes a 10% profit—but a 10% drop loses 100% of your gems!',
        correctExplanation:
            'Leverage is the primary reason why professional hedge funds sometimes "blow up" and lose everything in a single day.',
      ),
      QuizQuestion(
        question: 'What is the "2 and 20" fee structure common in hedge funds?',
        options: [
          '2 gems per month and 20% of your total gems',
          'A 2% management fee and a 20% performance fee (on profits)',
          '2 employees for every 20 investors',
          'A 20-year contract and a 2% interest rate',
        ],
        correctIndex: 1,
        wrongExplanation:
            'These fees are HUGE! The fund takes 2% of your gems even if they LOSE money, and 20% of any gains they make for you.',
        correctExplanation:
            'Because of these high fees, many experts (like Warren Buffett) recommend low-cost index funds for almost everyone.',
      ),
      QuizQuestion(
        question: 'What is a "Market Neutral" strategy?',
        options: [
          'Not being interested in the market',
          'A strategy that tries to make gems whether the market goes UP or DOWN by balancing Long and Short positions',
          'Investing only in government bonds',
          'A rule that bans you from selling stocks',
        ],
        correctIndex: 1,
        wrongExplanation:
            'They "Hedge" their bets. They might buy the best tech stock and short the worst one, hoping to profit on the difference regardless of a crash.',
        correctExplanation:
            'True market-neutral funds are very rare and require extremely complex 💎trader algorithms to work.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q17',
    title: 'Bond Markets & Yields',
    subtitle: 'The 💎debt engine of the world',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question:
            'What is the inverse relationship between Bond Prices and "Yields"?',
        options: [
          'When prices go up, yields also go up',
          'When bond prices go UP, the interest rate (yield) they effectively pay goes DOWN',
          'There is no relationship between them',
          'Bond prices only move once a year',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Think of a see-saw. If people rush to buy safe bonds (pushing the price up), the new buyers get a smaller "slice" of interest.',
        correctExplanation:
            'This relationship is vital because it means if the market crashes and people buy bonds for safety, your existing bonds become MORE valuable.',
      ),
      QuizQuestion(
        question: 'What are "Junk Bonds" (High-Yield Bonds)?',
        options: [
          'Bonds issued by trash companies',
          'Bonds from companies with a high risk of "Default," which must pay very high interest to attract lenders',
          'Bonds that have no value at all',
          'A type of fake gem used by scammers',
        ],
        correctIndex: 1,
        wrongExplanation:
            'They aren\'t "junk" because they are worthless; they are junk because they are "Higher Risk." You get more gems, but the company might go broke.',
        correctExplanation:
            'Professional investors use junk bonds to "juice" their returns in a strong economy.',
      ),
      QuizQuestion(
        question: 'What is "Bond Duration"?',
        options: [
          'How many years until the bond ends',
          'A measure of how sensitive a bond\'s price is to changes in interest rates',
          'The length of the bond contract document',
          'The number of people who own the bond',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It isn\'t just time. High duration means if interest rates rise by 1%, your bond price might drop by 10%. It is a measure of "Interest Rate Risk."',
        correctExplanation:
            'Long-term bonds (30 years) have much higher duration (risk) than short-term bonds (2 years).',
      ),
      QuizQuestion(
        question: 'What is a "Treasury Bill" (T-Bill) considered to be?',
        options: [
          'The riskiest investment in the world',
          'A "Risk-Free Asset" because it is backed by the full power of the government',
          'A type of paper gems',
          'A bill you get when you visit a museum',
        ],
        correctIndex: 1,
        wrongExplanation:
            'While nothing is truly 100% safe, T-Bills are the closest thing. Every other investment is compared to the "Risk-Free" rate of a T-Bill.',
        correctExplanation:
            'When the world is scared, everyone sells everything to hide their gems in T-Bills.',
      ),
      QuizQuestion(
        question: 'What is "Credit Rating" for a bond?',
        options: [
          'The amount of gems the bond costs',
          'A grade (like AAA or B-) representing how likely the borrower is to pay back the gems',
          'A way to pay for things without cash',
          'A score given to the investor',
        ],
        correctIndex: 1,
        wrongExplanation:
            'AAA is "Safe" (low interest). C or D is "Dangerous" (high interest). Always check the rating before lending your gems to a company.',
        correctExplanation:
            'Agencies like Moody\'s or S&P are paid to "grade" bonds so you don\'t have to be a detective yourself.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q18',
    title: 'REITs & Alternatives',
    subtitle: 'Beyond just stocks and bonds',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is a "REIT" (Real Estate Investment Trust)?',
        options: [
          'A company that builds houses and sells them',
          'A company that owns and manages income-producing real estate and pays most profits to shareholders as dividends',
          'A tax that you pay when you buy a house',
          'A rule that prevents you from owning land',
        ],
        correctIndex: 1,
        wrongExplanation:
            'REITs allow you to own pieces of 💎100,000,000 malls, hotels, and apartments without ever needing to fix a toilet yourself.',
        correctExplanation:
            'By law, REITs must pay out 90% of their taxable income to you. They are excellent for generating a "passive income" stream.',
      ),
      QuizQuestion(
        question: 'Why is "Gold" often called a "Hedge against Inflation"?',
        options: [
          'Because its price never changes',
          'Because it is a physical asset with a limited supply that historically holds value when paper currency is being printed',
          'Because it is shiny and people like it',
          'Because the government requires everyone to own it',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Gold doesn\'t "grow" or pay dividends. It just "sits there." Its value is that it can\'t be printed out of thin air like gems or dollars.',
        correctExplanation:
            'Many investors keep 5% of their wealth in Gold as "Insurance" for the end of the world.',
      ),
      QuizQuestion(
        question: 'What is "Commodity" investing?',
        options: [
          'Buying shares in a clothing company',
          'Investing in raw materials like Oil, Wheat, Coffee, or Copper',
          'Buying things you need every day',
          'Trading items with your neighbors',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Commodities are the "fuel" of the world. Their prices are driven by global "Supply and Demand" (like a war in an oil country).',
        correctExplanation:
            'Commodity prices are very volatile and usually move differently than stocks, making them good for diversification.',
      ),
      QuizQuestion(
        question: 'What is "Cryptocurrency" (at a systemic level)?',
        options: [
          'A type of video game gem',
          'A decentralized digital currency that use cryptography and a blockchain to secure transactions and control the supply',
          'A secret way to hide gems from the bank',
          'A new type of computer processor',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The key word is "Decentralized." There is no "Fed" or "Government" that can print more Bitcoin or devaluate it.',
        correctExplanation:
            'Crypto is a brand-new "Asset Class" (like a digital version of Gold) but it is extremely high-risk compared to traditional assets.',
      ),
      QuizQuestion(
        question: 'What is "Liquidity" in an investment?',
        options: [
          'How much gems the interest pays',
          'How quickly and easily an asset can be turned into spendable gems without losing value',
          'The amount of water a factory uses',
          'The name of the bank owner',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Cash is "perfectly liquid." A house is "illiquid" because it takes 6 months to sell. If you have an emergency, you can\'t eat a piece of your house.',
        correctExplanation:
            'Always keep an "Emergency Fund" of highly liquid gems (cash/savings) so you never have to sell your illiquid assets in a panic.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q19',
    title: 'DCF & Net Present Value',
    subtitle: 'The math of legendary investors',
    difficulty: QuizDifficulty.hard,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question:
            'What is the goal of a "Discounted Cash Flow" (DCF) analysis?',
        options: [
          'To count how many gems are currently in the bank',
          'To estimate the value of an investment today based on projections of how many gems it will generate in the future',
          'To find out which stock is the most popular',
          'To calculate the cost of a company\'s products',
        ],
        correctIndex: 1,
        wrongExplanation:
            'DCF is "intrinsic valuation." It doesn\'t care about the stock market price. It asks: "If I buy this whole business and keep all the gems it makes forever, what is that worth to me right now?"',
        correctExplanation:
            'DCF is the tool used by professionals (like Warren Buffett) to find "Underpriced" stocks that the market hasn\'t noticed yet.',
      ),
      QuizQuestion(
        question: 'What is "Net Present Value" (NPV)?',
        options: [
          'The total amount of gems you have',
          'the difference between the present value of cash inflows and the present value of cash outflows over a period of time',
          'A tax on your profits',
          'The value of a company after it goes bankrupt',
        ],
        correctIndex: 1,
        wrongExplanation:
            'NPV answers: "Is this project worth doing?" If NPV is POSITIVE, it means the investment will create more wealth than it costs (including interest).',
        correctExplanation:
            'Companies only build new factories or launch products if the NPV calculation shows they will gain a net profit in today\'s 💎s.',
      ),
      QuizQuestion(
        question: 'In a DCF, what is the "Terminal Value"?',
        options: [
          'The value of a company when it closes down',
          'The estimated value of a business beyond the initial projection period (usually assuming it grows forever at a steady rate)',
          'The gems paid to the CEO',
          'The total debt of the company',
        ],
        correctIndex: 1,
        wrongExplanation:
            'You can\'t project every single year for 100 years. You project 5-10 years, and then use a "Terminal Value" formula for the infinite future.',
        correctExplanation:
            'Terminal Value often makes up 70% or more of a total DCF valuation, making it a very sensitive and important number.',
      ),
      QuizQuestion(
        question: 'What is "WACC" (Weighted Average Cost of Capital)?',
        options: [
          'A type of legal contract',
          'The average interest rate a company pays to all its lenders and investors for the gems they provided',
          'The cost of running a website',
          'The percentage of gems spent on advertising',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Gems aren\'t free! WACC is the "Hurdle Rate." If a business investment doesn\'t earn more than its WACC, it is actually LOSING wealth for its owners.',
        correctExplanation:
            'Valuators use WACC as the "Discount Rate" in their DCF to see if a business is truly profitable.',
      ),
      QuizQuestion(
        question: 'What is "Free Cash Flow" (FCF)?',
        options: [
          'Gems that are given away for free',
          'The gems a company has left over after paying for all its operating expenses and new equipment (CapEx)',
          'A loan that has no interest',
          'The total revenue of a business',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Profit is an accounting number; FCF is "REAL GEMS." You can\'t pay dividends or buy other companies with profit—only with Free Cash Flow.',
        correctExplanation:
            'FCF is considered the "Lifeblood" of a corporation. Investors look for companies with "fat" cash flow and low debt.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q20',
    title: 'Arbitrage & HFT',
    subtitle: 'The 💎speed of light in finance',
    difficulty: QuizDifficulty.hard,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is "Arbitrage"?',
        options: [
          'A legal rule for resolving disputes',
          'The simultaneous purchase and sale of the same asset in different markets to profit from tiny price differences',
          'Buying a stock and holding it for 50 years',
          'A way to save on your taxes',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If Gold is 💎1,000 in London and 💎1,001 in New York, an arbitrageur buys it in London and sells it in NY at the same time for a "Risk-Free" 💎1 profit.',
        correctExplanation:
            'Arbitrage is the "Force of Nature" that keeps prices equal across the whole world.',
      ),
      QuizQuestion(
        question: 'What is "High-Frequency Trading" (HFT)?',
        options: [
          'Trading stocks once a day',
          'Using powerful computers to execute thousands of trades in fractions of a second (milliseconds)',
          'A way to trade stocks without using a computer',
          'A rule that limits how fast you can sell',
        ],
        correctIndex: 1,
        wrongExplanation:
            'HFT isn\'t about human thinking. It is about "Latency." The faster your computer and your fiber-optic cables, the more gems you can make.',
        correctExplanation:
            'HFT firms provide "Liquidity" to the market, but they can also cause "Flash Crashes" where the market drops and recovers in seconds.',
      ),
      QuizQuestion(
        question: 'What is a "Market Maker"?',
        options: [
          'The person who invented the stock exchange',
          'A firm that stands ready to both buy and sell a stock at all times, profiting from the "Bid-Ask Spread"',
          'A company that sells marketing services',
          'A government regulator',
        ],
        correctIndex: 1,
        wrongExplanation:
            'They don\'t care if the price goes up or down. They just want the "Spread" (the 1-cent difference between the buy and sell price) on millions of trades.',
        correctExplanation:
            'Without market makers, you wouldn\'t be able to sell your shares instantly when you need gems.',
      ),
      QuizQuestion(
        question: 'What is "Dark Pool" trading?',
        options: [
          'Illegal trading of stolen gems',
          'Private exchanges where large banks and "Whale" investors trade massive blocks of shares without the public seeing the price',
          'Trading that only happens at night',
          'A way to trade gems in a swimming pool',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If a billionaire sells 10,000,000 shares on the public exchange, the price would crash instantly. Dark pools allow them to find a buyer quietly.',
        correctExplanation:
            'While legal, dark pools are controversial because they reduce the "Transparency" of the overall market.',
      ),
      QuizQuestion(
        question: 'What is "Algorithmic Trading"?',
        options: [
          'Trading stocks based on what you see in the news',
          'Using pre-programmed mathematical "Rules" to execute trades automatically based on price, volume, or timing',
          'A way to avoid using math in finance',
          'A system where the government picks your stocks',
        ],
        correctIndex: 1,
        wrongExplanation:
            'An algorithm might say: "If the 50-day average moves above the 200-day average, buy 💎10,000 worth of shares." It never gets tired or emotional.',
        correctExplanation:
            'Today, over 80% of all trading in the stock market is done by algorithms, not humans.',
      ),
    ],
  ),
];

final List<QuizMetadata> _level5Quizzes = [
  // Quiz 1-3: Easy (Professional Fundamentals)
  QuizMetadata(
    id: 'l5_q1',
    title: 'Advanced Balance Sheet Metrics',
    subtitle: 'Liquidity & Solvency Analysis',
    difficulty: QuizDifficulty.easy,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question:
            'Which of the following is the "strictest" measure of a company\'s immediate liquidity?',
        options: [
          'Current Ratio',
          'Quick Ratio (Acid-Test Ratio)',
          'Debt-to-Equity Ratio',
          'Total Asset Turnover',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The Current Ratio includes inventory, which might take months to sell. The Quick Ratio subtracts inventory, showing only the gems that are TRULY available right now.',
        correctExplanation:
            'A Quick Ratio above 1.0 means the company can pay all its current bills without selling a single piece of inventory—a hallmark of financial strength.',
      ),
      QuizQuestion(
        question: 'What does a "Current Ratio" of 1.2 mean?',
        options: [
          'The company has 💎1.20 in current assets for every 💎1.00 of current liabilities',
          'The company is bankrupt',
          'The company has 120 employees',
          'The company made 20% profit this year',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Ratio = Division. 1.2 means assets are 20% higher than liabilities. If it drops below 1.0, the company might not be able to pay its short-term debts.',
        correctExplanation:
            'While 1.2 is generally safe, professional analysts compare this to the industry average to see if the company is lagging behind.',
      ),
      QuizQuestion(
        question: 'What is "Working Capital" in professional accounting?',
        options: [
          'The total amount of gems the CEO earns',
          'Current Assets minus Current Liabilities',
          'The value of the company\'s buildings',
          'The total debt of the company',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Working capital is the "oil" in the engine. If it is negative, the engine (the business) will likely seize up and stop functioning.',
        correctExplanation:
            'Positive working capital ensures that a business can continue its operations and has sufficient gems to meet both short-term debt and upcoming operational expenses.',
      ),
      QuizQuestion(
        question: 'What is the "Debt-to-Equity" ratio used to measure?',
        options: [
          'How much profit the company makes',
          'Financial Leverage (how much the company is funded by debt vs. owners)',
          'The number of shares in the market',
          'The amount of taxes owed',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you have 💎100 in debt and 💎10 in equity, your ratio is 10. This is very "Aggressive" and dangerous if profits drop.',
        correctExplanation:
            'Conservative companies keep this ratio low to ensure they can survive economic downturns without the bank taking their assets.',
      ),
      QuizQuestion(
        question: 'What is "Solvency"?',
        options: [
          'The ability to turn assets into gems quickly',
          'The ability of a business to meet its long-term financial obligations',
          'Winning a legal case in court',
          'A type of cleaning chemical for factories',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Liquidity is about the next 30 days. Solvency is about the next 30 YEARS. A company can be liquid but insolvent if its total debts are higher than its total assets.',
        correctExplanation:
            'Professional auditors must sign off on a "Going Concern" statement, confirming they believe the company is solvent for at least another year.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q2',
    title: 'Professional Auditing Scope',
    subtitle: 'The guardians of financial truth',
    difficulty: QuizDifficulty.easy,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What is "Materiality" in auditing?',
        options: [
          'The physical weight of the gold in the vault',
          'The threshold above which a financial error or omission would influence the decision of an investor',
          'The total cost of the audit fee',
          'A list of all the materials used in a product',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Auditors don\'t check every single 💎1 transaction. They set a "Materiality" level (e.g., 💎50,000). If an error is below that, they might ignore it.',
        correctExplanation:
            'Materiality is a matter of "Professional Judgment" and varies based on the size and nature of the company.',
      ),
      QuizQuestion(
        question: 'What is "Professional Skepticism"?',
        options: [
          'Assuming the client is always lying',
          'An attitude that includes a questioning mind and a critical assessment of audit evidence',
          'Being rude to the company management',
          'A refusal to believe any numbers provided',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Auditors don\'t assume fraud, but they don\'t assume honesty either. They require "Evidence" to back up every claim made by the company.',
        correctExplanation:
            'Skepticism is the most important trait for an auditor to prevent being "fooled" by clever accounting tricks.',
      ),
      QuizQuestion(
        question: 'What is an "External Audit"?',
        options: [
          'An audit of the building\'s exterior',
          'An independent examination of financial statements by a third-party firm (CPA)',
          'When the CEO checks their own bank account',
          'A review of the company by its own employees',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Internal audits are done by employees. External audits are done by outside firms (like the Big 4) to give "Assurance" to the public.',
        correctExplanation:
            'Publicly traded companies are REQUIRED by law to have an external audit every year to protect investors.',
      ),
      QuizQuestion(
        question: 'What does "Audit Independence" mean?',
        options: [
          'The auditor doesn\'t need any help from the client',
          'The auditor has no financial or personal connection to the client that could bias their report',
          'The auditor works from home',
          'The auditor doesn\'t use any standard rules',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If an auditor owns stock in the company they are auditing, they have a "Conflict of Interest." They might hide bad news to protect their own 💎s.',
        correctExplanation:
            'Independence is the "Bedrock" of the profession. Without it, the audit report has zero value to the market.',
      ),
      QuizQuestion(
        question: 'What is a "Qualified Opinion"?',
        options: [
          'An opinion given by a very smart person',
          'A report stating that the financial statements are mostly fair, EXCEPT for one specific area or issue',
          'A report that says everything is perfect',
          'A type of legal certificate',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A "Clean" opinion is what you want. A "Qualified" opinion is a "Yellow Flag"—it means the auditor found something they don\'t like.',
        correctExplanation:
            'If the auditor finds massive fraud, they give a "Disclaimer" or an "Adverse Opinion," which usually causes the stock price to crash.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q3',
    title: 'Professional TVM Applications',
    subtitle: 'Advanced Capital Budgeting',
    difficulty: QuizDifficulty.easy,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question:
            'When comparing two "Mutually Exclusive" projects with unequal lives, what tool is best?',
        options: [
          'Net Present Value (NPV)',
          'Equivalent Annual Annuity (EAA)',
          'Internal Rate of Return (IRR)',
          'Payback Period',
        ],
        correctIndex: 1,
        wrongExplanation:
            'NPV works for projects with the same length. If Project A is 3 years and Project B is 10 years, you must use EAA to see which one creates more wealth PER YEAR.',
        correctExplanation:
            'EAA converts the total NPV of each project into a steady "annual payment" that makes them easy to compare.',
      ),
      QuizQuestion(
        question: 'What is "Capital Rationing"?',
        options: [
          'When a company has too many gems and doesn\'t know what to do',
          'When a company has limited gems and must choose only the BEST projects from many profitable ones',
          'A tax on the company\'s capital',
          'Giving everyone in the company an equal share of profit',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Even a profitable company can\'t do EVERYTHING. If you have 💎1,000,000 but three 💎500,000 projects, you must "ration" your capital.',
        correctExplanation:
            'The goal of rationing is to pick the "Combination" of projects that results in the HIGHEST total NPV.',
      ),
      QuizQuestion(
        question: 'What is the "Profitability Index" (PI)?',
        options: [
          'The total profit of the company',
          'The Present Value of inflows divided by the Initial Investment',
          'A list of the company\'s best products',
          'The amount of gems spent on advertising',
        ],
        correctIndex: 1,
        wrongExplanation:
            'PI shows "Bang for your Buck." A PI of 1.2 means for every 💎1 you invest, you get back 💎1.20 in present value.',
        correctExplanation:
            'PI is the perfect tool for working under "Capital Rationing" because it ranks projects by their efficiency.',
      ),
      QuizQuestion(
        question: 'What is an "Opportunity Cost of Capital"?',
        options: [
          'The cost of hiring a new manager',
          'The return that could have been earned by investing the gems in the NEXT BEST alternative',
          'A fine for missing a business meeting',
          'The interest rate charged by the bank',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you put gems in a project that earns 5%, but you could have earned 10% in the stock market, your "true" cost is that missing 10%.',
        correctExplanation:
            'Professionals use the "Hurdle Rate" to ensure they are never doing a project that earns less than their opportunity cost.',
      ),
      QuizQuestion(
        question: 'What is "Sensitivity Analysis" in a financial model?',
        options: [
          'Being careful not to hurt the client\'s feelings',
          'Changing one variable (like sales growth) to see how it affects the total NPV',
          'Searching for errors in the spreadsheet',
          'A review of the company\'s social media accounts',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Models are just guesses. Sensitivity analysis tells you: "If our sales are 10% lower than we think, is the project still worth it?"',
        correctExplanation:
            'Identifying "Critical Variables" (the ones that change the result the most) is the mark of a pro financial analyst.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q4',
    title: 'Consolidation & Goodwill',
    subtitle: 'Professional Group Accounting',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question:
            'When a Parent company owns 80% of a Subsidiary, what is the remaining 20% called on the balance sheet?',
        options: [
          'Minority Debt',
          'Non-Controlling Interest (NCI)',
          'Owners\' Equity',
          'Retained Earnings',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It isn\'t "Debt" because the company doesn\'t owe it back. It is the "Ownership" of the other 20% of investors who aren\'t the parent.',
        correctExplanation:
            'NCI ensures that the consolidated balance sheet accurately shows that while the Parent controls the assets, they don\'t "own" every single gem of the value.',
      ),
      QuizQuestion(
        question: 'How is "Goodwill" calculated in an acquisition?',
        options: [
          'Purchase Price - Book Value of Assets',
          'Purchase Price - Fair Value of Net Identifiable Assets',
          'Total Revenue - Total Expenses',
          'The value of the company\'s brand name only',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Book Value is just a historical number. You must use "Fair Value" (what the assets are worth today). If you pay 💎1,000,000 for 💎800,000 in assets, you have 💎200,000 in Goodwill.',
        correctExplanation:
            'Goodwill represents "unidentifiable" assets like brand reputation, customer loyalty, and synergistic value that cannot be sold separately.',
      ),
      QuizQuestion(
        question: 'What is an "Intra-group Transaction" in consolidation?',
        options: [
          'A trade between two different countries',
          'Sales or loans between a Parent and its Subsidiary that must be ELIMINATED during consolidation',
          'A secret deal with a competitor',
          'Buying shares of your own company',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you sell a pen to yourself for 💎100, you haven\'t made 💎100. In group accounting, "internal" sales must be erased so only "outside" gems are counted.',
        correctExplanation:
            'Eliminating these transactions prevents the group from "inflating" its revenue numbers by trading with its own companies.',
      ),
      QuizQuestion(
        question: 'What is the "Full Goodwill" method?',
        options: [
          'Counting every single asset as goodwill',
          'A method where goodwill is calculated for both the parent\'s share AND the NCI\'s share',
          'Spending all your gems on advertising',
          'A way to avoid paying taxes on acquisitions',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The alternative is "Partial Goodwill." Full Goodwill provides a more complete picture of what the WHOLE company is worth, including the 20% not owned by the parent.',
        correctExplanation:
            'Full Goodwill is required under IFRS standards to ensure transparency for all shareholders.',
      ),
      QuizQuestion(
        question: 'When does "Impairment of Goodwill" occur?',
        options: [
          'When the company pays a dividend',
          'When the Fair Value of a reporting unit drops below its Carrying Amount on the books',
          'When an employee is injured',
          'When the stock market closes for a holiday',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Goodwill is never "depreciated." It is only checked once a year for impairment. If the 💎200,000 value you paid for "reputation" is now only worth 💎100,000, you must record a loss.',
        correctExplanation:
            'Impairment tests are high-stakes! A massive impairment charge can wipe out a year\'s worth of profit and crash the stock price.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q5',
    title: 'Accounting Standards & Assets',
    subtitle: 'IFRS & GAAP Professional Rules',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What is the "Componentization" of Fixed Assets?',
        options: [
          'Building a product from many small parts',
          'Treating significant parts of an asset (like an airplane engine) as separate assets with their own depreciation lives',
          'Selling off pieces of the company to competitors',
          'Buying parts from different suppliers',
        ],
        correctIndex: 1,
        wrongExplanation:
            'An airplane might last 30 years, but the engine only lasts 10. Professionally, you must depreciate the engine faster than the wings to be accurate.',
        correctExplanation:
            'This provides a much more realistic view of when the company will need to spend massive gems on replacements.',
      ),
      QuizQuestion(
        question: 'What is "Fair Value Hierarchy" Level 1?',
        options: [
          'Assets that have no value',
          'Assets with quoted prices in active markets for identical items (like stocks)',
          'Assets that can only be valued by experts',
          'Assets that are owned by the government',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Level 1 is the "Gold Standard." You can look at the screen and see exactly what it\'s worth. Level 3 (the hardest) requires models and "guesses."',
        correctExplanation:
            'Regulators prefer Level 1 valuations because they are the hardest to manipulate or fake.',
      ),
      QuizQuestion(
        question: 'Under IFRS, what is the "Revaluation Model"?',
        options: [
          'A way to hide losses from the public',
          'A method allowing companies to adjust the value of assets UP to their current fair market value',
          'Charging more for products to cover costs',
          'Changing the name of the company\'s brand',
        ],
        correctIndex: 1,
        wrongExplanation:
            'US GAAP usually forbids this (you stay at historical cost). IFRS allows it, which can make a company\'s 💎 balance sheet look much stronger if land or buildings go up.',
        correctExplanation:
            'Any gain from revaluation is usually tucked away in "Other Comprehensive Income" (OCI) so it doesn\'t inflate normal profit.',
      ),
      QuizQuestion(
        question: 'What is "Investment Property" (IAS 40)?',
        options: [
          'A building where the company holds its meetings',
          'Property held to earn rentals or for capital appreciation, rather than for the company\'s own use',
          'A type of low-cost housing for employees',
          'A property owned by the company\'s bank',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If the company works in the building, it\'s an "Owner-Occupied" asset. If they just rent it out to others, it\'s an Investment Property with different accounting rules.',
        correctExplanation:
            'Investment properties can often be recorded at Fair Value, with any 💎 profit going directly to the income statement every year!',
      ),
      QuizQuestion(
        question: 'What is the "Impairment Loss" formula for an asset?',
        options: [
          'Carrying Amount - Net Income',
          'Carrying Amount - Recoverable Amount',
          'Total Assets - Total Debt',
          'Purchase Price - Depreciation',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Recoverable Amount is the HIGHER of: 1) What you could sell it for today, or 2) The value of the gems it will make you if you keep using it.',
        correctExplanation:
            'If your factory is on the books for 💎1M but it\'s only worth 💎600k, you have an impairment loss of 💎400k.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q6',
    title: 'Audit Evidence & Logic',
    subtitle: 'Building a bulletproof case',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What is the "Reliability Hierarchy" of audit evidence?',
        options: [
          'Information from the CEO is most reliable',
          'Evidence obtained directly from external third parties is more reliable than internal company documents',
          'All information is equal to an auditor',
          'Photos are the only reliable evidence',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Management can print a fake bank statement. A letter SENT DIRECTLY FROM THE BANK to the auditor is much harder to fake.',
        correctExplanation:
            'External confirmations (like from banks or customers) are the most powerful "weapons" in an auditor\'s arsenal.',
      ),
      QuizQuestion(
        question: 'What is "Substantive Testing"?',
        options: [
          'Testing the company\'s air quality',
          'Audit procedures designed to detect material misstatements at the assertion level (testing the actual numbers)',
          'A review of the company\'s mission statement',
          'Testing how fast employees can work',
        ],
        correctIndex: 1,
        wrongExplanation:
            'This is the "Digging" phase. You don\'t just ask if the computer works; you check 100 actual receipts to see if the gems were spent correctly.',
        correctExplanation:
            'Every audit must include substantive testing to ensure the 💎 values on the balance sheet actually exist.',
      ),
      QuizQuestion(
        question: 'What does "Tolerable Error" mean in audit sampling?',
        options: [
          'The number of typos allowed in a report',
          'The maximum error in a population that the auditor is willing to accept without concluding it\'s material',
          'A mistake that the CEO is allowed to make',
          'The amount of gems a company can lose without closing',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you check 100 items and find 💎1 missing, is that a problem? Tolerable error is the "Line in the Sand" the auditor draws before sounding the alarm.',
        correctExplanation:
            'If the estimated error from your sample is higher than the tolerable error, you must "Reject" the whole account and dig deeper.',
      ),
      QuizQuestion(
        question: 'What is an "Analytical Procedure"?',
        options: [
          'A procedure done by a very analytical person',
          'Evaluations of financial information through analysis of plausible relationships (like comparing 💎 revenue to last year)',
          'A type of computer repair',
          'A way to train new auditors',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If the company says revenue went up 50% but the factory used 10% LESS electricity, something is wrong. The "Relationship" doesn\'t make sense.',
        correctExplanation:
            'Analytical procedures help auditors spot "Smell Tests" that don\'t add up before they spend gems on more expensive testing.',
      ),
      QuizQuestion(
        question: 'What is "Inherent Risk"?',
        options: [
          'The risk of a building catching fire',
          'The susceptibility of an account to an error before considering any internal controls (e.g., cash is high risk)',
          'The risk of the auditor losing their job',
          'A risk that is required by law',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A 💎100,000,000 inventory of Diamonds is "inherently" riskier to lose or steal than a 💎100,000,000 inventory of Concrete Pipes.',
        correctExplanation:
            'Auditors focus most of their gems and time on areas with high inherent risk.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q7',
    title: 'Advanced Cost of Capital',
    subtitle: 'WACC & Flotation Complexity',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'Why do we use the "Post-Tax" cost of debt in WACC?',
        options: [
          'Because the bank requires it',
          'Because interest payments are tax-deductible, reducing the actual 💎 cost to the company',
          'Because taxes are unpaid debt',
          'To make the calculation look more professional',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you pay 10% interest but get a 30% tax break, your "True" cost of debt is only 7%. The government is effectively paying 30% of your interest.',
        correctExplanation:
            'This "Tax Shield" is why companies often prefer borrowing gems rather than selling more shares of the company.',
      ),
      QuizQuestion(
        question: 'What is the "Market Value Weight" rule for WACC?',
        options: [
          'Weighting assets by how much they weigh in kilograms',
          'Using the current market price of stocks and bonds to calculate their percentage of the total capital, not their book value',
          'A rule that requires you to trade in the morning',
          'A tax on the value of the market',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Book value represents the past; Market value represents the PRESENT cost of gems. Professional WACC must always use market prices.',
        correctExplanation:
            'If a company has 1M shares at 💎10 and 💎5M in debt, the weights are approx 66% Equity and 33% Debt.',
      ),
      QuizQuestion(
        question: 'What are "Flotation Costs"?',
        options: [
          'The cost of keeping a boat in the harbor',
          'The underwriting, legal, and banking fees a company must pay to issue NEW stocks or bonds',
          'The gems lost to inflation every year',
          'The cost of moving a factory',
        ],
        correctIndex: 1,
        wrongExplanation:
            'New gems aren\'t free to raise. If you want 💎1,000,000, the bank might take 💎50,000 in fees. You only get 💎950,000, which makes your cost of capital higher.',
        correctExplanation:
            'Flotation costs are usually included by "Adjusting" the initial investment in an NPV model.',
      ),
      QuizQuestion(
        question: 'What is the "Marginal Cost of Capital" (MCC)?',
        options: [
          'The cost of the very first gem the company ever borrowed',
          'The cost of raising the NEXT additional 💎1 of new capital',
          'The cost of paying for minor repairs',
          'A cost that is at the margin of error',
        ],
        correctIndex: 1,
        wrongExplanation:
            'As a company borrows more and more gems, the bank gets scared and raises the interest rate. The "Last" 💎1 you borrow is always more expensive than the "First" 💎1.',
        correctExplanation:
            'The MCC schedule shows that a company\'s cost of capital increases as it tries to grow too fast.',
      ),
      QuizQuestion(
        question: 'What is "Beta" (β) in the CAPM formula?',
        options: [
          'A type of software test',
          'A measure of how much a stock\'s return fluctuates compared to the overall market',
          'The second best bank in the country',
          'The amount of profit a company makes',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A Beta of 2.0 means if the market goes up 1%, the stock goes up 2%. If the market drops 1%, the stock drops 2%. It is the measure of "Riskiness."',
        correctExplanation:
            'In CAPM, the higher the Beta, the more gems investors DEMAND as a return for taking the risk.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q8',
    title: 'Revenue Recognition',
    subtitle: 'IFRS 15: The Five-Step Model',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What is the "First Step" in the IFRS 15 revenue model?',
        options: [
          'Calculating the profit',
          'Identifying the contract(s) with the customer',
          'Sending an invoice immediately',
          'Counting the inventory',
        ],
        correctIndex: 1,
        wrongExplanation:
            'You can\'t record a single gem of revenue until you have a valid, legal contract where both sides are committed to the deal.',
        correctExplanation:
            'This step ensures that revenue is only recognized when a real transaction has actually been agreed upon.',
      ),
      QuizQuestion(
        question: 'What is a "Performance Obligation" (PO)?',
        options: [
          'The requirement for employees to wear a uniform',
          'A promise in a contract to transfer a distinct good or service to a customer',
          'A type of musical show',
          'The amount of gems the office rent costs',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you sell a phone AND a 1-year service plan, you have TWO POs. You must split the gems between them and recognize them at different times.',
        correctExplanation:
            'Identifying distinct POs prevents companies from "front-loading" revenue for services they haven\'t yet provided.',
      ),
      QuizQuestion(
        question: 'What is "Variable Consideration"?',
        options: [
          'Being nice to different customers',
          'Portions of the price that are uncertain (like bonuses, discounts, or refunds)',
          'A type of changing tax rate',
          'Buying different types of assets',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you might get a 💎10,000 bonus for finishing early, you can only record it if it is "Highly Probable." You can\'t be an optimist in accounting!',
        correctExplanation:
            'Companies must estimate variable gems using either the "Expected Value" or "Most Likely Amount" method.',
      ),
      QuizQuestion(
        question: 'When is revenue recognized for a "Point in Time" sale?',
        options: [
          'When the customer pays the gems',
          'When "Control" of the asset is transferred to the customer (e.g., they walk out with the item)',
          'Daily for the life of the product',
          'On the last day of the year',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It isn\'t about the gems; it\'s about the "Control." If you have the item but haven\'t paid yet, the store might already record the revenue.',
        correctExplanation:
            'Transfer of control includes having the right to payment, legal title, and physical possession.',
      ),
      QuizQuestion(
        question: 'What is "Revenue Over Time" (Percentage of Completion)?',
        options: [
          'Revenue that is only recorded after 10 years',
          'Recognizing revenue as the work is performed (common in long-term construction like building a city bridge)',
          'A way to delay paying your taxes',
          'Subtracting revenue from expenses',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you spend 3 years building a stadium, you don\'t wait until year 3 to record revenue. You record a piece of it as you lay each 💎 brick.',
        correctExplanation:
            'This matches the "Effort" with the "Reward," giving a better picture of the company\'s annual progress.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q9',
    title: 'Forex Exposure Management',
    subtitle: 'Translation, Transaction & Economic',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What is "Transaction Exposure" in Forex?',
        options: [
          'The risk that the exchange rate will change before a specific 💎 payment is completed',
          'The risk of the bank being closed',
          'The risk of the building losing value',
          'A tax on every transaction',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If you buy a car for 100 Euros today but pay in 30 days, and the Euro gets 50% more expensive, you lose gems. This is a specific transaction risk.',
        correctExplanation:
            'Transaction exposure is "Realized"—it affects the actual gems leaving your bank account.',
      ),
      QuizQuestion(
        question: 'What is "Translation Exposure" (Accounting Exposure)?',
        options: [
          'The cost of hiring a translator',
          'The risk that a subsidiary\'s financial statements will look worse when converted to the parent\'s 💎 currency for reporting',
          'Translating documents for an audit',
          'A change in the company\'s brand name',
        ],
        correctIndex: 1,
        wrongExplanation:
            'This is often purely "On Paper." The company hasn\'t actually lost gems yet, but their balance sheet looks smaller because of exchange rates.',
        correctExplanation:
            'While it may not affect cash flow today, translation exposure can affect a company\'s credit rating and stock price perceptions.',
      ),
      QuizQuestion(
        question: 'What is "Economic Exposure" (Operating Exposure)?',
        options: [
          'When the whole economy goes into a recession',
          'The risk that exchange rate changes will affect a company\'s long-term competitive position and future 💎 cash flows',
          'A tax on the country\'s total wealth',
          'The cost of running a factory overseas',
        ],
        correctIndex: 1,
        wrongExplanation:
            'This is the deepest risk. If your currency becomes too "Strong," no one overseas can afford your products, and you go broke over several years.',
        correctExplanation:
            'Economic exposure is hard to measure but vital for "Strategic" planning in global companies.',
      ),
      QuizQuestion(
        question: 'What is a "Money Market Hedge"?',
        options: [
          'Buying a fence for the bank',
          'Hedging Forex risk by borrowing or lending gems in the local and foreign markets simultaneously',
          'Buying stocks in different countries',
          'A way to get free interest from the government',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you are owed 100 Euros, you borrow 90 Euros today, convert them to 💎s, and invest them. You use the 100 Euros you get later to pay back the loan. No more risk!',
        correctExplanation:
            'Money market hedges are a professional alternative to Forward contracts, often used when banks charge too much for Forwards.',
      ),
      QuizQuestion(
        question: 'What is "Netting" in global treasury management?',
        options: [
          'Catching fish for the company cafeteria',
          'Combining all internal 💎 flows between subsidiaries and only paying the final "Net" difference',
          'A tax on the total revenue',
          'A way to hide gems from the auditor',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If Sub A owes Sub B 💎100, and Sub B owes Sub A 💎80, they only send 💎20. This saves massive amounts in bank fees and Forex spreads.',
        correctExplanation:
            'Large global "whales" use netting to run their entire world empire using the smallest possible amount of liquid gems.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q10',
    title: 'Professional Derivatives',
    subtitle: 'Forwards vs Futures Mechanics',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question:
            'What is the primary difference between a "Forward" and a "Future" contract?',
        options: [
          'Forwards are only for the future',
          'Forwards are customized/private (OTC), while Futures are standardized and traded on an exchange',
          'Futures are much cheaper',
          'Forwards are illegal for small businesses',
        ],
        correctIndex: 1,
        wrongExplanation:
            'In a Forward, you and the bank agree on any amount and date. In a Future, you must buy exactly 1 "Contract" (e.g., 2,500 bushels) on a fixed date.',
        correctExplanation:
            'Because Futures are on an exchange, they are much more "Liquid" (easier to sell) than private Forwards.',
      ),
      QuizQuestion(
        question: 'What is "Marking-to-Market" in futures trading?',
        options: [
          'Painting the exchange building',
          'The daily process of settling profits and losses in a trader\'s account based on the closing price',
          'A way to choose which stocks to buy',
          'A tax on the total number of trades',
        ],
        correctIndex: 1,
        wrongExplanation:
            'You don\'t wait until the end. If you lose 💎100 today, the exchange TAKES 💎100 from your account TONIGHT. If you run out of gems, you are kicked out.',
        correctExplanation:
            'Daily settling prevents "default risk"—it ensures that every loser has enough gems to pay Every day.',
      ),
      QuizQuestion(
        question: 'What is a "Maintenance Margin"?',
        options: [
          'The cost of repairing the office',
          'The minimum amount of gems that MUST remain in a futures account at all times',
          'The profit made by a bank',
          'A type of insurance for traders',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If your account drops below this level, you get a "Margin Call." You must add more gems immediately or your position is closed at a loss.',
        correctExplanation:
            'Margins allow traders to use "Leverage," controlling large amounts of assets with a small amount of 💎s.',
      ),
      QuizQuestion(
        question: 'What does "Contango" mean in the futures market?',
        options: [
          'A type of dance for CEOs',
          'When the futures price is HIGHER than the current spot price',
          'When the market is closed for a holiday',
          'A way to save on trading fees',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you want corn in 6 months, it costs more than corn today because of the "Cost of Carry" (storage and interest). This is a normal market.',
        correctExplanation:
            'The opposite of Contango is "Backwardation," which usually happens during a shortage when people need gems or goods RIGHT NOW.',
      ),
      QuizQuestion(
        question: 'What is an "Option Premium"?',
        options: [
          'The highest price a stock ever reached',
          'The non-refundable 💎 price paid by the buyer to the seller for the rights in an option contract',
          'A reward for being a good investor',
          'A tax on the profit from an option',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The premium is the "Cost of the Ticket." Even if the option becomes worthless, you never get your premium gems back.',
        correctExplanation:
            'The seller (Writer) of the option keeps the premium as their "fee" for taking on the risk.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q11',
    title: 'Advanced Working Capital',
    subtitle: 'The 💎Operating Cycle Math',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'How do you calculate the "Operating Cycle"?',
        options: [
          'Sales / Total Assets',
          'Inventory Days + Receivable Days',
          'Revenue - Expenses',
          'Total Debt / Total Equity',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It is the total time from buying a raw 💎 to getting the final 💎 from the customer. If inventory takes 60 days and customers take 30 days to pay, your cycle is 90 days.',
        correctExplanation:
            'Successful companies try to shrink this cycle as much as possible to keep their gems working instead of sitting on a shelf.',
      ),
      QuizQuestion(
        question: 'What is the "Cash Conversion Cycle" (CCC)?',
        options: [
          'Operating Cycle minus Payable Days',
          'The amount of gems a company has in cash',
          'The total profit divided by 365',
          'A way to turn gold into gems',
        ],
        correctIndex: 0,
        wrongExplanation:
            'CCC is the "Gap" where your gems are GONE. If you take 90 days to sell/get paid but pay your own suppliers in 30 days, you are "Out of gems" for 60 days.',
        correctExplanation:
            'Negative CCC is the "Holy Grail." Companies like Amazon get paid by customers before they pay their suppliers—they are essentially using other people\'s gems for free!',
      ),
      QuizQuestion(
        question: 'What is "Factoring" in working capital?',
        options: [
          'Choosing the best factory to use',
          'Selling your Accounts Receivable to a third party (a factor) for immediate 💎s at a discount',
          'A way to calculate the cost of a product',
          'Hiring new employees to count gems',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If a customer owes you 💎1,000 in 90 days, you sell that debt to a bank for 💎950 today. You lose 💎50 but get your gems NOW to keep the business running.',
        correctExplanation:
            'Factoring is common for fast-growing small businesses that can\'t wait for slow-paying customers.',
      ),
      QuizQuestion(
        question: 'What is the "Economic Order Quantity" (EOQ)?',
        options: [
          'The total amount of gems the government orders',
          'The ideal order size that MINIMIZES total inventory costs (ordering + holding costs)',
          'The number of orders a company makes in a year',
          'A tax on the size of an order',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Buying too much cost gems in "Storage." Buying too little costs gems in "Shipping fees." EOQ is the perfect "Sweet Spot" in the middle.',
        correctExplanation:
            'Professional supply chain managers use the EOQ formula to ensure the 💎 efficiency of the warehouse.',
      ),
      QuizQuestion(
        question: 'What is "Just-In-Time" (JIT) Inventory?',
        options: [
          'Delivering products just before the store closes',
          'A strategy to keep inventory levels near zero by receiving goods only as they are needed for production',
          'Buying index funds at the last minute',
          'Paying your taxes exactly on the due date',
        ],
        correctIndex: 1,
        wrongExplanation:
            'JIT is very efficient but "Fragile." If a single truck is late, the whole factory stops. But it saves 💎millions in storage costs.',
        correctExplanation:
            'JIT was pioneered by Toyota and is now a standard for professional manufacturing worldwide.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q12',
    title: 'Portfolio Theories',
    subtitle: 'Efficient Frontiers & EMH',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What is "Modern Portfolio Theory" (MPT)?',
        options: [
          'Investing only in a single tech stock',
          'A framework for building a portfolio that maximizes expected return for a given level of risk',
          'A theory that all stocks are equal',
          'A way to predict the future price of gems',
        ],
        correctIndex: 1,
        wrongExplanation:
            'MPT proved that you can\'t look at a stock "alone." You must look at how its risk "interacts" with other stocks in the folder.',
        correctExplanation:
            'MPT led to the invention of Index Funds and the idea of wide-scale diversification.',
      ),
      QuizQuestion(
        question: 'What is the "Efficient Frontier"?',
        options: [
          'The border of a country with a good economy',
          'The set of optimal portfolios that offer the highest return for each level of risk',
          'A list of the fastest growing companies',
          'The amount of gems a bank holds in reserve',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If your portfolio is "below" the frontier, you are being a "Sucker"—you are taking more risk than you need for the return you are getting.',
        correctExplanation:
            'Professional portfolio managers use software to ensure they are always "On the Frontier."',
      ),
      QuizQuestion(
        question: 'What does the "Efficient Market Hypothesis" (EMH) claim?',
        options: [
          'Every market is equally efficient',
          'Asset prices fully reflect all available information, making it impossible to "beat the market" consistently',
          'Gems are the most efficient currency',
          'Computers will soon do all the trading',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If EMH is 100% true, trying to pick "winners" is a waste of time. You should just buy the whole market index and go to the beach.',
        correctExplanation:
            'EMH has three forms: Weak, Semi-Strong, and Strong, depending on what types of information are already "priced in."',
      ),
      QuizQuestion(
        question: 'What is "Arbitrage Pricing Theory" (APT)?',
        options: [
          'A way to set the price of a product',
          'A multi-factor model for asset pricing that considers several macroeconomic factors (not just one Beta)',
          'A theory that arbitrage is illegal',
          'The total cost of trading gems',
        ],
        correctIndex: 1,
        wrongExplanation:
            'CAPM only uses one Beta. APT uses many (like Inflation Beta, GDP Beta, Interest Rate Beta) to be more accurate.',
        correctExplanation:
            'APT is favored by professional "Quants" who build complex 💎 algorithms to find market edge.',
      ),
      QuizQuestion(
        question: 'What is the "Sharpe Ratio"?',
        options: [
          'The total profit of the company',
          'The Excess Return of a portfolio per unit of risk (Volatility)',
          'The number of people who own a stock',
          'The amount of gems spent on legal fees',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A high Sharpe ratio means you are getting a lot of gems for every "heart attack" the market gives you. It is the best measure of a manager\'s true skill.',
        correctExplanation:
            'Comparing two managers by return alone is wrong. You must divide their return by their risk—that is the Sharpe Ratio.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q13',
    title: 'Internal Controls & COSO',
    subtitle: 'The 💎Ethics of Business',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What are the three components of the "Fraud Triangle"?',
        options: [
          'Greed, Fear, and Laziness',
          'Pressure (Incentive), Opportunity, and Rationalization',
          'Assets, Liabilities, and Equity',
          'CEO, CFO, and Auditor',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A person only steals if: 1) They need gems (Pressure), 2) No one is watching (Opportunity), and 3) They tell themselves "I\'ll pay it back" (Rationalization).',
        correctExplanation:
            'Good management focuses on removing the "Opportunity" to prevent fraud before it starts.',
      ),
      QuizQuestion(
        question: 'What is "Segregation of Duties" (SoD)?',
        options: [
          'Giving everyone different tasks in the building',
          'A control requiring that more than one person is needed to complete a business process (e.g., one to order, one to pay)',
          'Making sure everyone has their own office',
          'A way to hire more employees',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If the same person writes the checks AND signs them, they can steal 💎billions easily. You must split these "Keys to the Vault."',
        correctExplanation:
            'SoD is the #1 internal control recommended by professional auditors.',
      ),
      QuizQuestion(
        question: 'What is the "COSO Framework"?',
        options: [
          'A type of software for accounting',
          'A globally recognized framework for designing, implementing, and evaluating internal controls',
          'A new set of laws from the government',
          'A special club for financial professionals',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It isn\'t a law; it\'s a "Blueprint" for a healthy company. It ensures the "Control Environment" (the management culture) is strong.',
        correctExplanation:
            'Most public companies use COSO to prove to shareholders that their gems are safe.',
      ),
      QuizQuestion(
        question: 'What is an "IT General Control" (ITGC)?',
        options: [
          'A button that turns off the computers',
          'Controls over the IT environment, such as passwords, backups, and physical security of servers',
          'The cost of buying new computers',
          'Hiring people to fix the printers',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If a hacker can change the spreadsheet, the accounting is worth zero. ITGCs are the "Foundation" of digital financial truth.',
        correctExplanation:
            'Auditors now spend a huge part of their time checking server rooms and password policies.',
      ),
      QuizQuestion(
        question: 'What is a "Whistleblower Policy"?',
        options: [
          'A rule that bans loud noises in the office',
          'A formal system that allows employees to report unethical behavior or fraud without fear of being fired',
          'A way to reward employees for working hard',
          'A type of insurance for the CEO',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Most fraud is found by "Tips" from honest employees, not by auditors. A safe reporting system is vital for keeping the 💎s safe.',
        correctExplanation:
            'Under laws like Sarbanes-Oxley, companies are REQIURED to have a way for people to report fraud privately.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q14',
    title: 'Corporate Valuation Models',
    subtitle: 'DDM vs Multiples Professionalism',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What is the "Gordon Growth Model" (GGM) used for?',
        options: [
          'Calculating how fast a company\'s employees grow',
          'A Dividend Discount Model that values a stock assuming dividends grow at a constant rate forever',
          'A way to predict the next recession',
          'The total cost of a company\'s debt',
        ],
        correctIndex: 1,
        wrongExplanation:
            'GGM says: Value = D1 / (k - g). It is perfect for "Boring" stable companies that pay steady dividends every year.',
        correctExplanation:
            'Professional analysts use GGM as a baseline to see if a stable company is fairly priced compared to its 💎 payout.',
      ),
      QuizQuestion(
        question: 'What is an "EV/EBITDA" multiple used to compare?',
        options: [
          'The size of two different buildings',
          'The total value of the company (Enterprise Value) relative to its operational gems, regardless of its debt levels',
          'How many products a company sells',
          'The amount of taxes paid by two companies',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Price/Earnings (P/E) can be "distorted" by debt. EV/EBITDA is "Capital Structure Neutral"—it allows you to compare a debt-heavy company to a cash-rich one fairly.',
        correctExplanation:
            'EV/EBITDA is the #1 multiple used by Wall Street for valuing businesses for sale or merger.',
      ),
      QuizQuestion(
        question: 'What is a "Control Premium" in valuation?',
        options: [
          'The cost of hiring a new security guard',
          'The extra price paid above the market value to acquire enough shares to control the company\'s decisions',
          'A tax on the company\'s profits',
          'A reward for the CEO staying for 10 years',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If a stock is 💎10, you might pay 💎13 to buy the WHOLE company. That 💎3 (30%) is the price of "Power"—the right to fire the board and change the strategy.',
        correctExplanation:
            'Calculating the control premium is a vital skill for mergers and acquisitions (M&A) professionals.',
      ),
      QuizQuestion(
        question: 'What is "Asset-Based Valuation"?',
        options: [
          'Valuing a company based on what its buildings are made of',
          'Valuing a business by totaling the fair market value of all its individual assets and subtracting its liabilities',
          'A way to choose which stocks to buy',
          'The total revenue of a company',
        ],
        correctIndex: 1,
        wrongExplanation:
            'This is used for "Liquidating" companies or holding companies. It ignores future profit and asks: "If we sold everything today, how many gems would we have?"',
        correctExplanation:
            'Asset valuation provides the "Floor" price—a company should rarely sell for less than its net assets.',
      ),
      QuizQuestion(
        question: 'What is "Discount for Lack of Marketability" (DLOM)?',
        options: [
          'A discount on products that aren\'t selling well',
          'A reduction in the value of shares that cannot be easily sold or traded on a public exchange',
          'A tax on properties in rural areas',
          'The cost of advertising a business',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you own 10% of a private "Mom & Pop" store, you can\'t sell it in 1 second like a stock. Professionals "Discount" the value by 15-30% because your gems are "Trapped."',
        correctExplanation:
            'DLOM is a critical adjustment in the valuation of private businesses and family-owned firms.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q15',
    title: 'Lease vs Buy Analysis',
    subtitle: 'Professional Capital Strategy',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What is an "Operating Lease" under modern IFRS 16 rules?',
        options: [
          'A lease for a car',
          'A lease that is now recorded on the balance sheet as a "Right of Use" asset and a liability (mostly ending the era of hidden leases)',
          'When you rent a building for one day',
          'A secret contract between two companies',
        ],
        correctIndex: 1,
        wrongExplanation:
            'In the old days, companies hid 💎billions in debt by "Renting" airplanes instead of buying them. Now, those rentals MUST be shown as debt.',
        correctExplanation:
            'IFRS 16 brought massive transparency to the market, forcing companies to admit their true long-term 💎 obligations.',
      ),
      QuizQuestion(
        question: 'Why might a company choose to LEASE instead of BUY?',
        options: [
          'Because they don\'t like owning things',
          'To avoid the risk of "Obsolescence" (the machine becoming old/useless) and to preserve upfront gems',
          'Because it is always cheaper than buying',
          'To hide the assets from the government',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If technology changes every 2 years, buying is a bad move. Leasing lets you "Trade In" for the new model easily.',
        correctExplanation:
            'Leasing is a "Financing" decision, often used to help a company grow without using all its cash at once.',
      ),
      QuizQuestion(
        question: 'What is the "Nal" (Net Advantage to Leasing)?',
        options: [
          'The number of people who rent vs buy',
          'A formula that compares the NPV of leasing versus the NPV of borrowing gems to buy the asset',
          'The total profit from a rental',
          'A type of insurance for leased equipment',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If NAL is POSITIVE, you should lease. It factors in tax shields, depreciation and the 💎 cost of borrowing.',
        correctExplanation:
            'Professional CFOs run NAL models for every major piece of equipment or real estate a company needs.',
      ),
      QuizQuestion(
        question: 'What is a "Sale and Leaseback" transaction?',
        options: [
          'Selling a product and buying it back later',
          'Selling an asset (like a headquarters) to a bank and then immediately leasing it back to get instant gems while still using the building',
          'A way to avoid paying rent',
          'Trading old assets for new ones',
        ],
        correctIndex: 1,
        wrongExplanation:
            'This is a way to unlock "Dead Gems" trapped in a building. You get 💎100M today to invest in growth, and just pay rent every month.',
        correctExplanation:
            'Leasebacks are common when a company is growing fast but needs more liquid cash for its daily operations.',
      ),
      QuizQuestion(
        question: 'What is a "Finance Lease" (Capital Lease)?',
        options: [
          'A lease for a bank',
          'A lease where the tenant effectively takes on all the risks and rewards of ownership (treated exactly like a loan and purchase)',
          'When the CEO rents a car',
          'A type of low-interest loan',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Even if the contract says "Rent," if you use it for 95% of its life, it is a purchase in the eyes of the law.',
        correctExplanation:
            'Finance leases are "Debt" in every way that matters to professional analysts.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q16',
    title: 'International Finance Parity',
    subtitle: 'The 💎Math of Global Markets',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What does "Interest Rate Parity" (IRP) state?',
        options: [
          'All interest rates should be the same across the world',
          'The difference in interest rates between two countries should equal the difference between the spot and forward exchange rates',
          'The bank is always right',
          'High interest rates lead to zero inflation',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If 💎s earn 10% in India and 2% in the US, IRP says the Indian Rupee MUST get cheaper in the future to prevent people from getting "free" money.',
        correctExplanation:
            'IRP is the force that prevents "Risk-Free" arbitrage across international borders.',
      ),
      QuizQuestion(
        question: 'What is "Purchasing Power Parity" (PPP)?',
        options: [
          'A list of the richest people in the world',
          'The idea that exchange rates should adjust so that a "Basket of Goods" costs the same in every country',
          'How much power the CEO has',
          'A tax on buying products overseas',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The "Big Mac Index" is a famous example. If a burger is 💎5 in NY but 💎2 in London, PPP says the Pound is "Underpriced" and will eventually go up.',
        correctExplanation:
            'While it rarely works in the short term, PPP is the best tool for "Long-Term" Forex prediction.',
      ),
      QuizQuestion(
        question: 'What is the "International Fisher Effect"?',
        options: [
          'A way to catch more fish globally',
          'The theory that differences in nominal interest rates reflect differences in expected inflation',
          'A set of rules for international banks',
          'The total amount of gems in the world',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If a bank pays 15% interest, it usually means everybody expects 10-12% inflation. You aren\'t actually getting "richer." ',
        correctExplanation:
            'Investors look at "Real" interest rates (Nominal minus Inflation) to decide where to move their gems.',
      ),
      QuizQuestion(
        question: 'What is a "Currency Swap"?',
        options: [
          'Trading one coin for another at a shop',
          'A professional contract where two parties exchange interest and principal payments in different currencies',
          'A type of illegal gamble',
          'A way to hide your nationality',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If a US company needs Euros and a German company needs gems, they "Swap" loans. This can lower the interest and Forex risk for both sides.',
        correctExplanation:
            'Large global "Whales" use currency swaps to manage their 💎 billon-dollar global debt.',
      ),
      QuizQuestion(
        question: 'What is "Country Risk"?',
        options: [
          'The risk of a country losing a sports game',
          'The risk that political, economic, or социал changes in a nation will impact the value of your investment there',
          'The risk of traveling to a new place',
          'A tax on international flights',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Even if a company is great, if the country\'s government suddenly takes away all their factories, your investment is zero. This is "Expropriation Risk."',
        correctExplanation:
            'Professional investors demand a "Risk Premium" (more gems) for putting their wealth into countries with unstable governments.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q17',
    title: 'Forensic Audit & Fraud',
    subtitle: 'Professional Financial Detective',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What is "Benford\'s Law" used for in forensic audit?',
        options: [
          'A law that requires auditors to wear suits',
          'The mathematical observation that in many real-life datasets, the number "1" appears as the leading digit more often than "9"',
          'A way to calculate interest rates',
          'A rule that prevents people from stealing gems',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If a human makes up fake 💎 receipts, they naturally use "1" through "9" equally. A computer can spot this "unnatural" pattern instantly.',
        correctExplanation:
            'Benford\'s Law is a powerful digital tool for finding hidden patterns of fraud in millions of transactions.',
      ),
      QuizQuestion(
        question: 'What is "Window Dressing"?',
        options: [
          'Cleaning the office windows before an audit',
          'Making the financial statements look better than they are at the very end of the year (e.g., delaying expenses)',
          'A type of marketing show',
          'Selling more products to customers',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A company might pay off its debt on Dec 31st and borrow it back on Jan 1st just to show "Zero Debt" on its annual report. This is misleading!',
        correctExplanation:
            'Forensic auditors look for "Large suspicious transactions" right before and after the year ends.',
      ),
      QuizQuestion(
        question: 'What is "Lapping" in accounts receivable fraud?',
        options: [
          'Running around the office',
          'Stealing a payment from Customer A and covering it up with a later payment from Customer B',
          'A way to calculate the cost of a product',
          'A type of bank insurance',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The thief must keep a secret book of who they stole from. They have to keep "lapping" payments forever to stay ahead of the audit.',
        correctExplanation:
            'Forcing every employee to take a 1-week mandatory vacation is the #1 way to catch lapping fraud.',
      ),
      QuizQuestion(
        question:
            'What is a "Bribe" in the context of the FCPA (Foreign Corrupt Practices Act)?',
        options: [
          'A tip for a waiter',
          'Giving gems or gifts to foreign government officials to win business—which is highly illegal for US companies',
          'Buying a gift for a friend',
          'The cost of doing business',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It doesn\'t matter if it\'s "legal" in the other country. If a US company pays a bribe, it can face 💎billions in fines and jail time.',
        correctExplanation:
            'The FCPA is the "World Cop" of business ethics, ensuring fair competition based on quality, not bribes.',
      ),
      QuizQuestion(
        question: 'What is an "Audit Trail"?',
        options: [
          'A path in the woods near the office',
          'A step-by-step record (paper or digital) that allows a transaction to be traced from the final report back to the original source',
          'A list of all the employees in the company',
          'The total profit made by the company',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you see 💎100,000 on the report, but there is no record of where it came from, that is a "Broken Trail" and a major sign of fraud.',
        correctExplanation:
            'Maintaining a secure audit trail is a legal requirement for all public companies.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q18',
    title: 'Strategic Accounting',
    subtitle: 'Balanced Scorecard & Beyond',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What are the four perspectives of the "Balanced Scorecard"?',
        options: [
          'Past, Present, Future, and CEO',
          'Financial, Customer, Internal Process, and Learning & Growth',
          'Assets, Liabilities, Equity, and Revenue',
          'Sales, Marketing, HR, and IT',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Being "Rich" (Financial) today isn\'t enough. If your customers hate you and your staff is quitting (Learning), you will be "Poor" tomorrow.',
        correctExplanation:
            'The scorecard ensures management doesn\'t sacrifice the future of the company for short-term gems.',
      ),
      QuizQuestion(
        question: 'What is "Activity-Based Costing" (ABC)?',
        options: [
          'Counting how many activities employees do',
          'Allocating overhead costs to products based on the specific activities they consume, rather than just using a simple percentage',
          'A way to choose which stocks to buy',
          'The total cost of running a website',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Old accounting might say: "Every product pays 10% for rent." ABC says: "Product A uses 50 hours of machine time, so IT should pay more for the factory gems."',
        correctExplanation:
            'ABC reveals which products are TRULY profitable and which ones are "stealing" gems from others.',
      ),
      QuizQuestion(
        question: 'What is a "Value Chain Analysis"?',
        options: [
          'Looking at the chain on the company\'s front door',
          'Examining every step of the business (from raw materials to after-sales service) to find where to create more value or save gems',
          'A way to calculate interest rates',
          'A set of rules for competitive markets',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Does our shipping create value? Does our packaging? If a step doesn\'t make the customer more "Happy" or the product "Better," it should be cut.',
        correctExplanation:
            'Mastering the value chain is how companies like Apple or Amazon stay ahead of all their competitors.',
      ),
      QuizQuestion(
        question: 'What is "Kaizen" Costing?',
        options: [
          'A type of food in the cafeteria',
          'A Japanese philosophy of "Continuous Improvement" focused on making tiny, daily changes to reduce costs and waste',
          'A rule that limits how much you can sell',
          'A tax on high-profit companies',
        ],
        correctIndex: 1,
        wrongExplanation:
            'You don\'t wait for a miracle. You aim to save 1 cent today, half a cent tomorrow. Over a million gems, this adds up to a massive advantage.',
        correctExplanation:
            'Kaizen requires "Everyone" in the building to be involved in saving 💎s and improving quality.',
      ),
      QuizQuestion(
        question: 'What is "Total Quality Management" (TQM)?',
        options: [
          'A way to manage the total number of employees',
          'A management approach where "Quality" is the goal of every single employee and business process',
          'A type of software test',
          'A rule that prevents bad products from being sold',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Quality isn\'t checked at the end. It is built in starting from the very first 💎 brick. It turns out, doing it right the first time is actually CHEAPER than fixing mistakes.',
        correctExplanation:
            'TQM companies have higher customer loyalty and spend far fewer gems on repairs and refunds.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q19',
    title: 'Complex Consolidation',
    subtitle: 'Step Acquisitions & Foreign Subs',
    difficulty: QuizDifficulty.hard,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What is a "Step Acquisition" (Acheived in Stages)?',
        options: [
          'Buying the building next door',
          'When a company increases its ownership in another firm from a non-controlling share (e.g., 20%) to a controlling share (e.g., 60%)',
          'A way to pay for a company in monthly installments',
          'A tax on buying more shares',
        ],
        correctIndex: 1,
        wrongExplanation:
            'You don\'t just add the new cost. You must "Revalue" your old 20% to its current Fair Market Value today and record a 💎 profit or loss BEFORE consolidating.',
        correctExplanation:
            'Step acquisitions require professional "Remeasurement" of previous equity interests, which is a high-level CA exam topic.',
      ),
      QuizQuestion(
        question:
            'What is the "Current Rate Method" for foreign subsidiary translation?',
        options: [
          'Charging customers the current interest rate',
          'Translating all balance sheet items at the year-end exchange rate and income items at the average rate',
          'Using the exchange rate from the day the company was founded',
          'A way to avoid using foreign currency',
        ],
        correctIndex: 1,
        wrongExplanation:
            'This method is used when the subsidiary is "Independent." Any 💎 gains or losses from translation go to the CTA (Cumulative Translation Adjustment) in equity.',
        correctExplanation:
            'The Current Rate method ensures the subsidiary\'s financial ratios (like Current Ratio) stay the same after translation.',
      ),
      QuizQuestion(
        question: 'What is "Temporal Method" translation?',
        options: [
          'A temporary way to count gems',
          'A method where non-monetary assets (like inventory) are translated at their historical exchange rates, used when a subsidiary is an extension of the parent',
          'Trading gems only during certain times of the year',
          'A tax on temporary companies',
        ],
        correctIndex: 1,
        wrongExplanation:
            'This is used for "Dependent" subsidiaries. Any 💎 gains or losses go directly to the Income Statement, which makes the parent\'s profit very volatile.',
        correctExplanation:
            'Professional accountants choose between Current and Temporal methods based on the "Functional Currency" of the subsidiary.',
      ),
      QuizQuestion(
        question: 'What is a "Bargain Purchase" (Negative Goodwill)?',
        options: [
          'Buying a product on sale',
          'When you buy a company for LESS than the fair value of its net assets, resulting in an immediate 💎 gain on the income statement',
          'A company that is going bankrupt',
          'A secret deal with a supplier',
        ],
        correctIndex: 1,
        wrongExplanation:
            'This is the opposite of Goodwill. It usually happens in "Fire Sales." If a company has 💎100M in assets but you pay 💎80M, you "made" 💎20M profit on Day 1.',
        correctExplanation:
            'Auditors check bargain purchases very strictly to ensure the assets aren\'t overvalued on the books.',
      ),
      QuizQuestion(
        question: 'What is "Equity Method" vs "Consolidation"?',
        options: [
          ' Konsolidation is only for small businesses',
          'Equity method is used for "Significant Influence" (20-50% ownership) where you only record your share of the profit, not every asset',
          ' консолидация means selling the company',
          'A way to hide debt from the public',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you own 30%, you don\'t put their factory on your balance sheet. You just increase your initial 💎 investment by 30% of their annual profit.',
        correctExplanation:
            'Distinguishing between "Influence" and "Control" is the foundation of professional group reporting.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q20',
    title: 'Advanced Derivatives Strategy',
    subtitle: 'The 💎Delta \u0026 Gamma Professional',
    difficulty: QuizDifficulty.hard,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What is "Delta Neutral" hedging?',
        options: [
          'A way to stay neutral in a political debate',
          'Building a portfolio so that the total Delta is zero, meaning the 💎 value doesn\'t change if the stock price moves slightly',
          'Buying equal amounts of every stock in the market',
          'A hedge made with zero gems',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If your stock goes up 💎1, your option might go down 💎1. You are "Immune" to small price swings.',
        correctExplanation:
            'Banks and Market Makers use Delta Neutral strategies to earn gems from "Spreads" without caring about where the stock price goes.',
      ),
      QuizQuestion(
        question: 'What is "Gamma" in option Greeks?',
        options: [
          'A type of radiation',
          'The rate of change in Delta as the stock price moves',
          'The third best option in the market',
          'A tax on huge profits',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Delta is "Speed." Gamma is "Acceleration." If Gamma is high, your Delta (and your risk) can change very fast, requiring you to trade more gems to stay hedged.',
        correctExplanation:
            'Gamma risk is what causes "Hedgers" to panic and buy/sell rapidly during market crashes.',
      ),
      QuizQuestion(
        question: 'What is a "Bull Call Spread"?',
        options: [
          'A type of farm animal',
          'Buying one Call option and selling another Call at a higher strike price to lower the 💎 cost of the trade',
          'Telling everyone a stock is going up',
          'A way to borrow gems from a bull',
        ],
        correctIndex: 1,
        wrongExplanation:
            'You pay less gems for the trade, but you also cap your profit. It is a "Cost-Efficient" professional way to bet on a stock going up.',
        correctExplanation:
            'Spreads are the basic "building blocks" of professional CAIA-level trading strategies.',
      ),
      QuizQuestion(
        question: 'What is "Theta" decay?',
        options: [
          'A type of brain wave',
          'The loss in value of an option every day as it gets closer to its expiration date',
          'A way to make gems slowly',
          'A tax on holding stocks for too long',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Options are "Wasting Assets." Every night while you sleep, an option loses more gems in value. This is the "Time Decay."',
        correctExplanation:
            'Professional "Sellers" of options earn their gems by harvesting this Theta decay from people who buy options.',
      ),
      QuizQuestion(
        question: 'What is "Value at Risk" (VaR)?',
        options: [
          'The total amount of gems the company owns',
          'A statistical measure of the maximum 💎 amount you could lose in a portfolio over a specific time with a certain confidence (e.g., 95%)',
          'A way to calculate interest on a loan',
          'A list of the riskiest stocks in the country',
        ],
        correctIndex: 1,
        wrongExplanation:
            'VaR says: "There is a 95% chance we won\'t lose more than 💎1M today." It helps CEOs sleep at night, but it can fail during "Black Swan" events.',
        correctExplanation:
            'VaR is the standard risk reporting tool for every major investment bank and hedge fund in the world.',
      ),
    ],
  ),
];

List<QuizMetadata> _getAllQuizzes() {
  return [
    ..._level1Quizzes,
    ..._level2Quizzes,
    ..._level3Quizzes,
    ..._level4Quizzes,
    ..._level5Quizzes,
  ];
}
