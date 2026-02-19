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
          'Giving it away to someone who needs saving',
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
          'Money you owe to someone',
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
          'Something can live without',
          'A gift on your birthday',
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
          'Something you must have to live',
          'Nice to have for fun',
          'Free items you get',
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
          'To show off to others',
          'To hide it away',
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
          'A fun party or a gift that is on sale',
          'A new limited edition toy',
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
          'A secret goal in football',
          'A goal in a game',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A savings goal is not a math problem, a secret goal with bonus points, or a game you play. It is a target for your savings.',
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
          'Money you find on the street',
          'Money you earn from your job',
          'Money you save in a bank',
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
          'A card to show to your friends to show off',
          'A card that you can use to buy anything for free',
          'A card for playing video games',
          'A card to buy things using borrowed money',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Credit cards are not for playing video games, free money to buy anything, or something to show off. Using a credit card means you are taking a loan.',
        correctExplanation:
            'A credit card allows you to buy things now using the bank\'s money. You must pay this money back later, often with extra interest if late.',
      ),
      QuizQuestion(
        question: 'Why is too much debt bad?',
        options: [
          'Makes you rich',
          'Limits financial freedom',
          'Helps you save',
          'It is good because it helps you save',
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
          'A discount on the debt',
          'Extra money to pay',
          'A reward for the borrower',
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
          'Ignore it and pay when you can',
          'Borrow more money from a different lender',
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
          'A bank account with goals',
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
          'To impress friends and show off',
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
          'A secret dream that lasts only one night',
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
          'Something easy that can be done later',
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
          'A place to get cash from your account',
          'A video game where a secret code gives you money',
          'A brand of bike',
          'A free money machine',
        ],
        correctIndex: 0,
        wrongExplanation:
            'An ATM is not a video game, a fast bike, or a place to get free money. It is a specialized machine used for banking and money.',
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
          'Planned shopping based on impulse',
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
          'Free money from the bank',
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
          'learning to drift a car',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Professional skills are not heavy objects like boxes, shiny toys, or knowing how to drift a car. They are mental or physical abilities used to perform a specific job well.',
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
          'Call your friends and tell everyone',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Buying something too fast or thinking it is just a lucky break can lead to trouble. Most amazing deals that seem impossible are actually clever tricks.',
        correctExplanation:
            'If a deal seems too good to be true, it is likely a scam. You should always be careful and ask an adult before spending your money.',
      ),
      QuizQuestion(
        question: "What is the 'Phishing' scam?",
        options: ['Catching fish', 'A sport', 'Buying a boat', 'Fake emails'],
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
          'Being cheap and mean when you have money',
          'Being rich and never saving',
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
          'To feel bad about your money',
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
          'Being late for a sale and missing out',
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
          'Rich strangers',
          'Nobody, keep it to yourself',
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
          'Only a few days before birthdays',
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
          'A secret code to get rich',
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
          'A toy from the bank that you must pay for',
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
          'To show off how much money you have',
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
          'the cost of fixing a broken toy',
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
          'The cost of the variable',
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
          'Garbage money that can be disposed of',
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
          'Only metal coins',
          'A credit card',
          'Another name for a check',
          'Physical bills',
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
          'Acard to buy things using your own money',
          'A card which you can use to buy anything for free',
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
          'A website with digital cash and coins',
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
        options: [
          'A money exchange',
          'A car',
          'A secret deal with a friend',
          'A gift',
        ],
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
          'Having a job with lots of power',
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
          'Saving coins with the help of a barter',
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
          'By anyone\'s wish',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Prices do not stay the same forever, and they certainly don\'t change by magic or by anyone\'s wish. They follow very specific rules of the national economy.',
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
          'A type of food with charred vegetables',
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
          'To be cool and show off',
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
          'A paid job in a volunt',
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
          'At least 1000[GEM]',
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
          'A bank that gives you free money',
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
          'It is magic and makes you cool',
          'It costs more for the brand',
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
          'A brain disease that sets your mind on money',
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
          'A service charge deducted regularly for storing your money',
          'Money the bank pays you for letting it use your savings',
          'A compulsory amount collected by the government each year',
          'Extra cash you must add to the account every month',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Interest is not something you pay or a government charge. In a savings account, the bank borrows your money and compensates you for that use, rather than deducting or demanding additional payments from you.',
        correctExplanation:
            'Interest is the payment you receive for allowing the bank to use your deposited money. Over time, this payment adds to your balance, rewarding you for saving instead of spending immediately.',
      ),
      QuizQuestion(
        question: 'What is "compound interest"?',
        options: [
          'Interest calculated only on the initial amount deposited',
          'Interest earned on both the principal and past interest',
          'Interest decided once a year using a fixed rule',
          'Interest that never changes regardless of time',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Earning interest only on the original amount is called simple interest. Compound interest is different because it repeatedly adds previous interest into the calculation, causing faster growth over long periods.',
        correctExplanation:
            'Compound interest means your money grows on top of itself. Each period, interest is added to the balance, and future interest is calculated on this larger amount, accelerating growth over time.',
      ),
      QuizQuestion(
        question:
            'Which of these makes your money grow the most over 10 years?',
        options: [
          'Keeping cash at home where it never earns anything',
          'Earning simple interest added once each year',
          'Earning compound interest over the entire period',
          'Spending the money instead of saving it',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Without interest or with simple interest, growth is slow and limited. Spending removes any chance of growth at all, while compound interest continuously builds on previous gains.',
        correctExplanation:
            'Compound interest produces the strongest long-term growth because earnings are reinvested again and again. Over many years, this repeated compounding leads to much higher total value than other options.',
      ),
      QuizQuestion(
        question: 'Why is a high interest rate bad when you owe money (debt)?',
        options: [
          'It slowly lowers the total amount you must repay over time',
          'It causes the debt balance to increase more quickly',
          'It has no meaningful impact on your repayments',
          'It only affects banks and not borrowers',
        ],
        correctIndex: 1,
        wrongExplanation:
            'High interest never reduces debt or leaves it unchanged. Instead, it increases what you owe, meaning you must pay back significantly more than the amount you originally borrowed.',
        correctExplanation:
            'When you owe money, interest works against you. A high rate adds extra cost each period, making the debt grow faster and harder to eliminate without much larger payments.',
      ),
      QuizQuestion(
        question: 'Why is it better to start saving earlier in life?',
        options: [
          'Your money has more time to compound and grow',
          'Laws require younger people to save money',
          'Banks only support accounts opened at a young age',
          'Saving early stops you from spending later',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Saving is not restricted by age or law. The key advantage of starting early is time, which allows interest to repeat its compounding effect many more times.',
        correctExplanation:
            'Starting early gives your savings more years to compound. Each extra year allows interest to build upon itself, resulting in far greater growth compared to saving the same amount later.',
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
          'The total money currently sitting in your bank account',
          'A number showing how reliably you repay borrowed money',
          'A performance score given by schools or teachers',
          'A count of how many credit cards you own',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A credit score is unrelated to education, account balances, or card counts. It is specifically designed to measure how responsibly someone handles loans and repayments, helping lenders estimate the risk of lending money.',
        correctExplanation:
            'A credit score represents your financial trustworthiness. It summarizes how consistently you repay borrowed money, allowing banks and lenders to quickly judge how risky it may be to lend to you.',
      ),
      QuizQuestion(
        question: 'Which of these helps improve your credit score?',
        options: [
          'Paying bills a little late but eventually settling them',
          'Paying bills on time across all accounts',
          'Using most of your available credit limit',
          'Avoiding all financial products completely',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Late payments, heavy credit usage, or avoiding credit entirely do not help your score. Credit systems reward predictable behavior, where lenders can clearly see that obligations are met consistently and on schedule.',
        correctExplanation:
            'Regular on time payments show reliability. When lenders see a long history of meeting deadlines, they gain confidence that you will repay future loans as agreed.',
      ),
      QuizQuestion(
        question: 'Who might check your credit score?',
        options: [
          'Friends comparing financial habits casually',
          'Media companies offering online services',
          'Banks and landlords evaluating applications',
          'Family members tracking personal finances',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Credit scores are not used socially or by media companies. They are accessed by organizations making financial or housing decisions, where understanding payment reliability is essential before approving an agreement.',
        correctExplanation:
            'Banks review credit scores before lending, and landlords check them before renting. Both want reassurance that payments will be made reliably over time.',
      ),
      QuizQuestion(
        question: 'What is a "credit report"?',
        options: [
          'A yearly summary of your academic results',
          'A detailed record of yearly income sources',
          'A history of loans, credit, and repayments',
          'A personal list of planned purchases',
        ],
        correctIndex: 2,
        wrongExplanation:
            'A credit report does not track grades, income, or shopping plans. It focuses entirely on borrowing behavior and repayment history, which lenders use to calculate and understand a credit score.',
        correctExplanation:
            'A credit report documents your borrowing activity. It includes loans, credit cards, and payment behavior, forming the foundation used to calculate your credit score.',
      ),
      QuizQuestion(
        question: 'Why is it beneficial to have a high credit score?',
        options: [
          'Companies send free products automatically',
          'You qualify for loans with lower interest',
          'Tax obligations are removed entirely',
          'Your salary increases without effort',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A high score does not provide free items, remove taxes, or raise income. Its real advantage is reducing borrowing costs by signaling lower risk to lenders.',
        correctExplanation:
            'A high credit score signals reliability. Because lenders see you as low risk, they often offer loans with lower interest rates, saving you money over time.',
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
          'A temporary discount applied during store promotions',
          'An extra percentage added to the price when buying items',
          'The base cost set by the manufacturer',
          'A handling charge added by banks for bringing goods to the sale',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Sales tax is not a discount or a base price. It is an added charge collected by the government at the point of purchase, increasing the total amount you pay rather than reducing it.',
        correctExplanation:
            'Sales tax is an added percentage charged on certain purchases. It is collected at checkout and passed to the government to help fund public services.',
      ),
      QuizQuestion(
        question: 'What is "income tax"?',
        options: [
          'a tax applied to goods sold in shops',
          'a tax taken from the money you earn',
          'money paid by the government to workers',
          'a charge for using banking services',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Income tax is not related to selling goods, receiving benefits, or banking fees. It is deducted from earnings and sent to the government as part of national revenue.',
        correctExplanation:
            'Income tax is charged on earnings from work or business. Governments collect it to fund public services and shared infrastructure used by everyone.',
      ),
      QuizQuestion(
        question: 'What are some things that tax money pays for?',
        options: [
          'personal shopping and private gifts',
          'roads, schools, and emergency services',
          'luxury travel for officials only',
          'profits for private companies',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Taxes are not meant for personal spending or private profit. They are collected to support services and systems that benefit society as a whole.',
        correctExplanation:
            'Tax money funds shared services like roads, schools, healthcare, and public safety. These services support communities and cannot function without collective contributions.',
      ),
      QuizQuestion(
        question: 'What is "Net Pay" on a paycheck?',
        options: [
          'the full amount earned before deductions',
          'the money you receive after all deductions',
          'a bonus added for good performance',
          'a fee charged by the bank for processing the payment',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Net pay is not your full earnings or a bonus. It is calculated after taxes and other deductions are removed from your original salary.',
        correctExplanation:
            'Net pay is what remains after taxes and deductions are subtracted. It represents the actual amount deposited into your account or given to you.',
      ),
      QuizQuestion(
        question: 'Why should you include tax when planning a big purchase?',
        options: [
          'because the final cost is higher than the listed price',
          'because stores keep tax as extra profit',
          'because taxes can usually be skipped and are negligible as compared to the price of the item',
          'because taxes are refunded instantly',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Taxes are not optional and do not increase store profits. They raise the final amount you must pay, which is why ignoring them can break a budget.',
        correctExplanation:
            'Sales tax is added during checkout, not shown fully on price tags. Including tax prevents underestimating the total cost of a large purchase.',
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
          'When the value of money increases compared to goods and services in a growing economy over many years',
          'A term used to describe economic growth during a boom period',
          'When more products are available in stores',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Inflation is not about economic growth, product availability, or money becoming stronger. It specifically describes a broad rise in prices across an economy, which causes each unit of money to buy fewer goods and services over time.',
        correctExplanation:
            'Inflation refers to the general rise in prices throughout an economy. As prices increase, the purchasing power of money falls, meaning the same amount of money can buy fewer goods and services than before.',
      ),
      QuizQuestion(
        question: 'How does inflation affect your savings?',
        options: [
          'It makes your savings more valuable over time as prices increase',
          'It buys less over time if interest doesn\'t keep up',
          'It keeps savings equal in value no matter what happens in the economy',
          'It automatically increases your bank balance',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Inflation does not protect or increase the real value of savings. If prices rise faster than your savings grow, the money you saved will be able to purchase fewer goods and services in the future.',
        correctExplanation:
            'Inflation reduces the real value of savings when interest growth is too low. Even if your balance increases slightly, rising prices can cause your savings to lose purchasing power over time.',
      ),
      QuizQuestion(
        question:
            'If inflation is 3% and your bank interest is 1%, are you gaining purchasing power?',
        options: [
          'Yes, because any growth always beats inflation over long periods of time',
          'No, you are losing purchasing power because prices rise faster than your interest',
          'It stays exactly the same every year',
          'This situation has no real impact on savings',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Although your savings grow by 1%, prices increase by 3%. This gap means your money cannot keep up with rising costs, so you can afford less even though the number in your account is higher.',
        correctExplanation:
            'When inflation is higher than interest, purchasing power falls. Your savings grow more slowly than prices, causing the real value of your money to decrease instead of increase.',
      ),
      QuizQuestion(
        question:
            'What usually happens to inflation if too much money is printed?',
        options: [
          'Prices slowly decrease as money becomes common and easier to obtain',
          'Prices go up because money becomes less rare',
          'Prices remain stable with no long-term effects',
          'Everyone suddenly becomes wealthier',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Printing excess money does not make goods cheaper or everyone richer. When more money exists without more goods, sellers raise prices, which leads to inflation increasing across the economy.',
        correctExplanation:
            'When too much money chases the same amount of goods, prices rise. The increased supply of money reduces its value, causing inflation to increase.',
      ),
      QuizQuestion(
        question: 'Why are historical prices (like 1950) usually much lower?',
        options: [
          'People valued money differently and spent less overall',
          'Because of long-term inflation over decades',
          'Because money systems were not developed yet',
          'Because products were always cheaper to make',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Lower historical prices are not mainly due to quality, spending habits, or undeveloped systems. They result from decades of inflation steadily increasing prices over long periods of time.',
        correctExplanation:
            'Over many decades, even small inflation rates compound. This makes past prices appear much lower, since money in earlier years had far greater purchasing power than the same amount today.',
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
          'The listed price shown on an item you want',
          'The value of the next best option you give up',
          'The effort required to find a good opportunity to buy something',
          'A special fee applied to luxury purchases',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Opportunity cost is not the sticker price or a special fee. It refers to the value of the alternative you did not choose when making a decision, which is often invisible but very important.',
        correctExplanation:
            'Opportunity cost is the value of the best alternative you give up. Choosing one option always means losing the benefits you could have received from the next best choice.',
      ),
      QuizQuestion(
        question:
            'If you spend 50[GEM] on a video game instead of saving it, what is the opportunity cost?',
        options: [
          'The entertainment and fun value provided by the game',
          'The 50[GEM] and the future growth it could earn',
          'The hours spent playing the video game',
          'The receipt showing the purchase was made',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The game and time spent are what you gain, not what you lose. The real cost is missing out on saving or investing that 50[GEM] and the interest or growth it could have produced.',
        correctExplanation:
            'The opportunity cost is the money plus its future potential. By spending 50[GEM], you give up the chance for that money to grow through saving or investing over time.',
      ),
      QuizQuestion(
        question: 'Does a "free" activity have an opportunity cost?',
        options: [
          'No, because it does not require any payment',
          'Yes, because it uses time you could spend elsewhere',
          'Only if equipment or travel is required for the opportunity',
          'Only if other people are involved',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Even without a price, activities still use time. That time could have been spent studying, working, resting, or doing something else valuable, which creates an opportunity cost.',
        correctExplanation:
            'Free activities still cost time. Since time is limited, using it for one activity means giving up the chance to use it for another potentially valuable option.',
      ),
      QuizQuestion(
        question: 'Why is understanding opportunity cost important for wealth?',
        options: [
          'It helps you understand the real impact of choices',
          'It forces you to stop spending money completely and save all of it',
          'It automatically reduces your tax burden',
          'It helps you locate cheaper products',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Opportunity cost does not remove spending, lower taxes, or find deals. It improves decision making by revealing what you sacrifice in the long term when choosing short term benefits.',
        correctExplanation:
            'Understanding opportunity cost helps you see hidden trade-offs. This awareness leads to smarter financial decisions that favor long term growth over short term satisfaction.',
      ),
      QuizQuestion(
        question: 'Every financial choice involves...',
        options: [
          'Visiting a bank or financial institution to check your credit score',
          'Giving something up to gain something else',
          'Winning money from chance or luck',
          'Getting professional legal advice',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Financial decisions do not always involve banks, luck, or lawyers. What they always involve is a trade-off, where choosing one option means giving up another.',
        correctExplanation:
            'Because money and time are limited, every financial decision requires a trade-off. Gaining one thing always means sacrificing another possible option.',
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
          'A person employed within a government department',
          'Someone who starts and manages their own business',
          'A senior manager working inside a very large and established company structure',
          'An employee working at a financial institution',
        ],
        correctIndex: 1,
        wrongExplanation:
            'An entrepreneur is not defined by working for the government, banks, or corporate hierarchies. Instead, entrepreneurs build and operate their own ventures, taking responsibility for decisions, risks, and outcomes rather than relying on existing systems.',
        correctExplanation:
            'An entrepreneur is someone who starts and runs a business. They organize resources, make key decisions, and accept the risks involved in creating something new with the goal of earning a profit.',
      ),
      QuizQuestion(
        question: 'How do you calculate "Profit"?',
        options: [
          'Adding all income together with all operating expenses included',
          'Subtracting total expenses from total income',
          'Looking only at the final bank account balance',
          'Counting how many workers the business currently employs',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Profit is not found by adding expenses or checking staff size. To know if a business truly earns money, all costs must be subtracted from income to reveal whether the result is positive or negative.',
        correctExplanation:
            'Profit is calculated by subtracting expenses from income. The remaining amount shows whether the business made money or suffered a loss during that period.',
      ),
      QuizQuestion(
        question: 'What is "Revenue"?',
        options: [
          'All the money earned from selling goods or services',
          'Money left after paying taxes, wages, and other business expenses',
          'The total amount of long term debt owed by a company',
          'Income earned specifically from launching a brand new product line',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Revenue is not what remains after expenses or taxes. It represents the total money coming in from sales before any costs are removed, which is why it is often called the top line.',
        correctExplanation:
            'Revenue is the total income a business earns from selling products or services, measured before subtracting any costs or expenses.',
      ),
      QuizQuestion(
        question: 'What is the main "Risk" for an entrepreneur?',
        options: [
          'Managing too many customers at the same time',
          'Losing personal money and time if it fails',
          'Having too much free time and fewer responsibilities',
          'Receiving an unexpected promotion within the business',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The real risk is not comfort or success. Entrepreneurs often invest their own savings and effort, and if the business does not succeed, they may lose both money and valuable time.',
        correctExplanation:
            'Entrepreneurs risk their own money and time with no guarantee of success. If the business fails, those personal investments may be lost.',
      ),
      QuizQuestion(
        question: 'Why might a business fail even if it has many customers?',
        options: [
          'Customers are paying far more money than expected',
          'Expenses are higher than the income earned',
          'The owner enjoys running the business far too much',
          'There is absolutely no competition anywhere in the market',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A large customer base does not ensure profit. If producing and delivering goods costs more than the sales revenue, the business loses money despite appearing successful on the surface.',
        correctExplanation:
            'A business can still fail if expenses exceed revenue. High costs can erase profits even when sales volume and customer numbers are high.',
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
          'A formal loan agreement given to a business',
          'Partial ownership of a company',
          'A long term insurance product sold by banks',
          'A guaranteed return promised by governments and regulators',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A stock is not a loan, insurance product, or government promise. Those descriptions fit other financial tools. Stocks specifically represent ownership, meaning you benefit if the company grows and lose value if it performs poorly.',
        correctExplanation:
            'Buying a stock means owning a small piece of a company. As an owner, your investment value rises or falls based on how well the company performs over time.',
      ),
      QuizQuestion(
        question: 'What is a "Bond"?',
        options: [
          'A loan you give to a company or government',
          'Ownership in a business with voting rights',
          'A digital asset traded only online',
          'A long term agreement guaranteeing business control',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Bonds do not represent ownership or control. They are debt instruments where the borrower promises to repay the lender with interest, making them fundamentally different from stocks.',
        correctExplanation:
            'A bond is a loan made to a government or company. In return, the borrower pays interest and promises to repay the original amount after a fixed period.',
      ),
      QuizQuestion(
        question: 'Which investment is generally "Higher Risk, Higher Reward"?',
        options: [
          'Savings accounts with guaranteed returns',
          'Government bonds issued for stability',
          'Stocks',
          'Holding physical cash for emergencies only',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Savings accounts, bonds, and cash are designed to protect value rather than grow it quickly. Stocks can rise sharply or fall sharply, making them riskier but offering higher potential rewards.',
        correctExplanation:
            'Stocks carry higher risk because prices can change rapidly. However, this risk comes with the potential for much higher long term growth compared to safer investments.',
      ),
      QuizQuestion(
        question: 'What is a "Dividend"?',
        options: [
          'A mandatory tax charged on stock purchases',
          'A portion of company profits paid to shareholders',
          'A transaction fee paid when selling shares',
          'A fixed interest payment earned from bonds over time',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Dividends are not taxes or fees. They are payments companies choose to make when they are profitable, rewarding shareholders for owning and supporting the business.',
        correctExplanation:
            'A dividend is a share of profits paid to stockholders. Companies distribute dividends to reward investors and share success when business performance is strong.',
      ),
      QuizQuestion(
        question: 'Why would someone choose a Bond over a Stock?',
        options: [
          'They want direct ownership and voting power',
          'They prefer predictable income with lower risk',
          'They expect extremely high returns quickly',
          'They enjoy frequent price changes and volatility',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Bonds are usually not chosen for excitement or massive growth. They are favored because they offer stability, regular interest payments, and lower risk compared to the unpredictable nature of stocks.',
        correctExplanation:
            'Bonds provide predictable payments and lower risk. Investors choose them for stability, especially when protecting capital is more important than maximizing growth.',
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
          'Money that must be repaid in the future',
          'Something you own that has value',
          'An accounting mistake recorded in finances',
          'Only cash kept physically on hand at all times',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Assets are not debts or errors. They include anything valuable you own, such as cash, property, vehicles, or investments. Money that must be repaid is classified as a liability, not an asset.',
        correctExplanation:
            'An asset is anything you own that has economic value. Assets can increase your financial strength because they can be sold, invested, or used to generate income over time.',
      ),
      QuizQuestion(
        question: 'What is a "Liability"?',
        options: [
          'Something valuable that you fully own',
          'Money you owe to someone else',
          'Total income earned across many years',
          'A financial indicator showing long term stability and strength',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Liabilities are not signs of strength or ownership. They represent obligations like loans or credit card balances that reduce your net worth until they are fully repaid.',
        correctExplanation:
            'A liability is a financial obligation you owe. Loans, unpaid bills, and credit balances are liabilities because they represent future payments that reduce your overall financial position.',
      ),
      QuizQuestion(
        question: 'How do you calculate "Net Worth"?',
        options: [
          'Total assets added together with all liabilities',
          'Total assets minus total liabilities',
          'Monthly income minus regular monthly expenses',
          'All money held across different savings accounts',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Adding assets and liabilities inflates wealth inaccurately. Net worth focuses on what remains after debts are removed, revealing your true financial position rather than just showing how much money flows through you.',
        correctExplanation:
            'Net worth is calculated by subtracting liabilities from assets. This shows how much you truly own after accounting for all debts and obligations.',
      ),
      QuizQuestion(
        question:
            'If you have a [GEM]20,000 car but own it with a [GEM]15,000 loan, what is your net worth related to that car?',
        options: [
          'The full market value of the car',
          'Only the remaining loan amount',
          'The difference between value and debt',
          'The car value added to the loan balance together',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Your net worth is not the full value or the loan alone. You must subtract the outstanding debt from the asset value to find how much of the car you actually own.',
        correctExplanation:
            'Net worth related to the car is the value minus the loan. Subtracting [GEM]15,000 from [GEM]20,000 shows you truly own [GEM]5,000 of value.',
      ),
      QuizQuestion(
        question:
            'Why is Net Worth more important than just having a high salary?',
        options: [
          'Income matters more than any long term measurement',
          'It shows whether wealth is actually being built',
          'It helps impress others with financial terms',
          'It guarantees future financial success automatically',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A high income does not guarantee wealth. If spending and debt rise faster than savings, net worth can remain low or negative despite earning a large salary.',
        correctExplanation:
            'Net worth shows real financial progress. It reflects whether assets are growing and liabilities are shrinking, which matters far more than income alone.',
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
          'Debt used for short term spending that quickly loses value',
          'Debt that helps you increase your wealth or income long term',
          'Debt with very high interest rates and strict repayment terms that limit financial flexibility over time',
          'Debt taken without any plan for repayment',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Good debt is not linked to consumption or poor planning. It usually funds education, businesses, or assets that improve future earning ability, unlike high interest or unproductive borrowing that reduces long term financial stability.',
        correctExplanation:
            'Good debt is borrowing used to improve future finances. It supports education, skill building, or assets that generate income or grow in value beyond the total cost of the loan.',
      ),
      QuizQuestion(
        question: 'What is an example of "Bad Debt"?',
        options: [
          'A loan taken to gain skills that raise long term income',
          'Borrowing money to expand a profitable business operation',
          'High interest credit card debt used for luxury purchases',
          'A long term home loan with affordable monthly payments and stable value',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Bad debt is not tied to growth or investment. It usually carries high interest and is spent on items that quickly lose value, leaving ongoing payments without improving income or financial security.',
        correctExplanation:
            'Bad debt is borrowing that does not increase future wealth. High interest consumer debt often drains money and limits financial progress instead of helping it grow.',
      ),
      QuizQuestion(
        question: 'Is a house loan (mortgage) usually good or bad debt?',
        options: [
          'Always bad because the borrowed amount is very large',
          'Usually good because homes often increase in value over time',
          'Not considered debt because it is paid monthly',
          'Bad mainly in unstable housing markets with long term price declines',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The size of a loan alone does not define bad debt. Mortgages often help build equity in property, which historically appreciates and contributes positively to long term net worth.',
        correctExplanation:
            'A mortgage is often considered good debt because it helps you own an asset. Over time, repayments build equity and the property may increase in value.',
      ),
      QuizQuestion(
        question: 'Why are "Payday Loans" considered very bad debt?',
        options: [
          'They are approved very quickly with minimal checks',
          'They charge extremely high interest rates',
          'They require repayment within a short time',
          'They combine very high interest, short repayment periods, and penalties that trap borrowers in repeated cycles of debt',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The danger of payday loans is not convenience alone. Their extremely high interest and penalties make repayment difficult, often forcing borrowers to take new loans to cover old ones.',
        correctExplanation:
            'Payday loans are bad debt because their interest rates are extremely high. This makes repayment difficult and often traps borrowers in long term debt cycles.',
      ),
      QuizQuestion(
        question: 'Borrowing money to start a business is good debt if...',
        options: [
          'The business earns more than the loan interest costs',
          'The business looks impressive and professionally branded',
          'The loan repayment is delayed for many years',
          'The business idea sounds exciting and attracts attention from many people',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A business loan is not good simply because it looks attractive or sounds exciting. It is only beneficial if the business generates returns that exceed borrowing costs.',
        correctExplanation:
            'Business debt is good when returns exceed interest costs. If profits are higher than loan expenses, borrowing helps grow wealth instead of reducing it.',
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
          'A recreational activity involving water, rods, and outdoor equipment',
          'Fake emails or messages designed to steal personal information',
          'Online shopping focused only on seafood products',
          'A modern investment strategy promoted on social media',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Phishing has nothing to do with sports, shopping, or investing. It is a scam where attackers pretend to be trusted organizations to trick people into revealing passwords, bank details, or other sensitive information.',
        correctExplanation:
            'Phishing is a fraud technique where scammers impersonate trusted sources. Their goal is to steal passwords, banking details, or personal data by creating messages that look real and urgent.',
      ),
      QuizQuestion(
        question:
            'What should you do if a "bank worker" calls and asks for your password?',
        options: [
          'Share the password so the issue can be fixed quickly',
          'Hang up immediately because banks never ask for passwords',
          'Ask the caller to verify their identity in detail over the phone',
          'Provide a false password to test whether the caller is legitimate',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Real banks already have secure access to your account information. Anyone asking for your password over the phone is attempting fraud and should not be engaged or tested in any way.',
        correctExplanation:
            'You should hang up immediately. Banks never request passwords or one time codes by phone, and sharing them can lead directly to identity theft and financial loss.',
      ),
      QuizQuestion(
        question: 'Which of these is a sign of a "Ponzi Scheme"?',
        options: [
          'A business earning revenue from real products or services',
          'An offer promising guaranteed high returns with no risk',
          'A regulated bank offering modest interest rates',
          'A company reinvesting profits into long term expansion plans',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Legitimate investments always carry some risk. Claims of guaranteed, risk free, high returns usually indicate a scheme that pays old investors using new investors\' money.',
        correctExplanation:
            'Ponzi schemes rely on money from new participants to pay earlier ones. They collapse once new investments stop, leaving most people with significant losses.',
      ),
      QuizQuestion(
        question: 'How can you protect your money when using an ATM?',
        options: [
          'Rely on the machine security and type your PIN openly',
          'Cover the keypad while entering your PIN',
          'Leave printed receipts nearby for later reference',
          'Use unfamiliar machines in isolated locations late at night',
        ],
        correctIndex: 1,
        wrongExplanation:
            'ATM fraud often involves hidden cameras or card skimmers. Exposing your PIN or using unsafe locations increases the risk of theft rather than improving convenience.',
        correctExplanation:
            'Covering the keypad prevents others or hidden cameras from seeing your PIN. This simple habit significantly reduces the risk of card and identity theft.',
      ),
      QuizQuestion(
        question:
            'If an online deal sounds "too good to be true," it usually is...',
        options: [
          'A rare but genuine opportunity available to everyone',
          'A scam designed to steal money or personal data',
          'An accidental pricing error left online temporarily',
          'A generous promotion meant to reward early users extensively',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Scammers rely on excitement and urgency to bypass logic. Extremely generous offers are often designed to trick people into sending money or sharing sensitive information.',
        correctExplanation:
            'Deals that promise extreme rewards usually hide serious risks. Being skeptical, researching the source, and verifying legitimacy helps protect you from losing money to scams.',
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
          'Savings set aside for planned travel and leisure expenses over the year',
          'Cash used regularly for small everyday personal spending',
          'Funds reserved for purchasing expensive lifestyle upgrades later',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Emergency funds are not meant for planned purchases or routine spending. They exist to protect you from sudden financial shocks like medical emergencies, urgent repairs, or unexpected loss of income that cannot be delayed.',
        correctExplanation:
            'An emergency fund is money saved for unexpected situations. It helps cover urgent expenses without borrowing, selling assets, or disrupting long term financial plans when life does not go as expected.',
      ),
      QuizQuestion(
        question: 'How much should you ideally have in an emergency fund?',
        options: [
          'Enough money to cover a few days of basic expenses',
          '3 to 6 months of essential living expenses',
          '100[gem] saved for rare emergencies',
          'Every bit of income saved without spending anything at all',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A few days of savings or a very small amount will not protect you during job loss or serious illness. Several months of expenses give you time to recover without panic or debt.',
        correctExplanation:
            'Saving three to six months of essential expenses creates a strong safety net. It gives you breathing room during job loss, illness, or other disruptions without relying on loans.',
      ),
      QuizQuestion(
        question:
            'Which of these is a valid reason to use your emergency fund?',
        options: [
          'Buying discounted items during a seasonal sale or a limited edition product',
          'Losing your job or facing a major medical emergency',
          'Upgrading to a newer phone model',
          'Purchasing a gift for a special occasion',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Sales, upgrades, and gifts can usually be postponed. Emergency funds are for situations that threaten your health, income, or basic living needs and require immediate financial support.',
        correctExplanation:
            'Emergency funds should be used only for serious situations. Job loss, urgent medical care, or essential repairs qualify because delaying them could cause long term harm.',
      ),
      QuizQuestion(
        question:
            'Why is an emergency fund better than using a credit card for crises?',
        options: [
          'Credit cards are restricted during emergency situations',
          'It avoids high interest debt and added stress',
          'Credit cards allow unlimited spending power',
          'Emergency funds create a better financial image',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Credit cards are not illegal, but they add costly interest. Using borrowed money during emergencies creates long term financial pressure even after the original crisis has passed.',
        correctExplanation:
            'Using savings avoids interest charges and repayment stress. Emergency funds solve the problem immediately without creating new debt that can follow you for months or years.',
      ),
      QuizQuestion(
        question: 'Where is the best place to keep an emergency fund?',
        options: [
          'Kept as cash in an unsecured place at home',
          'A liquid savings account that is easy to access',
          'Invested in high risk assets hoping for growth',
          'Locked away where access is difficult in emergencies',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Emergency money must be safe and accessible. Cash can be lost or stolen, and risky investments may drop in value exactly when the money is urgently needed.',
        correctExplanation:
            'A liquid savings account is ideal for emergency funds. It keeps money safe, accessible, and slightly growing while allowing quick withdrawals during urgent situations.',
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
          'Buying a single company you strongly believe will succeed',
          'Spreading your money across many different types of investments',
          'Regularly moving money between banks to stay flexible',
          'Investing everything into one opportunity because research removes all risk completely',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Diversification is not about confidence or frequent switching. It reduces risk by spreading money across different assets, so poor performance in one area does not heavily damage your overall portfolio.',
        correctExplanation:
            'Diversification means spreading investments across different assets. This lowers risk because losses in one investment can be balanced by gains or stability in others over time.',
      ),
      QuizQuestion(
        question:
            'If you only own stock in one company, what is your biggest risk?',
        options: [
          'The company grows faster than expected',
          'If the company fails, you lose nearly all your money',
          'Dividend payments become unexpectedly large',
          'Your investment depends on many companies surviving every economic and market condition',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Owning a single stock concentrates risk. Even strong companies can fail due to competition, regulation, or mismanagement, leaving you with little or no protection.',
        correctExplanation:
            'Owning only one stock creates high risk. If that company performs poorly or collapses, your entire investment is affected with no diversification to soften the loss.',
      ),
      QuizQuestion(
        question: 'What is a "Mutual Fund"?',
        options: [
          'An informal investment shared between a few friends',
          'A collection of many stocks and bonds managed together',
          'A standard savings account with fixed interest',
          'A personal loan structure that combines family money into one account',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A mutual fund is not a savings account or personal arrangement. It pools money from many investors to buy a wide range of assets, providing diversification through professional management.',
        correctExplanation:
            'A mutual fund pools money from many investors to buy a variety of assets. This allows individuals to diversify easily without managing each investment themselves.',
      ),
      QuizQuestion(
        question:
            'Generally, what is the relationship between "Risk" and "Reward"?',
        options: [
          'Higher risk always results in lower returns',
          'Higher potential reward usually requires taking higher risk',
          'Risk and reward have no meaningful connection',
          'Low risk investments consistently deliver the highest possible returns in all market conditions',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If high returns were guaranteed without risk, everyone would invest the same way. Competition would remove excess returns, leaving higher rewards only for those who accept uncertainty.',
        correctExplanation:
            'In finance, higher potential returns usually require accepting more risk. Investors expect compensation for the chance that outcomes may be worse than expected.',
      ),
      QuizQuestion(
        question: 'Which of these is a "Diversified" portfolio?',
        options: [
          'Invested entirely in a single technology company',
          'Invested entirely in precious metals only',
          'Spread across stocks, bonds, real estate, and cash',
          'Invested only in one highly volatile digital asset regardless of market conditions',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Putting everything into one asset or category increases risk. Different asset classes behave differently, so concentration exposes your wealth to larger and more dangerous swings.',
        correctExplanation:
            'A diversified portfolio holds multiple asset classes. This reduces risk because not all investments decline at the same time, helping smooth overall performance.',
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
          'To purchase a car using borrowed money from a lender',
          'To pay for using a car for a set time and then return it',
          'To temporarily share a car with someone you know',
          'To sign a contract that guarantees you will own the car for free after the lease period ends',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Leasing does not lead to ownership. You pay only for using the car and its depreciation, then return it. There is no free ownership at the end, unlike buying with a loan.',
        correctExplanation:
            'Leasing means paying to use a car for a fixed period. Payments are often lower, but you return the car at the end and do not build ownership or long term value.',
      ),
      QuizQuestion(
        question: 'What is a "Depreciating Asset"?',
        options: [
          'Something that slowly gains value as time passes',
          'Something that loses value over time like cars or phones',
          'A savings account with limited withdrawals',
          'An item that becomes more valuable the longer you keep it due to age and usage',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Most physical items lose value as they age or wear out. They do not gain value simply by being used longer, which is why depreciation matters when making purchase decisions.',
        correctExplanation:
            'A depreciating asset loses value over time. Cars, electronics, and appliances typically decline in value, which is why buying fewer of them can help protect long term wealth.',
      ),
      QuizQuestion(
        question: 'When you "Buy" a home with a mortgage, you are building...',
        options: [
          'A permanent payment obligation with no benefit',
          'Equity which represents your actual ownership value',
          'Public infrastructure connected to the house',
          'A rental style arrangement where no ownership is gained despite making payments',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Mortgage payments are not the same as rent. Each payment reduces the loan balance, increasing ownership. Over time, this builds equity rather than leaving you with nothing.',
        correctExplanation:
            'Equity grows as you repay the loan. It represents the portion of the home you truly own and contributes directly to your net worth over time.',
      ),
      QuizQuestion(
        question: 'What is a major advantage of Renting/Leasing?',
        options: [
          'Guaranteed wealth growth every month',
          'More flexibility to move and fewer maintenance responsibilities',
          'Lower total cost in every possible situation',
          'A structure that automatically converts rent into ownership without any additional cost',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Renting does not convert into ownership or guarantee savings. Its advantage lies in flexibility and reduced responsibility, not in long term wealth creation.',
        correctExplanation:
            'Renting or leasing offers flexibility and fewer repair responsibilities. This can be helpful for people who expect to move, have uncertain plans, or want lower upfront commitments.',
      ),
      QuizQuestion(
        question:
            'Which of these usually helps your long-term Net Worth the most?',
        options: [
          'Leasing new expensive cars every few years',
          'Buying a reliable used car and keeping it long term',
          'Using high interest loans for lifestyle spending',
          'Regularly upgrading vehicles to enjoy new features while accepting ongoing depreciation and repeated payments',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Frequently upgrading vehicles leads to repeated depreciation and ongoing payments. This drains money that could otherwise be saved or invested to improve long term financial stability.',
        correctExplanation:
            'Keeping a reliable used car avoids rapid depreciation and constant payments. The savings can be invested or used to reduce debt, which strongly supports long term net worth.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q14',
    title: 'Pay yourself first',
    subtitle: 'The secret to consistent saving',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What does "pay yourself first" mean?',
        options: [
          'Setting aside savings immediately before paying bills or spending money.',
          'Buying something small for yourself every month to feel motivated.',
          'Choosing to prioritize personal enjoyment like shopping before financial obligations.',
          'Managing your salary manually instead of using automatic systems.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The idea is not about personal rewards or motivation spending. It focuses on disciplined saving behavior, not emotional purchases or lifestyle choices made after receiving income.',
        correctExplanation:
            'Pay yourself first means saving or investing a portion of your income immediately when you get paid. By doing this before spending on anything else, you make saving automatic and protect it from daily spending decisions.',
      ),
      QuizQuestion(
        question:
            'Why is this more effective than saving whatever is left over?',
        options: [
          'Because it is natural for anyone to spend what remains if it is easily available.',
          'Because banks design systems that make end of month saving difficult.',
          'Because saving later requires complex budgeting tools and constant tracking.',
          'Because it guarantees higher interest rates automatically.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'While systems and tools may influence behavior, the core issue is human spending habits. The problem is not complexity or banks, but the tendency to spend available money before thinking about savings.',
        correctExplanation:
            'Saving first works because it removes temptation. When money is saved at the start of the month, it is no longer available for impulse spending, making consistent saving far easier than hoping money remains later.',
      ),
      QuizQuestion(
        question: 'Where should the "pay yourself first" money ideally go?',
        options: [
          'Into a high yield savings or long term investment account.',
          'Into the same account used for rent, food, and entertainment for the whole family.',
          'Into cash stored at home for quick and flexible access.',
          'Into an account that is checked daily for balance updates.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Daily use or easily accessible locations increase the chance of spending the money. The goal is to separate savings from routine transactions so it remains untouched and continues growing over time.',
        correctExplanation:
            'Placing saved money into a separate savings or investment account reduces temptation and creates psychological distance from spending. This separation helps ensure the money is preserved for future goals instead of daily expenses.',
      ),
      QuizQuestion(
        question: 'If you pay yourself last, you are essentially doing what?',
        options: [
          'Giving your money to everyone else first and hoping some remains.',
          'Carefully balancing expenses so saving happens naturally.',
          'Building financial discipline through delayed gratification and building financial integrity.',
          'Avoiding unnecessary spending through strict budgeting rules.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Paying yourself last does not build discipline for most people. Bills, subscriptions, and impulse spending usually consume income first, leaving little opportunity to save consistently or meaningfully.',
        correctExplanation:
            'When you pay yourself last, saving becomes optional and unreliable. Other expenses take priority, and savings only happen if money accidentally remains, which often results in little or no progress toward long term goals.',
      ),
      QuizQuestion(
        question:
            'Even saving 5[gem] from every paycheck is better than 0[gem] because?',
        options: [
          'It builds a strong lifelong habit of saving consistently.',
          'It will eventually be enough to buy expensive items without any effort.',
          'It immediately improves your standard of living.',
          'It guarantees financial independence within a few years.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Small amounts alone do not guarantee wealth or major purchases. Their real value lies in behavior change, not immediate results or promises of rapid financial transformation.',
        correctExplanation:
            'Small savings create consistency and reinforce the habit of paying yourself first. Once the habit exists, increasing the amount becomes much easier, making long term financial growth possible even from very small beginnings.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q15',
    title: 'Understanding insurance',
    subtitle: 'Managing life\'s big risks',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is the primary purpose of insurance?',
        options: [
          'To protect yourself from large financial losses you could not afford alone.',
          'To earn a huge profit when you want by regularly paying a company money.',
          'To reduce yearly expenses through routine reimbursements by claiming insurance.',
          'To replenish your personal savings entirely during emergencies.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Insurance is not designed to generate profit or replace savings. Its role is protection, not income creation, and it does not improve daily cash flow or guarantee financial gains.',
        correctExplanation:
            'Insurance exists to protect you from rare but severe financial shocks. By paying a small, predictable amount regularly, you transfer the risk of a potentially devastating expense to the insurance provider.',
      ),
      QuizQuestion(
        question: 'What is an insurance premium?',
        options: [
          'The amount you pay regularly to keep your insurance coverage active.',
          'A bonus paid to customers who never file claims.',
          'A special fee to get the premium version of insurance which gives much more money.',
          'A flexible fee that only applies during emergencies.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A premium is not a reward or a conditional fee. It certainly doesn\'t have tiers that give much more money. It must be paid consistently regardless of claims, and stopping payment usually results in loss of coverage.',
        correctExplanation:
            'The premium is the recurring cost of maintaining insurance protection. Paying it on time keeps the policy active, while missing payments can result in losing coverage exactly when you might need it most.',
      ),
      QuizQuestion(
        question: 'What is a deductible?',
        options: [
          'The portion of a claim you must pay before insurance covers the rest.',
          'The money returned to you if no claims are made in a certain period of time.',
          'A pricing adjustment based on income level.',
          'A fixed service charge added to every bill regardless of claims.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A deductible is not refunded or adjusted automatically. It represents the amount you agree to cover yourself, ensuring shared responsibility before the insurer pays anything.',
        correctExplanation:
            'A deductible is the amount you pay out of pocket before insurance contributes. Higher deductibles usually reduce premium costs, but they increase the immediate expense when a claim is made.',
      ),
      QuizQuestion(
        question: 'Which of these is not a typical type of insurance?',
        options: [
          'Health insurance.',
          'Car insurance.',
          'Ghost Insurance.',
          'Life insurance.',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Insurance focuses on protecting against serious financial risks like illness, accidents, or death. Paranormal outcomes do not create the kind of financial exposure insurance is designed to manage.',
        correctExplanation:
            'Most insurance exists to protect against real world risks that could cause significant financial harm. Coverage is built around health, property or travel but exceptions such as "Ghost Insurance" also exist. A UK hotel owner secured a policy protecting against death or injury caused by spirits',
      ),
      QuizQuestion(
        question: 'Is insurance an investment?',
        options: [
          'No, it is a risk management tool that costs money for protection.',
          'Yes, because unused coverage increases future returns like like stocks and gold.',
          'Only when claims exceed premiums paid.',
          'It depends on personal luck and timing.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Insurance does not generate returns or compound over time. Its value lies in protection, not growth, and measuring it by profit misunderstands its purpose.',
        correctExplanation:
            'Insurance protects existing wealth rather than growing it. While investments aim to increase money over time, insurance exists to prevent financial ruin from unexpected and costly events.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q16',
    title: 'Retirement: starting early',
    subtitle: 'Planning for your future self',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is retirement?',
        options: [
          'When you stop working and live using savings, pensions, and investments.',
          'A phase where income continues without any financial planning.',
          'A long period of rest that replaces the need for money entirely.',
          'A lifestyle change that guarantees comfort regardless of preparation or career.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Retirement does not remove the need for planning or income. Comfort is not guaranteed automatically, and financial independence only exists if sufficient savings and investments were built during working years.',
        correctExplanation:
            'Retirement means reaching a point where you no longer depend on a paycheck. Your living expenses are covered by savings, investments, or pensions, giving you freedom over how you spend your time.',
      ),
      QuizQuestion(
        question: 'Why is starting at age 20 better than starting at age 40?',
        options: [
          'You give compound growth more time to multiply your money.',
          'You earn higher interest simply because you are younger.',
          'You can save less money overall and still retire instantly.',
          'Early saving guarantees identical results regardless of contribution size.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Age itself does not create higher returns or instant results. The advantage comes from time, not special treatment, and delaying savings requires much higher contributions later to reach the same outcome.',
        correctExplanation:
            'Starting early allows compound growth to work over decades. Money earns returns, which then earn their own returns, creating exponential growth that becomes extremely difficult to replicate when starting later in life.',
      ),
      QuizQuestion(
        question: 'What is a pension?',
        options: [
          'Regular income paid after retirement by an employer or government.',
          'A personal savings account that you withdraw freely at any age.',
          'A guaranteed income source that automatically adjusts to lifestyle choices.',
          'A temporary benefit paid only during the first year of retirement.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A pension is not fully flexible or lifestyle based. It follows predefined rules, payout structures, and eligibility conditions that are established long before retirement begins.',
        correctExplanation:
            'A pension provides regular income during retirement, usually funded during working years. It helps replace salary after you stop working and adds stability to long term financial planning.',
      ),
      QuizQuestion(
        question: 'How does inflation affect your retirement plan?',
        options: [
          'Your money loses purchasing power over time.',
          'It reduces costs as technology improves over time.',
          'It has no meaningful impact on long term planning.',
          'It automatically increases savings at the same rate.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Inflation does not cancel itself out automatically. Ignoring rising prices can severely reduce purchasing power, making savings feel insufficient even if the numerical amount appears large.',
        correctExplanation:
            'Inflation slowly reduces the value of money over time. Retirement plans must grow faster than inflation so future expenses can be covered without lowering your standard of living.',
      ),
      QuizQuestion(
        question: 'What is the biggest factor in growing a retirement fund?',
        options: [
          'Time and consistent long term investing.',
          'Choosing a famous institution to manage funds.',
          'Making one perfectly timed investment decision.',
          'Relying on market luck during strong years.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Reputation, luck, or perfect timing do not reliably build wealth. Sustainable growth comes from steady contributions and patience rather than rare wins or short term market movements.',
        correctExplanation:
            'Time and consistency allow investments to compound and recover from volatility. Regular investing over long periods reduces risk and steadily builds wealth, even without perfect market timing.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q17',
    title: 'Unit price shopping',
    subtitle: 'Being a smart consumer',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is unit price?',
        options: [
          'The cost per unit of weight, volume, or item',
          'The final amount shown on the price label before tax.',
          'The discounted price applied during a sale event.',
          'The average price of similar products across brands and stores.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The total or discounted price alone does not show true value. Unit price focuses on how much you pay for a specific quantity, which allows accurate comparison across different sizes and brands.',
        correctExplanation:
            'Unit price shows how much each unit costs, such as per gram or per item. This makes it easier to compare products of different sizes and avoid being misled by packaging or total price alone.',
      ),
      QuizQuestion(
        question: 'Why is it helpful to check the unit price?',
        options: [
          'To determine which size or brand actually costs less per unit.',
          'To understand how much effort went into packaging design.',
          'To follow store guidelines for careful shopping.',
          'To estimate transportation and storage costs for the product.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Packaging, guidelines, and logistics do not determine value for consumers. Unit price matters because it cuts through marketing and highlights which option gives more product for the same money.',
        correctExplanation:
            'Checking the unit price reveals the real cost of a product. It helps you see past marketing tactics and choose the option that provides the most value for the amount you are actually getting.',
      ),
      QuizQuestion(
        question:
            'If a 10oz box costs 5[gem] and a 20oz box costs 8[gem], which is the better value?',
        options: [
          'The 20oz box, because the cost per ounce is lower.',
          'The smaller box, because it has a lower total price.',
          'Both boxes provide equal value.',
          'The choice depends on brand reputation and shelf placement.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Total price alone does not determine value. When comparing unit prices, the larger box costs less per ounce, making it the better deal despite having a higher upfront cost.',
        correctExplanation:
            'The 20oz box has a lower unit price because you pay less per ounce. Comparing cost per unit shows which option delivers more product for each unit of money spent.',
      ),
      QuizQuestion(
        question: 'Does bulk pricing always save you money?',
        options: [
          'No, sometimes smaller packages have a lower unit price.',
          'Yes, buying more always reduces the cost per unit.',
          'Only when shopping at warehouse style stores.',
          'Yes, because bulk purchases are cheaper due to reduced packaging waste.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Buying more does not guarantee savings. Some bulk items are priced higher per unit, so checking the unit price is essential before assuming a larger size is a better deal.',
        correctExplanation:
            'Bulk pricing can be misleading. While larger sizes sometimes cost less per unit, this is not always true, and comparing unit prices helps avoid paying more unnecessarily.',
      ),
      QuizQuestion(
        question: 'What is a marketing trap related to pricing?',
        options: [
          'Using bulk or value labels even when the unit price is not lower.',
          'Placing popular items at eye level on shelves.',
          'Using bright colors and sale signs to attract attention.',
          'Combining placement, labeling, and visual cues to influence buying decisions.',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Focusing on a single tactic misses the bigger picture. Stores often combine multiple strategies to influence perception, making products seem like better deals even when the unit price is higher.',
        correctExplanation:
            'Marketing traps rely on psychology rather than value. By understanding tactics like placement, labeling, and visual cues, shoppers can rely on unit price instead of being influenced by appearance.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q18',
    title: 'Fixed vs variable expenses',
    subtitle: 'Understanding your bills',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is a fixed expense?',
        options: [
          'An expense that stays the same each month, such as rent or a subscription.',
          'An expense that changes depending on daily choices and habits but paying it is fixed.',
          'A cost that disappears once income increases.',
          'A required payment that adjusts automatically with inflation and usage.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Fixed expenses do not change based on short term behavior. They are predictable and recurring, making them easier to plan for but harder to reduce quickly without renegotiation or long term changes.',
        correctExplanation:
            'A fixed expense remains consistent from month to month. Because the amount does not vary much, it provides predictability in budgeting, but it also limits flexibility when trying to reduce expenses quickly.',
      ),
      QuizQuestion(
        question: 'What is a variable expense?',
        options: [
          'An expense that changes based on usage or personal choices.',
          'An expense that remains the same regardless of behavior.',
          'A payment that is locked in by long term contracts that are variable in nature.',
          'A cost that grows automatically every year without control.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Variable expenses are not fixed or contract based. They fluctuate depending on how much you use a service or product, giving you more control over the final amount.',
        correctExplanation:
            'Variable expenses change from month to month depending on behavior and usage. Because they are flexible, they are often the easiest expenses to adjust when trying to save money.',
      ),
      QuizQuestion(
        question:
            'If you need to save money quickly, which expenses should you cut first?',
        options: [
          'Variable expenses, because they can be adjusted immediately.',
          'Fixed expenses, since they are fixed and can be cut immediately and do not take priority.',
          'Income related costs that affect earning ability.',
          'Long term financial obligations that cannot be changed.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Fixed expenses are difficult to change quickly. Contracts and obligations limit flexibility, making variable expenses the more practical choice for immediate savings.',
        correctExplanation:
            'Variable expenses respond quickly to changes in behavior. Cutting back on flexible spending like dining or entertainment can reduce costs immediately without renegotiating contracts or disrupting essential obligations.',
      ),
      QuizQuestion(
        question:
            'Is a gym membership with a monthly contract fixed or variable?',
        options: [
          'Fixed, because the payment stays the same each month.',
          'Variable, since usage changes how often you attend.',
          'Partially variable depending on motivation.',
          'A flexible cost that adjusts with attendance and effort.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Usage does not affect the payment amount. Even if attendance changes, the contracted monthly fee remains the same, making it a fixed expense.',
        correctExplanation:
            'A contracted gym membership is a fixed expense because the payment amount does not change month to month. Whether you attend often or rarely, the cost remains predictable.',
      ),
      QuizQuestion(
        question: 'Why are utility bills considered variable expenses?',
        options: [
          'They depend on how much electricity, water, or gas you use.',
          'They remain constant across all seasons.',
          'They are controlled entirely by providers and hence they are variable.',
          'They increase only when income rises.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Utility bills are not fixed or income based. They fluctuate because usage changes, making them variable and influenced by habits, weather, and consumption patterns.',
        correctExplanation:
            'Utility bills vary based on usage. Changes in habits, seasons, or efficiency directly affect how much you pay, which makes these expenses flexible and adjustable over time.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q19',
    title: 'Financial independence',
    subtitle: 'Reaching the ultimate goal',
    difficulty: QuizDifficulty.hard,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is financial independence?',
        options: [
          'When your investment income reliably covers all living expenses.',
          'Having a high paying job that provides long term security.',
          'Reaching a point where expenses feel manageable most of the time.',
          'Earning enough salary to stop worrying about money while continuing full time work.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A high income job still depends on trading time for money. Financial independence means income continues even without working, removing dependence on employment for meeting daily living expenses.',
        correctExplanation:
            'Financial independence occurs when your investments generate enough income to cover your living costs. At this stage, working becomes optional, allowing you to choose how to spend your time rather than working out of necessity.',
      ),
      QuizQuestion(
        question: 'What is the 4% rule in retirement planning?',
        options: [
          'A guideline suggesting you can withdraw 4% of savings annually with low risk.',
          'A rule that limits how much income you are allowed to earn.',
          'A fixed return rate promised by conservative investments.',
          'A saving strategy where exactly 4% of income is invested every year and it leads to fastest growth.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The 4% rule is not about guaranteed returns or saving percentages. It is a withdrawal guideline based on historical data, not a promise of fixed performance or universal safety.',
        correctExplanation:
            'The 4% rule suggests that withdrawing about 4% of your invested savings each year can allow the portfolio to last for decades. It is a guideline used for planning, not a guaranteed outcome.',
      ),
      QuizQuestion(
        question:
            'If you need 40,000[gem] per year to live, how much savings do you need using the 4% rule?',
        options: [
          '1,000,000[gem] invested to support long term withdrawals.',
          '400,000[gem] spread across multiple savings accounts.',
          '2,000,000[gem] invested aggressively to reduce withdrawal risk.',
          'An amount that depends entirely on future market performance.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Using the 4% rule, required savings are calculated by multiplying annual expenses by twenty five. Lower amounts would not safely support the needed yearly withdrawals over long periods.',
        correctExplanation:
            'If you need 40,000[gem] per year, the 4% rule suggests saving about 1,000,000[gem]. With this amount invested, withdrawing 4% annually aligns with your spending needs under typical long term assumptions.',
      ),
      QuizQuestion(
        question:
            'Achieving financial independence early usually requires what?',
        options: [
          'Maintaining a high savings rate, often saving 30 to 50 percent of income.',
          'Spending more money early to enjoy life before responsibilities increase.',
          'Keeping money liquid to avoid investment risk and be able to buy future freedom.',
          'Waiting for income to naturally increase over time.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Early independence rarely happens by chance or waiting. It requires deliberate action, disciplined saving, and intentional lifestyle choices rather than relying on future raises or uncontrolled spending.',
        correctExplanation:
            'Reaching independence early depends on saving a large portion of income and investing consistently. Living below your means accelerates wealth building and shortens the time needed to reach financial freedom.',
      ),
      QuizQuestion(
        question: 'What does the acronym fire stand for in finance?',
        options: [
          'Financial independence, retire early.',
          'A structured system for managing long term expenses.',
          'A government supported retirement assistance program.',
          'A strategy focused entirely on real estate investing returns.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Fire is not a product, program, or single investment strategy. It describes a broader philosophy focused on maximizing savings and investment to gain control over time and work choices.',
        correctExplanation:
            'Fire stands for financial independence, retire early. It represents a movement focused on aggressive saving, intentional spending, and investing to achieve freedom from mandatory work as early as possible.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l2_q20',
    title: 'Evaluating business ideas',
    subtitle: 'Thinking like an investor',
    difficulty: QuizDifficulty.hard,
    requiredLevel: 2,
    questions: [
      QuizQuestion(
        question: 'What is a business value proposition?',
        options: [
          'The unique benefit or solution a business offers to solve a customer problem.',
          'The price listed for a product or service.',
          'The overall reputation a company builds over time.',
          'A combination of branding, office location, and visual identity used to appear professional.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A value proposition is not about branding, pricing alone, or appearance. It focuses on the specific problem a business solves and why customers should choose it over alternatives.',
        correctExplanation:
            'A value proposition clearly explains the problem being solved and the benefit delivered to customers. Strong businesses communicate this clearly, making it obvious why their solution is better or more relevant than competitors.',
      ),
      QuizQuestion(
        question: 'Why is market research critical before starting a business?',
        options: [
          'To confirm that enough people want the product and are willing to pay for it.',
          'To identify competitors and copy their pricing exactly.',
          'To reduce operational costs by choosing cheaper suppliers.',
          'To collect opinions that support the idea even if customers are unlikely to buy.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Market research is not about validation bias or cost cutting alone. Its main purpose is to test real demand and reduce the risk of building a product that customers do not actually want.',
        correctExplanation:
            'Market research helps verify real customer demand before investing time and money. Even strong ideas fail if customers are unwilling to pay, so research reduces risk by grounding decisions in actual behavior.',
      ),
      QuizQuestion(
        question: 'What does scalability mean for a business?',
        options: [
          'The ability to grow revenue much faster than operating costs.',
          'Hiring more employees to handle increased workload.',
          'Expanding office space to accommodate growth.',
          'Growing slowly while maintaining identical cost structures at every stage.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Scalability is not about physical expansion or linear growth. A scalable business increases revenue without needing costs to rise at the same rate, allowing profits to grow more efficiently.',
        correctExplanation:
            'Scalability means a business can increase income significantly without proportional increases in cost. This allows profits to grow faster over time, making the business more attractive to investors.',
      ),
      QuizQuestion(
        question:
            'If a product costs 10[gem] to make and sells for 12[gem], what is the main issue?',
        options: [
          'The profit margin is too small.',
          'The price is too high for most customers.',
          'The product is guaranteed to fail.',
          'The business will always lose money.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A small margin may look profitable initially, but it often disappears once marketing, distribution, overhead, and growth expenses are included, leaving little room for sustainable operations.',
        correctExplanation:
            'Healthy margins are essential for survival. Businesses must cover marketing, salaries, rent, and future growth, so pricing must leave enough profit beyond just production costs.',
      ),
      QuizQuestion(
        question: 'Successful businesses primarily focus on what?',
        options: [
          'Solving a real customer problem.',
          'Creating the most visually appealing brand.',
          'Maximizing short term profit at all costs.',
          'Expanding quickly without validating demand.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Branding and profit matter, but they follow value creation. Businesses that ignore real customer needs often fail because appearance and short term gains cannot replace long term usefulness.',
        correctExplanation:
            'Strong businesses succeed by consistently delivering real value. When customer problems are solved effectively, trust grows, demand increases, and profitability follows naturally over the long term.',
      ),
    ],
  ),
];

final List<QuizMetadata> _level3Quizzes = [
  // Quiz 1–3: Easy (Level 3)
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
          'Higher income earners pay a higher percentage of their income in tax',
          'Everyone pays the same percentage regardless of income level',
          'A tax system based on progress in school and education outcomes',
          'A tax that decreases as you earn more money over time',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A progressive tax system is specifically designed to avoid a flat rate where everyone pays the same percentage. Instead, it ensures that as you climb the income ladder, you contribute a progressively larger portion of your earnings.',
        correctExplanation:
            'In a progressive tax framework, higher earners contribute a larger percentage of their income to support essential public services. This system aims to create a more equitable distribution of the tax burden across different income levels.',
      ),
      QuizQuestion(
        question: 'What is a "Tax Deduction"?',
        options: [
          'An amount that reduces your total taxable income',
          'A penalty charged for paying taxes after the deadline',
          'A special payment given by the government to taxpayers',
          'The final amount of tax you owe after calculations',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A tax deduction is not a punishment for late filing or a direct payment from the treasury. It is a critical mechanism that allows you to lower the actual amount of your income subject to taxation.',
        correctExplanation:
            'Tax deductions are valuable financial tools that reduce the amount of your total income the government can legally tax. By utilizing these deductions, you effectively lower your overall tax bill while potentially keeping more of your salary.',
      ),
      QuizQuestion(
        question: 'What is the purpose of a "W-4 Form"?',
        options: [
          'To tell your employer how much tax to withhold from your paycheck',
          'To apply for a new job with an employer',
          'To file your taxes at the end of the year',
          'To formally request a raise or promotion',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The W-4 form is primarily concerned with real-time tax withholding during your employment, rather than the final year-end tax filing process. It does not serve as a job application or a formal request for promotions.',
        correctExplanation:
            'The W-4 form allows you to provide specific instructions to your employer regarding how much federal income tax should be withheld from each paycheck. Correct withholding ensures you do not end up with a large surprise tax bill.',
      ),
      QuizQuestion(
        question: 'What does "FICA" tax usually fund?',
        options: [
          'Social Security and Medicare',
          'Maintenance of national parks and public land',
          'Military operations and defense spending',
          'Scientific research and space programs',
        ],
        correctIndex: 0,
        wrongExplanation:
            'FICA taxes are legally dedicated to specific social safety net programs rather than general government expenditures like national park maintenance or scientific research. These funds are carefully ring-fenced to provide support for the elderly and disabled.',
        correctExplanation:
            'FICA contributions are mandatory payroll taxes that directly fund Social Security and Medicare programs in the United States. These vital programs provide critical income support and healthcare coverage for millions of retirees and individuals with long-term disabilities.',
      ),
      QuizQuestion(
        question: 'Why do some people receive a "Tax Refund"?',
        options: [
          'They overpaid their taxes throughout the year',
          'They won a government-sponsored contest',
          'The government had excess funds to return',
          'They worked fewer hours than expected',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Receiving a tax refund is not a sign of winning a government contest or receiving a generic gift from the state. It simply represents the return of your own money that was over-withheld during the previous year.',
        correctExplanation:
            'A tax refund occurs when the total amount of taxes you paid during the calendar year exceeds your actual tax liability. The government essentially returns this interest-free loan to you after you file your annual tax return.',
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
          'Your existing checking account balance',
          'A temporary loan provided by the bank',
          'Your future income that has not been earned yet',
          'A shared pool of digital currency managed by banks',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Using a debit card does not involve taking out a temporary loan or tapping into unearned future income. It is also not connected to any shared digital currency pool managed collectively by various banks.',
        correctExplanation:
            'When you use a debit card, the funds are immediately withdrawn from your personal checking account. This direct access helps you manage your spending effectively by limiting your purchases to the money you already own.',
      ),
      QuizQuestion(
        question: 'When you use a "Credit Card," you are...',
        options: [
          'Taking a short-term loan from the bank',
          'Spending only money you already own',
          'Receiving free products from stores',
          'Reducing your total debt automatically',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A credit card is not a tool for spending your own savings or receiving free merchandise from retailers. It does not automatically reduce your debt; in fact, improper use can significantly increase your financial obligations.',
        correctExplanation:
            'Using a credit card effectively creates a short-term loan from the issuing bank that you must eventually repay. If the balance is not paid in full each month, you may be charged significant interest fees.',
      ),
      QuizQuestion(
        question:
            'Which card usually offers better "Fraud Protection" for shoppers?',
        options: [
          'Credit card',
          'Debit card with a personal identification number',
          'Both provide identical protection in all situations',
          'Cash stored securely in a wallet',
        ],
        correctIndex: 0,
        wrongExplanation:
            'While debit cards have some security features, they typically do not match the robust consumer protections offered by credit cards. Cash and PIN-based debit transactions are often much harder to dispute after fraud has occurred.',
        correctExplanation:
            'Credit cards generally provide superior fraud protection because any unauthorized charges affect the bank\'s funds first rather than your personal cash. This makes it much easier to dispute transactions and reverse fraudulent charges quickly.',
      ),
      QuizQuestion(
        question: 'What is a "Credit Limit"?',
        options: [
          'The maximum amount the bank allows you to borrow on the card',
          'The minimum amount you must spend each month',
          'The total number of credit cards you may own',
          'A deadline for completing purchases',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A credit limit is not a mandatory monthly spending requirement or a restriction on the number of cards you can possess. It is also completely unrelated to any deadlines for making specific purchases in stores.',
        correctExplanation:
            'The credit limit represents the absolute maximum amount of money the financial institution allows you to borrow at any given time. Maintaining your balance well below this limit is vital for building a strong score.',
      ),
      QuizQuestion(
        question:
            'What happens if you only pay the "Minimum Balance" on a credit card?',
        options: [
          'You pay a large amount of interest and the debt lasts for years',
          'Your debt disappears quickly',
          'Nothing changes over time',
          'The bank rewards you for consistency',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Paying only the minimum balance will not make your debt vanish quickly or result in special rewards from the bank. Instead, it ensures that your financial situation remains stagnant while total interest costs continue rising.',
        correctExplanation:
            'If you only make the minimum monthly payment, a huge portion of that money goes toward interest rather than the original debt. Consequently, it can take many years or even decades to fully pay off.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q3',
    title: 'Advanced Insurance',
    subtitle: 'Liability and comprehensive coverage',
    difficulty: QuizDifficulty.easy,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What does "Liability Coverage" in car insurance pay for?',
        options: [
          'Damage or injuries you cause to other people or their property',
          'Repairs to your own vehicle after an accident',
          'Replacement of a stolen vehicle',
          'The full cost of purchasing a new car',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Liability coverage is not intended to pay for repairs to your own car or to replace a vehicle that has been stolen. It also does not cover the expenses associated with buying a brand-new automobile.',
        correctExplanation:
            'Liability coverage is a legal requirement in many places because it pays for the medical bills and property repairs of other people when you are at fault in an accident, protecting your personal assets.',
      ),
      QuizQuestion(
        question: 'What is "Comprehensive Coverage"?',
        options: [
          'Protection against non-accident events like theft, fire, or weather damage',
          'Insurance coverage for every possible situation',
          'A category of medical insurance',
          'Insurance that only applies during weekends',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Despite its broad name, comprehensive coverage does not protect you against every conceivable scenario or serve as a medical insurance policy. It is also active at all times, not just during the weekend period.',
        correctExplanation:
            'Comprehensive coverage protects your vehicle from non-collision events such as theft, vandalism, fire, or damage caused by extreme weather. It provides peace of mind against many unpredictable risks that are outside of your control.',
      ),
      QuizQuestion(
        question:
            'Why might a 1000[GEM] deductible be better than a 250[GEM] deductible?',
        options: [
          'It lowers your monthly premium, reducing regular insurance costs',
          'It costs less when you file a claim',
          'It increases how much the insurer pays',
          'It provides no meaningful benefit',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A higher deductible actually increases your out-of-pocket costs when you file an insurance claim and does not increase the insurer\'s total payout. It is a calculated trade-off that offers very specific financial benefits.',
        correctExplanation:
            'Choosing a higher deductible, such as 1000[GEM], typically results in a lower monthly premium because you are assuming more of the initial risk. This strategy can save you a significant amount of money over time.',
      ),
      QuizQuestion(
        question: 'What is "Disability Insurance"?',
        options: [
          'Insurance that replaces part of your income if you are unable to work',
          'Insurance coverage for vehicle accidents',
          'Insurance designed only for retirees',
          'A variation of life insurance policies',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Disability insurance is not a form of vehicle coverage or a policy designed exclusively for retirees. While it shares some concepts with life insurance, its primary focus is on protecting your current ability to earn.',
        correctExplanation:
            'Disability insurance provides a crucial safety net by replacing a portion of your regular income if an illness or injury prevents you from working. This ensures that you can still pay for your essential needs.',
      ),
      QuizQuestion(
        question: 'An insurance "Claim" is...',
        options: [
          'A request to the insurance company to pay for a covered loss',
          'The monthly payment required to keep insurance active',
          'A special type of savings account',
          'The total value of insured property',
        ],
        correctIndex: 0,
        wrongExplanation:
            'An insurance claim is not the regular premium you pay to keep a policy active or a specialized type of savings account. It also does not represent the total appraised value of your property.',
        correctExplanation:
            'A claim is a formal notification and request sent to your insurance provider asking them to cover the costs of a loss that is protected under your policy. This initiates the review and payment process.',
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
          'Calculating your total tax debt over multiple years',
          'Determining the long-term market value of a house',
          'Finding the best advertised interest rate at a local bank branch',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The Rule of 72 is specifically designed for calculating mathematical growth and doubling times rather than determining property values, figuring out complex tax debts, or searching for the best advertised interest rates at local banks.',
        correctExplanation:
            'The Rule of 72 is an extremely useful mental calculation that allows investors to quickly estimate how many years it will take for an investment to double in value at any given fixed annual rate.',
      ),
      QuizQuestion(
        question:
            'Compound interest is often called the "Eighth Wonder of the World" because...',
        options: [
          'It allows you to earn interest on your previous interest',
          'It has existed for hundreds of years in financial systems',
          'It ranks just after seven major historical discoveries',
          'It is required by law for all savings and investment accounts',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Unlike simple interest, which only pays on your initial principal, compound interest rewards you for keeping your money invested over time. It is not simply a historical discovery or a legal requirement for all accounts.',
        correctExplanation:
            'Compound interest is uniquely powerful because it generates earnings on both your initial principal and the accumulated interest from previous periods. This creates a powerful snowball effect that can lead to massive long-term wealth building.',
      ),
      QuizQuestion(
        question:
            'Which factor has the BIGGEST impact on compound interest growth?',
        options: [
          'The number of years the money stays invested',
          'The initial amount of money you invest at the beginning',
          'The design or color of your bank card',
          'The official name of the investment product',
        ],
        correctIndex: 0,
        wrongExplanation:
            'While starting with a large initial sum is helpful, time remains the superior factor in the growth equation. The color of your bank card or the product\'s name has absolutely zero impact on mathematical growth.',
        correctExplanation:
            'While the initial amount and interest rate are certainly important, time is the most critical ingredient for compound interest. The longer your money remains invested, the more opportunities it has to multiply exponentially over time.',
      ),
      QuizQuestion(
        question: 'What is the "APY" (Annual Percentage Yield)?',
        options: [
          'The real interest rate you earn including compounding',
          'The official name of a financial institution',
          'A fee charged for withdrawing money early',
          'The total amount of money currently in your account',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Annual Percentage Yield is not the name of a bank, a fee for early withdrawals, or the current total balance of your account. It is strictly a mathematical representation of your true investment returns.',
        correctExplanation:
            'The Annual Percentage Yield provides a standardized way to compare different financial products by reflecting the total amount of interest you actually earn in a year, specifically taking the effects of compounding into account accurately.',
      ),
      QuizQuestion(
        question: 'Inflation is the "enemy" of compound interest because...',
        options: [
          'It reduces the purchasing power of the money you earn',
          'It forces banks to shut down operations',
          'It automatically increases your tax rate',
          'It prevents mathematical growth formulas from working',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Inflation does not physically stop mathematical growth formulas from working or automatically increase your personal tax rate. However, it can make your growing balance feel much smaller by reducing the real value of your [GEM].',
        correctExplanation:
            'Inflation is dangerous because it causes the general price of goods to rise over time, which reduces what your [GEM] can actually buy. True wealth only grows when your returns significantly exceed inflation rates.',
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
          'A certificate of partial ownership in a corporation',
          'A loan provided to a company with fixed repayment terms',
          'A ticket similar to a lottery entry',
          'A promise that guarantees free products for life',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Stock ownership is fundamentally different from providing a loan to a company or purchasing a lottery ticket. It does not provide any guaranteed free products or fixed repayment terms like a traditional debt instrument.',
        correctExplanation:
            'A share of stock represents a legal claim to a small piece of a corporation\'s ownership. As the company grows and becomes more profitable, the value of your ownership share typically increases as well.',
      ),
      QuizQuestion(
        question: 'What are "Dividends"?',
        options: [
          'A portion of a company\'s profit paid out to stockholders',
          'Fees charged by investment platforms',
          'The market price of one share',
          'A form of long-term company debt',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Dividends are not fees charged by brokers or the current market price of a single share. They are also not a form of company debt that must be repaid to lenders at a future date.',
        correctExplanation:
            'Dividends are regular payments made by a corporation to its shareholders out of its annual profits. They provide a source of passive income and can be reinvested to further accelerate your long-term wealth building.',
      ),
      QuizQuestion(
        question: 'What does a "Diversified Portfolio" mean?',
        options: [
          'Spreading your money across many different companies and industries',
          'Buying only one high-priced stock',
          'Frequently buying and selling the same stock every day',
          'Investing only in businesses located near you',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Diversification is the opposite of buying only one high-priced stock or trading the same security frequently. Investing only in local businesses also fails to provide the broad market exposure required for true safety.',
        correctExplanation:
            'A diversified portfolio involves allocating your investment capital across a wide range of different assets and sectors. This strategy is essential for reducing overall risk by ensuring that no single failure can ruin your finances.',
      ),
      QuizQuestion(
        question: 'What is a "Market Index" (like the S&P 500)?',
        options: [
          'A tool that tracks the performance of a specific group of stocks',
          'A published list of the cheapest products available',
          'The official building where stocks are traded',
          'A government tax applied to stock profits',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A market index is not a physical building where trading occurs or a government tax applied to profits. It is also not a published list of the cheapest products currently available in the marketplace.',
        correctExplanation:
            'A market index is a statistical measure that tracks the performance of a specific group of stocks. It serves as a benchmark for the overall health of the economy or a particular industry sector.',
      ),
      QuizQuestion(
        question: 'A "Bear Market" occurs when...',
        options: [
          'Stock prices have fallen by 20% or more over a period of time',
          'Stock prices are rising very quickly',
          'Animals become mascots for stock exchanges',
          'Companies give away free money to investors',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The term bear market does not refer to rapidly rising prices or animals becoming mascots for exchanges. It certainly does not mean that companies are giving away free money to their investors during a downturn.',
        correctExplanation:
            'A bear market is defined by a prolonged period of falling stock prices, typically marked by a decline of twenty percent or more. This phase is a normal part of the long-term economic cycle.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q6',
    title: 'Bonds and Fixed Income',
    subtitle: 'Lending your money for profit',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is a "Bond" in the financial world?',
        options: [
          'An I.O.U. where you lend money to a government or corporation for interest',
          'An employment agreement with a company',
          'A type of insurance contract',
          'A permanent ownership partnership',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A bond is not an employment contract, an ownership partnership, or a type of insurance. It represents a debtor-creditor relationship where the issuer has a legal obligation to repay the principal at maturity.',
        correctExplanation:
            'A bond is essentially a formal loan agreement where you act as the lender to a government or corporation. In exchange for your capital, the borrower promises to pay you regular interest payments.',
      ),
      QuizQuestion(
        question: 'What is the "Coupon Rate" of a bond?',
        options: [
          'The fixed interest rate the bond issuer pays to the lender',
          'A discount program for consumers',
          'The market value of the bond',
          'The year the bond expires',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Coupon rate does not refer to a consumer discount program, the current market price of the bond, or its expiration year. It is strictly the fixed percentage of the bond\'s face value paid regularly.',
        correctExplanation:
            'The coupon rate is the specific annual interest rate that the bond issuer agrees to pay the bondholder. It determines the steady stream of income you will receive throughout the life of the bond.',
      ),
      QuizQuestion(
        question: 'What is "Maturity Date"?',
        options: [
          'The date the borrower must repay the original loan amount',
          'The legal age to invest in markets',
          'The founding date of the issuing company',
          'The ideal time to sell stocks',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Maturity is not related to the age of the investor, the founding date of the company, or the ideal time to sell stocks. it marks the official end of the bond holder\'s contract.',
        correctExplanation:
            'The maturity date is the specific point in time when the bond\'s term ends and the issuer is legally required to return your initial principal investment in full to you as the lender.',
      ),
      QuizQuestion(
        question: 'Which bond is typically considered the SAFEST?',
        options: [
          'U.S. Treasury Bond',
          'Corporate bonds issued by new startups',
          'International bonds from unstable economies',
          'Bonds issued by private entertainment venues',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Corporate bonds from startups, international bonds from unstable regions, and private venue bonds all carry significantly higher risks of default. Treasury bonds offer a guaranteed safety net that these other options simply cannot provide.',
        correctExplanation:
            'U.S. Treasury bonds are widely considered the safest investments because they are backed by the full faith and credit of the government. This low risk usually comes with lower relative returns for investors.',
      ),
      QuizQuestion(
        question: 'What is a "Municipal Bond"?',
        options: [
          'A bond issued by a city or state to fund public projects',
          'A bond used for personal vehicle purchases',
          'A bond reserved for private individuals only',
          'A bond that never pays interest at any time',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Municipal bonds are never used for personal vehicle purchases or reserved exclusively for private individuals. They are also not non-interest bearing; they provide a steady income stream while supporting vital community development initiatives.',
        correctExplanation:
            'Municipal bonds are debt securities issued by local or state governments to fund important public infrastructure projects. They are attractive to many investors because the interest earned is often exempt from federal taxes.',
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
          'A type of mutual fund or ETF designed to track the performance of a specific market index',
          'A list of the most expensive public companies',
          'A fund that invests in office supplies',
          'A savings product issued by the government',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Index funds are not government savings products or funds that specifically invest in office supplies. They are also not merely a list of expensive companies but are active investment tools for building wealth.',
        correctExplanation:
            'An index fund is a type of investment vehicle designed to mimic the performance of a specific market benchmark. This passive approach typically results in lower fees and more consistent long-term returns for investors.',
      ),
      QuizQuestion(
        question: 'What does "ETF" stand for?',
        options: [
          'Exchange-Traded Fund',
          'Electronic Total Fund structure',
          'Easy Tax Filing system',
          'Every Trading Friday program',
        ],
        correctIndex: 0,
        wrongExplanation:
            'ETF does not stand for electronic total funds, easy tax filing, or every trading Friday. It is a specific financial structure that combines the diversification of mutual funds with the trading flexibility of stocks.',
        correctExplanation:
            'ETF stands for Exchange-Traded Fund, which is a versatile investment security that tracks an index or basket of assets. Unlike mutual funds, ETFs can be bought and sold on exchanges throughout the trading day.',
      ),
      QuizQuestion(
        question: 'What is an "Expense Ratio"?',
        options: [
          'The percentage of your investment taken each year for management fees',
          'The total money you spend on daily expenses',
          'A calculation comparing income and debt',
          'The cost of buying a single share',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Expense ratio is not your personal debt-to-income calculation or the cost of purchasing a single share. It is also not related to your daily personal spending habits but is strictly an investment management fee.',
        correctExplanation:
            'The expense ratio is the annual fee charged by an investment fund to cover its management and operating costs. It is expressed as a percentage of your total assets held within the specific fund.',
      ),
      QuizQuestion(
        question: 'What is "Dollar-Cost Averaging" (DCA)?',
        options: [
          'Investing a fixed amount of money at regular intervals regardless of price',
          'Trying to buy only at market lows',
          'Exchanging one currency for another',
          'Estimating housing prices',
        ],
        correctIndex: 0,
        wrongExplanation:
            'DCA is not about trying to time market lows or simply exchanging different types of currencies. It is a long-term strategy designed to take the emotion out of investing and build a larger position.',
        correctExplanation:
            'Dollar-cost averaging is a disciplined investment strategy where you consistently invest a fixed amount of [GEM] at regular intervals. This approach helps reduce the impact of market volatility by averaging your overall purchase price.',
      ),
      QuizQuestion(
        question:
            'The primary advantage of Index Funds over Active Funds is...',
        options: [
          'They have much lower fees and often better long-term performance',
          'They always guarantee higher returns',
          'They are restricted to wealthy investors',
          'They are backed by the government',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Index funds are not backed by the government and cannot guarantee higher returns in any specific year. They are also widely available to all types of investors rather than being restricted to the wealthy.',
        correctExplanation:
            'Index funds typically outperform active funds over the long run because they have significantly lower management fees and operating costs. This cost efficiency allows more of your money to compound and grow over time.',
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
          'A three-digit number representing your creditworthiness',
          'A secret internal bank rating',
          'A school exam result',
          'The total money you have saved',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A FICO score is not a secret internal bank rating or the total amount of money in your savings account. It is also not related to your performance on school exams or certificates.',
        correctExplanation:
            'A FICO score is a standardized three-digit number that summarizes your entire credit history. Lenders use this score to quickly assess how likely you are to repay borrowed money on time and in full.',
      ),
      QuizQuestion(
        question: 'Which factor has the LARGEST impact on your credit score?',
        options: [
          'Payment history, including on-time bill payments',
          'Your annual income level',
          'The number of credit cards owned',
          'The brand of vehicle you drive',
        ],
        correctIndex: 0,
        wrongExplanation:
            'While your annual income is important for qualifying for loans, it does not directly affect your actual credit score. The brand of vehicle you drive or the number of cards you own also carry less weight.',
        correctExplanation:
            'Your payment history is the single most important factor in determining your credit score. Consistently paying all of your bills exactly on time proves to potential lenders that you are a reliable and responsible borrower.',
      ),
      QuizQuestion(
        question: 'What is "Credit Utilization"?',
        options: [
          'The percentage of your total available credit currently in use',
          'How often you use your credit card',
          'The number of active loans you have',
          'Paying for purchases with cash',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Credit utilization is not simply how often you use your card or the specific number of active loans you possess. It is also not related to paying for your daily purchases with cash or checks.',
        correctExplanation:
            'Credit utilization is a ratio that compares the amount of credit you are currently using to your total available credit limits. Financial experts generally recommend keeping this percentage below thirty percent to maintain a healthy score.',
      ),
      QuizQuestion(
        question: 'Why does "Length of Credit History" matter?',
        options: [
          'It shows long-term experience managing credit responsibly',
          'It has no real effect',
          'It determines retirement eligibility',
          'It affects card appearance',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Credit history length does not determine your eligibility for retirement or have any effect on the physical appearance of your cards. It is a critical component of your overall financial reputation and credit stability.',
        correctExplanation:
            'The length of your credit history provides lenders with a clear track record of how you have managed debt over many years. A longer history typically makes you appear safer and more predictable as a borrower.',
      ),
      QuizQuestion(
        question: 'Hard inquiries can...',
        options: [
          'Slightly lower your score for a short period',
          'Instantly increase your score',
          'Erase your credit history',
          'Trigger automatic tax refunds',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Multiple hard inquiries will never instantly increase your credit score or trigger automatic tax refunds from the government. They certainly cannot erase your history but can instead make you appear desperate for credit to lenders.',
        correctExplanation:
            'A hard inquiry occurs when a lender checks your credit for a lending decision, which can slightly lower your score temporarily. Applying for too many new accounts in a short time signals potential financial risk.',
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
          'A long-term loan specifically used for buying real estate',
          'A monthly fee for renting',
          'A type of home insurance',
          'The total cost of a house',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A mortgage is not a simple monthly rental fee or a type of homeowners insurance policy. While it contributes to the total cost, it refers specifically to the borrowed funds used for acquisition.',
        correctExplanation:
            'A mortgage is a specialized type of long-term loan used by individuals to purchase a home or other real estate. The property itself serves as collateral to secure the loan from the lender.',
      ),
      QuizQuestion(
        question: 'What is the "Down Payment" on a house?',
        options: [
          'The upfront [GEM] you pay out of pocket before the mortgage starts',
          'The final payment of the loan',
          'A fee for moving in',
          'The monthly interest rate',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The down payment is not the final loan payment or a simple fee for moving into a house. It is also not related to your ongoing monthly interest rate but is an upfront cost.',
        correctExplanation:
            'The down payment is the initial amount of [GEM] you pay upfront toward the purchase price of a home. A larger down payment reduces the total amount you need to borrow from the bank.',
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
            'A fixed-rate mortgage does not mean the actual price of the house is fixed or that the loan must be paid in five years. It also does not feature interest rates that change monthly.',
        correctExplanation:
            'A fixed-rate mortgage is a home loan where the interest rate remains constant for the entire duration of the loan. This provides borrowers with stable and predictable monthly payments regardless of market fluctuations.',
      ),
      QuizQuestion(
        question: 'What is "Escrow" in home ownership?',
        options: [
          'An account where [GEM] are held to pay for property taxes and home insurance',
          'The name of the front door key',
          'A legal way to avoid paying rent',
          'The total square footage of the backyard',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Escrow is not a legal way to avoid paying your rent or the name of a physical key for your front door. It also has absolutely nothing to do with measuring your house square footage.',
        correctExplanation:
            'Escrow is a neutral third-party account used to hold [GEM] for your annual property tax and homeowners insurance bills. This ensures that these vital payments are always made on time to protect your property.',
      ),
      QuizQuestion(
        question: 'What is "Equity"?',
        options: [
          'Ownership in an asset or company, calculated as value remaining after all debts and liabilities are subtracted from total assets',
          'The total [GEM] you still owe the bank',
          'The number of rooms in your house',
          'A monthly maintenance fee',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Equity is not the total amount of money you still owe the bank or the number of rooms in your house. It is also not a regular monthly maintenance fee charged to homeowners.',
        correctExplanation:
            'Equity represents the true portion of your home that you truly own. It is calculated by subtracting your current outstanding mortgage balance from the actual market value of your property at any given time.',
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
          'The steady increase in market value over long periods',
          'Value loss as the vehicle gets older',
          'The total cost of fuel and maintenance for driving',
          'The annual interest rate applied to a standard loan',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Most cars are not investments that grow in value. They lose significant resale price the moment you drive them off the lot. A [GEM]30,000 new car might only be worth [GEM]15,000 in five years.',
        correctExplanation:
            'Understanding depreciation is essential for building wealth. This is why many smart savers choose to buy slightly used cars rather than brand-new ones, allowing someone else to pay for that initial massive drop in value.',
      ),
      QuizQuestion(
        question: 'What is a "Lease" for a car?',
        options: [
          'A loan where you eventually own the entire car',
          'Renting for lower cost without gaining any ownership',
          'An insurance policy specifically covering your tires and wheels',
          'A special financial gift from the local car dealership',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Leasing is very similar to renting a house. You get a new car for a lower monthly cost, but after three years, you have to give it back and you have zero ownership equity.',
        correctExplanation:
            'Leasing can be good for people who want a new car every few years, but it is generally more expensive than owning in the long run because you never stop making your monthly payments.',
      ),
      QuizQuestion(
        question: 'What is "Collision Coverage"?',
        options: [
          'Fixing your own car after an accident you caused',
          'Insurance that only pays for other people\'s damaged cars',
          'An insurance plan that covers only the theft of vehicles',
          'A special technology that makes car accidents completely impossible',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Liability insurance pays for the other person involved in the accident. Collision is what specifically pays to fix your own vehicle. Without it, you would have to pay for all your own repairs out of pocket.',
        correctExplanation:
            'If your car is old and worth very little, you might choose to cancel collision coverage to save [GEM] every month. This strategy works because the insurance payout might be less than the cost of premiums.',
      ),
      QuizQuestion(
        question: 'What is a "Balloon Payment"?',
        options: [
          'A fun party favor given at the local bank',
          'Final large payment due at the loan termination',
          'A mandatory fee for inflating your vehicle tires regularly',
          'A special financial reward gifted from the national government',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Balloon payments are extremely risky! They make your monthly bills look low, but then you suddenly owe [GEM]10,000 all at once at the very end. many people find themselves unable to pay this massive final amount.',
        correctExplanation:
            'Many people are forced into deep debt because they were not prepared for a massive balloon payment. Understanding the total repayment schedule is vital before signing any long-term car or home loan contracts at the bank.',
      ),
      QuizQuestion(
        question:
            'Why is a 60-month car loan often worse than a 36-month loan?',
        options: [
          'The monthly payments are much higher for the owner',
          'Total interest paid is significantly more over time',
          'The car becomes completely illegal after three years driving',
          'The 36-month loan is more expensive in total [GEM] costs',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Longer loans have lower monthly bills, which often tricks people into buying more than they can afford. Because you are borrowing for longer, the bank earns way more [GEM] from you in total interest payments.',
        correctExplanation:
            'Always calculate the total cost by multiplying the monthly payment by the number of months when choosing a loan. A shorter loan might have higher monthly bills, but it will save you thousands of [GEM] eventually.',
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
          'A special high-quality insurance plan for elite members',
          'Regular payments made to keep insurance active',
          'The total amount you pay when a crash occurs',
          'A financial reward for not getting sick or injured',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The deductible is the amount paid when a problem happens, whereas the premium is the subscription fee you pay even when everything is perfect. Failing to pay your premium leads to an immediate loss of coverage.',
        correctExplanation:
            'Premium payments are the foundation of your insurance contract. If you stop paying your premium, your coverage disappears instantly, leaving you exposed to massive financial risks from medical emergencies or unexpected legal liabilities and accidents.',
      ),
      QuizQuestion(
        question: 'What is a "Co-pay"?',
        options: [
          'A financial payment made by your closest friend',
          'Fixed amount paid for a specific medical service',
          'The total cost of a major surgery or operation',
          'The exact amount the insurance company owes to you',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It is a flat fee rather than a percentage. For example, your insurance might cover the whole [GEM]200 checkup, but you are specifically required to pay a small [GEM]20 co-pay at the clinic front desk.',
        correctExplanation:
            'Co-pays are designed to make you share a small portion of the cost so that people do not go to the doctor for every tiny scratch. This helps keep the overall insurance premiums lower for everyone.',
      ),
      QuizQuestion(
        question: 'What is "Term Life Insurance"?',
        options: [
          'Insurance that lasts for your entire natural life',
          'Payout for family if death occurs within term',
          'An insurance policy designed specifically for your expensive furniture',
          'Insurance that only works during your active school term',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Term insurance is simple, affordable, and effective. It acts as a financial safety net for your children or spouse while they depend on your income to live. It does not last forever like whole life.',
        correctExplanation:
            'Once the term (such as twenty years) is over, the insurance coverage ends. It is usually the best and most cost-effective choice for most young families who need high coverage for a low monthly premium.',
      ),
      QuizQuestion(
        question: 'What is an "Umbrella Policy"?',
        options: [
          'Insurance specifically designed for extreme rain and flood damage',
          'Extra liability protection beyond your basic home policies',
          'A policy that covers your entire summer vacation travel',
          'Special insurance for your legal business partner or employee',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Think of a real umbrella—it covers everything underneath it. If you are sued for [GEM]1 Million but your car insurance only covers [GEM]300k, the umbrella policy kicks in to pay the remaining balance of the debt.',
        correctExplanation:
            'Umbrella policies are very cheap ways to protect your total net worth from rare but massive disasters. They provide peace of mind by ensuring that one single unlucky event does not bankrupt your entire family legacy.',
      ),
      QuizQuestion(
        question: 'What is a "Pre-existing Condition"?',
        options: [
          'Health problem you had before new insurance started',
          'A condition of your car before you finally bought it',
          'A requirement to pay your monthly bills exactly on time',
          'A specific type of emergency fund for unexpected medical costs',
        ],
        correctIndex: 0,
        wrongExplanation:
            'In the past, insurance companies could refuse to help you if you were already sick. New laws in many places now require them to cover everyone regardless of their previous medical history or health conditions.',
        correctExplanation:
            'Knowing how these conditions are handled is vital when you are choosing between different health plans. It ensures that you receive necessary care without being unfairly excluded due to past medical challenges or chronic illnesses.',
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
          'A type of standard high-yield bank savings account',
          'Employer retirement plan often including matching [GEM] funds',
          'The total amount of [GEM] you need to retire comfortably',
          'A complicated government tax form required for all annual filings',
        ],
        correctIndex: 1,
        wrongExplanation:
            'It is a specialized investment account, not just a simple savings account. The [GEM] are taken from your paycheck before taxes are applied, which provides a significant and immediate financial benefit to you.',
        correctExplanation:
            'Many companies offer a match. If you put in one [GEM], they give you another [GEM] for free! This is effectively a one hundred percent return on your investment that happens instantly without any risk.',
      ),
      QuizQuestion(
        question: 'What does "Vesting" mean?',
        options: [
          'Right to keep employer contributions to retirement accounts',
          'Buying a brand new suit for a professional work environment',
          'Investing regularly in the broad and diversified stock market',
          'Paying your monthly insurance premium to maintain active coverage always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Employers want you to stay for the long term! They might say you are fully vested after three years. If you leave earlier, they legally take back their matching [GEM] contributions from your account.',
        correctExplanation:
            'Knowing your specific vesting schedule is very important before you decide to quit a job. It ensures you do not accidentally leave thousands of [GEM] on the table by resigning just a few months too early.',
      ),
      QuizQuestion(
        question: 'What is a "Traditional IRA"?',
        options: [
          'A standard savings account with absolutely no taxes applied',
          'IRA with tax break now but taxed at withdrawal',
          'A retirement account designed exclusively for large corporate groups',
          'A way to avoid the stock market while saving [GEM]',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Traditional means tax-deferred. You save approximately thirty [GEM] in taxes today for every one hundred [GEM] you save for the future. This allows you to invest more of your current income for long-term growth.',
        correctExplanation:
            'Individual Retirement Accounts are great because you maintain full control over the account, even if you change jobs twenty different times. They provide flexibility and portability that many employer-sponsored plans simply cannot match over time.',
      ),
      QuizQuestion(
        question: 'What is the special benefit of a "Roth IRA"?',
        options: [
          'You get a significant tax break right now today',
          'Wealth grows and is withdrawn 100% TAX-FREE later',
          'The government gives you free [GEM] for every deposit',
          'It has absolutely no special benefits for the average investor',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Roth means tax-free later. You pay the tax today, but you never pay a single [GEM] to the government on the growth ever again. This makes it an incredibly powerful tool for long-term wealth building.',
        correctExplanation:
            'If your initial five thousand [GEM] investment grows into fifty thousand [GEM] inside a Roth IRA, you keep all fifty thousand [GEM] for your retirement. The government does not get to take any portion of that growth.',
      ),
      QuizQuestion(
        question:
            'At what age can you usually withdraw retirement funds without a "10% Penalty"?',
        options: [
          'When you reach the age of eighteen years old',
          'After reaching exactly fifty-nine and a half years',
          'When you finally reach age one hundred years old',
          'Anytime you want without any restrictions or extra fees',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Retirement accounts have strict rules designed to discourage early spending! If you take the [GEM] out at age thirty to buy a fancy car, the government takes a huge ten percent penalty plus regular taxes.',
        correctExplanation:
            'These rules exist to force you to leave your wealth alone so it has time to compound for forty or more years. This long-term focus is the secret to achieving true financial independence in retirement.',
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
          'The total amount of [GEM] stored in national bank accounts',
          'Total value of goods and services produced annually',
          'The average price of food found at the local grocery',
          'Percentage of the population that currently holds a full-time job',
        ],
        correctIndex: 1,
        wrongExplanation:
            'GDP is often described as the national paycheck of a country. If GDP is growing steadily, the economy is healthy and people are providing significantly more value to each other through their work and products.',
        correctExplanation:
            'Monitoring GDP growth is essential for understanding the overall health of an economy. When GDP shrinks for several months in a row, it usually signals that a painful recession or economic downturn is officially starting.',
      ),
      QuizQuestion(
        question: 'What does the "CPI" (Consumer Price Index) measure?',
        options: [
          'The total number of consumers living in the entire country',
          'Average price change for regular consumer basket goods',
          'The total annual profit levels of all large international corporations',
          'The current interest rate offered by the central bank system',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The CPI strictly tracks the prices of essential items like eggs, milk, gas, and rent. It tells us how much the overall cost of living has changed for the average family over a period.',
        correctExplanation:
            'If the CPI is up six percent from last year, your one hundred [GEM] only has the purchasing power that ninety-four [GEM] had before. This means your savings are losing value due to inflation effects.',
      ),
      QuizQuestion(
        question: 'What is the "Federal Reserve"?',
        options: [
          'The high security place where all [GEM] are stored today',
          'Central bank controlling money supply and interest rates',
          'A government department that focuses exclusively on collecting annual taxes',
          'A specific type of high security military base found nearby',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The Federal Reserve acts as the bank for all other banks. They raise interest rates to slow down inflation or lower them to help the overall economy grow during periods of low activity or recession.',
        correctExplanation:
            'Decisions made by the Federal Reserve have a massive impact on your car loan, mortgage, and savings account interest rates. Understanding their actions helps you plan your borrowing and saving strategies more effectively for wealth.',
      ),
      QuizQuestion(
        question: 'What is "Unemployment Rate"?',
        options: [
          'The total percentage of everyone who does not have jobs',
          'Percentage of adults seeking work but without jobs',
          'The total number of people currently living in the country',
          'A special type of tax paid only by individual workers',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The unemployment rate does not count children, students, or retired people. It only tracks adults who are actively looking for a job but have not yet been able to find suitable employment in the market.',
        correctExplanation:
            'A low unemployment rate means the economy is strong and companies are competing for workers. This usually leads to higher wages and more opportunities for career growth as businesses struggle to fill their open positions.',
      ),
      QuizQuestion(
        question: 'What is a "Trade Deficit"?',
        options: [
          'Buying more from other countries than selling away',
          'When a country has absolutely zero [GEM] left today',
          'A specific law that stops all international trading completely now',
          'A specific type of bank robbery occurring at high levels',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Imports represent buying from neighbors while exports represent selling to them. A deficit simply means that more [GEM] are leaving the country than coming in, which can impact the long-term national balance of payments.',
        correctExplanation:
            'Trade deficits are not always bad, but they can significantly impact the value of a countrys currency and its manufacturing jobs. Policymakers often watch these numbers to ensure that the domestic industry remains competitive internationally.',
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
          'Software system used to recover lost digital files easily',
          'Malicious software locking files until payment is made',
          'Cyberattack method that permanently deletes all data across entire networks',
          'Legal service that helps companies recover stolen intellectual property today',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Ransomware is not a recovery tool or legal service. It is designed to block access and pressure victims into paying attackers. It is one of the most dangerous threats to individual and corporate digital security.',
        correctExplanation:
            'Ransomware encrypts or locks data and demands payment for access. Strong backups and security habits reduce damage and recovery costs, ensuring that you do not have to pay criminals to get your important files back.',
      ),
      QuizQuestion(
        question: 'What should you do if you suspect "Identity Theft"?',
        options: [
          'Monitor accounts casually and wait for suspicious activity stops',
          'Contact bank and place credit freeze on accounts',
          'Only change social media passwords without reporting the incident today',
          'Ignore small charges because they usually disappear on their own now',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Delaying action allows criminals to open new accounts and cause more financial harm that becomes harder to reverse later. You must act immediately to minimize the damage and begin the formal recovery process with authorities.',
        correctExplanation:
            'A credit freeze blocks new accounts from being opened, limiting damage while you investigate and recover control of your identity. It is a critical step in protecting your financial reputation after a compromise has occurred.',
      ),
      QuizQuestion(
        question: 'What is "Two-Factor Authentication" (2FA)?',
        options: [
          'Using one strong password for multiple important accounts today',
          'Using two security steps like password and code',
          'Having duplicate accounts in case one becomes completely inaccessible now',
          'Relying on security questions instead of passwords for protection always',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Using a single password or backup accounts does not provide the additional verification required to stop unauthorized access. 2FA ensures that even if a hacker knows your password, they still cannot access your private accounts.',
        correctExplanation:
            'Two-factor authentication adds a second verification step, making accounts far harder to access even if passwords are stolen. This simple layer of defense is one of the most effective ways to secure your digital and financial life.',
      ),
      QuizQuestion(
        question:
            'How often are you legally entitled to a free credit report from each bureau?',
        options: [
          'Only once every several years under special circumstances today',
          'Report once every twelve months for free',
          'Only when applying for major loans or credit cards now',
          'Never unless you pay for a monitoring subscription service always',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Federal law guarantees regular access to credit reports, so paying or waiting years is unnecessary and risky. You have a legal right to review your data to ensure its accuracy and identify any fraudulent activity.',
        correctExplanation:
            'Checking your report yearly helps detect fraud, errors, or unauthorized accounts before serious financial damage occurs. It is a vital part of maintaining your financial health and ensuring that your credit score remains as high as possible.',
      ),
      QuizQuestion(
        question: 'Why is it dangerous to use public Wi-Fi for your bank app?',
        options: [
          'Public Wi-Fi networks usually have slower internet speeds today',
          'Hackers intercept data sent between device and bank',
          'Using public Wi-Fi drains battery life more quickly than mobile',
          'Public networks charge hidden access fees for use of data',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Speed and battery life are minor concerns compared to the risk of data theft. The real danger is weak security that exposes sensitive financial data to anyone who happens to be monitoring the network traffic.',
        correctExplanation:
            'Unsecured networks allow attackers to monitor traffic, potentially stealing login details or transaction information. Always use a secure connection or a virtual private network when accessing any sensitive financial information while you are away from home.',
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
          'A personal statement of preferences without any legal authority',
          'Legal document explaining asset distribution after death',
          'A financial plan specifically designed for your retirement savings',
          'A legal contract used to transfer property during a sale',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Without a will, courts decide asset distribution based on law rather than personal wishes. This can lead to family disputes and assets going to people who you may not have intended to receive them.',
        correctExplanation:
            'A will provides legally binding instructions that protect family members and ensure assets go to intended recipients. It is a foundational part of any estate plan that provides clarity and peace of mind for your loved ones.',
      ),
      QuizQuestion(
        question: 'What is an "Executor"?',
        options: [
          'Person who carries out instructions in a will',
          'A legal professional who automatically inherits all your assets',
          'A financial advisor who manages your investments long-term today',
          'A court-appointed official who replaces your family members now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Executors manage the distribution process but do not personally own the assets unless they are named separately as beneficiaries. It is a position of high responsibility that requires careful attention to legal and financial details.',
        correctExplanation:
            'An executor ensures debts are paid, documents are filed, and assets are distributed correctly and legally. They act as the primary representative of the estate throughout the entire probate and distribution process after a person dies.',
      ),
      QuizQuestion(
        question: 'What is a "Trust"?',
        options: [
          'A personal belief in someone’s reliability and daily honesty today',
          'Legal arrangement where assets are held for beneficiaries',
          'A short-term loan agreement for buying property or vehicles',
          'An informal promise without any legal force or official documentation',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Trusts are formal legal structures rather than emotional relationships or informal agreements. They are used to manage assets for the benefit of others and can provide significant legal and tax advantages over traditional wills.',
        correctExplanation:
            'Trusts allow controlled distribution of assets and can reduce taxes or avoid lengthy court processes. They are often used to protect minor children or to manage how wealth is passed down through multiple generations.',
      ),
      QuizQuestion(
        question: 'What is a "Power of Attorney"?',
        options: [
          'Permission to practice law professionally in a court environment',
          'Document allowing someone to make decisions for you',
          'A specific financial account with special authority over investments',
          'A requirement for medical treatment approval from the local government',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Power of attorney grants decision authority rather than professional credentials or financial ownership. It is an essential document that ensures your affairs are handled if you suddenly become unable to make decisions for yourself.',
        correctExplanation:
            'It ensures trusted individuals can manage finances or medical decisions if you become unable to act. This protection is vital for ensuring that your wishes are respected and your assets are protected during health crises.',
      ),
      QuizQuestion(
        question:
            'The people who receive assets from a will or insurance are called...',
        options: [
          'Executors who manage all estate paperwork and legal filings',
          'Beneficiaries receiving the assets',
          'Trustees overseeing complicated legal arrangements and financial distributions today',
          'Policyholders responsible for paying all premiums to keep insurance',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Executors and trustees manage assets, but beneficiaries are the ones who actually receive them. Understanding this distinction is vital for ensuring that your estate plan correctly identifies the specific people you want to help.',
        correctExplanation:
            'Keeping beneficiary designations updated ensures assets transfer smoothly without legal disputes. This is particularly important after major life events such as marriage, divorce, or the birth of children to ensure your legacy remains secure.',
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
          'A budgeting strategy for families with low annual income',
          'Tax-advantaged savings account for education expenses',
          'A specific private student loan program with very high interest',
          'A government-run scholarship system for high achieving students today',
        ],
        correctIndex: 1,
        wrongExplanation:
            '529 plans are savings and investment accounts rather than loans or automatic scholarship programs. They are designed specifically to help families save for future education costs while receiving significant tax benefits from the government.',
        correctExplanation:
            'Money grows tax-free when used for qualified education costs, reducing long-term college expenses significantly. This makes them one of the most effective tools for funding higher education while minimizing the need for expensive student loans.',
      ),
      QuizQuestion(
        question: 'What is the "FAFSA"?',
        options: [
          'An academic performance exam required for college entry today',
          'The Free Application for Federal Student Aid',
          'A private lender offering student loans with very low rates',
          'A law guaranteeing free college tuition for every citizen always',
        ],
        correctIndex: 1,
        wrongExplanation:
            'FAFSA does not provide money directly; it determines eligibility for financial aid programs. It is a necessary step for anyone looking for assistance through grants, work-study programs, or federal student loans in the country.',
        correctExplanation:
            'Completing FAFSA opens access to grants, work-study, and low-interest federal loans. It is the single most important document for students to submit if they hope to receive any form of federal financial assistance.',
      ),
      QuizQuestion(
        question: 'What is a "Student Loan Subsidized" by the government?',
        options: [
          'A loan that never requires repayment from any student',
          'Government pays interest while you are in school',
          'A loan reserved only for high-income families with significant wealth',
          'A loan that must be repaid within one year after graduating',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Subsidized loans still require repayment but prevent interest growth while you are enrolled in school. This is a massive benefit that can save students thousands of [GEM] in interest costs over their education years.',
        correctExplanation:
            'They reduce total debt by stopping interest accumulation while students focus on education. This ensures that the balance you borrow does not grow out of control before you even have a chance to graduate.',
      ),
      QuizQuestion(
        question: 'What is a "Grant"?',
        options: [
          'Money for college that does not need repayment',
          'A specific loan with delayed repayment terms and high rates',
          'A legal contract with a university for future employment always',
          'A tuition discount that must be earned back through work',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Grants differ fundamentally from loans because they do not create any future debt obligations for the recipient. They are effectively gifts of money intended to help students cover the high costs of their higher education.',
        correctExplanation:
            'They lower education costs directly and reduce the need for borrowing significantly. This allows students to graduate with less debt, giving them a much stronger financial start as they begin their professional careers in life.',
      ),
      QuizQuestion(
        question:
            'Why is "Average Starting Salary" important when choosing a degree?',
        options: [
          'It has no effect on long-term finances for a student',
          'Helps evaluate if education costs are financially reasonable',
          'It determines job satisfaction levels of your future professional career',
          'It predicts future promotion speed in your chosen field of work',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Ignoring potential salary can lead to massive debt that is extremely difficult to repay after graduation. It is essential to understand the financial reality of your career path before committing to expensive degree programs.',
        correctExplanation:
            'Comparing expected salary to total tuition helps assess the return on investment for education decisions. This logical approach ensures that you are making a wise financial choice rather than just following a temporary passion.',
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
          'Entertainment and discretionary spending for your own personal daily fun',
          'Needs such as rent, groceries, and utilities',
          'Savings and investments specifically meant for your long term retirement',
          'Tax obligations that you must pay to the local government annually',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Needs are essential expenses required to maintain basic living standards and survival. They should be prioritized above all other spending to ensure that you always have a safe place to live and enough food.',
        correctExplanation:
            'Limiting needs to half your total income creates a healthy balance between stability, enjoyment, and future planning. It prevents you from becoming "house poor" or overwhelmed by fixed costs that you cannot easily reduce.',
      ),
      QuizQuestion(
        question: 'In the "50/30/20 Rule," what does the 30% represent?',
        options: [
          'Emergency savings specifically for unexpected medical or financial crises today',
          'Wants like hobbies, dining out, and subscriptions',
          'Insurance payments for your car and home and health coverage',
          'Charitable contributions to local groups or organizations in your own community',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Wants represent optional expenses rather than essential obligations or long-term savings goals. While they are important for quality of life, they should never be funded at the expense of your basic needs or your savings.',
        correctExplanation:
            'Allowing controlled enjoyment through a dedicated portion of your budget prevents burnout while maintaining financial discipline. It gives you the freedom to spend without guilt, knowing that your other responsibilities are already fully covered.',
      ),
      QuizQuestion(
        question: 'In the "50/30/20 Rule," what is the most important 20%?',
        options: [
          'Clothing purchases and regular fashion updates for your professional work',
          'Savings, investing, and extra debt payments',
          'Travel expenses for vacations and trips around the world today',
          'Vehicle upkeep and regular maintenance for your car and driving needs',
        ],
        correctIndex: 1,
        wrongExplanation:
            'This specific portion of your income builds your long-term financial security rather than providing short-term comfort or status. It is the engine that drives your future wealth and eventually leads to your financial independence.',
        correctExplanation:
            'Consistent investment of this twenty percent portion creates long-term wealth and stability for your family. By making this a non-negotiable part of your monthly budget, you ensure that your future self is well protected.',
      ),
      QuizQuestion(
        question: 'What is "Lifestyle Creep"?',
        options: [
          'Suspicious behavior within the neighborhood where you currently live today',
          'Increasing spending as your income rises',
          'Relocating for higher paying work in a much different and expensive city',
          'Purchasing unnecessary items impulsively without any planning or thinking now',
        ],
        correctIndex: 1,
        wrongExplanation:
            'A higher income does not automatically require matching increases in your daily spending or luxury levels. Lifestyle creep happens when you upgrade your life every time you get a raise, leaving you with zero net gain.',
        correctExplanation:
            'Controlling lifestyle creep allows your total savings to grow exponentially as your income increases over time. By maintaining your previous standard of living while earning more, you accelerate your journey toward financial freedom significantly.',
      ),
      QuizQuestion(
        question: 'A "Zero-Based Budget" means...',
        options: [
          'Ending the month with absolutely no money saved in your accounts',
          'Every unit of income assigned specific purpose',
          'Spending nothing at all for an entire month to save every [GEM]',
          'Avoiding budgeting entirely because you do not have enough money today',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Zero-based budgeting is about intentional planning and allocation rather than eliminating all spending from your life. It ensures that every single [GEM] you earn has a specific job to do before the month even begins.',
        correctExplanation:
            'Assigning every unit of income to a category prevents waste and significantly improves your overall financial control. It forces you to be honest about your spending habits and helps you reach your financial goals faster.',
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
          'The net profit remaining after all company expenses are paid',
          'Total money earned from sales before any subtractions',
          'The exact amount of [GEM] paid in annual corporate taxes',
          'Percentage of employees who work for the organization today always',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Revenue measures the total income before any expenses are subtracted, which identifies how much money is coming into the business. It is often called the top line because it appears at the peak of the statement.',
        correctExplanation:
            'High revenue does not guarantee success unless expenses are carefully controlled and monitored. A company can earn millions of [GEM] in revenue but still lose money if its operating costs are even higher than its sales.',
      ),
      QuizQuestion(
        question: 'What is "Net Profit"?',
        options: [
          'Money remaining after all expenses and taxes paid',
          'The total amount spent on advertising and company promotions today',
          'The total value of all business equipment and physical property',
          'Total management salaries paid to all employees and contractors annually',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Net profit reflects your actual earnings rather than gross income or operating expenses. It is often referred to as the bottom line because it represents what is ultimately left for the owners after everything else.',
        correctExplanation:
            'Net profit determines whether a business is sustainable over the long term. It provides the necessary capital for reinvestment, expansion, and rewarding shareholders for the risks they have taken by investing in the company.',
      ),
      QuizQuestion(
        question: 'What does "LLC" stand for?',
        options: [
          'Large Local Company operating within a specific narrow geographic region',
          'Limited Liability Company for private asset protection',
          'Long-Term Capital Corporation focused on major infrastructure and development projects',
          'Low-Level Corporate Structure intended for small family run seasonal businesses',
        ],
        correctIndex: 1,
        wrongExplanation:
            'LLCs are designed to limit personal financial risk from various business liabilities and debts. This means that creditors generally cannot come after your personal home or savings to pay for the companys mistakes or failures.',
        correctExplanation:
            'LLCs separate personal assets from business obligations effectively. This legal shield is one of the primary reasons why entrepreneurs choose this specific structure when starting new ventures that involve significant financial risks or potential lawsuits.',
      ),
      QuizQuestion(
        question: 'What is a "Business Plan"?',
        options: [
          'A simple map showing the internal office and desk layout',
          'Document outlining goals, strategy, and daily operations',
          'A specific workplace dress requirement for all employees and visitors',
          'A special insurance policy covering unexpected loss of business income',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Business plans are comprehensive roadmaps that guide overall operations rather than just simple daily workplace rules. They force entrepreneurs to think through their competition, marketing strategies, and financial projections before starting their new empire.',
        correctExplanation:
            'A well-written business plan is essential for attracting investors and guiding strategic decisions as the company grows. It serves as a benchmark for measuring success and a tool for communicating the vision to others.',
      ),
      QuizQuestion(
        question: 'What is "Equity Financing"?',
        options: [
          'Borrowing money that must be repaid with regular interest payments',
          'Selling ownership in exchange for growth funding',
          'Buying expensive company equipment using saved cash from previous sales',
          'Receiving a small government grant intended for local community improvement',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Equity financing does not require repayment like high-interest loans. Instead of becoming a debtor, you take on partners who share in the profits and have a say in how the company is managed and operarted.',
        correctExplanation:
            'Investors provide capital in exchange for ownership shares and agree to share both the risks and rewards. This approach is common for high-growth startups that need massive amounts of capital to scale quickly.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l3_q19',
    title: 'Time Value of Money (TVM)',
    subtitle: 'Why [GEM] today are worth more',
    difficulty: QuizDifficulty.hard,
    requiredLevel: 3,
    questions: [
      QuizQuestion(
        question: 'What is the core concept of "Time Value of Money"?',
        options: [
          'Money has different emotional value at different points in life',
          'Present [GEM] is worth more than future [GEM] because of inflation',
          'Wealth depends entirely on hours worked regardless of investment growth',
          'Value remains constant across time and is unaffected by interest rates',
        ],
        correctIndex: 1,
        wrongExplanation:
            'The time value of money concept is not based on internal emotions, working hours, or fixed value assumptions. It specifically recognizes that money can grow significantly through interest or reinvestment opportunities available today.',
        correctExplanation:
            'The time value of money explains that having [GEM] today allows you to invest it, earn interest, and grow your wealth. Receiving the same amount later removes that opportunity, making future money less valuable.',
      ),
      QuizQuestion(
        question: 'In TVM, what does "Future Value" (FV) calculate?',
        options: [
          'The value an investment will reach eventually',
          'Expected cost of consumer goods many years from now by inflation',
          'Number of years required to reach retirement based on current behavior',
          'Total amount of money already spent on past investments and expenses',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Future Value does not predict inflation prices, retirement timelines, or past spending habits. It strictly calculates how much an investment grows over time using interest, compounding periods, and the total length of the investment.',
        correctExplanation:
            'Future Value helps investors understand how much their current savings or investments will grow over time, allowing for much better planning for long-term goals such as education, housing, or their eventual retirement years.',
      ),
      QuizQuestion(
        question: 'What does "Present Value" (PV) tell an investor?',
        options: [
          'The current market price of everyday consumer goods in the store',
          'Today\'s value of future [GEM] adjusted for interest',
          'The total wealth currently held across all different types of accounts',
          'The number of years required for an existing investment to double',
        ],
        correctIndex: 1,
        wrongExplanation:
            'Present Value does not measure spending power, total wealth, or doubling time. It focuses specifically on translating future cash flows into todays value using certain discounting and interest assumptions about the market economy.',
        correctExplanation:
            'Present Value allows investors to compare future payments or investments in todays terms, making it much easier to judge whether an opportunity is worthwhile compared to other available options in the market.',
      ),
      QuizQuestion(
        question: 'How does the "Discount Rate" affect Present Value?',
        options: [
          'Higher discount rate lowers today\'s value of future wealth',
          'A higher discount rate increases the future purchasing power of money',
          'The discount rate only applies to retail discounts and promotional pricing',
          'Discount rates do not influence financial calculations or any investment decisions',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Discount rates are not related to retail pricing or promotions. They represent opportunity cost and risk, directly influencing how future cash flows are valued in almost all financial decision-making processes and models.',
        correctExplanation:
            'A higher discount rate increases the opportunity cost of waiting, which reduces the present value. This reflects higher expected returns elsewhere or greater uncertainty about receiving the future money on schedule from the debtor.',
      ),
      QuizQuestion(
        question: 'An "Annuity" is a financial product that...',
        options: [
          'Pays a single large amount once at the end of contract',
          'Provides equal payments at regular intervals over defined period',
          'Is limited to short-term consumer purchases like furniture or home goods',
          'Offers no interest or time-based structure for the investor to use',
        ],
        correctIndex: 1,
        wrongExplanation:
            'An annuity is not a lump sum payment or a consumer purchase tool. It is structured specifically to distribute payments consistently over a long period, which is often used for long-term income planning during retirement.',
        correctExplanation:
            'Annuities are commonly used in retirement planning to provide predictable income streams, helping individuals manage longevity risk and maintain stable cash flow throughout their later years when they are no longer working full time.',
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
          'All higher potential returns eventually require accepting higher risk',
          'All investments should prioritize maximum risk for achieve faster wealth today',
          'Risk and return exist independently and do not influence each other now',
          'Government policies eliminate risk from all existing financial investments in country',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Risk and return are closely connected in finance. Higher returns are not guaranteed, and extreme risk-taking without a solid strategy often leads to catastrophic losses rather than long-term success or wealth creation.',
        correctExplanation:
            'The risk-return tradeoff explains why safer investments offer lower returns while riskier assets require higher potential rewards to justify the uncertainty and volatility. Investors must balance these factors based on their own goals.',
      ),
      QuizQuestion(
        question: 'What does "Beta" measure in a stock?',
        options: [
          'The volatility of a stock compared to overall markets',
          'The company’s total revenue growth over multiple years and months today',
          'The experience level of executive leadership and management and board members',
          'The amount of outstanding corporate debt owed to all the major lenders',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Beta does not measure company leadership, revenue, or previous debt levels. It strictly compares how a stocks price movements respond relative to overall market changes. A beta of one indicates the stock moves with the market.',
        correctExplanation:
            'Beta helps investors understand how sensitive a stock is to market movements, allowing for better portfolio risk management and alignment with individual risk tolerance. It is a fundamental tool for professional portfolio construction and management.',
      ),
      QuizQuestion(
        question: 'What is "Systematic Risk" (Market Risk)?',
        options: [
          'Risk impacting entire market that is not easily diversified',
          'Risk specific to one single company due to poor management decisions',
          'Operational risks such as factory shutdowns or strikes at local plants today',
          'Risks caused by individual consumer behavior or changing tastes and preferences now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Systematic risk differs from company-specific risk. It affects all assets simultaneously due to global economic, political, or world events beyond any single investors control. it is sometimes referred to as non-diversifiable risk by finance professionals.',
        correctExplanation:
            'Because systematic risk cannot be diversified away, investors require compensation through higher expected returns for holding risky market assets. Understanding this is key to building a diversified portfolio that manages specific company risks effectively.',
      ),
      QuizQuestion(
        question: 'The "Capital Asset Pricing Model" (CAPM) is used to...',
        options: [
          'Estimate required rate of return based on investment risk',
          'Predict exact future stock prices with absolute certainty and daily accuracy',
          'Identify the cheapest assets currently available in the broad global market today',
          'Eliminate all uncertainty from investment decisions to guarantee success for all',
        ],
        correctIndex: 0,
        wrongExplanation:
            'CAPM does not predict prices or remove uncertainty from the market. Instead, it provides a theoretical framework linking risk to expected return. It helps investors determine if the potential reward justifies the risk they are taking.',
        correctExplanation:
            'CAPM helps investors decide whether an investment offers sufficient return for its level of systematic risk compared to the broader market. It is a cornerstone of modern financial theory and widely used in professional asset management.',
      ),
      QuizQuestion(
        question:
            'What is the "Standard Deviation" of an investment used to measure?',
        options: [
          'Total volatility of returns around the calculated average wealth',
          'The initial purchase cost of an individual investment asset today',
          'The average economic growth rate of a country or regional group',
          'The reputation of the fund manager or the board of directors',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Standard deviation does not measure price, management quality, or economic growth. It strictly quantifies how widely returns fluctuate over time. A higher standard deviation indicates that the returns are less predictable and more volatile.',
        correctExplanation:
            'A higher standard deviation indicates greater volatility and risk, while lower values suggest more stable and predictable investment performance. Professional investors use this metric to compare the risk profiles of different investment opportunities.',
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
          'S-Corporations avoid double taxation by passing profits directly to shareholders',
          'C-Corporations are legally restricted to operating only as small domestic firms today',
          'C-Corporations are prohibited from issuing equity or raising capital from investors now',
          'S-Corporations expose owners to unlimited personal liability for business obligations always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The defining difference is taxation, not size, fundraising ability, or liability exposure. C-Corporations face taxation at both the corporate and shareholder levels, while S-Corporations pass income directly to owners.',
        correctExplanation:
            'S-Corporations are structured as pass-through entities, allowing profits to be taxed only at the shareholder level, which simplifies taxation while still preserving corporate liability protections.',
      ),
      QuizQuestion(
        question: 'What does "Limited Liability" actually protect?',
        options: [
          'The personal assets of the owners from being seized to pay business debts',
          'The business itself from experiencing losses or operational failure in competitive markets today',
          'Employees from termination or contract disputes during severe financial downturns in the country',
          'Company-owned intellectual property from theft or misuse by international competitors in market now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Limited liability does not protect the business, employees, or intellectual property. It specifically separates personal wealth from business obligations, ensuring owners are not personally ruined by corporate failure.',
        correctExplanation:
            'Limited liability shields personal assets such as homes, savings, and investments, allowing entrepreneurs and investors to take calculated risks without exposing their entire personal financial position.',
      ),
      QuizQuestion(
        question: 'A "Partnership" differs from a Corporation because...',
        options: [
          'Partners often have unlimited personal liability for business debts always now',
          'Partnerships allow shares to be traded publicly on regulated stock exchanges today',
          'Partnerships are exempt from all forms of taxation in every global jurisdiction',
          'Partnerships are legally restricted to employing no more than two individuals now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Unlike corporations, partnerships generally do not create a separate legal entity that shields owners from liability. Tax exemptions, share trading, and employment limits are not defining characteristics.',
        correctExplanation:
            'In a general partnership, each partner may be personally responsible for the full amount of business obligations, making partnerships riskier than corporate structures for large or leveraged ventures.',
      ),
      QuizQuestion(
        question: 'What is a "Non-Profit 501(c)(3)" organization?',
        options: [
          'A corporation that reinvests surplus income into charitable or social missions',
          'An organization that is legally prohibited from generating revenue under any circumstances today',
          'A business entity that does not pay employees or contractors for their work always',
          'An operational branch of the federal or local government found in major cities now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Non-profit status does not prohibit revenue or employee compensation. The key distinction is that profits must support the mission rather than be distributed to private owners or shareholders.',
        correctExplanation:
            '501(c)(3) organizations operate for public benefit purposes and receive tax advantages, including eligibility for deductible donations, making them central to education, healthcare, and charitable services.',
      ),
      QuizQuestion(
        question: 'What is a "Publicly Traded" company?',
        options: [
          'A corporation that sells ownership shares to public through stock exchanges',
          'A company owned and operated directly by government authorities in the country today',
          'A company that distributes free products to customers for promotional purposes every year',
          'A business whose financial statements are visible inside its office to all visitors now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Publicly traded companies are not government-owned or defined by transparency alone. Their defining feature is public ownership through freely traded equity securities.',
        correctExplanation:
            'Public companies access large pools of capital by selling shares to investors, but must comply with strict regulatory, reporting, and disclosure requirements.',
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
          'The frequency and magnitude of price movements over time',
          'The total volume of shares exchanged across global markets today always',
          'The processing speed of electronic trading platforms found in major cities now',
          'The combined profitability of all listed corporations within the entire market today',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Volatility does not measure trading volume, infrastructure speed, or aggregate profits. It reflects how widely and unpredictably prices fluctuate within a given period.',
        correctExplanation:
            'Volatility is a core risk metric used by traders and portfolio managers to assess uncertainty, pricing behavior, and potential short-term instability in financial markets.',
      ),
      QuizQuestion(
        question: 'What is a "Correction" in the stock market?',
        options: [
          'A decline of ten percent or more from recent peaks',
          'A government-mandated adjustment to incorrect asset pricing found in markets today now',
          'A complete suspension of trading activity across all major international stock exchanges now',
          'A rapid increase in prices caused by speculation and high investor excitement today',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Corrections are market-driven price adjustments, not regulatory actions or trading halts. They occur naturally as prices realign with underlying fundamentals.',
        correctExplanation:
            'Market corrections are considered normal events that help reset valuations and often present attractive entry points for disciplined, long-term investors.',
      ),
      QuizQuestion(
        question: 'What is "Market Sentiment"?',
        options: [
          'Prevailing emotional and psychological outlook of individual investors',
          'The total amount of capital circulating in financial markets today always',
          'The exact valuation of individual securities based on daily professional analysis',
          'A regulatory tax imposed on speculative behavior by the national government now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Market sentiment is not a numeric valuation or regulatory mechanism. It reflects collective investor psychology, which can drive prices beyond rational fundamentals.',
        correctExplanation:
            'Understanding sentiment helps professionals identify periods of excessive optimism or fear, allowing for more informed risk management and contrarian strategies.',
      ),
      QuizQuestion(
        question: 'What defines a "Recession" (the technical definition)?',
        options: [
          'Two consecutive quarters of negative growth in GDP',
          'A sustained increase in consumer prices across the entire national economy',
          'A single sharp decline in equity markets observed by many investors today',
          'Unemployment reaching a specific percentage threshold determined by the government officials now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Recessions are defined by broad economic contraction, not isolated market events or inflation levels. GDP decline over multiple quarters signals systemic slowdown.',
        correctExplanation:
            'This definition helps policymakers and analysts distinguish temporary disruptions from genuine economic downturns affecting employment, production, and consumer demand.',
      ),
      QuizQuestion(
        question: 'A "Bubble" occurs when...',
        options: [
          'Prices rise far beyond fundamental value due to high speculation',
          'Asset prices reflect their underlying intrinsic value based on solid economic data',
          'Central banks expand the money supply to encourage higher spending and investment',
          'Interest rates remain elevated for extended periods due to strict government intervention now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Bubbles are not caused simply by monetary policy or interest rates. They form when investor behavior detaches prices from realistic earnings or cash-flow expectations.',
        correctExplanation:
            'Bubbles often collapse suddenly, leading to severe losses for late entrants and broader financial instability when leveraged positions unwind.',
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
          'The tax rate applied to the last portion of income earned here',
          'The average tax paid across total income earned by the individual worker today',
          'A special rate imposed exclusively on financial institutions operating in the domestic markets',
          'The lowest statutory tax rate found in the national economy for all citizens',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Marginal tax rate does not represent average taxation or sector-specific rules. It applies only to the highest income bracket reached, not the entire income base.',
        correctExplanation:
            'Understanding marginal tax rates prevents common misconceptions about income increases and clarifies why earning more never reduces total after-tax income.',
      ),
      QuizQuestion(
        question: 'What is an "Effective Tax Rate"?',
        options: [
          'The total taxes paid divided by total income earned yearly now',
          'The rate applied to the final dollar earned by the individual citizen',
          'A measure used exclusively for corporate taxation levels across many different industries',
          'A rate adjusted for inflation annually by government officials using specific economic data',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Effective tax rate is not tied to marginal brackets or inflation. It reflects the real percentage of income surrendered after accounting for all tax layers.',
        correctExplanation:
            'Effective tax rate provides a clearer picture of an individual’s or firm’s true tax burden and is commonly used for financial planning and policy analysis.',
      ),
      QuizQuestion(
        question: 'What is "Taxable Income"?',
        options: [
          'Gross income minus deductions, adjustments, and exemptions now',
          'All income received before any adjustments are made today',
          'The balance currently held in bank accounts by individual',
          'The total refund amount owed by tax authorities now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Taxable income excludes protected amounts defined by law. Gross receipts alone do not determine tax liability without accounting for deductions and exclusions.',
        correctExplanation:
            'Reducing taxable income through legitimate deductions and planning strategies is a core objective of effective personal and corporate tax management.',
      ),
      QuizQuestion(
        question: 'A "Regressive Tax" is one where...',
        options: [
          'Low earners pay higher shares of income than wealthy ones',
          'Higher earners pay progressively higher percentages of their total income earned always',
          'Taxes decrease automatically over time regardless of economic performance in the country',
          'No enforcement mechanisms exist to collect revenue from citizens in rural areas',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Regressive taxation is not about rate decline over time or lack of enforcement. It disproportionately impacts lower earners relative to their income.',
        correctExplanation:
            'Sales and consumption taxes often exhibit regressive characteristics, which policymakers must balance against progressive income taxation to maintain equity.',
      ),
      QuizQuestion(
        question: 'What is "Capital Gains Tax"?',
        options: [
          'Tax on profits from selling investments like stocks or property',
          'A tax applied to earned wages from a regular job or salary',
          'A levy on total asset value held by an individual or corporation',
          'A fee associated with capital cities and their specific local government laws',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Capital gains tax applies only to realized profits, not gross sale values or earned income, distinguishing it from standard income taxation.',
        correctExplanation:
            'Preferential capital gains rates are often used to encourage long-term investment and economic growth by reducing friction in capital allocation.',
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
          'To balance risk and reward by spreading [GEM] across different asset classes',
          'To concentrate nearly all investable capital into a single asset believed to outperform today',
          'To completely eliminate taxes through portfolio structure without considering any investment risk now',
          'To maximize short-term spending efficiency instead of long-term financial stability and growth now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Asset allocation is not about concentration or tax avoidance. Overconcentrating capital dramatically increases volatility and exposes investors to large losses when a single asset or sector underperforms unexpectedly.',
        correctExplanation:
            'Asset allocation reduces portfolio risk by combining assets with different behaviors. This improves long-term stability and allows investors to pursue growth while controlling downside risk.',
      ),
      QuizQuestion(
        question: 'What does it mean for two investments to be "Uncorrelated"?',
        options: [
          'The performance of one investment does not reliably move with the other',
          'They consistently move in the same direction because they respond to identical economic forces always',
          'They are held within the same brokerage or custodial account managed by a professional now',
          'They operate under identical legal and regulatory frameworks found within the entire domestic market today',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Investments that move together do not provide diversification benefits. High correlation increases portfolio risk and can cause multiple assets to decline simultaneously during market stress.',
        correctExplanation:
            'Uncorrelated assets reduce volatility by offsetting losses. When one asset declines, another may remain stable or rise, helping protect total portfolio value.',
      ),
      QuizQuestion(
        question: 'What is "Rebalancing" a portfolio?',
        options: [
          'Buying and selling assets to restore original target asset allocation',
          'Selling profitable investments to fund unrelated personal expenses without regard for risk management',
          'Waiting passively for markets to correct themselves without taking any active steps now',
          'Changing account providers or credentials to improve overall safety of your digital assets',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Rebalancing is not passive behavior or liquidation for consumption. Without rebalancing, portfolios drift into unintended risk profiles that may exceed investor tolerance.',
        correctExplanation:
            'Rebalancing maintains consistent risk by trimming outperforming assets and increasing exposure to underperforming ones, reinforcing disciplined long-term investing.',
      ),
      QuizQuestion(
        question: 'What is a "Target Date Fund"?',
        options: [
          'A fund that gradually shifts from higher risk to lower risk',
          'An investment vehicle that exists only briefly before mandatory liquidation on calendar deadlines',
          'A short-term trading product designed for frequent buying and selling on secondary markets',
          'A fund designed to finance specific personal events like luxury weddings or vacations',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Target date funds are not short-term or speculative instruments. They are long-term retirement solutions that automatically adjust risk exposure over decades.',
        correctExplanation:
            'These funds simplify retirement investing by automatically reducing risk as the target retirement year approaches, aligning investments with changing risk tolerance.',
      ),
      QuizQuestion(
        question:
            'Why does an investor\'s "Time Horizon" matter for allocation?',
        options: [
          'A longer time horizon allows greater risk tolerance because recovery time exists',
          'It determines the specific trading hours available to the individual investor in the country today',
          'It dictates which financial institution must be used for all types of investment accounts and services',
          'It has no meaningful impact on investment decisions made by the individual or professional advisors always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Time horizon has nothing to do with bank selection or market hours. Ignoring it often results in portfolios that are either too risky or overly conservative.',
        correctExplanation:
            'Longer time horizons allow investors to absorb volatility and pursue higher returns, while shorter horizons require more stable, conservative allocations.',
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
          'A financial contract whose value depends on an underlying asset',
          'A banking product designed primarily for storing deposits and earning interest over time today always',
          'A standardized method for calculating personal income taxes used by the local government authorities now',
          'A perpetual loan with no maturity date that is offered to high income earners only',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Derivatives are not bank accounts or tax tools. They derive value from another asset and introduce leverage, making them powerful but potentially dangerous instruments.',
        correctExplanation:
            'Derivatives allow investors to manage risk, speculate, or hedge positions by referencing assets such as stocks, bonds, commodities, or currencies.',
      ),
      QuizQuestion(
        question: 'What is the primary purpose of "Hedging"?',
        options: [
          'To reduce or offset the risk of losses in an existing position',
          'To maximize profits regardless of risk exposure to the overall market conditions today always',
          'To hide investment losses from others using complicated legal structures and offshore banking accounts now',
          'To increase unnecessary portfolio complexity through the use of advanced financial instruments and contracts today',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Hedging is not about profit maximization or concealment. It sacrifices some upside potential in exchange for protection against severe downside losses.',
        correctExplanation:
            'Hedging functions like insurance, helping investors manage uncertainty and reduce the financial impact of adverse market movements.',
      ),
      QuizQuestion(
        question: 'In options trading, what is a "Call Option"?',
        options: [
          'The right to buy stock at a set price within specific time',
          'The contractual right to sell shares at a fixed price regardless of market conditions',
          'A communication request initiated by a brokerage firm regarding your active trading accounts now always',
          'A binding obligation to purchase an entire company following a formal agreement between parties',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Call options do not grant selling rights. Confusing calls with puts leads to incorrect strategies and significant financial losses.',
        correctExplanation:
            'Call options benefit from rising prices, allowing investors to control shares at a fixed price while limiting losses to the premium paid.',
      ),
      QuizQuestion(
        question: 'In options trading, what is a "Put Option"?',
        options: [
          'The contractual right to sell a stock at a specific price now',
          'The binding obligation to buy a fixed number of shares in the market today',
          'A deposit into a savings vehicle used to build long term wealth always now',
          'An account cancellation method required for all inactive trading platforms found in country always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Put options are not savings tools or purchase obligations. They provide downside protection by allowing investors to sell at a predetermined price.',
        correctExplanation:
            'Puts are commonly used to hedge portfolios, protecting against sharp market declines while limiting potential losses.',
      ),
      QuizQuestion(
        question: 'What occurs during "Short Selling"?',
        options: [
          'Borrowing shares to sell now, planning to repurchase them later cheaper',
          'Buying shares for temporary ownership while waiting for a specific price increase today',
          'Liquidating assets due to cash shortages caused by unexpected medical or personal expenses',
          'Purchasing shares at a discounted price offered by the brokerage firm to customers',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Short selling is not discounted buying. It involves borrowing shares and carries unlimited risk if prices rise unexpectedly.',
        correctExplanation:
            'Short selling allows investors to profit from declining prices but exposes them to significant losses if markets move upward.',
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
          'The global marketplace used for trading one currency for another currency',
          'A specialized system for processing international retail payments between different countries today always',
          'A fixed accounting expense ratio used by major corporations to track global costs',
          'An export licensing framework required for businesses that sell products in foreign nations',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Forex is not an accounting ratio or licensing system. It is the global marketplace where currencies are exchanged continuously.',
        correctExplanation:
            'Forex enables international trade and investment by allowing currencies to be exchanged at constantly changing rates.',
      ),
      QuizQuestion(
        question: 'When a currency "Appreciates," what does that mean?',
        options: [
          'Its value increases relative to another currency in the global markets',
          'Its purchasing power decreases consistently due to inflation and weak demand today always',
          'It stops being issued by the government following a significant economic or political crisis',
          'It becomes unusable in international trade because of strict sanctions imposed by nations',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Appreciation does not mean reduced value or discontinued use. It reflects increased demand relative to another currency.',
        correctExplanation:
            'Currency appreciation increases purchasing power for imports but may hurt export competitiveness.',
      ),
      QuizQuestion(
        question: 'What is a "Trade Deficit"?',
        options: [
          'When a country imports more goods and services than it exports',
          'When exports exceed imports during a specific period of economic activity today always',
          'A situation where a country has no foreign reserves left in its bank',
          'A tax applied to imported goods by national government to protect local industries',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A trade deficit is not a tax or reserve shortage. It occurs when a country purchases more goods from abroad than it sells.',
        correctExplanation:
            'Persistent trade deficits can influence currency value and long-term economic balance.',
      ),
      QuizQuestion(
        question: 'What is a "Tariff"?',
        options: [
          'A tax imposed on imported goods to regulate international trade and commerce',
          'A diplomatic financial gift given to a foreign nation during an official visit today',
          'A transportation infrastructure system used for moving products across different country borders always now',
          'A securities trading license required for individuals working in the international investment banking industry',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Tariffs are not gifts or licenses. They are taxes designed to influence trade behavior and protect domestic industries.',
        correctExplanation:
            'Tariffs can shield local producers but often raise prices for consumers.',
      ),
      QuizQuestion(
        question: 'What is "Hyperinflation"?',
        options: [
          'Extremely rapid and uncontrollable price increases that devalue the national currency quickly',
          'Moderate price increases observed in the daily cost of living for families today always',
          'Fast stock market growth fueled by high investor confidence and record breaking corporate profits',
          'An accelerated savings strategy intended to build wealth quickly during periods of economic instability',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Hyperinflation is not normal inflation. It reflects severe monetary collapse where currency rapidly loses value.',
        correctExplanation:
            'Hyperinflation is usually triggered by excessive money creation and loss of confidence in government finances.',
      ),
    ],
  ),

  QuizMetadata(
    id: 'l4_q7',
    title: 'Advanced Mortgages',
    subtitle: 'The 100,000 [GEM] math of a home',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is a "Fixed-Rate Mortgage"?',
        options: [
          'A loan with interest rate that remains constant over several decades',
          'A home whose market value never changes regardless of the local economic conditions today',
          'A mortgage repayable within one single year following the initial agreement between all parties now',
          'A lending product restricted to wealthy borrowers found in major international financial centers today always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Fixed-rate mortgages do not stabilize home values. They stabilize payments, protecting borrowers from interest rate fluctuations.',
        correctExplanation:
            'Fixed rates provide long-term predictability, making budgeting easier and reducing exposure to rising rates.',
      ),
      QuizQuestion(
        question: 'How does an "ARM" (Adjustable-Rate Mortgage) work?',
        options: [
          'Interest rates change over time based on specific market benchmarks',
          'Payments are made through physical labor instead of using cash or digital currency today',
          'The lender can seize the property at will without any formal legal warning or notice',
          'Interest is permanently set to zero for the entire duration of the housing loan always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'ARMs are not labor-based or zero-interest loans. They adjust periodically, exposing borrowers to payment increases.',
        correctExplanation:
            'ARMs may offer lower initial rates but carry higher long-term risk if rates rise significantly.',
      ),
      QuizQuestion(
        question: 'What is a "Mortgage Amortization Schedule"?',
        options: [
          'Breakdown of how each payment applies to interest and principal monthly',
          'A property feature list describing every individual room and structural component of the house today',
          'A relocation plan used by families moving between different neighborhoods or large cities across country',
          'A neighborhood agreement signed by all residents living on a specific residential street today always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Amortization schedules are not property descriptions. They reveal how interest dominates early payments.',
        correctExplanation:
            'Understanding amortization helps borrowers see the true long-term cost of borrowing.',
      ),
      QuizQuestion(
        question: 'What is "Home Equity"?',
        options: [
          'Value owned outright by the homeowner after subtracting all debts',
          'The home’s current market price estimated by a professional real estate agent today always',
          'Outdoor property size measured in square meters or acres depending on the specific location now',
          'Insurance coverage type required for all residential properties found within the domestic market today always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Equity does not equal market value alone. It reflects ownership after subtracting remaining debt.',
        correctExplanation:
            'Home equity is a key source of household wealth accumulation over time.',
      ),
      QuizQuestion(
        question: 'What is a "Refinance" (Refi)?',
        options: [
          'Replacing an existing mortgage with a brand new loan agreement',
          'Renovating a home to increase its overall market value and aesthetic appeal for potential buyers',
          'Purchasing additional property as an investment strategy to build long term wealth in the country',
          'Paying off debt in cash instead of using multiple monthly installments over several different years now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Refinancing is not renovation or early payoff. It replaces debt to improve terms.',
        correctExplanation:
            'Refinancing can reduce interest costs but requires careful cost-benefit analysis.',
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
          'Price divided by earnings per share of a company',
          'Profit divided by expenses across multiple operational departments of a corporation',
          'Employee percentage metric used to track productivity within the entire organization',
          'Energy cost ratio calculated by the facilities management team for electricity',
        ],
        correctIndex: 0,
        wrongExplanation:
            'P/E does not measure costs or staffing. It reflects how much investors pay for earnings.',
        correctExplanation:
            'P/E ratios indicate growth expectations and valuation sensitivity.',
      ),
      QuizQuestion(
        question: 'What does "Market Capitalization" (Market Cap) mean?',
        options: [
          'Total value of all outstanding shares in the entire company',
          'Total buildings owned by a corporation across multiple different geographic regions',
          'Headquarters location chosen by board of directors for its strategic advantages',
          'Cash reserves held in various banking institutions to fund future expansion',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Market cap is not physical assets or cash alone. It reflects total market valuation.',
        correctExplanation:
            'Market cap categorizes company size and risk characteristics.',
      ),
      QuizQuestion(
        question: 'What is "EBITDA"?',
        options: [
          'Earnings before interest, taxes, depreciation, and amortization for the firm',
          'A professional qualification required for individuals working in the accounting and finance industry today always',
          'A trade authority responsible for regulating international commerce and export activities between multiple different nations now',
          'Marketing expenditure total calculated by the advertising department to reach new customers in global markets always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'EBITDA is not a credential or spending metric. It isolates operational performance.',
        correctExplanation:
            'EBITDA allows cross-company comparison by removing accounting distortions.',
      ),
      QuizQuestion(
        question: 'What is a "Dividend Yield"?',
        options: [
          'Annual dividend divided by stock price for the investment',
          'Lifetime dividends paid to all historical shareholders since the initial public offering of the firm today',
          'Number of shareholders currently registered with the company following the latest annual meeting of the board',
          'Risk measurement used by traders to assess the potential for significant architectural failures within the infrastructure always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Dividend yield is not historical totals or ownership counts. It represents income return.',
        correctExplanation:
            'Dividend yield helps income-focused investors assess cash flow potential.',
      ),
      QuizQuestion(
        question: 'What is "Book Value"?',
        options: [
          'Net asset value if the entire company was liquidated',
          'Textbook cost typically associated with a new undergraduate degree in economics or finance today always',
          'Library size measured by the total number of books found within the corporate research division now',
          'Legal expense total accumulated after multiple different court cases involving intellectual property disputes in the industry now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Book value is not educational cost. It reflects accounting net worth.',
        correctExplanation:
            'Book value aids value investors in identifying undervalued firms.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q9',
    title: 'Monetary Policy & The Fed',
    subtitle: 'The trillion-dollar [GEM] levers of power',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question:
            'What is the primary role of the "Federal Reserve" (The Fed)?',
        options: [
          'Manage the nation\'s money supply and set overall interest rates',
          'To administer national tax system, directly collect revenues from individuals and businesses found in the country today always',
          'To operate all government payment systems and approve every financial transaction occurring in the national economy today always',
          'To guarantee financial profits for banks and investment firms regardless of current market conditions or overall economic performance now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The Federal Reserve does not collect taxes or manage government spending. Its role is monetary, not fiscal, and it operates independently from agencies responsible for taxation or direct budgetary decisions.',
        correctExplanation:
            'The Federal Reserve influences economic activity by controlling interest rates and liquidity. By tightening or loosening monetary conditions, it affects borrowing, spending, inflation, and overall financial stability.',
      ),
      QuizQuestion(
        question: 'What happens when The Fed "Raises" interest rates?',
        options: [
          'Borrowing becomes more expensive, which usually cools down overheating inflation',
          'Borrowing costs fall significantly, encouraging higher consumer spending and rapid credit expansion across all households today always',
          'Government spending automatically increases to offset higher private borrowing costs found within the entire domestic market today always',
          'Asset prices instantly rise across all markets without any exception regardless of the underlying economic fundamentals or market sentiment now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Raising interest rates increases borrowing costs, not lowers them. This typically slows spending and investment rather than accelerating economic activity or guaranteeing higher asset prices.',
        correctExplanation:
            'The Fed raises rates to slow economic demand when inflation is rising too quickly. Higher rates reduce borrowing, discourage excessive spending, and help stabilize prices over time.',
      ),
      QuizQuestion(
        question: 'What is "Quantitative Easing" (QE)?',
        options: [
          'Central bank buys government bonds to inject [GEM] into economy',
          'A comprehensive process for tracking every unit of currency in circulation',
          'A targeted tax policy applied only to high-income earners during expansions',
          'A regulatory rule limiting how many financial assets investors may hold',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Quantitative easing is not a tax or accounting process. It is a monetary tool used when interest rates are already very low and traditional policy tools become ineffective.',
        correctExplanation:
            'QE increases liquidity by purchasing long-term securities, lowering yields and encouraging lending, investment, and economic activity when standard rate cuts are no longer sufficient.',
      ),
      QuizQuestion(
        question: 'What is the "Dual Mandate" of the Federal Reserve?',
        options: [
          'Maximum employment and stable prices with low inflation consistently',
          'To supervise banks while simultaneously collecting taxes and enforcing federal budget laws found across the entire nation today always',
          'To control currency printing and eliminate all financial fraud occurring within the international banking systems and markets today always',
          'To oversee military funding and national infrastructure projects decided by the elected government officials and their respective agencies now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The Federal Reserve does not manage taxation, defense spending, or fraud enforcement. Its mandate is narrowly focused on employment levels and price stability within the economy.',
        correctExplanation:
            'The dual mandate requires balancing strong employment with low inflation. These goals often conflict, forcing the Fed to make difficult trade-offs in monetary policy decisions.',
      ),
      QuizQuestion(
        question: 'What are "Reserve Requirements"?',
        options: [
          'Percentage of deposits a bank must keep in reserve',
          'The minimum amount of personal savings individuals must maintain in regulated banking institutions found in major international financial centers today always',
          'A mandatory employment quota imposed on private companies following a specific government order to increase workforce participation across country borders now',
          'A legal requirement for businesses to hold emergency cash funds that are strictly separated from their operational and research development budgets today',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Reserve requirements do not apply to individuals or employment levels. They regulate how much banks can lend to prevent instability and reduce the risk of systemic bank failures.',
        correctExplanation:
            'Reserve requirements limit excessive lending and protect financial stability. Lowering them allows banks to expand credit, while raising them restricts money creation.',
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
          'Fiscal policy is the use of government spending and taxation',
          'Fiscal policy is controlled by central banks and focuses exclusively on interest rates and liquidity management solutions today always',
          'Monetary policy applies only to low-income households and has no effect on large corporations or professional investors in market now',
          'There is no meaningful distinction between monetary and fiscal policy tools used by the national government to manage its economy today',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Fiscal policy is not controlled by the central bank. It is determined by elected officials through government budgets, taxation decisions, and public spending priorities.',
        correctExplanation:
            'Fiscal policy uses taxation and spending to influence economic growth, employment, and public welfare, while monetary policy operates through interest rates and money supply.',
      ),
      QuizQuestion(
        question: 'What is a "Budget Deficit"?',
        options: [
          'When the government spends more [GEM] than it collects annually',
          'A situation where the government completely runs out of money and cannot fund any public services for its citizens today now',
          'An accounting error caused by inaccurate tax reporting across several different government agencies and departments following a recent budget audit today',
          'A penalty imposed on countries with low economic growth and high unemployment rates by international financial organizations and major global lenders now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A budget deficit does not mean the government has no money. It simply means spending exceeded revenue during a specific fiscal year.',
        correctExplanation:
            'Budget deficits are financed through borrowing, usually by issuing government bonds, allowing governments to fund operations beyond current tax revenues.',
      ),
      QuizQuestion(
        question: 'What is the "National Debt"?',
        options: [
          'Total accumulation of all past deficits that remain unpaid today',
          'The combined personal debt of all citizens and households within a country regardless of their individual income or savings now always',
          'The amount of money distributed as government grants to various non-profit organizations and small businesses to encourage higher economic growth today always',
          'A recurring tax imposed on every resident living within the nation boundaries to help fund defense spending and infrastructure projects decided now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'National debt is not household debt or grants. It represents outstanding government obligations accumulated over many years of borrowing.',
        correctExplanation:
            'High national debt increases interest costs and reduces fiscal flexibility, as future tax revenues must service existing obligations.',
      ),
      QuizQuestion(
        question: 'What does the "Debt-to-GDP Ratio" measure?',
        options: [
          'Total government debt compared to annual economic output',
          'The exact amount of debt owed by each citizen on an individual basis across all social and economic classes today always',
          'The portion of taxes allocated to defense spending and international military aid decided by the elected political leaders and their advisors now',
          'The repayment period of public loans borrowed from international financial institutions or major private sector lenders found within global markets today always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Debt-to-GDP does not assign debt per person. It evaluates sustainability by comparing debt size to the economy’s capacity to generate income.',
        correctExplanation:
            'This ratio helps economists assess whether a country can reasonably service its debt without triggering default or inflation.',
      ),
      QuizQuestion(
        question: 'What is "Discretionary Spending" in a government budget?',
        options: [
          'Spending that Congress approves annually through the formal budget process today now',
          'Spending legally required under entitlement programs such as pensions and healthcare for citizens',
          'Spending conducted secretly without any form of public oversight or democratic legislative review',
          'Private sector consumer spending tracked by the national statistical agency to monitor economy',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Discretionary spending is not mandatory or secret. It is debated and adjusted yearly, unlike entitlement programs that are automatically funded.',
        correctExplanation:
            'Discretionary spending includes defense, education, and infrastructure, making it the primary area targeted during budget negotiations.',
      ),
    ],
  ),

  QuizMetadata(
    id: 'l4_q11',
    title: 'Behavioral Finance',
    subtitle: 'The psychology of the [GEM] market',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is "Loss Aversion" in psychology?',
        options: [
          'The tendency for people to feel losses more intensely than equivalent gains now',
          'A navigational fear experienced when unfamiliar with physical surroundings in new environments today always',
          'A strategy focused on maximizing gains at any cost without considering potential financial risks',
          'The habit of ignoring financial information entirely due to overwhelming stress from market volatility',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Loss aversion is not about physical fear or neglecting information. It describes a psychological bias that distorts rational decision-making in financial contexts.',
        correctExplanation:
            'Loss aversion causes investors to avoid realizing losses, often leading to poor timing decisions and long-term underperformance.',
      ),
      QuizQuestion(
        question: 'What is the "Sunk Cost Fallacy"?',
        options: [
          'Continuing an investment because of past [GEM] already spent today always',
          'The expense of constructing maritime vessels for international shipping during periods of growth',
          'Assuming prices always rise over time regardless of the specific underlying economic conditions',
          'Investing exclusively in low-risk assets to avoid any possibility of significant financial loss',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Sunk costs are unrecoverable and should not influence future decisions. Continuing solely due to past spending often compounds losses.',
        correctExplanation:
            'Recognizing sunk costs allows investors to reallocate capital toward better opportunities rather than emotionally defending poor decisions.',
      ),
      QuizQuestion(
        question: 'What is "Herd Mentality" in the stock market?',
        options: [
          'Following the actions of others without conducting any independent analysis today always',
          'The coordinated purchasing of agricultural assets to improve food security and national stability',
          'Maintaining a diversified investment portfolio across many different asset classes and geographic regions',
          'Mandatory participation in investment groups required by banking institutions for all new account holders',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Herd behavior ignores fundamentals and increases bubble risk. Many investors enter at peak prices and exit during panic-driven declines.',
        correctExplanation:
            'Avoiding herd mentality encourages independent analysis and disciplined investing, improving long-term outcomes.',
      ),
      QuizQuestion(
        question: 'What is "Confirmation Bias"?',
        options: [
          'Seeking information that confirms existing beliefs while ignoring contradictory evidence today now',
          'Receiving notifications after trades are executed on the stock exchange during normal business hours',
          'Publicly sharing investment successes to build a reputation as a successful and professional market trader',
          'Consulting professional advisors to gain expert insights into current market trends and future economic forecasts',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Confirmation bias filters out contradictory evidence, preventing objective assessment and increasing exposure to avoidable risks.',
        correctExplanation:
            'Actively challenging assumptions helps investors identify weaknesses in their strategies and improve decision quality.',
      ),
      QuizQuestion(
        question: 'What is "FOMO" (Fear Of Missing Out)?',
        options: [
          'Anxiety caused by observing others profit while remaining uninvested today always now',
          'A structured high-interest lending product offered by major global banking institutions to institutional clients',
          'The cost of excessive trading activity including commissions and fees charged by brokerage firms',
          'A regulatory limit on investment gains imposed by the national government to ensure fair competition',
        ],
        correctIndex: 0,
        wrongExplanation:
            'FOMO leads to impulsive buying after prices have risen, increasing the likelihood of losses when momentum reverses.',
        correctExplanation:
            'Discipline, planning, and valuation-based investing are effective defenses against emotionally driven FOMO decisions.',
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
          'Guideline allowing withdrawal of 4% yearly without depleting assets today always',
          'A recommendation to save exactly four percent of income annually into a diversified account',
          'The minimum interest paid on savings accounts by the national central bank each tax year',
          'The maximum retirement tax rate applied to high-income earners within the local domestic financial market',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The 4% rule does not dictate savings rates or interest guarantees. It estimates sustainable withdrawals based on historical market returns.',
        correctExplanation:
            'This rule helps retirees estimate safe spending levels while preserving portfolio longevity under typical market conditions.',
      ),
      QuizQuestion(
        question: 'What is "Sequence of Returns Risk"?',
        options: [
          'The risk of poor returns early in retirement today always',
          'The risk of stock exchanges shutting down because of major technical failures or crises',
          'The order of household bill payments required to maintain a good personal credit score',
          'Holding multiple accounts across different financial institutions to improve security and overall safety today',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Early negative returns can permanently damage retirement portfolios because withdrawals occur when asset values are depressed.',
        correctExplanation:
            'Managing this risk involves cash reserves and conservative allocations during early retirement years.',
      ),
      QuizQuestion(
        question: 'What is a "Roth Conversion"?',
        options: [
          'Moving funds from traditional to Roth accounts for tax-free growth',
          'Changing legal identity following a major life event or relocation to a new country',
          'Selling property assets to fund retirement goals while reducing overall exposure to real estate today',
          'Doubling wealth quickly by participating in high-risk speculative trading on global financial markets now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Roth conversions are not instant wealth strategies. They require paying taxes upfront to reduce future tax exposure.',
        correctExplanation:
            'Strategic conversions can significantly reduce lifetime tax liability when timed correctly.',
      ),
      QuizQuestion(
        question: 'What is a "Required Minimum Distribution" (RMD)?',
        options: [
          'Mandatory withdrawals starting at a certain age today always',
          'Minimum wage requirement enforced by national labor laws to protect low income workers today',
          'Account opening minimum required by commercial banks to access professional investment portfolios now always',
          'Charitible giving minimum suggested for wealthy individuals to reduce their taxable income during the year',
        ],
        correctIndex: 0,
        wrongExplanation:
            'RMDs are not optional and exist to ensure deferred taxes are eventually collected by the government.',
        correctExplanation:
            'Failing to comply with RMD rules results in severe penalties, making proactive planning essential.',
      ),
      QuizQuestion(
        question:
            'What is an "HSA" (Health Savings Account) used as a retirement tool?',
        options: [
          'A triple tax-advantaged account for healthcare costs today always',
          'A short-term medical expense fund only used for minor doctor visits and generic prescriptions',
          'Vehicle insurance required for all drivers to protect against accidents and potential legal liability now',
          'Fitness-related savings used to purchase gym memberships or luxury health equipment for home use today',
        ],
        correctIndex: 0,
        wrongExplanation:
            'HSAs are not limited to short-term use. They can function as powerful long-term retirement investment vehicles.',
        correctExplanation:
            'HSAs provide unmatched tax efficiency when used strategically for retirement healthcare expenses.',
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
          'Consumption, investment, government spending, and net exports of the country today',
          'Financial assets, real estate, commodities, and labor within the domestic industrial borders',
          'Taxes, fees, fines, and grants collected by the national government to fund public activities',
          'Agricultural and industrial output categories tracked by the statistical agency to monitor economic growth patterns',
        ],
        correctIndex: 0,
        wrongExplanation:
            'GDP does not measure asset classes or tax types. It tracks total economic production through spending categories.',
        correctExplanation:
            'These components together capture the full scope of economic activity within a country.',
      ),
      QuizQuestion(
        question: 'What is the "CPI" (Consumer Price Index)?',
        options: [
          'The weighted average price of a basket of goods today',
          'A population growth measure used by urban planners to estimate future housing and infrastructure needs',
          'Stock market pricing index used to track the performance of major technology companies over time',
          'Retail sales tax applied to luxury items purchased within specific geographic regions of the country always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'CPI does not track markets or populations. It measures consumer price changes to estimate inflation.',
        correctExplanation:
            'CPI helps policymakers and investors understand purchasing power trends over time.',
      ),
      QuizQuestion(
        question: 'What is a "Leading Economic Indicator"?',
        options: [
          'A metric that changes before the broader economy today',
          'An economic report detailing past fiscal performances of various national and local governments always',
          'A corporate performance award given to businesses that exceed their annual revenue targets consistently over time',
          'A fiscal penalty imposed on companies that fail to meet their regulatory environmental standards during the year',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Leading indicators are forward-looking and differ from lagging measures like GDP.',
        correctExplanation:
            'They help forecast economic turning points and guide investment decisions.',
      ),
      QuizQuestion(
        question: 'What is "Stagflation"?',
        options: [
          'High inflation combined with stagnant growth characterised by high unemployment and stagnant wages',
          'Rapid growth with stable prices observed during the most successful periods of recent economic history',
          'Long-term price stability maintained through effective monetary policy and coordination between major central banks',
          'Urban development measurement used to track the expansion of residential and commercial properties within the city',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Stagflation is dangerous because traditional policy tools struggle to address inflation and unemployment simultaneously.',
        correctExplanation:
            'This condition forces central banks to make aggressive and often painful policy adjustments.',
      ),
      QuizQuestion(
        question: 'What is the "Yield Curve" (and why is it a warning)?',
        options: [
          'A graph of bond yields by maturity today that signals investor pessimism and preceded recessions',
          'A graphical commodity pricing pattern used by traders to predict future supply and demand shifts',
          'A short-term equity chart showing daily fluctuations in stock prices for major global technology firms',
          'A geological measurement used by mining companies to estimate the density and value of mineral deposits',
        ],
        correctIndex: 0,
        wrongExplanation:
            'An inverted yield curve signals investor pessimism and has historically preceded recessions.',
        correctExplanation:
            'It reflects expectations of economic slowdown and future rate cuts.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q14',
    title: 'Venture Capital & Equity',
    subtitle: 'Risk capital and ownership economics',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is the primary role of a Venture Capital (VC) firm?',
        options: [
          'To invest [GEM] in early-stage, high-growth companies for equity ownership today',
          'To provide collateralized loans to established corporations found in major international banking centers',
          'To allocate public funds toward regulated infrastructure projects with predictable cash flows today always',
          'To underwrite fixed-income securities for conservative institutional investors looking for low risk now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Venture capital firms do not function as lenders or underwriters. Their returns depend on equity appreciation, not interest payments or guaranteed income streams.',
        correctExplanation:
            'VC firms deploy high-risk capital into young companies with scalable business models, accepting frequent failures in exchange for occasional outsized equity returns.',
      ),
      QuizQuestion(
        question: 'What typically occurs during a Series A funding round?',
        options: [
          'A company raises its first institutional round to scale after validation today',
          'The founders rely exclusively on personal savings and early employee contributions today always',
          'The company distributes retained earnings to shareholders as recurring dividends every single quarter',
          'The firm restructures debt obligations following liquidity stress and significant operational underperformance now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Founder capital and seed rounds precede Series A. Dividends and debt restructuring are characteristics of mature or distressed companies, not early-stage growth.',
        correctExplanation:
            'Series A marks the transition from validation to execution, where institutional capital funds hiring, infrastructure, and market expansion at increasing valuations.',
      ),
      QuizQuestion(
        question: 'In finance, what defines a "Unicorn" company?',
        options: [
          'A privately held startup valued at over 1 billion [GEM] today by private equity firms',
          'A publicly listed firm with exceptional quarterly revenue growth patterns observed over time',
          'A multinational corporation operating across more than fifty countries worldwide in diverse markets',
          'A technology firm generating consistent positive free cash flow before its third fiscal year',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Unicorn status is unrelated to profitability, public listing, or geographic reach. It strictly refers to private valuation exceeding a defined threshold.',
        correctExplanation:
            'The term highlights valuation scale rather than financial maturity, often signaling strong growth expectations and future liquidity events such as IPOs or acquisitions.',
      ),
      QuizQuestion(
        question: 'What is an "Exit Strategy" for founders or investors?',
        options: [
          'Method to convert illiquid equity into realized [GEM] through public events today',
          'A predefined plan for closing offices and winding down daily operations across the country',
          'A contractual obligation to resign from executive management roles following a change in ownership',
          'A regulatory process required to dissolve a corporate legal entity under the national legislative framework',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Exits are not operational shutdowns or regulatory dissolutions. They focus on liquidity realization rather than terminating the business itself.',
        correctExplanation:
            'An exit strategy defines how equity holders ultimately monetize ownership, transforming paper valuations into spendable capital through public or private transactions.',
      ),
      QuizQuestion(
        question: 'In startup finance, what does "Burn Rate" measure?',
        options: [
          'The pace at which a company spends its available [GEM] today always',
          'The annual depreciation rate of physical and intangible assets held by the corporation now',
          'The volatility of monthly revenue growth across different reporting periods and fiscal years today',
          'The percentage of operating expenses allocated to research and development activities within the firm',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Burn rate does not measure volatility or accounting depreciation. It specifically reflects cash outflow relative to available reserves.',
        correctExplanation:
            'Understanding burn rate allows management to estimate runway, plan fundraising timelines, and avoid insolvency before sustainable revenues are established.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q15',
    title: 'IPOs & The Public Market',
    subtitle: 'Transitioning from private to public capital',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is an Initial Public Offering (IPO)?',
        options: [
          'The first sale of a private company’s shares to the public that begins the process of transitioning from private to public capital',
          'A restructuring process designed to reduce outstanding corporate liabilities and overall financial debt now',
          'An internal valuation exercise conducted for executive compensation planning and future board reviews always',
          'A government-mandated conversion of private firms into regulated entities found in the domestic markets',
        ],
        correctIndex: 0,
        wrongExplanation:
            'An IPO is not an internal or regulatory exercise. It represents a fundamental ownership transition involving public market investors.',
        correctExplanation:
            'By going public, companies access broader capital pools, provide liquidity to early investors, and become subject to ongoing disclosure obligations.',
      ),
      QuizQuestion(
        question: 'What role does an Underwriter play in an IPO?',
        options: [
          'Pricing the offering and placing shares with major institutional investors today always',
          'Drafting marketing campaigns to improve retail investor brand recognition across the international market now',
          'Auditing historical financial statements for regulatory compliance before the final company listing process begins',
          'Managing post-IPO shareholder communications and dividend distributions following the successful market debut always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'While audits and marketing exist, underwriting focuses on pricing risk, demand discovery, and execution of the public offering.',
        correctExplanation:
            'Investment banks assume placement risk, stabilize early trading, and coordinate investor demand to ensure an orderly transition into public markets.',
      ),
      QuizQuestion(
        question: 'What is an S-1 filing?',
        options: [
          'Common registration document filed with regulators prior to an IPO today',
          'A quarterly earnings disclosure submitted after a company lists publicly on the national stock exchange',
          'A confidential agreement between underwriters and cornerstone investors regarding the final offering price now',
          'A tax declaration used to calculate corporate income liabilities and other fiscal obligations for the year',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The S-1 is not post-listing or confidential. It is a public disclosure designed to inform potential investors before trading begins.',
        correctExplanation:
            'The document details financials, risks, governance, and business strategy, enabling investors to evaluate the offering with full transparency.',
      ),
      QuizQuestion(
        question: 'What is a Lock-up Period following an IPO?',
        options: [
          'Restriction preventing insiders from selling shares for defined time today always',
          'A temporary trading halt imposed during periods of extreme volatility observed in the broader financial market',
          'A regulatory review phase delaying settlement of public market transactions until all requirements are met now',
          'A contractual limit on dividend payments during the first fiscal year following the company listing process',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Lock-ups do not halt markets or dividends. They specifically restrict insider selling to protect early price stability.',
        correctExplanation:
            'By limiting insider liquidity, lock-ups reduce immediate supply pressure and signal confidence in the company’s long-term prospects.',
      ),
      QuizQuestion(
        question: 'What distinguishes a Direct Listing from a traditional IPO?',
        options: [
          'Shares begin trading publicly without issuing new equity or underwriter pricing',
          'Shares are allocated exclusively to government-sponsored investment funds and specific institutional clients found globally',
          'The company delays financial disclosures until after trading begins on the public market exchange today',
          'Retail investors are restricted from participating during initial sessions until the price stability is fully reached',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Direct listings do not restrict retail access or disclosures. They eliminate capital raising and traditional underwriting mechanisms.',
        correctExplanation:
            'This approach reduces fees and pricing distortions but provides no immediate fundraising, relying entirely on existing shareholder liquidity.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q16',
    title: 'Hedge Funds & Investing',
    subtitle: 'Active strategies and risk-adjusted returns',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What primarily differentiates hedge funds from index funds?',
        options: [
          'Hedge funds pursue active, leveraged strategies aiming to outperform benchmarks today now',
          'Index funds operate under stricter ownership requirements enforced by national legislative banking authorities today',
          'Index funds concentrate capital into a small number of high-conviction positions within a single sector',
          'Hedge funds are designed to eliminate all forms of investment risk through complex mathematical modeling',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Index funds are diversified and passive, while hedge funds accept complexity, leverage, and active risk-taking to seek excess returns.',
        correctExplanation:
            'Hedge funds attempt to generate alpha through strategy, timing, and instruments, though long-term outperformance remains statistically rare.',
      ),
      QuizQuestion(
        question:
            'In investment performance analysis, what does "Alpha" measure?',
        options: [
          'Return earned above a benchmark after adjusting for market exposure today',
          'The total return generated by the overall market during a specific fiscal reporting period',
          'The volatility of returns during periods of extreme economic stress and global market instability always',
          'The liquidity premium associated with alternative asset classes found in private equity or real estate',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Alpha does not represent volatility or raw returns. It isolates skill-based performance relative to systematic market movements.',
        correctExplanation:
            'Positive alpha indicates value added beyond passive exposure, though sustaining it consistently is extremely challenging in competitive markets.',
      ),
      QuizQuestion(
        question: 'What does leverage mean in trading and investing?',
        options: [
          'Using borrowed [GEM] to amplify exposure, increasing potential gains and losses',
          'Allocating capital exclusively into low-risk government securities to protect the principal wealth today always',
          'Diversifying holdings across multiple uncorrelated asset classes to reduce the overall impact of market volatility',
          'Reducing portfolio volatility through active hedging techniques using derivatives and other complex financial products now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Leverage does not inherently diversify or reduce risk. It magnifies outcomes, making drawdowns faster and more severe.',
        correctExplanation:
            'While leverage can enhance returns, it introduces nonlinear risk, often leading to forced liquidation during adverse market movements.',
      ),
      QuizQuestion(
        question: 'What does the "2 and 20" hedge fund fee structure describe?',
        options: [
          'A 2% management fee plus 20% of profits as compensation today',
          'Two annual audits and twenty mandatory regulatory filings required by the secondary market authorities',
          'Two investment strategies and twenty portfolio managers per fund working within the same organization always',
          'A twenty-year lock-up period with a two-year redemption window provided to institutional investors today always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'These fees apply regardless of outcomes, often eroding net returns, especially when performance fails to exceed benchmarks.',
        correctExplanation:
            'High fees reflect operational complexity and talent costs, but they significantly raise the hurdle required to justify hedge fund investing.',
      ),
      QuizQuestion(
        question: 'What defines a market-neutral investment strategy?',
        options: [
          'Balancing long and short positions to minimize directional market risk today',
          'Avoiding exposure to all equity and credit markets entirely during periods of extreme global instability',
          'Holding only cash equivalents during periods of uncertainty to preserve capital for future buying opportunities',
          'Tracking a broad market index with minimal tracking error using sophisticated software and automated systems always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Market neutrality does not eliminate risk. It shifts focus from market direction to relative security performance.',
        correctExplanation:
            'Such strategies seek consistent returns independent of market trends, but require sophisticated modeling and strict risk controls.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q17',
    title: 'Bond Markets & Yields',
    subtitle: 'Interest rates and fixed-income risk',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is the relationship between bond prices and yields?',
        options: [
          'When bond prices rise, their effective yield declines today always now',
          'Bond prices and yields move in the same direction at all times during the trading sessions',
          'Yields remain fixed regardless of secondary market trading activity observed on the global bond exchanges',
          'Bond prices change only at issuance or maturity dates determined by the national central bank authorities',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Secondary market dynamics constantly adjust yields based on price movements, reflecting changing interest rate expectations.',
        correctExplanation:
            'As prices increase, fixed coupon payments represent a lower return, causing yields to fall inversely.',
      ),
      QuizQuestion(
        question: 'What characterizes high-yield or "junk" bonds?',
        options: [
          'They offer higher interest to compensate for increased default risk today',
          'They are issued exclusively by early-stage startup companies looking for rapid expansion and growth today',
          'They are guaranteed by central banks during economic downturns to ensure market stability and investor confidence',
          'They cannot be traded on secondary bond markets according to strict regulations found in the nation',
        ],
        correctIndex: 0,
        wrongExplanation:
            'These bonds are not guaranteed and remain tradable. Their yields reflect elevated credit risk.',
        correctExplanation:
            'Investors demand higher compensation because issuers have weaker balance sheets or unstable cash flows.',
      ),
      QuizQuestion(
        question: 'What does bond duration measure?',
        options: [
          'Sensitivity of a bond’s price to changes in interest rates today',
          'The contractual maturity date stated on the bond certificate issued by the national treasury department',
          'The frequency of coupon payments per year required by the original agreement between the parties now',
          'The average holding period of institutional investors found in the major global financial centers today always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Duration is not simply time to maturity. It reflects interest rate exposure across all cash flows.',
        correctExplanation:
            'Higher duration means greater price volatility when rates change, making duration central to fixed-income risk management.',
      ),
      QuizQuestion(
        question: 'Why are Treasury Bills often considered risk-free?',
        options: [
          'They are backed by the government’s ability to tax and issue currency',
          'They provide the highest returns available in global markets for all classes of institutional investors',
          'They cannot lose value under any market conditions regardless of fluctuations in the broader economic landscape',
          'They are insured by private international rating agencies which provide a full guarantee of the principal wealth',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Risk-free does not mean price stability. It refers to negligible default risk, not immunity from rate changes.',
        correctExplanation:
            'Government backing makes default extremely unlikely, establishing Treasuries as the benchmark for risk-free returns.',
      ),
      QuizQuestion(
        question: 'What does a bond’s credit rating indicate?',
        options: [
          'The issuer’s likelihood of meeting its debt obligations today always',
          'The market price investors must pay to acquire the bond during the normal trading hours now always',
          'The expected inflation rate over the bond’s lifespan predicted by the professional market analysis team today always',
          'The historical return of similar bonds in the sector observed over the past few fiscal reporting years',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Credit ratings assess default risk, not pricing or inflation expectations.',
        correctExplanation:
            'Lower ratings imply higher risk and require higher yields to compensate investors for potential nonpayment.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q18',
    title: 'REITs & Alternatives',
    subtitle: 'Diversification beyond traditional assets',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What defines a Real Estate Investment Trust (REIT)?',
        options: [
          'An entity that owns income-generating real estate and distributes earnings as dividends',
          'A construction firm specializing in residential property development across the major urban centers found today',
          'A government authority regulating land ownership transactions and property rights within the national domestic borders now',
          'A private partnership focused on speculative property flipping to generate high short term profits for its members',
        ],
        correctIndex: 0,
        wrongExplanation:
            'REITs are not developers or regulators. Their structure prioritizes income distribution from stabilized assets.',
        correctExplanation:
            'Mandatory payout rules make REITs attractive for income-focused investors seeking real estate exposure without direct ownership.',
      ),
      QuizQuestion(
        question: 'Why is gold often viewed as a hedge against inflation?',
        options: [
          'Limited supply helps preserve purchasing power during currency debasement today',
          'Its value increases at a fixed annual percentage determined by the global gold mining associations always',
          'It generates consistent income through interest payments or dividends provided by the central banks found globally',
          'Its price is controlled by central banks to ensure global financial stability during periods of economic crisis',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Gold does not yield income or grow intrinsically. Its appeal lies in scarcity and historical store-of-value properties.',
        correctExplanation:
            'When fiat currency loses purchasing power, gold often retains relative value, providing portfolio protection.',
      ),
      QuizQuestion(
        question: 'What is commodity investing?',
        options: [
          'Investing in raw materials such as energy, metals, and agricultural products today',
          'Purchasing shares in consumer goods manufacturers located within the domestic and international industrial regions now',
          'Trading finished products directly with retailers to capture the profit margins from the final consumer sales',
          'Speculating exclusively on foreign exchange markets to profit from the fluctuations between different national currencies today always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Commodities are physical inputs, not corporate equity or finished goods.',
        correctExplanation:
            'Commodity prices reflect global supply-demand dynamics and can diversify portfolios due to low correlation with equities.',
      ),
      QuizQuestion(
        question: 'At a systemic level, what is cryptocurrency?',
        options: [
          'Decentralized digital asset secured by cryptography and distributed ledgers today always',
          'A centralized digital payment system managed by commercial banks and national financial regulatory authorities found globally',
          'A government-issued replacement for physical currency designed to improve the efficiency of the domestic payment infrastructure',
          'A proprietary database controlled by technology corporations to track user data and financial transactions within their ecosystem',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Cryptocurrencies operate independently of centralized authorities and rely on consensus mechanisms.',
        correctExplanation:
            'Their decentralized nature limits supply manipulation but introduces volatility, regulatory uncertainty, and technological risk.',
      ),
      QuizQuestion(
        question: 'What does liquidity mean in an investment context?',
        options: [
          'Ease and speed with which an asset can be converted into [GEM] today',
          'The total interest income an asset generates annually based on its current market value and coupon rate',
          'The legal protection offered to investors by national and international regulators to ensure overall market fairness today always',
          'The expected appreciation rate over long holding periods estimated by the professional financial analysis and research firms found globally',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Liquidity concerns convertibility, not returns or regulatory protection.',
        correctExplanation:
            'High liquidity allows rapid access to capital, reducing the need to sell long-term assets under unfavorable conditions.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q19',
    title: 'DCF & Net Present Value',
    subtitle: 'Intrinsic valuation and capital allocation',
    difficulty: QuizDifficulty.hard,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question:
            'What is the primary objective of a Discounted Cash Flow (DCF) analysis?',
        options: [
          'To estimate the present value of investment by discounting expected future cash flows today',
          'To measure the current cash balance reported on a company’s balance sheet each fiscal year',
          'To compare short-term price momentum between competing publicly traded securities over recent reporting periods now',
          'To determine product-level pricing strategies based on historical operating margins and cost structures always now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'DCF analysis is not concerned with short-term market prices, accounting cash balances, or competitive pricing strategies. It focuses on long-term cash generation rather than snapshot financial metrics.',
        correctExplanation:
            'DCF analysis seeks to determine intrinsic value by translating projected future cash flows into today’s terms, reflecting both time value of money and investment risk.',
      ),
      QuizQuestion(
        question:
            'What does Net Present Value (NPV) represent in capital budgeting?',
        options: [
          'Difference between present value of expected cash inflows and outflows over investment life today',
          'The gross revenue generated by a project before accounting for any operating or financing costs during the year',
          'The statutory tax liability arising from a profitable long-term investment project conducted within the national domestic industrial sectors',
          'The accounting value of assets remaining after liquidation of a failed business venture or significant corporate restructuring process always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'NPV does not measure revenue, taxes, or liquidation value. It evaluates whether future benefits, discounted appropriately, exceed the total economic cost of undertaking the project.',
        correctExplanation:
            'A positive NPV indicates value creation after accounting for opportunity cost of capital, making it a foundational decision metric in corporate finance.',
      ),
      QuizQuestion(
        question: 'Within a DCF framework, what is Terminal Value?',
        options: [
          'The value assigned to cash flows beyond the explicit forecast period assuming long-term growth today',
          'The estimated recovery value of a business if operations cease at the end of the forecast horizon now',
          'The cumulative compensation paid to senior executives during the final projection year according to the original employment contracts',
          'The total outstanding liabilities recorded on the balance sheet at the end of the model period today now always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Terminal Value does not assume shutdown, compensation totals, or debt balances. It approximates the continuing economic value of a business beyond detailed projections.',
        correctExplanation:
            'Because it often represents a majority of total valuation, small changes in terminal assumptions can significantly impact overall DCF results.',
      ),
      QuizQuestion(
        question:
            'What does WACC (Weighted Average Cost of Capital) represent?',
        options: [
          'The blended required return demanded by both debt and equity providers based on contribution today',
          'A legally mandated interest rate applied uniformly across all corporate borrowing arrangements by national authorities',
          'The average operational expense incurred to maintain digital and physical infrastructure across the entire global corporation',
          'The percentage of total revenue allocated annually to marketing and brand development initiatives within major sectors',
        ],
        correctIndex: 0,
        wrongExplanation:
            'WACC is not a regulatory rate or an operating expense metric. It reflects the opportunity cost of capital from all financing sources.',
        correctExplanation:
            'WACC serves as a discount rate and investment hurdle, ensuring projects generate returns exceeding the cost of the capital employed.',
      ),
      QuizQuestion(
        question: 'What is Free Cash Flow (FCF) in valuation analysis?',
        options: [
          'Cash generated by operations after accounting for capital expenditures required to sustain business today',
          'Unrestricted funds available to shareholders after all distributions and dividend payments are fully finalized now',
          'Total reported net income adjusted for non-recurring accounting items observed over the past few fiscal years',
          'Short-term liquidity obtained through revolving credit facilities provided by commercial banking institutions found within the system',
        ],
        correctIndex: 0,
        wrongExplanation:
            'FCF is not net income, dividend surplus, or borrowed liquidity. It measures actual cash available after maintaining productive capacity.',
        correctExplanation:
            'Investors value FCF because it represents deployable capital that can fund growth, debt reduction, dividends, or acquisitions.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l4_q20',
    title: 'Arbitrage & HFT',
    subtitle: 'Market efficiency and speed-based strategies',
    difficulty: QuizDifficulty.hard,
    requiredLevel: 4,
    questions: [
      QuizQuestion(
        question: 'What is arbitrage in financial markets?',
        options: [
          'The simultaneous buying and selling of equivalent assets to exploit small price discrepancies today',
          'A regulatory mechanism used to resolve valuation disputes between institutional counterparties during the normal company settlement process now',
          'A long-term investment strategy focused on dividend income and compounding returns over many decades of disciplined saving behavior',
          'A hedging technique designed to reduce portfolio volatility during macroeconomic downturns using diversified asset classes found in global markets',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Arbitrage is not regulatory, long-term investing, or volatility hedging. It relies on near-instant execution to capture mispricing.',
        correctExplanation:
            'By eliminating price differences across markets, arbitrage activity enhances efficiency and enforces the law of one price.',
      ),
      QuizQuestion(
        question: 'What defines High-Frequency Trading (HFT)?',
        options: [
          'Use of ultra-low-latency systems to execute large trade volumes in short timeframes today always',
          'A discretionary trading approach based on macroeconomic forecasts and human judgment regarding the future state of the global markets',
          'A manual trading style emphasizing reduced transaction frequency and extended holding periods for all classes of diversified physical assets',
          'A compliance-driven trading restriction imposed during periods of excessive market volatility to protect individual and institutional investors alike',
        ],
        correctIndex: 0,
        wrongExplanation:
            'HFT does not rely on discretion or infrequent trades. Its advantage stems from speed, automation, and infrastructure investment.',
        correctExplanation:
            'HFT strategies profit from microstructure inefficiencies, often holding positions for milliseconds while providing liquidity at scale.',
      ),
      QuizQuestion(
        question: 'What is the primary function of a market maker?',
        options: [
          'Continuously quoting buy and sell prices to facilitate liquidity and earn the spread today always',
          'Designing new securities for initial public offerings on major exchanges located in the leading global financial centers found today',
          'Supervising trading activity to ensure regulatory compliance across all participants within the domestic and international financial market systems always',
          'Providing advisory services to issuers regarding capital structure optimization and future fundraising strategies during periods of growth and expansion',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Market makers are not regulators or advisors. Their role is transactional, ensuring continuous two-sided markets.',
        correctExplanation:
            'By absorbing temporary imbalances in supply and demand, market makers enable investors to transact quickly and efficiently.',
      ),
      QuizQuestion(
        question: 'What characterizes dark pool trading?',
        options: [
          'Private venues allowing large participants to execute block trades with limited transparency today',
          'Unauthorized trading venues operating outside financial regulatory frameworks and national oversight systems found within the country today always',
          'After-hours retail trading sessions restricted to non-institutional investors who wish to trade after the main market sessions are fully closed',
          'Government-operated exchanges designed to stabilize markets during crises and provide emergency liquidity to the broader national financial system always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Dark pools are regulated and legal. Their defining feature is reduced transparency, not illegality or retail access.',
        correctExplanation:
            'They minimize market impact for large trades but raise concerns about fairness and price discovery in public markets.',
      ),
      QuizQuestion(
        question: 'What is algorithmic trading?',
        options: [
          'Automated execution of trades using predefined rules based on market data today always',
          'Discretionary trading based on qualitative news interpretation and professional analyst opinions today always now',
          'A centralized system where exchanges determine specific member trading strategies to ensure stability always now',
          'A method of eliminating mathematical models from investment decision-making to focus on human judgment now',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Algorithmic trading does not remove mathematics or centralize decisions. It codifies logic into repeatable execution rules.',
        correctExplanation:
            'Automation reduces human bias, increases consistency, and dominates modern market volume across asset classes.',
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
          'The Quick Ratio specifically subtracts inventory balances to show the most liquid funds',
          'The Current Ratio includes inventory items which may take months to monetize or sell',
          'The Debt to Equity ratio measures the total long term financing provided by creditors',
          'Total Asset Turnover measures how effectively buildings generate annual business revenue',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The Current Ratio includes inventory, which might take months to sell or monetize. The Quick Ratio specifically subtracts inventory, showing only the [GEM] that are truly available right now for immediate obligations.',
        correctExplanation:
            'A Quick Ratio above 1.0 means the company can pay all its current bills without selling any inventory. This is a critical hallmark of financial strength and immediate operational stability for any professional organization.',
      ),
      QuizQuestion(
        question: 'What does a "Current Ratio" of 1.2 mean?',
        options: [
          'The company has 1.2 [GEM] in current assets for every single liability [GEM] owed.',
          'The company is facing immediate bankruptcy and requires an emergency capital injection today now.',
          'The company achieved a twenty percent net profit margin during this current reporting fiscal year.',
          'Company has exactly one hundred twenty employees working in the department.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Ratio calculations represent division between asset and liability accounts. A 1.2 ratio means assets are 20% higher than liabilities. If it drops below 1.0, the company might not be able to pay short-term debts.',
        correctExplanation:
            'While a 1.2 ratio is generally considered safe, professional financial analysts always compare this figure to the industry average to determine if the company is lagging behind or leading its peers in liquidity.',
      ),
      QuizQuestion(
        question: 'What is "Working Capital" in professional accounting?',
        options: [
          'The total amount of current assets minus the total amount of current liabilities today',
          'The total amount of [GEM] the executive team earns annually for their professional services',
          'The total long term debt owed to institutional creditors and major commercial banking entities',
          'The current market value of the physical buildings owned by the global corporation',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Working capital represents the operational liquidity available to a business. If this figure becomes negative, the operational engine of the business will likely seize up and stop functioning due to an inability to cover costs.',
        correctExplanation:
            'Positive working capital ensures that a business can continue its daily operations smoothly and has sufficient [GEM] to meet both short-term debt obligations and upcoming operational expenses without needing external emergency funding.',
      ),
      QuizQuestion(
        question: 'What is the "Debt-to-Equity" ratio used to measure?',
        options: [
          'Financial leverage representing the balance of funding between debt and total equity owners today',
          'The annual net profit margin of the company calculated before all taxes and interests',
          'The amount of corporate taxes owed to the state based on annual earnings reports',
          'The total number of shares currently circulating in the open global stock market',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If you have 100 [GEM] in debt and only 10 [GEM] in equity, your leverage ratio is 10. This is considered very aggressive and dangerous for the company if profits drop even slightly during a downturn.',
        correctExplanation:
            'Conservative companies strive to keep this ratio low to ensure they can survive severe economic downturns without the risk of creditors taking their assets. It measures the balance between borrowed funds and owner capital.',
      ),
      QuizQuestion(
        question: 'What is "Solvency"?',
        options: [
          'The ability of a business to meet all its long term financial obligations today',
          'The ability to turn physical assets into [GEM] very quickly for immediate operational needs',
          'The process of winning a significant legal case in a high national court system',
          'A type of industrial cleaning chemical used to maintain factories and heavy machines',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Liquidity focuses on the next 30 days of operations. Solvency focuses on the next 30 years. A company can be liquid but insolvent if its total debts are significantly higher than its total tangible assets.',
        correctExplanation:
            'Professional auditors must sign off on a "Going Concern" statement annually, confirming they believe the company is solvent and will remain operational for at least another year. This is vital for long-term investor confidence.',
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
          'The threshold for errors that would significantly impact the economic decisions of investors today',
          'The total cost of the external audit fee paid to the third party firms',
          'A list of all raw materials used in production across the various global factories',
          'The physical weight of precious metals stored in the central corporate secure vault',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Auditors do not check every single small transaction because it is inefficient. They set a materiality level, such as 50,000 [GEM]. If an error is below that threshold, they might choose to ignore its impact.',
        correctExplanation:
            'Materiality remains a matter of professional judgment and varies significantly based on the size and nature of the company. It defines what information is important enough to potentially change an investor’s economic decision-making process.',
      ),
      QuizQuestion(
        question: 'What is "Professional Skepticism"?',
        options: [
          'A questioning mind and a critical assessment of all investigative evidence gathered today now',
          'Assuming the client management team is always lying about the annual financial reports today',
          'A refusal to believe any financial numbers provided by the company during the audit',
          'Being consistently rude to the company management throughout the entire audit process always',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Auditors should not assume fraud exists, but they should not assume honesty either. They require verifiable evidence to back up every significant claim made by the company management before forming their final professional audit opinion.',
        correctExplanation:
            'Skepticism remains the most important trait for a professional auditor to prevent being fooled by clever accounting tricks or management bias. It involves being alert to conditions that may indicate possible misstatement due to error.',
      ),
      QuizQuestion(
        question: 'What is an "External Audit"?',
        options: [
          'An independent examination of financial statements performed by a qualified third party firm today',
          'An audit of the building\'s exterior facade and architectural integrity conducted by licensed civil engineers',
          'A review of the company by its own employees to identify potential operational improvements',
          'When the CEO checks their own personal account for potential errors or missing [GEM]',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Internal audits are performed by company employees to improve operations. External audits are performed by independent firms like the Big 4 to give high-level assurance to the general public and shareholders regarding financial statement accuracy.',
        correctExplanation:
            'Publicly traded companies are required by law to have an external audit every year to protect investors from fraud. This process ensures that the financial statements present a true and fair view of the company.',
      ),
      QuizQuestion(
        question: 'What does "Audit Independence" mean?',
        options: [
          'The auditor has no personal or financial connection to the client being audited today',
          'The auditor does not need any help from the client to gather information today',
          'The auditor does not use any standard industry rules during the financial examination process',
          'The auditor works from a home office environment instead of visiting the company',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If an auditor owns stock in the company they are auditing, they have a clear conflict of interest. They might hide bad news to protect their own investment [GEM] instead of reporting the absolute truth.',
        correctExplanation:
            'Independence is the bedrock of the auditing profession. Without it, the audit report has zero value to the market because investors cannot trust that the auditor remained objective and unbiased throughout the entire examination process.',
      ),
      QuizQuestion(
        question: 'What is a "Qualified Opinion"?',
        options: [
          'A report stating that financial statements are fair except for one specific isolated issue',
          'An opinion given by a very intelligent person who has high academic qualifications today',
          'A report stating that everything is perfect and no errors were found during audit',
          'A type of legal certificate for the board regarding the company\'s environmental social goals',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A clean or "unqualified" opinion is what every company wants. A "qualified" opinion is a yellow flag indicating the auditor found something they do not like, although the rest of the statements are generally acceptable.',
        correctExplanation:
            'If the auditor finds evidence of massive fraud or systemic errors, they give a disclaimer or an adverse opinion. Such reports usually cause the stock price to crash as they signal deep, unresolved financial reporting problems.',
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
          'The Equivalent Annual Annuity method allows comparing projects with very different expected lives',
          'Net Present Value works best for projects that have exactly the same length today',
          'Internal Rate of Return measures the percentage profit for a single project over time',
          'Payback Period measures how many years until your initial investment returns',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Net Present Value works best for projects with the same length. If Project A is 3 years and Project B is 10 years, you must use EAA to see which one creates more wealth per year.',
        correctExplanation:
            'Equivalent Annual Annuity converts the total NPV of each project into a steady annual payment that makes them easy to compare. This allows managers to select the project that maximizes value relative to the time invested.',
      ),
      QuizQuestion(
        question: 'What is "Capital Rationing"?',
        options: [
          'Choosing the best combination of projects when the total available capital is limited',
          'When a company has too many [GEM] reserves and is idling in market',
          'A tax on the company total invested capital applied by regional government authorities',
          'Giving everyone in the entire company an equal share of the profit',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Even a profitable company cannot do everything at once. If you have 1,000,000 [GEM] but three 500,000 [GEM] projects to choose from, you must ration your capital to ensure you select the most profitable combination possible.',
        correctExplanation:
            'The goal of capital rationing is to pick the combination of projects that results in the highest total NPV for the company. This process requires careful evaluation of opportunity costs and strategic alignment with long-term goals.',
      ),
      QuizQuestion(
        question: 'What is the "Profitability Index" (PI)?',
        options: [
          'The present value of inflows divided by the amount of initial project investment',
          'The total net profit margin of the company calculated before any tax payments',
          'A list of the company best performing products categorized by their annual revenue',
          'The amount of [GEM] spent on marketing costs during the recent quarter',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The Profitability Index shows "Bang for your Buck." A PI of 1.2 means that for every 100 [GEM] you invest today, you get back 120 [GEM] in present value over the life of the project.',
        correctExplanation:
            'Profitability Index is the perfect tool for working under capital rationing because it ranks projects by their efficiency. It helps managers identify which investments provide the highest relative return for each unit of [GEM] spent.',
      ),
      QuizQuestion(
        question: 'What is an "Opportunity Cost of Capital"?',
        options: [
          'The expected return from the next best alternative investment available to the company',
          'The cost of hiring a new department manager to oversee the daily operations',
          'A financial fine for missing a critical business meeting with major institutional investors',
          'The interest rate charged by the primary bank for a small loan',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If you put [GEM] in a project that earns 5%, but you could have earned 10% in the stock market instead, your true cost is that missing 10%. This represents the value sacrificed by chosen one path.',
        correctExplanation:
            'Professionals use the hurdle rate to ensure they are never doing a project that earns less than their opportunity cost. It sets a minimum return threshold that all new investments must exceed to be considered viable.',
      ),
      QuizQuestion(
        question: 'What is "Sensitivity Analysis" in a financial model?',
        options: [
          'Systematically changing variables to see the effects on the total project net value',
          'Being careful not to hurt the client personal feelings during a professional meeting',
          'Searching for minor clerical errors in the spreadsheet used for the financial model',
          'A review of the company social media accounts for potential marketing trends',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Financial models are just educated guesses about the future. Sensitivity analysis tells you: "If our sales are 10% lower than we predicted, is this project still worth the initial investment of our company [GEM] reserves today?"',
        correctExplanation:
            'Identifying critical variables, which are the ones that change the final result the most, is the mark of a professional financial analyst. It allows for better risk management and more robust planning for various market scenarios.',
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
            'When a Parent company owns 80% of a Subsidiary, what is the remaining 20% called?',
        options: [
          'Non Controlling Interest represents the ownership of investors other than the parent company',
          'Minority Debt Obligations which include all the short term loans from external parties',
          'Owners Equity Surplus reported on the balance sheet after all the dividends paid',
          'Accumulated Retained Earnings kept for future investment in the heavy machinery assets',
        ],
        correctIndex: 0,
        wrongExplanation:
            'It is not considered debt because the company does not owe it back to anyone. It represents the ownership of the other 20% of investors who are not the parent company in this specific group structure.',
        correctExplanation:
            'Non-Controlling Interest ensures that the consolidated balance sheet accurately shows that while the Parent controls the assets, they do not own every single gem of the value. It represents the portion of equity not attributable to parents.',
      ),
      QuizQuestion(
        question: 'How is "Goodwill" calculated in an acquisition?',
        options: [
          'The purchase price minus the fair value of net assets being acquired today',
          'Purchase Price minus the original book value of assets recorded in the past',
          'Total Revenue minus the total operating expenses incurred during the whole fiscal year',
          'The estimated value of the company brand name and its market reputation',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Book Value is just a historical number from the past. You must use Fair Value, which is what the assets are worth today. If you pay [GEM]1,000,000 for [GEM]800,000 in fair assets, you have [GEM]200,000 in Goodwill.',
        correctExplanation:
            'Goodwill represents unidentifiable assets like brand reputation, customer loyalty, and synergistic value that cannot be sold separately. It is the premium paid for the expectation of future earnings above the fair value of identifiable net assets.',
      ),
      QuizQuestion(
        question: 'What is an "Intra-group Transaction" in consolidation?',
        options: [
          'Sales or loans between group members that must be erased during the consolidation',
          'A trade between two different countries involving the physical transport of various goods',
          'A secret deal made with a direct competitor to fix market prices illegally',
          'Buying shares of your own parent company in the open national market',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If you sell a pen to yourself for 100 [GEM], you have not actually made any profit. In group accounting, internal sales must be erased so that only transactions with outside parties are counted in the final reports.',
        correctExplanation:
            'Eliminating these transactions prevents the consolidated group from inflating its revenue numbers by trading with its own companies. This ensures that the financial statements reflect the true economic position of the group as a single entity.',
      ),
      QuizQuestion(
        question: 'What is the "Full Goodwill" method?',
        options: [
          'Recording the goodwill for both the parent share and the non controlling interest',
          'Counting every single asset as goodwill to inflate the total value of group',
          'Spending all your [GEM] on advertising to improve the public image of firm',
          'A way to avoid paying taxes on acquisitions involving multiple foreign entities',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The alternative is the partial goodwill method. Full goodwill provides a more complete picture of what the whole company is worth, including the portion that is not owned by the parent company in the acquisition.',
        correctExplanation:
            'The Full Goodwill method is required under IFRS standards to ensure transparency for all shareholders involved. It reflects the total goodwill of the subsidiary at the date of acquisition, regardless of the percentage of ownership acquired.',
      ),
      QuizQuestion(
        question: 'When does "Impairment of Goodwill" occur?',
        options: [
          'When the fair value of an asset falls below its carrying book amount',
          'When the company pays a large dividend to shareholders from their accumulated profits',
          'When an employee is injured on the site during the normal working hours',
          'When the stock market closes for a holiday and no trading occurs',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Goodwill is never depreciated over time. It is only checked once a year for impairment. If the value you paid for reputation is now worth less than what is on the books, you must record a loss.',
        correctExplanation:
            'Impairment tests are high-stakes events! A massive impairment charge can wipe out a whole year\'s worth of profit and crash the stock price instantly as it signals that a previous acquisition was overvalued or is underperforming.',
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
          'Depreciating the significant parts of a fixed asset separately over their individual lives.',
          'Building a product from many small parts sourced from various global suppliers today.',
          'Selling off pieces of the company to others to raise [GEM] for growth.',
          'Buying parts from different global suppliers to reduce total production costs.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'An airplane might last for 30 years, but the high-performance engine might only last for 10 years. Professionally, you must depreciate the engine faster than the wings to ensure your financial reporting remains accurate and realistic.',
        correctExplanation:
            'This approach provides a much more realistic view of when the company will need to spend massive [GEM] reserves on critical replacements. It aligns the expense recognized in the income statement with the actual pattern of economic benefits.',
      ),
      QuizQuestion(
        question: 'What is "Fair Value Hierarchy" Level 1?',
        options: [
          'Using quoted prices in active markets for identical assets to determine the value',
          'Assets that have no market value at all and are considered completely worthless',
          'Assets that can only be valued by experts using very complex mathematical models',
          'Assets that are owned by the national government for the public good',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Level 1 is considered the gold standard of valuation. You can look at a market screen and see exactly what an asset is worth. Level 3 is the hardest because it requires complex models and many internal guesses.',
        correctExplanation:
            'Regulators strongly prefer Level 1 valuations because they are the hardest for management to manipulate or fake. They provide the most objective evidence of value because they are based on actual, observable market transactions for identical items.',
      ),
      QuizQuestion(
        question: 'Under IFRS, what is the "Revaluation Model"?',
        options: [
          'Regularly adjusting the carrying value of assets up to their fair market value',
          'A way to hide losses from the public eye using complicated accounting methods',
          'Charging more for products to cover the rising operational costs of the business',
          'Changing the name of the company brand to attract new younger customers',
        ],
        correctIndex: 0,
        wrongExplanation:
            'US GAAP usually forbids this, requiring you to stay at historical cost. IFRS allows it, which can make a company\'s balance sheet look much stronger if their land or buildings have increased in value over time.',
        correctExplanation:
            'Any gain from revaluation is usually tucked away in Other Comprehensive Income (OCI) so it does not inflate normal operational profit. This ensures that unrealized gains do not lead to inappropriate dividend payments or executive bonuses.',
      ),
      QuizQuestion(
        question: 'What is "Investment Property" (IAS 40)?',
        options: [
          'Property that is held strictly for rental income or long term capital appreciation',
          'A building where the company holds its regular board meetings and executive retreats',
          'A type of low cost housing for employees who live near the factory',
          'A property owned by the company bank for its own internal use',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If the company works in the building, it is an owner-occupied asset. If they just rent it out to others to earn income, it is an investment property and follows a completely different set of accounting rules.',
        correctExplanation:
            'Investment properties can often be recorded at Fair Value under IFRS, with any [GEM] profit or loss going directly to the income statement every year! This allows the company to show the benefit of rising property values.',
      ),
      QuizQuestion(
        question: 'What is the "Impairment Loss" formula for an asset?',
        options: [
          'Carrying amount minus the recoverable amount of the specific asset being tested',
          'Carrying Amount minus the total Net Income earned by the company during the year',
          'Total Assets minus the Total Group Debt reported on the most recent statements',
          'Purchase Price minus the annual depreciation expense recorded for the current fiscal period',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The Recoverable Amount is the higher of what you could sell the asset for today or the value of the [GEM] it will make you if you keep using it in your business operations over time.',
        correctExplanation:
            'If your factory is on the books for 1 million [GEM] but its recoverable value is only 600,000 [GEM], you must recognize an immediate impairment loss of 400,000 [GEM] to reflect the loss in economic value.',
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
          'External third party evidence is more reliable than information provided by management today',
          'Information provided by the company CEO is considered the most reliable during an audit',
          'All information gathered by a professional auditor is equal regardless of its source today',
          'Photos are the only reliable digital evidence accepted by the national agency',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Management could potentially print a fake bank statement to mislead auditors. A letter sent directly from the independent bank to the auditor is much harder to manipulate or fake during the verification process.',
        correctExplanation:
            'External confirmations, such as those from banks, customers, or suppliers, are the most powerful tools in an auditor\'s arsenal. They provide highly objective and verifiable evidence of the company’s true financial position and account balances.',
      ),
      QuizQuestion(
        question: 'What is "Substantive Testing"?',
        options: [
          'Detailed auditing procedures designed to detect material errors in the financial statement items.',
          'Testing the company indoor air quality to ensure a healthy working environment for staff.',
          'A high level review of the company core mission statement and strategic goals.',
          'Testing how fast employees can finish their daily work in the office.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'This is the intensive digging phase of the audit. You do not just ask if the accounting system works; you check many actual physical receipts to see if the company [GEM] reserves were spent accurately and legally.',
        correctExplanation:
            'Every professional audit must include substantive testing to ensure that the [GEM] values reported on the balance sheet actually exist in reality. It focuses on finding direct evidence of numerical accuracy at the transaction level.',
      ),
      QuizQuestion(
        question: 'What does "Tolerable Error" mean in audit sampling?',
        options: [
          'The maximum error an auditor accepts without the financial statements being materially misstated',
          'The number of minor typos that are allowed in a professional audit report tonight',
          'A specific mistake that the senior CEO is allowed to make every single year',
          'The total amount of [GEM] a company can safely lose each year',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If you check a sample and find one [GEM] missing, is it a systemic problem? Tolerable error is the specific line in the sand the auditor draws before sounding the alarm about potential widespread financial issues.',
        correctExplanation:
            'If the estimated error from your statistical sample is higher than the tolerable error, you must reject the whole account and dig much deeper. It helps auditors manage the risk of not detecting a material misstatement.',
      ),
      QuizQuestion(
        question: 'What is an "Analytical Procedure"?',
        options: [
          'The evaluation of financial information through analysis of relationships among various data sets',
          'A procedure that is performed by a very analytical person with high academic credentials',
          'A type of complex computer hardware repair involving the main corporate servers today now',
          'A way to train new junior auditors in the field of professional accounting',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If the company claims revenue increased by 50% but the factory consumes 10% less electricity, something is wrong. The relationship between operations and financial reports does not make sense to a professional auditor investigating the books.',
        correctExplanation:
            'Analytical procedures help auditors spot issues through smell tests that do not add up before they spend company [GEM] on more expensive and time-consuming testing methods. They identify unusual trends or transactions for further investigation.',
      ),
      QuizQuestion(
        question: 'What is "Inherent Risk"?',
        options: [
          'Susceptibility of an account to material misstatement before considering any related internal controls',
          'The physical risk of a large building catching fire during the hot summer months',
          'The total risk of the lead auditor losing their job due to poor performance',
          'A risk that is strictly required by federal law for all firms',
        ],
        correctIndex: 0,
        wrongExplanation:
            'An inventory worth 100,000,000 [GEM] in small diamonds is inherently much riskier to lose or have stolen than an inventory of concrete pipes. Some accounts are naturally more prone to errors or fraud than others are.',
        correctExplanation:
            'Professional auditors focus most of their time and [GEM] on areas with the highest inherent risk to maximize efficiency. By identifying high-risk areas first, they can design more effective audit procedures to address specific concerns.',
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
          'Interest payments are tax deductible which reduces the true cost of borrowing [GEM].',
          'Because the bank requires it for all corporate loans regardless of the company size.',
          'Because taxes are considered unpaid debt by the national financial regulatory authorities today always.',
          'To make calculation look more professional for the senior executive team.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If you pay 10% interest but get a 30% tax break, your true cost of debt is only 7%. The government is effectively paying 30% of your interest through tax savings.',
        correctExplanation:
            'This tax shield is the primary reason why companies often prefer borrowing [GEM] rather than selling more shares of the company. It effectively lowers the weighted average cost of capital and enhances overall shareholder value.',
      ),
      QuizQuestion(
        question: 'What is the "Market Value Weight" rule for WACC?',
        options: [
          'Weighting capital components by their current market prices instead of their book values.',
          'Weighting physical corporate assets by how much they weigh in kilograms and grams today.',
          'A rule that strictly requires you to trade in the early morning market hours.',
          'Tax on total market value of all assets owned by individuals.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Book value represents the historical past; market value represents the current, present cost of [GEM]. Professional WACC calculations must always use current market prices to stay accurate in today’s financial environment.',
        correctExplanation:
            'If a company has 1M shares at 10 [GEM] and 5M [GEM] in debt, the weights are approximately 66% Equity and 33% Debt. Using market weights ensures the cost of capital reflects current economic reality.',
      ),
      QuizQuestion(
        question: 'What are "Flotation Costs"?',
        options: [
          'The fees paid to professionals for issuing new stocks or bonds to investors.',
          'The total cost of keeping a boat in the harbor during the winter months.',
          'The total [GEM] value lost to inflation every single year in the national economy.',
          'Moving a factory to a new location across the national border.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'New capital is not free to raise for a company. If you want 1,000,000 [GEM], the bank might take 50,000 [GEM] in fees. You only get 950,000 [GEM] net, which increases your overall cost.',
        correctExplanation:
            'Flotation costs are usually included by adjusting the initial investment amount in an NPV model. This ensures that the true cost of raising [GEM] is factored into the decision-making process for new major projects.',
      ),
      QuizQuestion(
        question: 'What is the "Marginal Cost of Capital" (MCC)?',
        options: [
          'The specific cost of raising the next additional [GEM] of capital for projects.',
          'The total cost of the first gem ever borrowed from a commercial banking institution.',
          'The cost of paying for minor office repairs and small administrative expenses every year.',
          'Cost at the margin of error for firms in statistical models.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'As a company borrows more and more [GEM], lenders get more worried and eventually raise the interest rate. The last [GEM] you borrow is almost always more expensive than the first [GEM] you ever borrowed.',
        correctExplanation:
            'The MCC schedule shows that a company\'s cost of capital increases as it tries to grow too fast beyond its current means. Managing this cost is essential for maintaining a healthy balance sheet during expansion.',
      ),
      QuizQuestion(
        question: 'What is "Beta" (β) in the CAPM formula?',
        options: [
          'A measure of how much a stock return fluctuates relative to the market',
          'A type of software beta test conducted before the final product launch to customers',
          'The second best bank in the whole country as ranked by the central agency',
          'The total amount of profit a company makes during the fiscal year',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A Beta of 2.0 means if the market goes up 1%, the stock goes up 2%. If the market drops, it drops twice as fast. It is a fundamental measure of systematic riskiness in the market.',
        correctExplanation:
            'In the CAPM model, the higher the Beta, the more [GEM] investors demand as a return for taking on additional risk. It helps in determining the appropriate required rate of return for an equity investment.',
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
          'Identifying legal contracts with customers where both parties have committed to the obligations.',
          'Calculating the total annual profit of the entire corporation before all taxes and interests.',
          'Sending an invoice immediately today to every customer who visited the store during day.',
          'Counting all warehouse inventory items to determine the total asset counts.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'You cannot record a single gem of revenue until you have a valid, legal contract where both sides are committed to the deal. This prevents premature revenue recognition before a transaction is truly official and agreed.',
        correctExplanation:
            'This foundational step ensures that revenue is only recognized when a real transaction has actually been agreed upon between two parties. It establishes the legal basis for all subsequent steps in the revenue recognition process.',
      ),
      QuizQuestion(
        question: 'What is a "Performance Obligation" (PO)?',
        options: [
          'A promise in a contract to transfer a distinct good or service.',
          'The requirement for all employees to wear specific uniforms at work during their shifts.',
          'A type of musical show performed by employees for the senior management team today.',
          'The total amount of [GEM] office rent costs for the corporation.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If you sell a phone and a one-year service plan together, you have two distinct performance obligations. You must split the [GEM] between them and recognize the revenue at different times as each promise is fulfilled.',
        correctExplanation:
            'Identifying distinct performance obligations prevents companies from front-loading revenue for services they have not yet provided to customers. It ensures that income matches the actual delivery of goods or services over the contract term.',
      ),
      QuizQuestion(
        question: 'What is "Variable Consideration"?',
        options: [
          'Uncertain portions of the transaction price such as bonuses or potential vendor rebates.',
          'Being nice to different types of customers during a professional business meeting today always.',
          'Buying different types of company assets using the available corporate cash reserves tonight now.',
          'A changing tax rate from the state based on the location.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If you might get a [GEM]10,000 bonus for finishing early, you can only record it if it is highly probable to happen. You cannot be an optimist in professional accounting because it leads to misleading statements.',
        correctExplanation:
            'Companies must estimate variable [GEM] using either the expected value or the most likely amount method. This ensures that the revenue reported reflects the amount the company expects to be entitled to receive eventually.',
      ),
      QuizQuestion(
        question: 'When is revenue recognized for a "Point in Time" sale?',
        options: [
          'Revenue is recognized when control of the promised asset is transferred to customers.',
          'When the customer pays the final [GEM] for the goods they have received today.',
          'Daily for the entire life of the product regardless of the actual delivery date.',
          'Last day of the current fiscal year for all corporate transactions.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'It is not strictly about when the [GEM] are paid; it is about who has control. If you have the item but have not paid yet, the store might still be able to record the revenue.',
        correctExplanation:
            'Transfer of control includes having the legal right to payment, holding the legal title, and possessing the physical asset. It reflects the moment when the risks and rewards of ownership pass from seller to buyer.',
      ),
      QuizQuestion(
        question: 'What is "Revenue Over Time" (Percentage of Completion)?',
        options: [
          'Recognizing revenue systematically as the work is performed over a period of time.',
          'Revenue that is only recorded after ten years of continuous service to the client.',
          'Subtracting revenue from the total group expenses incurred during the current reporting cycle now.',
          'Way to delay paying your corporate taxes to the national government.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If you spend three years building a large stadium, you do not wait until the final year to record any revenue. You record a piece of it as you lay each [GEM] brick during construction.',
        correctExplanation:
            'This method matches the effort with the reward, giving a much better picture of the company\'s annual progress on long-term projects. It provides stakeholders with more timely information about current performance and contract status.',
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
          'Risk that exchange rates will change before a specific [GEM] payment is completed.',
          'The risk of the bank being closed due to a sudden technical failure today.',
          'The risk of the building losing value over a long period of time always.',
          'Tax on every single transaction made by the corporate bank account.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If you buy a car for 100 Euros today but pay in 30 days, and the Error gets 50% more expensive, you lose [GEM] in real terms. This is a specific transaction risk that affects cash flow.',
        correctExplanation:
            'Transaction exposure is "Realized"—it affects the actual [GEM] leaving your bank account. Managing it requires hedging strategies like forward contracts to lock in exchange rates and protect future cash flows from volatility.',
      ),
      QuizQuestion(
        question: 'What is "Translation Exposure" (Accounting Exposure)?',
        options: [
          'Exchange risk when converting the financial statements of a foreign subsidiary to base.',
          'The total cost of hiring a professional translator for an international business meeting today.',
          'Translating documents for a professional audit conducted by the national financial regulatory agency always.',
          'A sudden change in company brand name for the global market.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'This is often purely "On Paper" and does not immediately affect cash flow. The company hasn\'t actually lost [GEM] yet, but their balance sheet looks significantly smaller because of unfavorable exchange rates during consolidation.',
        correctExplanation:
            'While it may not affect cash flow today, translation exposure can affect a company\'s credit rating and stock price perceptions. Investors look at consolidated results, so a weak local currency can make a global giant look weak.',
      ),
      QuizQuestion(
        question: 'What is "Economic Exposure" (Operating Exposure)?',
        options: [
          'Risk that exchange rate fluctuations will affect the long term competitive market position.',
          'When the whole economy goes into a deep recession due to poor fiscal policies.',
          'A tax on the country total wealth applied to every citizen and corporate entity.',
          'The cost of running a large factory in an overseas location.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'This is the deepest risk. If your currency becomes too "Strong," no one overseas can afford your products, and you go broke over several years as your competitive edge in the global market is slowly eroded.',
        correctExplanation:
            'Economic exposure is hard to measure but vital for "Strategic" planning in global companies. It requires moving production to different countries or changing suppliers to ensure long-term profitability despite currency fluctuations in the market.',
      ),
      QuizQuestion(
        question: 'What is a "Money Market Hedge"?',
        options: [
          'Using domestic and foreign borrowing arrangements to lock in the future exchange rates.',
          'Buying many stocks in different countries to diversify the total corporate investment portfolio today.',
          'A way to get free interest from the national government every single year now.',
          'Buying a physical fence for the bank to improve vault security.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If you are owed 100 Euros, you borrow 90 Euros today, convert them to [GEM]s, and invest them. You use the 100 Euros you get later to pay back the loan, effectively removing any currency risk.',
        correctExplanation:
            'Money market hedges are a professional alternative to Forward contracts, often used when banks charge too much for Forwards. They allow a company to create a synthetic forward position using the domestic and foreign interest rate difference.',
      ),
      QuizQuestion(
        question: 'What is "Netting" in global treasury management?',
        options: [
          'Combining internal cash flows between subsidiaries to pay only the net difference today',
          'Catching fish for the company cafeteria to reduce the total food costs for employees',
          'A tax on the total revenue earned by every single subsidiary within the group',
          'A way to hide [GEM] from the professional auditor during the annual review',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If Sub A owes Sub B 100 [GEM], and Sub B owes Sub A 80 [GEM], they only send 20 [GEM]. This saves massive amounts in bank transaction fees and reduces foreign exchange exposure for the overall group.',
        correctExplanation:
            'Large global "whales" use netting to run their entire world empire using the smallest possible amount of liquid [GEM]. It simplifies cash management and allows central treasurers to have better control over the group’s total liquidity.',
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
          'Forwards are customized private contracts while Futures are traded on an organized exchange.',
          'Forwards are only for the future while futures are only for the past events.',
          'Futures are much cheaper for the company to use for their initial hedging strategy.',
          'Forwards are illegal for small businesses in the national financial system.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'In a Forward, you and the bank agree on any specific amount and date. In a Future, you must buy exactly one standard "Contract" on a fixed date, such as 2,500 bushels of corn or a fixed amount of currency.',
        correctExplanation:
            'Because Futures are traded on an organized exchange, they are much more "Liquid" and easier to sell than private Forward contracts. This allows investors to exit their positions quickly if the market moves against them unexpectedly.',
      ),
      QuizQuestion(
        question: 'What is "Marking-to-Market" in futures trading?',
        options: [
          'The daily settlement of profits and losses in futures trading accounts every night.',
          'Painting the exchange building to improve the public image of the financial district today.',
          'A way to choose which stocks to buy based on the recent market trends.',
          'Tax on the total number of trades made during the year.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'You do not wait until the contract expires. If you lose 100 [GEM] today, the exchange takes that 100 [GEM] from your account tonight. If you run out of [GEM] reserves, your position is immediately liquidated by the broker.',
        correctExplanation:
            'Daily settling prevents "Default Risk" by ensuring that every losing party has enough [GEM] to pay their losses every single day. This maintenance of credit integrity is what makes futures markets so robust and globally trusted.',
      ),
      QuizQuestion(
        question: 'What is a "Maintenance Margin"?',
        options: [
          'The minimum [GEM] amount required to be kept in the trading account today.',
          'The cost of repairing the office and maintaining the hardware used for professional trades.',
          'A type of insurance for professional traders who work in the global markets daily.',
          'Profit made by a bank on a trade conducted for client.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If your account drops below this level, you get a "Margin Call." You must add more [GEM] immediately to reach the initial margin level, or your professional position will be closed at a loss by the exchange.',
        correctExplanation:
            'Margins allow traders to use "Leverage," controlling large amounts of assets with a relatively small amount of actual [GEM]s. This magnifies both potential profits and potential losses, making margin management a critical skill for any trader.',
      ),
      QuizQuestion(
        question: 'What does "Contango" mean in the futures market?',
        options: [
          'When the futures price is higher than the current spot price of asset.',
          'A type of dance for executive teams to celebrate the end of fiscal year.',
          'When the market is closed for a holiday and no trading activity occurs today.',
          'Way to save on total trading fees charged by the exchange.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If you want corn in 6 months, it usually costs more than corn today because of the "Cost of Carry," which includes storage and interest. This upward-sloping price curve is considered a normal and healthy market condition.',
        correctExplanation:
            'The opposite of Contango is "Backwardation," which usually happens during a sudden shortage when people need goods or [GEM] right now. In such cases, the spot price is significantly higher than the future delivery price.',
      ),
      QuizQuestion(
        question: 'What is an "Option Premium"?',
        options: [
          'The non-refundable price paid by the option buyer to the seller today.',
          'The highest price a stock ever reached in the history of the global market.',
          'A reward for being a good junior investor who consistently follows the market rules.',
          'Tax on the profit from an option trade made during year.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Options are true "Wasting Assets." Every night while you sleep, an option loses some [GEM] in value simply because time has passed. This is the "Time Decay" that all option buyers must overcome to make a profit.',
        correctExplanation:
            'Professional "Sellers" of options earn their [GEM] by consistently harvesting this Theta decay from people who buy options for speculation or hedging. They act like the "House" in a casino, benefiting from the unavoidable passage of time.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q11',
    title: 'Advanced Working Capital',
    subtitle: 'The [GEM]Operating Cycle Math',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'How do you calculate the "Operating Cycle"?',
        options: [
          'The sum of inventory days and receivable days used for the corporate operating cycle.',
          'The result of dividing total annual sales by the average total assets today always.',
          'Subtracting all operating expenses from the total annual revenue earned during the whole year.',
          'The total amount of debt divided by the total equity owners.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'It is the total time from buying a raw [GEM] to getting the final [GEM] from the customer. If inventory takes 60 days and customers take 30 days to pay, your cycle is 90 days. This does not account for payment to suppliers.',
        correctExplanation:
            'Successful companies try to shrink this cycle as much as possible to keep their [GEM] working instead of sitting on a shelf. A shorter operating cycle improves liquidity and allows the business to reinvest cash into new opportunities faster.',
      ),
      QuizQuestion(
        question: 'What is the "Cash Conversion Cycle" (CCC)?',
        options: [
          'The total operating cycle minus the number of annual payable days from suppliers today.',
          'The total amount of [GEM] currently held in the company cash accounts today always.',
          'The total annual net profit divided by three hundred sixty five days of year.',
          'A specific way to turn gold into [GEM] for the company.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'CCC is the "Gap" where your [GEM] are gone. If you take 90 days to sell/get paid but pay your own suppliers in 30 days, you are effectively "Out of [GEM]" for 60 days and need external financing.',
        correctExplanation:
            'Negative CCC is the "Holy Grail" of finance. Companies like Amazon get paid by customers before they ever pay their own suppliers, which means they are essentially using other people\'s [GEM] to fund their own growth for free.',
      ),
      QuizQuestion(
        question: 'What is "Factoring" in working capital?',
        options: [
          'Selling company accounts receivable to a third party for immediate liquid [GEM] reserves.',
          'Choosing the best possible factory to use in production across various global regions today.',
          'A professional way to calculate the total cost of a new product for users.',
          'Hiring new employees to count [GEM] coins in the vault nightly.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If a customer owes you 1,000 [GEM] in 90 days, you sell that debt to a bank for 950 [GEM] today. You lose 50 [GEM] in fees but get your [GEM] now to keep the business running smoothly.',
        correctExplanation:
            'Factoring is common for fast-growing small businesses that cannot afford to wait for slow-paying customers to settle their bills. It provides an immediate injection of liquidity at the expense of a small portion of the total invoice value.',
      ),
      QuizQuestion(
        question: 'What is the "Economic Order Quantity" (EOQ)?',
        options: [
          'The optimal order size that minimizes total inventory holding and ordering costs today always.',
          'The total amount of [GEM] the national government orders for the public during year.',
          'The total number of orders a company makes annually to all its various suppliers.',
          'A tax on size of order for the large corporate factory.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Buying too much costs [GEM] in storage and insurance. Buying too little costs [GEM] in frequent shipping fees and potential stockouts. EOQ is the perfect "Sweet Spot" in the middle that minimizes the sum of both costs.',
        correctExplanation:
            'Professional supply chain managers use the EOQ formula to ensure the absolute [GEM] efficiency of the warehouse. It balances the cost of placing an order against the various costs of holding inventory over a specific period of time.',
      ),
      QuizQuestion(
        question: 'What is "Just-In-Time" (JIT) Inventory?',
        options: [
          'A strategy of receiving goods only as they are needed for the production process.',
          'Delivering various finished products just before the store closes for the whole day today.',
          'Buying diverse stock index funds at the very last minute of the trading day.',
          'Paying your national taxes exactly on due date for the firm.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'JIT is very efficient but also very "Fragile." If a single truck is late, the whole factory stops immediately. However, it saves the company millions in storage costs and prevents inventory from becoming obsolete or damaged.',
        correctExplanation:
            'JIT was pioneered by Toyota and is now a standard for professional manufacturing worldwide. It requires extremely strong relationships with suppliers and highly reliable logistics systems to ensure that materials arrive exactly when they are needed on the line.',
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
          'A framework for maximizing return for a given level of risk in portfolios.',
          'Investing all your available company funds only in a single tech stock today now.',
          'A theory that all stocks in the market are equal regardless of performance now.',
          'A specific way to predict future price of [GEM] for investors.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'MPT proved that you cannot look at a stock "alone" in isolation. You must look at how its risk "interacts" with other stocks in the portfolio folder to understand the total impact on the risk-return profile.',
        correctExplanation:
            'MPT led directly to the invention of passive Index Funds and the core professional idea of wide-scale diversification. It revolutionized how both individual and institutional investors approach the construction of their investment portfolios for long-term growth.',
      ),
      QuizQuestion(
        question: 'What is the "Efficient Frontier"?',
        options: [
          'Set of optimal portfolios that offer the highest return for each risk level.',
          'The physical border of a country with a very good and strong economy tonight.',
          'A list of the fastest growing companies in the entire country for this year.',
          'The total amount of [GEM] a bank holds in its reserve.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If your portfolio is "below" the frontier line, you are effectively being a "Sucker"—you are taking much more risk than you need to for the specific level of return you are currently getting from those assets.',
        correctExplanation:
            'Professional portfolio managers use advanced software to ensure they are always positioned "On the Frontier" of efficiency. This optimization process involves constantly rebalancing assets to maintain the best possible risk-adjusted performance over time.',
      ),
      QuizQuestion(
        question: 'What does the "Efficient Market Hypothesis" (EMH) claim?',
        options: [
          'Claims that asset prices reflect all available information in the global financial markets.',
          'Every single market is equally efficient regardless of the location or the specific size.',
          'Gems are the most efficient currency for use in the modern national economy today.',
          'Computers will soon do all the trading work for the companies.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If EMH is 100% true, trying to pick "winners" in the stock market is a complete waste of time. You should just buy a whole market index fund and go to the beach to enjoy your life.',
        correctExplanation:
            'EMH has three distinct forms: Weak, Semi-Strong, and Strong, depending on what types of information are believed to be already "priced in." It remains one of the most debated and studied concepts in modern finance and economics.',
      ),
      QuizQuestion(
        question: 'What is "Arbitrage Pricing Theory" (APT)?',
        options: [
          'A multi-factor asset pricing model considering many different systemic risk factors in market.',
          'A specific way to set the price of a physical product for consumers today.',
          'The total cost of trading [GEM] on an international exchange during the whole year.',
          'Theory that arbitrage is illegal in states for all the firms.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The standard CAPM model only uses one Beta (market risk). APT uses many different ones (like Inflation Beta, GDP Beta, and Interest Rate Beta) to be much more accurate in different economic environments.',
        correctExplanation:
            'APT is favored by professional "Quants" who build complex [GEM] algorithms to find a subtle market edge over competitors. It provides a more nuanced view of the multiple systemic risks that can affect an asset’s price.',
      ),
      QuizQuestion(
        question: 'What is the "Sharpe Ratio"?',
        options: [
          'A measure of excess return per unit of total portfolio risk or volatility.',
          'The total profit made by the large company during this current fiscal reporting year.',
          'The total amount of [GEM] spent on annual legal fees for the corporate firm.',
          'The number of people who own a single stock today now.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A high Sharpe ratio means you are getting a lot of [GEM] profit for every "heart attack" the market volatility gives you. It is the best measure of a professional investment manager\'s true skill over time.',
        correctExplanation:
            'Comparing two managers by return alone is fundamentally wrong in finance. You must divide their excess return by their risk to find the Sharpe Ratio. This allows for a fair comparison of performance regardless of risk levels.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q13',
    title: 'Internal Controls & COSO',
    subtitle: 'The [GEM]Ethics of Business',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What are the three components of the "Fraud Triangle"?',
        options: [
          'The core components of fraud including pressure, opportunity, and the final rationalization.',
          'A combination of greed, fear, and general laziness found in many large offices.',
          'Assets, liabilities, and equity reported on the official company paper using annual data.',
          'The roles of the CEO, CFO, and the professional external auditor.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A person only steals if: 1) They need [GEM] (Pressure), 2) No one is watching (Opportunity), and 3) They tell themselves "I\'ll pay it back" (Rationalization). All three must usually be present for professional fraud to occur.',
        correctExplanation:
            'Good management focuses primarily on removing the "Opportunity" through strong internal controls to prevent fraud before it starts. By implementing systems that make theft difficult or obvious, the company protects its [GEM] assets from bad actors.',
      ),
      QuizQuestion(
        question: 'What is "Segregation of Duties" (SoD)?',
        options: [
          'Internal control requiring multiple independent people for a single important business process.',
          'Giving everyone different tasks in the building to ensure they stay busy long.',
          'Making sure that everyone has their own private office within the large building.',
          'A way to hire many more employees for the corporate company.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If the same person writes the checks and also signs them, they can steal [GEM]billions easily without being caught. You must split these "Keys to the Vault" between different employees to ensure that collusion is required for theft.',
        correctExplanation:
            'SoD is the #1 internal control recommended by professional auditors and risk managers worldwide. It ensures that the responsibilities for authorizing transactions, recording them, and handling the related assets are separated to provide a checks-and-balances system.',
      ),
      QuizQuestion(
        question: 'What is the "COSO Framework"?',
        options: [
          'A globally recognized and standard blueprint for implementing effective internal business controls.',
          'A type of software for financial accounting used by the large global corporations.',
          'A new set of laws from the federal government regarding national security measures.',
          'A special club for financial professionals in the global market.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'It is not a law; it is a "Blueprint" for building a healthy company. It ensures the "Control Environment" (the management culture) is strong and that risks are identified and managed effectively to protect the company’s [GEM] reserves.',
        correctExplanation:
            'Most public companies use COSO to prove to their shareholders and regulators that their [GEM] and reporting processes are safe and reliable. It provides a common language and structure for discussing and implementing internal control systems.',
      ),
      QuizQuestion(
        question: 'What is an "IT General Control" (ITGC)?',
        options: [
          'Controls over user passwords, data backups, and general network security for companies.',
          'A large button that turns off all the computers in the entire building.',
          'The total cost of buying new computers for all the senior staff members.',
          'Hiring more people to fix the printers in the office.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If a hacker can change the spreadsheet values, the accounting reports are worth zero. ITGCs are the "Foundation" of digital financial truth in a modern business where almost all [GEM] transactions are recorded and stored electronically today.',
        correctExplanation:
            'Auditors now spend a huge part of their time checking server rooms, network security, and password policies. These controls ensure that the underlying systems that process financial data are secure, reliable, and working correctly as intended.',
      ),
      QuizQuestion(
        question: 'What is a "Whistleblower Policy"?',
        options: [
          'A formal system to report fraud or ethics violations without any fear.',
          'A specific rule that bans all loud noises in the office site today.',
          'A way to reward employees for working very hard on their daily tasks.',
          'A type of insurance policy for the head company CEO.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Most fraud is found by "Tips" from honest employees, not by professional auditors. A safe, anonymous reporting system is vital for keeping the company [GEM]s safe from internal threats and unethical behavior by high-level management members.',
        correctExplanation:
            'Under laws like Sarbanes-Oxley, public companies are REQUIRED to have a formal way for people to report fraud privately. This encourages a culture of integrity and helps identify problems early before they become catastrophic for the business.',
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
          'Dividend model assuming constant growth of dividends forever for the very stable global firms.',
          'Calculating how fast a company\'s employees grow each year during the whole fiscal cycle.',
          'A specific way to predict the next economic recession in the national central market.',
          'The total cost of a company debt during this year today.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'GGM says: Value = D1 / (k - g). It is perfect for "Boring" stable companies that pay steady dividends every year. However, it fails for high-growth firms where the growth rate (g) is higher than the required return (k).',
        correctExplanation:
            'Professional analysts use GGM as a baseline to see if a stable company is fairly priced compared to its expected [GEM] payout. It assumes that a company will continue to grow at a sustainable rate indefinitely into the future.',
      ),
      QuizQuestion(
        question: 'What is an "EV/EBITDA" multiple used to compare?',
        options: [
          'Enterprise Value relative to operational [GEM] cash flows produced by the core business today.',
          'The size of two different buildings on the office site measured in square meters.',
          'How many products a company sells in a year across all its global locations.',
          'The amount of taxes paid by the two companies today now.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Price/Earnings (P/E) can be significantly "distorted" by high debt levels. EV/EBITDA is "Capital Structure Neutral"—it allows you to compare a debt-heavy company to a cash-rich one fairly based on their actual business operations.',
        correctExplanation:
            'EV/EBITDA is the #1 multiple used by Wall Street for valuing businesses for sale or merger. It provides a clearer picture of the company’s ability to generate cash from its core business before accounting for financing and tax variables.',
      ),
      QuizQuestion(
        question: 'What is a "Control Premium" in valuation?',
        options: [
          'The extra price paid to acquire the controlling shares of a specific target company.',
          'The total cost of hiring a new security guard team for the office building.',
          'A tax on the company\'s annual net profits applied by the national government authorities.',
          'A reward for the CEO staying for ten years tonight.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If a stock is 10 [GEM], you might pay 13 [GEM] to buy the WHOLE company. That 3 [GEM] (30%) is the price of "Power"—the right to fire the board and change the strategic direction of the business.',
        correctExplanation:
            'Calculating the control premium is a vital skill for mergers and acquisitions (M&A) professionals. It represents the value of being able to control the [GEM] cash flows and strategic decisions of the target entity as a whole.',
      ),
      QuizQuestion(
        question: 'What is "Asset-Based Valuation"?',
        options: [
          'Totaling the fair value of all assets minus the total liabilities of the company.',
          'Valuing a company based on its building materials like steel and concrete used today.',
          'A way to choose which stocks to buy on Monday for the investment team.',
          'The total revenue of a company in one cycle tonight.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'This is used for "Liquidating" companies or holding companies. It ignores future profit potential and simply asks: "If we sold everything today, how many [GEM] would we have left after paying all our debts to creditors?"',
        correctExplanation:
            'Asset valuation provides the "Floor" price for a business—a healthy company should rarely sell for less than its net assets. It is most useful for companies with significant tangible property, machinery, or investment holdings in their portfolio.',
      ),
      QuizQuestion(
        question: 'What is "Discount for Lack of Marketability" (DLOM)?',
        options: [
          'Reduces the value of shares that are not easily sold publicly in the markets.',
          'A discount on products that are not selling well in the local retail market.',
          'A tax on properties in very rural regions of the country during fiscal year.',
          'The cost of advertising a business to users today now.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If you own 10% of a private "Mom & Pop" store, you cannot sell it in 1 second like a public stock. Professionals "Discount" the value by 15-30% because your [GEM] are "Trapped" in an illiquid investment.',
        correctExplanation:
            'DLOM is a critical adjustment in the valuation of private businesses and family-owned firms. It reflects the extra risk and cost that an investor faces when they cannot easily convert their ownership into [GEM] cash on demand.',
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
          'A lease recorded on the balance sheet as a ROU asset and liability.',
          'A lease for a company car package given to every senior department manager.',
          'When you rent a building for one single day only during the summer.',
          'A secret contract between two global companies in the national economy.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'In the old days, companies hid billions of [GEM] in debt by "Renting" airplanes instead of buying them. Now, those rental agreements MUST be shown as debt on the balance sheet, providing more transparency for all stakeholders in the market.',
        correctExplanation:
            'IFRS 16 brought massive transparency to the global financial market, forcing companies to admit their true long-term [GEM] obligations. It ensures that any significant right to use an asset is reflected as both an asset and a financial obligation.',
      ),
      QuizQuestion(
        question: 'Why might a company choose to LEASE instead of BUY?',
        options: [
          'Companies choose to lease to avoid obsolescence and preserve their liquid [GEM] funds.',
          'Because they do not like owning anything in the entire country today always.',
          'To hide the physical assets from the national government team during an audit.',
          'Because it is always cheaper than buying assets now today always.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If technology changes every 2 years, buying is a very poor strategic move. Leasing lets you "Trade In" for the newest model easily, ensuring your business stays competitive without wasting [GEM] on machines that will soon be worthless.',
        correctExplanation:
            'Leasing is primarily a "Financing" decision, often used to help a company grow its operations without using all its cash reserves at once. It can also provide tax advantages depending on the local jurisdiction’s specific accounting rules.',
      ),
      QuizQuestion(
        question: 'What is the "NAL" (Net Advantage to Leasing)?',
        options: [
          'A formula used for comparing the NPV of leasing versus buying an asset.',
          'The total number of people who rent versus buy physical properties globally tonight.',
          'The total annual profit from a rental agreement for the large corporate firm.',
          'Insurance for the leased equipment in the office site today now.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If the NAL calculation results in a POSITIVE number, it means that the company should lean towards leasing the asset. It factors in tax shields, depreciation benefits, and the [GEM] cost of borrowing to buy the asset outright.',
        correctExplanation:
            'Professional CFOs run detailed NAL models for every major piece of equipment or real estate a company needs to acquire. This ensures that the capital allocation decision is based on objective mathematical analysis of the net cash flows.',
      ),
      QuizQuestion(
        question: 'What is a "Sale and Leaseback" transaction?',
        options: [
          'Selling an asset to a bank and then immediately leasing it back today.',
          'Selling a product and buying it back later during the next fiscal year.',
          'A way to avoid paying rent in the long run for the company.',
          'Trading old assets for new ones on the office site now.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'This is a clever way to unlock "Dead Gems" that are currently trapped in a building. You get 100M [GEM] in cash today to invest in business growth, and simply pay rent every month to continue using the building.',
        correctExplanation:
            'Leasebacks are very common when a company is growing fast but needs more liquid cash for its daily operations or new investments. It allows a firm to monetize its fixed assets while maintaining uninterrupted use of the facilities.',
      ),
      QuizQuestion(
        question: 'What is a "Finance Lease" (Capital Lease)?',
        options: [
          'A lease contract where the tenant takes all the risks and the rewards.',
          'A lease for a commercial bank to use as a professional office space.',
          'When the head CEO rents a car for a weekend in the country.',
          'A type of low-interest loan for corporate employees in the firm.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Even if the legal contract says "Rent," if you use the asset for 95% of its useful life, it is treated as a purchase. You are effectively paying off a loan to own the asset, so the [GEM] must be reported correctly.',
        correctExplanation:
            'Finance leases are considered "Debt" in every way that matters to professional financial analysts and creditors. They represent a long-term commitment that has a direct impact on the company’s solvency and future cash flow requirements.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q16',
    title: 'International Finance Parity',
    subtitle: 'The [GEM]Math of Global Markets',
    difficulty: QuizDifficulty.medium,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What does "Interest Rate Parity" (IRP) state?',
        options: [
          'Interest rate differentials between countries equal the gap between forward and spot rates.',
          'Financial experts believe that all global interest rates must eventually become identical over time.',
          'High nominal interest rates in developing nations will always lead to zero inflation immediately.',
          'Central banks maintain identical interest rates across all existing types of borders.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If [GEM]s earn 10% in India and 2% in the US, IRP says the Indian Rupee MUST get cheaper in the future to prevent people from getting "Free Money" easily. This adjustment ensures that the total return is balanced across different currencies and markets.',
        correctExplanation:
            'IRP is the fundamental force that prevents "Risk-Free" arbitrage across international borders. It ensures that the forward exchange rate of a currency reflects the difference in interest rates between the two countries, maintaining a fair global equilibrium.',
      ),
      QuizQuestion(
        question: 'What is "Purchasing Power Parity" (PPP)?',
        options: [
          'Exchange rates adjust so that identical goods cost the same in every nation.',
          'A comprehensive global list of the richest people living in the world today.',
          'A specific tax applied solely to buying products from overseas at the site.',
          'Total power a CEO holds over the entire global management team.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The "Big Mac Index" is a famous example. If a burger is [GEM]5 in NY but [GEM]2 in London, PPP theory says the Pound is "Underpriced" and will eventually go up in value as the market corrects the imbalance over time.',
        correctExplanation:
            'While it rarely works perfectly in the short term, PPP remains one of the best professional tools for "Long-Term" Forex prediction. It helps economists understand which currencies are overvalued or undervalued based on the actual cost of living.',
      ),
      QuizQuestion(
        question: 'What is the "International Fisher Effect"?',
        options: [
          'Nominal interest rates reflect differences in expected inflation between different global countries.',
          'A specific set of international rules that all global banks must follow today.',
          'The total amount of liquid assets currently circulating in the entire modern world.',
          'Way to catch more fish for sale in local neighborhood markets.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If a bank pays 15% interest, it usually means everybody expects 10-12% inflation in that country. You aren\'t actually getting much "richer" [GEM]-wise; you are just being compensated for the loss in the currency\'s purchasing power over the next year.',
        correctExplanation:
            'Professional investors look at the "Real" interest rates (Nominal minus Inflation) to decide where to move their [GEM] capital. This helps them identify countries where they can achieve true economic growth rather than just inflationary gains.',
      ),
      QuizQuestion(
        question: 'What is a "Currency Swap"?',
        options: [
          'Contract exchanging interest and principal payments in different currencies over a duration.',
          'Trading one specific type of coin for another at a local retail shop.',
          'A type of illegal gamble occurring with [GEM] on a street corner in city.',
          'Way to hide your true nationality while you are traveling abroad.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If a US company needs Euros and a German company needs [GEM], they "Swap" loans with each other. This can significantly lower the interest costs and Forex risk for both sides by matching their currency needs and borrowing strengths.',
        correctExplanation:
            'Large global "Whales" use currency swaps to manage their [GEM] billion-dollar global debt portfolios efficiently. It allows them to convert debt into a different currency without having to go through the expensive and volatile spot markets.',
      ),
      QuizQuestion(
        question: 'What is "Country Risk"?',
        options: [
          'Political or economic risk impacting investments within a specific global geographic territory.',
          'The specific risk of a country losing a sports match during competition.',
          'A tax on international flights traveling to a specific region or country.',
          'Risk of traveling to a new foreign place for your vacation.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Even if a company is great, if the country\'s government suddenly takes away all their factories, your investment is worth zero. This is known as "Expropriation Risk," and it is a major factor when investing in developing nations today.',
        correctExplanation:
            'Professional investors demand a significant "Risk Premium" (more [GEM]) for putting their wealth into countries with unstable governments. This extra return compensates them for the possibility of civil unrest, sudden law changes, or economic collapses.',
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
          'Leading digits in natural financial datasets are not distributed uniformly across reports.',
          'A specific law that requires all professional auditors to wear dark formal suits.',
          'A simple way for bank managers to calculate interest rates on a loan.',
          'Rule that prevents people from stealing any local [GEM] project funds.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If a human makes up fake [GEM] receipts, they naturally use digits "1" through "9" equally. However, in nature, "1" is the leader 30% of the time, while "9" only 5%. A computer can instantly spot this "unnatural" human-made pattern.',
        correctExplanation:
            'Benford\'s Law is a powerful digital tool for finding hidden patterns of fraud in millions of transactions. It is used by investigators to identify which vendor accounts or expense reports deserve a much deeper manual inspection.',
      ),
      QuizQuestion(
        question: 'What is "Window Dressing"?',
        options: [
          'Financial accounts looking better than they actually are at each fiscal year-end.',
          'Cleaning the office windows before a big audit is conducted by the team.',
          'A type of marketing show for new products offered by the company today.',
          'Selling more products to customers on site during every holiday weekend.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'A company might pay off its total debt on Dec 31st and then borrow the [GEM] back on Jan 1st just to show "Zero Debt" on its published annual report. This is highly misleading and can result in severe penalties if uncovered.',
        correctExplanation:
            'Forensic auditors look for "Large suspicious transactions" that occur right before and after the fiscal year ends. They trace these [GEM] flows to ensure that the financial statements represent the underlying economic reality of the business fairly.',
      ),
      QuizQuestion(
        question: 'What is "Lapping" in accounts receivable fraud?',
        options: [
          'Using Customer B funds to cover a Customer A theft in accounts.',
          'Running multiple laps around the office for fitness during the lunch break hour.',
          'A specific way to calculate the cost of a product for sale today.',
          'Type of bank insurance created for small businesses in the city.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'The thief must keep a secret book of who they stole from every day. They have to keep "lapping" new payments forever to stay ahead of the audit, creating a complex web of lies that eventually collapses under its own weight.',
        correctExplanation:
            'Forcing every employee to take a one-week mandatory vacation is the #1 way to catch lapping fraud. When the thief is gone, the "juggling" stops, and Customer A suddenly complains that their paid [GEM] haven\'t been credited to their account.',
      ),
      QuizQuestion(
        question: 'What is a "Bribe" under the FCPA?',
        options: [
          'Gifts or money given to foreign officials to win new global business.',
          'A small tip for a professional waiter in a restaurant after a meal.',
          'Buying a birthday gift for a close friend during the holiday season today.',
          'Standard cost of doing business today in the local national markets.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'It does not matter if it is considered "legal" or "normal" in the foreign country. If a US company pays a bribe, it can face billions of [GEM] in fines and prison time. The law focuses on the intent to gain an unfair advantage.',
        correctExplanation:
            'The Foreign Corrupt Practices Act (FCPA) is the "World Cop" of business ethics, ensuring that companies compete based on the quality and price of their products rather than the size of their illegal [GEM] payments to officials.',
      ),
      QuizQuestion(
        question: 'What is an "Audit Trail"?',
        options: [
          'Step-by-step record of a transaction from the beginning to the final end.',
          'A path in the woods near the office site for employee exercise today.',
          'A list of all the employees in the company today for the payroll.',
          'Total profit made by the company during this entire fiscal year.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If you see a total of 100,000 [GEM] on the final report, but there is no record of where it came from or who authorized it, that is a "Broken Trail" and a major warning sign of potential embezzlement or fraud.',
        correctExplanation:
            'Maintaining a secure and unalterable audit trail is a strict legal requirement for all public companies. It allows auditors to trace every [GEM] from the final balance sheet all the way back to the original source document or digital log.',
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
          'Financial, Customer, Process, and Learning and Growth perspectives for global management.',
          'Past, Present, Future, and CEO perspective for the entire company board members.',
          'Assets, Liabilities, Equity, and Revenue now for the company in the fiscal year.',
          'Sales, Marketing, HR, and IT departments for the large business.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Being "Rich" (Financial) today isn\'t enough for long-term survival. If your customers hate you and your staff is quitting (Learning & Growth), you will be "Poor" [GEM]-wise tomorrow regardless of your current bank balance.',
        correctExplanation:
            'The scorecard ensures management does not sacrifice the future of the company for short-term [GEM] gains. It provides a holistic view of performance, linking day-to-day operations with the long-term strategic goals and vision of the organization.',
      ),
      QuizQuestion(
        question: 'What is "Activity-Based Costing" (ABC)?',
        options: [
          'Allocating overhead based on consumed activities rather than using simple volume metrics.',
          'Counting how many activities employees do daily for the management to review today.',
          'A specific way to choose which stocks to buy on Friday for profit.',
          'Total cost of running a website for users in the country.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Old accounting might say: "Every product pays 10% for rent." ABC says: "Product A uses 50 hours of machine time, so it should pay more for the factory [GEM] costs than Product B which uses only 5 hours."',
        correctExplanation:
            'ABC reveals which products are truly profitable and which ones are "stealing" [GEM] from others by consuming more resources than they are being charged for. This allows managers to make better pricing and production decisions based on real data.',
      ),
      QuizQuestion(
        question: 'What is a "Value Chain Analysis"?',
        options: [
          'Examining steps to create value or save [GEM] during the whole production.',
          'Looking at the chain on the company\'s front door for the security team.',
          'A setup of rules for competitive global markets used by all the companies.',
          'Way to calculate interest rates on a bank loan for customers.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Does our shipping create value? Does our packaging? If a step does not make the customer more "Happy" or the product "Better," it should be cut to save precious [GEM] resources and improve the overall efficiency of the business.',
        correctExplanation:
            'Mastering the value chain is how companies like Apple or Amazon stay ahead of all their competitors. They optimize every link in the chain—from raw material sourcing to final delivery—to maximize the value delivered to the end consumer.',
      ),
      QuizQuestion(
        question: 'What is "Kaizen" Costing?',
        options: [
          'Japanese philosophy of "Continuous Improvement" involving all employees in the corporate organization.',
          'A type of food in the company cafeteria today for all the employees.',
          'A tax on high-profit companies in the region during the fiscal year ends.',
          'Rule that limits how much you can sell each year today.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'You do not wait for a miracle or a huge breakthrough. You aim to save 1 cent today, half a cent tomorrow. Over a million [GEM] transactions, this tiny daily progress adds up to a massive and sustainable competitive advantage.',
        correctExplanation:
            'Kaizen requires "Everyone" in the building to be actively involved in saving [GEM]s and improving quality. It creates a culture where every employee is an innovator looking for ways to reduce waste and improve the manufacturing or service process.',
      ),
      QuizQuestion(
        question: 'What is "Total Quality Management" (TQM)?',
        options: [
          'Quality is the goal for every employee in the entire corporate organization.',
          'Managing the total number of employees in a lab for the research projects.',
          'A rule that prevents bad products in the market for all the consumers.',
          'Type of software test for the dev team in the office.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Quality isn\'t checked at the end by an inspector. It is built in starting from the very first [GEM] brick. It turns out, doing it right the first time is actually much CHEAPER than fixing expensive mistakes after the product is finished.',
        correctExplanation:
            'TQM companies have higher customer loyalty and spend far fewer [GEM] on repairs, refunds, and warranty claims. It is a long-term commitment to excellence that permeates every level of the organization and every interaction with the customer.',
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
        question: 'What is a "Step Acquisition" (Achieved in Stages)?',
        options: [
          'Increasing ownership to a controlling share through steps of purchasing firm\'s equity.',
          'Buying the building next door to the office site for the expansion plans.',
          'A tax on buying more shares in the market during the fiscal year.',
          'Way to pay for a company in monthly steps today.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'You do not just add the new cost to the old one. You must "Revalue" your old non-controlling interest to its current Fair Market Value today and record a significant [GEM] profit or loss before you can begin the consolidation process.',
        correctExplanation:
            'Step acquisitions require professional "Remeasurement" of all previously held equity interests at their current fair value. This ensured that the consolidated financial statements reflect the true value of the entire entity at the date control was actually achieved.',
      ),
      QuizQuestion(
        question: 'What is the "Current Rate Method" for translation?',
        options: [
          'Translating Balance Sheet at year-end and Income Statement using average exchange rates.',
          'Charging customers the current interest rate for the loans they have taken today.',
          'A way to avoid using any foreign currency now during the global trade.',
          'Using the exchange rate from the founding day of the company.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'This method is used when the subsidiary is "Independent" and operates in its own local environment. Any [GEM] gains or losses from translation are reported in the Cumulative Translation Adjustment (CTA) within the equity section of the balance sheet.',
        correctExplanation:
            'The Current Rate method ensures that the subsidiary\'s key financial ratios, such as the current ratio, remain the same after translation as they were in the local currency. This provides a more accurate view of the subsidiary’s local performance for the group.',
      ),
      QuizQuestion(
        question: 'What is "Temporal Method" translation?',
        options: [
          'Translating monetary items at current rate and non-monetary items at historical rates.',
          'A temporary way to count [GEM] in a bank for the daily reports.',
          'A tax on temporary companies in the state durante the entire fiscal year.',
          'Trading [GEM] only during certain times of year in city.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'This is used for "Dependent" subsidiaries that are effectively an extension of the parent. Any [GEM] translation gains or losses go directly to the Income Statement, which can create significant volatility in the parent\'s reported net profit.',
        correctExplanation:
            'Professional accountants choose between the Current and Temporal methods based on the "Functional Currency" of the subsidiary. The Temporal method is designed to reflect the subsidiary’s transactions as if they had been carried out by the parent company itself.',
      ),
      QuizQuestion(
        question: 'What is a "Bargain Purchase" (Negative Goodwill)?',
        options: [
          'Buying a company for less than fair value of its net assets.',
          'Buying a product on sale at a local store during the weekend holiday.',
          'A secret deal with a local building supplier for the construction project now.',
          'Company that is going bankrupt very fast in the country.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'This is the opposite of Goodwill and usually occurs in "Fire Sales" or distressed situations. If a company has 100M [GEM] in net assets but you only pay 80M [GEM], you effectively "made" an immediate 20M [GEM] profit on the acquisition date.',
        correctExplanation:
            'Auditors check bargain purchases very strictly to ensure that the fair values of the acquired assets haven\'t been overvalued and that all liabilities have been correctly identified. Any gain from a bargain purchase is recognized immediately in the income statement.',
      ),
      QuizQuestion(
        question: 'What is "Equity Method" vs "Consolidation"?',
        options: [
          'Equity records share of profit; Consolidation adds together all assets and liabilities.',
          'One is only used for very small businesses in the local city market.',
          'A way to hide total debt from the public team during audits today.',
          'One means selling the company for assets in local market.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If you own 30%, you do not put their factory on your balance sheet. You just increase your initial [GEM] investment by 30% of their annual profit and decrease it by any dividends you receive during the period.',
        correctExplanation:
            'Distinguishing between "Significant Influence" and "Full Control" is the foundation of professional group reporting standards. The Equity method reflects your economic interest in the associate, while Consolidation reflects your control over the entire subsidiary’s resources.',
      ),
    ],
  ),
  QuizMetadata(
    id: 'l5_q20',
    title: 'Advanced Derivatives Strategy',
    subtitle: 'The [GEM]Delta \u0026 Gamma Professional',
    difficulty: QuizDifficulty.hard,
    requiredLevel: 5,
    questions: [
      QuizQuestion(
        question: 'What is "Delta Neutral" hedging?',
        options: [
          'Creating a portfolio where value doesn\'t change with small underlying price moves.',
          'A way to stay neutral in a political debate now during the elections.',
          'Buying equal amounts of every stock in the market for the balanced fund.',
          'Hedge made with zero [GEM] initial investment in the bank.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If your stock goes up 1 [GEM], your offsetting option position might go down 1 [GEM]. You are effectively "Immune" to small price swings, protecting your capital from the noise of daily market fluctuations in the short term.',
        correctExplanation:
            'Banks and professional Market Makers use Delta Neutral strategies to earn [GEM] from the "Bid-Ask Spreads" without caring about where the underlying stock price goes. They constantly rebalance their positions to maintain this neutrality as prices move.',
      ),
      QuizQuestion(
        question: 'What is "Gamma" in option Greeks?',
        options: [
          'Greek letter representing the rate of change in Delta as price moves.',
          'A type of radiation used in a hospital lab for the medical tests.',
          'A tax on huge profits made in a single trade during the year.',
          'Third best option available in the market for the investor.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'If Delta is considered "Speed," then Gamma is "Acceleration." If Gamma is high, your Delta (and thus your risk) can change very fast, requiring you to trade more [GEM] and frequently to stay properly hedged against market moves.',
        correctExplanation:
            'Gamma risk is what often causes professional "Hedgers" to panic and buy or sell rapidly during sudden market crashes. Understanding and managing Gamma is crucial for anyone maintaining a Delta-hedged portfolio in a volatile market environment.',
      ),
      QuizQuestion(
        question: 'What is a "Bull Call Spread"?',
        options: [
          'Bullish strategy involving buying one Call and selling another higher strike.',
          'A type of farm animal found in the rural area during the summer.',
          'A way to borrow [GEM] from a bull at low cost for business.',
          'Telling everyone a stock is certainly going up in market.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'You pay less [GEM] for the overall trade, but you also cap your maximum potential profit. It is a "Cost-Efficient" professional way to bet on a stock going up while strictly limiting the initial capital you have at risk.',
        correctExplanation:
            'Spreads are the basic "building blocks" of professional CAIA-level trading strategies. They allow investors to customize their risk-return profile based on their specific market outlook and the amount of [GEM] they are willing to risk.',
      ),
      QuizQuestion(
        question: 'What is "Theta" decay?',
        options: [
          'Gradual loss in option value as the expiration date gets closer today.',
          'A type of brain wave found in deep sleep for the medical research.',
          'A tax on holding stocks for too long in one account today.',
          'Way to make [GEM] slowly over many cycles for profit.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Options are true "Wasting Assets." Every night while you sleep, an option loses some [GEM] in value simply because time has passed. This is the "Time Decay" that all option buyers must overcome to make a profit.',
        correctExplanation:
            'Professional "Sellers" of options earn their [GEM] by consistently harvesting this Theta decay from people who buy options for speculation or hedging. They act like the "House" in a casino, benefiting from the unavoidable passage of time.',
      ),
      QuizQuestion(
        question: 'What is "Value at Risk" (VaR)?',
        options: [
          'Estimating maximum potential loss over time with a specific statistical confidence level.',
          'The total amount of [GEM] the company owns now in the bank accounts.',
          'A list of the riskiest stocks in the whole country for the investors.',
          'Way to calculate interest on a large bank loan today.',
        ],
        correctIndex: 0,
        wrongExplanation:
            'VaR says: "There is a 95% chance we will not lose more than 1M [GEM] today." It helps CEOs sleep at night by quantifying risk, but it can fail catastrophically during extreme "Black Swan" events that fall outside normal distributions.',
        correctExplanation:
            'VaR is the universal standard risk reporting tool for every major investment bank, hedge fund, and pension fund in the world. It provides a single, easy-to-understand [GEM] number that summarizes the total risk exposure of a complex portfolio.',
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
