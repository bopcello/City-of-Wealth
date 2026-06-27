import 'dart:math';
import '../game_state.dart';

class NotificationData {
  static final _random = Random();

  // Pick a random element from a list
  static T _randomElement<T>(List<T> list) =>
      list[_random.nextInt(list.length)];

  // Helper to replace placeholders
  static String _format(String template, Map<String, String> placeholders) {
    String result = template;
    placeholders.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }

  static const List<(String, String)> dailyGeneral = [
    ("Your city kept moving", "Passive income doesn't take days off."),
    (
      "Quiet day, real progress",
      "Compounding works best when nobody's watching.",
    ),
    ("Cha-ching, {name}", "Today's income cycle just landed."),
    (
      "Nothing dramatic today",
      "Which is exactly what a healthy portfolio looks like.",
    ),
    ("Your assets showed up to work", "Even when you didn't open the app."),
    (
      "Small numbers, big pattern",
      "This is what compounding looks like in slow motion.",
    ),
    (
      "Stability check: passed",
      "Your city held steady — that's harder than it looks.",
    ),
    ("{name}, the curve is bending", "Slow growth is still growth."),
    ("Still richer than yesterday", "Not flashy. Still true."),
    (
      "Your strategy is holding",
      "No news is good news in a balanced portfolio.",
    ),
    ("Foundations: solid", "Expansion gets safer every day you wait it out."),
    ("Patience, {name}", "Wealth rewards the people who don't panic."),
    ("No emergencies today", "Sometimes the win is just nothing going wrong."),
    ("Assets working the night shift", "Your income streams don't clock out."),
    (
      "Another quiet win banked",
      "These add up faster than they feel like they do.",
    ),
    ("Your city trusts your plan", "Don't go changing it on a whim."),
    (
      "Ready for today's move, {name}?",
      "One good decision compounds for years.",
    ),
    ("The system is learning", "So is every player who sticks with it."),
    ("Cash flow: steady", "For now. Markets don't stay quiet forever."),
    ("Momentum is building", "You'll feel it before you can prove it."),
  ];

  static const Map<DisasterType, List<(String, String)>> disasterInsured = {
    DisasterType.flood: [
      (
        "Flood warning — but you're covered",
        "Your policy absorbed the damage. Smart planning paid off.",
      ),
      ("Rising waters, {name}", "Flood insurance just did its job."),
      (
        "Aqua alert: contained",
        "Coverage kicked in before the damage could spread.",
      ),
      (
        "Heavy rain hit your sectors",
        "Your flood policy took the financial hit instead of you.",
      ),
      (
        "Storm passed, city intact",
        "This is exactly why you paid that premium.",
      ),
    ],
    DisasterType.fire: [
      (
        "Fire contained, {name}",
        "Insurance covered the rebuild. Crisis averted.",
      ),
      (
        "Smoke clears over your city",
        "Your fire policy just earned its premium back.",
      ),
      (
        "Blaze alert: handled",
        "Coverage stepped in before losses could stack up.",
      ),
      (
        "A spark turned into a claim",
        "Not a crisis — that's what insurance is for.",
      ),
      (
        "Flames out, finances intact",
        "Recovery's already underway, fully covered.",
      ),
    ],
    DisasterType.earthquake: [
      (
        "Tremor felt, structures held",
        "Earthquake coverage absorbed the repair costs.",
      ),
      (
        "Ground shook, {name}",
        "Your policy kept the foundations — and your budget — standing.",
      ),
      (
        "Seismic shock: insured",
        "No collapse, no crisis. Coverage handled it.",
      ),
      (
        "The city swayed, didn't fall",
        "Earthquake insurance just justified itself.",
      ),
      ("Quake hit, repairs covered", "This is the calm version of a bad day."),
    ],
    DisasterType.economyCrash: [
      (
        "Market dipped hard",
        "Portfolio insurance kept your income streams flowing.",
      ),
      (
        "Downturn detected, {name}",
        "Your hedge just did exactly what it's supposed to.",
      ),
      ("Bear market, steady hands", "Financial insurance absorbed the shock."),
      (
        "Recession alert: cushioned",
        "Smart diversification kept the damage contained.",
      ),
      (
        "Crash hit the headlines, not your city",
        "Coverage kept cash flowing through the dip.",
      ),
    ],
    DisasterType.drought: [
      (
        "Dry spell, steady yield",
        "Agricultural coverage kept your income from drying up too.",
      ),
      ("Drought warning, {name}", "Your policy offset the lost production."),
      ("Water scarcity, income stable", "This is what crop insurance is for."),
      (
        "Fields dried, plans didn't",
        "Coverage kept the dry spell from becoming a crisis.",
      ),
      (
        "Long dry season, short-term hit",
        "Insurance smoothed out what the weather couldn't.",
      ),
    ],
    DisasterType.landslide: [
      (
        "Terrain shifted, plans held",
        "Your coverage absorbed the clearing costs.",
      ),
      ("Landslide alert, {name}", "Geological insurance just paid for itself."),
      (
        "Mudslide hit the expansion zone",
        "Coverage kept rebuilding costs off your books.",
      ),
      (
        "Slopes gave way, finances didn't",
        "This is the upside of being over-prepared.",
      ),
      (
        "Debris cleared, budget intact",
        "Insurance handled what gravity couldn't.",
      ),
    ],
    DisasterType.massEmigration: [
      (
        "Citizens relocated, revenue held",
        "Your coverage offset the population dip.",
      ),
      (
        "An emigration wave hit, {name}",
        "Insurance cushioned the drop in tax revenue.",
      ),
      (
        "Population shift, income steady",
        "This is what demographic coverage is for.",
      ),
      (
        "People moved out, plans stayed put",
        "Coverage absorbed the revenue gap.",
      ),
      ("Exodus alert: contained", "Your safety net just did its job."),
    ],
    DisasterType.pandemic: [
      (
        "Outbreak contained, operations steady",
        "Business interruption coverage kept things running.",
      ),
      (
        "Health crisis hit, {name}",
        "Your workforce policy minimized the disruption.",
      ),
      (
        "Cases rose, output barely dipped",
        "This is why you insured the workforce.",
      ),
      (
        "Pandemic declared, plans intact",
        "Coverage absorbed the productivity hit.",
      ),
      (
        "Virus spread, income didn't",
        "Smart call insuring the workforce early.",
      ),
    ],
  };

  static const Map<DisasterType, List<(String, String)>> disasterUninsured = {
    DisasterType.flood: [
      (
        "Flood hit hard, {name}",
        "No coverage found — the damage is all yours this time.",
      ),
      (
        "Water swept through unprotected sectors",
        "Lesson learned the expensive way.",
      ),
      (
        "Rising water, no safety net",
        "Flood insurance would've softened this one.",
      ),
      (
        "Submerged and uninsured",
        "Worth considering coverage before the next storm.",
      ),
      (
        "Heavy rain, heavy losses",
        "This is the cost of skipping flood insurance.",
      ),
    ],
    DisasterType.fire: [
      (
        "Fire spread fast, {name}",
        "No policy in place — losses are full price.",
      ),
      (
        "Assets burned, none recovered",
        "Fire insurance exists for days exactly like this.",
      ),
      ("Smoke cleared, damage didn't", "Uninsured losses hit different."),
      (
        "Blaze hit unprotected structures",
        "A policy would've caught most of this.",
      ),
      (
        "Ash where assets used to be",
        "Next fire, coverage might be worth the premium.",
      ),
    ],
    DisasterType.earthquake: [
      (
        "Ground shook, structures crumbled",
        "No earthquake coverage to absorb it, {name}.",
      ),
      (
        "Tremor hit hard",
        "Unprotected buildings rarely survive seismic shocks.",
      ),
      (
        "Quake damage: full cost",
        "This is what skipping insurance looks like.",
      ),
      (
        "Rubble where buildings stood",
        "Earthquake coverage would've changed this outcome.",
      ),
      (
        "Seismic hit, no cushion",
        "Repairs are coming out of pocket this time.",
      ),
    ],
    DisasterType.economyCrash: [
      ("Market crashed, no hedge", "Your income took the full hit, {name}."),
      (
        "Downturn hit unprotected portfolios hardest",
        "No financial insurance means no buffer.",
      ),
      (
        "Bear market, exposed position",
        "This is the risk of skipping a hedge.",
      ),
      (
        "Recession hit your revenue directly",
        "Diversified portfolios fared better today.",
      ),
      ("Crash hit, cash flow followed", "Worth revisiting your risk coverage."),
    ],
    DisasterType.drought: [
      (
        "Drought dried up more than fields",
        "No agricultural coverage means no cushion, {name}.",
      ),
      ("Dry spell, dry returns", "Crop insurance would've offset this."),
      ("Water scarcity hit yield hard", "Uninsured drought losses are steep."),
      (
        "Fields failed, income followed",
        "This is what skipping crop coverage costs.",
      ),
      (
        "Long dry season, short on cushion",
        "Insurance might be worth it before next season.",
      ),
    ],
    DisasterType.landslide: [
      (
        "Landslide hit unprotected zones",
        "Full repair cost lands on you, {name}.",
      ),
      (
        "Mudslide damage: uninsured",
        "Geological coverage would've absorbed this.",
      ),
      (
        "Slopes collapsed, budget followed",
        "Worth insuring expansion zones next time.",
      ),
      (
        "Debris blocked roads, blocked recovery too",
        "No coverage means slower rebuilding.",
      ),
      (
        "Terrain failed, finances felt it",
        "This is the cost of going uninsured.",
      ),
    ],
    DisasterType.massEmigration: [
      (
        "Citizens left, revenue followed",
        "No coverage to soften the population drop, {name}.",
      ),
      (
        "Emigration wave hit hard",
        "Unprotected demographic shifts hurt the most.",
      ),
      (
        "Empty offices, empty buffer",
        "This is what skipping coverage looks like.",
      ),
      (
        "Population dropped, tax base followed",
        "Insurance might've eased this transition.",
      ),
      (
        "Exodus hit your bottom line",
        "Worth considering coverage before the next shift.",
      ),
    ],
    DisasterType.pandemic: [
      (
        "Outbreak hit operations hard",
        "No business interruption coverage, {name}.",
      ),
      (
        "Workforce sidelined, output too",
        "Uninsured pandemics cost more than the premium would've.",
      ),
      (
        "Cases rose, production fell",
        "This is the price of skipping workforce coverage.",
      ),
      (
        "Pandemic declared, plans paused",
        "Coverage would've kept things running.",
      ),
      (
        "Virus spread, so did the losses",
        "Worth insuring the workforce before next time.",
      ),
    ],
  };

  static const List<(String, String)> debtNotifications = [
    (
      "Debt is compounding, {name}",
      "Interest doesn't pause just because you're busy.",
    ),
    (
      "Cash flow getting tight",
      "Expenses are outpacing income — time to rebalance.",
    ),
    ("Interest is stacking up", "The longer it sits, the more it costs."),
    ("Are you overleveraged?", "Risk is starting to outweigh reward here."),
    (
      "Debt is dragging on growth",
      "A little discipline now saves a lot later.",
    ),
  ];

  static const List<(String, String)> foreclosureNotifications = [
    (
      "{building} has been foreclosed",
      "Unpaid debt caught up with you, {name}.",
    ),
    (
      "A building was seized",
      "{building} is gone — interest finally outran your income.",
    ),
    (
      "Foreclosure hit your city",
      "{building} was auctioned off to cover the debt.",
    ),
    (
      "{building}: repossessed",
      "Debt limits were exceeded, and the bank took notice.",
    ),
    (
      "Liquidation notice for {name}",
      "{building} was seized after interest went unpaid too long.",
    ),
  ];

  static const Map<String, List<(String, String)>> inactivityNotifications = {
    "2d": [
      ("Your city's still here", "Running quietly without you, {name}."),
      ("Two days, zero check-ins", "Your assets have been on autopilot."),
      ("Quick peek?", "Your city's been making moves without you."),
      ("Cash flow's piling up", "Might be worth a look, {name}."),
      ("Your city's waiting on a decision", "No rush — but it's waiting."),
    ],
    "3d": [
      ("Three days of silence", "Your city has no new direction, {name}."),
      ("Where've you been?", "Your strategy's been stalling for 3 days."),
      ("Decisions are piling up", "Your city needs a steer."),
      ("Still compounding, still waiting", "Come check your yield, {name}."),
      ("Things have gone quiet", "Three days without a move."),
    ],
    "5d": [
      ("Growth's slowing down", "Your city could use some direction, {name}."),
      ("Five days, empty streets", "The economy's starting to stagnate."),
      ("Don't stall now", "Your passive income is just sitting there."),
      (
        "Your empire needs a hand",
        "Five days is a while in compounding terms.",
      ),
      ("Leadership vacancy", "Your city's been running on fumes."),
    ],
    "1w": [
      ("A week of silence, {name}", "Your city's drifting without direction."),
      (
        "Your buildings are gathering dust",
        "One week away — time for a comeback.",
      ),
      ("Your empire's been waiting", "Don't lose the momentum you built."),
      ("Active management needed", "It's been a week, {name}."),
      (
        "Remember the plan?",
        "A week ago you were building wealth. Let's pick it back up.",
      ),
    ],
    "2w": [
      ("Decay's setting in", "Nothing compounds on neglect, {name}."),
      ("Two weeks away", "Your city's sliding toward stagnation."),
      ("Your citizens are restless", "14 days without leadership."),
      ("Time's not on your side here", "Don't let two weeks of work fade."),
      ("Your assets need attention", "They've been asking for a while."),
    ],
    "1m": [
      (
        "It's been a month, {name}",
        "Your city remembers when you used to show up.",
      ),
      ("One month offline", "Is this where the story ends?"),
      ("A forgotten empire?", "Your city's gone quiet — bring it back."),
      ("Your legacy's fading", "A month of inactivity will do that."),
      ("Reset or resume?", "Your city's still waiting for you to decide."),
    ],
  };

  static const List<(String, String)> newQuizNotifications = [
    (
      "Today's challenge is live",
      "A new Daily Financial Challenge is ready, {name}.",
    ),
    ("Your quiz is up", "Test today's financial knowledge and bank some KP."),
    (
      "Ready to earn KP, {name}?",
      "Solve today's challenge and grow your city.",
    ),
    (
      "Daily Challenge: active",
      "Don't miss today's quiz — knowledge compounds too.",
    ),
    ("Quick financial workout?", "Today's quiz is live, {name}."),
  ];

  static const List<(String, String)> morningQuizNotifications = [
    ("Good morning, {name} ☀️", "Today's quiz is ready — answer it for KP."),
    (
      "Rise and check your city ☕",
      "Start the day by sharpening your financial knowledge.",
    ),
    ("New day, new quiz", "Keep the streak going, {name}."),
    ("Your morning quiz is here", "Earn KP early and expand your city today."),
    ("Wakey wakey ⏰", "Today's challenge is ready when you are, {name}."),
  ];

  static const Map<String, List<(String, String)>>
  challengeReminderWithRevival = {
    "6h": [
      ("6 hours left, {name}", "Complete today's challenge or lose a revival."),
      ("Revival at risk", "6 hours to attempt the daily challenge."),
      ("Clock's ticking", "Protect your revival — 6 hours remaining, {name}."),
      ("Daily Challenge: 6h left", "Attempt it now to keep your revival safe."),
      ("Don't lose a revival", "6 hours left to play today's quiz."),
    ],
    "2h": [
      (
        "2 hours left, {name}",
        "Your revival will be consumed tonight if you skip this.",
      ),
      ("Revival alert", "Only 2 hours left to protect it."),
      ("Almost out of time", "2 hours to save your revival, {name}."),
      ("Daily Challenge: 2h left", "Play now or lose a revival tonight."),
      ("Last call soon", "2 hours left before your revival's gone."),
    ],
    "1h": [
      ("1 hour left, {name}", "Don't let your revival go to waste."),
      (
        "Critical: 1 hour remaining",
        "Save your revival by completing the challenge now.",
      ),
      ("Final hour", "Play now to preserve your revival, {name}."),
      ("Revival at risk", "60 minutes left before it's consumed."),
      ("Act fast", "1 hour left — attempt the quiz now, {name}."),
    ],
    "15m": [
      ("15 minutes left, {name}", "Your revival is about to be consumed."),
      ("Final warning", "15 minutes to save your revival."),
      ("Almost out of time", "Your revival goes in 15 minutes, {name}."),
      ("Last chance", "15 minutes left before your revival is consumed."),
      ("Play now", "Only 15 minutes left, {name}."),
    ],
  };

  static const Map<String, List<(String, String)>> challengeReminderNoRevival =
      {
        "6h": [
          (
            "6 hours left, {name}",
            "Complete today's challenge to protect your {streak}-day streak.",
          ),
          ("Streak at risk", "6 hours remaining to keep it alive."),
          ("Don't break the streak", "{streak} days on the line, {name}."),
          (
            "Daily Challenge: 6h left",
            "Play now to save your {streak}-day streak.",
          ),
          ("Clock's ticking on your streak", "6 hours left, {name}."),
        ],
        "2h": [
          (
            "2 hours left, {name}",
            "Your {streak}-day streak resets tonight if you skip this.",
          ),
          ("Streak alert", "Only 2 hours left to protect {streak} days."),
          ("Almost out of time", "2 hours to save your streak, {name}."),
          (
            "Daily Challenge: 2h left",
            "Play now or lose your {streak}-day streak.",
          ),
          ("Last call soon", "2 hours left before your streak resets."),
        ],
        "1h": [
          ("1 hour left, {name}", "Don't lose your {streak}-day streak now."),
          (
            "Critical: 1 hour remaining",
            "Save your {streak}-day streak by playing now.",
          ),
          ("Final hour", "Protect your {streak}-day streak, {name}."),
          ("Streak at risk", "60 minutes left before it resets."),
          ("Act fast", "1 hour left to save {streak} days, {name}."),
        ],
        "15m": [
          (
            "15 minutes left, {name}",
            "Your {streak}-day streak is about to reset.",
          ),
          ("Final warning", "15 minutes to save your streak."),
          (
            "Almost out of time",
            "Your {streak}-day streak resets in 15 minutes, {name}.",
          ),
          (
            "Last chance",
            "15 minutes left before your {streak}-day streak resets.",
          ),
          ("Play now", "Only 15 minutes left to save {streak} days, {name}."),
        ],
      };

  static const Map<String, List<(String, String)>> challengeReminderZeroStreak =
      {
        "6h": [
          (
            "6 hours left, {name}",
            "Start your daily financial learning habit today!",
          ),
          ("Start your streak", "6 hours remaining to complete today's quiz."),
          (
            "Knowledge is wealth, {name}",
            "Attempt today's challenge before time runs out.",
          ),
          (
            "Daily Challenge: 6h left",
            "Take today's quiz and kickstart your daily streak.",
          ),
          (
            "Kickstart your streak",
            "6 hours left to start building your consistency.",
          ),
        ],
        "2h": [
          (
            "2 hours left, {name}",
            "A new streak is waiting. Start it tonight!",
          ),
          ("Start your streak", "Only 2 hours left to attempt today's quiz."),
          (
            "Don't miss today's KP",
            "2 hours to play today's challenge, {name}.",
          ),
          (
            "Daily Challenge: 2h left",
            "Learn something new today and earn some KP.",
          ),
          ("Opportunity knocking", "2 hours left before today's quiz resets."),
        ],
        "1h": [
          ("1 hour left, {name}", "Kickstart your streak before midnight!"),
          (
            "Critical: 1 hour remaining",
            "Start your daily financial habit now.",
          ),
          (
            "Final hour",
            "Attempt today's challenge and learn something new, {name}.",
          ),
          ("Streak waiting for you", "60 minutes left to start your daily streak."),
          ("Act fast", "1 hour left to complete today's quiz, {name}."),
        ],
        "15m": [
          (
            "15 minutes left, {name}",
            "Last chance to start your daily streak today!",
          ),
          ("Final warning", "15 minutes to take today's quiz."),
          (
            "Almost out of time",
            "Today's challenge resets in 15 minutes, {name}.",
          ),
          (
            "Last chance",
            "15 minutes left to earn today's knowledge points.",
          ),
          ("Play now", "Only 15 minutes left to start your streak, {name}!"),
        ],
      };

  // Original list kept for compatibility
  static const List<(String, String)> dailyQuiz = [
    (
      "New Daily Quiz",
      "A fresh challenge just dropped — test your money skills.",
    ),
    ("Today's Quiz is Here", "Answer it to earn KP and grow your city."),
    ("Don't Miss Today's Quiz", "Keep your streak alive."),
    ("Knowledge Is Wealth", "Your daily quiz is ready."),
  ];

  static (String, String) getRandomDisasterNotification(
    String name,
    DisasterType type,
    bool insured,
  ) {
    final list = insured ? disasterInsured[type]! : disasterUninsured[type]!;
    final choice = _randomElement(list);
    return (
      _format(choice.$1, {'name': name}),
      _format(choice.$2, {'name': name}),
    );
  }

  static (String, String) getRandomDebtNotification(String name) {
    final choice = _randomElement(debtNotifications);
    return (
      _format(choice.$1, {'name': name}),
      _format(choice.$2, {'name': name}),
    );
  }

  static (String, String) getRandomForeclosureNotification(
    String name,
    String buildingName,
  ) {
    final choice = _randomElement(foreclosureNotifications);
    return (
      _format(choice.$1, {'name': name, 'building': buildingName}),
      _format(choice.$2, {'name': name, 'building': buildingName}),
    );
  }

  static (String, String) getRandomInactivityNotification(
    String name,
    String interval,
  ) {
    final list =
        inactivityNotifications[interval] ?? inactivityNotifications["2d"]!;
    final choice = _randomElement(list);
    return (
      _format(choice.$1, {'name': name}),
      _format(choice.$2, {'name': name}),
    );
  }

  static (String, String) getRandomNewQuizNotification(String name) {
    final choice = _randomElement(newQuizNotifications);
    return (
      _format(choice.$1, {'name': name}),
      _format(choice.$2, {'name': name}),
    );
  }

  static (String, String) getRandomDailyMorningNotification(String name) {
    final choice = _randomElement(morningQuizNotifications);
    return (
      _format(choice.$1, {'name': name}),
      _format(choice.$2, {'name': name}),
    );
  }

  static (String, String) getRandomChallengeReminder(
    String name,
    int streak,
    int revivals,
    String timeLeft,
  ) {
    if (revivals > 0) {
      final list =
          challengeReminderWithRevival[timeLeft] ??
          challengeReminderWithRevival["6h"]!;
      final choice = _randomElement(list);
      return (
        _format(choice.$1, {'name': name}),
        _format(choice.$2, {'name': name}),
      );
    } else if (streak == 0) {
      final list =
          challengeReminderZeroStreak[timeLeft] ??
          challengeReminderZeroStreak["6h"]!;
      final choice = _randomElement(list);
      return (
        _format(choice.$1, {'name': name}),
        _format(choice.$2, {'name': name}),
      );
    } else {
      final list =
          challengeReminderNoRevival[timeLeft] ??
          challengeReminderNoRevival["6h"]!;
      final choice = _randomElement(list);
      return (
        _format(choice.$1, {'name': name, 'streak': streak.toString()}),
        _format(choice.$2, {'name': name, 'streak': streak.toString()}),
      );
    }
  }

  static (String, String) getRandomDailyGeneralNotification(String name) {
    final choice = _randomElement(dailyGeneral);
    return (
      _format(choice.$1, {'name': name}),
      _format(choice.$2, {'name': name}),
    );
  }
}
