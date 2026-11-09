import 'workout_enums.dart';

/// A finished (or interrupted) phase instance — the audit record from which
/// session aggregates are computed.
class PhaseSegment {
  const PhaseSegment({
    required this.id,
    required this.sequenceIndex,
    required this.type,
    required this.plannedDuration,
    required this.actualDuration,
    required this.startedAt,
    required this.endedAt,
    required this.insertedByUser,
    required this.completion,
  });

  final String id;
  final int sequenceIndex;
  final PhaseType type;
  final Duration plannedDuration;

  /// Time actually spent in this phase, excluding pauses.
  final Duration actualDuration;
  final DateTime startedAt;
  final DateTime endedAt;
  final bool insertedByUser;
  final SegmentCompletion completion;

  Map<String, Object?> toJson() => {
    'id': id,
    'sequenceIndex': sequenceIndex,
    'type': type.name,
    'plannedDurationMs': plannedDuration.inMilliseconds,
    'actualDurationMs': actualDuration.inMilliseconds,
    'startedAtUtcMs': startedAt.millisecondsSinceEpoch,
    'endedAtUtcMs': endedAt.millisecondsSinceEpoch,
    'insertedByUser': insertedByUser,
    'completion': completion.name,
  };

  factory PhaseSegment.fromJson(Map<String, Object?> json) => PhaseSegment(
    id: json['id']! as String,
    sequenceIndex: json['sequenceIndex']! as int,
    type: PhaseType.values.byName(json['type']! as String),
    plannedDuration: Duration(milliseconds: json['plannedDurationMs']! as int),
    actualDuration: Duration(milliseconds: json['actualDurationMs']! as int),
    startedAt: _utc(json['startedAtUtcMs']! as int),
    endedAt: _utc(json['endedAtUtcMs']! as int),
    insertedByUser: json['insertedByUser']! as bool,
    completion: SegmentCompletion.values.byName(json['completion']! as String),
  );

  static DateTime _utc(int ms) =>
      DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);

  @override
  bool operator ==(Object other) =>
      other is PhaseSegment &&
      other.id == id &&
      other.sequenceIndex == sequenceIndex &&
      other.type == type &&
      other.plannedDuration == plannedDuration &&
      other.actualDuration == actualDuration &&
      other.startedAt == startedAt &&
      other.endedAt == endedAt &&
      other.insertedByUser == insertedByUser &&
      other.completion == completion;

  @override
  int get hashCode => Object.hash(
    id,
    sequenceIndex,
    type,
    plannedDuration,
    actualDuration,
    startedAt,
    endedAt,
    insertedByUser,
    completion,
  );
}
