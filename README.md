# Solo Calisthenics

Offline-first, privacy-first calisthenics training app (Flutter, Android 8.0+ / iOS 15+).
English and Arabic with full RTL. No account, no server, no analytics.

**Status: Phase 1 (MVP) complete.** Onboarding and profiling, exercise library,
workout logger, rest timer, encrypted local storage, theme, Arabic/English.

## Run

```bash
flutter pub get
```

```bash
flutter gen-l10n
```

```bash
dart run build_runner build
```

```bash
flutter run
```

```bash
flutter test
```

The generated files (`lib/l10n/app_l10n*.dart`, `*.g.dart`) are committed, so the
two generation steps are only needed after changing `.arb` files or database tables.

## Architecture

Feature-first folders; each feature is split into `domain` (pure Dart rules and
models), `data` (repositories), `application` (Riverpod controllers) and
`presentation` (widgets).

```
lib/
  main.dart                 boot: open encrypted DB, load seed + settings, runApp
  app.dart                  MaterialApp, locale, theme, onboarding gate
  core/
    db/                     Drift schema, SQLCipher connection, key store
    notifications/          NotificationService interface + local implementation
    platform/               volume-button channel (Android)
    theme/                  palette, typography, tabular numerals
    units.dart              kg/lb, cm/ft-in conversions
    providers.dart          dependency wiring (overridden in tests)
  features/
    profile/                profile + injuries (domain, repository, controller)
    onboarding/             first-run flow, reused as the profile editor
    exercises/              library, detail, injury filter rules, media widget
    workout/                templates, session repository, controller, logger UI
    settings/               key/value settings, reminders
  l10n/                     app_en.arb, app_ar.arb (+ generated code)
assets/
  data/exercises.json       exercise seed: 80 exercises in 15 progression chains
  media/exercises/          your clips go here (see assets/media/README.md)
  fonts/                    Inter, IBM Plex Sans Arabic (SIL OFL)
android/.../MainActivity.kt volume-button capture
test/                       unit + widget tests
tool/                       authoring helpers and screenshot renderer
```

### Data

* **Database**: Drift over SQLite, encrypted with SQLCipher (selected through the
  `sqlite3` package build hooks in `pubspec.yaml`). The 256-bit key is generated on
  first launch and kept in the platform keystore (`flutter_secure_storage`).
  Android auto-backup is disabled so an encrypted file is never restored without its key.
* **Tables**: `profiles` (single row), `injuries`, `settings` (key/value),
  `sessions`, `session_exercises`, `set_logs`. Everything is stored in metric.
* **Exercises** are not in the database. They are read from
  `assets/data/exercises.json`, which can be extended without code changes.
  `test/exercises/seed_data_test.dart` validates the file.

### Rules worth knowing

* **Injury filter** (`features/exercises/domain/injury_filter.dart`):
  Severe excludes Medium and High stress on that joint. Moderate excludes High and
  substitutes the nearest allowed regression. Mild allows the exercise, adds a
  targeted warm-up, and caps volume at 2 sets when the stress is Medium or High.
  Excluded exercises stay visible in the library, greyed out with the reason.
* **Session safety**: every tap, set and rest start is written to the database
  immediately. An unfinished session is reopened on launch.
* **Rest timer**: stored as an end timestamp, so it is correct after the screen
  turns off or the app is killed. A local notification is scheduled for the end.

## Adding content

* Exercises: edit `assets/data/exercises.json` (or `tool/build_seed.py` and rerun it).
* Translations: edit `tool/build_arb.py`, run it, then `flutter gen-l10n`.
* Clips: see `assets/media/README.md`.

## Roadmap

* Phase 2: weekly planner and progression engine, skill tree, progress photos
  vault with app lock, analytics, encrypted backup export/import.
* Phase 3 (optional cloud): Google sign-in, encrypted cloud backup, coach review.
