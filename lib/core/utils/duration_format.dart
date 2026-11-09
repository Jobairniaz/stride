/// Formatting helpers for durations. Pure Dart; no locale dependence.
library;

/// `m:ss` or `h:mm:ss`. Rounds *up* partial seconds so a countdown shows
/// `0:01` until the phase actually ends, never `0:00` early.
String formatCountdown(Duration d) {
  final totalMs = d.inMilliseconds < 0 ? 0 : d.inMilliseconds;
  final seconds = (totalMs + 999) ~/ 1000;
  return _clock(seconds);
}

/// `m:ss` or `h:mm:ss`, truncating partial seconds (for elapsed time).
String formatElapsed(Duration d) {
  final seconds = d.inSeconds < 0 ? 0 : d.inSeconds;
  return _clock(seconds);
}

String _clock(int totalSeconds) {
  final h = totalSeconds ~/ 3600;
  final m = (totalSeconds % 3600) ~/ 60;
  final s = totalSeconds % 60;
  final ss = s.toString().padLeft(2, '0');
  if (h > 0) return '$h:${m.toString().padLeft(2, '0')}:$ss';
  return '$m:$ss';
}

/// Short human label with explicit units, e.g. `30 sec`, `2 min`,
/// `2 min 30 sec`, `1 h 5 min`.
String formatDurationLabel(Duration d) {
  final totalSeconds = d.inSeconds;
  final h = totalSeconds ~/ 3600;
  final m = (totalSeconds % 3600) ~/ 60;
  final s = totalSeconds % 60;
  final parts = <String>[
    if (h > 0) '$h h',
    if (m > 0) '$m min',
    if (s > 0 || totalSeconds == 0) '$s sec',
  ];
  return parts.join(' ');
}

/// Compact total for statistics, e.g. `0 min`, `42 min`, `3 h 05 min`.
String formatTotalMinutes(Duration d) {
  final minutes = d.inMinutes;
  if (minutes < 60) return '$minutes min';
  return '${minutes ~/ 60} h ${(minutes % 60).toString().padLeft(2, '0')} min';
}

/// Spoken form for TTS, e.g. `1 minute 20 seconds`.
String spokenDuration(Duration d) {
  final totalSeconds = (d.inMilliseconds + 999) ~/ 1000;
  final m = totalSeconds ~/ 60;
  final s = totalSeconds % 60;
  final parts = <String>[
    if (m > 0) '$m ${m == 1 ? 'minute' : 'minutes'}',
    if (s > 0 || m == 0) '$s ${s == 1 ? 'second' : 'seconds'}',
  ];
  return parts.join(' ');
}
