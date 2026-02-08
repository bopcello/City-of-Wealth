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
            'When you save, you set aside some money instead of spending it now. This helps you have money ready for a rainy day or big goals.',
      ),
      QuizQuestion(
        question: 'What is a bank?',
        options: ['A place for money', 'A restaurant', 'A school', 'A park'],
        correctIndex: 0,
        wrongExplanation:
            'A bank is not a place to eat food, go to school, or play in the park. It is a building meant for financial security only.',
        correctExplanation:
            'A bank is a very safe place where you can keep your money. They help protect your savings from being lost or stolen at your home.',
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
            'Income is the money you receive for doing a job or chore. It is the reward for your hard work and helps you buy what you.',
      ),
      QuizQuestion(
        question: 'What is a coin?',
        options: ['Paper money', 'Metal money', 'A toy', 'A snack'],
        correctIndex: 1,
        wrongExplanation:
            'A coin is not made of paper, and it is definitely not a toy or a tasty snack to eat. It is a solid financial tool.',
        correctExplanation:
            'Coins are small, round pieces of metal used as money. They come in different values like pennies and quarters to help you pay for small items.',
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
            'Needs are not just things for fun, expensive items, or gifts from friends. They are the most important things you require to stay healthy and.',
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
            'A plan for your money is not a game you play or a simple box you keep. It is a smart way to track your spending.',
        correctExplanation:
            'A budget is a plan that shows how you will spend and save your money. It helps you make sure you have enough for your needs.',
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
            'Spending is not about keeping your money for later or finding coins on the ground. It is the act of using your cash to get.',
        correctExplanation:
            'Spending happens when you give your money to a store in exchange for something you want or need. It is how you buy your daily.',
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
            'Saving is not for showing off to others or hiding your money away. It is also definitely not meant for losing your hard-earned cash by.',
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
        options: ['A math test', 'Something to save for', 'A secret', 'A game'],
        correctIndex: 1,
        wrongExplanation:
            'A savings goal is not a math test, a secret you keep, or a game you play. It is a target for your own money.',
        correctExplanation:
            'A savings goal is a specific thing you are saving your money to buy, like a new bike. It helps you stay focused on your.',
      ),
      QuizQuestion(
        question: 'Why use a safe place?',
        options: ['To hide it', 'To show off', 'To keep it safe', 'To be mean'],
        correctIndex: 2,
        wrongExplanation:
            'Safe places are not for hiding from people or showing off how much you have. They are also not meant for being mean to your friends.',
        correctExplanation:
            'Using a safe place like a bank or a strong box keeps your money from getting lost. It gives you peace of mind about your.',
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
          'A specific money target',
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
          'An impossible task',
          'A secret dream',
          'Goal reached within a year',
        ],
        correctIndex: 3,
        wrongExplanation:
            'Short-term goals are not distant plans for twenty years from now or impossible dreams. They are realistic targets that you can reach in a short time.',
        correctExplanation:
            'A short-term goal is something you want to achieve very soon, usually within a year. Saving for a video game is a great example of this.',
      ),
      QuizQuestion(
        question: 'What is a long-term goal?',
        options: [
          'Goal for next week',
          'Something easy',
          'Goal many years away',
          'A daily task',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Long-term goals are not simple tasks you finish in a week or daily chores. They require a lot of time, patience, and many years of saving.',
        correctExplanation:
            'A long-term goal is a major target that takes several years to reach. Saving for college or buying a house are common examples of long-term goals.',
      ),
      QuizQuestion(
        question: 'How do you track goals?',
        options: [
          'Forget them',
          'Write them down',
          'Change them daily',
          'Keep them secret',
        ],
        correctIndex: 1,
        wrongExplanation:
            'If you forget your goals, change them every day, or keep them totally secret, you might lose focus. You need to see your progress to succeed.',
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
            'Withdrawal does not mean adding more money to your account, losing cash by mistake, or finding a dollar on the street. It is a planned action.',
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
            'Price comparison helps you find which store offers the lowest price for the same item. Using your phone to check prices can save you many dollars.',
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
        question: 'What should you do with private info?',
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
            'If a deal seems too good to be true, it is likely a scam. You should always be careful and ask an adult before spending your.',
      ),
      QuizQuestion(
        question: 'What is "Phishing"?',
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
            'Spending every dollar you earn, losing your wallet often, or ignoring price tags are bad habits. These actions will prevent you from ever becoming financially stable.',
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
            'Tracking your spending is not done to be bored, waste paper, or make you feel bad. It is a tool for understanding your own financial.',
        correctExplanation:
            'Tracking spending helps you see exactly how you use your money each day. This lets you find small things you can cut back on to.',
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
            'Delayed gratification is not about buying things immediately, getting angry, or just being late. It is about having the patience to wait for a bigger.',
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
            'Social media, random strangers, or refusing to ask anyone can lead to poor choices. Most people online do not have your best interest in mind at.',
        correctExplanation:
            'You should always ask trusted adults like your parents or teachers for money advice. They have more experience and can help you make very smart.',
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
            'Video games, expensive designer shoes, and new toys are all things we want. They are fun to have but your body does not require them to.',
        correctExplanation:
            'Healthy food is a need because your body must have it to stay strong and alive. You should always buy your needs before spending on.',
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
            'A movie ticket is a want because it is for entertainment only. You can live a happy life without seeing every new movie at the.',
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
            'You should always pay for your needs first, like rent and food. Once your needs are met, you can decide how much for your other.',
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
            'Saying a phone is always a need or always a want is not quite correct. It really depends on how the phone is being used every.',
        correctExplanation:
            'A phone can be a need for safety and work, but an expensive new model is a want. It is important to know the difference.',
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
            'Flipping a coin, buying both when you don\'t have the money, or guessing are poor choices. You should think about what will truly make you.',
        correctExplanation:
            'When picking between wants, choose the thing that adds the most value to your life. Think about which one you will use and enjoy the.',
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
        question: 'What is a piggy bank?',
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
            'You should try to save a little bit of money every single time you receive some. Consistent saving is the best way to reach your.',
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
            'This rule is not a math test, a phone number, or a secret code. It is a simple way for adults and kids to manage.',
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
            'Spending more money than you earn is a very big mistake. This leads to debt and makes it impossible for you to save for the.',
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
            'Late fees are never fun and they are certainly not gifts to you. While they help banks make money, they are a total waste for.',
        correctExplanation:
            'Late fees are extra charges you pay when you miss a deadline. Avoiding them keeps more of your own money in your pocket for your.',
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
            'Thinking that spending is better or that it doesn\'t matter will lead to trouble. Everyone, including kids, should have some money set aside for the.',
        correctExplanation:
            'Yes, it is risky to have no savings because unexpected problems always happen. An emergency fund keeps you safe when you need to buy something.',
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
            'Losing a receipt won\'t close the store or send you to jail, but it is still a mistake. You must keep records of what you.',
        correctExplanation:
            'If you lose your receipt, most stores will not let you return an item. Keeping your receipts safe is a very important habit for smart.',
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
            'You are the only person responsible for your own money and how you spend it. Being accountable helps you make smarter choices for your own bright.',
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
            'Obligations are not fun parties, free gifts from your family, or shiny new toys. They are serious weights that you must carry until they are finally.',
        correctExplanation:
            'A financial obligation is a promise to pay money for something, like a bill or a loan. You must fulfill these promises to keep a good.',
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
            'Financial records are not meant for wasting time, using up extra ink, or showing off to others. They are tools for managing your own personal.',
        correctExplanation:
            'Keeping records helps you see where every dollar goes and prevents you from losing track. This makes it much easier to plan for your future.',
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
            'Integrity means being honest with your money and others, even when nobody is watching. Honest people are trusted more in the business world and at.',
      ),
      QuizQuestion(
        question: 'How do you fix a money mistake?',
        options: ['Hide it', 'Give up', 'Learn and fix it', 'Blame others'],
        correctIndex: 2,
        wrongExplanation:
            'Hiding your errors, giving up completely, or blaming other people will never solve the problem. These actions will only make your difficult situation much worse than.',
        correctExplanation:
            'The best way to fix a mistake is to admit it and learn how to do better next time. Finding a solution now prevents bigger problems.',
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
          'Finding a dollar',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Spending all your cash or having no money at all means your budget is not balanced. Finding a random dollar also does not create a budget.',
        correctExplanation:
            'A balanced budget means the money you spend is not more than the money you earn. This balance ensures you do not fall into expensive debt.',
      ),
      QuizQuestion(
        question: 'What is a "fixed expense"?',
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
        question: 'What is a "variable expense"?',
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
            'Using a tool helps you organize your spending and see where you can save. It makes the math easier so you don\'t have to remember.',
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
            'Digital wallets are not metal boxes, video games, or just any website. They are specialized apps designed to store your payment information safely on your.',
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
            'Checks are not meant for being slow, drawing pictures, or throwing away. They are formal documents used for sending money safely when you don\'t have.',
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
            'Purchasing power is not physical strength, the cost of a single car, or just having a job. It is about what your money can actually.',
        correctExplanation:
            'Purchasing power is the amount of goods and services that one dollar can buy. When prices go up, your purchasing power starts to go down.',
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
            'Scarcity is not about having too much of something, being scared of the dark, or a fruit. It is a fundamental rule about limited global.',
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
            'Bartering is not using cash, saving coins in a bank, or just working hard. It is an ancient way to get things without using any.',
        correctExplanation:
            'Bartering is trading one thing you have for something someone else has. For example, you might trade a shiny apple for a tasty pear at.',
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
            'Prices do not stay the same forever, and they certainly don\'t change by magic or by accident. They follow very specific rules of the national.',
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
            'A charity is not a store that sells items for profit, a bank, or a type of food. It is a group with a special.',
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
            'Donating means giving your money, time, or items to help others without expecting anything back. It is a kind way to support your local.',
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
            'You should not give money just to be famous or cool. While you do lose that money, the goal is not to be poor but.',
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
        question: 'How much should you give?',
        options: ['Everything', 'Nothing', 'What you can afford', 'Only \$100'],
        correctIndex: 2,
        wrongExplanation:
            'Giving everything you own is not wise, and giving nothing is not helpful. You should also not feel pressured to give a specific large.',
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
          'What you give up',
          'The price of a toy',
          'A bank fee',
          'Total savings',
        ],
        correctIndex: 0,
        wrongExplanation:
            'Opportunity cost is not the sticker price, a bank fee, or your total savings. It is a hidden cost that every person faces when choosing.',
        correctExplanation:
            'Opportunity cost is the thing you give up when you make a choice. If you spend money on a movie, you give up the snack.',
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
            'Guessing or buying immediately are poor ways to handle your money. While friends can help, you need to think for yourself about the true.',
        correctExplanation:
            'To analyze a purchase, you should think about how much it costs and how much value it brings. This helps you avoid wasting your hard-earned.',
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
            'Risk is the chance that you might lose money or gain money on a choice. Smart people study the risks before they ever invest their.',
      ),
      QuizQuestion(
        question: 'Why wait before a big buy?',
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
            'Waiting 24 hours before a big purchase helps you avoid making a choice based on emotions. This simple rule can save you from big money.',
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
            'A trade-off is not a car, a secret, or a discount. It is a decision where you must choose between two things you really.',
        correctExplanation:
            'A trade-off is when you give up one thing to get something else you want more. Life and money are full of these important.',
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
            'Peer pressure is not a math tool, a type of gas, or a gym class. It is a social force that can hurt your wallet.',
        correctExplanation:
            'Peer pressure is when you feel like you must buy something because your friends have it. It is important to make choices based on.',
      ),
      QuizQuestion(
        question: 'How do ads try to trick you?',
        options: [
          'They tell only facts',
          'They give free toys',
          'They use emotional appeal',
          'They don\'t',
        ],
        correctIndex: 2,
        wrongExplanation:
            'Ads rarely tell just the plain facts and they don\'t usually give away free things. Most ads are designed to make you feel a specific.',
        correctExplanation:
            'Advertisements often use music and happy people to make you feel like you need their product. Knowing their tricks helps you shop logic over.',
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
            'Consumerism is not a plant, a bank, or a sport. It is a way that society thinks about buying and owning many new.',
        correctExplanation:
            'Consumerism is the idea that buying more things will make you happier. However, true happiness usually comes from experiences and relationships, not from more.',
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
            'Brand names are not always better quality and they are definitely not cheaper or magic. You are often paying extra just for the popular.',
        correctExplanation:
            'A brand name often costs more because of the company\'s reputation and advertising. Sometimes the same product without the name brand is much cheaper for.',
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

List<QuizMetadata> _getAllQuizzes() {
  return [..._level1Quizzes, ..._mediumQuizzes, ..._hardQuizzes];
}
