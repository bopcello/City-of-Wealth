// ignore_for_file: constant_identifier_names

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
    ("Income received, {name}", "Today's income cycle just landed."),
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

  static const Map<String, List<(String, String)>> friendActivityTemplates = {
    'level_up': [
      ('{friend} just leveled up!', '{friend} is now a {title}. Big moment.'),
      ('New milestone for {friend}', '{friend} just reached {title}.'),
      ('{friend} is climbing fast', 'They just became {title}.'),
    ],
    'streak_milestone': [
      (
        '{friend} hit a {streak}-day streak',
        'That kind of consistency is rare — go cheer them on.',
      ),
      ('{friend} is on fire', '{streak} days straight. Worth a shoutout.'),
    ],
    'building_built': [
      ('{friend} built {building}', 'Their city just got a new addition.'),
      ('{friend}\'s skyline is growing', '{building} just went up.'),
    ],
    'bankruptcy': [
      (
        '{friend} is starting over',
        'Bankruptcy declared. This is the moment to show up for them.',
      ),
      (
        'A hard reset for {friend}',
        'Their city fell back to level 1 — a cheer might help.',
      ),
    ],
    'session_summary': [('{friend} made moves', '{summary}')],
  };

  static const Map<String, List<(String, String)>> friendRequestTemplates = {
    'friend_request_sent': [
      ('{name} sent a friend request', '{name} sent a friend request'),
      ('New Friend Request', '{name} sent a friend request'),
      ('Friend Request from {name}', '{name} sent a friend request'),
    ],
    'friend_request_denied': [
      (
        '{name} denied your friend request',
        '{name} denied your friend request',
      ),
      ('Friend Request Declined', '{name} denied your friend request'),
      ('Update on Friend Request', '{name} denied your friend request'),
    ],
    'friend_request_accepted': [
      (
        '{name} accepted your friend request',
        '{name} accepted your friend request, you are now friends with {name}',
      ),
      (
        'New Friend Connected!',
        '{name} accepted your friend request, you are now friends with {name}',
      ),
      (
        'Friend Request Accepted',
        '{name} accepted your friend request, you are now friends with {name}',
      ),
    ],
  };

  /// Source of truth for friend push copy. The Render worker reads this JSON
  /// during startup so closed-app notifications use the same copy as Flutter.
  static const String friendActivityNotificationTemplatesJson = r'''{
  "level_up": [
    ["{name} just leveled up!", "They're officially {level} now. Big moves."],
    ["Level up for {name}", "Say hello to {level}."],
    ["{name} broke through", "New level unlocked: {level}."],
    ["Rising star alert", "{name} just became {level}."],
    ["{name} is moving up fast", "{level} status: achieved."]
  ],
  "building_built": [
    ["{name}'s city just grew", "{buildings} is now standing tall."],
    ["New addition in {name}'s skyline", "{buildings} just went up."],
    ["{name} is building an empire", "{buildings} joined the city."],
    ["Construction complete", "{name} finished {buildings}."],
    ["{name}'s city keeps expanding", "{buildings} is now part of the skyline."]
  ],
  "building_destroyed": [
    ["{name}'s city just lost {buildings}", "A rough day for their skyline."],
    ["{buildings} came down", "{name} will need to rebuild."],
    ["Bad news for {name}", "{buildings} was destroyed."],
    ["{name}'s skyline took a hit", "{buildings} is gone."],
    ["{name} is picking up the pieces", "{buildings} didn't make it."]
  ],
  "kp_gained": [
    ["{name}'s KP is climbing", "+{kp} KP added to their total."],
    ["Smart move, {name}", "+{kp} KP just landed."],
    ["{name} is getting sharper", "+{kp} KP gained."],
    ["KP boost for {name}", "Up {kp} points and counting."],
    ["{name} is stacking KP", "+{kp} KP this round."]
  ],
  "kp_lost": [
    ["{name}'s KP took a hit", "-{kp} KP lost."],
    ["A costly call for {name}", "-{kp} KP gone."],
    ["{name} slipped up", "-{kp} KP this round."],
    ["KP drop for {name}", "Down {kp} points."],
    ["{name} needs to recover", "-{kp} KP lost just now."]
  ],
  "streak_continued": [
    ["{name}'s streak lives on", "Now at {streak} days."],
    ["{name} showed up again", "Streak: {streak} days strong."],
    ["Consistency win for {name}", "{streak} days and climbing."],
    ["{name} is on a roll", "{streak}-day streak intact."],
    ["Another day, another win", "{name} hit {streak} days."]
  ],
  "streak_lost": [
    ["{name}'s streak just ended", "{previousStreak} days reset to {streak}."],
    ["Streak broken for {name}", "Down from {previousStreak} to {streak}."],
    ["{name} lost the momentum", "Their {previousStreak}-day streak is gone."],
    ["A tough break for {name}", "Streak fell from {previousStreak} to {streak}."],
    ["{name} is starting a new streak", "{previousStreak} days came to an end."]
  ],
  "bankruptcy": [
    ["{name} declared bankruptcy", "Back to level 1 — a tough moment."],
    ["A hard reset for {name}", "Their city dropped to level 1."],
    ["{name} is starting from scratch", "Bankruptcy hit hard this time."],
    ["A rough day for {name}", "Their empire reset to level 1."],
    ["{name} could use some support", "Bankruptcy declared — level 1 again."]
  ]
}''';

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
    ("Good morning, {name}", "Today's quiz is ready — answer it for KP."),
    (
      "Rise and check your city",
      "Start the day by sharpening your financial knowledge.",
    ),
    ("New day, new quiz", "Keep the streak going, {name}."),
    ("Your morning quiz is here", "Earn KP early and expand your city today."),
    ("Daily Challenge", "Today's challenge is ready when you are, {name}."),
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

  static const Map<String, List<(String, String)>>
  challengeReminderZeroStreak = {
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
      ("2 hours left, {name}", "A new streak is waiting. Start it tonight!"),
      ("Start your streak", "Only 2 hours left to attempt today's quiz."),
      ("Don't miss today's KP", "2 hours to play today's challenge, {name}."),
      (
        "Daily Challenge: 2h left",
        "Learn something new today and earn some KP.",
      ),
      ("Opportunity knocking", "2 hours left before today's quiz resets."),
    ],
    "1h": [
      ("1 hour left, {name}", "Kickstart your streak before midnight!"),
      ("Critical: 1 hour remaining", "Start your daily financial habit now."),
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
      ("Almost out of time", "Today's challenge resets in 15 minutes, {name}."),
      ("Last chance", "15 minutes left to earn today's knowledge points."),
      ("Play now", "Only 15 minutes left to start your streak, {name}!"),
    ],
  };

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
    if (streak == 0) {
      final list =
          challengeReminderZeroStreak[timeLeft] ??
          challengeReminderZeroStreak["6h"]!;
      final choice = _randomElement(list);
      return (
        _format(choice.$1, {'name': name}),
        _format(choice.$2, {'name': name}),
      );
    } else if (revivals > 0) {
      final list =
          challengeReminderWithRevival[timeLeft] ??
          challengeReminderWithRevival["6h"]!;
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

  static (String, String) getRandomFriendActivityNotification(
    String friendName,
    String eventType,
    Map<String, dynamic> payload,
  ) {
    final list =
        friendActivityTemplates[eventType] ??
        friendActivityTemplates['session_summary']!;
    final choice = _randomElement(list);
    final buildings = (payload['newBuildings'] as List? ?? const [])
        .map((building) => building.toString())
        .toList();
    final values = <String, String>{
      'friend': friendName,
      'title': payload['newLevel']?.toString() ?? 'a new level',
      'streak': payload['streak']?.toString() ?? 'new',
      'building': buildings.isNotEmpty ? buildings.first : 'a new building',
      'summary': formatFriendActivitySummary(friendName, payload),
    };
    return (_format(choice.$1, values), _format(choice.$2, values));
  }

  static (String, String) getRandomFriendRequestNotification(
    String friendName,
    String type,
  ) {
    final list =
        friendRequestTemplates[type] ??
        friendRequestTemplates['friend_request_sent']!;
    final choice = _randomElement(list);
    final values = {'name': friendName};
    return (_format(choice.$1, values), _format(choice.$2, values));
  }

  static String formatFriendActivitySummary(
    String friendName,
    Map<String, dynamic> payload,
  ) {
    final events = (payload['events'] as List? ?? const [])
        .map((event) => event.toString())
        .toSet();
    final parts = <String>[];
    final level = payload['newLevel']?.toString();
    final streak = payload['streak'];
    final previousStreak = payload['previousStreak'];
    final kpChange = (payload['kpChange'] as num?)?.toInt();
    final buildings = (payload['newBuildings'] as List? ?? const [])
        .map((building) => building.toString())
        .toList();
    final destroyedBuildings =
        (payload['destroyedBuildings'] as List? ?? const [])
            .map((building) => building.toString())
            .toList();

    if (events.contains('level_up') && level != null && level.isNotEmpty) {
      parts.add('leveled up to $level');
    }
    if ((events.contains('streak_milestone') ||
            events.contains('streak_continued')) &&
        streak != null) {
      parts.add('hit a $streak-day streak');
    }
    if (events.contains('streak_lost') && previousStreak != null) {
      parts.add('lost their $previousStreak-day streak');
    }
    if (events.contains('building_built')) {
      parts.add(
        buildings.length == 1
            ? 'built ${buildings.first}'
            : 'built ${buildings.length} new buildings',
      );
    }
    if (events.contains('building_destroyed')) {
      parts.add(
        destroyedBuildings.length == 1
            ? 'lost ${destroyedBuildings.first}'
            : 'lost ${destroyedBuildings.length} buildings',
      );
    }
    if (events.contains('kp_gained') && kpChange != null) {
      parts.add('gained $kpChange KP');
    }
    if (events.contains('kp_lost') && kpChange != null) {
      parts.add('lost ${kpChange.abs()} KP');
    }
    if (events.contains('bankruptcy')) parts.add('is starting over');

    if (parts.isEmpty) return '$friendName made progress in their city.';
    if (parts.length == 1) return '$friendName ${parts.first}.';
    return '$friendName ${parts.sublist(0, parts.length - 1).join(', ')} and ${parts.last}.';
  }

  // ---------------------------------------------------------------------------
  // Daily Reminder Notification Sets (8 3-bit state sets with rich data)
  // ---------------------------------------------------------------------------

  /// Set 1: KP✅ Assets✅ Quizzes✅ (kp_yes_assets_yes_quizzes_yes) — Ready to level up right now.
  static const List<(String, String)> kp_yes_assets_yes_quizzes_yes = [
    (
      "You're ready to level up, {name}!",
      "You've met all requirements — open City of Wealth and claim your next title now!",
    ),
    (
      "Level up is waiting for you!",
      "KP, assets, and quizzes are all complete. Tap to advance your career!",
    ),
    (
      "What are you waiting for, {name}?",
      "Your hard work paid off. Advance to the next level and scale your daily yield!",
    ),
    (
      "Your next title is ready to claim",
      "All requirements met! Open the app and take the next step in your financial journey.",
    ),
    (
      "You've done the work, {name}",
      "KP, buildings, and quizzes are cleared. Level up today!",
    ),
  ];

  /// Set 2: KP✅ Assets❌ Quizzes❌ (kp_yes_assets_no_quizzes_no) — Has enough KP, missing buildings and quizzes.
  static const List<(String, String)> kp_yes_assets_no_quizzes_no = [
    (
      "KP ready, but structure needed",
      "Can you construct {buildingsNeeded} before your competitors catch up?",
    ),
    (
      "Your KP is ready, {name}, but your city isn't",
      "You still need {buildingsNeeded} and {quizzesNeeded} to unlock your next level.",
    ),
    (
      "Great KP, but missing foundation!",
      "Construct {buildingsNeeded} and complete {quizzesNeeded} to advance.",
    ),
    (
      "Capital without structure, {name}",
      "You've got the KP, but you need {buildingsNeeded} and {quizzesNeeded} to level up.",
    ),
    (
      "KP is banked, but structure is missing",
      "Construct {buildingsNeeded} and finish {quizzesNeeded} to reach the next tier.",
    ),
  ];

  /// Set 3: KP❌ Assets❌ Quizzes✅ (kp_no_assets_no_quizzes_yes) — Has completed required quizzes, missing KP and buildings.
  static const List<(String, String)> kp_no_assets_no_quizzes_yes = [
    (
      "Quizzes complete, but empire building remains",
      "You still need {kpNeeded} more KP and {buildingsNeeded} to level up, {name}.",
    ),
    (
      "Quizzes checked off, {name}!",
      "Now focus on earning {kpNeeded} more KP and constructing {buildingsNeeded} to level up.",
    ),
    (
      "Knowledge tested, now scale up!",
      "Your quizzes are done. Earn {kpNeeded} more KP and construct {buildingsNeeded} to advance.",
    ),
    (
      "The theory is done, {name}",
      "Quizzes are checked off, but you need {kpNeeded} KP and {buildingsNeeded} for your next title.",
    ),
    (
      "Smart moves take time",
      "Quizzes completed! Focus now on gaining {kpNeeded} KP and expanding by {buildingsNeeded}.",
    ),
  ];

  /// Set 4: KP❌ Assets✅ Quizzes❌ (kp_no_assets_yes_quizzes_no) — Has enough buildings, missing KP and quizzes.
  static const List<(String, String)> kp_no_assets_yes_quizzes_no = [
    (
      "Skyline built, wisdom needed",
      "Complete your quizzes to earn the {kpNeeded} KP you need to expand your city!",
    ),
    (
      "Your skyline is built, {name}, but your knowledge isn't complete",
      "You need {kpNeeded} more KP and {quizzesNeeded} to reach your next level.",
    ),
    (
      "Great buildings, now sharpen your skills!",
      "You have the assets. Now earn {kpNeeded} KP and complete {quizzesNeeded} to advance.",
    ),
    (
      "Infrastructure ready, mind in progress",
      "Buildings are set, but {kpNeeded} KP and {quizzesNeeded} stand between you and promotion, {name}.",
    ),
    (
      "Assets locked in!",
      "Your buildings are built. Now tackle {quizzesNeeded} and gain {kpNeeded} KP to level up.",
    ),
  ];

  /// Set 5: KP✅ Assets❌ Quizzes✅ (kp_yes_assets_no_quizzes_yes) — Has KP and quizzes, missing buildings only.
  static const List<(String, String)> kp_yes_assets_no_quizzes_yes = [
    (
      "Knowledge turns to wealth when applied",
      "Construct {buildingsNeeded} to turn your knowledge into wealth.",
    ),
    (
      "So close to promotion, {name}!",
      "KP and quizzes are done. Just construct {buildingsNeeded} to level up!",
    ),
    (
      "Your mind is ready, but your city is waiting",
      "Build {buildingsNeeded} to claim your next career milestone.",
    ),
    (
      "Just one piece left!",
      "KP and quizzes complete. Construct {buildingsNeeded} to advance, {name}.",
    ),
    (
      "Infrastructure bottleneck!",
      "You've got the wisdom and KP — now construct {buildingsNeeded} to expand your empire.",
    ),
  ];

  /// Set 6: KP❌ Assets✅ Quizzes✅ (kp_no_assets_yes_quizzes_yes) — Has buildings and quizzes, missing KP only.
  static const List<(String, String)> kp_no_assets_yes_quizzes_yes = [
    (
      "Everything is built and tested, {name}",
      "You just need {kpNeeded} more KP to unlock your next level!",
    ),
    (
      "Buildings set, quizzes done!",
      "You're only {kpNeeded} KP away from your promotion. Keep making smart choices!",
    ),
    (
      "The final hurdle is KP",
      "You have the assets and quiz credentials. Earn {kpNeeded} more KP to level up!",
    ),
    (
      "Almost a mogul, {name}",
      "Buildings and quizzes are checked off. Gain {kpNeeded} KP to claim your title.",
    ),
    (
      "Precision planning paid off",
      "Your city and quizzes are complete. Just bank {kpNeeded} more KP to advance!",
    ),
  ];

  /// Set 7: KP✅ Assets✅ Quizzes❌ (kp_yes_assets_yes_quizzes_no) — Has KP and buildings, missing quizzes only.
  static const List<(String, String)> kp_yes_assets_yes_quizzes_no = [
    (
      "You have the wealth and the city, {name}",
      "Now prove your financial knowledge! Complete {quizzesNeeded} to level up.",
    ),
    (
      "KP and buildings are ready!",
      "You just need to complete {quizzesNeeded} to secure your promotion.",
    ),
    (
      "Don't let quizzes hold you back",
      "You've built the assets and banked the KP. Finish {quizzesNeeded} to level up!",
    ),
    (
      "Test your knowledge, {name}",
      "Your empire is standing and your KP is high. Complete {quizzesNeeded} to advance.",
    ),
    (
      "Final requirement: Quizzes!",
      "You've got the KP and buildings. Complete {quizzesNeeded} to claim your new title.",
    ),
  ];

  /// Set 8: KP❌ Assets❌ Quizzes❌ (kp_no_assets_no_quizzes_no) — Missing all three (early-game default state).
  static const List<(String, String)> kp_no_assets_no_quizzes_no = [
    (
      "Your financial journey is just beginning, {name}",
      "Earn {kpNeeded} KP, build {buildingsNeeded}, and complete {quizzesNeeded} to level up!",
    ),
    (
      "Every empire starts from scratch",
      "Work towards {kpNeeded} KP, {buildingsNeeded}, and {quizzesNeeded} for your next title.",
    ),
    (
      "Time to make your mark!",
      "You need {kpNeeded} KP, {buildingsNeeded}, and {quizzesNeeded} to advance.",
    ),
    (
      "Build, learn, and earn, {name}",
      "Gain {kpNeeded} KP, construct {buildingsNeeded}, and complete {quizzesNeeded} to level up.",
    ),
    (
      "Ready for the grind?",
      "Target {kpNeeded} KP, {buildingsNeeded}, and {quizzesNeeded} to expand your city!",
    ),
  ];

  // ---------------------------------------------------------------------------
  // Retention Notifications (30 notifications with rich personalized data)
  // ---------------------------------------------------------------------------

  static const List<(String, String)> retentionNotifications = [
    // --- Original & updated retention notifications ---
    (
      "Pitching in the boardroom",
      "Show off your financial empire — log in to City of Wealth today!",
    ),
    (
      "Your future self called",
      "They wanted to see if you built your empire and put your {gemYield} gems to work today.",
    ),
    (
      "Markets move fast, {name}",
      "Take 2 minutes to inspect your {rawBuildingName} and keep your income growing.",
    ),
    (
      "Quiet day in your portfolio?",
      "Turn your idle assets into {gemYieldFromPassive} extra gems daily with passive income.",
    ),
    (
      "Your city needs its mayor",
      "Decisions don't make themselves — come back and manage your {rawBuildingName}!",
    ),
    (
      "Ready for today's board meeting?",
      "Leveling up to level {nextLevel} will boost your daily income by {gemBoostNextLevel} gems!",
    ),
    (
      "Consistency compounds",
      "A quick 1-minute check-in keeps your {rawBuildingName} yield compounding.",
    ),
    (
      "Don't leave {gemYieldFromPassive} gems on the table",
      "Activate passive income on your assets and collect free daily gems.",
    ),
    (
      "Small decisions, massive returns",
      "Attempt today's quiz to unlock {buildingCountFormatted} more {buildingNamePluralized}.",
    ),
    (
      "Your financial empire is waiting!",
      "Check in now to boost your daily yield by {gemBoostNextLevel} gems at level {nextLevel}.",
    ),
    (
      "Is your portfolio ready for level {nextLevel}?",
      "You are just {kpNeeded} KP away. Open City of Wealth and claim your promotion!",
    ),
    (
      "A quick financial sanity check?",
      "See how your {rawBuildingName} income stands against top players today.",
    ),
    (
      "Wealth isn't built overnight — it's built daily",
      "Level up to level {nextLevel} and add {gemBoostNextLevel} extra gems to your daily income.",
    ),
    (
      "Your assets don't sleep, {name}",
      "Make sure your {rawBuildingName} strategy is set for maximum growth.",
    ),
    (
      "Got 2 minutes to spare?",
      "Turn idle assets into {gemYieldFromPassive} extra gems per day with passive income.",
    ),
    (
      "Your competition is making moves",
      "Other players are building {rawBuildingNamePlural} — check your stats and keep pace.",
    ),
    (
      "From rookie to real estate mogul",
      "Level up to level {nextLevel} to earn {gemBoostNextLevel} more gems every single day.",
    ),
    (
      "Smart money moves start with daily practice",
      "Test your knowledge, gain {kpNeeded} KP, and level up to level {nextLevel}.",
    ),
    (
      "Your city's economy is buzzing",
      "Come see how many gems your {rawBuildingName} banked while you were away.",
    ),
    (
      "The best time to build your next {rawBuildingName} was yesterday",
      "The second best time is right now!",
    ),
    // --- Merged from Set 5 (Motivational nudges) ---
    (
      "Your city would love someone with more KP to lead it",
      "You're just {kpNeeded} KP away from level {nextLevel}. Attempt today's quiz!",
    ),
    (
      "Is {kpNeeded} KP really going to stand between you and level {nextLevel}?",
      "Solve today's quiz and boost your KP.",
    ),
    (
      "Expand your empire today",
      "A quick quiz today gets you the KP needed for your next level.",
    ),
    (
      "Your city skyline is looking a bit modest...",
      "Nothing a few correct answers and {kpNeeded} more KP can't fix.",
    ),
    (
      "Other players are blazing through levels while you rest",
      "Level up to level {nextLevel} and unlock {gemBoostNextLevel} extra gems daily.",
    ),
    // --- 5 New Debt Ragebait Notifications ---
    (
      "Your bank account is bleeding, {name}",
      "Debt is at {debt} gems and accumulating interest. Pay it off before bankruptcy!",
    ),
    (
      "Interest payments are eating your empire!",
      "You owe {debt} gems. Log in now to stop your debt from spiraling.",
    ),
    (
      "Financial emergency in your city!",
      "Debt has reached {debt} gems. Play now to save yourself from bankruptcy!",
    ),
    (
      "Are you really letting {debt} gems of debt destroy your city?",
      "Take control, make smart money moves, and clear your balance!",
    ),
    (
      "Your creditors are knocking, {name}",
      "You have {debt} gems in active debt. Log in and recover your balance today.",
    ),
  ];

  // ---------------------------------------------------------------------------
  // Helper: random building name from player's actual city buildings
  // ---------------------------------------------------------------------------

  /// Pluralizes a building name based on count or general plural format.
  static String _pluralizeBuildingName(String name, int count) {
    if (count == 1) return name;
    if (name.endsWith('y')) {
      return '${name.substring(0, name.length - 1)}ies';
    }
    if (name.endsWith('s')) {
      return name;
    }
    return '${name}s';
  }

  /// Helper: returns a raw building name selected from the player's city buildings.
  static String getRawBuildingFromCity(List<String>? builtBuildings) {
    if (builtBuildings != null && builtBuildings.isNotEmpty) {
      final valid = builtBuildings.where((b) => b.trim().isNotEmpty).toList();
      if (valid.isNotEmpty) {
        return _randomElement(valid);
      }
    }
    final names = passiveIncomeData.values.map((e) => e.buildingName).toList();
    return _randomElement(names);
  }

  /// Helper: returns a random building name selected from the player's actually built city buildings.
  /// Counts the occurrences of each building type in the city (e.g. "3 Farms" or "1 Farm").
  /// Derives building names dynamically without hardcoded fallback lists.
  static String getRandomBuildingFromCity(
    List<String>? builtBuildings, {
    bool includeCount = true,
  }) {
    final Map<String, int> counts = {};
    if (builtBuildings != null) {
      for (final name in builtBuildings) {
        if (name.trim().isEmpty) continue;
        counts[name] = (counts[name] ?? 0) + 1;
      }
    }

    if (counts.isEmpty) {
      final names = passiveIncomeData.values
          .map((e) => e.buildingName)
          .toList();
      final selectedName = _randomElement(names);
      return includeCount ? '1 $selectedName' : selectedName;
    }

    final uniqueNames = counts.keys.toList();
    final selectedName = _randomElement(uniqueNames);
    final count = counts[selectedName]!;
    final formattedName = _pluralizeBuildingName(selectedName, count);

    if (includeCount && count > 1) {
      return '$count $formattedName';
    } else if (includeCount && count == 1) {
      return '1 $selectedName';
    }
    return formattedName;
  }

  // ---------------------------------------------------------------------------
  // Daily Reminder helper
  // ---------------------------------------------------------------------------

  /// Returns a personalised daily reminder notification based on the player's
  /// 3-bit level-up state (KP, Assets, Quizzes).
  static (String, String) getRandomDailyReminderNotification({
    required String name,
    bool kpMet = false,
    bool assetsMet = false,
    bool quizzesMet = false,
    int kpNeeded = 0,
    int buildingsNeeded = 0,
    String quizzesNeeded = '',
    String? buildingName,
    List<String>? builtBuildings,
    int gemYield = 0,
  }) {
    List<(String, String)> selectedSet;
    if (kpMet && assetsMet && quizzesMet) {
      selectedSet = kp_yes_assets_yes_quizzes_yes;
    } else if (kpMet && !assetsMet && !quizzesMet) {
      selectedSet = kp_yes_assets_no_quizzes_no;
    } else if (!kpMet && !assetsMet && quizzesMet) {
      selectedSet = kp_no_assets_no_quizzes_yes;
    } else if (!kpMet && assetsMet && !quizzesMet) {
      selectedSet = kp_no_assets_yes_quizzes_no;
    } else if (kpMet && !assetsMet && quizzesMet) {
      selectedSet = kp_yes_assets_no_quizzes_yes;
    } else if (!kpMet && assetsMet && quizzesMet) {
      selectedSet = kp_no_assets_yes_quizzes_yes;
    } else if (kpMet && assetsMet && !quizzesMet) {
      selectedSet = kp_yes_assets_yes_quizzes_no;
    } else {
      selectedSet = kp_no_assets_no_quizzes_no;
    }

    final choice = _randomElement(selectedSet);
    final rawBuilding = getRawBuildingFromCity(builtBuildings);
    final rawBuildingPlural = _pluralizeBuildingName(rawBuilding, 2);
    final buildingsNeededStr = buildingsNeeded == 1
        ? '1 building'
        : '$buildingsNeeded buildings';

    final placeholders = <String, String>{
      'name': name,
      'kpNeeded': kpNeeded.toString(),
      'buildingsNeeded': buildingsNeededStr,
      'quizzesNeeded': quizzesNeeded,
      'buildingName': buildingName ?? rawBuilding,
      'rawBuildingName': rawBuilding,
      'rawBuildingNamePlural': rawBuildingPlural,
      'gemYield': gemYield.toString(),
    };

    return (_format(choice.$1, placeholders), _format(choice.$2, placeholders));
  }

  // ---------------------------------------------------------------------------
  // Retention helper
  // ---------------------------------------------------------------------------

  /// Returns a personalised retention notification.
  /// All placeholder values are dynamically calculated. Templates with condition-dependent
  /// placeholders (such as {gemBoostNextLevel}, {debt}, {gemYieldFromPassive}, {kpNeeded}, {buildingCount})
  /// will be skipped and re-selected if their condition is not met (e.g. debt <= 0 or level 5).
  static (String, String) getRandomRetentionNotification({
    required String name,
    int level = 1,
    int kpNeeded = 0,
    int buildingCount = 0,
    String? buildingName,
    List<String>? builtBuildings,
    int gemYield = 0,
    int gemBoostNextLevel = 0,
    int gemYieldFromPassive = 0,
    int debt = 0,
  }) {
    final rawBuilding = getRawBuildingFromCity(builtBuildings);
    final rawBuildingPlural = _pluralizeBuildingName(rawBuilding, 2);
    final buildingNamePluralized = buildingCount == 1
        ? rawBuilding
        : rawBuildingPlural;
    final nextLevel = level < 5 ? level + 1 : 5;

    // Filter templates to ensure conditional placeholders are valid
    final validCandidates = retentionNotifications.where((notification) {
      final text = '${notification.$1} ${notification.$2}';
      if (text.contains('{gemBoostNextLevel}') && gemBoostNextLevel <= 0) {
        return false;
      }
      if (text.contains('{debt}') && debt <= 0) {
        return false;
      }
      if (text.contains('{gemYieldFromPassive}') && gemYieldFromPassive <= 0) {
        return false;
      }
      if (text.contains('{kpNeeded}') && kpNeeded <= 0) {
        return false;
      }
      if ((text.contains('{buildingCount}') ||
              text.contains('{buildingsNeeded}')) &&
          buildingCount <= 0) {
        return false;
      }
      if (text.contains('{gemYield}') && gemYield <= 0) {
        return false;
      }
      return true;
    }).toList();

    final selectedPool = validCandidates.isNotEmpty
        ? validCandidates
        : retentionNotifications;
    final choice = _randomElement(selectedPool);

    final placeholders = <String, String>{
      'name': name,
      'level': level.toString(),
      'nextLevel': nextLevel.toString(),
      'kpNeeded': kpNeeded.toString(),
      'buildingCount': buildingCount.toString(),
      'buildingCountFormatted': buildingCount.toString(),
      'buildingNamePluralized': buildingNamePluralized,
      'buildingsNeeded': buildingCount == 1
          ? '1 building'
          : '$buildingCount buildings',
      'buildingName': buildingNamePluralized,
      'rawBuildingName': rawBuilding,
      'rawBuildingNamePlural': rawBuildingPlural,
      'gemYield': gemYield.toString(),
      'gemBoostNextLevel': gemBoostNextLevel.toString(),
      'gemYieldFromPassive': gemYieldFromPassive.toString(),
      'debt': debt.toString(),
    };

    return (_format(choice.$1, placeholders), _format(choice.$2, placeholders));
  }

  // ---------------------------------------------------------------------------
  // Alternating 6-hour retention notification
  // ---------------------------------------------------------------------------

  /// Returns a notification that alternates between the 8 3-bit state daily
  /// reminder sets and the retention notifications every 6 hours.
  ///
  /// Even [cycleIndex] → one of the 8 3-bit state sets (matching exact 3-bit state)
  /// Odd  [cycleIndex] → retentionNotifications
  static (String, String) getAlternatingRetentionNotification({
    required int cycleIndex,
    required String name,
    int level = 1,
    bool kpMet = false,
    bool assetsMet = false,
    bool quizzesMet = false,
    int kpNeeded = 0,
    int buildingsNeeded = 0,
    String quizzesNeeded = '',
    String? buildingName,
    List<String>? builtBuildings,
    int gemYield = 0,
    int gemBoostNextLevel = 0,
    int gemYieldFromPassive = 0,
    int debt = 0,
  }) {
    if (cycleIndex.isEven) {
      // Personalised set turn (matching player's 3-bit state)
      return getRandomDailyReminderNotification(
        name: name,
        kpMet: kpMet,
        assetsMet: assetsMet,
        quizzesMet: quizzesMet,
        kpNeeded: kpNeeded,
        buildingsNeeded: buildingsNeeded,
        quizzesNeeded: quizzesNeeded,
        buildingName: buildingName,
        builtBuildings: builtBuildings,
        gemYield: gemYield,
      );
    } else {
      // Retention set turn
      return getRandomRetentionNotification(
        name: name,
        level: level,
        kpNeeded: kpNeeded,
        buildingCount: buildingsNeeded,
        buildingName: buildingName,
        builtBuildings: builtBuildings,
        gemYield: gemYield,
        gemBoostNextLevel: gemBoostNextLevel,
        gemYieldFromPassive: gemYieldFromPassive,
        debt: debt,
      );
    }
  }
}
