# City of Wealth

**City of Wealth** is a Flutter-based idle/simulation game where players manage a career, assets, and a growing city.
This document provides a comprehensive overview for developers and AI agents working on the codebase.

---

## 🤖 For AI Agents: Start Here

### Project Context
- **Type**: Mobile Game (Android/iOS)
- **Framework**: Flutter (Dart)
- **State Management**: Lifted State Up pattern (Centralized in `MainScreen`).
- **Persistence**: `shared_preferences` with JSON serialization.

### File Map
| Path | Purpose |
| :--- | :--- |
| **`lib/main.dart`** | **Entry Point & Core Loop**. Contains `MainScreen`, `_checkDailyCycle`, and holds the source of truth for all game state variables. **Start here to understand the game loop.** |
| **`lib/game_state.dart`** | **Data Models & Logic**. Defines `CareerState`, `AssetInventory`, `Building`, `AssetType`, `CareerTrack`, etc. Contains `saveGameState`/`loadGameState` and income calculation logic (`dailyIncome`). |
| **`lib/tabs/city_tab.dart`** | **City View**. Handles the isometric grid rendering (`_IsometricGrid`), building placement, and the "Keystone" logic. Uses a **centered coordinate system** (0,0 is center). |
| **`lib/tabs/money_tab.dart`** | **Financial Hub**. UI for managing Assets, Liabilities, Insurance, and Bankruptcy. Navigates to sub-screens in `lib/screens/`. |
| **`lib/tabs/home_tab.dart`** | **Dashboard**. Displays summary stats, recent events log, and current lifestyle choices. |
| **`lib/tabs/settings_tab.dart`**| **Debug & Settings**. Contains cheat buttons (Add Money, Reset). |

---

## 🏗️ Architecture & Core Systems

### 1. State Management
All critical state (`gems`, `kp`, `career`, `cityLayout`, `assets`, `insurances`) is held in `_MainScreenState` within `lib/main.dart`.
- **Modifications**: Child widgets (Tabs) receive callbacks (e.g., `onBuyAsset`, `onPlaceBuilding`) to request state changes.
- **Updates**: `setState()` is called in `MainScreen` to rebuild the UI and trigger `_save()`.

### 2. Time & Income Cycle
The game runs on a timer (default: **10 seconds per cycle**).
- **Logic**: `_checkDailyCycle` in `main.dart`.
- **Process**:
    1.  Calculates `dailyIncome` based on `CareerTrack` and `Level`.
    2.  Deducts expenses (Rent, Food, Transport, Maintenance, Insurance).
    3.  Updates `gems` and `kp`.
    4.  Logs events to `_pendingEvents` (displayed in Home Tab).

### 3. Coordinate System (City)
The city grid uses a **Centered Coordinate System**.
- **Origin**: `(0, 0)` is the center tile of the grid.
- **Expansion**: As `gridSize` increases (odd numbers: 3x3, 5x5...), the grid expands outwards in all directions.
- **Rendering**: `_IsometricGrid` in `city_tab.dart` handles the conversion from (x,y) to screen coordinates.
- **Wall**: A decorative wall (image asset) is rendered behind the grid if `hasWall` is true (unlocked via "The Keystone").

### 4. Economy & Debt
- **Assets**: Generate net worth and are required for certain buildings.
- **Liabilities**: Recurring costs that affect happiness/KP gain.
- **Debt**:
    -   If `gems < 0`, the player enters "Debt Mode".
    -   **Grace Period**: 30 cycles (approx 5 mins).
    -   **Consequence**: After 30 cycles, buildings are randomly destroyed (`_checkDailyCycle` logic).
    -   **Bankruptcy**: Players can reset progress to clear debt via `MoneyTab` -> `LiabilitiesScreen`.

---

## 🧩 Data Models (`game_state.dart`)

### `CareerState`
Tracks the player's path:
-   `track`: `CareerTrack.student`, `job`, or `business`.
-   `level`: 1 to 5.
-   Income scales with level.

### `AssetInventory`
A map of `AssetType` to count:
-   `land`, `realEstate`, `machinery`, `vehicles`, `officeEquipment`.
-   Used for building requirements and net worth.

### `PlacedBuilding`
Represents a building on the grid:
-   `name`: ID of the building type.
-   `x`, `y`: Coordinates on the centered grid.

---

## 🛠️ Development Guide

### Adding a New Building
1.  Define it in `buildings` list in `lib/game_state.dart` with name, track, level, and resource requirements.
2.  If it has special logic (like "The Keystone"), update `_BuildingCard` in `city_tab.dart`.

### adding a New Asset
1.  Add enum value to `AssetType` in `lib/game_state.dart`.
2.  Update `assetCosts`, `assetSellingPrices`, and `assetLabel` maps.
3.  Add icon/logic in `AssetScreen` if necessary (handled dynamically).

### Debugging
-   **Income Pause**: Toggle in `HomeTab` to stop the 10s cycle.
-   **Cheats**: enable in `SettingsTab` to add money or reset save.

---

## 📦 Assets & Resources
-   **Images**: Stored in `lib/assets/`.
-   **Configuration**: `pubspec.yaml` must reference `lib/assets/` or specific files.
-   **Wall Texture**: `lib/assets/image-removebg-preview.png`.
