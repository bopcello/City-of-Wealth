# City of Wealth 💎 - Version 3.2.0 Release Notes

**Release Date:** August 29, 2026  
**Previous Baseline:** v2.0.2  
**Target Version:** v3.2.0  

---

## 🌟 Executive Summary

Welcome to **City of Wealth v3.2.0**! This flagship release represents a massive evolution from version 2.0.2, bringing major architectural upgrades, automated native Windows installation capabilities, cutting-edge AI features, real-time social integration, and an updated modern toolchain across Android and Windows desktop platforms.

Highlights of this release include:
1. **Automated Windows MSI Installer**: Running `flutter build windows` now automatically packages a production-ready Windows MSI Installer using WiX Toolset.
2. **Java 21 & AGP 9.0+ Toolchain**: Full upgrade to JDK 21, AGP 9.0.0, Gradle 9.1.0, and Kotlin 2.2.0 with desugaring enabled.
3. **Nemotron Ultra 3 and 2 fallback AI models for Daily Quiz Pipeline**: Automated daily financial literacy question generation powered by OpenRouter API & Google Nemotron Ultra 3 with search grounding and topic deduplication.
4. **Isometric City Render Engine & Friend Viewer**: High-precision grid renderer with live friend city inspection.
5. **Background Social Activity Monitor**: Real-time background notifications and social cheer tracking using WorkManager.

---

## 🚀 Key Highlights & New Features (v2.0.2 ➔ v3.2.0)

### 📦 1. Automated Windows Packaging & MSI Installer Engine
- **WiX Packaging Integration**: Integrated WiX 3.11 standalone toolset for generating native, enterprise-grade `.msi` setup packages.
- **One-Command Build Pipeline**: Configured CMake build rules (`windows/CMakeLists.txt`) so that invoking `flutter build windows` automatically compiles the binary and triggers `scripts/build_msi.ps1` to produce `CityOfWealth_v3.2.0_Setup.msi`.
- **Harvesting & Component Clean-up**: Utilizes `heat.exe` to harvest output bundle assets while stripping unwanted static libraries (`.lib`, `.exp`).
- **Custom Managed Action**: Built a native C# Custom Action (`BrowseFolderCA.cs`) compiled with `csc.exe` and packaged with `MakeSfxCA.exe` for seamless modern directory selection.
- **Branded Install Visuals**: Embedded custom installation artwork (`bannrbmp.bmp`, `dlgbmp.bmp`), shortcut creation prompts, and clean uninstaller registration.

---

### ⚡ 2. Modern Android Toolchain Upgrade (JDK 21 & AGP 9.0+)
- **Java 21 Compatibility**: Upgraded Java runtime requirements from Java 17 to **JDK 21** (`JavaVersion.VERSION_21` and `JvmTarget.JVM_21`).
- **Android Gradle Plugin 9.0.0**: Upgraded AGP build plugins and Gradle Wrapper to `v9.1.0` with Foojay Java toolchain auto-provisioning.
- **Java Core Library Desugaring**: Enabled `com.android.tools:desugar_jdk_libs:2.1.4` to support modern Java APIs on older Android API levels.
- **Firebase BoM 34.9.0**: Updated Firebase Android BoM dependencies across Authentication, Cloud Firestore, and App Check.
- **Split-ABI APK Build Scripting**: Added automated `copyReleaseApks` task to rename and separate output binaries for `arm64-v8a`, `armeabi-v7a`, and `x86_64`.

---

### 🤖 3. AI-Powered Daily Quiz Pipeline (OpenRouter + Gemini 2.0 Flash)
- **Automated GitHub Actions Cron**: Daily workflow (`.github/workflows/daily-question.yml`) executing at 18:30 UTC / 00:00 IST (`30 18 * * *`).
- **Search-Grounded AI Generation**: Uses OpenRouter API (`google/gemini-2.0-flash-001`) with web search grounding to generate contextual, up-to-date financial literacy questions.
- **Topic De-duplication**: The worker script (`scripts/daily_quiz_generator.js`) fetches the prior 30 daily quizzes from Cloud Firestore and prompts Gemini to avoid repeating topics or questions.
- **Practice Mode Bank**: Integrated 30-day historical quiz retrieval in `quiz_screen.dart` allowing players to replay past quizzes and earn Knowledge Points (KP).

---

### 🏙️ 4. Isometric City Render Engine & Friend City Viewer
- **Isometric Board Renderer**: Implemented grid-to-screen coordinate translation for 2D isometric rendering of player properties (Farms, Factories, Apartments, Xerox Shops, Insurance Centers).
- **Interactive Structure Controls**: Place, inspect, upgrade, and repair income-generating structures.
- **Friend City Viewer (`city_viewer_screen.dart`)**: View friends' cities in real time, inspect building levels, view active disaster statuses, and send celebratory cheers directly from their city map.

---

### 👥 5. Social Ecosystem, Activity Feed & Leaderboard
- **Cloud Firestore Friend Graph**: Real-time friend search by friend code or display name (`friends_service.dart`).
- **Activity Feed (`activity_feed_screen.dart`)**: Live chronological stream showing friends' level-ups, building achievements, disaster recoveries, and cheer interactions.
- **Social Leaderboard (`leaderboard_screen.dart`)**: Competitive friend leaderboards ranked by total Knowledge Points (KP) and daily quiz streaks.
- **Friend Cheers**: Send daily cheers to boost friends' morale and earn bonus streak protection.

---

### 🔔 6. Background Activity Monitor & Intelligent Push Notifications
- **WorkManager Background Service**: Integrated `FriendActivityMonitor` for background execution via `workmanager` (`^0.6.0`).
- **Local Notifications**: Powered by `flutter_local_notifications` (`^20.0.0`) for real-time notification alerts.
- **Smart Notification Channels**: Dedicated notification categories for daily quiz reminders, streak danger alerts, and friend cheers.

---

### 📊 7. Financial Engine, Disaster System & Insurance
- **Centralized Game Loop (`GameManager`)**: 5-second tick clock orchestrating daily asset yields, debt interest, rent, tax calculations, and net worth updates.
- **Dynamic Disasters (`DisasterResult`)**: Random natural and economic events (Floods, Fires, Earthquakes, Market Crashes, Droughts, Landslides, Pandemics).
- **Insurance Coverage**: Insurance Centers provide payout recovery for damaged buildings and lost assets during disasters.
- **Career Tracks & Assets**: Student, Employee, and Entrepreneur career paths with progressive income caps and asset unlocks.

---

### 🎨 8. UI/UX Polish, Micro-Animations & Audio Engine
- **Celebratory Popups**: Level-up popups featuring particle burst animations and fanfare.
- **Shiny UI Buttons & Micro-Animations**: Enhanced tactile feedback with `shiny_button.dart` and responsive card hover states.
- **Custom Audio Engine**: Dual-channel `MusicManager` and `SfxManager` using `audioplayers` (`^6.5.1`).
- **User Avatar Support**: Profile avatar selection and customization using `image_picker` (`^1.2.1`).

---

## 🛠️ Full Changelog (v2.0.2 ➔ v3.2.0)

| Commit/Feature Area | Description |
| :--- | :--- |
| **Windows Build** | Added WiX 3.11 packaging pipeline script `scripts/build_msi.ps1`. |
| **Windows Build** | Attached CMake `install(CODE ...)` hook in `windows/CMakeLists.txt` for automatic MSI generation during `flutter build windows`. |
| **Windows Installer** | Created native C# custom action `BrowseFolderCA.cs` for modern folder browsing in MSI installer. |
| **Android Build** | Upgraded Android build toolchain to Java 21 (`JDK 21`) and AGP `9.0.0`. |
| **Android Build** | Configured Gradle Wrapper `9.1.0` and Kotlin `2.2.0` with `JVM_21` target. |
| **Android Build** | Enabled core library desugaring with `com.android.tools:desugar_jdk_libs:2.1.4`. |
| **Android Build** | Added split-per-ABI release configuration and `copyReleaseApks` task. |
| **Backend & AI** | Integrated OpenRouter API (`google/gemini-2.0-flash-001`) for daily quiz generation. |
| **Backend & AI** | Added GitHub Actions workflow `.github/workflows/daily-question.yml` for automated cron quiz generation. |
| **Backend & AI** | Built 30-day quiz deduplication logic in `scripts/daily_quiz_generator.js`. |
| **Social** | Implemented Firestore real-time friendship graph and search in `friends_service.dart`. |
| **Social** | Built interactive friend city viewer in `city_viewer_screen.dart`. |
| **Social** | Added activity feed screen `activity_feed_screen.dart` and social leaderboard `leaderboard_screen.dart`. |
| **Notifications** | Integrated WorkManager background worker `friend_activity_monitor.dart`. |
| **Notifications** | Upgraded `flutter_local_notifications` to `^20.0.0` with custom notification channels. |
| **UI Engine** | Re-designed isometric board renderer for city grid in `city_tab.dart`. |
| **UI Engine** | Added level-up celebration popup modals and micro-animated `shiny_button.dart`. |
| **Audio Engine** | Upgraded `audioplayers` to `^6.5.1` with separate background music and SFX managers. |
| **Security** | Hardened Firestore anti-enumeration rules in `firestore.rules`. |

---

## 💻 Installation & Upgrade Instructions

### For Windows Desktop Users
1. Download `CityOfWealth_v3.2.0_Setup.msi`.
2. Double-click the `.msi` installer.
3. Follow the installation wizard to select install directory and create desktop shortcuts.
4. Launch **City of Wealth** from your Start Menu or Desktop.

### For Developers & Maintainers
To build the Windows binary and generate the MSI installer in a single command:
```powershell
flutter build windows
```
The output MSI installer will be produced at:
`build\windows\x64\runner\Release\CityOfWealth_v3.2.0_Setup.msi`

To build split Android APKs:
```bash
flutter build apk --split-per-abi
```

---

*City of Wealth v3.2.0 - Empowering Financial Literacy Through Gameplay.* 💎
