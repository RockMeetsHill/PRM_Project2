# Journal Trend Analyzer - Project Summary

## Project Overview
**Journal Trend Analyzer** is a Flutter mobile application designed for scientific trend analysis. It retrieves publication, author, and journal data (configured for "Artificial Intelligence") and displays dashboards, search interfaces, details, and charts.

## Folder Structure and Responsibilities
- `INSTRUCTIONS.md`: Step-by-step setup guide for running and building the app.
- `lib/models/`: Data models (`publication.dart`, `author.dart`, `journal.dart`).
- `lib/theme/`: Custom application themes and color schemes (`app_theme.dart`).
- `lib/mock/`: Mock data definitions (`mock_data.dart`).
- `lib/router/`: GoRouter navigation configuration (`app_router.dart`).
- `lib/widgets/`: Reusable widgets used across screens (e.g., `publication_card.dart`, `stat_card.dart`, `trend_chart.dart`, `loading_skeleton.dart`).
- `lib/screens/`: Screens for navigation:
  - `search_screen.dart`
  - `trend_analysis_screen.dart`
  - `dashboard_screen.dart`
  - `publication_detail_screen.dart`

## Key Dependencies
- `go_router`: Routing and navigation.
- `fl_chart`: Bar chart for trend analysis.
- `shimmer`: Shimmer skeleton loading effect.
- `google_fonts`: Poppins font loading.

## Coding Conventions
- Consistent material 3 design.
- Separation of concerns: models, router, widgets, screens.
- Use `const` constructors where possible.
