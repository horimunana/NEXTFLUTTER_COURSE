# Recipe App 🍕

A multi-screen **pizza recipes** Flutter application built to demonstrate navigation, state management, theming, responsive layouts, and clean UI/data separation.

> Built with **Flutter** and **GoRouter**.

---

## ✨ Features

- **5 distinct screens** with navigation via **GoRouter named routes**
  - 🏠 **Home** — recipe list with live **search** and **category filter**
  - 📄 **Detail** — full recipe with ingredients, steps, and stats (parameter passing via `/recipe/:id`)
  - ❤️ **Favorites** — save and browse your favorite recipes
  - ➕ **Add Recipe** — validated form to create a new recipe
  - ℹ️ **About** — app info and capabilities
- 🌗 **Light / Dark theme** with a toggle in the app bar
- 📱 **Responsive** — adaptive grid (mobile → tablet → desktop)
- 🧩 **Reusable widgets** in `lib/widgets/`
- 🗂️ **UI / data separation** — all data comes from mock JSON in `assets/data/`, loaded by a service
- ✅ **Form validation** on every field

---

## 🖼️ Screenshots

> Add your screenshots here. Place image files in a `screenshots/` folder and reference them like below.

| Home | Detail | Dark mode |
|------|--------|-----------|
| ![Home](screenshots/home.png) | ![Detail](screenshots/detail.png) | ![Dark](screenshots/dark.png) |

| Favorites | Add Recipe | About |
|-----------|------------|-------|
| ![Favorites](screenshots/favorites.png) | ![Add Recipe](screenshots/add.png) | ![About](screenshots/about.png) |

---

## 🧱 Project Structure

```
lib/
├── main.dart                      # App entry, theme toggle
├── config/
│   ├── app_config.dart            # App name / constants
│   ├── app_router.dart            # GoRouter named routes
│   └── app_theme.dart             # Light & dark themes
├── core/
│   ├── models/recipe.dart         # Recipe model
│   ├── services/recipe_service.dart  # Loads mock JSON from assets
│   └── stores/recipe_store.dart   # State (recipes + favorites)
├── features/
│   ├── home/presentation/         # Home list (search + filter)
│   ├── detail/presentation/       # Recipe detail
│   ├── favorites/presentation/    # Favorites grid
│   ├── form/presentation/         # Add-recipe validated form
│   └── about/presentation/        # About screen
├── responsive/responsive_builder.dart  # Mobile/tablet/desktop
└── widgets/                       # Reusable widgets
    ├── recipe_card.dart
    ├── search_bar_widget.dart
    ├── stats_chip.dart
    └── section_header.dart
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x or later)
- [Dart SDK](https://dart.dev/get-dart)
- A device, emulator, or simulator

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/horimunana/NEXTFLUTTER_COURSE.git
cd NEXTFLUTTER_COURSE/first_appli

# 2. Get dependencies (includes GoRouter)
flutter pub get

# 3. Run the app
flutter run
```

### Run on a specific platform

```bash
# iOS simulator
flutter run -d ios

# Android emulator
flutter run -d android

# Chrome (web)
flutter run -d chrome

# macOS (desktop)
flutter run -d macos
```

### Verify the project

```bash
flutter analyze        # Static analysis — should report "No issues found!"
flutter test           # Run the widget tests
flutter build macos --debug   # Full compile check (optional)
```

---

## 📦 Dependencies

- [`go_router`](https://pub.dev/packages/go_router) — declarative named-route navigation
- `cupertino_icons` — iOS-style icon set

---

## 👩‍🍳 Mock Data

Recipes live in [`assets/data/recipes.json`](assets/data/recipes.json) and are loaded at runtime by [`RecipeService`](lib/core/services/recipe_service.dart). The UI never hardcodes recipe data — edit the JSON to add or change recipes without touching widgets.

---

## ✅ Rubric Checklist

- [x] At least 4 distinct screens (5 provided)
- [x] Navigation with **GoRouter** (named routes)
- [x] List screen with **search/filter**
- [x] **Detail** screen with **parameter passing**
- [x] **Form** with validation (5 fields)
- [x] **Light/dark** theme support
- [x] 8+ different widgets (`ListView`, `GridView`, `Stack`, `Card`, …)
- [x] 3+ reusable widgets in `lib/widgets/`
- [x] **Responsive**: mobile and tablet
- [x] **No hardcoded data** in widgets (UI/data separation)

---

## 📄 License

This project is for educational purposes. No license specified.
