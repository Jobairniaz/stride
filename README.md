# Stride (Flutter app)

Offline walk/run interval timer. Product docs and rules live one level up: `../README.md`, `../AI_RULES.md`, `../docs/`.

## Run
```bash
flutter pub get
dart run build_runner build   # only after changing Drift tables
flutter run
```

## Check
```bash
dart format lib test
flutter analyze
flutter test
```

## Layout
```
lib/
  app/          app root, router, theme, infrastructure providers, shared widgets
  core/         clock, typed failures, duration formatting
  features/
    workout/    engine + announcement planner (pure), Drift repo, controller, screens
    progress/   monthly stats & streaks (pure), providers, screens
    profile/    units, BMI, calorie estimator, weight trend (pure), Drift repo, screens
    settings/   preferences (SharedPreferences), screens
    home/       home screen
  platform/     TTS, notifications, haptics/wakelock, Drift database
test/           domain, data, application (controller), widget
```

Behavior details: `../docs/WORKOUT_RULES.md`. Platform status and limits: `../docs/PLATFORM_STATUS.md`.

Before release, replace the `com.example.stride` application ID and set up signing.
