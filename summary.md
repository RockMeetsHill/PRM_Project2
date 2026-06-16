# Project Summary: RockMeetsHill/PRM_Project2

## High-level project overview
This project is a Flutter application called **journaltrend** developed for Android and Windows. It features tools for searching, mock data, and various UI screens.

## Folder structure and responsibilities
* `journaltrend/`: The root directory of the Flutter project.
  * `lib/`: Contains Flutter/Dart code.
    * `main.dart`: Entry point of the application.
    * `models/`: Data models.
    * `providers/`: State management / data providers.
      * `search_provider.dart`: Fetches publications and formats computed data points.
    * `screens/`: UI screen layouts (e.g., search, dashboard, trends screens).
      * `trend_analysis_screen.dart`: Tabbed view displaying four interactive diagrams.
    * `services/`: API or database services.
  * `android/`: Android-specific native wrapper and gradle build configuration.

## State management approach
Uses standard Flutter providers or stateful widgets (as structured in `lib/providers`).

## Key dependencies
* Flutter SDK
* `fl_chart`: For rendering interactive, smooth diagrams.
* `google_fonts`: For modern typography (Outfit and Inter).
* `shimmer`: For premium loading skeletons.
* Kotlin (configured via Kotlin Gradle Plugin in Android)
* Android Gradle Plugin (AGP) 9.0.1+

## Visual System & Theme
* Custom slate-based Dark Theme.
* Glassmorphism card overlays.
* Interactive tooltips on charts.
