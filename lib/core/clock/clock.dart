/// Source of the current time. Always returns UTC.
///
/// Injected everywhere time matters so tests can use [FakeClock]-style
/// implementations and so the workout engine never reads the system clock
/// directly.
abstract interface class Clock {
  DateTime now();
}

/// Wall-clock implementation.
///
/// Wall time is used (rather than a monotonic stopwatch) because Dart's
/// monotonic sources do not advance while the device CPU sleeps, which would
/// make a locked-phone workout run slow. Backward wall-clock jumps are
/// handled by the workout engine (see `WorkoutEngine` clock policy).
class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now().toUtc();
}
