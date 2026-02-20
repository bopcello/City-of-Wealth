import '../game_state.dart';

class NotificationData {
  static const List<(String, String)> dailyGeneral = [
    ("Your city awaits you", "Things don’t grow unless someone’s watching."),
    ("Quiet progress happening", "Your assets are still working."),
    ("Money moved today", "Passive income just ticked in."),
    ("Small systems, big results", "Compounding doesn’t announce itself."),
    ("Your city feels stable", "That didn’t happen by accident."),
    ("Assets reporting in", "They did their job today."),
    ("Growth update", "Slow. Steady. Real."),
    ("Another income cycle complete", "Numbers look healthier."),
    ("Your city is breathing", "Cash flow is steady… for now."),
    ("Momentum building", "The curve is starting to bend."),
    ("Nothing flashy today", "Still richer than yesterday."),
    ("The system is learning", "And so are you."),
    ("Your strategy is holding", "Stability feels good."),
    ("Foundations look solid", "Expansion is safer now."),
    ("Your city is patient", "Wealth rewards patience too."),
    ("No emergencies today", "That’s a win."),
    ("Assets stayed productive", "Even without new input."),
    ("Another quiet win", "Those add up."),
    ("Your city trusts you", "Don’t disappear."),
    ("Ready to master money today?", "One decision can change everything."),
  ];

  static const Map<DisasterType, (String, String)> disasterInsured = {
    DisasterType.flood: (
      "Flood hit the city",
      "Insurance softened the damage. Smart call.",
    ),
    DisasterType.fire: (
      "Fire outbreak contained",
      "Insurance prevented major losses.",
    ),
    DisasterType.earthquake: (
      "Earthquake shock absorbed",
      "Insurance kept the city standing.",
    ),
    DisasterType.economyCrash: (
      "Market crash detected",
      "Insurance stabilized income streams.",
    ),
    DisasterType.drought: (
      "Drought slowed production",
      "Insurance eased long-term impact.",
    ),
    DisasterType.landslide: (
      "Landslide contained",
      "Insurance reduced terrain losses.",
    ),
    DisasterType.massEmigration: (
      "Citizens left, but stabilized",
      "Insurance helped retain balance.",
    ),
    DisasterType.pandemic: (
      "Pandemic hit, losses limited",
      "Insurance kept operations running.",
    ),
  };

  static const Map<DisasterType, (String, String)> disasterUninsured = {
    DisasterType.flood: (
      "Flood hit the city",
      "Water damage hurt badly. No coverage found.",
    ),
    DisasterType.fire: ("Fire outbreak spread", "Uninsured assets were lost."),
    DisasterType.earthquake: (
      "Earthquake damage severe",
      "Structures failed without protection.",
    ),
    DisasterType.economyCrash: (
      "Market crash detected",
      "No safety net. Income dropped hard.",
    ),
    DisasterType.drought: (
      "Drought strained the city",
      "No coverage. Recovery will be slow.",
    ),
    DisasterType.landslide: (
      "Landslide impact severe",
      "Expansion zones destroyed.",
    ),
    DisasterType.massEmigration: (
      "Mass emigration underway",
      "No protection. Income is falling.",
    ),
    DisasterType.pandemic: (
      "Pandemic outbreak spread",
      "No coverage. Workforce collapsed.",
    ),
  };

  static const List<(String, String)> debtNotifications = [
    ("Debt is growing quietly", "It compounds faster than income."),
    ("Cash flow feels tight", "Expansion may have gone too far."),
    ("Interest is stacking up", "This won’t fix itself."),
    ("Leverage warning", "Risk is outweighing reward."),
    ("Debt is pulling you down", "Stability needs attention."),
  ];

  static const Map<String, (String, String)> inactivityNotifications = {
    "2d": ("Your city is still here", "It kept running… without you."),
    "3d": ("Things feel quieter", "No new decisions. No direction."),
    "5d": ("Growth slowed", "The city misses leadership."),
    "1w": ("Your city feels abandoned", "Systems are drifting."),
    "2w": ("Decay has started", "Nothing lasts without care."),
    "1m": (
      "The city is barely holding on",
      "It remembers when you used to lead.",
    ),
  };
}
