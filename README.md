# City of Wealth 💎

A premium isometric idle-simulation game built with Flutter. Manage your career, build a sprawling city, and navigate the risks of a dynamic economy.

## 🚀 How to Run
To run this game on any device (Android, iOS, or Web):
1. **Clone the Repo**: `git clone [repository-url]`
2. **Install Flutter**: Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
3. **Get Dependencies**: Run `flutter pub get` in the project root.
4. **Run**: Use `flutter run` (or `flutter run -d chrome` for web).

---

## 🎮 Game Mechanics

### 1. Career Tracks & Progression
Rise from a **Student** to the top of your field.
- **Job Track**: Stable income scaling through professional levels.
- **Business Track**: High-risk, high-reward entrepreneurship.
- **Progression**: Earn Knowledge Points (KP) through Quizzes and Level Up to unlock new buildings and luxuries.

### 2. Assets & Financial Management
Manage your net worth across five asset categories:
- **Land**, **Properties**, **Vehicles**, **Machinery**, and **Office Equipment**.
- **Expenses**: Balance your lifestyle with Rent, Food, and Transport choices. Be careful—unnecessary assets at lower levels incur KP penalties!
- **Debt & Bankruptcy**: If your Gems fall below zero, you enter debt. Fail to clear it in 30 cycles, and your buildings will be foreclosed. Bankruptcy resets progress but clears your debts.

### 3. Passive Income System 🏗️
Invest your hard-earned assets into specialized buildings to generate recurring wealth:
- **Farms**: Requires Land.
- **Factories**: Requires Machinery.
- **Apartments**: Requires Properties.
- **Goods Exchange**: Requires Vehicles.
- **Xerox Shops**: Requires Office Equipment.
*Buildings will only generate income if you own enough raw assets to support the investment!*

### 4. Dynamic Disaster System 🌪️
The city is prone to random disasters that challenge your financial stability:
- **Asset Disasters** (Flood, Fire, Earthquake): Target specific physical assets, destroying up to 50% of your holdings.
- **Passive Income Disasters** (Drought, Pandemic, Economy Crash, etc.): Reduce income yields for 30 cycles and may deactivate investment units.
- **Building Removal**: Buildings are no longer destroyed randomly. They are removed **only** if their associated passive income units hit zero.

### 5. Insurance & Protection 🛡️
Protect your empire!
- **Insurance**: Purchase coverage for specific asset types to receive an **80% payout** on lost values during disasters.
- **KP Penalty**: Players without insurance suffer significant KP losses during catastrophes.

### 6. The Keystone
The ultimate goal. Unlock the **Keystone** building at Level 5 by securing all five insurances to solidify your legacy and build the Great Wall of Wealth.

---

## 🏗️ Technical Overview
- **Framework**: Flutter (Dart)
- **Engine**: Custom Isometric Grid using Centered Coordinates.
- **State**: Centralized `GameManager` (ChangeNotifier) with `SharedPreferences` persistence.
- **Cycle Speed**: 5 seconds per game "day".
