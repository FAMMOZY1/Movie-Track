# MovieTrack — Project Guide

Flutter movie-finder app built from a Stitch UI Kit ("Cinematic Core" design system) using the TMDB API.

## Quick Start

Flutter SDK is at `C:\Users\User\flutter` (pinned to **3.27.4** — see "Flutter version" below). It is on PATH after a shell restart; otherwise prepend `C:\Users\User\flutter\bin`.

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generates *.freezed.dart + *.g.dart
flutter run -d chrome --web-port=8080                       # or -d <android-device>
```

TMDB API key already set in `.env` (`TMDB_API_KEY`, `BASE_URL`, `IMAGE_BASE_URL`).

## Flutter version — IMPORTANT

Pinned to **Flutter 3.27.4 / Dart 3.6.2**. Do NOT upgrade to 3.44+:
- `phosphor_flutter` 2.1.0 (latest) extends `IconData`, which is a *final class* in Flutter 3.44+ → compile error.
- `skeletonizer` 2.x needs newer Flutter Canvas API (`clipRSuperellipse`).
- `flutter_form_builder` 10.x needs Dart 3.7+.

To change Flutter version: `git -C C:\Users\User\flutter checkout <tag>` then `flutter --version` (rebuilds tool).

## Android build config — IMPORTANT

`flutter create .` ran under Flutter 3.44 and generated an Android setup incompatible with 3.27. Fixed to:
- `android/gradle/wrapper/gradle-wrapper.properties` → **gradle-8.9** (was 9.1.0; Gradle 9 dropped `groovy.xml.QName` that flutter.groovy needs).
- `android/settings.gradle.kts` → AGP **8.3.0**, Kotlin **2.1.0** (were 9.0.1 / 2.3.20).
- `android/app/build.gradle.kts` → added `id("org.jetbrains.kotlin.android")` plugin (was missing → MainActivity.kt never compiled → `ClassNotFoundException` at launch) and `kotlinOptions { jvmTarget = "17" }` (Java and Kotlin JVM targets must match — both 17).

Emulator: `flutter emulators --launch Pixel_9_Pro_XL`, then `flutter run -d emulator-5554`. JDK is Android Studio's bundled OpenJDK 21.

## Architecture

- **State:** BLoC (`bloc` + `flutter_bloc`). Each feature has its own `bloc/` (bloc + event + state via `part of`).
- **Models:** `freezed` + `json_serializable`. After editing any model, re-run build_runner.
- **Network:** `dio` via `DioClient.instance` (singleton). API key + language injected by interceptor. Endpoints in `core/network/api_endpoints.dart`.
- **Navigation:** `go_router`. Bottom-nav tabs (Home/Search/Favorites) use a `StatefulShellRoute.indexedStack` wrapped by `MainShell`. Detail & Review are full-screen routes (no bottom nav).
- **Favorites:** persisted as JSON to the app documents dir via `path_provider` (`FavoriteRepository`). `FavoriteBloc` is provided **app-wide** in `main.dart` so the detail screen and favorites tab share one source of truth.
- **Theme:** `shared/themes/app_theme.dart` — `AppColors`, `AppRadius`, `AppSpacing`, `AppTheme.theme`. Dark "Cinematic Core": near-black surfaces, blue primary (#4D8EFF), yellow rating (#EEC200), 1px borders, Inter font.

## Structure

```
lib/
├── core/         constants, network (dio_client, api_endpoints), router, utils
├── shared/
│   ├── models/   movie, movie_detail, movie_response, favorite_movie (freezed)
│   ├── themes/   app_theme (Cinematic Core)
│   └── widgets/  poster_card, poster_image, rating_badge, section_header,
│                 state_view, splash_screen, main_shell (bottom nav)
└── features/
    ├── home/         popular movies — hero, Trending/Popular shelves, genre grid
    ├── search/       debounced search + results/loading/empty/error states
    ├── movie_detail/ backdrop, poster, genres, overview, favorite toggle, share, review
    ├── favorite/     JSON-persisted favorites grid, remove modal, empty state
    └── review/        FormBuilder review form (name + 5-star rating + comment, validated)
```

Each feature folder: `bloc/`, `screens/`, `widgets/`, and (where it calls the API) `repository/`.

## Screens (mapped from Stitch UI Kit)

splash → home (+ loading) → search (results/loading/empty/error) → movie_detail (+ favorite state) → review; favorite (+ empty state + remove modal). `component_system` and `cinematic_core/DESIGN.md` were reference only.

## Shared widget contracts

- `PosterCard({movie, onTap, width=160, cornerAction})` — 2:3 poster + rating badge + title/year.
- `PosterImage({path, width, height, fit, radius})` — cached image w/ phosphor fallback. Prepends `AppConstants.imageBaseUrl`.
- `SectionHeader({title, onViewAll})` — title + primary underline.
- `StateView({icon, title, subtitle, actionLabel, onAction})` — empty/error illustration.
- `MainShell({child, currentIndex, onTap})` — 64px bottom nav.

## Conventions

- Relative imports (`../../../shared/...`).
- `withValues(alpha:)` not `withOpacity` (3.27 API).
- Icons from `phosphor_flutter` (PhosphorIconsBold / PhosphorIconsFill).
- Share via `Share.share('text')` (share_plus 10.x).

## Work log

- Initial app scaffolded (purple/red theme) → **replaced entirely** by Stitch "Cinematic Core" design per the UI Kit in `assets/stitch_movietrack_flutter_ui_kit/`.
- Added Favorites feature (JSON persistence) — not in the original req.md, came from the UI Kit.
- Downgraded Flutter 3.44 → 3.27.4 to restore `phosphor_flutter` compatibility.
- Stitch MCP server added to `~/.claude.json` (global `mcpServers`).
