import 'package:flutter/material.dart';

import '../../features/workout/domain/entities/workout_enums.dart';

/// Provisional Stride palette (docs/UI_UX.md §2): deep ink for dark,
/// warm off-white for light, green = walking/primary, amber = running,
/// muted blue-grey = rest. Phase is never conveyed by colour alone.
abstract final class StridePalette {
  static const ink = Color(0xFF0E1726);
  static const inkSurface = Color(0xFF172234);
  static const inkSurfaceHigh = Color(0xFF203047);
  static const paper = Color(0xFFFAF7F2);
  static const paperSurface = Color(0xFFFFFFFF);

  static const walkLight = Color(0xFF1E7F4A);
  static const walkDark = Color(0xFF5BD08C);
  static const runLight = Color(0xFFB45309);
  static const runDark = Color(0xFFFFB061);
  static const restLight = Color(0xFF4B6584);
  static const restDark = Color(0xFF9DB4CF);
}

@immutable
class PhaseColors extends ThemeExtension<PhaseColors> {
  const PhaseColors({
    required this.walking,
    required this.running,
    required this.rest,
  });

  final Color walking;
  final Color running;
  final Color rest;

  Color of(PhaseType type) => switch (type) {
    PhaseType.walking => walking,
    PhaseType.running => running,
    PhaseType.rest => rest,
  };

  @override
  PhaseColors copyWith({Color? walking, Color? running, Color? rest}) =>
      PhaseColors(
        walking: walking ?? this.walking,
        running: running ?? this.running,
        rest: rest ?? this.rest,
      );

  @override
  PhaseColors lerp(PhaseColors? other, double t) {
    if (other == null) return this;
    return PhaseColors(
      walking: Color.lerp(walking, other.walking, t)!,
      running: Color.lerp(running, other.running, t)!,
      rest: Color.lerp(rest, other.rest, t)!,
    );
  }
}

extension PhaseColorsContext on BuildContext {
  PhaseColors get phaseColors => Theme.of(this).extension<PhaseColors>()!;
}

IconData phaseIcon(PhaseType type) => switch (type) {
  PhaseType.walking => Icons.directions_walk_rounded,
  PhaseType.running => Icons.directions_run_rounded,
  PhaseType.rest => Icons.self_improvement_rounded,
};

abstract final class AppTheme {
  static ThemeData light() => _build(
    ColorScheme.fromSeed(
      seedColor: StridePalette.walkLight,
      brightness: Brightness.light,
      primary: StridePalette.walkLight,
      surface: StridePalette.paper,
    ),
    const PhaseColors(
      walking: StridePalette.walkLight,
      running: StridePalette.runLight,
      rest: StridePalette.restLight,
    ),
  );

  static ThemeData dark() => _build(
    ColorScheme.fromSeed(
      seedColor: StridePalette.walkDark,
      brightness: Brightness.dark,
      primary: StridePalette.walkDark,
      onPrimary: StridePalette.ink,
      surface: StridePalette.ink,
      surfaceContainerLow: StridePalette.inkSurface,
      surfaceContainer: StridePalette.inkSurface,
      surfaceContainerHigh: StridePalette.inkSurfaceHigh,
    ),
    const PhaseColors(
      walking: StridePalette.walkDark,
      running: StridePalette.runDark,
      rest: StridePalette.restDark,
    ),
  );

  static ThemeData _build(ColorScheme scheme, PhaseColors phases) {
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      extensions: [phases],
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: base.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(minVerticalPadding: 12),
    );
  }
}
