import 'dart:math';
import '../game_state.dart';

class NotificationData {
  static final _random = Random();

  // Pick a random element from a list
  static T _randomElement<T>(List<T> list) => list[_random.nextInt(list.length)];

  // Helper to replace placeholders
  static String _format(String template, Map<String, String> placeholders) {
    String result = template;
    placeholders.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }

  static const List<(String, String)> dailyGeneral = [
    ("{name}, your city awaits you!", "Things don’t grow unless {name} is watching."),
    ("Quiet progress in {name}'s city", "Your assets are still working for {name}."),
    ("Money moved today for {name}!", "Passive income just ticked into {name}'s account."),
    ("Small systems, big results for {name}", "Compounding doesn’t announce itself, {name}."),
    ("Your city feels stable, {name}!", "That didn’t happen by accident, {name}."),
    ("Assets reporting in to {name}", "They did their job for {name} today."),
    ("Growth update for {name}", "Slow. Steady. Real progress for {name}."),
    ("Another income cycle complete, {name}", "Numbers look healthier in {name}'s town."),
    ("Your city is breathing, {name}", "Cash flow is steady for {name}… for now."),
    ("Momentum building for {name}!", "The curve is starting to bend, {name}."),
    ("Nothing flashy today, {name}", "Still richer than yesterday, {name}."),
    ("The system is learning from {name}", "And so is {name}."),
    ("Your strategy is holding, {name}!", "Stability feels good to {name}."),
    ("Foundations look solid, {name}", "Expansion is safer now for {name}."),
    ("Your city is patient, {name}", "Wealth rewards {name}'s patience too."),
    ("No emergencies today for {name}!", "That’s a win for {name}."),
    ("Assets stayed productive for {name}", "Even without new input from {name}."),
    ("Another quiet win, {name}!", "Those add up for {name}."),
    ("Your city trusts you, {name}!", "Don’t disappear on us, {name}."),
    ("Ready to master money today, {name}?", "One decision can change everything for {name}."),
  ];

  static const Map<DisasterType, List<(String, String)>> disasterInsured = {
    DisasterType.flood: [
      ("Flood hit the city, {name}!", "Insurance softened the damage for {name}. Smart call!"),
      ("Water levels rose in {name}'s town", "Flood insurance kept {name} dry and protected."),
      ("Aqua alert for {name}!", "Flood insurance coverage kicked in to help {name} recover."),
      ("Heavy flood hit {name}'s assets", "Your insurance policy saved {name} from a wet disaster."),
      ("Rain came down on {name}", "Insurance absorbed the flood shock for {name}."),
    ],
    DisasterType.fire: [
      ("Fire outbreak contained, {name}!", "Insurance prevented major losses for {name}."),
      ("Smoke cleared for {name}!", "Fire insurance policy covered the damage in {name}'s sectors."),
      ("Blaze alert in {name}'s city!", "Insurance softened the fire damage for {name}."),
      ("Fire hit, but {name} was ready", "Fire policy active! Asset recovery has begun for {name}."),
      ("Conflagration extinguished, {name}", "Unfortunate spark, but {name}'s insurance fully covered the damage."),
    ],
    DisasterType.earthquake: [
      ("Earthquake shock absorbed, {name}!", "Insurance kept {name}'s city standing."),
      ("Ground shook under {name}!", "Earthquake insurance policy saved {name}'s structures."),
      ("Tremor detected in {name}'s town!", "Earthquake policy activated to cover {name}'s repair costs."),
      ("Seismic wave hit {name}'s sectors", "No collapse! {name}'s earthquake insurance protected the foundations."),
      ("Earthquake hit, but {name} is safe", "Smart planning! Insurance absorbed the shock for {name}."),
    ],
    DisasterType.economyCrash: [
      ("Market crash detected, {name}!", "Insurance stabilized {name}'s income streams."),
      ("Economic downturn for {name}!", "Financial insurance shielded {name}'s business operations."),
      ("Bear market hit {name}'s city", "Portfolio insurance protected {name}'s income from crashing."),
      ("Crash hit, but {name} is insured", "Smart hedging! Insurance eased the economic blow for {name}."),
      ("Recession alert for {name}!", "Insurance policies kicked in to keep {name}'s cash flowing."),
    ],
    DisasterType.drought: [
      ("Drought slowed production, {name}!", "Insurance eased long-term impact for {name}."),
      ("Dry spell in {name}'s fields", "Agricultural insurance compensated {name} for the dry weather."),
      ("Drought alert in {name}'s city!", "Insurance policy helped {name} maintain yield."),
      ("Water scarcity hit {name}'s area", "Drought insurance kept {name}'s passive income stable."),
      ("Dry land for {name}", "Crop coverage saved {name} from a total loss."),
    ],
    DisasterType.landslide: [
      ("Landslide contained, {name}!", "Insurance reduced terrain losses for {name}."),
      ("Mudslide in {name}'s zone!", "Geological insurance covered {name}'s clearing costs."),
      ("Landslide alert in {name}'s city!", "Insurance protected {name}'s expansion zone."),
      ("Slopes gave way under {name}'s town", "Landslide coverage kept {name}'s structures safe."),
      ("Mud and rock hit {name}'s sector", "Insurance softened the landslide impact for {name}."),
    ],
    DisasterType.massEmigration: [
      ("Citizens left, but stabilized, {name}!", "Insurance helped retain balance for {name}."),
      ("Emigration wave in {name}'s town", "Population loss insurance compensated {name}'s revenue drop."),
      ("Citizens departing {name}'s city!", "Insurance policy cushioned {name} from demographic shifts."),
      ("Mass exit, but {name} is covered", "Emigration insurance stabilized your city cashflow, {name}."),
      ("Population drop for {name}", "Insurance support arrived to balance {name}'s finances."),
    ],
    DisasterType.pandemic: [
      ("Pandemic hit, losses limited, {name}!", "Insurance kept operations running for {name}."),
      ("Health crisis in {name}'s city!", "Pandemic insurance protected {name}'s workforce yield."),
      ("Outbreak alert for {name}!", "Insurance covered business interruption in {name}'s city."),
      ("Virus spread, but {name} was covered", "Workforce policy minimized the impact on {name}'s industries."),
      ("Pandemic declared in {name}'s town", "Smart call! Business insurance cushioned the blow for {name}."),
    ],
  };

  static const Map<DisasterType, List<(String, String)>> disasterUninsured = {
    DisasterType.flood: [
      ("Flood hit the city, {name}!", "Water damage hurt {name} badly. No coverage found."),
      ("Water damage in {name}'s town", "Uninsured assets drowned. Tough luck for {name}!"),
      ("Flood emergency for {name}!", "Water swept away structures. {name} has no flood insurance."),
      ("Submerged city alert, {name}!", "Heavy rains destroyed unprotected structures in {name}'s city."),
      ("Water hit {name}'s city", "Wet ruins are all that's left. {name} should buy flood insurance next time."),
    ],
    DisasterType.fire: [
      ("Fire outbreak spread, {name}!", "Uninsured assets were lost. Fire hit {name} hard."),
      ("Assets burned down, {name}!", "No fire insurance coverage was found for {name}'s properties."),
      ("Smoke in {name}'s town!", "Structures turned to ash. Unprotected losses for {name}."),
      ("Fire disaster alert, {name}!", "A sudden blaze destroyed unprotected assets in {name}'s city."),
      ("Ash and smoke for {name}", "A massive fire took down structures. {name} had no fire coverage."),
    ],
    DisasterType.earthquake: [
      ("Earthquake damage severe, {name}!", "Structures failed without protection for {name}."),
      ("Ground shook under {name}!", "Uninsured buildings crumbled. Hard times for {name}."),
      ("Tremor hit {name}'s city!", "Major rubble. {name} has no earthquake insurance."),
      ("Seismic disaster alert, {name}!", "Unprotected structures collapsed. Heavy repair costs for {name}."),
      ("Rubbles in {name}'s town", "A powerful earthquake shattered buildings. {name} had no coverage."),
    ],
    DisasterType.economyCrash: [
      ("Market crash detected, {name}!", "No safety net. {name}'s income dropped hard."),
      ("Economic downturn for {name}!", "No financial insurance. Operations halted for {name}."),
      ("Bear market hit {name}'s city", "Unprotected income streams collapsed. Tough hit for {name}!"),
      ("Crash hit, and {name} is vulnerable", "No policy found. {name}'s revenues are down the drain."),
      ("Recession alert for {name}!", "Your city is bleeding cash. {name} has no economic crash coverage."),
    ],
    DisasterType.drought: [
      ("Drought strained the city, {name}!", "No coverage. Recovery will be slow for {name}."),
      ("Dry spell in {name}'s fields", "No agricultural insurance. Crops failed for {name}!"),
      ("Drought alert in {name}'s city!", "Water scarcity ruined assets. {name} has no drought coverage."),
      ("Water scarcity hit {name}'s area", "Dry fields and empty wells. Unprotected losses for {name}."),
      ("Dry land for {name}", "No crops, no yield. {name} needs drought insurance next time."),
    ],
    DisasterType.landslide: [
      ("Landslide impact severe, {name}!", "Expansion zones destroyed. Uninsured losses for {name}."),
      ("Mudslide in {name}'s zone!", "No geological insurance. Mud destroyed {name}'s property!"),
      ("Landslide alert in {name}'s city!", "Slopes collapsed on unprotected buildings of {name}."),
      ("Slopes gave way under {name}'s town", "Massive land damage. {name} has no landslide coverage."),
      ("Mud and rock hit {name}'s sector", "Debris blocked roads and broke structures. No insurance for {name}."),
    ],
    DisasterType.massEmigration: [
      ("Mass emigration underway, {name}!", "No protection. {name}'s income is falling fast."),
      ("Emigration wave in {name}'s town", "Unprotected population drop. Empty offices for {name}!"),
      ("Citizens departing {name}'s city!", "No safety net. Tax revenue collapsed for {name}."),
      ("Mass exit, and {name} is vulnerable", "Uninsured demographic shift. {name} is losing workers."),
      ("Population drop for {name}", "Empty streets and closed shops. {name} has no emigration coverage."),
    ],
    DisasterType.pandemic: [
      ("Pandemic outbreak spread, {name}!", "No coverage. {name}'s workforce collapsed."),
      ("Health crisis in {name}'s city!", "Unprotected business interruption. Zero production for {name}!"),
      ("Outbreak alert for {name}!", "Workforce sick and offline. {name} has no pandemic insurance."),
      ("Virus spread, and {name} is hit", "Uninsured losses. {name}'s city operations came to a halt."),
      ("Pandemic declared in {name}'s town", "Empty offices and stalled factories. Tough times for {name}."),
    ],
  };

  static const List<(String, String)> debtNotifications = [
    ("Hey {name}, watch your debt!", "Interest is compounding faster than {name}'s income."),
    ("Cash flow alert for {name}!", "Your expenses are piling up, {name}. Tighten your budget!"),
    ("Interest warning, {name}!", "Interest is stacking up in {name}'s account and won't resolve itself."),
    ("Is {name} overleveraged?", "Risk is currently outweighing reward. Balance your sheets, {name}."),
    ("Finances under pressure, {name}!", "Debt is pulling {name}'s city down. Focus on stability!"),
  ];

  static const List<(String, String)> foreclosureNotifications = [
    ("Foreclosure Alert for {name}!", "Your city is crumbling, {name}! {building} has been foreclosed due to unpaid debt."),
    ("{name}, a building was seized!", "Unpaid interest forced a foreclosure: {building} is no longer owned by {name}."),
    ("{building} was foreclosed!", "With too much debt, {name}'s building {building} has been auctioned off."),
    ("Bad news for {name}'s city", "{name}'s structure, {building}, has been seized to cover mounting interest."),
    ("Liquidation warning, {name}!", "{name}, your property {building} was foreclosed because debt limits were exceeded."),
  ];

  static const Map<String, List<(String, String)>> inactivityNotifications = {
    "2d": [
      ("{name}, your city is still here", "It kept running… without {name} watching."),
      ("Quiet streets for {name}", "No decisions made in 2 days. {name}, checking in?"),
      ("Checking on {name}'s progress", "Your assets are running on autopilot, {name}."),
      ("{name}, cash flow is piling up!", "Don't leave your money unattended, {name}."),
      ("A quick visit, {name}?", "Your city is waiting for {name}'s next direction."),
    ],
    "3d": [
      ("Things feel quieter, {name}", "No new decisions. {name}'s city has no direction."),
      ("Where is {name}?", "Three days of silence. The city needs {name}'s guidance."),
      ("Your strategy is stalling, {name}", "Don't let your progress slip away, {name}."),
      ("{name}, the city is waiting", "Decisions need to be made by {name} today."),
      ("Keep compounding, {name}!", "Three days offline. Come back and check your yield, {name}!"),
    ],
    "5d": [
      ("Growth slowed down, {name}", "The city misses {name}'s leadership and strategy."),
      ("{name}, the streets are empty", "Five days without {name}. The economy is stagnating."),
      ("Is {name} giving up?", "Five days offline. Keep building {name}'s empire!"),
      ("Don't pause now, {name}!", "Your passive income is waiting to be claimed, {name}."),
      ("{name}, leadership required!", "The city needs {name}'s vision to move forward."),
    ],
    "1w": [
      ("Your city feels abandoned, {name}", "Systems are drifting without {name}."),
      ("One week of silence, {name}", "Your buildings are getting dusty. Come back, {name}!"),
      ("{name}, your empire is waiting", "A whole week away. Don't lose your momentum, {name}!"),
      ("Economy alert for {name}!", "Your city needs active management, {name}. Open the app!"),
      ("{name}, remember your goals?", "One week ago, you were building wealth. Let's resume, {name}!"),
    ],
    "2w": [
      ("Decay has started, {name}", "Nothing lasts without care. Check {name}'s city!"),
      ("Two weeks away, {name}?", "Your financial empire is slowly slipping into stagnation."),
      ("{name}, your citizens are worried", "No leadership for 14 days. Re-establish control, {name}!"),
      ("Time is running, {name}", "Don't let your hard work decay. Return to your city, {name}!"),
      ("{name}, wealth needs attention", "Your assets are crying out for {name}'s direction."),
    ],
    "1m": [
      ("The city is barely holding on, {name}", "It remembers when {name} used to lead it to glory."),
      ("One month offline, {name}!", "Is this the end of {name}'s financial journey?"),
      ("A forgotten empire, {name}?", "Your city is a ghost town. Bring it back to life, {name}!"),
      ("{name}, your legacy is fading", "One month of inactivity. Rebuild your dream, {name}!"),
      ("Reset or resume, {name}?", "Your city is waiting for {name}'s return. Don't quit now!"),
    ],
  };

  static const List<(String, String)> newQuizNotifications = [
    ("Morning update for {name}!", "A new Daily Financial Challenge is ready for {name}. Start your day with a win!"),
    ("Rise and shine, {name}!", "Your Daily Quiz is waiting, {name}. Test your financial knowledge today!"),
    ("{name}, ready to earn KP today?", "A new financial challenge is ready. Solve it and grow {name}'s city!"),
    ("Daily Challenge is active, {name}!", "Don't miss out on today's quiz, {name}. Knowledge is wealth!"),
    ("Financial workout for {name}", "Keep that brain sharp, {name}. The Daily Quiz is live now!"),
  ];

  static const List<(String, String)> morningQuizNotifications = [
    ("Good morning, {name}! ☀️", "Your daily quiz is ready, {name}. Answer it to earn valuable KP!"),
    ("Time to wake up, {name}! ☕", "Start the day by building {name}'s financial knowledge. The quiz is live!"),
    ("New day, new quiz for {name}!", "Another opportunity to boost {name}'s streak and knowledge. Play now!"),
    ("{name}, your morning quiz is here!", "Earn more KP today to expand {name}'s city. Check it out!"),
    ("Wakey wakey, {name}! ⏰", "Ready for today's challenge, {name}? Complete it to earn rewards!"),
  ];

  static const Map<String, List<(String, String)>> challengeReminderWithRevival = {
    "6h": [
      ("Daily Challenge Reminder", "Only 6 hours left, {name}! Complete the daily challenge to avoid consuming a revival."),
      ("Revival warning for {name}", "Clock is ticking, {name}! 6 hours remaining to protect your revival."),
      ("{name}, don't lose your revival!", "6 hours left to attempt the daily challenge before your revival is consumed."),
      ("Daily Quiz alert, {name}!", "Attempt the daily quiz in the next 6 hours to save {name}'s revival."),
      ("Time is running out, {name}", "6 hours left, {name}! Protect your revival by playing the daily challenge."),
    ],
    "2h": [
      ("Daily Challenge Reminder", "2 hours remaining, {name}! Your daily revival will be consumed if you don't attempt the challenge."),
      ("Revival alert for {name}!", "Only 2 hours left! Your revival will be consumed tonight, {name}."),
      ("{name}, attempt the challenge!", "2 hours to go! Complete the daily challenge to protect your revival, {name}."),
      ("Urgent revival warning, {name}", "Just 2 hours left for {name} to play today's quiz and save a revival!"),
      ("{name}, clock is ticking!", "Your revival is about to be consumed in 2 hours. Play now, {name}!"),
    ],
    "1h": [
      ("Daily Challenge Reminder", "1 hour left, {name}! Don't let your revival go to waste. Complete the daily challenge now!"),
      ("Critical revival warning, {name}!", "Only 1 hour left! Save your revival by completing the challenge, {name}."),
      ("{name}, last hour!", "1 hour remaining! Play the daily challenge now to preserve your revival, {name}."),
      ("Revival at risk, {name}!", "60 minutes left! Don't let your revival be consumed tonight, {name}."),
      ("{name}, act fast!", "Only 1 hour before your revival is consumed. Attempt the quiz now, {name}!"),
    ],
    "15m": [
      ("Daily Challenge Reminder", "Last 15 minutes, {name}! Your revival is about to be consumed. Play now!"),
      ("Final warning, {name}!", "Only 15 minutes left! Play the daily challenge to save your revival, {name}!"),
      ("{name}, 15 minutes remaining!", "Your revival will be consumed in 15 minutes. Save it now, {name}!"),
      ("Emergency alert, {name}!", "Last chance! 15 minutes to save your revival from being consumed, {name}."),
      ("{name}, play immediately!", "Only 15 minutes left! Don't let your revival be consumed tonight, {name}!"),
    ],
  };

  static const Map<String, List<(String, String)>> challengeReminderNoRevival = {
    "6h": [
      ("Daily Challenge Streak Warning", "Only 6 hours left, {name}! Complete the daily challenge to protect your {streak}-day streak."),
      ("Streak in danger, {name}!", "6 hours remaining to keep {name}'s {streak}-day streak alive!"),
      ("{name}, save your {streak}-day streak!", "6 hours left to attempt the daily challenge before your streak is reset."),
      ("Daily Quiz alert, {name}!", "Attempt the daily quiz in the next 6 hours to save {name}'s {streak}-day streak."),
      ("Time is running out, {name}", "6 hours left, {name}! Keep your {streak}-day streak going by playing now."),
    ],
    "2h": [
      ("Daily Challenge Streak Warning", "2 hours remaining, {name}! You will lose your {streak}-day streak if you don't attempt the challenge."),
      ("Streak alert for {name}!", "Only 2 hours left! Your {streak}-day streak will be reset tonight, {name}."),
      ("{name}, attempt the challenge!", "2 hours to go! Complete the daily challenge to protect your {streak}-day streak, {name}."),
      ("Urgent streak warning, {name}", "Just 2 hours left for {name} to play today's quiz and save your {streak}-day streak!"),
      ("{name}, clock is ticking!", "Your {streak}-day streak will be reset in 2 hours. Play now, {name}!"),
    ],
    "1h": [
      ("Daily Challenge Streak Warning", "1 hour left, {name}! Don't lose your {streak}-day streak. Complete the daily challenge now!"),
      ("Critical streak warning, {name}!", "Only 1 hour left! Save your {streak}-day streak by completing the challenge, {name}."),
      ("{name}, last hour!", "1 hour remaining! Play the daily challenge now to preserve your {streak}-day streak, {name}."),
      ("Streak at risk, {name}!", "60 minutes left! Don't let your {streak}-day streak reset tonight, {name}."),
      ("{name}, act fast!", "Only 1 hour before your {streak}-day streak is reset. Attempt the quiz now, {name}!"),
    ],
    "15m": [
      ("Daily Challenge Streak Warning", "Last 15 minutes, {name}! Play the daily challenge now to keep your {streak}-day streak alive!"),
      ("Final warning, {name}!", "Only 15 minutes left! Play the daily challenge to save your {streak}-day streak, {name}!"),
      ("{name}, 15 minutes remaining!", "Your {streak}-day streak will reset in 15 minutes. Save it now, {name}!"),
      ("Emergency alert, {name}!", "Last chance! 15 minutes to save {name}'s {streak}-day streak from resetting."),
      ("{name}, play immediately!", "Only 15 minutes left! Don't let your {streak}-day streak reset tonight, {name}!"),
    ],
  };

  // Original list kept for compatibility
  static const List<(String, String)> dailyQuiz = [
    ("New Daily Quiz!", "A new challenge is available. Master your money today!"),
    ("Today's Quiz is Here", "Test your financial knowledge and earn KP."),
    ("Don't Miss Today's Quiz", "Keep your streak alive and grow your city."),
    ("Knowledge is Wealth", "Your daily quiz is ready for you."),
  ];

  static (String, String) getRandomDisasterNotification(String name, DisasterType type, bool insured) {
    final list = insured ? disasterInsured[type]! : disasterUninsured[type]!;
    final choice = _randomElement(list);
    return (_format(choice.$1, {'name': name}), _format(choice.$2, {'name': name}));
  }

  static (String, String) getRandomDebtNotification(String name) {
    final choice = _randomElement(debtNotifications);
    return (_format(choice.$1, {'name': name}), _format(choice.$2, {'name': name}));
  }

  static (String, String) getRandomForeclosureNotification(String name, String buildingName) {
    final choice = _randomElement(foreclosureNotifications);
    return (_format(choice.$1, {'name': name, 'building': buildingName}), _format(choice.$2, {'name': name, 'building': buildingName}));
  }

  static (String, String) getRandomInactivityNotification(String name, String interval) {
    final list = inactivityNotifications[interval] ?? inactivityNotifications["2d"]!;
    final choice = _randomElement(list);
    return (_format(choice.$1, {'name': name}), _format(choice.$2, {'name': name}));
  }

  static (String, String) getRandomNewQuizNotification(String name) {
    final choice = _randomElement(newQuizNotifications);
    return (_format(choice.$1, {'name': name}), _format(choice.$2, {'name': name}));
  }

  static (String, String) getRandomDailyMorningNotification(String name) {
    final choice = _randomElement(morningQuizNotifications);
    return (_format(choice.$1, {'name': name}), _format(choice.$2, {'name': name}));
  }

  static (String, String) getRandomChallengeReminder(String name, int streak, int revivals, String timeLeft) {
    if (revivals > 0) {
      final list = challengeReminderWithRevival[timeLeft] ?? challengeReminderWithRevival["6h"]!;
      final choice = _randomElement(list);
      return (_format(choice.$1, {'name': name}), _format(choice.$2, {'name': name}));
    } else {
      final list = challengeReminderNoRevival[timeLeft] ?? challengeReminderNoRevival["6h"]!;
      final choice = _randomElement(list);
      return (_format(choice.$1, {'name': name, 'streak': streak.toString()}), _format(choice.$2, {'name': name, 'streak': streak.toString()}));
    }
  }

  static (String, String) getRandomDailyGeneralNotification(String name) {
    final choice = _randomElement(dailyGeneral);
    return (_format(choice.$1, {'name': name}), _format(choice.$2, {'name': name}));
  }
}
