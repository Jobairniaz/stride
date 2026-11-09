import 'package:stride/core/clock/clock.dart';

class FakeClock implements Clock {
  FakeClock([DateTime? start])
    : _now = start ?? DateTime.utc(2026, 11, 9, 6, 30);

  DateTime _now;

  @override
  DateTime now() => _now;

  void advance(Duration d) => _now = _now.add(d);

  void set(DateTime t) => _now = t.toUtc();
}
