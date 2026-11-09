// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, SessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtUtcMeta = const VerificationMeta(
    'startedAtUtc',
  );
  @override
  late final GeneratedColumn<int> startedAtUtc = GeneratedColumn<int>(
    'started_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtUtcMeta = const VerificationMeta(
    'endedAtUtc',
  );
  @override
  late final GeneratedColumn<int> endedAtUtc = GeneratedColumn<int>(
    'ended_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completionReasonMeta = const VerificationMeta(
    'completionReason',
  );
  @override
  late final GeneratedColumn<String> completionReason = GeneratedColumn<String>(
    'completion_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalElapsedMsMeta = const VerificationMeta(
    'totalElapsedMs',
  );
  @override
  late final GeneratedColumn<int> totalElapsedMs = GeneratedColumn<int>(
    'total_elapsed_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeDurationMsMeta = const VerificationMeta(
    'activeDurationMs',
  );
  @override
  late final GeneratedColumn<int> activeDurationMs = GeneratedColumn<int>(
    'active_duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _walkingDurationMsMeta = const VerificationMeta(
    'walkingDurationMs',
  );
  @override
  late final GeneratedColumn<int> walkingDurationMs = GeneratedColumn<int>(
    'walking_duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _runningDurationMsMeta = const VerificationMeta(
    'runningDurationMs',
  );
  @override
  late final GeneratedColumn<int> runningDurationMs = GeneratedColumn<int>(
    'running_duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restDurationMsMeta = const VerificationMeta(
    'restDurationMs',
  );
  @override
  late final GeneratedColumn<int> restDurationMs = GeneratedColumn<int>(
    'rest_duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedRoundsMeta = const VerificationMeta(
    'completedRounds',
  );
  @override
  late final GeneratedColumn<int> completedRounds = GeneratedColumn<int>(
    'completed_rounds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planSnapshotJsonMeta = const VerificationMeta(
    'planSnapshotJson',
  );
  @override
  late final GeneratedColumn<String> planSnapshotJson = GeneratedColumn<String>(
    'plan_snapshot_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedCaloriesKcalMeta =
      const VerificationMeta('estimatedCaloriesKcal');
  @override
  late final GeneratedColumn<double> estimatedCaloriesKcal =
      GeneratedColumn<double>(
        'estimated_calories_kcal',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _calorieMethodVersionMeta =
      const VerificationMeta('calorieMethodVersion');
  @override
  late final GeneratedColumn<String> calorieMethodVersion =
      GeneratedColumn<String>(
        'calorie_method_version',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _calorieWeightGramsMeta =
      const VerificationMeta('calorieWeightGrams');
  @override
  late final GeneratedColumn<int> calorieWeightGrams = GeneratedColumn<int>(
    'calorie_weight_grams',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _calorieAssumptionsJsonMeta =
      const VerificationMeta('calorieAssumptionsJson');
  @override
  late final GeneratedColumn<String> calorieAssumptionsJson =
      GeneratedColumn<String>(
        'calorie_assumptions_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<int> createdAtUtc = GeneratedColumn<int>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtc = GeneratedColumn<int>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAtUtc,
    endedAtUtc,
    status,
    completionReason,
    totalElapsedMs,
    activeDurationMs,
    walkingDurationMs,
    runningDurationMs,
    restDurationMs,
    completedRounds,
    planSnapshotJson,
    estimatedCaloriesKcal,
    calorieMethodVersion,
    calorieWeightGrams,
    calorieAssumptionsJson,
    createdAtUtc,
    updatedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at_utc')) {
      context.handle(
        _startedAtUtcMeta,
        startedAtUtc.isAcceptableOrUnknown(
          data['started_at_utc']!,
          _startedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedAtUtcMeta);
    }
    if (data.containsKey('ended_at_utc')) {
      context.handle(
        _endedAtUtcMeta,
        endedAtUtc.isAcceptableOrUnknown(
          data['ended_at_utc']!,
          _endedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('completion_reason')) {
      context.handle(
        _completionReasonMeta,
        completionReason.isAcceptableOrUnknown(
          data['completion_reason']!,
          _completionReasonMeta,
        ),
      );
    }
    if (data.containsKey('total_elapsed_ms')) {
      context.handle(
        _totalElapsedMsMeta,
        totalElapsedMs.isAcceptableOrUnknown(
          data['total_elapsed_ms']!,
          _totalElapsedMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalElapsedMsMeta);
    }
    if (data.containsKey('active_duration_ms')) {
      context.handle(
        _activeDurationMsMeta,
        activeDurationMs.isAcceptableOrUnknown(
          data['active_duration_ms']!,
          _activeDurationMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activeDurationMsMeta);
    }
    if (data.containsKey('walking_duration_ms')) {
      context.handle(
        _walkingDurationMsMeta,
        walkingDurationMs.isAcceptableOrUnknown(
          data['walking_duration_ms']!,
          _walkingDurationMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_walkingDurationMsMeta);
    }
    if (data.containsKey('running_duration_ms')) {
      context.handle(
        _runningDurationMsMeta,
        runningDurationMs.isAcceptableOrUnknown(
          data['running_duration_ms']!,
          _runningDurationMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_runningDurationMsMeta);
    }
    if (data.containsKey('rest_duration_ms')) {
      context.handle(
        _restDurationMsMeta,
        restDurationMs.isAcceptableOrUnknown(
          data['rest_duration_ms']!,
          _restDurationMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_restDurationMsMeta);
    }
    if (data.containsKey('completed_rounds')) {
      context.handle(
        _completedRoundsMeta,
        completedRounds.isAcceptableOrUnknown(
          data['completed_rounds']!,
          _completedRoundsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedRoundsMeta);
    }
    if (data.containsKey('plan_snapshot_json')) {
      context.handle(
        _planSnapshotJsonMeta,
        planSnapshotJson.isAcceptableOrUnknown(
          data['plan_snapshot_json']!,
          _planSnapshotJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_planSnapshotJsonMeta);
    }
    if (data.containsKey('estimated_calories_kcal')) {
      context.handle(
        _estimatedCaloriesKcalMeta,
        estimatedCaloriesKcal.isAcceptableOrUnknown(
          data['estimated_calories_kcal']!,
          _estimatedCaloriesKcalMeta,
        ),
      );
    }
    if (data.containsKey('calorie_method_version')) {
      context.handle(
        _calorieMethodVersionMeta,
        calorieMethodVersion.isAcceptableOrUnknown(
          data['calorie_method_version']!,
          _calorieMethodVersionMeta,
        ),
      );
    }
    if (data.containsKey('calorie_weight_grams')) {
      context.handle(
        _calorieWeightGramsMeta,
        calorieWeightGrams.isAcceptableOrUnknown(
          data['calorie_weight_grams']!,
          _calorieWeightGramsMeta,
        ),
      );
    }
    if (data.containsKey('calorie_assumptions_json')) {
      context.handle(
        _calorieAssumptionsJsonMeta,
        calorieAssumptionsJson.isAcceptableOrUnknown(
          data['calorie_assumptions_json']!,
          _calorieAssumptionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at_utc'],
      )!,
      endedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at_utc'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      completionReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completion_reason'],
      ),
      totalElapsedMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_elapsed_ms'],
      )!,
      activeDurationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active_duration_ms'],
      )!,
      walkingDurationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}walking_duration_ms'],
      )!,
      runningDurationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}running_duration_ms'],
      )!,
      restDurationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_duration_ms'],
      )!,
      completedRounds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_rounds'],
      )!,
      planSnapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_snapshot_json'],
      )!,
      estimatedCaloriesKcal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}estimated_calories_kcal'],
      ),
      calorieMethodVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calorie_method_version'],
      ),
      calorieWeightGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calorie_weight_grams'],
      ),
      calorieAssumptionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calorie_assumptions_json'],
      ),
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc'],
      )!,
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class SessionRow extends DataClass implements Insertable<SessionRow> {
  final String id;
  final int startedAtUtc;
  final int? endedAtUtc;
  final String status;
  final String? completionReason;

  /// Wall-clock duration including pauses.
  final int totalElapsedMs;
  final int activeDurationMs;
  final int walkingDurationMs;
  final int runningDurationMs;
  final int restDurationMs;
  final int completedRounds;
  final String planSnapshotJson;

  /// Estimated walking + running kcal (rest is in the assumptions JSON).
  final double? estimatedCaloriesKcal;
  final String? calorieMethodVersion;
  final int? calorieWeightGrams;
  final String? calorieAssumptionsJson;
  final int createdAtUtc;
  final int updatedAtUtc;
  const SessionRow({
    required this.id,
    required this.startedAtUtc,
    this.endedAtUtc,
    required this.status,
    this.completionReason,
    required this.totalElapsedMs,
    required this.activeDurationMs,
    required this.walkingDurationMs,
    required this.runningDurationMs,
    required this.restDurationMs,
    required this.completedRounds,
    required this.planSnapshotJson,
    this.estimatedCaloriesKcal,
    this.calorieMethodVersion,
    this.calorieWeightGrams,
    this.calorieAssumptionsJson,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at_utc'] = Variable<int>(startedAtUtc);
    if (!nullToAbsent || endedAtUtc != null) {
      map['ended_at_utc'] = Variable<int>(endedAtUtc);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || completionReason != null) {
      map['completion_reason'] = Variable<String>(completionReason);
    }
    map['total_elapsed_ms'] = Variable<int>(totalElapsedMs);
    map['active_duration_ms'] = Variable<int>(activeDurationMs);
    map['walking_duration_ms'] = Variable<int>(walkingDurationMs);
    map['running_duration_ms'] = Variable<int>(runningDurationMs);
    map['rest_duration_ms'] = Variable<int>(restDurationMs);
    map['completed_rounds'] = Variable<int>(completedRounds);
    map['plan_snapshot_json'] = Variable<String>(planSnapshotJson);
    if (!nullToAbsent || estimatedCaloriesKcal != null) {
      map['estimated_calories_kcal'] = Variable<double>(estimatedCaloriesKcal);
    }
    if (!nullToAbsent || calorieMethodVersion != null) {
      map['calorie_method_version'] = Variable<String>(calorieMethodVersion);
    }
    if (!nullToAbsent || calorieWeightGrams != null) {
      map['calorie_weight_grams'] = Variable<int>(calorieWeightGrams);
    }
    if (!nullToAbsent || calorieAssumptionsJson != null) {
      map['calorie_assumptions_json'] = Variable<String>(
        calorieAssumptionsJson,
      );
    }
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    map['updated_at_utc'] = Variable<int>(updatedAtUtc);
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      startedAtUtc: Value(startedAtUtc),
      endedAtUtc: endedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAtUtc),
      status: Value(status),
      completionReason: completionReason == null && nullToAbsent
          ? const Value.absent()
          : Value(completionReason),
      totalElapsedMs: Value(totalElapsedMs),
      activeDurationMs: Value(activeDurationMs),
      walkingDurationMs: Value(walkingDurationMs),
      runningDurationMs: Value(runningDurationMs),
      restDurationMs: Value(restDurationMs),
      completedRounds: Value(completedRounds),
      planSnapshotJson: Value(planSnapshotJson),
      estimatedCaloriesKcal: estimatedCaloriesKcal == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedCaloriesKcal),
      calorieMethodVersion: calorieMethodVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(calorieMethodVersion),
      calorieWeightGrams: calorieWeightGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(calorieWeightGrams),
      calorieAssumptionsJson: calorieAssumptionsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(calorieAssumptionsJson),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
    );
  }

  factory SessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionRow(
      id: serializer.fromJson<String>(json['id']),
      startedAtUtc: serializer.fromJson<int>(json['startedAtUtc']),
      endedAtUtc: serializer.fromJson<int?>(json['endedAtUtc']),
      status: serializer.fromJson<String>(json['status']),
      completionReason: serializer.fromJson<String?>(json['completionReason']),
      totalElapsedMs: serializer.fromJson<int>(json['totalElapsedMs']),
      activeDurationMs: serializer.fromJson<int>(json['activeDurationMs']),
      walkingDurationMs: serializer.fromJson<int>(json['walkingDurationMs']),
      runningDurationMs: serializer.fromJson<int>(json['runningDurationMs']),
      restDurationMs: serializer.fromJson<int>(json['restDurationMs']),
      completedRounds: serializer.fromJson<int>(json['completedRounds']),
      planSnapshotJson: serializer.fromJson<String>(json['planSnapshotJson']),
      estimatedCaloriesKcal: serializer.fromJson<double?>(
        json['estimatedCaloriesKcal'],
      ),
      calorieMethodVersion: serializer.fromJson<String?>(
        json['calorieMethodVersion'],
      ),
      calorieWeightGrams: serializer.fromJson<int?>(json['calorieWeightGrams']),
      calorieAssumptionsJson: serializer.fromJson<String?>(
        json['calorieAssumptionsJson'],
      ),
      createdAtUtc: serializer.fromJson<int>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<int>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAtUtc': serializer.toJson<int>(startedAtUtc),
      'endedAtUtc': serializer.toJson<int?>(endedAtUtc),
      'status': serializer.toJson<String>(status),
      'completionReason': serializer.toJson<String?>(completionReason),
      'totalElapsedMs': serializer.toJson<int>(totalElapsedMs),
      'activeDurationMs': serializer.toJson<int>(activeDurationMs),
      'walkingDurationMs': serializer.toJson<int>(walkingDurationMs),
      'runningDurationMs': serializer.toJson<int>(runningDurationMs),
      'restDurationMs': serializer.toJson<int>(restDurationMs),
      'completedRounds': serializer.toJson<int>(completedRounds),
      'planSnapshotJson': serializer.toJson<String>(planSnapshotJson),
      'estimatedCaloriesKcal': serializer.toJson<double?>(
        estimatedCaloriesKcal,
      ),
      'calorieMethodVersion': serializer.toJson<String?>(calorieMethodVersion),
      'calorieWeightGrams': serializer.toJson<int?>(calorieWeightGrams),
      'calorieAssumptionsJson': serializer.toJson<String?>(
        calorieAssumptionsJson,
      ),
      'createdAtUtc': serializer.toJson<int>(createdAtUtc),
      'updatedAtUtc': serializer.toJson<int>(updatedAtUtc),
    };
  }

  SessionRow copyWith({
    String? id,
    int? startedAtUtc,
    Value<int?> endedAtUtc = const Value.absent(),
    String? status,
    Value<String?> completionReason = const Value.absent(),
    int? totalElapsedMs,
    int? activeDurationMs,
    int? walkingDurationMs,
    int? runningDurationMs,
    int? restDurationMs,
    int? completedRounds,
    String? planSnapshotJson,
    Value<double?> estimatedCaloriesKcal = const Value.absent(),
    Value<String?> calorieMethodVersion = const Value.absent(),
    Value<int?> calorieWeightGrams = const Value.absent(),
    Value<String?> calorieAssumptionsJson = const Value.absent(),
    int? createdAtUtc,
    int? updatedAtUtc,
  }) => SessionRow(
    id: id ?? this.id,
    startedAtUtc: startedAtUtc ?? this.startedAtUtc,
    endedAtUtc: endedAtUtc.present ? endedAtUtc.value : this.endedAtUtc,
    status: status ?? this.status,
    completionReason: completionReason.present
        ? completionReason.value
        : this.completionReason,
    totalElapsedMs: totalElapsedMs ?? this.totalElapsedMs,
    activeDurationMs: activeDurationMs ?? this.activeDurationMs,
    walkingDurationMs: walkingDurationMs ?? this.walkingDurationMs,
    runningDurationMs: runningDurationMs ?? this.runningDurationMs,
    restDurationMs: restDurationMs ?? this.restDurationMs,
    completedRounds: completedRounds ?? this.completedRounds,
    planSnapshotJson: planSnapshotJson ?? this.planSnapshotJson,
    estimatedCaloriesKcal: estimatedCaloriesKcal.present
        ? estimatedCaloriesKcal.value
        : this.estimatedCaloriesKcal,
    calorieMethodVersion: calorieMethodVersion.present
        ? calorieMethodVersion.value
        : this.calorieMethodVersion,
    calorieWeightGrams: calorieWeightGrams.present
        ? calorieWeightGrams.value
        : this.calorieWeightGrams,
    calorieAssumptionsJson: calorieAssumptionsJson.present
        ? calorieAssumptionsJson.value
        : this.calorieAssumptionsJson,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
  );
  SessionRow copyWithCompanion(WorkoutSessionsCompanion data) {
    return SessionRow(
      id: data.id.present ? data.id.value : this.id,
      startedAtUtc: data.startedAtUtc.present
          ? data.startedAtUtc.value
          : this.startedAtUtc,
      endedAtUtc: data.endedAtUtc.present
          ? data.endedAtUtc.value
          : this.endedAtUtc,
      status: data.status.present ? data.status.value : this.status,
      completionReason: data.completionReason.present
          ? data.completionReason.value
          : this.completionReason,
      totalElapsedMs: data.totalElapsedMs.present
          ? data.totalElapsedMs.value
          : this.totalElapsedMs,
      activeDurationMs: data.activeDurationMs.present
          ? data.activeDurationMs.value
          : this.activeDurationMs,
      walkingDurationMs: data.walkingDurationMs.present
          ? data.walkingDurationMs.value
          : this.walkingDurationMs,
      runningDurationMs: data.runningDurationMs.present
          ? data.runningDurationMs.value
          : this.runningDurationMs,
      restDurationMs: data.restDurationMs.present
          ? data.restDurationMs.value
          : this.restDurationMs,
      completedRounds: data.completedRounds.present
          ? data.completedRounds.value
          : this.completedRounds,
      planSnapshotJson: data.planSnapshotJson.present
          ? data.planSnapshotJson.value
          : this.planSnapshotJson,
      estimatedCaloriesKcal: data.estimatedCaloriesKcal.present
          ? data.estimatedCaloriesKcal.value
          : this.estimatedCaloriesKcal,
      calorieMethodVersion: data.calorieMethodVersion.present
          ? data.calorieMethodVersion.value
          : this.calorieMethodVersion,
      calorieWeightGrams: data.calorieWeightGrams.present
          ? data.calorieWeightGrams.value
          : this.calorieWeightGrams,
      calorieAssumptionsJson: data.calorieAssumptionsJson.present
          ? data.calorieAssumptionsJson.value
          : this.calorieAssumptionsJson,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionRow(')
          ..write('id: $id, ')
          ..write('startedAtUtc: $startedAtUtc, ')
          ..write('endedAtUtc: $endedAtUtc, ')
          ..write('status: $status, ')
          ..write('completionReason: $completionReason, ')
          ..write('totalElapsedMs: $totalElapsedMs, ')
          ..write('activeDurationMs: $activeDurationMs, ')
          ..write('walkingDurationMs: $walkingDurationMs, ')
          ..write('runningDurationMs: $runningDurationMs, ')
          ..write('restDurationMs: $restDurationMs, ')
          ..write('completedRounds: $completedRounds, ')
          ..write('planSnapshotJson: $planSnapshotJson, ')
          ..write('estimatedCaloriesKcal: $estimatedCaloriesKcal, ')
          ..write('calorieMethodVersion: $calorieMethodVersion, ')
          ..write('calorieWeightGrams: $calorieWeightGrams, ')
          ..write('calorieAssumptionsJson: $calorieAssumptionsJson, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startedAtUtc,
    endedAtUtc,
    status,
    completionReason,
    totalElapsedMs,
    activeDurationMs,
    walkingDurationMs,
    runningDurationMs,
    restDurationMs,
    completedRounds,
    planSnapshotJson,
    estimatedCaloriesKcal,
    calorieMethodVersion,
    calorieWeightGrams,
    calorieAssumptionsJson,
    createdAtUtc,
    updatedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionRow &&
          other.id == this.id &&
          other.startedAtUtc == this.startedAtUtc &&
          other.endedAtUtc == this.endedAtUtc &&
          other.status == this.status &&
          other.completionReason == this.completionReason &&
          other.totalElapsedMs == this.totalElapsedMs &&
          other.activeDurationMs == this.activeDurationMs &&
          other.walkingDurationMs == this.walkingDurationMs &&
          other.runningDurationMs == this.runningDurationMs &&
          other.restDurationMs == this.restDurationMs &&
          other.completedRounds == this.completedRounds &&
          other.planSnapshotJson == this.planSnapshotJson &&
          other.estimatedCaloriesKcal == this.estimatedCaloriesKcal &&
          other.calorieMethodVersion == this.calorieMethodVersion &&
          other.calorieWeightGrams == this.calorieWeightGrams &&
          other.calorieAssumptionsJson == this.calorieAssumptionsJson &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class WorkoutSessionsCompanion extends UpdateCompanion<SessionRow> {
  final Value<String> id;
  final Value<int> startedAtUtc;
  final Value<int?> endedAtUtc;
  final Value<String> status;
  final Value<String?> completionReason;
  final Value<int> totalElapsedMs;
  final Value<int> activeDurationMs;
  final Value<int> walkingDurationMs;
  final Value<int> runningDurationMs;
  final Value<int> restDurationMs;
  final Value<int> completedRounds;
  final Value<String> planSnapshotJson;
  final Value<double?> estimatedCaloriesKcal;
  final Value<String?> calorieMethodVersion;
  final Value<int?> calorieWeightGrams;
  final Value<String?> calorieAssumptionsJson;
  final Value<int> createdAtUtc;
  final Value<int> updatedAtUtc;
  final Value<int> rowid;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.startedAtUtc = const Value.absent(),
    this.endedAtUtc = const Value.absent(),
    this.status = const Value.absent(),
    this.completionReason = const Value.absent(),
    this.totalElapsedMs = const Value.absent(),
    this.activeDurationMs = const Value.absent(),
    this.walkingDurationMs = const Value.absent(),
    this.runningDurationMs = const Value.absent(),
    this.restDurationMs = const Value.absent(),
    this.completedRounds = const Value.absent(),
    this.planSnapshotJson = const Value.absent(),
    this.estimatedCaloriesKcal = const Value.absent(),
    this.calorieMethodVersion = const Value.absent(),
    this.calorieWeightGrams = const Value.absent(),
    this.calorieAssumptionsJson = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    required String id,
    required int startedAtUtc,
    this.endedAtUtc = const Value.absent(),
    required String status,
    this.completionReason = const Value.absent(),
    required int totalElapsedMs,
    required int activeDurationMs,
    required int walkingDurationMs,
    required int runningDurationMs,
    required int restDurationMs,
    required int completedRounds,
    required String planSnapshotJson,
    this.estimatedCaloriesKcal = const Value.absent(),
    this.calorieMethodVersion = const Value.absent(),
    this.calorieWeightGrams = const Value.absent(),
    this.calorieAssumptionsJson = const Value.absent(),
    required int createdAtUtc,
    required int updatedAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAtUtc = Value(startedAtUtc),
       status = Value(status),
       totalElapsedMs = Value(totalElapsedMs),
       activeDurationMs = Value(activeDurationMs),
       walkingDurationMs = Value(walkingDurationMs),
       runningDurationMs = Value(runningDurationMs),
       restDurationMs = Value(restDurationMs),
       completedRounds = Value(completedRounds),
       planSnapshotJson = Value(planSnapshotJson),
       createdAtUtc = Value(createdAtUtc),
       updatedAtUtc = Value(updatedAtUtc);
  static Insertable<SessionRow> custom({
    Expression<String>? id,
    Expression<int>? startedAtUtc,
    Expression<int>? endedAtUtc,
    Expression<String>? status,
    Expression<String>? completionReason,
    Expression<int>? totalElapsedMs,
    Expression<int>? activeDurationMs,
    Expression<int>? walkingDurationMs,
    Expression<int>? runningDurationMs,
    Expression<int>? restDurationMs,
    Expression<int>? completedRounds,
    Expression<String>? planSnapshotJson,
    Expression<double>? estimatedCaloriesKcal,
    Expression<String>? calorieMethodVersion,
    Expression<int>? calorieWeightGrams,
    Expression<String>? calorieAssumptionsJson,
    Expression<int>? createdAtUtc,
    Expression<int>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAtUtc != null) 'started_at_utc': startedAtUtc,
      if (endedAtUtc != null) 'ended_at_utc': endedAtUtc,
      if (status != null) 'status': status,
      if (completionReason != null) 'completion_reason': completionReason,
      if (totalElapsedMs != null) 'total_elapsed_ms': totalElapsedMs,
      if (activeDurationMs != null) 'active_duration_ms': activeDurationMs,
      if (walkingDurationMs != null) 'walking_duration_ms': walkingDurationMs,
      if (runningDurationMs != null) 'running_duration_ms': runningDurationMs,
      if (restDurationMs != null) 'rest_duration_ms': restDurationMs,
      if (completedRounds != null) 'completed_rounds': completedRounds,
      if (planSnapshotJson != null) 'plan_snapshot_json': planSnapshotJson,
      if (estimatedCaloriesKcal != null)
        'estimated_calories_kcal': estimatedCaloriesKcal,
      if (calorieMethodVersion != null)
        'calorie_method_version': calorieMethodVersion,
      if (calorieWeightGrams != null)
        'calorie_weight_grams': calorieWeightGrams,
      if (calorieAssumptionsJson != null)
        'calorie_assumptions_json': calorieAssumptionsJson,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<String>? id,
    Value<int>? startedAtUtc,
    Value<int?>? endedAtUtc,
    Value<String>? status,
    Value<String?>? completionReason,
    Value<int>? totalElapsedMs,
    Value<int>? activeDurationMs,
    Value<int>? walkingDurationMs,
    Value<int>? runningDurationMs,
    Value<int>? restDurationMs,
    Value<int>? completedRounds,
    Value<String>? planSnapshotJson,
    Value<double?>? estimatedCaloriesKcal,
    Value<String?>? calorieMethodVersion,
    Value<int?>? calorieWeightGrams,
    Value<String?>? calorieAssumptionsJson,
    Value<int>? createdAtUtc,
    Value<int>? updatedAtUtc,
    Value<int>? rowid,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      startedAtUtc: startedAtUtc ?? this.startedAtUtc,
      endedAtUtc: endedAtUtc ?? this.endedAtUtc,
      status: status ?? this.status,
      completionReason: completionReason ?? this.completionReason,
      totalElapsedMs: totalElapsedMs ?? this.totalElapsedMs,
      activeDurationMs: activeDurationMs ?? this.activeDurationMs,
      walkingDurationMs: walkingDurationMs ?? this.walkingDurationMs,
      runningDurationMs: runningDurationMs ?? this.runningDurationMs,
      restDurationMs: restDurationMs ?? this.restDurationMs,
      completedRounds: completedRounds ?? this.completedRounds,
      planSnapshotJson: planSnapshotJson ?? this.planSnapshotJson,
      estimatedCaloriesKcal:
          estimatedCaloriesKcal ?? this.estimatedCaloriesKcal,
      calorieMethodVersion: calorieMethodVersion ?? this.calorieMethodVersion,
      calorieWeightGrams: calorieWeightGrams ?? this.calorieWeightGrams,
      calorieAssumptionsJson:
          calorieAssumptionsJson ?? this.calorieAssumptionsJson,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAtUtc.present) {
      map['started_at_utc'] = Variable<int>(startedAtUtc.value);
    }
    if (endedAtUtc.present) {
      map['ended_at_utc'] = Variable<int>(endedAtUtc.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (completionReason.present) {
      map['completion_reason'] = Variable<String>(completionReason.value);
    }
    if (totalElapsedMs.present) {
      map['total_elapsed_ms'] = Variable<int>(totalElapsedMs.value);
    }
    if (activeDurationMs.present) {
      map['active_duration_ms'] = Variable<int>(activeDurationMs.value);
    }
    if (walkingDurationMs.present) {
      map['walking_duration_ms'] = Variable<int>(walkingDurationMs.value);
    }
    if (runningDurationMs.present) {
      map['running_duration_ms'] = Variable<int>(runningDurationMs.value);
    }
    if (restDurationMs.present) {
      map['rest_duration_ms'] = Variable<int>(restDurationMs.value);
    }
    if (completedRounds.present) {
      map['completed_rounds'] = Variable<int>(completedRounds.value);
    }
    if (planSnapshotJson.present) {
      map['plan_snapshot_json'] = Variable<String>(planSnapshotJson.value);
    }
    if (estimatedCaloriesKcal.present) {
      map['estimated_calories_kcal'] = Variable<double>(
        estimatedCaloriesKcal.value,
      );
    }
    if (calorieMethodVersion.present) {
      map['calorie_method_version'] = Variable<String>(
        calorieMethodVersion.value,
      );
    }
    if (calorieWeightGrams.present) {
      map['calorie_weight_grams'] = Variable<int>(calorieWeightGrams.value);
    }
    if (calorieAssumptionsJson.present) {
      map['calorie_assumptions_json'] = Variable<String>(
        calorieAssumptionsJson.value,
      );
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<int>(createdAtUtc.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<int>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAtUtc: $startedAtUtc, ')
          ..write('endedAtUtc: $endedAtUtc, ')
          ..write('status: $status, ')
          ..write('completionReason: $completionReason, ')
          ..write('totalElapsedMs: $totalElapsedMs, ')
          ..write('activeDurationMs: $activeDurationMs, ')
          ..write('walkingDurationMs: $walkingDurationMs, ')
          ..write('runningDurationMs: $runningDurationMs, ')
          ..write('restDurationMs: $restDurationMs, ')
          ..write('completedRounds: $completedRounds, ')
          ..write('planSnapshotJson: $planSnapshotJson, ')
          ..write('estimatedCaloriesKcal: $estimatedCaloriesKcal, ')
          ..write('calorieMethodVersion: $calorieMethodVersion, ')
          ..write('calorieWeightGrams: $calorieWeightGrams, ')
          ..write('calorieAssumptionsJson: $calorieAssumptionsJson, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutPhaseSegmentsTable extends WorkoutPhaseSegments
    with TableInfo<$WorkoutPhaseSegmentsTable, SegmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutPhaseSegmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sequenceIndexMeta = const VerificationMeta(
    'sequenceIndex',
  );
  @override
  late final GeneratedColumn<int> sequenceIndex = GeneratedColumn<int>(
    'sequence_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phaseTypeMeta = const VerificationMeta(
    'phaseType',
  );
  @override
  late final GeneratedColumn<String> phaseType = GeneratedColumn<String>(
    'phase_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedDurationMsMeta = const VerificationMeta(
    'plannedDurationMs',
  );
  @override
  late final GeneratedColumn<int> plannedDurationMs = GeneratedColumn<int>(
    'planned_duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualDurationMsMeta = const VerificationMeta(
    'actualDurationMs',
  );
  @override
  late final GeneratedColumn<int> actualDurationMs = GeneratedColumn<int>(
    'actual_duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtUtcMeta = const VerificationMeta(
    'startedAtUtc',
  );
  @override
  late final GeneratedColumn<int> startedAtUtc = GeneratedColumn<int>(
    'started_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtUtcMeta = const VerificationMeta(
    'endedAtUtc',
  );
  @override
  late final GeneratedColumn<int> endedAtUtc = GeneratedColumn<int>(
    'ended_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _insertedByUserMeta = const VerificationMeta(
    'insertedByUser',
  );
  @override
  late final GeneratedColumn<bool> insertedByUser = GeneratedColumn<bool>(
    'inserted_by_user',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("inserted_by_user" IN (0, 1))',
    ),
  );
  static const VerificationMeta _completionStatusMeta = const VerificationMeta(
    'completionStatus',
  );
  @override
  late final GeneratedColumn<String> completionStatus = GeneratedColumn<String>(
    'completion_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    sequenceIndex,
    phaseType,
    plannedDurationMs,
    actualDurationMs,
    startedAtUtc,
    endedAtUtc,
    insertedByUser,
    completionStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_phase_segments';
  @override
  VerificationContext validateIntegrity(
    Insertable<SegmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('sequence_index')) {
      context.handle(
        _sequenceIndexMeta,
        sequenceIndex.isAcceptableOrUnknown(
          data['sequence_index']!,
          _sequenceIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sequenceIndexMeta);
    }
    if (data.containsKey('phase_type')) {
      context.handle(
        _phaseTypeMeta,
        phaseType.isAcceptableOrUnknown(data['phase_type']!, _phaseTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseTypeMeta);
    }
    if (data.containsKey('planned_duration_ms')) {
      context.handle(
        _plannedDurationMsMeta,
        plannedDurationMs.isAcceptableOrUnknown(
          data['planned_duration_ms']!,
          _plannedDurationMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedDurationMsMeta);
    }
    if (data.containsKey('actual_duration_ms')) {
      context.handle(
        _actualDurationMsMeta,
        actualDurationMs.isAcceptableOrUnknown(
          data['actual_duration_ms']!,
          _actualDurationMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualDurationMsMeta);
    }
    if (data.containsKey('started_at_utc')) {
      context.handle(
        _startedAtUtcMeta,
        startedAtUtc.isAcceptableOrUnknown(
          data['started_at_utc']!,
          _startedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedAtUtcMeta);
    }
    if (data.containsKey('ended_at_utc')) {
      context.handle(
        _endedAtUtcMeta,
        endedAtUtc.isAcceptableOrUnknown(
          data['ended_at_utc']!,
          _endedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('inserted_by_user')) {
      context.handle(
        _insertedByUserMeta,
        insertedByUser.isAcceptableOrUnknown(
          data['inserted_by_user']!,
          _insertedByUserMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_insertedByUserMeta);
    }
    if (data.containsKey('completion_status')) {
      context.handle(
        _completionStatusMeta,
        completionStatus.isAcceptableOrUnknown(
          data['completion_status']!,
          _completionStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completionStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SegmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SegmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      sequenceIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence_index'],
      )!,
      phaseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase_type'],
      )!,
      plannedDurationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_duration_ms'],
      )!,
      actualDurationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_duration_ms'],
      )!,
      startedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at_utc'],
      )!,
      endedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at_utc'],
      ),
      insertedByUser: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}inserted_by_user'],
      )!,
      completionStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completion_status'],
      )!,
    );
  }

  @override
  $WorkoutPhaseSegmentsTable createAlias(String alias) {
    return $WorkoutPhaseSegmentsTable(attachedDatabase, alias);
  }
}

class SegmentRow extends DataClass implements Insertable<SegmentRow> {
  final String id;
  final String sessionId;
  final int sequenceIndex;
  final String phaseType;
  final int plannedDurationMs;
  final int actualDurationMs;
  final int startedAtUtc;
  final int? endedAtUtc;
  final bool insertedByUser;
  final String completionStatus;
  const SegmentRow({
    required this.id,
    required this.sessionId,
    required this.sequenceIndex,
    required this.phaseType,
    required this.plannedDurationMs,
    required this.actualDurationMs,
    required this.startedAtUtc,
    this.endedAtUtc,
    required this.insertedByUser,
    required this.completionStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['sequence_index'] = Variable<int>(sequenceIndex);
    map['phase_type'] = Variable<String>(phaseType);
    map['planned_duration_ms'] = Variable<int>(plannedDurationMs);
    map['actual_duration_ms'] = Variable<int>(actualDurationMs);
    map['started_at_utc'] = Variable<int>(startedAtUtc);
    if (!nullToAbsent || endedAtUtc != null) {
      map['ended_at_utc'] = Variable<int>(endedAtUtc);
    }
    map['inserted_by_user'] = Variable<bool>(insertedByUser);
    map['completion_status'] = Variable<String>(completionStatus);
    return map;
  }

  WorkoutPhaseSegmentsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutPhaseSegmentsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      sequenceIndex: Value(sequenceIndex),
      phaseType: Value(phaseType),
      plannedDurationMs: Value(plannedDurationMs),
      actualDurationMs: Value(actualDurationMs),
      startedAtUtc: Value(startedAtUtc),
      endedAtUtc: endedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAtUtc),
      insertedByUser: Value(insertedByUser),
      completionStatus: Value(completionStatus),
    );
  }

  factory SegmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SegmentRow(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      sequenceIndex: serializer.fromJson<int>(json['sequenceIndex']),
      phaseType: serializer.fromJson<String>(json['phaseType']),
      plannedDurationMs: serializer.fromJson<int>(json['plannedDurationMs']),
      actualDurationMs: serializer.fromJson<int>(json['actualDurationMs']),
      startedAtUtc: serializer.fromJson<int>(json['startedAtUtc']),
      endedAtUtc: serializer.fromJson<int?>(json['endedAtUtc']),
      insertedByUser: serializer.fromJson<bool>(json['insertedByUser']),
      completionStatus: serializer.fromJson<String>(json['completionStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'sequenceIndex': serializer.toJson<int>(sequenceIndex),
      'phaseType': serializer.toJson<String>(phaseType),
      'plannedDurationMs': serializer.toJson<int>(plannedDurationMs),
      'actualDurationMs': serializer.toJson<int>(actualDurationMs),
      'startedAtUtc': serializer.toJson<int>(startedAtUtc),
      'endedAtUtc': serializer.toJson<int?>(endedAtUtc),
      'insertedByUser': serializer.toJson<bool>(insertedByUser),
      'completionStatus': serializer.toJson<String>(completionStatus),
    };
  }

  SegmentRow copyWith({
    String? id,
    String? sessionId,
    int? sequenceIndex,
    String? phaseType,
    int? plannedDurationMs,
    int? actualDurationMs,
    int? startedAtUtc,
    Value<int?> endedAtUtc = const Value.absent(),
    bool? insertedByUser,
    String? completionStatus,
  }) => SegmentRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    sequenceIndex: sequenceIndex ?? this.sequenceIndex,
    phaseType: phaseType ?? this.phaseType,
    plannedDurationMs: plannedDurationMs ?? this.plannedDurationMs,
    actualDurationMs: actualDurationMs ?? this.actualDurationMs,
    startedAtUtc: startedAtUtc ?? this.startedAtUtc,
    endedAtUtc: endedAtUtc.present ? endedAtUtc.value : this.endedAtUtc,
    insertedByUser: insertedByUser ?? this.insertedByUser,
    completionStatus: completionStatus ?? this.completionStatus,
  );
  SegmentRow copyWithCompanion(WorkoutPhaseSegmentsCompanion data) {
    return SegmentRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      sequenceIndex: data.sequenceIndex.present
          ? data.sequenceIndex.value
          : this.sequenceIndex,
      phaseType: data.phaseType.present ? data.phaseType.value : this.phaseType,
      plannedDurationMs: data.plannedDurationMs.present
          ? data.plannedDurationMs.value
          : this.plannedDurationMs,
      actualDurationMs: data.actualDurationMs.present
          ? data.actualDurationMs.value
          : this.actualDurationMs,
      startedAtUtc: data.startedAtUtc.present
          ? data.startedAtUtc.value
          : this.startedAtUtc,
      endedAtUtc: data.endedAtUtc.present
          ? data.endedAtUtc.value
          : this.endedAtUtc,
      insertedByUser: data.insertedByUser.present
          ? data.insertedByUser.value
          : this.insertedByUser,
      completionStatus: data.completionStatus.present
          ? data.completionStatus.value
          : this.completionStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SegmentRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('sequenceIndex: $sequenceIndex, ')
          ..write('phaseType: $phaseType, ')
          ..write('plannedDurationMs: $plannedDurationMs, ')
          ..write('actualDurationMs: $actualDurationMs, ')
          ..write('startedAtUtc: $startedAtUtc, ')
          ..write('endedAtUtc: $endedAtUtc, ')
          ..write('insertedByUser: $insertedByUser, ')
          ..write('completionStatus: $completionStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    sequenceIndex,
    phaseType,
    plannedDurationMs,
    actualDurationMs,
    startedAtUtc,
    endedAtUtc,
    insertedByUser,
    completionStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SegmentRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.sequenceIndex == this.sequenceIndex &&
          other.phaseType == this.phaseType &&
          other.plannedDurationMs == this.plannedDurationMs &&
          other.actualDurationMs == this.actualDurationMs &&
          other.startedAtUtc == this.startedAtUtc &&
          other.endedAtUtc == this.endedAtUtc &&
          other.insertedByUser == this.insertedByUser &&
          other.completionStatus == this.completionStatus);
}

class WorkoutPhaseSegmentsCompanion extends UpdateCompanion<SegmentRow> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<int> sequenceIndex;
  final Value<String> phaseType;
  final Value<int> plannedDurationMs;
  final Value<int> actualDurationMs;
  final Value<int> startedAtUtc;
  final Value<int?> endedAtUtc;
  final Value<bool> insertedByUser;
  final Value<String> completionStatus;
  final Value<int> rowid;
  const WorkoutPhaseSegmentsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.sequenceIndex = const Value.absent(),
    this.phaseType = const Value.absent(),
    this.plannedDurationMs = const Value.absent(),
    this.actualDurationMs = const Value.absent(),
    this.startedAtUtc = const Value.absent(),
    this.endedAtUtc = const Value.absent(),
    this.insertedByUser = const Value.absent(),
    this.completionStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutPhaseSegmentsCompanion.insert({
    required String id,
    required String sessionId,
    required int sequenceIndex,
    required String phaseType,
    required int plannedDurationMs,
    required int actualDurationMs,
    required int startedAtUtc,
    this.endedAtUtc = const Value.absent(),
    required bool insertedByUser,
    required String completionStatus,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       sequenceIndex = Value(sequenceIndex),
       phaseType = Value(phaseType),
       plannedDurationMs = Value(plannedDurationMs),
       actualDurationMs = Value(actualDurationMs),
       startedAtUtc = Value(startedAtUtc),
       insertedByUser = Value(insertedByUser),
       completionStatus = Value(completionStatus);
  static Insertable<SegmentRow> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<int>? sequenceIndex,
    Expression<String>? phaseType,
    Expression<int>? plannedDurationMs,
    Expression<int>? actualDurationMs,
    Expression<int>? startedAtUtc,
    Expression<int>? endedAtUtc,
    Expression<bool>? insertedByUser,
    Expression<String>? completionStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (sequenceIndex != null) 'sequence_index': sequenceIndex,
      if (phaseType != null) 'phase_type': phaseType,
      if (plannedDurationMs != null) 'planned_duration_ms': plannedDurationMs,
      if (actualDurationMs != null) 'actual_duration_ms': actualDurationMs,
      if (startedAtUtc != null) 'started_at_utc': startedAtUtc,
      if (endedAtUtc != null) 'ended_at_utc': endedAtUtc,
      if (insertedByUser != null) 'inserted_by_user': insertedByUser,
      if (completionStatus != null) 'completion_status': completionStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutPhaseSegmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<int>? sequenceIndex,
    Value<String>? phaseType,
    Value<int>? plannedDurationMs,
    Value<int>? actualDurationMs,
    Value<int>? startedAtUtc,
    Value<int?>? endedAtUtc,
    Value<bool>? insertedByUser,
    Value<String>? completionStatus,
    Value<int>? rowid,
  }) {
    return WorkoutPhaseSegmentsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      sequenceIndex: sequenceIndex ?? this.sequenceIndex,
      phaseType: phaseType ?? this.phaseType,
      plannedDurationMs: plannedDurationMs ?? this.plannedDurationMs,
      actualDurationMs: actualDurationMs ?? this.actualDurationMs,
      startedAtUtc: startedAtUtc ?? this.startedAtUtc,
      endedAtUtc: endedAtUtc ?? this.endedAtUtc,
      insertedByUser: insertedByUser ?? this.insertedByUser,
      completionStatus: completionStatus ?? this.completionStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (sequenceIndex.present) {
      map['sequence_index'] = Variable<int>(sequenceIndex.value);
    }
    if (phaseType.present) {
      map['phase_type'] = Variable<String>(phaseType.value);
    }
    if (plannedDurationMs.present) {
      map['planned_duration_ms'] = Variable<int>(plannedDurationMs.value);
    }
    if (actualDurationMs.present) {
      map['actual_duration_ms'] = Variable<int>(actualDurationMs.value);
    }
    if (startedAtUtc.present) {
      map['started_at_utc'] = Variable<int>(startedAtUtc.value);
    }
    if (endedAtUtc.present) {
      map['ended_at_utc'] = Variable<int>(endedAtUtc.value);
    }
    if (insertedByUser.present) {
      map['inserted_by_user'] = Variable<bool>(insertedByUser.value);
    }
    if (completionStatus.present) {
      map['completion_status'] = Variable<String>(completionStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPhaseSegmentsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('sequenceIndex: $sequenceIndex, ')
          ..write('phaseType: $phaseType, ')
          ..write('plannedDurationMs: $plannedDurationMs, ')
          ..write('actualDurationMs: $actualDurationMs, ')
          ..write('startedAtUtc: $startedAtUtc, ')
          ..write('endedAtUtc: $endedAtUtc, ')
          ..write('insertedByUser: $insertedByUser, ')
          ..write('completionStatus: $completionStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActiveWorkoutSnapshotsTable extends ActiveWorkoutSnapshots
    with TableInfo<$ActiveWorkoutSnapshotsTable, SnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveWorkoutSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentPhaseIdMeta = const VerificationMeta(
    'currentPhaseId',
  );
  @override
  late final GeneratedColumn<String> currentPhaseId = GeneratedColumn<String>(
    'current_phase_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentPhaseTypeMeta = const VerificationMeta(
    'currentPhaseType',
  );
  @override
  late final GeneratedColumn<String> currentPhaseType = GeneratedColumn<String>(
    'current_phase_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentSequenceIndexMeta =
      const VerificationMeta('currentSequenceIndex');
  @override
  late final GeneratedColumn<int> currentSequenceIndex = GeneratedColumn<int>(
    'current_sequence_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phasePlannedMsMeta = const VerificationMeta(
    'phasePlannedMs',
  );
  @override
  late final GeneratedColumn<int> phasePlannedMs = GeneratedColumn<int>(
    'phase_planned_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phaseDeadlineUtcMsMeta =
      const VerificationMeta('phaseDeadlineUtcMs');
  @override
  late final GeneratedColumn<int> phaseDeadlineUtcMs = GeneratedColumn<int>(
    'phase_deadline_utc_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frozenRemainingMsMeta = const VerificationMeta(
    'frozenRemainingMs',
  );
  @override
  late final GeneratedColumn<int> frozenRemainingMs = GeneratedColumn<int>(
    'frozen_remaining_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phaseStartedAtUtcMsMeta =
      const VerificationMeta('phaseStartedAtUtcMs');
  @override
  late final GeneratedColumn<int> phaseStartedAtUtcMs = GeneratedColumn<int>(
    'phase_started_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phaseInsertedByUserMeta =
      const VerificationMeta('phaseInsertedByUser');
  @override
  late final GeneratedColumn<bool> phaseInsertedByUser = GeneratedColumn<bool>(
    'phase_inserted_by_user',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("phase_inserted_by_user" IN (0, 1))',
    ),
  );
  static const VerificationMeta _phaseIsResumptionMeta = const VerificationMeta(
    'phaseIsResumption',
  );
  @override
  late final GeneratedColumn<bool> phaseIsResumption = GeneratedColumn<bool>(
    'phase_is_resumption',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("phase_is_resumption" IN (0, 1))',
    ),
  );
  static const VerificationMeta _workoutStartedAtUtcMsMeta =
      const VerificationMeta('workoutStartedAtUtcMs');
  @override
  late final GeneratedColumn<int> workoutStartedAtUtcMs = GeneratedColumn<int>(
    'workout_started_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastReconciledAtUtcMsMeta =
      const VerificationMeta('lastReconciledAtUtcMs');
  @override
  late final GeneratedColumn<int> lastReconciledAtUtcMs = GeneratedColumn<int>(
    'last_reconciled_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workIndexMeta = const VerificationMeta(
    'workIndex',
  );
  @override
  late final GeneratedColumn<int> workIndex = GeneratedColumn<int>(
    'work_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentRoundMeta = const VerificationMeta(
    'currentRound',
  );
  @override
  late final GeneratedColumn<int> currentRound = GeneratedColumn<int>(
    'current_round',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resumeRemainingMsMeta = const VerificationMeta(
    'resumeRemainingMs',
  );
  @override
  late final GeneratedColumn<int> resumeRemainingMs = GeneratedColumn<int>(
    'resume_remaining_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serializedPlanSnapshotMeta =
      const VerificationMeta('serializedPlanSnapshot');
  @override
  late final GeneratedColumn<String> serializedPlanSnapshot =
      GeneratedColumn<String>(
        'serialized_plan_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _completedSegmentsJsonMeta =
      const VerificationMeta('completedSegmentsJson');
  @override
  late final GeneratedColumn<String> completedSegmentsJson =
      GeneratedColumn<String>(
        'completed_segments_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    status,
    currentPhaseId,
    currentPhaseType,
    currentSequenceIndex,
    phasePlannedMs,
    phaseDeadlineUtcMs,
    frozenRemainingMs,
    phaseStartedAtUtcMs,
    phaseInsertedByUser,
    phaseIsResumption,
    workoutStartedAtUtcMs,
    lastReconciledAtUtcMs,
    workIndex,
    currentRound,
    resumeRemainingMs,
    serializedPlanSnapshot,
    completedSegmentsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_workout_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<SnapshotRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('current_phase_id')) {
      context.handle(
        _currentPhaseIdMeta,
        currentPhaseId.isAcceptableOrUnknown(
          data['current_phase_id']!,
          _currentPhaseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentPhaseIdMeta);
    }
    if (data.containsKey('current_phase_type')) {
      context.handle(
        _currentPhaseTypeMeta,
        currentPhaseType.isAcceptableOrUnknown(
          data['current_phase_type']!,
          _currentPhaseTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentPhaseTypeMeta);
    }
    if (data.containsKey('current_sequence_index')) {
      context.handle(
        _currentSequenceIndexMeta,
        currentSequenceIndex.isAcceptableOrUnknown(
          data['current_sequence_index']!,
          _currentSequenceIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentSequenceIndexMeta);
    }
    if (data.containsKey('phase_planned_ms')) {
      context.handle(
        _phasePlannedMsMeta,
        phasePlannedMs.isAcceptableOrUnknown(
          data['phase_planned_ms']!,
          _phasePlannedMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phasePlannedMsMeta);
    }
    if (data.containsKey('phase_deadline_utc_ms')) {
      context.handle(
        _phaseDeadlineUtcMsMeta,
        phaseDeadlineUtcMs.isAcceptableOrUnknown(
          data['phase_deadline_utc_ms']!,
          _phaseDeadlineUtcMsMeta,
        ),
      );
    }
    if (data.containsKey('frozen_remaining_ms')) {
      context.handle(
        _frozenRemainingMsMeta,
        frozenRemainingMs.isAcceptableOrUnknown(
          data['frozen_remaining_ms']!,
          _frozenRemainingMsMeta,
        ),
      );
    }
    if (data.containsKey('phase_started_at_utc_ms')) {
      context.handle(
        _phaseStartedAtUtcMsMeta,
        phaseStartedAtUtcMs.isAcceptableOrUnknown(
          data['phase_started_at_utc_ms']!,
          _phaseStartedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phaseStartedAtUtcMsMeta);
    }
    if (data.containsKey('phase_inserted_by_user')) {
      context.handle(
        _phaseInsertedByUserMeta,
        phaseInsertedByUser.isAcceptableOrUnknown(
          data['phase_inserted_by_user']!,
          _phaseInsertedByUserMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phaseInsertedByUserMeta);
    }
    if (data.containsKey('phase_is_resumption')) {
      context.handle(
        _phaseIsResumptionMeta,
        phaseIsResumption.isAcceptableOrUnknown(
          data['phase_is_resumption']!,
          _phaseIsResumptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phaseIsResumptionMeta);
    }
    if (data.containsKey('workout_started_at_utc_ms')) {
      context.handle(
        _workoutStartedAtUtcMsMeta,
        workoutStartedAtUtcMs.isAcceptableOrUnknown(
          data['workout_started_at_utc_ms']!,
          _workoutStartedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutStartedAtUtcMsMeta);
    }
    if (data.containsKey('last_reconciled_at_utc_ms')) {
      context.handle(
        _lastReconciledAtUtcMsMeta,
        lastReconciledAtUtcMs.isAcceptableOrUnknown(
          data['last_reconciled_at_utc_ms']!,
          _lastReconciledAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastReconciledAtUtcMsMeta);
    }
    if (data.containsKey('work_index')) {
      context.handle(
        _workIndexMeta,
        workIndex.isAcceptableOrUnknown(data['work_index']!, _workIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_workIndexMeta);
    }
    if (data.containsKey('current_round')) {
      context.handle(
        _currentRoundMeta,
        currentRound.isAcceptableOrUnknown(
          data['current_round']!,
          _currentRoundMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentRoundMeta);
    }
    if (data.containsKey('resume_remaining_ms')) {
      context.handle(
        _resumeRemainingMsMeta,
        resumeRemainingMs.isAcceptableOrUnknown(
          data['resume_remaining_ms']!,
          _resumeRemainingMsMeta,
        ),
      );
    }
    if (data.containsKey('serialized_plan_snapshot')) {
      context.handle(
        _serializedPlanSnapshotMeta,
        serializedPlanSnapshot.isAcceptableOrUnknown(
          data['serialized_plan_snapshot']!,
          _serializedPlanSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serializedPlanSnapshotMeta);
    }
    if (data.containsKey('completed_segments_json')) {
      context.handle(
        _completedSegmentsJsonMeta,
        completedSegmentsJson.isAcceptableOrUnknown(
          data['completed_segments_json']!,
          _completedSegmentsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedSegmentsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId};
  @override
  SnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnapshotRow(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      currentPhaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_phase_id'],
      )!,
      currentPhaseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_phase_type'],
      )!,
      currentSequenceIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_sequence_index'],
      )!,
      phasePlannedMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}phase_planned_ms'],
      )!,
      phaseDeadlineUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}phase_deadline_utc_ms'],
      ),
      frozenRemainingMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frozen_remaining_ms'],
      ),
      phaseStartedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}phase_started_at_utc_ms'],
      )!,
      phaseInsertedByUser: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}phase_inserted_by_user'],
      )!,
      phaseIsResumption: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}phase_is_resumption'],
      )!,
      workoutStartedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_started_at_utc_ms'],
      )!,
      lastReconciledAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_reconciled_at_utc_ms'],
      )!,
      workIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}work_index'],
      )!,
      currentRound: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_round'],
      )!,
      resumeRemainingMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}resume_remaining_ms'],
      ),
      serializedPlanSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serialized_plan_snapshot'],
      )!,
      completedSegmentsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_segments_json'],
      )!,
    );
  }

  @override
  $ActiveWorkoutSnapshotsTable createAlias(String alias) {
    return $ActiveWorkoutSnapshotsTable(attachedDatabase, alias);
  }
}

class SnapshotRow extends DataClass implements Insertable<SnapshotRow> {
  final String sessionId;
  final String status;
  final String currentPhaseId;
  final String currentPhaseType;
  final int currentSequenceIndex;
  final int phasePlannedMs;
  final int? phaseDeadlineUtcMs;
  final int? frozenRemainingMs;
  final int phaseStartedAtUtcMs;
  final bool phaseInsertedByUser;
  final bool phaseIsResumption;
  final int workoutStartedAtUtcMs;
  final int lastReconciledAtUtcMs;
  final int workIndex;
  final int currentRound;
  final int? resumeRemainingMs;
  final String serializedPlanSnapshot;
  final String completedSegmentsJson;
  const SnapshotRow({
    required this.sessionId,
    required this.status,
    required this.currentPhaseId,
    required this.currentPhaseType,
    required this.currentSequenceIndex,
    required this.phasePlannedMs,
    this.phaseDeadlineUtcMs,
    this.frozenRemainingMs,
    required this.phaseStartedAtUtcMs,
    required this.phaseInsertedByUser,
    required this.phaseIsResumption,
    required this.workoutStartedAtUtcMs,
    required this.lastReconciledAtUtcMs,
    required this.workIndex,
    required this.currentRound,
    this.resumeRemainingMs,
    required this.serializedPlanSnapshot,
    required this.completedSegmentsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['status'] = Variable<String>(status);
    map['current_phase_id'] = Variable<String>(currentPhaseId);
    map['current_phase_type'] = Variable<String>(currentPhaseType);
    map['current_sequence_index'] = Variable<int>(currentSequenceIndex);
    map['phase_planned_ms'] = Variable<int>(phasePlannedMs);
    if (!nullToAbsent || phaseDeadlineUtcMs != null) {
      map['phase_deadline_utc_ms'] = Variable<int>(phaseDeadlineUtcMs);
    }
    if (!nullToAbsent || frozenRemainingMs != null) {
      map['frozen_remaining_ms'] = Variable<int>(frozenRemainingMs);
    }
    map['phase_started_at_utc_ms'] = Variable<int>(phaseStartedAtUtcMs);
    map['phase_inserted_by_user'] = Variable<bool>(phaseInsertedByUser);
    map['phase_is_resumption'] = Variable<bool>(phaseIsResumption);
    map['workout_started_at_utc_ms'] = Variable<int>(workoutStartedAtUtcMs);
    map['last_reconciled_at_utc_ms'] = Variable<int>(lastReconciledAtUtcMs);
    map['work_index'] = Variable<int>(workIndex);
    map['current_round'] = Variable<int>(currentRound);
    if (!nullToAbsent || resumeRemainingMs != null) {
      map['resume_remaining_ms'] = Variable<int>(resumeRemainingMs);
    }
    map['serialized_plan_snapshot'] = Variable<String>(serializedPlanSnapshot);
    map['completed_segments_json'] = Variable<String>(completedSegmentsJson);
    return map;
  }

  ActiveWorkoutSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return ActiveWorkoutSnapshotsCompanion(
      sessionId: Value(sessionId),
      status: Value(status),
      currentPhaseId: Value(currentPhaseId),
      currentPhaseType: Value(currentPhaseType),
      currentSequenceIndex: Value(currentSequenceIndex),
      phasePlannedMs: Value(phasePlannedMs),
      phaseDeadlineUtcMs: phaseDeadlineUtcMs == null && nullToAbsent
          ? const Value.absent()
          : Value(phaseDeadlineUtcMs),
      frozenRemainingMs: frozenRemainingMs == null && nullToAbsent
          ? const Value.absent()
          : Value(frozenRemainingMs),
      phaseStartedAtUtcMs: Value(phaseStartedAtUtcMs),
      phaseInsertedByUser: Value(phaseInsertedByUser),
      phaseIsResumption: Value(phaseIsResumption),
      workoutStartedAtUtcMs: Value(workoutStartedAtUtcMs),
      lastReconciledAtUtcMs: Value(lastReconciledAtUtcMs),
      workIndex: Value(workIndex),
      currentRound: Value(currentRound),
      resumeRemainingMs: resumeRemainingMs == null && nullToAbsent
          ? const Value.absent()
          : Value(resumeRemainingMs),
      serializedPlanSnapshot: Value(serializedPlanSnapshot),
      completedSegmentsJson: Value(completedSegmentsJson),
    );
  }

  factory SnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnapshotRow(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      status: serializer.fromJson<String>(json['status']),
      currentPhaseId: serializer.fromJson<String>(json['currentPhaseId']),
      currentPhaseType: serializer.fromJson<String>(json['currentPhaseType']),
      currentSequenceIndex: serializer.fromJson<int>(
        json['currentSequenceIndex'],
      ),
      phasePlannedMs: serializer.fromJson<int>(json['phasePlannedMs']),
      phaseDeadlineUtcMs: serializer.fromJson<int?>(json['phaseDeadlineUtcMs']),
      frozenRemainingMs: serializer.fromJson<int?>(json['frozenRemainingMs']),
      phaseStartedAtUtcMs: serializer.fromJson<int>(
        json['phaseStartedAtUtcMs'],
      ),
      phaseInsertedByUser: serializer.fromJson<bool>(
        json['phaseInsertedByUser'],
      ),
      phaseIsResumption: serializer.fromJson<bool>(json['phaseIsResumption']),
      workoutStartedAtUtcMs: serializer.fromJson<int>(
        json['workoutStartedAtUtcMs'],
      ),
      lastReconciledAtUtcMs: serializer.fromJson<int>(
        json['lastReconciledAtUtcMs'],
      ),
      workIndex: serializer.fromJson<int>(json['workIndex']),
      currentRound: serializer.fromJson<int>(json['currentRound']),
      resumeRemainingMs: serializer.fromJson<int?>(json['resumeRemainingMs']),
      serializedPlanSnapshot: serializer.fromJson<String>(
        json['serializedPlanSnapshot'],
      ),
      completedSegmentsJson: serializer.fromJson<String>(
        json['completedSegmentsJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'status': serializer.toJson<String>(status),
      'currentPhaseId': serializer.toJson<String>(currentPhaseId),
      'currentPhaseType': serializer.toJson<String>(currentPhaseType),
      'currentSequenceIndex': serializer.toJson<int>(currentSequenceIndex),
      'phasePlannedMs': serializer.toJson<int>(phasePlannedMs),
      'phaseDeadlineUtcMs': serializer.toJson<int?>(phaseDeadlineUtcMs),
      'frozenRemainingMs': serializer.toJson<int?>(frozenRemainingMs),
      'phaseStartedAtUtcMs': serializer.toJson<int>(phaseStartedAtUtcMs),
      'phaseInsertedByUser': serializer.toJson<bool>(phaseInsertedByUser),
      'phaseIsResumption': serializer.toJson<bool>(phaseIsResumption),
      'workoutStartedAtUtcMs': serializer.toJson<int>(workoutStartedAtUtcMs),
      'lastReconciledAtUtcMs': serializer.toJson<int>(lastReconciledAtUtcMs),
      'workIndex': serializer.toJson<int>(workIndex),
      'currentRound': serializer.toJson<int>(currentRound),
      'resumeRemainingMs': serializer.toJson<int?>(resumeRemainingMs),
      'serializedPlanSnapshot': serializer.toJson<String>(
        serializedPlanSnapshot,
      ),
      'completedSegmentsJson': serializer.toJson<String>(completedSegmentsJson),
    };
  }

  SnapshotRow copyWith({
    String? sessionId,
    String? status,
    String? currentPhaseId,
    String? currentPhaseType,
    int? currentSequenceIndex,
    int? phasePlannedMs,
    Value<int?> phaseDeadlineUtcMs = const Value.absent(),
    Value<int?> frozenRemainingMs = const Value.absent(),
    int? phaseStartedAtUtcMs,
    bool? phaseInsertedByUser,
    bool? phaseIsResumption,
    int? workoutStartedAtUtcMs,
    int? lastReconciledAtUtcMs,
    int? workIndex,
    int? currentRound,
    Value<int?> resumeRemainingMs = const Value.absent(),
    String? serializedPlanSnapshot,
    String? completedSegmentsJson,
  }) => SnapshotRow(
    sessionId: sessionId ?? this.sessionId,
    status: status ?? this.status,
    currentPhaseId: currentPhaseId ?? this.currentPhaseId,
    currentPhaseType: currentPhaseType ?? this.currentPhaseType,
    currentSequenceIndex: currentSequenceIndex ?? this.currentSequenceIndex,
    phasePlannedMs: phasePlannedMs ?? this.phasePlannedMs,
    phaseDeadlineUtcMs: phaseDeadlineUtcMs.present
        ? phaseDeadlineUtcMs.value
        : this.phaseDeadlineUtcMs,
    frozenRemainingMs: frozenRemainingMs.present
        ? frozenRemainingMs.value
        : this.frozenRemainingMs,
    phaseStartedAtUtcMs: phaseStartedAtUtcMs ?? this.phaseStartedAtUtcMs,
    phaseInsertedByUser: phaseInsertedByUser ?? this.phaseInsertedByUser,
    phaseIsResumption: phaseIsResumption ?? this.phaseIsResumption,
    workoutStartedAtUtcMs: workoutStartedAtUtcMs ?? this.workoutStartedAtUtcMs,
    lastReconciledAtUtcMs: lastReconciledAtUtcMs ?? this.lastReconciledAtUtcMs,
    workIndex: workIndex ?? this.workIndex,
    currentRound: currentRound ?? this.currentRound,
    resumeRemainingMs: resumeRemainingMs.present
        ? resumeRemainingMs.value
        : this.resumeRemainingMs,
    serializedPlanSnapshot:
        serializedPlanSnapshot ?? this.serializedPlanSnapshot,
    completedSegmentsJson: completedSegmentsJson ?? this.completedSegmentsJson,
  );
  SnapshotRow copyWithCompanion(ActiveWorkoutSnapshotsCompanion data) {
    return SnapshotRow(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      status: data.status.present ? data.status.value : this.status,
      currentPhaseId: data.currentPhaseId.present
          ? data.currentPhaseId.value
          : this.currentPhaseId,
      currentPhaseType: data.currentPhaseType.present
          ? data.currentPhaseType.value
          : this.currentPhaseType,
      currentSequenceIndex: data.currentSequenceIndex.present
          ? data.currentSequenceIndex.value
          : this.currentSequenceIndex,
      phasePlannedMs: data.phasePlannedMs.present
          ? data.phasePlannedMs.value
          : this.phasePlannedMs,
      phaseDeadlineUtcMs: data.phaseDeadlineUtcMs.present
          ? data.phaseDeadlineUtcMs.value
          : this.phaseDeadlineUtcMs,
      frozenRemainingMs: data.frozenRemainingMs.present
          ? data.frozenRemainingMs.value
          : this.frozenRemainingMs,
      phaseStartedAtUtcMs: data.phaseStartedAtUtcMs.present
          ? data.phaseStartedAtUtcMs.value
          : this.phaseStartedAtUtcMs,
      phaseInsertedByUser: data.phaseInsertedByUser.present
          ? data.phaseInsertedByUser.value
          : this.phaseInsertedByUser,
      phaseIsResumption: data.phaseIsResumption.present
          ? data.phaseIsResumption.value
          : this.phaseIsResumption,
      workoutStartedAtUtcMs: data.workoutStartedAtUtcMs.present
          ? data.workoutStartedAtUtcMs.value
          : this.workoutStartedAtUtcMs,
      lastReconciledAtUtcMs: data.lastReconciledAtUtcMs.present
          ? data.lastReconciledAtUtcMs.value
          : this.lastReconciledAtUtcMs,
      workIndex: data.workIndex.present ? data.workIndex.value : this.workIndex,
      currentRound: data.currentRound.present
          ? data.currentRound.value
          : this.currentRound,
      resumeRemainingMs: data.resumeRemainingMs.present
          ? data.resumeRemainingMs.value
          : this.resumeRemainingMs,
      serializedPlanSnapshot: data.serializedPlanSnapshot.present
          ? data.serializedPlanSnapshot.value
          : this.serializedPlanSnapshot,
      completedSegmentsJson: data.completedSegmentsJson.present
          ? data.completedSegmentsJson.value
          : this.completedSegmentsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnapshotRow(')
          ..write('sessionId: $sessionId, ')
          ..write('status: $status, ')
          ..write('currentPhaseId: $currentPhaseId, ')
          ..write('currentPhaseType: $currentPhaseType, ')
          ..write('currentSequenceIndex: $currentSequenceIndex, ')
          ..write('phasePlannedMs: $phasePlannedMs, ')
          ..write('phaseDeadlineUtcMs: $phaseDeadlineUtcMs, ')
          ..write('frozenRemainingMs: $frozenRemainingMs, ')
          ..write('phaseStartedAtUtcMs: $phaseStartedAtUtcMs, ')
          ..write('phaseInsertedByUser: $phaseInsertedByUser, ')
          ..write('phaseIsResumption: $phaseIsResumption, ')
          ..write('workoutStartedAtUtcMs: $workoutStartedAtUtcMs, ')
          ..write('lastReconciledAtUtcMs: $lastReconciledAtUtcMs, ')
          ..write('workIndex: $workIndex, ')
          ..write('currentRound: $currentRound, ')
          ..write('resumeRemainingMs: $resumeRemainingMs, ')
          ..write('serializedPlanSnapshot: $serializedPlanSnapshot, ')
          ..write('completedSegmentsJson: $completedSegmentsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sessionId,
    status,
    currentPhaseId,
    currentPhaseType,
    currentSequenceIndex,
    phasePlannedMs,
    phaseDeadlineUtcMs,
    frozenRemainingMs,
    phaseStartedAtUtcMs,
    phaseInsertedByUser,
    phaseIsResumption,
    workoutStartedAtUtcMs,
    lastReconciledAtUtcMs,
    workIndex,
    currentRound,
    resumeRemainingMs,
    serializedPlanSnapshot,
    completedSegmentsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnapshotRow &&
          other.sessionId == this.sessionId &&
          other.status == this.status &&
          other.currentPhaseId == this.currentPhaseId &&
          other.currentPhaseType == this.currentPhaseType &&
          other.currentSequenceIndex == this.currentSequenceIndex &&
          other.phasePlannedMs == this.phasePlannedMs &&
          other.phaseDeadlineUtcMs == this.phaseDeadlineUtcMs &&
          other.frozenRemainingMs == this.frozenRemainingMs &&
          other.phaseStartedAtUtcMs == this.phaseStartedAtUtcMs &&
          other.phaseInsertedByUser == this.phaseInsertedByUser &&
          other.phaseIsResumption == this.phaseIsResumption &&
          other.workoutStartedAtUtcMs == this.workoutStartedAtUtcMs &&
          other.lastReconciledAtUtcMs == this.lastReconciledAtUtcMs &&
          other.workIndex == this.workIndex &&
          other.currentRound == this.currentRound &&
          other.resumeRemainingMs == this.resumeRemainingMs &&
          other.serializedPlanSnapshot == this.serializedPlanSnapshot &&
          other.completedSegmentsJson == this.completedSegmentsJson);
}

class ActiveWorkoutSnapshotsCompanion extends UpdateCompanion<SnapshotRow> {
  final Value<String> sessionId;
  final Value<String> status;
  final Value<String> currentPhaseId;
  final Value<String> currentPhaseType;
  final Value<int> currentSequenceIndex;
  final Value<int> phasePlannedMs;
  final Value<int?> phaseDeadlineUtcMs;
  final Value<int?> frozenRemainingMs;
  final Value<int> phaseStartedAtUtcMs;
  final Value<bool> phaseInsertedByUser;
  final Value<bool> phaseIsResumption;
  final Value<int> workoutStartedAtUtcMs;
  final Value<int> lastReconciledAtUtcMs;
  final Value<int> workIndex;
  final Value<int> currentRound;
  final Value<int?> resumeRemainingMs;
  final Value<String> serializedPlanSnapshot;
  final Value<String> completedSegmentsJson;
  final Value<int> rowid;
  const ActiveWorkoutSnapshotsCompanion({
    this.sessionId = const Value.absent(),
    this.status = const Value.absent(),
    this.currentPhaseId = const Value.absent(),
    this.currentPhaseType = const Value.absent(),
    this.currentSequenceIndex = const Value.absent(),
    this.phasePlannedMs = const Value.absent(),
    this.phaseDeadlineUtcMs = const Value.absent(),
    this.frozenRemainingMs = const Value.absent(),
    this.phaseStartedAtUtcMs = const Value.absent(),
    this.phaseInsertedByUser = const Value.absent(),
    this.phaseIsResumption = const Value.absent(),
    this.workoutStartedAtUtcMs = const Value.absent(),
    this.lastReconciledAtUtcMs = const Value.absent(),
    this.workIndex = const Value.absent(),
    this.currentRound = const Value.absent(),
    this.resumeRemainingMs = const Value.absent(),
    this.serializedPlanSnapshot = const Value.absent(),
    this.completedSegmentsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActiveWorkoutSnapshotsCompanion.insert({
    required String sessionId,
    required String status,
    required String currentPhaseId,
    required String currentPhaseType,
    required int currentSequenceIndex,
    required int phasePlannedMs,
    this.phaseDeadlineUtcMs = const Value.absent(),
    this.frozenRemainingMs = const Value.absent(),
    required int phaseStartedAtUtcMs,
    required bool phaseInsertedByUser,
    required bool phaseIsResumption,
    required int workoutStartedAtUtcMs,
    required int lastReconciledAtUtcMs,
    required int workIndex,
    required int currentRound,
    this.resumeRemainingMs = const Value.absent(),
    required String serializedPlanSnapshot,
    required String completedSegmentsJson,
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       status = Value(status),
       currentPhaseId = Value(currentPhaseId),
       currentPhaseType = Value(currentPhaseType),
       currentSequenceIndex = Value(currentSequenceIndex),
       phasePlannedMs = Value(phasePlannedMs),
       phaseStartedAtUtcMs = Value(phaseStartedAtUtcMs),
       phaseInsertedByUser = Value(phaseInsertedByUser),
       phaseIsResumption = Value(phaseIsResumption),
       workoutStartedAtUtcMs = Value(workoutStartedAtUtcMs),
       lastReconciledAtUtcMs = Value(lastReconciledAtUtcMs),
       workIndex = Value(workIndex),
       currentRound = Value(currentRound),
       serializedPlanSnapshot = Value(serializedPlanSnapshot),
       completedSegmentsJson = Value(completedSegmentsJson);
  static Insertable<SnapshotRow> custom({
    Expression<String>? sessionId,
    Expression<String>? status,
    Expression<String>? currentPhaseId,
    Expression<String>? currentPhaseType,
    Expression<int>? currentSequenceIndex,
    Expression<int>? phasePlannedMs,
    Expression<int>? phaseDeadlineUtcMs,
    Expression<int>? frozenRemainingMs,
    Expression<int>? phaseStartedAtUtcMs,
    Expression<bool>? phaseInsertedByUser,
    Expression<bool>? phaseIsResumption,
    Expression<int>? workoutStartedAtUtcMs,
    Expression<int>? lastReconciledAtUtcMs,
    Expression<int>? workIndex,
    Expression<int>? currentRound,
    Expression<int>? resumeRemainingMs,
    Expression<String>? serializedPlanSnapshot,
    Expression<String>? completedSegmentsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (status != null) 'status': status,
      if (currentPhaseId != null) 'current_phase_id': currentPhaseId,
      if (currentPhaseType != null) 'current_phase_type': currentPhaseType,
      if (currentSequenceIndex != null)
        'current_sequence_index': currentSequenceIndex,
      if (phasePlannedMs != null) 'phase_planned_ms': phasePlannedMs,
      if (phaseDeadlineUtcMs != null)
        'phase_deadline_utc_ms': phaseDeadlineUtcMs,
      if (frozenRemainingMs != null) 'frozen_remaining_ms': frozenRemainingMs,
      if (phaseStartedAtUtcMs != null)
        'phase_started_at_utc_ms': phaseStartedAtUtcMs,
      if (phaseInsertedByUser != null)
        'phase_inserted_by_user': phaseInsertedByUser,
      if (phaseIsResumption != null) 'phase_is_resumption': phaseIsResumption,
      if (workoutStartedAtUtcMs != null)
        'workout_started_at_utc_ms': workoutStartedAtUtcMs,
      if (lastReconciledAtUtcMs != null)
        'last_reconciled_at_utc_ms': lastReconciledAtUtcMs,
      if (workIndex != null) 'work_index': workIndex,
      if (currentRound != null) 'current_round': currentRound,
      if (resumeRemainingMs != null) 'resume_remaining_ms': resumeRemainingMs,
      if (serializedPlanSnapshot != null)
        'serialized_plan_snapshot': serializedPlanSnapshot,
      if (completedSegmentsJson != null)
        'completed_segments_json': completedSegmentsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActiveWorkoutSnapshotsCompanion copyWith({
    Value<String>? sessionId,
    Value<String>? status,
    Value<String>? currentPhaseId,
    Value<String>? currentPhaseType,
    Value<int>? currentSequenceIndex,
    Value<int>? phasePlannedMs,
    Value<int?>? phaseDeadlineUtcMs,
    Value<int?>? frozenRemainingMs,
    Value<int>? phaseStartedAtUtcMs,
    Value<bool>? phaseInsertedByUser,
    Value<bool>? phaseIsResumption,
    Value<int>? workoutStartedAtUtcMs,
    Value<int>? lastReconciledAtUtcMs,
    Value<int>? workIndex,
    Value<int>? currentRound,
    Value<int?>? resumeRemainingMs,
    Value<String>? serializedPlanSnapshot,
    Value<String>? completedSegmentsJson,
    Value<int>? rowid,
  }) {
    return ActiveWorkoutSnapshotsCompanion(
      sessionId: sessionId ?? this.sessionId,
      status: status ?? this.status,
      currentPhaseId: currentPhaseId ?? this.currentPhaseId,
      currentPhaseType: currentPhaseType ?? this.currentPhaseType,
      currentSequenceIndex: currentSequenceIndex ?? this.currentSequenceIndex,
      phasePlannedMs: phasePlannedMs ?? this.phasePlannedMs,
      phaseDeadlineUtcMs: phaseDeadlineUtcMs ?? this.phaseDeadlineUtcMs,
      frozenRemainingMs: frozenRemainingMs ?? this.frozenRemainingMs,
      phaseStartedAtUtcMs: phaseStartedAtUtcMs ?? this.phaseStartedAtUtcMs,
      phaseInsertedByUser: phaseInsertedByUser ?? this.phaseInsertedByUser,
      phaseIsResumption: phaseIsResumption ?? this.phaseIsResumption,
      workoutStartedAtUtcMs:
          workoutStartedAtUtcMs ?? this.workoutStartedAtUtcMs,
      lastReconciledAtUtcMs:
          lastReconciledAtUtcMs ?? this.lastReconciledAtUtcMs,
      workIndex: workIndex ?? this.workIndex,
      currentRound: currentRound ?? this.currentRound,
      resumeRemainingMs: resumeRemainingMs ?? this.resumeRemainingMs,
      serializedPlanSnapshot:
          serializedPlanSnapshot ?? this.serializedPlanSnapshot,
      completedSegmentsJson:
          completedSegmentsJson ?? this.completedSegmentsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (currentPhaseId.present) {
      map['current_phase_id'] = Variable<String>(currentPhaseId.value);
    }
    if (currentPhaseType.present) {
      map['current_phase_type'] = Variable<String>(currentPhaseType.value);
    }
    if (currentSequenceIndex.present) {
      map['current_sequence_index'] = Variable<int>(currentSequenceIndex.value);
    }
    if (phasePlannedMs.present) {
      map['phase_planned_ms'] = Variable<int>(phasePlannedMs.value);
    }
    if (phaseDeadlineUtcMs.present) {
      map['phase_deadline_utc_ms'] = Variable<int>(phaseDeadlineUtcMs.value);
    }
    if (frozenRemainingMs.present) {
      map['frozen_remaining_ms'] = Variable<int>(frozenRemainingMs.value);
    }
    if (phaseStartedAtUtcMs.present) {
      map['phase_started_at_utc_ms'] = Variable<int>(phaseStartedAtUtcMs.value);
    }
    if (phaseInsertedByUser.present) {
      map['phase_inserted_by_user'] = Variable<bool>(phaseInsertedByUser.value);
    }
    if (phaseIsResumption.present) {
      map['phase_is_resumption'] = Variable<bool>(phaseIsResumption.value);
    }
    if (workoutStartedAtUtcMs.present) {
      map['workout_started_at_utc_ms'] = Variable<int>(
        workoutStartedAtUtcMs.value,
      );
    }
    if (lastReconciledAtUtcMs.present) {
      map['last_reconciled_at_utc_ms'] = Variable<int>(
        lastReconciledAtUtcMs.value,
      );
    }
    if (workIndex.present) {
      map['work_index'] = Variable<int>(workIndex.value);
    }
    if (currentRound.present) {
      map['current_round'] = Variable<int>(currentRound.value);
    }
    if (resumeRemainingMs.present) {
      map['resume_remaining_ms'] = Variable<int>(resumeRemainingMs.value);
    }
    if (serializedPlanSnapshot.present) {
      map['serialized_plan_snapshot'] = Variable<String>(
        serializedPlanSnapshot.value,
      );
    }
    if (completedSegmentsJson.present) {
      map['completed_segments_json'] = Variable<String>(
        completedSegmentsJson.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveWorkoutSnapshotsCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('status: $status, ')
          ..write('currentPhaseId: $currentPhaseId, ')
          ..write('currentPhaseType: $currentPhaseType, ')
          ..write('currentSequenceIndex: $currentSequenceIndex, ')
          ..write('phasePlannedMs: $phasePlannedMs, ')
          ..write('phaseDeadlineUtcMs: $phaseDeadlineUtcMs, ')
          ..write('frozenRemainingMs: $frozenRemainingMs, ')
          ..write('phaseStartedAtUtcMs: $phaseStartedAtUtcMs, ')
          ..write('phaseInsertedByUser: $phaseInsertedByUser, ')
          ..write('phaseIsResumption: $phaseIsResumption, ')
          ..write('workoutStartedAtUtcMs: $workoutStartedAtUtcMs, ')
          ..write('lastReconciledAtUtcMs: $lastReconciledAtUtcMs, ')
          ..write('workIndex: $workIndex, ')
          ..write('currentRound: $currentRound, ')
          ..write('resumeRemainingMs: $resumeRemainingMs, ')
          ..write('serializedPlanSnapshot: $serializedPlanSnapshot, ')
          ..write('completedSegmentsJson: $completedSegmentsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FitnessProfilesTable extends FitnessProfiles
    with TableInfo<$FitnessProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FitnessProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMmMeta = const VerificationMeta(
    'heightMm',
  );
  @override
  late final GeneratedColumn<int> heightMm = GeneratedColumn<int>(
    'height_mm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preferredHeightUnitMeta =
      const VerificationMeta('preferredHeightUnit');
  @override
  late final GeneratedColumn<String> preferredHeightUnit =
      GeneratedColumn<String>(
        'preferred_height_unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _preferredWeightUnitMeta =
      const VerificationMeta('preferredWeightUnit');
  @override
  late final GeneratedColumn<String> preferredWeightUnit =
      GeneratedColumn<String>(
        'preferred_weight_unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtc = GeneratedColumn<int>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    heightMm,
    preferredHeightUnit,
    preferredWeightUnit,
    updatedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fitness_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('height_mm')) {
      context.handle(
        _heightMmMeta,
        heightMm.isAcceptableOrUnknown(data['height_mm']!, _heightMmMeta),
      );
    }
    if (data.containsKey('preferred_height_unit')) {
      context.handle(
        _preferredHeightUnitMeta,
        preferredHeightUnit.isAcceptableOrUnknown(
          data['preferred_height_unit']!,
          _preferredHeightUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preferredHeightUnitMeta);
    }
    if (data.containsKey('preferred_weight_unit')) {
      context.handle(
        _preferredWeightUnitMeta,
        preferredWeightUnit.isAcceptableOrUnknown(
          data['preferred_weight_unit']!,
          _preferredWeightUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preferredWeightUnitMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      heightMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height_mm'],
      ),
      preferredHeightUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_height_unit'],
      )!,
      preferredWeightUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_weight_unit'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc'],
      )!,
    );
  }

  @override
  $FitnessProfilesTable createAlias(String alias) {
    return $FitnessProfilesTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  /// Always [AppDatabase.profileId].
  final int id;
  final int? heightMm;
  final String preferredHeightUnit;
  final String preferredWeightUnit;
  final int updatedAtUtc;
  const ProfileRow({
    required this.id,
    this.heightMm,
    required this.preferredHeightUnit,
    required this.preferredWeightUnit,
    required this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || heightMm != null) {
      map['height_mm'] = Variable<int>(heightMm);
    }
    map['preferred_height_unit'] = Variable<String>(preferredHeightUnit);
    map['preferred_weight_unit'] = Variable<String>(preferredWeightUnit);
    map['updated_at_utc'] = Variable<int>(updatedAtUtc);
    return map;
  }

  FitnessProfilesCompanion toCompanion(bool nullToAbsent) {
    return FitnessProfilesCompanion(
      id: Value(id),
      heightMm: heightMm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightMm),
      preferredHeightUnit: Value(preferredHeightUnit),
      preferredWeightUnit: Value(preferredWeightUnit),
      updatedAtUtc: Value(updatedAtUtc),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<int>(json['id']),
      heightMm: serializer.fromJson<int?>(json['heightMm']),
      preferredHeightUnit: serializer.fromJson<String>(
        json['preferredHeightUnit'],
      ),
      preferredWeightUnit: serializer.fromJson<String>(
        json['preferredWeightUnit'],
      ),
      updatedAtUtc: serializer.fromJson<int>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'heightMm': serializer.toJson<int?>(heightMm),
      'preferredHeightUnit': serializer.toJson<String>(preferredHeightUnit),
      'preferredWeightUnit': serializer.toJson<String>(preferredWeightUnit),
      'updatedAtUtc': serializer.toJson<int>(updatedAtUtc),
    };
  }

  ProfileRow copyWith({
    int? id,
    Value<int?> heightMm = const Value.absent(),
    String? preferredHeightUnit,
    String? preferredWeightUnit,
    int? updatedAtUtc,
  }) => ProfileRow(
    id: id ?? this.id,
    heightMm: heightMm.present ? heightMm.value : this.heightMm,
    preferredHeightUnit: preferredHeightUnit ?? this.preferredHeightUnit,
    preferredWeightUnit: preferredWeightUnit ?? this.preferredWeightUnit,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
  );
  ProfileRow copyWithCompanion(FitnessProfilesCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      heightMm: data.heightMm.present ? data.heightMm.value : this.heightMm,
      preferredHeightUnit: data.preferredHeightUnit.present
          ? data.preferredHeightUnit.value
          : this.preferredHeightUnit,
      preferredWeightUnit: data.preferredWeightUnit.present
          ? data.preferredWeightUnit.value
          : this.preferredWeightUnit,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('heightMm: $heightMm, ')
          ..write('preferredHeightUnit: $preferredHeightUnit, ')
          ..write('preferredWeightUnit: $preferredWeightUnit, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    heightMm,
    preferredHeightUnit,
    preferredWeightUnit,
    updatedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.heightMm == this.heightMm &&
          other.preferredHeightUnit == this.preferredHeightUnit &&
          other.preferredWeightUnit == this.preferredWeightUnit &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class FitnessProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<int> id;
  final Value<int?> heightMm;
  final Value<String> preferredHeightUnit;
  final Value<String> preferredWeightUnit;
  final Value<int> updatedAtUtc;
  const FitnessProfilesCompanion({
    this.id = const Value.absent(),
    this.heightMm = const Value.absent(),
    this.preferredHeightUnit = const Value.absent(),
    this.preferredWeightUnit = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
  });
  FitnessProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.heightMm = const Value.absent(),
    required String preferredHeightUnit,
    required String preferredWeightUnit,
    required int updatedAtUtc,
  }) : preferredHeightUnit = Value(preferredHeightUnit),
       preferredWeightUnit = Value(preferredWeightUnit),
       updatedAtUtc = Value(updatedAtUtc);
  static Insertable<ProfileRow> custom({
    Expression<int>? id,
    Expression<int>? heightMm,
    Expression<String>? preferredHeightUnit,
    Expression<String>? preferredWeightUnit,
    Expression<int>? updatedAtUtc,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (heightMm != null) 'height_mm': heightMm,
      if (preferredHeightUnit != null)
        'preferred_height_unit': preferredHeightUnit,
      if (preferredWeightUnit != null)
        'preferred_weight_unit': preferredWeightUnit,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
    });
  }

  FitnessProfilesCompanion copyWith({
    Value<int>? id,
    Value<int?>? heightMm,
    Value<String>? preferredHeightUnit,
    Value<String>? preferredWeightUnit,
    Value<int>? updatedAtUtc,
  }) {
    return FitnessProfilesCompanion(
      id: id ?? this.id,
      heightMm: heightMm ?? this.heightMm,
      preferredHeightUnit: preferredHeightUnit ?? this.preferredHeightUnit,
      preferredWeightUnit: preferredWeightUnit ?? this.preferredWeightUnit,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (heightMm.present) {
      map['height_mm'] = Variable<int>(heightMm.value);
    }
    if (preferredHeightUnit.present) {
      map['preferred_height_unit'] = Variable<String>(
        preferredHeightUnit.value,
      );
    }
    if (preferredWeightUnit.present) {
      map['preferred_weight_unit'] = Variable<String>(
        preferredWeightUnit.value,
      );
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<int>(updatedAtUtc.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FitnessProfilesCompanion(')
          ..write('id: $id, ')
          ..write('heightMm: $heightMm, ')
          ..write('preferredHeightUnit: $preferredHeightUnit, ')
          ..write('preferredWeightUnit: $preferredWeightUnit, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }
}

class $WeightMeasurementsTable extends WeightMeasurements
    with TableInfo<$WeightMeasurementsTable, WeightRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightMeasurementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measuredAtUtcMeta = const VerificationMeta(
    'measuredAtUtc',
  );
  @override
  late final GeneratedColumn<int> measuredAtUtc = GeneratedColumn<int>(
    'measured_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightGramsMeta = const VerificationMeta(
    'weightGrams',
  );
  @override
  late final GeneratedColumn<int> weightGrams = GeneratedColumn<int>(
    'weight_grams',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<int> createdAtUtc = GeneratedColumn<int>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    measuredAtUtc,
    weightGrams,
    note,
    createdAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_measurements';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('measured_at_utc')) {
      context.handle(
        _measuredAtUtcMeta,
        measuredAtUtc.isAcceptableOrUnknown(
          data['measured_at_utc']!,
          _measuredAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measuredAtUtcMeta);
    }
    if (data.containsKey('weight_grams')) {
      context.handle(
        _weightGramsMeta,
        weightGrams.isAcceptableOrUnknown(
          data['weight_grams']!,
          _weightGramsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weightGramsMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      measuredAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}measured_at_utc'],
      )!,
      weightGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight_grams'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  $WeightMeasurementsTable createAlias(String alias) {
    return $WeightMeasurementsTable(attachedDatabase, alias);
  }
}

class WeightRow extends DataClass implements Insertable<WeightRow> {
  final String id;
  final int measuredAtUtc;
  final int weightGrams;
  final String? note;
  final int createdAtUtc;
  const WeightRow({
    required this.id,
    required this.measuredAtUtc,
    required this.weightGrams,
    this.note,
    required this.createdAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['measured_at_utc'] = Variable<int>(measuredAtUtc);
    map['weight_grams'] = Variable<int>(weightGrams);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    return map;
  }

  WeightMeasurementsCompanion toCompanion(bool nullToAbsent) {
    return WeightMeasurementsCompanion(
      id: Value(id),
      measuredAtUtc: Value(measuredAtUtc),
      weightGrams: Value(weightGrams),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory WeightRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightRow(
      id: serializer.fromJson<String>(json['id']),
      measuredAtUtc: serializer.fromJson<int>(json['measuredAtUtc']),
      weightGrams: serializer.fromJson<int>(json['weightGrams']),
      note: serializer.fromJson<String?>(json['note']),
      createdAtUtc: serializer.fromJson<int>(json['createdAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'measuredAtUtc': serializer.toJson<int>(measuredAtUtc),
      'weightGrams': serializer.toJson<int>(weightGrams),
      'note': serializer.toJson<String?>(note),
      'createdAtUtc': serializer.toJson<int>(createdAtUtc),
    };
  }

  WeightRow copyWith({
    String? id,
    int? measuredAtUtc,
    int? weightGrams,
    Value<String?> note = const Value.absent(),
    int? createdAtUtc,
  }) => WeightRow(
    id: id ?? this.id,
    measuredAtUtc: measuredAtUtc ?? this.measuredAtUtc,
    weightGrams: weightGrams ?? this.weightGrams,
    note: note.present ? note.value : this.note,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
  );
  WeightRow copyWithCompanion(WeightMeasurementsCompanion data) {
    return WeightRow(
      id: data.id.present ? data.id.value : this.id,
      measuredAtUtc: data.measuredAtUtc.present
          ? data.measuredAtUtc.value
          : this.measuredAtUtc,
      weightGrams: data.weightGrams.present
          ? data.weightGrams.value
          : this.weightGrams,
      note: data.note.present ? data.note.value : this.note,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightRow(')
          ..write('id: $id, ')
          ..write('measuredAtUtc: $measuredAtUtc, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('note: $note, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, measuredAtUtc, weightGrams, note, createdAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightRow &&
          other.id == this.id &&
          other.measuredAtUtc == this.measuredAtUtc &&
          other.weightGrams == this.weightGrams &&
          other.note == this.note &&
          other.createdAtUtc == this.createdAtUtc);
}

class WeightMeasurementsCompanion extends UpdateCompanion<WeightRow> {
  final Value<String> id;
  final Value<int> measuredAtUtc;
  final Value<int> weightGrams;
  final Value<String?> note;
  final Value<int> createdAtUtc;
  final Value<int> rowid;
  const WeightMeasurementsCompanion({
    this.id = const Value.absent(),
    this.measuredAtUtc = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeightMeasurementsCompanion.insert({
    required String id,
    required int measuredAtUtc,
    required int weightGrams,
    this.note = const Value.absent(),
    required int createdAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       measuredAtUtc = Value(measuredAtUtc),
       weightGrams = Value(weightGrams),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<WeightRow> custom({
    Expression<String>? id,
    Expression<int>? measuredAtUtc,
    Expression<int>? weightGrams,
    Expression<String>? note,
    Expression<int>? createdAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (measuredAtUtc != null) 'measured_at_utc': measuredAtUtc,
      if (weightGrams != null) 'weight_grams': weightGrams,
      if (note != null) 'note': note,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeightMeasurementsCompanion copyWith({
    Value<String>? id,
    Value<int>? measuredAtUtc,
    Value<int>? weightGrams,
    Value<String?>? note,
    Value<int>? createdAtUtc,
    Value<int>? rowid,
  }) {
    return WeightMeasurementsCompanion(
      id: id ?? this.id,
      measuredAtUtc: measuredAtUtc ?? this.measuredAtUtc,
      weightGrams: weightGrams ?? this.weightGrams,
      note: note ?? this.note,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (measuredAtUtc.present) {
      map['measured_at_utc'] = Variable<int>(measuredAtUtc.value);
    }
    if (weightGrams.present) {
      map['weight_grams'] = Variable<int>(weightGrams.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<int>(createdAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightMeasurementsCompanion(')
          ..write('id: $id, ')
          ..write('measuredAtUtc: $measuredAtUtc, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('note: $note, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $WorkoutPhaseSegmentsTable workoutPhaseSegments =
      $WorkoutPhaseSegmentsTable(this);
  late final $ActiveWorkoutSnapshotsTable activeWorkoutSnapshots =
      $ActiveWorkoutSnapshotsTable(this);
  late final $FitnessProfilesTable fitnessProfiles = $FitnessProfilesTable(
    this,
  );
  late final $WeightMeasurementsTable weightMeasurements =
      $WeightMeasurementsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workoutSessions,
    workoutPhaseSegments,
    activeWorkoutSnapshots,
    fitnessProfiles,
    weightMeasurements,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_phase_segments', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      required String id,
      required int startedAtUtc,
      Value<int?> endedAtUtc,
      required String status,
      Value<String?> completionReason,
      required int totalElapsedMs,
      required int activeDurationMs,
      required int walkingDurationMs,
      required int runningDurationMs,
      required int restDurationMs,
      required int completedRounds,
      required String planSnapshotJson,
      Value<double?> estimatedCaloriesKcal,
      Value<String?> calorieMethodVersion,
      Value<int?> calorieWeightGrams,
      Value<String?> calorieAssumptionsJson,
      required int createdAtUtc,
      required int updatedAtUtc,
      Value<int> rowid,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<String> id,
      Value<int> startedAtUtc,
      Value<int?> endedAtUtc,
      Value<String> status,
      Value<String?> completionReason,
      Value<int> totalElapsedMs,
      Value<int> activeDurationMs,
      Value<int> walkingDurationMs,
      Value<int> runningDurationMs,
      Value<int> restDurationMs,
      Value<int> completedRounds,
      Value<String> planSnapshotJson,
      Value<double?> estimatedCaloriesKcal,
      Value<String?> calorieMethodVersion,
      Value<int?> calorieWeightGrams,
      Value<String?> calorieAssumptionsJson,
      Value<int> createdAtUtc,
      Value<int> updatedAtUtc,
      Value<int> rowid,
    });

final class $$WorkoutSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutSessionsTable, SessionRow> {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$WorkoutPhaseSegmentsTable, List<SegmentRow>>
  _workoutPhaseSegmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutPhaseSegments,
        aliasName: 'workout_sessions__id__workout_phase_segments__session_id',
      );

  $$WorkoutPhaseSegmentsTableProcessedTableManager
  get workoutPhaseSegmentsRefs {
    final manager = $$WorkoutPhaseSegmentsTableTableManager(
      $_db,
      $_db.workoutPhaseSegments,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutPhaseSegmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAtUtc => $composableBuilder(
    column: $table.endedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completionReason => $composableBuilder(
    column: $table.completionReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalElapsedMs => $composableBuilder(
    column: $table.totalElapsedMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activeDurationMs => $composableBuilder(
    column: $table.activeDurationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walkingDurationMs => $composableBuilder(
    column: $table.walkingDurationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get runningDurationMs => $composableBuilder(
    column: $table.runningDurationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restDurationMs => $composableBuilder(
    column: $table.restDurationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedRounds => $composableBuilder(
    column: $table.completedRounds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planSnapshotJson => $composableBuilder(
    column: $table.planSnapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedCaloriesKcal => $composableBuilder(
    column: $table.estimatedCaloriesKcal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calorieMethodVersion => $composableBuilder(
    column: $table.calorieMethodVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calorieWeightGrams => $composableBuilder(
    column: $table.calorieWeightGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calorieAssumptionsJson => $composableBuilder(
    column: $table.calorieAssumptionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutPhaseSegmentsRefs(
    Expression<bool> Function($$WorkoutPhaseSegmentsTableFilterComposer f) f,
  ) {
    final $$WorkoutPhaseSegmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutPhaseSegments,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutPhaseSegmentsTableFilterComposer(
            $db: $db,
            $table: $db.workoutPhaseSegments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAtUtc => $composableBuilder(
    column: $table.endedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completionReason => $composableBuilder(
    column: $table.completionReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalElapsedMs => $composableBuilder(
    column: $table.totalElapsedMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeDurationMs => $composableBuilder(
    column: $table.activeDurationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walkingDurationMs => $composableBuilder(
    column: $table.walkingDurationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get runningDurationMs => $composableBuilder(
    column: $table.runningDurationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restDurationMs => $composableBuilder(
    column: $table.restDurationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedRounds => $composableBuilder(
    column: $table.completedRounds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planSnapshotJson => $composableBuilder(
    column: $table.planSnapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedCaloriesKcal => $composableBuilder(
    column: $table.estimatedCaloriesKcal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calorieMethodVersion => $composableBuilder(
    column: $table.calorieMethodVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calorieWeightGrams => $composableBuilder(
    column: $table.calorieWeightGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calorieAssumptionsJson => $composableBuilder(
    column: $table.calorieAssumptionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endedAtUtc => $composableBuilder(
    column: $table.endedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get completionReason => $composableBuilder(
    column: $table.completionReason,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalElapsedMs => $composableBuilder(
    column: $table.totalElapsedMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get activeDurationMs => $composableBuilder(
    column: $table.activeDurationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get walkingDurationMs => $composableBuilder(
    column: $table.walkingDurationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get runningDurationMs => $composableBuilder(
    column: $table.runningDurationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restDurationMs => $composableBuilder(
    column: $table.restDurationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedRounds => $composableBuilder(
    column: $table.completedRounds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get planSnapshotJson => $composableBuilder(
    column: $table.planSnapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get estimatedCaloriesKcal => $composableBuilder(
    column: $table.estimatedCaloriesKcal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get calorieMethodVersion => $composableBuilder(
    column: $table.calorieMethodVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get calorieWeightGrams => $composableBuilder(
    column: $table.calorieWeightGrams,
    builder: (column) => column,
  );

  GeneratedColumn<String> get calorieAssumptionsJson => $composableBuilder(
    column: $table.calorieAssumptionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  Expression<T> workoutPhaseSegmentsRefs<T extends Object>(
    Expression<T> Function($$WorkoutPhaseSegmentsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutPhaseSegmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutPhaseSegments,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutPhaseSegmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutPhaseSegments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          SessionRow,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (SessionRow, $$WorkoutSessionsTableReferences),
          SessionRow,
          PrefetchHooks Function({bool workoutPhaseSegmentsRefs})
        > {
  $$WorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> startedAtUtc = const Value.absent(),
                Value<int?> endedAtUtc = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> completionReason = const Value.absent(),
                Value<int> totalElapsedMs = const Value.absent(),
                Value<int> activeDurationMs = const Value.absent(),
                Value<int> walkingDurationMs = const Value.absent(),
                Value<int> runningDurationMs = const Value.absent(),
                Value<int> restDurationMs = const Value.absent(),
                Value<int> completedRounds = const Value.absent(),
                Value<String> planSnapshotJson = const Value.absent(),
                Value<double?> estimatedCaloriesKcal = const Value.absent(),
                Value<String?> calorieMethodVersion = const Value.absent(),
                Value<int?> calorieWeightGrams = const Value.absent(),
                Value<String?> calorieAssumptionsJson = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                startedAtUtc: startedAtUtc,
                endedAtUtc: endedAtUtc,
                status: status,
                completionReason: completionReason,
                totalElapsedMs: totalElapsedMs,
                activeDurationMs: activeDurationMs,
                walkingDurationMs: walkingDurationMs,
                runningDurationMs: runningDurationMs,
                restDurationMs: restDurationMs,
                completedRounds: completedRounds,
                planSnapshotJson: planSnapshotJson,
                estimatedCaloriesKcal: estimatedCaloriesKcal,
                calorieMethodVersion: calorieMethodVersion,
                calorieWeightGrams: calorieWeightGrams,
                calorieAssumptionsJson: calorieAssumptionsJson,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int startedAtUtc,
                Value<int?> endedAtUtc = const Value.absent(),
                required String status,
                Value<String?> completionReason = const Value.absent(),
                required int totalElapsedMs,
                required int activeDurationMs,
                required int walkingDurationMs,
                required int runningDurationMs,
                required int restDurationMs,
                required int completedRounds,
                required String planSnapshotJson,
                Value<double?> estimatedCaloriesKcal = const Value.absent(),
                Value<String?> calorieMethodVersion = const Value.absent(),
                Value<int?> calorieWeightGrams = const Value.absent(),
                Value<String?> calorieAssumptionsJson = const Value.absent(),
                required int createdAtUtc,
                required int updatedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                startedAtUtc: startedAtUtc,
                endedAtUtc: endedAtUtc,
                status: status,
                completionReason: completionReason,
                totalElapsedMs: totalElapsedMs,
                activeDurationMs: activeDurationMs,
                walkingDurationMs: walkingDurationMs,
                runningDurationMs: runningDurationMs,
                restDurationMs: restDurationMs,
                completedRounds: completedRounds,
                planSnapshotJson: planSnapshotJson,
                estimatedCaloriesKcal: estimatedCaloriesKcal,
                calorieMethodVersion: calorieMethodVersion,
                calorieWeightGrams: calorieWeightGrams,
                calorieAssumptionsJson: calorieAssumptionsJson,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSessionsTable, SessionRow>(table),
                  $$WorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutPhaseSegmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutPhaseSegmentsRefs) db.workoutPhaseSegments,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutPhaseSegmentsRefs)
                    await $_getPrefetchedDataByColumns<
                      SessionRow,
                      $WorkoutSessionsTable,
                      SegmentRow,
                      $WorkoutPhaseSegmentsTable
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutSessionsTableReferences
                          ._workoutPhaseSegmentsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).workoutPhaseSegmentsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'session_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      SessionRow,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (SessionRow, $$WorkoutSessionsTableReferences),
      SessionRow,
      PrefetchHooks Function({bool workoutPhaseSegmentsRefs})
    >;
typedef $$WorkoutPhaseSegmentsTableCreateCompanionBuilder =
    WorkoutPhaseSegmentsCompanion Function({
      required String id,
      required String sessionId,
      required int sequenceIndex,
      required String phaseType,
      required int plannedDurationMs,
      required int actualDurationMs,
      required int startedAtUtc,
      Value<int?> endedAtUtc,
      required bool insertedByUser,
      required String completionStatus,
      Value<int> rowid,
    });
typedef $$WorkoutPhaseSegmentsTableUpdateCompanionBuilder =
    WorkoutPhaseSegmentsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<int> sequenceIndex,
      Value<String> phaseType,
      Value<int> plannedDurationMs,
      Value<int> actualDurationMs,
      Value<int> startedAtUtc,
      Value<int?> endedAtUtc,
      Value<bool> insertedByUser,
      Value<String> completionStatus,
      Value<int> rowid,
    });

final class $$WorkoutPhaseSegmentsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutPhaseSegmentsTable, SegmentRow> {
  $$WorkoutPhaseSegmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .workoutSessions
      .createAlias('workout_phase_segments__session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutPhaseSegmentsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutPhaseSegmentsTable> {
  $$WorkoutPhaseSegmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequenceIndex => $composableBuilder(
    column: $table.sequenceIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phaseType => $composableBuilder(
    column: $table.phaseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedDurationMs => $composableBuilder(
    column: $table.plannedDurationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualDurationMs => $composableBuilder(
    column: $table.actualDurationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAtUtc => $composableBuilder(
    column: $table.endedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get insertedByUser => $composableBuilder(
    column: $table.insertedByUser,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completionStatus => $composableBuilder(
    column: $table.completionStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutPhaseSegmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutPhaseSegmentsTable> {
  $$WorkoutPhaseSegmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequenceIndex => $composableBuilder(
    column: $table.sequenceIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phaseType => $composableBuilder(
    column: $table.phaseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedDurationMs => $composableBuilder(
    column: $table.plannedDurationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualDurationMs => $composableBuilder(
    column: $table.actualDurationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAtUtc => $composableBuilder(
    column: $table.endedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get insertedByUser => $composableBuilder(
    column: $table.insertedByUser,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completionStatus => $composableBuilder(
    column: $table.completionStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutPhaseSegmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutPhaseSegmentsTable> {
  $$WorkoutPhaseSegmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sequenceIndex => $composableBuilder(
    column: $table.sequenceIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phaseType =>
      $composableBuilder(column: $table.phaseType, builder: (column) => column);

  GeneratedColumn<int> get plannedDurationMs => $composableBuilder(
    column: $table.plannedDurationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualDurationMs => $composableBuilder(
    column: $table.actualDurationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endedAtUtc => $composableBuilder(
    column: $table.endedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get insertedByUser => $composableBuilder(
    column: $table.insertedByUser,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completionStatus => $composableBuilder(
    column: $table.completionStatus,
    builder: (column) => column,
  );

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutPhaseSegmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutPhaseSegmentsTable,
          SegmentRow,
          $$WorkoutPhaseSegmentsTableFilterComposer,
          $$WorkoutPhaseSegmentsTableOrderingComposer,
          $$WorkoutPhaseSegmentsTableAnnotationComposer,
          $$WorkoutPhaseSegmentsTableCreateCompanionBuilder,
          $$WorkoutPhaseSegmentsTableUpdateCompanionBuilder,
          (SegmentRow, $$WorkoutPhaseSegmentsTableReferences),
          SegmentRow,
          PrefetchHooks Function({bool sessionId})
        > {
  $$WorkoutPhaseSegmentsTableTableManager(
    _$AppDatabase db,
    $WorkoutPhaseSegmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutPhaseSegmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutPhaseSegmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WorkoutPhaseSegmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> sequenceIndex = const Value.absent(),
                Value<String> phaseType = const Value.absent(),
                Value<int> plannedDurationMs = const Value.absent(),
                Value<int> actualDurationMs = const Value.absent(),
                Value<int> startedAtUtc = const Value.absent(),
                Value<int?> endedAtUtc = const Value.absent(),
                Value<bool> insertedByUser = const Value.absent(),
                Value<String> completionStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutPhaseSegmentsCompanion(
                id: id,
                sessionId: sessionId,
                sequenceIndex: sequenceIndex,
                phaseType: phaseType,
                plannedDurationMs: plannedDurationMs,
                actualDurationMs: actualDurationMs,
                startedAtUtc: startedAtUtc,
                endedAtUtc: endedAtUtc,
                insertedByUser: insertedByUser,
                completionStatus: completionStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required int sequenceIndex,
                required String phaseType,
                required int plannedDurationMs,
                required int actualDurationMs,
                required int startedAtUtc,
                Value<int?> endedAtUtc = const Value.absent(),
                required bool insertedByUser,
                required String completionStatus,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutPhaseSegmentsCompanion.insert(
                id: id,
                sessionId: sessionId,
                sequenceIndex: sequenceIndex,
                phaseType: phaseType,
                plannedDurationMs: plannedDurationMs,
                actualDurationMs: actualDurationMs,
                startedAtUtc: startedAtUtc,
                endedAtUtc: endedAtUtc,
                insertedByUser: insertedByUser,
                completionStatus: completionStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutPhaseSegmentsTable, SegmentRow>(table),
                  $$WorkoutPhaseSegmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable:
                                    $$WorkoutPhaseSegmentsTableReferences
                                        ._sessionIdTable(db),
                                referencedColumn:
                                    $$WorkoutPhaseSegmentsTableReferences
                                        ._sessionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutPhaseSegmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutPhaseSegmentsTable,
      SegmentRow,
      $$WorkoutPhaseSegmentsTableFilterComposer,
      $$WorkoutPhaseSegmentsTableOrderingComposer,
      $$WorkoutPhaseSegmentsTableAnnotationComposer,
      $$WorkoutPhaseSegmentsTableCreateCompanionBuilder,
      $$WorkoutPhaseSegmentsTableUpdateCompanionBuilder,
      (SegmentRow, $$WorkoutPhaseSegmentsTableReferences),
      SegmentRow,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$ActiveWorkoutSnapshotsTableCreateCompanionBuilder =
    ActiveWorkoutSnapshotsCompanion Function({
      required String sessionId,
      required String status,
      required String currentPhaseId,
      required String currentPhaseType,
      required int currentSequenceIndex,
      required int phasePlannedMs,
      Value<int?> phaseDeadlineUtcMs,
      Value<int?> frozenRemainingMs,
      required int phaseStartedAtUtcMs,
      required bool phaseInsertedByUser,
      required bool phaseIsResumption,
      required int workoutStartedAtUtcMs,
      required int lastReconciledAtUtcMs,
      required int workIndex,
      required int currentRound,
      Value<int?> resumeRemainingMs,
      required String serializedPlanSnapshot,
      required String completedSegmentsJson,
      Value<int> rowid,
    });
typedef $$ActiveWorkoutSnapshotsTableUpdateCompanionBuilder =
    ActiveWorkoutSnapshotsCompanion Function({
      Value<String> sessionId,
      Value<String> status,
      Value<String> currentPhaseId,
      Value<String> currentPhaseType,
      Value<int> currentSequenceIndex,
      Value<int> phasePlannedMs,
      Value<int?> phaseDeadlineUtcMs,
      Value<int?> frozenRemainingMs,
      Value<int> phaseStartedAtUtcMs,
      Value<bool> phaseInsertedByUser,
      Value<bool> phaseIsResumption,
      Value<int> workoutStartedAtUtcMs,
      Value<int> lastReconciledAtUtcMs,
      Value<int> workIndex,
      Value<int> currentRound,
      Value<int?> resumeRemainingMs,
      Value<String> serializedPlanSnapshot,
      Value<String> completedSegmentsJson,
      Value<int> rowid,
    });

class $$ActiveWorkoutSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveWorkoutSnapshotsTable> {
  $$ActiveWorkoutSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentPhaseId => $composableBuilder(
    column: $table.currentPhaseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentPhaseType => $composableBuilder(
    column: $table.currentPhaseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentSequenceIndex => $composableBuilder(
    column: $table.currentSequenceIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get phasePlannedMs => $composableBuilder(
    column: $table.phasePlannedMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get phaseDeadlineUtcMs => $composableBuilder(
    column: $table.phaseDeadlineUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frozenRemainingMs => $composableBuilder(
    column: $table.frozenRemainingMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get phaseStartedAtUtcMs => $composableBuilder(
    column: $table.phaseStartedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get phaseInsertedByUser => $composableBuilder(
    column: $table.phaseInsertedByUser,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get phaseIsResumption => $composableBuilder(
    column: $table.phaseIsResumption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workoutStartedAtUtcMs => $composableBuilder(
    column: $table.workoutStartedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReconciledAtUtcMs => $composableBuilder(
    column: $table.lastReconciledAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workIndex => $composableBuilder(
    column: $table.workIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentRound => $composableBuilder(
    column: $table.currentRound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get resumeRemainingMs => $composableBuilder(
    column: $table.resumeRemainingMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serializedPlanSnapshot => $composableBuilder(
    column: $table.serializedPlanSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedSegmentsJson => $composableBuilder(
    column: $table.completedSegmentsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActiveWorkoutSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveWorkoutSnapshotsTable> {
  $$ActiveWorkoutSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentPhaseId => $composableBuilder(
    column: $table.currentPhaseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentPhaseType => $composableBuilder(
    column: $table.currentPhaseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentSequenceIndex => $composableBuilder(
    column: $table.currentSequenceIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get phasePlannedMs => $composableBuilder(
    column: $table.phasePlannedMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get phaseDeadlineUtcMs => $composableBuilder(
    column: $table.phaseDeadlineUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frozenRemainingMs => $composableBuilder(
    column: $table.frozenRemainingMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get phaseStartedAtUtcMs => $composableBuilder(
    column: $table.phaseStartedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get phaseInsertedByUser => $composableBuilder(
    column: $table.phaseInsertedByUser,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get phaseIsResumption => $composableBuilder(
    column: $table.phaseIsResumption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workoutStartedAtUtcMs => $composableBuilder(
    column: $table.workoutStartedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReconciledAtUtcMs => $composableBuilder(
    column: $table.lastReconciledAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workIndex => $composableBuilder(
    column: $table.workIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentRound => $composableBuilder(
    column: $table.currentRound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get resumeRemainingMs => $composableBuilder(
    column: $table.resumeRemainingMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serializedPlanSnapshot => $composableBuilder(
    column: $table.serializedPlanSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedSegmentsJson => $composableBuilder(
    column: $table.completedSegmentsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActiveWorkoutSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveWorkoutSnapshotsTable> {
  $$ActiveWorkoutSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get currentPhaseId => $composableBuilder(
    column: $table.currentPhaseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentPhaseType => $composableBuilder(
    column: $table.currentPhaseType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentSequenceIndex => $composableBuilder(
    column: $table.currentSequenceIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get phasePlannedMs => $composableBuilder(
    column: $table.phasePlannedMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get phaseDeadlineUtcMs => $composableBuilder(
    column: $table.phaseDeadlineUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get frozenRemainingMs => $composableBuilder(
    column: $table.frozenRemainingMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get phaseStartedAtUtcMs => $composableBuilder(
    column: $table.phaseStartedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get phaseInsertedByUser => $composableBuilder(
    column: $table.phaseInsertedByUser,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get phaseIsResumption => $composableBuilder(
    column: $table.phaseIsResumption,
    builder: (column) => column,
  );

  GeneratedColumn<int> get workoutStartedAtUtcMs => $composableBuilder(
    column: $table.workoutStartedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastReconciledAtUtcMs => $composableBuilder(
    column: $table.lastReconciledAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get workIndex =>
      $composableBuilder(column: $table.workIndex, builder: (column) => column);

  GeneratedColumn<int> get currentRound => $composableBuilder(
    column: $table.currentRound,
    builder: (column) => column,
  );

  GeneratedColumn<int> get resumeRemainingMs => $composableBuilder(
    column: $table.resumeRemainingMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serializedPlanSnapshot => $composableBuilder(
    column: $table.serializedPlanSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completedSegmentsJson => $composableBuilder(
    column: $table.completedSegmentsJson,
    builder: (column) => column,
  );
}

class $$ActiveWorkoutSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActiveWorkoutSnapshotsTable,
          SnapshotRow,
          $$ActiveWorkoutSnapshotsTableFilterComposer,
          $$ActiveWorkoutSnapshotsTableOrderingComposer,
          $$ActiveWorkoutSnapshotsTableAnnotationComposer,
          $$ActiveWorkoutSnapshotsTableCreateCompanionBuilder,
          $$ActiveWorkoutSnapshotsTableUpdateCompanionBuilder,
          (
            SnapshotRow,
            BaseReferences<
              _$AppDatabase,
              $ActiveWorkoutSnapshotsTable,
              SnapshotRow
            >,
          ),
          SnapshotRow,
          PrefetchHooks Function()
        > {
  $$ActiveWorkoutSnapshotsTableTableManager(
    _$AppDatabase db,
    $ActiveWorkoutSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveWorkoutSnapshotsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ActiveWorkoutSnapshotsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActiveWorkoutSnapshotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> currentPhaseId = const Value.absent(),
                Value<String> currentPhaseType = const Value.absent(),
                Value<int> currentSequenceIndex = const Value.absent(),
                Value<int> phasePlannedMs = const Value.absent(),
                Value<int?> phaseDeadlineUtcMs = const Value.absent(),
                Value<int?> frozenRemainingMs = const Value.absent(),
                Value<int> phaseStartedAtUtcMs = const Value.absent(),
                Value<bool> phaseInsertedByUser = const Value.absent(),
                Value<bool> phaseIsResumption = const Value.absent(),
                Value<int> workoutStartedAtUtcMs = const Value.absent(),
                Value<int> lastReconciledAtUtcMs = const Value.absent(),
                Value<int> workIndex = const Value.absent(),
                Value<int> currentRound = const Value.absent(),
                Value<int?> resumeRemainingMs = const Value.absent(),
                Value<String> serializedPlanSnapshot = const Value.absent(),
                Value<String> completedSegmentsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveWorkoutSnapshotsCompanion(
                sessionId: sessionId,
                status: status,
                currentPhaseId: currentPhaseId,
                currentPhaseType: currentPhaseType,
                currentSequenceIndex: currentSequenceIndex,
                phasePlannedMs: phasePlannedMs,
                phaseDeadlineUtcMs: phaseDeadlineUtcMs,
                frozenRemainingMs: frozenRemainingMs,
                phaseStartedAtUtcMs: phaseStartedAtUtcMs,
                phaseInsertedByUser: phaseInsertedByUser,
                phaseIsResumption: phaseIsResumption,
                workoutStartedAtUtcMs: workoutStartedAtUtcMs,
                lastReconciledAtUtcMs: lastReconciledAtUtcMs,
                workIndex: workIndex,
                currentRound: currentRound,
                resumeRemainingMs: resumeRemainingMs,
                serializedPlanSnapshot: serializedPlanSnapshot,
                completedSegmentsJson: completedSegmentsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required String status,
                required String currentPhaseId,
                required String currentPhaseType,
                required int currentSequenceIndex,
                required int phasePlannedMs,
                Value<int?> phaseDeadlineUtcMs = const Value.absent(),
                Value<int?> frozenRemainingMs = const Value.absent(),
                required int phaseStartedAtUtcMs,
                required bool phaseInsertedByUser,
                required bool phaseIsResumption,
                required int workoutStartedAtUtcMs,
                required int lastReconciledAtUtcMs,
                required int workIndex,
                required int currentRound,
                Value<int?> resumeRemainingMs = const Value.absent(),
                required String serializedPlanSnapshot,
                required String completedSegmentsJson,
                Value<int> rowid = const Value.absent(),
              }) => ActiveWorkoutSnapshotsCompanion.insert(
                sessionId: sessionId,
                status: status,
                currentPhaseId: currentPhaseId,
                currentPhaseType: currentPhaseType,
                currentSequenceIndex: currentSequenceIndex,
                phasePlannedMs: phasePlannedMs,
                phaseDeadlineUtcMs: phaseDeadlineUtcMs,
                frozenRemainingMs: frozenRemainingMs,
                phaseStartedAtUtcMs: phaseStartedAtUtcMs,
                phaseInsertedByUser: phaseInsertedByUser,
                phaseIsResumption: phaseIsResumption,
                workoutStartedAtUtcMs: workoutStartedAtUtcMs,
                lastReconciledAtUtcMs: lastReconciledAtUtcMs,
                workIndex: workIndex,
                currentRound: currentRound,
                resumeRemainingMs: resumeRemainingMs,
                serializedPlanSnapshot: serializedPlanSnapshot,
                completedSegmentsJson: completedSegmentsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActiveWorkoutSnapshotsTable, SnapshotRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ActiveWorkoutSnapshotsTable,
                    SnapshotRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActiveWorkoutSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActiveWorkoutSnapshotsTable,
      SnapshotRow,
      $$ActiveWorkoutSnapshotsTableFilterComposer,
      $$ActiveWorkoutSnapshotsTableOrderingComposer,
      $$ActiveWorkoutSnapshotsTableAnnotationComposer,
      $$ActiveWorkoutSnapshotsTableCreateCompanionBuilder,
      $$ActiveWorkoutSnapshotsTableUpdateCompanionBuilder,
      (
        SnapshotRow,
        BaseReferences<
          _$AppDatabase,
          $ActiveWorkoutSnapshotsTable,
          SnapshotRow
        >,
      ),
      SnapshotRow,
      PrefetchHooks Function()
    >;
typedef $$FitnessProfilesTableCreateCompanionBuilder =
    FitnessProfilesCompanion Function({
      Value<int> id,
      Value<int?> heightMm,
      required String preferredHeightUnit,
      required String preferredWeightUnit,
      required int updatedAtUtc,
    });
typedef $$FitnessProfilesTableUpdateCompanionBuilder =
    FitnessProfilesCompanion Function({
      Value<int> id,
      Value<int?> heightMm,
      Value<String> preferredHeightUnit,
      Value<String> preferredWeightUnit,
      Value<int> updatedAtUtc,
    });

class $$FitnessProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $FitnessProfilesTable> {
  $$FitnessProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heightMm => $composableBuilder(
    column: $table.heightMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredHeightUnit => $composableBuilder(
    column: $table.preferredHeightUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredWeightUnit => $composableBuilder(
    column: $table.preferredWeightUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FitnessProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $FitnessProfilesTable> {
  $$FitnessProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heightMm => $composableBuilder(
    column: $table.heightMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredHeightUnit => $composableBuilder(
    column: $table.preferredHeightUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredWeightUnit => $composableBuilder(
    column: $table.preferredWeightUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FitnessProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FitnessProfilesTable> {
  $$FitnessProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get heightMm =>
      $composableBuilder(column: $table.heightMm, builder: (column) => column);

  GeneratedColumn<String> get preferredHeightUnit => $composableBuilder(
    column: $table.preferredHeightUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredWeightUnit => $composableBuilder(
    column: $table.preferredWeightUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );
}

class $$FitnessProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FitnessProfilesTable,
          ProfileRow,
          $$FitnessProfilesTableFilterComposer,
          $$FitnessProfilesTableOrderingComposer,
          $$FitnessProfilesTableAnnotationComposer,
          $$FitnessProfilesTableCreateCompanionBuilder,
          $$FitnessProfilesTableUpdateCompanionBuilder,
          (
            ProfileRow,
            BaseReferences<_$AppDatabase, $FitnessProfilesTable, ProfileRow>,
          ),
          ProfileRow,
          PrefetchHooks Function()
        > {
  $$FitnessProfilesTableTableManager(
    _$AppDatabase db,
    $FitnessProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FitnessProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FitnessProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FitnessProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> heightMm = const Value.absent(),
                Value<String> preferredHeightUnit = const Value.absent(),
                Value<String> preferredWeightUnit = const Value.absent(),
                Value<int> updatedAtUtc = const Value.absent(),
              }) => FitnessProfilesCompanion(
                id: id,
                heightMm: heightMm,
                preferredHeightUnit: preferredHeightUnit,
                preferredWeightUnit: preferredWeightUnit,
                updatedAtUtc: updatedAtUtc,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> heightMm = const Value.absent(),
                required String preferredHeightUnit,
                required String preferredWeightUnit,
                required int updatedAtUtc,
              }) => FitnessProfilesCompanion.insert(
                id: id,
                heightMm: heightMm,
                preferredHeightUnit: preferredHeightUnit,
                preferredWeightUnit: preferredWeightUnit,
                updatedAtUtc: updatedAtUtc,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FitnessProfilesTable, ProfileRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $FitnessProfilesTable,
                    ProfileRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FitnessProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FitnessProfilesTable,
      ProfileRow,
      $$FitnessProfilesTableFilterComposer,
      $$FitnessProfilesTableOrderingComposer,
      $$FitnessProfilesTableAnnotationComposer,
      $$FitnessProfilesTableCreateCompanionBuilder,
      $$FitnessProfilesTableUpdateCompanionBuilder,
      (
        ProfileRow,
        BaseReferences<_$AppDatabase, $FitnessProfilesTable, ProfileRow>,
      ),
      ProfileRow,
      PrefetchHooks Function()
    >;
typedef $$WeightMeasurementsTableCreateCompanionBuilder =
    WeightMeasurementsCompanion Function({
      required String id,
      required int measuredAtUtc,
      required int weightGrams,
      Value<String?> note,
      required int createdAtUtc,
      Value<int> rowid,
    });
typedef $$WeightMeasurementsTableUpdateCompanionBuilder =
    WeightMeasurementsCompanion Function({
      Value<String> id,
      Value<int> measuredAtUtc,
      Value<int> weightGrams,
      Value<String?> note,
      Value<int> createdAtUtc,
      Value<int> rowid,
    });

class $$WeightMeasurementsTableFilterComposer
    extends Composer<_$AppDatabase, $WeightMeasurementsTable> {
  $$WeightMeasurementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get measuredAtUtc => $composableBuilder(
    column: $table.measuredAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeightMeasurementsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightMeasurementsTable> {
  $$WeightMeasurementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get measuredAtUtc => $composableBuilder(
    column: $table.measuredAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeightMeasurementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightMeasurementsTable> {
  $$WeightMeasurementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get measuredAtUtc => $composableBuilder(
    column: $table.measuredAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );
}

class $$WeightMeasurementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightMeasurementsTable,
          WeightRow,
          $$WeightMeasurementsTableFilterComposer,
          $$WeightMeasurementsTableOrderingComposer,
          $$WeightMeasurementsTableAnnotationComposer,
          $$WeightMeasurementsTableCreateCompanionBuilder,
          $$WeightMeasurementsTableUpdateCompanionBuilder,
          (
            WeightRow,
            BaseReferences<_$AppDatabase, $WeightMeasurementsTable, WeightRow>,
          ),
          WeightRow,
          PrefetchHooks Function()
        > {
  $$WeightMeasurementsTableTableManager(
    _$AppDatabase db,
    $WeightMeasurementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightMeasurementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightMeasurementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightMeasurementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> measuredAtUtc = const Value.absent(),
                Value<int> weightGrams = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeightMeasurementsCompanion(
                id: id,
                measuredAtUtc: measuredAtUtc,
                weightGrams: weightGrams,
                note: note,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int measuredAtUtc,
                required int weightGrams,
                Value<String?> note = const Value.absent(),
                required int createdAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => WeightMeasurementsCompanion.insert(
                id: id,
                measuredAtUtc: measuredAtUtc,
                weightGrams: weightGrams,
                note: note,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeightMeasurementsTable, WeightRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WeightMeasurementsTable,
                    WeightRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeightMeasurementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightMeasurementsTable,
      WeightRow,
      $$WeightMeasurementsTableFilterComposer,
      $$WeightMeasurementsTableOrderingComposer,
      $$WeightMeasurementsTableAnnotationComposer,
      $$WeightMeasurementsTableCreateCompanionBuilder,
      $$WeightMeasurementsTableUpdateCompanionBuilder,
      (
        WeightRow,
        BaseReferences<_$AppDatabase, $WeightMeasurementsTable, WeightRow>,
      ),
      WeightRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$WorkoutPhaseSegmentsTableTableManager get workoutPhaseSegments =>
      $$WorkoutPhaseSegmentsTableTableManager(_db, _db.workoutPhaseSegments);
  $$ActiveWorkoutSnapshotsTableTableManager get activeWorkoutSnapshots =>
      $$ActiveWorkoutSnapshotsTableTableManager(
        _db,
        _db.activeWorkoutSnapshots,
      );
  $$FitnessProfilesTableTableManager get fitnessProfiles =>
      $$FitnessProfilesTableTableManager(_db, _db.fitnessProfiles);
  $$WeightMeasurementsTableTableManager get weightMeasurements =>
      $$WeightMeasurementsTableTableManager(_db, _db.weightMeasurements);
}
