// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthYearMeta = const VerificationMeta(
    'birthYear',
  );
  @override
  late final GeneratedColumn<int> birthYear = GeneratedColumn<int>(
    'birth_year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _experienceMeta = const VerificationMeta(
    'experience',
  );
  @override
  late final GeneratedColumn<String> experience = GeneratedColumn<String>(
    'experience',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxPushUpsMeta = const VerificationMeta(
    'maxPushUps',
  );
  @override
  late final GeneratedColumn<int> maxPushUps = GeneratedColumn<int>(
    'max_push_ups',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxPullUpsMeta = const VerificationMeta(
    'maxPullUps',
  );
  @override
  late final GeneratedColumn<int> maxPullUps = GeneratedColumn<int>(
    'max_pull_ups',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxDeadHangSecMeta = const VerificationMeta(
    'maxDeadHangSec',
  );
  @override
  late final GeneratedColumn<int> maxDeadHangSec = GeneratedColumn<int>(
    'max_dead_hang_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxPlankSecMeta = const VerificationMeta(
    'maxPlankSec',
  );
  @override
  late final GeneratedColumn<int> maxPlankSec = GeneratedColumn<int>(
    'max_plank_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    birthYear,
    heightCm,
    weightKg,
    experience,
    maxPushUps,
    maxPullUps,
    maxDeadHangSec,
    maxPlankSec,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
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
    if (data.containsKey('birth_year')) {
      context.handle(
        _birthYearMeta,
        birthYear.isAcceptableOrUnknown(data['birth_year']!, _birthYearMeta),
      );
    } else if (isInserting) {
      context.missing(_birthYearMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('experience')) {
      context.handle(
        _experienceMeta,
        experience.isAcceptableOrUnknown(data['experience']!, _experienceMeta),
      );
    } else if (isInserting) {
      context.missing(_experienceMeta);
    }
    if (data.containsKey('max_push_ups')) {
      context.handle(
        _maxPushUpsMeta,
        maxPushUps.isAcceptableOrUnknown(
          data['max_push_ups']!,
          _maxPushUpsMeta,
        ),
      );
    }
    if (data.containsKey('max_pull_ups')) {
      context.handle(
        _maxPullUpsMeta,
        maxPullUps.isAcceptableOrUnknown(
          data['max_pull_ups']!,
          _maxPullUpsMeta,
        ),
      );
    }
    if (data.containsKey('max_dead_hang_sec')) {
      context.handle(
        _maxDeadHangSecMeta,
        maxDeadHangSec.isAcceptableOrUnknown(
          data['max_dead_hang_sec']!,
          _maxDeadHangSecMeta,
        ),
      );
    }
    if (data.containsKey('max_plank_sec')) {
      context.handle(
        _maxPlankSecMeta,
        maxPlankSec.isAcceptableOrUnknown(
          data['max_plank_sec']!,
          _maxPlankSecMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
      birthYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}birth_year'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      experience: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}experience'],
      )!,
      maxPushUps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_push_ups'],
      ),
      maxPullUps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_pull_ups'],
      ),
      maxDeadHangSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_dead_hang_sec'],
      ),
      maxPlankSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_plank_sec'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final int id;
  final int birthYear;
  final double heightCm;
  final double weightKg;
  final String experience;
  final int? maxPushUps;
  final int? maxPullUps;
  final int? maxDeadHangSec;
  final int? maxPlankSec;
  final DateTime createdAt;
  const ProfileRow({
    required this.id,
    required this.birthYear,
    required this.heightCm,
    required this.weightKg,
    required this.experience,
    this.maxPushUps,
    this.maxPullUps,
    this.maxDeadHangSec,
    this.maxPlankSec,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['birth_year'] = Variable<int>(birthYear);
    map['height_cm'] = Variable<double>(heightCm);
    map['weight_kg'] = Variable<double>(weightKg);
    map['experience'] = Variable<String>(experience);
    if (!nullToAbsent || maxPushUps != null) {
      map['max_push_ups'] = Variable<int>(maxPushUps);
    }
    if (!nullToAbsent || maxPullUps != null) {
      map['max_pull_ups'] = Variable<int>(maxPullUps);
    }
    if (!nullToAbsent || maxDeadHangSec != null) {
      map['max_dead_hang_sec'] = Variable<int>(maxDeadHangSec);
    }
    if (!nullToAbsent || maxPlankSec != null) {
      map['max_plank_sec'] = Variable<int>(maxPlankSec);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      birthYear: Value(birthYear),
      heightCm: Value(heightCm),
      weightKg: Value(weightKg),
      experience: Value(experience),
      maxPushUps: maxPushUps == null && nullToAbsent
          ? const Value.absent()
          : Value(maxPushUps),
      maxPullUps: maxPullUps == null && nullToAbsent
          ? const Value.absent()
          : Value(maxPullUps),
      maxDeadHangSec: maxDeadHangSec == null && nullToAbsent
          ? const Value.absent()
          : Value(maxDeadHangSec),
      maxPlankSec: maxPlankSec == null && nullToAbsent
          ? const Value.absent()
          : Value(maxPlankSec),
      createdAt: Value(createdAt),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<int>(json['id']),
      birthYear: serializer.fromJson<int>(json['birthYear']),
      heightCm: serializer.fromJson<double>(json['heightCm']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      experience: serializer.fromJson<String>(json['experience']),
      maxPushUps: serializer.fromJson<int?>(json['maxPushUps']),
      maxPullUps: serializer.fromJson<int?>(json['maxPullUps']),
      maxDeadHangSec: serializer.fromJson<int?>(json['maxDeadHangSec']),
      maxPlankSec: serializer.fromJson<int?>(json['maxPlankSec']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'birthYear': serializer.toJson<int>(birthYear),
      'heightCm': serializer.toJson<double>(heightCm),
      'weightKg': serializer.toJson<double>(weightKg),
      'experience': serializer.toJson<String>(experience),
      'maxPushUps': serializer.toJson<int?>(maxPushUps),
      'maxPullUps': serializer.toJson<int?>(maxPullUps),
      'maxDeadHangSec': serializer.toJson<int?>(maxDeadHangSec),
      'maxPlankSec': serializer.toJson<int?>(maxPlankSec),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProfileRow copyWith({
    int? id,
    int? birthYear,
    double? heightCm,
    double? weightKg,
    String? experience,
    Value<int?> maxPushUps = const Value.absent(),
    Value<int?> maxPullUps = const Value.absent(),
    Value<int?> maxDeadHangSec = const Value.absent(),
    Value<int?> maxPlankSec = const Value.absent(),
    DateTime? createdAt,
  }) => ProfileRow(
    id: id ?? this.id,
    birthYear: birthYear ?? this.birthYear,
    heightCm: heightCm ?? this.heightCm,
    weightKg: weightKg ?? this.weightKg,
    experience: experience ?? this.experience,
    maxPushUps: maxPushUps.present ? maxPushUps.value : this.maxPushUps,
    maxPullUps: maxPullUps.present ? maxPullUps.value : this.maxPullUps,
    maxDeadHangSec: maxDeadHangSec.present
        ? maxDeadHangSec.value
        : this.maxDeadHangSec,
    maxPlankSec: maxPlankSec.present ? maxPlankSec.value : this.maxPlankSec,
    createdAt: createdAt ?? this.createdAt,
  );
  ProfileRow copyWithCompanion(ProfilesCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      birthYear: data.birthYear.present ? data.birthYear.value : this.birthYear,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      experience: data.experience.present
          ? data.experience.value
          : this.experience,
      maxPushUps: data.maxPushUps.present
          ? data.maxPushUps.value
          : this.maxPushUps,
      maxPullUps: data.maxPullUps.present
          ? data.maxPullUps.value
          : this.maxPullUps,
      maxDeadHangSec: data.maxDeadHangSec.present
          ? data.maxDeadHangSec.value
          : this.maxDeadHangSec,
      maxPlankSec: data.maxPlankSec.present
          ? data.maxPlankSec.value
          : this.maxPlankSec,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('birthYear: $birthYear, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('experience: $experience, ')
          ..write('maxPushUps: $maxPushUps, ')
          ..write('maxPullUps: $maxPullUps, ')
          ..write('maxDeadHangSec: $maxDeadHangSec, ')
          ..write('maxPlankSec: $maxPlankSec, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    birthYear,
    heightCm,
    weightKg,
    experience,
    maxPushUps,
    maxPullUps,
    maxDeadHangSec,
    maxPlankSec,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.birthYear == this.birthYear &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.experience == this.experience &&
          other.maxPushUps == this.maxPushUps &&
          other.maxPullUps == this.maxPullUps &&
          other.maxDeadHangSec == this.maxDeadHangSec &&
          other.maxPlankSec == this.maxPlankSec &&
          other.createdAt == this.createdAt);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<int> id;
  final Value<int> birthYear;
  final Value<double> heightCm;
  final Value<double> weightKg;
  final Value<String> experience;
  final Value<int?> maxPushUps;
  final Value<int?> maxPullUps;
  final Value<int?> maxDeadHangSec;
  final Value<int?> maxPlankSec;
  final Value<DateTime> createdAt;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.experience = const Value.absent(),
    this.maxPushUps = const Value.absent(),
    this.maxPullUps = const Value.absent(),
    this.maxDeadHangSec = const Value.absent(),
    this.maxPlankSec = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required int birthYear,
    required double heightCm,
    required double weightKg,
    required String experience,
    this.maxPushUps = const Value.absent(),
    this.maxPullUps = const Value.absent(),
    this.maxDeadHangSec = const Value.absent(),
    this.maxPlankSec = const Value.absent(),
    required DateTime createdAt,
  }) : birthYear = Value(birthYear),
       heightCm = Value(heightCm),
       weightKg = Value(weightKg),
       experience = Value(experience),
       createdAt = Value(createdAt);
  static Insertable<ProfileRow> custom({
    Expression<int>? id,
    Expression<int>? birthYear,
    Expression<double>? heightCm,
    Expression<double>? weightKg,
    Expression<String>? experience,
    Expression<int>? maxPushUps,
    Expression<int>? maxPullUps,
    Expression<int>? maxDeadHangSec,
    Expression<int>? maxPlankSec,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (birthYear != null) 'birth_year': birthYear,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (experience != null) 'experience': experience,
      if (maxPushUps != null) 'max_push_ups': maxPushUps,
      if (maxPullUps != null) 'max_pull_ups': maxPullUps,
      if (maxDeadHangSec != null) 'max_dead_hang_sec': maxDeadHangSec,
      if (maxPlankSec != null) 'max_plank_sec': maxPlankSec,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<int>? birthYear,
    Value<double>? heightCm,
    Value<double>? weightKg,
    Value<String>? experience,
    Value<int?>? maxPushUps,
    Value<int?>? maxPullUps,
    Value<int?>? maxDeadHangSec,
    Value<int?>? maxPlankSec,
    Value<DateTime>? createdAt,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      birthYear: birthYear ?? this.birthYear,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      experience: experience ?? this.experience,
      maxPushUps: maxPushUps ?? this.maxPushUps,
      maxPullUps: maxPullUps ?? this.maxPullUps,
      maxDeadHangSec: maxDeadHangSec ?? this.maxDeadHangSec,
      maxPlankSec: maxPlankSec ?? this.maxPlankSec,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (birthYear.present) {
      map['birth_year'] = Variable<int>(birthYear.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (experience.present) {
      map['experience'] = Variable<String>(experience.value);
    }
    if (maxPushUps.present) {
      map['max_push_ups'] = Variable<int>(maxPushUps.value);
    }
    if (maxPullUps.present) {
      map['max_pull_ups'] = Variable<int>(maxPullUps.value);
    }
    if (maxDeadHangSec.present) {
      map['max_dead_hang_sec'] = Variable<int>(maxDeadHangSec.value);
    }
    if (maxPlankSec.present) {
      map['max_plank_sec'] = Variable<int>(maxPlankSec.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('birthYear: $birthYear, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('experience: $experience, ')
          ..write('maxPushUps: $maxPushUps, ')
          ..write('maxPullUps: $maxPullUps, ')
          ..write('maxDeadHangSec: $maxDeadHangSec, ')
          ..write('maxPlankSec: $maxPlankSec, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $InjuriesTable extends Injuries
    with TableInfo<$InjuriesTable, InjuryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InjuriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _jointMeta = const VerificationMeta('joint');
  @override
  late final GeneratedColumn<String> joint = GeneratedColumn<String>(
    'joint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCurrentMeta = const VerificationMeta(
    'isCurrent',
  );
  @override
  late final GeneratedColumn<bool> isCurrent = GeneratedColumn<bool>(
    'is_current',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_current" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [joint, severity, isCurrent];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'injuries';
  @override
  VerificationContext validateIntegrity(
    Insertable<InjuryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('joint')) {
      context.handle(
        _jointMeta,
        joint.isAcceptableOrUnknown(data['joint']!, _jointMeta),
      );
    } else if (isInserting) {
      context.missing(_jointMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('is_current')) {
      context.handle(
        _isCurrentMeta,
        isCurrent.isAcceptableOrUnknown(data['is_current']!, _isCurrentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {joint};
  @override
  InjuryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InjuryRow(
      joint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}joint'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      isCurrent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_current'],
      )!,
    );
  }

  @override
  $InjuriesTable createAlias(String alias) {
    return $InjuriesTable(attachedDatabase, alias);
  }
}

class InjuryRow extends DataClass implements Insertable<InjuryRow> {
  final String joint;
  final String severity;
  final bool isCurrent;
  const InjuryRow({
    required this.joint,
    required this.severity,
    required this.isCurrent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['joint'] = Variable<String>(joint);
    map['severity'] = Variable<String>(severity);
    map['is_current'] = Variable<bool>(isCurrent);
    return map;
  }

  InjuriesCompanion toCompanion(bool nullToAbsent) {
    return InjuriesCompanion(
      joint: Value(joint),
      severity: Value(severity),
      isCurrent: Value(isCurrent),
    );
  }

  factory InjuryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InjuryRow(
      joint: serializer.fromJson<String>(json['joint']),
      severity: serializer.fromJson<String>(json['severity']),
      isCurrent: serializer.fromJson<bool>(json['isCurrent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'joint': serializer.toJson<String>(joint),
      'severity': serializer.toJson<String>(severity),
      'isCurrent': serializer.toJson<bool>(isCurrent),
    };
  }

  InjuryRow copyWith({String? joint, String? severity, bool? isCurrent}) =>
      InjuryRow(
        joint: joint ?? this.joint,
        severity: severity ?? this.severity,
        isCurrent: isCurrent ?? this.isCurrent,
      );
  InjuryRow copyWithCompanion(InjuriesCompanion data) {
    return InjuryRow(
      joint: data.joint.present ? data.joint.value : this.joint,
      severity: data.severity.present ? data.severity.value : this.severity,
      isCurrent: data.isCurrent.present ? data.isCurrent.value : this.isCurrent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InjuryRow(')
          ..write('joint: $joint, ')
          ..write('severity: $severity, ')
          ..write('isCurrent: $isCurrent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(joint, severity, isCurrent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InjuryRow &&
          other.joint == this.joint &&
          other.severity == this.severity &&
          other.isCurrent == this.isCurrent);
}

class InjuriesCompanion extends UpdateCompanion<InjuryRow> {
  final Value<String> joint;
  final Value<String> severity;
  final Value<bool> isCurrent;
  final Value<int> rowid;
  const InjuriesCompanion({
    this.joint = const Value.absent(),
    this.severity = const Value.absent(),
    this.isCurrent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InjuriesCompanion.insert({
    required String joint,
    required String severity,
    this.isCurrent = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : joint = Value(joint),
       severity = Value(severity);
  static Insertable<InjuryRow> custom({
    Expression<String>? joint,
    Expression<String>? severity,
    Expression<bool>? isCurrent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (joint != null) 'joint': joint,
      if (severity != null) 'severity': severity,
      if (isCurrent != null) 'is_current': isCurrent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InjuriesCompanion copyWith({
    Value<String>? joint,
    Value<String>? severity,
    Value<bool>? isCurrent,
    Value<int>? rowid,
  }) {
    return InjuriesCompanion(
      joint: joint ?? this.joint,
      severity: severity ?? this.severity,
      isCurrent: isCurrent ?? this.isCurrent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (joint.present) {
      map['joint'] = Variable<String>(joint.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (isCurrent.present) {
      map['is_current'] = Variable<bool>(isCurrent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InjuriesCompanion(')
          ..write('joint: $joint, ')
          ..write('severity: $severity, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String key;
  final String value;
  const SettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingRow copyWith({String? key, String? value}) =>
      SettingRow(key: key ?? this.key, value: value ?? this.value);
  SettingRow copyWithCompanion(SettingsCompanion data) {
    return SettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions
    with TableInfo<$SessionsTable, SessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentIndexMeta = const VerificationMeta(
    'currentIndex',
  );
  @override
  late final GeneratedColumn<int> currentIndex = GeneratedColumn<int>(
    'current_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pendingCountMeta = const VerificationMeta(
    'pendingCount',
  );
  @override
  late final GeneratedColumn<int> pendingCount = GeneratedColumn<int>(
    'pending_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _restEndsAtMeta = const VerificationMeta(
    'restEndsAt',
  );
  @override
  late final GeneratedColumn<DateTime> restEndsAt = GeneratedColumn<DateTime>(
    'rest_ends_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restTotalSecMeta = const VerificationMeta(
    'restTotalSec',
  );
  @override
  late final GeneratedColumn<int> restTotalSec = GeneratedColumn<int>(
    'rest_total_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planWeekMeta = const VerificationMeta(
    'planWeek',
  );
  @override
  late final GeneratedColumn<String> planWeek = GeneratedColumn<String>(
    'plan_week',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planDayIndexMeta = const VerificationMeta(
    'planDayIndex',
  );
  @override
  late final GeneratedColumn<int> planDayIndex = GeneratedColumn<int>(
    'plan_day_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeloadMeta = const VerificationMeta(
    'isDeload',
  );
  @override
  late final GeneratedColumn<bool> isDeload = GeneratedColumn<bool>(
    'is_deload',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deload" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    startedAt,
    finishedAt,
    currentIndex,
    pendingCount,
    restEndsAt,
    restTotalSec,
    planWeek,
    planDayIndex,
    isDeload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    if (data.containsKey('current_index')) {
      context.handle(
        _currentIndexMeta,
        currentIndex.isAcceptableOrUnknown(
          data['current_index']!,
          _currentIndexMeta,
        ),
      );
    }
    if (data.containsKey('pending_count')) {
      context.handle(
        _pendingCountMeta,
        pendingCount.isAcceptableOrUnknown(
          data['pending_count']!,
          _pendingCountMeta,
        ),
      );
    }
    if (data.containsKey('rest_ends_at')) {
      context.handle(
        _restEndsAtMeta,
        restEndsAt.isAcceptableOrUnknown(
          data['rest_ends_at']!,
          _restEndsAtMeta,
        ),
      );
    }
    if (data.containsKey('rest_total_sec')) {
      context.handle(
        _restTotalSecMeta,
        restTotalSec.isAcceptableOrUnknown(
          data['rest_total_sec']!,
          _restTotalSecMeta,
        ),
      );
    }
    if (data.containsKey('plan_week')) {
      context.handle(
        _planWeekMeta,
        planWeek.isAcceptableOrUnknown(data['plan_week']!, _planWeekMeta),
      );
    }
    if (data.containsKey('plan_day_index')) {
      context.handle(
        _planDayIndexMeta,
        planDayIndex.isAcceptableOrUnknown(
          data['plan_day_index']!,
          _planDayIndexMeta,
        ),
      );
    }
    if (data.containsKey('is_deload')) {
      context.handle(
        _isDeloadMeta,
        isDeload.isAcceptableOrUnknown(data['is_deload']!, _isDeloadMeta),
      );
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
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
      currentIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_index'],
      )!,
      pendingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pending_count'],
      )!,
      restEndsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}rest_ends_at'],
      ),
      restTotalSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_total_sec'],
      ),
      planWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_week'],
      ),
      planDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_day_index'],
      ),
      isDeload: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deload'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class SessionRow extends DataClass implements Insertable<SessionRow> {
  final int id;
  final String name;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final int currentIndex;
  final int pendingCount;
  final DateTime? restEndsAt;
  final int? restTotalSec;
  final String? planWeek;
  final int? planDayIndex;
  final bool isDeload;
  const SessionRow({
    required this.id,
    required this.name,
    required this.startedAt,
    this.finishedAt,
    required this.currentIndex,
    required this.pendingCount,
    this.restEndsAt,
    this.restTotalSec,
    this.planWeek,
    this.planDayIndex,
    required this.isDeload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    map['current_index'] = Variable<int>(currentIndex);
    map['pending_count'] = Variable<int>(pendingCount);
    if (!nullToAbsent || restEndsAt != null) {
      map['rest_ends_at'] = Variable<DateTime>(restEndsAt);
    }
    if (!nullToAbsent || restTotalSec != null) {
      map['rest_total_sec'] = Variable<int>(restTotalSec);
    }
    if (!nullToAbsent || planWeek != null) {
      map['plan_week'] = Variable<String>(planWeek);
    }
    if (!nullToAbsent || planDayIndex != null) {
      map['plan_day_index'] = Variable<int>(planDayIndex);
    }
    map['is_deload'] = Variable<bool>(isDeload);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      name: Value(name),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      currentIndex: Value(currentIndex),
      pendingCount: Value(pendingCount),
      restEndsAt: restEndsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(restEndsAt),
      restTotalSec: restTotalSec == null && nullToAbsent
          ? const Value.absent()
          : Value(restTotalSec),
      planWeek: planWeek == null && nullToAbsent
          ? const Value.absent()
          : Value(planWeek),
      planDayIndex: planDayIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(planDayIndex),
      isDeload: Value(isDeload),
    );
  }

  factory SessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      currentIndex: serializer.fromJson<int>(json['currentIndex']),
      pendingCount: serializer.fromJson<int>(json['pendingCount']),
      restEndsAt: serializer.fromJson<DateTime?>(json['restEndsAt']),
      restTotalSec: serializer.fromJson<int?>(json['restTotalSec']),
      planWeek: serializer.fromJson<String?>(json['planWeek']),
      planDayIndex: serializer.fromJson<int?>(json['planDayIndex']),
      isDeload: serializer.fromJson<bool>(json['isDeload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'currentIndex': serializer.toJson<int>(currentIndex),
      'pendingCount': serializer.toJson<int>(pendingCount),
      'restEndsAt': serializer.toJson<DateTime?>(restEndsAt),
      'restTotalSec': serializer.toJson<int?>(restTotalSec),
      'planWeek': serializer.toJson<String?>(planWeek),
      'planDayIndex': serializer.toJson<int?>(planDayIndex),
      'isDeload': serializer.toJson<bool>(isDeload),
    };
  }

  SessionRow copyWith({
    int? id,
    String? name,
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
    int? currentIndex,
    int? pendingCount,
    Value<DateTime?> restEndsAt = const Value.absent(),
    Value<int?> restTotalSec = const Value.absent(),
    Value<String?> planWeek = const Value.absent(),
    Value<int?> planDayIndex = const Value.absent(),
    bool? isDeload,
  }) => SessionRow(
    id: id ?? this.id,
    name: name ?? this.name,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    currentIndex: currentIndex ?? this.currentIndex,
    pendingCount: pendingCount ?? this.pendingCount,
    restEndsAt: restEndsAt.present ? restEndsAt.value : this.restEndsAt,
    restTotalSec: restTotalSec.present ? restTotalSec.value : this.restTotalSec,
    planWeek: planWeek.present ? planWeek.value : this.planWeek,
    planDayIndex: planDayIndex.present ? planDayIndex.value : this.planDayIndex,
    isDeload: isDeload ?? this.isDeload,
  );
  SessionRow copyWithCompanion(SessionsCompanion data) {
    return SessionRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      currentIndex: data.currentIndex.present
          ? data.currentIndex.value
          : this.currentIndex,
      pendingCount: data.pendingCount.present
          ? data.pendingCount.value
          : this.pendingCount,
      restEndsAt: data.restEndsAt.present
          ? data.restEndsAt.value
          : this.restEndsAt,
      restTotalSec: data.restTotalSec.present
          ? data.restTotalSec.value
          : this.restTotalSec,
      planWeek: data.planWeek.present ? data.planWeek.value : this.planWeek,
      planDayIndex: data.planDayIndex.present
          ? data.planDayIndex.value
          : this.planDayIndex,
      isDeload: data.isDeload.present ? data.isDeload.value : this.isDeload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('currentIndex: $currentIndex, ')
          ..write('pendingCount: $pendingCount, ')
          ..write('restEndsAt: $restEndsAt, ')
          ..write('restTotalSec: $restTotalSec, ')
          ..write('planWeek: $planWeek, ')
          ..write('planDayIndex: $planDayIndex, ')
          ..write('isDeload: $isDeload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    startedAt,
    finishedAt,
    currentIndex,
    pendingCount,
    restEndsAt,
    restTotalSec,
    planWeek,
    planDayIndex,
    isDeload,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.currentIndex == this.currentIndex &&
          other.pendingCount == this.pendingCount &&
          other.restEndsAt == this.restEndsAt &&
          other.restTotalSec == this.restTotalSec &&
          other.planWeek == this.planWeek &&
          other.planDayIndex == this.planDayIndex &&
          other.isDeload == this.isDeload);
}

class SessionsCompanion extends UpdateCompanion<SessionRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<int> currentIndex;
  final Value<int> pendingCount;
  final Value<DateTime?> restEndsAt;
  final Value<int?> restTotalSec;
  final Value<String?> planWeek;
  final Value<int?> planDayIndex;
  final Value<bool> isDeload;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.currentIndex = const Value.absent(),
    this.pendingCount = const Value.absent(),
    this.restEndsAt = const Value.absent(),
    this.restTotalSec = const Value.absent(),
    this.planWeek = const Value.absent(),
    this.planDayIndex = const Value.absent(),
    this.isDeload = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    this.currentIndex = const Value.absent(),
    this.pendingCount = const Value.absent(),
    this.restEndsAt = const Value.absent(),
    this.restTotalSec = const Value.absent(),
    this.planWeek = const Value.absent(),
    this.planDayIndex = const Value.absent(),
    this.isDeload = const Value.absent(),
  }) : name = Value(name),
       startedAt = Value(startedAt);
  static Insertable<SessionRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<int>? currentIndex,
    Expression<int>? pendingCount,
    Expression<DateTime>? restEndsAt,
    Expression<int>? restTotalSec,
    Expression<String>? planWeek,
    Expression<int>? planDayIndex,
    Expression<bool>? isDeload,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (currentIndex != null) 'current_index': currentIndex,
      if (pendingCount != null) 'pending_count': pendingCount,
      if (restEndsAt != null) 'rest_ends_at': restEndsAt,
      if (restTotalSec != null) 'rest_total_sec': restTotalSec,
      if (planWeek != null) 'plan_week': planWeek,
      if (planDayIndex != null) 'plan_day_index': planDayIndex,
      if (isDeload != null) 'is_deload': isDeload,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<int>? currentIndex,
    Value<int>? pendingCount,
    Value<DateTime?>? restEndsAt,
    Value<int?>? restTotalSec,
    Value<String?>? planWeek,
    Value<int?>? planDayIndex,
    Value<bool>? isDeload,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      currentIndex: currentIndex ?? this.currentIndex,
      pendingCount: pendingCount ?? this.pendingCount,
      restEndsAt: restEndsAt ?? this.restEndsAt,
      restTotalSec: restTotalSec ?? this.restTotalSec,
      planWeek: planWeek ?? this.planWeek,
      planDayIndex: planDayIndex ?? this.planDayIndex,
      isDeload: isDeload ?? this.isDeload,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (currentIndex.present) {
      map['current_index'] = Variable<int>(currentIndex.value);
    }
    if (pendingCount.present) {
      map['pending_count'] = Variable<int>(pendingCount.value);
    }
    if (restEndsAt.present) {
      map['rest_ends_at'] = Variable<DateTime>(restEndsAt.value);
    }
    if (restTotalSec.present) {
      map['rest_total_sec'] = Variable<int>(restTotalSec.value);
    }
    if (planWeek.present) {
      map['plan_week'] = Variable<String>(planWeek.value);
    }
    if (planDayIndex.present) {
      map['plan_day_index'] = Variable<int>(planDayIndex.value);
    }
    if (isDeload.present) {
      map['is_deload'] = Variable<bool>(isDeload.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('currentIndex: $currentIndex, ')
          ..write('pendingCount: $pendingCount, ')
          ..write('restEndsAt: $restEndsAt, ')
          ..write('restTotalSec: $restTotalSec, ')
          ..write('planWeek: $planWeek, ')
          ..write('planDayIndex: $planDayIndex, ')
          ..write('isDeload: $isDeload')
          ..write(')'))
        .toString();
  }
}

class $SessionExercisesTable extends SessionExercises
    with TableInfo<$SessionExercisesTable, SessionExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetSetsMeta = const VerificationMeta(
    'targetSets',
  );
  @override
  late final GeneratedColumn<int> targetSets = GeneratedColumn<int>(
    'target_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMinMeta = const VerificationMeta(
    'targetMin',
  );
  @override
  late final GeneratedColumn<int> targetMin = GeneratedColumn<int>(
    'target_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMaxMeta = const VerificationMeta(
    'targetMax',
  );
  @override
  late final GeneratedColumn<int> targetMax = GeneratedColumn<int>(
    'target_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restSecMeta = const VerificationMeta(
    'restSec',
  );
  @override
  late final GeneratedColumn<int> restSec = GeneratedColumn<int>(
    'rest_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    exerciseId,
    orderIndex,
    targetSets,
    targetMin,
    targetMax,
    restSec,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionExerciseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('target_sets')) {
      context.handle(
        _targetSetsMeta,
        targetSets.isAcceptableOrUnknown(data['target_sets']!, _targetSetsMeta),
      );
    } else if (isInserting) {
      context.missing(_targetSetsMeta);
    }
    if (data.containsKey('target_min')) {
      context.handle(
        _targetMinMeta,
        targetMin.isAcceptableOrUnknown(data['target_min']!, _targetMinMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMinMeta);
    }
    if (data.containsKey('target_max')) {
      context.handle(
        _targetMaxMeta,
        targetMax.isAcceptableOrUnknown(data['target_max']!, _targetMaxMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMaxMeta);
    }
    if (data.containsKey('rest_sec')) {
      context.handle(
        _restSecMeta,
        restSec.isAcceptableOrUnknown(data['rest_sec']!, _restSecMeta),
      );
    } else if (isInserting) {
      context.missing(_restSecMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionExerciseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionExerciseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      targetSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_sets'],
      )!,
      targetMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_min'],
      )!,
      targetMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_max'],
      )!,
      restSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_sec'],
      )!,
    );
  }

  @override
  $SessionExercisesTable createAlias(String alias) {
    return $SessionExercisesTable(attachedDatabase, alias);
  }
}

class SessionExerciseRow extends DataClass
    implements Insertable<SessionExerciseRow> {
  final int id;
  final int sessionId;
  final String exerciseId;
  final int orderIndex;
  final int targetSets;
  final int targetMin;
  final int targetMax;
  final int restSec;
  const SessionExerciseRow({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.orderIndex,
    required this.targetSets,
    required this.targetMin,
    required this.targetMax,
    required this.restSec,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['order_index'] = Variable<int>(orderIndex);
    map['target_sets'] = Variable<int>(targetSets);
    map['target_min'] = Variable<int>(targetMin);
    map['target_max'] = Variable<int>(targetMax);
    map['rest_sec'] = Variable<int>(restSec);
    return map;
  }

  SessionExercisesCompanion toCompanion(bool nullToAbsent) {
    return SessionExercisesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      orderIndex: Value(orderIndex),
      targetSets: Value(targetSets),
      targetMin: Value(targetMin),
      targetMax: Value(targetMax),
      restSec: Value(restSec),
    );
  }

  factory SessionExerciseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionExerciseRow(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      targetSets: serializer.fromJson<int>(json['targetSets']),
      targetMin: serializer.fromJson<int>(json['targetMin']),
      targetMax: serializer.fromJson<int>(json['targetMax']),
      restSec: serializer.fromJson<int>(json['restSec']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'targetSets': serializer.toJson<int>(targetSets),
      'targetMin': serializer.toJson<int>(targetMin),
      'targetMax': serializer.toJson<int>(targetMax),
      'restSec': serializer.toJson<int>(restSec),
    };
  }

  SessionExerciseRow copyWith({
    int? id,
    int? sessionId,
    String? exerciseId,
    int? orderIndex,
    int? targetSets,
    int? targetMin,
    int? targetMax,
    int? restSec,
  }) => SessionExerciseRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    orderIndex: orderIndex ?? this.orderIndex,
    targetSets: targetSets ?? this.targetSets,
    targetMin: targetMin ?? this.targetMin,
    targetMax: targetMax ?? this.targetMax,
    restSec: restSec ?? this.restSec,
  );
  SessionExerciseRow copyWithCompanion(SessionExercisesCompanion data) {
    return SessionExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      targetSets: data.targetSets.present
          ? data.targetSets.value
          : this.targetSets,
      targetMin: data.targetMin.present ? data.targetMin.value : this.targetMin,
      targetMax: data.targetMax.present ? data.targetMax.value : this.targetMax,
      restSec: data.restSec.present ? data.restSec.value : this.restSec,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionExerciseRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetMin: $targetMin, ')
          ..write('targetMax: $targetMax, ')
          ..write('restSec: $restSec')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    exerciseId,
    orderIndex,
    targetSets,
    targetMin,
    targetMax,
    restSec,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionExerciseRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.orderIndex == this.orderIndex &&
          other.targetSets == this.targetSets &&
          other.targetMin == this.targetMin &&
          other.targetMax == this.targetMax &&
          other.restSec == this.restSec);
}

class SessionExercisesCompanion extends UpdateCompanion<SessionExerciseRow> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> exerciseId;
  final Value<int> orderIndex;
  final Value<int> targetSets;
  final Value<int> targetMin;
  final Value<int> targetMax;
  final Value<int> restSec;
  const SessionExercisesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.targetSets = const Value.absent(),
    this.targetMin = const Value.absent(),
    this.targetMax = const Value.absent(),
    this.restSec = const Value.absent(),
  });
  SessionExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String exerciseId,
    required int orderIndex,
    required int targetSets,
    required int targetMin,
    required int targetMax,
    required int restSec,
  }) : sessionId = Value(sessionId),
       exerciseId = Value(exerciseId),
       orderIndex = Value(orderIndex),
       targetSets = Value(targetSets),
       targetMin = Value(targetMin),
       targetMax = Value(targetMax),
       restSec = Value(restSec);
  static Insertable<SessionExerciseRow> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? exerciseId,
    Expression<int>? orderIndex,
    Expression<int>? targetSets,
    Expression<int>? targetMin,
    Expression<int>? targetMax,
    Expression<int>? restSec,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (targetSets != null) 'target_sets': targetSets,
      if (targetMin != null) 'target_min': targetMin,
      if (targetMax != null) 'target_max': targetMax,
      if (restSec != null) 'rest_sec': restSec,
    });
  }

  SessionExercisesCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<String>? exerciseId,
    Value<int>? orderIndex,
    Value<int>? targetSets,
    Value<int>? targetMin,
    Value<int>? targetMax,
    Value<int>? restSec,
  }) {
    return SessionExercisesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
      targetSets: targetSets ?? this.targetSets,
      targetMin: targetMin ?? this.targetMin,
      targetMax: targetMax ?? this.targetMax,
      restSec: restSec ?? this.restSec,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (targetSets.present) {
      map['target_sets'] = Variable<int>(targetSets.value);
    }
    if (targetMin.present) {
      map['target_min'] = Variable<int>(targetMin.value);
    }
    if (targetMax.present) {
      map['target_max'] = Variable<int>(targetMax.value);
    }
    if (restSec.present) {
      map['rest_sec'] = Variable<int>(restSec.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionExercisesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetMin: $targetMin, ')
          ..write('targetMax: $targetMax, ')
          ..write('restSec: $restSec')
          ..write(')'))
        .toString();
  }
}

class $SetLogsTable extends SetLogs with TableInfo<$SetLogsTable, SetLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionExerciseIdMeta = const VerificationMeta(
    'sessionExerciseId',
  );
  @override
  late final GeneratedColumn<int> sessionExerciseId = GeneratedColumn<int>(
    'session_exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES session_exercises (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _setNumberMeta = const VerificationMeta(
    'setNumber',
  );
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'set_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rirMeta = const VerificationMeta('rir');
  @override
  late final GeneratedColumn<int> rir = GeneratedColumn<int>(
    'rir',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<double> rpe = GeneratedColumn<double>(
    'rpe',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionExerciseId,
    setNumber,
    value,
    rir,
    rpe,
    method,
    loggedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'set_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SetLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_exercise_id')) {
      context.handle(
        _sessionExerciseIdMeta,
        sessionExerciseId.isAcceptableOrUnknown(
          data['session_exercise_id']!,
          _sessionExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionExerciseIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('rir')) {
      context.handle(
        _rirMeta,
        rir.isAcceptableOrUnknown(data['rir']!, _rirMeta),
      );
    }
    if (data.containsKey('rpe')) {
      context.handle(
        _rpeMeta,
        rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta),
      );
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_exercise_id'],
      )!,
      setNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_number'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
      rir: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rir'],
      ),
      rpe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rpe'],
      ),
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
    );
  }

  @override
  $SetLogsTable createAlias(String alias) {
    return $SetLogsTable(attachedDatabase, alias);
  }
}

class SetLogRow extends DataClass implements Insertable<SetLogRow> {
  final int id;
  final int sessionExerciseId;
  final int setNumber;
  final int value;
  final int? rir;
  final double? rpe;
  final String method;
  final DateTime loggedAt;
  const SetLogRow({
    required this.id,
    required this.sessionExerciseId,
    required this.setNumber,
    required this.value,
    this.rir,
    this.rpe,
    required this.method,
    required this.loggedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_exercise_id'] = Variable<int>(sessionExerciseId);
    map['set_number'] = Variable<int>(setNumber);
    map['value'] = Variable<int>(value);
    if (!nullToAbsent || rir != null) {
      map['rir'] = Variable<int>(rir);
    }
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<double>(rpe);
    }
    map['method'] = Variable<String>(method);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    return map;
  }

  SetLogsCompanion toCompanion(bool nullToAbsent) {
    return SetLogsCompanion(
      id: Value(id),
      sessionExerciseId: Value(sessionExerciseId),
      setNumber: Value(setNumber),
      value: Value(value),
      rir: rir == null && nullToAbsent ? const Value.absent() : Value(rir),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      method: Value(method),
      loggedAt: Value(loggedAt),
    );
  }

  factory SetLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetLogRow(
      id: serializer.fromJson<int>(json['id']),
      sessionExerciseId: serializer.fromJson<int>(json['sessionExerciseId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      value: serializer.fromJson<int>(json['value']),
      rir: serializer.fromJson<int?>(json['rir']),
      rpe: serializer.fromJson<double?>(json['rpe']),
      method: serializer.fromJson<String>(json['method']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionExerciseId': serializer.toJson<int>(sessionExerciseId),
      'setNumber': serializer.toJson<int>(setNumber),
      'value': serializer.toJson<int>(value),
      'rir': serializer.toJson<int?>(rir),
      'rpe': serializer.toJson<double?>(rpe),
      'method': serializer.toJson<String>(method),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
    };
  }

  SetLogRow copyWith({
    int? id,
    int? sessionExerciseId,
    int? setNumber,
    int? value,
    Value<int?> rir = const Value.absent(),
    Value<double?> rpe = const Value.absent(),
    String? method,
    DateTime? loggedAt,
  }) => SetLogRow(
    id: id ?? this.id,
    sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
    setNumber: setNumber ?? this.setNumber,
    value: value ?? this.value,
    rir: rir.present ? rir.value : this.rir,
    rpe: rpe.present ? rpe.value : this.rpe,
    method: method ?? this.method,
    loggedAt: loggedAt ?? this.loggedAt,
  );
  SetLogRow copyWithCompanion(SetLogsCompanion data) {
    return SetLogRow(
      id: data.id.present ? data.id.value : this.id,
      sessionExerciseId: data.sessionExerciseId.present
          ? data.sessionExerciseId.value
          : this.sessionExerciseId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      value: data.value.present ? data.value.value : this.value,
      rir: data.rir.present ? data.rir.value : this.rir,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      method: data.method.present ? data.method.value : this.method,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetLogRow(')
          ..write('id: $id, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('value: $value, ')
          ..write('rir: $rir, ')
          ..write('rpe: $rpe, ')
          ..write('method: $method, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionExerciseId,
    setNumber,
    value,
    rir,
    rpe,
    method,
    loggedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetLogRow &&
          other.id == this.id &&
          other.sessionExerciseId == this.sessionExerciseId &&
          other.setNumber == this.setNumber &&
          other.value == this.value &&
          other.rir == this.rir &&
          other.rpe == this.rpe &&
          other.method == this.method &&
          other.loggedAt == this.loggedAt);
}

class SetLogsCompanion extends UpdateCompanion<SetLogRow> {
  final Value<int> id;
  final Value<int> sessionExerciseId;
  final Value<int> setNumber;
  final Value<int> value;
  final Value<int?> rir;
  final Value<double?> rpe;
  final Value<String> method;
  final Value<DateTime> loggedAt;
  const SetLogsCompanion({
    this.id = const Value.absent(),
    this.sessionExerciseId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.value = const Value.absent(),
    this.rir = const Value.absent(),
    this.rpe = const Value.absent(),
    this.method = const Value.absent(),
    this.loggedAt = const Value.absent(),
  });
  SetLogsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionExerciseId,
    required int setNumber,
    required int value,
    this.rir = const Value.absent(),
    this.rpe = const Value.absent(),
    required String method,
    required DateTime loggedAt,
  }) : sessionExerciseId = Value(sessionExerciseId),
       setNumber = Value(setNumber),
       value = Value(value),
       method = Value(method),
       loggedAt = Value(loggedAt);
  static Insertable<SetLogRow> custom({
    Expression<int>? id,
    Expression<int>? sessionExerciseId,
    Expression<int>? setNumber,
    Expression<int>? value,
    Expression<int>? rir,
    Expression<double>? rpe,
    Expression<String>? method,
    Expression<DateTime>? loggedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionExerciseId != null) 'session_exercise_id': sessionExerciseId,
      if (setNumber != null) 'set_number': setNumber,
      if (value != null) 'value': value,
      if (rir != null) 'rir': rir,
      if (rpe != null) 'rpe': rpe,
      if (method != null) 'method': method,
      if (loggedAt != null) 'logged_at': loggedAt,
    });
  }

  SetLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionExerciseId,
    Value<int>? setNumber,
    Value<int>? value,
    Value<int?>? rir,
    Value<double?>? rpe,
    Value<String>? method,
    Value<DateTime>? loggedAt,
  }) {
    return SetLogsCompanion(
      id: id ?? this.id,
      sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
      setNumber: setNumber ?? this.setNumber,
      value: value ?? this.value,
      rir: rir ?? this.rir,
      rpe: rpe ?? this.rpe,
      method: method ?? this.method,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionExerciseId.present) {
      map['session_exercise_id'] = Variable<int>(sessionExerciseId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (rir.present) {
      map['rir'] = Variable<int>(rir.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<double>(rpe.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetLogsCompanion(')
          ..write('id: $id, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('value: $value, ')
          ..write('rir: $rir, ')
          ..write('rpe: $rpe, ')
          ..write('method: $method, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }
}

class $ChainProgressTable extends ChainProgress
    with TableInfo<$ChainProgressTable, ChainProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChainProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _chainIdMeta = const VerificationMeta(
    'chainId',
  );
  @override
  late final GeneratedColumn<String> chainId = GeneratedColumn<String>(
    'chain_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _holdTargetMeta = const VerificationMeta(
    'holdTarget',
  );
  @override
  late final GeneratedColumn<int> holdTarget = GeneratedColumn<int>(
    'hold_target',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bonusMeta = const VerificationMeta('bonus');
  @override
  late final GeneratedColumn<int> bonus = GeneratedColumn<int>(
    'bonus',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _successStreakMeta = const VerificationMeta(
    'successStreak',
  );
  @override
  late final GeneratedColumn<int> successStreak = GeneratedColumn<int>(
    'success_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _failStreakMeta = const VerificationMeta(
    'failStreak',
  );
  @override
  late final GeneratedColumn<int> failStreak = GeneratedColumn<int>(
    'fail_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dropStreakMeta = const VerificationMeta(
    'dropStreak',
  );
  @override
  late final GeneratedColumn<int> dropStreak = GeneratedColumn<int>(
    'drop_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    chainId,
    exerciseId,
    holdTarget,
    bonus,
    successStreak,
    failStreak,
    dropStreak,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chain_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChainProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('chain_id')) {
      context.handle(
        _chainIdMeta,
        chainId.isAcceptableOrUnknown(data['chain_id']!, _chainIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chainIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('hold_target')) {
      context.handle(
        _holdTargetMeta,
        holdTarget.isAcceptableOrUnknown(data['hold_target']!, _holdTargetMeta),
      );
    }
    if (data.containsKey('bonus')) {
      context.handle(
        _bonusMeta,
        bonus.isAcceptableOrUnknown(data['bonus']!, _bonusMeta),
      );
    }
    if (data.containsKey('success_streak')) {
      context.handle(
        _successStreakMeta,
        successStreak.isAcceptableOrUnknown(
          data['success_streak']!,
          _successStreakMeta,
        ),
      );
    }
    if (data.containsKey('fail_streak')) {
      context.handle(
        _failStreakMeta,
        failStreak.isAcceptableOrUnknown(data['fail_streak']!, _failStreakMeta),
      );
    }
    if (data.containsKey('drop_streak')) {
      context.handle(
        _dropStreakMeta,
        dropStreak.isAcceptableOrUnknown(data['drop_streak']!, _dropStreakMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {chainId};
  @override
  ChainProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChainProgressRow(
      chainId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chain_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      holdTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hold_target'],
      ),
      bonus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bonus'],
      )!,
      successStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}success_streak'],
      )!,
      failStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fail_streak'],
      )!,
      dropStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}drop_streak'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ChainProgressTable createAlias(String alias) {
    return $ChainProgressTable(attachedDatabase, alias);
  }
}

class ChainProgressRow extends DataClass
    implements Insertable<ChainProgressRow> {
  final String chainId;
  final String exerciseId;

  /// Current per-set hold goal in seconds (holds only).
  final int? holdTarget;

  /// Extra reps/seconds on top of the library range, earned at the end of a chain.
  final int bonus;
  final int successStreak;
  final int failStreak;
  final int dropStreak;
  final DateTime updatedAt;
  const ChainProgressRow({
    required this.chainId,
    required this.exerciseId,
    this.holdTarget,
    required this.bonus,
    required this.successStreak,
    required this.failStreak,
    required this.dropStreak,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['chain_id'] = Variable<String>(chainId);
    map['exercise_id'] = Variable<String>(exerciseId);
    if (!nullToAbsent || holdTarget != null) {
      map['hold_target'] = Variable<int>(holdTarget);
    }
    map['bonus'] = Variable<int>(bonus);
    map['success_streak'] = Variable<int>(successStreak);
    map['fail_streak'] = Variable<int>(failStreak);
    map['drop_streak'] = Variable<int>(dropStreak);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ChainProgressCompanion toCompanion(bool nullToAbsent) {
    return ChainProgressCompanion(
      chainId: Value(chainId),
      exerciseId: Value(exerciseId),
      holdTarget: holdTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(holdTarget),
      bonus: Value(bonus),
      successStreak: Value(successStreak),
      failStreak: Value(failStreak),
      dropStreak: Value(dropStreak),
      updatedAt: Value(updatedAt),
    );
  }

  factory ChainProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChainProgressRow(
      chainId: serializer.fromJson<String>(json['chainId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      holdTarget: serializer.fromJson<int?>(json['holdTarget']),
      bonus: serializer.fromJson<int>(json['bonus']),
      successStreak: serializer.fromJson<int>(json['successStreak']),
      failStreak: serializer.fromJson<int>(json['failStreak']),
      dropStreak: serializer.fromJson<int>(json['dropStreak']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'chainId': serializer.toJson<String>(chainId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'holdTarget': serializer.toJson<int?>(holdTarget),
      'bonus': serializer.toJson<int>(bonus),
      'successStreak': serializer.toJson<int>(successStreak),
      'failStreak': serializer.toJson<int>(failStreak),
      'dropStreak': serializer.toJson<int>(dropStreak),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ChainProgressRow copyWith({
    String? chainId,
    String? exerciseId,
    Value<int?> holdTarget = const Value.absent(),
    int? bonus,
    int? successStreak,
    int? failStreak,
    int? dropStreak,
    DateTime? updatedAt,
  }) => ChainProgressRow(
    chainId: chainId ?? this.chainId,
    exerciseId: exerciseId ?? this.exerciseId,
    holdTarget: holdTarget.present ? holdTarget.value : this.holdTarget,
    bonus: bonus ?? this.bonus,
    successStreak: successStreak ?? this.successStreak,
    failStreak: failStreak ?? this.failStreak,
    dropStreak: dropStreak ?? this.dropStreak,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ChainProgressRow copyWithCompanion(ChainProgressCompanion data) {
    return ChainProgressRow(
      chainId: data.chainId.present ? data.chainId.value : this.chainId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      holdTarget: data.holdTarget.present
          ? data.holdTarget.value
          : this.holdTarget,
      bonus: data.bonus.present ? data.bonus.value : this.bonus,
      successStreak: data.successStreak.present
          ? data.successStreak.value
          : this.successStreak,
      failStreak: data.failStreak.present
          ? data.failStreak.value
          : this.failStreak,
      dropStreak: data.dropStreak.present
          ? data.dropStreak.value
          : this.dropStreak,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChainProgressRow(')
          ..write('chainId: $chainId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('holdTarget: $holdTarget, ')
          ..write('bonus: $bonus, ')
          ..write('successStreak: $successStreak, ')
          ..write('failStreak: $failStreak, ')
          ..write('dropStreak: $dropStreak, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    chainId,
    exerciseId,
    holdTarget,
    bonus,
    successStreak,
    failStreak,
    dropStreak,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChainProgressRow &&
          other.chainId == this.chainId &&
          other.exerciseId == this.exerciseId &&
          other.holdTarget == this.holdTarget &&
          other.bonus == this.bonus &&
          other.successStreak == this.successStreak &&
          other.failStreak == this.failStreak &&
          other.dropStreak == this.dropStreak &&
          other.updatedAt == this.updatedAt);
}

class ChainProgressCompanion extends UpdateCompanion<ChainProgressRow> {
  final Value<String> chainId;
  final Value<String> exerciseId;
  final Value<int?> holdTarget;
  final Value<int> bonus;
  final Value<int> successStreak;
  final Value<int> failStreak;
  final Value<int> dropStreak;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ChainProgressCompanion({
    this.chainId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.holdTarget = const Value.absent(),
    this.bonus = const Value.absent(),
    this.successStreak = const Value.absent(),
    this.failStreak = const Value.absent(),
    this.dropStreak = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChainProgressCompanion.insert({
    required String chainId,
    required String exerciseId,
    this.holdTarget = const Value.absent(),
    this.bonus = const Value.absent(),
    this.successStreak = const Value.absent(),
    this.failStreak = const Value.absent(),
    this.dropStreak = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : chainId = Value(chainId),
       exerciseId = Value(exerciseId),
       updatedAt = Value(updatedAt);
  static Insertable<ChainProgressRow> custom({
    Expression<String>? chainId,
    Expression<String>? exerciseId,
    Expression<int>? holdTarget,
    Expression<int>? bonus,
    Expression<int>? successStreak,
    Expression<int>? failStreak,
    Expression<int>? dropStreak,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (chainId != null) 'chain_id': chainId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (holdTarget != null) 'hold_target': holdTarget,
      if (bonus != null) 'bonus': bonus,
      if (successStreak != null) 'success_streak': successStreak,
      if (failStreak != null) 'fail_streak': failStreak,
      if (dropStreak != null) 'drop_streak': dropStreak,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChainProgressCompanion copyWith({
    Value<String>? chainId,
    Value<String>? exerciseId,
    Value<int?>? holdTarget,
    Value<int>? bonus,
    Value<int>? successStreak,
    Value<int>? failStreak,
    Value<int>? dropStreak,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ChainProgressCompanion(
      chainId: chainId ?? this.chainId,
      exerciseId: exerciseId ?? this.exerciseId,
      holdTarget: holdTarget ?? this.holdTarget,
      bonus: bonus ?? this.bonus,
      successStreak: successStreak ?? this.successStreak,
      failStreak: failStreak ?? this.failStreak,
      dropStreak: dropStreak ?? this.dropStreak,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (chainId.present) {
      map['chain_id'] = Variable<String>(chainId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (holdTarget.present) {
      map['hold_target'] = Variable<int>(holdTarget.value);
    }
    if (bonus.present) {
      map['bonus'] = Variable<int>(bonus.value);
    }
    if (successStreak.present) {
      map['success_streak'] = Variable<int>(successStreak.value);
    }
    if (failStreak.present) {
      map['fail_streak'] = Variable<int>(failStreak.value);
    }
    if (dropStreak.present) {
      map['drop_streak'] = Variable<int>(dropStreak.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChainProgressCompanion(')
          ..write('chainId: $chainId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('holdTarget: $holdTarget, ')
          ..write('bonus: $bonus, ')
          ..write('successStreak: $successStreak, ')
          ..write('failStreak: $failStreak, ')
          ..write('dropStreak: $dropStreak, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MilestonesTable extends Milestones
    with TableInfo<$MilestonesTable, MilestoneRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MilestonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _chainIdMeta = const VerificationMeta(
    'chainId',
  );
  @override
  late final GeneratedColumn<String> chainId = GeneratedColumn<String>(
    'chain_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _achievedAtMeta = const VerificationMeta(
    'achievedAt',
  );
  @override
  late final GeneratedColumn<DateTime> achievedAt = GeneratedColumn<DateTime>(
    'achieved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, chainId, exerciseId, achievedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'milestones';
  @override
  VerificationContext validateIntegrity(
    Insertable<MilestoneRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chain_id')) {
      context.handle(
        _chainIdMeta,
        chainId.isAcceptableOrUnknown(data['chain_id']!, _chainIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chainIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('achieved_at')) {
      context.handle(
        _achievedAtMeta,
        achievedAt.isAcceptableOrUnknown(data['achieved_at']!, _achievedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_achievedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MilestoneRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MilestoneRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      chainId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chain_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      achievedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}achieved_at'],
      )!,
    );
  }

  @override
  $MilestonesTable createAlias(String alias) {
    return $MilestonesTable(attachedDatabase, alias);
  }
}

class MilestoneRow extends DataClass implements Insertable<MilestoneRow> {
  final int id;
  final String chainId;
  final String exerciseId;
  final DateTime achievedAt;
  const MilestoneRow({
    required this.id,
    required this.chainId,
    required this.exerciseId,
    required this.achievedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chain_id'] = Variable<String>(chainId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['achieved_at'] = Variable<DateTime>(achievedAt);
    return map;
  }

  MilestonesCompanion toCompanion(bool nullToAbsent) {
    return MilestonesCompanion(
      id: Value(id),
      chainId: Value(chainId),
      exerciseId: Value(exerciseId),
      achievedAt: Value(achievedAt),
    );
  }

  factory MilestoneRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MilestoneRow(
      id: serializer.fromJson<int>(json['id']),
      chainId: serializer.fromJson<String>(json['chainId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      achievedAt: serializer.fromJson<DateTime>(json['achievedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chainId': serializer.toJson<String>(chainId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'achievedAt': serializer.toJson<DateTime>(achievedAt),
    };
  }

  MilestoneRow copyWith({
    int? id,
    String? chainId,
    String? exerciseId,
    DateTime? achievedAt,
  }) => MilestoneRow(
    id: id ?? this.id,
    chainId: chainId ?? this.chainId,
    exerciseId: exerciseId ?? this.exerciseId,
    achievedAt: achievedAt ?? this.achievedAt,
  );
  MilestoneRow copyWithCompanion(MilestonesCompanion data) {
    return MilestoneRow(
      id: data.id.present ? data.id.value : this.id,
      chainId: data.chainId.present ? data.chainId.value : this.chainId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      achievedAt: data.achievedAt.present
          ? data.achievedAt.value
          : this.achievedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MilestoneRow(')
          ..write('id: $id, ')
          ..write('chainId: $chainId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('achievedAt: $achievedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, chainId, exerciseId, achievedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MilestoneRow &&
          other.id == this.id &&
          other.chainId == this.chainId &&
          other.exerciseId == this.exerciseId &&
          other.achievedAt == this.achievedAt);
}

class MilestonesCompanion extends UpdateCompanion<MilestoneRow> {
  final Value<int> id;
  final Value<String> chainId;
  final Value<String> exerciseId;
  final Value<DateTime> achievedAt;
  const MilestonesCompanion({
    this.id = const Value.absent(),
    this.chainId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.achievedAt = const Value.absent(),
  });
  MilestonesCompanion.insert({
    this.id = const Value.absent(),
    required String chainId,
    required String exerciseId,
    required DateTime achievedAt,
  }) : chainId = Value(chainId),
       exerciseId = Value(exerciseId),
       achievedAt = Value(achievedAt);
  static Insertable<MilestoneRow> custom({
    Expression<int>? id,
    Expression<String>? chainId,
    Expression<String>? exerciseId,
    Expression<DateTime>? achievedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chainId != null) 'chain_id': chainId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (achievedAt != null) 'achieved_at': achievedAt,
    });
  }

  MilestonesCompanion copyWith({
    Value<int>? id,
    Value<String>? chainId,
    Value<String>? exerciseId,
    Value<DateTime>? achievedAt,
  }) {
    return MilestonesCompanion(
      id: id ?? this.id,
      chainId: chainId ?? this.chainId,
      exerciseId: exerciseId ?? this.exerciseId,
      achievedAt: achievedAt ?? this.achievedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chainId.present) {
      map['chain_id'] = Variable<String>(chainId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<DateTime>(achievedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MilestonesCompanion(')
          ..write('id: $id, ')
          ..write('chainId: $chainId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('achievedAt: $achievedAt')
          ..write(')'))
        .toString();
  }
}

class $ProgressPhotosTable extends ProgressPhotos
    with TableInfo<$ProgressPhotosTable, PhotoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bytesMeta = const VerificationMeta('bytes');
  @override
  late final GeneratedColumn<Uint8List> bytes = GeneratedColumn<Uint8List>(
    'bytes',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, takenAt, weightKg, bytes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<PhotoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('bytes')) {
      context.handle(
        _bytesMeta,
        bytes.isAcceptableOrUnknown(data['bytes']!, _bytesMeta),
      );
    } else if (isInserting) {
      context.missing(_bytesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PhotoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhotoRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      bytes: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}bytes'],
      )!,
    );
  }

  @override
  $ProgressPhotosTable createAlias(String alias) {
    return $ProgressPhotosTable(attachedDatabase, alias);
  }
}

class PhotoRow extends DataClass implements Insertable<PhotoRow> {
  final int id;
  final DateTime takenAt;
  final double? weightKg;
  final Uint8List bytes;
  const PhotoRow({
    required this.id,
    required this.takenAt,
    this.weightKg,
    required this.bytes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['taken_at'] = Variable<DateTime>(takenAt);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    map['bytes'] = Variable<Uint8List>(bytes);
    return map;
  }

  ProgressPhotosCompanion toCompanion(bool nullToAbsent) {
    return ProgressPhotosCompanion(
      id: Value(id),
      takenAt: Value(takenAt),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      bytes: Value(bytes),
    );
  }

  factory PhotoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhotoRow(
      id: serializer.fromJson<int>(json['id']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      bytes: serializer.fromJson<Uint8List>(json['bytes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'takenAt': serializer.toJson<DateTime>(takenAt),
      'weightKg': serializer.toJson<double?>(weightKg),
      'bytes': serializer.toJson<Uint8List>(bytes),
    };
  }

  PhotoRow copyWith({
    int? id,
    DateTime? takenAt,
    Value<double?> weightKg = const Value.absent(),
    Uint8List? bytes,
  }) => PhotoRow(
    id: id ?? this.id,
    takenAt: takenAt ?? this.takenAt,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    bytes: bytes ?? this.bytes,
  );
  PhotoRow copyWithCompanion(ProgressPhotosCompanion data) {
    return PhotoRow(
      id: data.id.present ? data.id.value : this.id,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      bytes: data.bytes.present ? data.bytes.value : this.bytes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhotoRow(')
          ..write('id: $id, ')
          ..write('takenAt: $takenAt, ')
          ..write('weightKg: $weightKg, ')
          ..write('bytes: $bytes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, takenAt, weightKg, $driftBlobEquality.hash(bytes));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhotoRow &&
          other.id == this.id &&
          other.takenAt == this.takenAt &&
          other.weightKg == this.weightKg &&
          $driftBlobEquality.equals(other.bytes, this.bytes));
}

class ProgressPhotosCompanion extends UpdateCompanion<PhotoRow> {
  final Value<int> id;
  final Value<DateTime> takenAt;
  final Value<double?> weightKg;
  final Value<Uint8List> bytes;
  const ProgressPhotosCompanion({
    this.id = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.bytes = const Value.absent(),
  });
  ProgressPhotosCompanion.insert({
    this.id = const Value.absent(),
    required DateTime takenAt,
    this.weightKg = const Value.absent(),
    required Uint8List bytes,
  }) : takenAt = Value(takenAt),
       bytes = Value(bytes);
  static Insertable<PhotoRow> custom({
    Expression<int>? id,
    Expression<DateTime>? takenAt,
    Expression<double>? weightKg,
    Expression<Uint8List>? bytes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (takenAt != null) 'taken_at': takenAt,
      if (weightKg != null) 'weight_kg': weightKg,
      if (bytes != null) 'bytes': bytes,
    });
  }

  ProgressPhotosCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? takenAt,
    Value<double?>? weightKg,
    Value<Uint8List>? bytes,
  }) {
    return ProgressPhotosCompanion(
      id: id ?? this.id,
      takenAt: takenAt ?? this.takenAt,
      weightKg: weightKg ?? this.weightKg,
      bytes: bytes ?? this.bytes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (bytes.present) {
      map['bytes'] = Variable<Uint8List>(bytes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressPhotosCompanion(')
          ..write('id: $id, ')
          ..write('takenAt: $takenAt, ')
          ..write('weightKg: $weightKg, ')
          ..write('bytes: $bytes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $InjuriesTable injuries = $InjuriesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $SessionExercisesTable sessionExercises = $SessionExercisesTable(
    this,
  );
  late final $SetLogsTable setLogs = $SetLogsTable(this);
  late final $ChainProgressTable chainProgress = $ChainProgressTable(this);
  late final $MilestonesTable milestones = $MilestonesTable(this);
  late final $ProgressPhotosTable progressPhotos = $ProgressPhotosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    injuries,
    settings,
    sessions,
    sessionExercises,
    setLogs,
    chainProgress,
    milestones,
    progressPhotos,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('session_exercises', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'session_exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('set_logs', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  required int birthYear,
  required double heightCm,
  required double weightKg,
  required String experience,
  Value<int?> maxPushUps,
  Value<int?> maxPullUps,
  Value<int?> maxDeadHangSec,
  Value<int?> maxPlankSec,
  required DateTime createdAt,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  Value<int> birthYear,
  Value<double> heightCm,
  Value<double> weightKg,
  Value<String> experience,
  Value<int?> maxPushUps,
  Value<int?> maxPullUps,
  Value<int?> maxDeadHangSec,
  Value<int?> maxPlankSec,
  Value<DateTime> createdAt,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
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

  ColumnFilters<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxPushUps => $composableBuilder(
    column: $table.maxPushUps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxPullUps => $composableBuilder(
    column: $table.maxPullUps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxDeadHangSec => $composableBuilder(
    column: $table.maxDeadHangSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxPlankSec => $composableBuilder(
    column: $table.maxPlankSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
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

  ColumnOrderings<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxPushUps => $composableBuilder(
    column: $table.maxPushUps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxPullUps => $composableBuilder(
    column: $table.maxPullUps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxDeadHangSec => $composableBuilder(
    column: $table.maxDeadHangSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxPlankSec => $composableBuilder(
    column: $table.maxPlankSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get birthYear =>
      $composableBuilder(column: $table.birthYear, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxPushUps => $composableBuilder(
    column: $table.maxPushUps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxPullUps => $composableBuilder(
    column: $table.maxPullUps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxDeadHangSec => $composableBuilder(
    column: $table.maxDeadHangSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxPlankSec => $composableBuilder(
    column: $table.maxPlankSec,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          ProfileRow,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (
            ProfileRow,
            BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>,
          ),
          ProfileRow,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> birthYear = const Value.absent(),
                Value<double> heightCm = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<String> experience = const Value.absent(),
                Value<int?> maxPushUps = const Value.absent(),
                Value<int?> maxPullUps = const Value.absent(),
                Value<int?> maxDeadHangSec = const Value.absent(),
                Value<int?> maxPlankSec = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                birthYear: birthYear,
                heightCm: heightCm,
                weightKg: weightKg,
                experience: experience,
                maxPushUps: maxPushUps,
                maxPullUps: maxPullUps,
                maxDeadHangSec: maxDeadHangSec,
                maxPlankSec: maxPlankSec,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int birthYear,
                required double heightCm,
                required double weightKg,
                required String experience,
                Value<int?> maxPushUps = const Value.absent(),
                Value<int?> maxPullUps = const Value.absent(),
                Value<int?> maxDeadHangSec = const Value.absent(),
                Value<int?> maxPlankSec = const Value.absent(),
                required DateTime createdAt,
              }) => ProfilesCompanion.insert(
                id: id,
                birthYear: birthYear,
                heightCm: heightCm,
                weightKg: weightKg,
                experience: experience,
                maxPushUps: maxPushUps,
                maxPullUps: maxPullUps,
                maxDeadHangSec: maxDeadHangSec,
                maxPlankSec: maxPlankSec,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, ProfileRow>(table),
                  BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      ProfileRow,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (ProfileRow, BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>),
      ProfileRow,
      PrefetchHooks Function()
    >;
typedef $$InjuriesTableCreateCompanionBuilder = InjuriesCompanion Function({
  required String joint,
  required String severity,
  Value<bool> isCurrent,
  Value<int> rowid,
});
typedef $$InjuriesTableUpdateCompanionBuilder = InjuriesCompanion Function({
  Value<String> joint,
  Value<String> severity,
  Value<bool> isCurrent,
  Value<int> rowid,
});

class $$InjuriesTableFilterComposer
    extends Composer<_$AppDatabase, $InjuriesTable> {
  $$InjuriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get joint => $composableBuilder(
    column: $table.joint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCurrent => $composableBuilder(
    column: $table.isCurrent,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InjuriesTableOrderingComposer
    extends Composer<_$AppDatabase, $InjuriesTable> {
  $$InjuriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get joint => $composableBuilder(
    column: $table.joint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCurrent => $composableBuilder(
    column: $table.isCurrent,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InjuriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InjuriesTable> {
  $$InjuriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get joint =>
      $composableBuilder(column: $table.joint, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<bool> get isCurrent =>
      $composableBuilder(column: $table.isCurrent, builder: (column) => column);
}

class $$InjuriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InjuriesTable,
          InjuryRow,
          $$InjuriesTableFilterComposer,
          $$InjuriesTableOrderingComposer,
          $$InjuriesTableAnnotationComposer,
          $$InjuriesTableCreateCompanionBuilder,
          $$InjuriesTableUpdateCompanionBuilder,
          (InjuryRow, BaseReferences<_$AppDatabase, $InjuriesTable, InjuryRow>),
          InjuryRow,
          PrefetchHooks Function()
        > {
  $$InjuriesTableTableManager(_$AppDatabase db, $InjuriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InjuriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InjuriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InjuriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> joint = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<bool> isCurrent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InjuriesCompanion(
                joint: joint,
                severity: severity,
                isCurrent: isCurrent,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String joint,
                required String severity,
                Value<bool> isCurrent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InjuriesCompanion.insert(
                joint: joint,
                severity: severity,
                isCurrent: isCurrent,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InjuriesTable, InjuryRow>(table),
                  BaseReferences<_$AppDatabase, $InjuriesTable, InjuryRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InjuriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InjuriesTable,
      InjuryRow,
      $$InjuriesTableFilterComposer,
      $$InjuriesTableOrderingComposer,
      $$InjuriesTableAnnotationComposer,
      $$InjuriesTableCreateCompanionBuilder,
      $$InjuriesTableUpdateCompanionBuilder,
      (InjuryRow, BaseReferences<_$AppDatabase, $InjuriesTable, InjuryRow>),
      InjuryRow,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          SettingRow,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, SettingRow>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      SettingRow,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (SettingRow, BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>),
      SettingRow,
      PrefetchHooks Function()
    >;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  required String name,
  required DateTime startedAt,
  Value<DateTime?> finishedAt,
  Value<int> currentIndex,
  Value<int> pendingCount,
  Value<DateTime?> restEndsAt,
  Value<int?> restTotalSec,
  Value<String?> planWeek,
  Value<int?> planDayIndex,
  Value<bool> isDeload,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> startedAt,
  Value<DateTime?> finishedAt,
  Value<int> currentIndex,
  Value<int> pendingCount,
  Value<DateTime?> restEndsAt,
  Value<int?> restTotalSec,
  Value<String?> planWeek,
  Value<int?> planDayIndex,
  Value<bool> isDeload,
});

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, SessionRow> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionExercisesTable, List<SessionExerciseRow>>
  _sessionExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionExercises,
    aliasName: 'sessions__id__session_exercises__session_id',
  );

  $$SessionExercisesTableProcessedTableManager get sessionExercisesRefs {
    final manager = $$SessionExercisesTableTableManager(
      $_db,
      $_db.sessionExercises,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pendingCount => $composableBuilder(
    column: $table.pendingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get restEndsAt => $composableBuilder(
    column: $table.restEndsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restTotalSec => $composableBuilder(
    column: $table.restTotalSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planWeek => $composableBuilder(
    column: $table.planWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get planDayIndex => $composableBuilder(
    column: $table.planDayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeload => $composableBuilder(
    column: $table.isDeload,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sessionExercisesRefs(
    Expression<bool> Function($$SessionExercisesTableFilterComposer f) f,
  ) {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pendingCount => $composableBuilder(
    column: $table.pendingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get restEndsAt => $composableBuilder(
    column: $table.restEndsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restTotalSec => $composableBuilder(
    column: $table.restTotalSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planWeek => $composableBuilder(
    column: $table.planWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get planDayIndex => $composableBuilder(
    column: $table.planDayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeload => $composableBuilder(
    column: $table.isDeload,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pendingCount => $composableBuilder(
    column: $table.pendingCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get restEndsAt => $composableBuilder(
    column: $table.restEndsAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restTotalSec => $composableBuilder(
    column: $table.restTotalSec,
    builder: (column) => column,
  );

  GeneratedColumn<String> get planWeek =>
      $composableBuilder(column: $table.planWeek, builder: (column) => column);

  GeneratedColumn<int> get planDayIndex => $composableBuilder(
    column: $table.planDayIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeload =>
      $composableBuilder(column: $table.isDeload, builder: (column) => column);

  Expression<T> sessionExercisesRefs<T extends Object>(
    Expression<T> Function($$SessionExercisesTableAnnotationComposer a) f,
  ) {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          SessionRow,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (SessionRow, $$SessionsTableReferences),
          SessionRow,
          PrefetchHooks Function({bool sessionExercisesRefs})
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int> currentIndex = const Value.absent(),
                Value<int> pendingCount = const Value.absent(),
                Value<DateTime?> restEndsAt = const Value.absent(),
                Value<int?> restTotalSec = const Value.absent(),
                Value<String?> planWeek = const Value.absent(),
                Value<int?> planDayIndex = const Value.absent(),
                Value<bool> isDeload = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                name: name,
                startedAt: startedAt,
                finishedAt: finishedAt,
                currentIndex: currentIndex,
                pendingCount: pendingCount,
                restEndsAt: restEndsAt,
                restTotalSec: restTotalSec,
                planWeek: planWeek,
                planDayIndex: planDayIndex,
                isDeload: isDeload,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime startedAt,
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int> currentIndex = const Value.absent(),
                Value<int> pendingCount = const Value.absent(),
                Value<DateTime?> restEndsAt = const Value.absent(),
                Value<int?> restTotalSec = const Value.absent(),
                Value<String?> planWeek = const Value.absent(),
                Value<int?> planDayIndex = const Value.absent(),
                Value<bool> isDeload = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                name: name,
                startedAt: startedAt,
                finishedAt: finishedAt,
                currentIndex: currentIndex,
                pendingCount: pendingCount,
                restEndsAt: restEndsAt,
                restTotalSec: restTotalSec,
                planWeek: planWeek,
                planDayIndex: planDayIndex,
                isDeload: isDeload,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionsTable, SessionRow>(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sessionExercisesRefs) db.sessionExercises,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionExercisesRefs)
                    await $_getPrefetchedDataByColumns<
                      SessionRow,
                      $SessionsTable,
                      SessionExerciseRow,
                      $SessionExercisesTable
                    >(
                      currentTable: table,
                      referencedTable: $$SessionsTableReferences
                          ._sessionExercisesRefsTable(db),
                      managerFromTypedResult: (p0) => $$SessionsTableReferences(
                        db,
                        table,
                        p0,
                      ).sessionExercisesRefs,
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

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      SessionRow,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (SessionRow, $$SessionsTableReferences),
      SessionRow,
      PrefetchHooks Function({bool sessionExercisesRefs})
    >;
typedef $$SessionExercisesTableCreateCompanionBuilder =
    SessionExercisesCompanion Function({
      Value<int> id,
      required int sessionId,
      required String exerciseId,
      required int orderIndex,
      required int targetSets,
      required int targetMin,
      required int targetMax,
      required int restSec,
    });
typedef $$SessionExercisesTableUpdateCompanionBuilder =
    SessionExercisesCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<String> exerciseId,
      Value<int> orderIndex,
      Value<int> targetSets,
      Value<int> targetMin,
      Value<int> targetMax,
      Value<int> restSec,
    });

final class $$SessionExercisesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SessionExercisesTable,
          SessionExerciseRow
        > {
  $$SessionExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('session_exercises__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SetLogsTable, List<SetLogRow>> _setLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.setLogs,
    aliasName: 'session_exercises__id__set_logs__session_exercise_id',
  );

  $$SetLogsTableProcessedTableManager get setLogsRefs {
    final manager = $$SetLogsTableTableManager(
      $_db,
      $_db.setLogs,
    ).filter((f) => f.sessionExerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_setLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableFilterComposer({
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

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetMin => $composableBuilder(
    column: $table.targetMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetMax => $composableBuilder(
    column: $table.targetMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSec => $composableBuilder(
    column: $table.restSec,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> setLogsRefs(
    Expression<bool> Function($$SetLogsTableFilterComposer f) f,
  ) {
    final $$SetLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.sessionExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableFilterComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableOrderingComposer({
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

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetMin => $composableBuilder(
    column: $table.targetMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetMax => $composableBuilder(
    column: $table.targetMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSec => $composableBuilder(
    column: $table.restSec,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetMin =>
      $composableBuilder(column: $table.targetMin, builder: (column) => column);

  GeneratedColumn<int> get targetMax =>
      $composableBuilder(column: $table.targetMax, builder: (column) => column);

  GeneratedColumn<int> get restSec =>
      $composableBuilder(column: $table.restSec, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> setLogsRefs<T extends Object>(
    Expression<T> Function($$SetLogsTableAnnotationComposer a) f,
  ) {
    final $$SetLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.sessionExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionExercisesTable,
          SessionExerciseRow,
          $$SessionExercisesTableFilterComposer,
          $$SessionExercisesTableOrderingComposer,
          $$SessionExercisesTableAnnotationComposer,
          $$SessionExercisesTableCreateCompanionBuilder,
          $$SessionExercisesTableUpdateCompanionBuilder,
          (SessionExerciseRow, $$SessionExercisesTableReferences),
          SessionExerciseRow,
          PrefetchHooks Function({bool sessionId, bool setLogsRefs})
        > {
  $$SessionExercisesTableTableManager(
    _$AppDatabase db,
    $SessionExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> targetSets = const Value.absent(),
                Value<int> targetMin = const Value.absent(),
                Value<int> targetMax = const Value.absent(),
                Value<int> restSec = const Value.absent(),
              }) => SessionExercisesCompanion(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
                targetSets: targetSets,
                targetMin: targetMin,
                targetMax: targetMax,
                restSec: restSec,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required String exerciseId,
                required int orderIndex,
                required int targetSets,
                required int targetMin,
                required int targetMax,
                required int restSec,
              }) => SessionExercisesCompanion.insert(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
                targetSets: targetSets,
                targetMin: targetMin,
                targetMax: targetMax,
                restSec: restSec,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionExercisesTable, SessionExerciseRow>(
                    table,
                  ),
                  $$SessionExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, setLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (setLogsRefs) db.setLogs],
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
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$SessionExercisesTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$SessionExercisesTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (setLogsRefs)
                    await $_getPrefetchedDataByColumns<
                      SessionExerciseRow,
                      $SessionExercisesTable,
                      SetLogRow,
                      $SetLogsTable
                    >(
                      currentTable: table,
                      referencedTable: $$SessionExercisesTableReferences
                          ._setLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SessionExercisesTableReferences(
                            db,
                            table,
                            p0,
                          ).setLogsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'session_exercise_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SessionExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionExercisesTable,
      SessionExerciseRow,
      $$SessionExercisesTableFilterComposer,
      $$SessionExercisesTableOrderingComposer,
      $$SessionExercisesTableAnnotationComposer,
      $$SessionExercisesTableCreateCompanionBuilder,
      $$SessionExercisesTableUpdateCompanionBuilder,
      (SessionExerciseRow, $$SessionExercisesTableReferences),
      SessionExerciseRow,
      PrefetchHooks Function({bool sessionId, bool setLogsRefs})
    >;
typedef $$SetLogsTableCreateCompanionBuilder = SetLogsCompanion Function({
  Value<int> id,
  required int sessionExerciseId,
  required int setNumber,
  required int value,
  Value<int?> rir,
  Value<double?> rpe,
  required String method,
  required DateTime loggedAt,
});
typedef $$SetLogsTableUpdateCompanionBuilder = SetLogsCompanion Function({
  Value<int> id,
  Value<int> sessionExerciseId,
  Value<int> setNumber,
  Value<int> value,
  Value<int?> rir,
  Value<double?> rpe,
  Value<String> method,
  Value<DateTime> loggedAt,
});

final class $$SetLogsTableReferences
    extends BaseReferences<_$AppDatabase, $SetLogsTable, SetLogRow> {
  $$SetLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionExercisesTable _sessionExerciseIdTable(_$AppDatabase db) => db
      .sessionExercises
      .createAlias('set_logs__session_exercise_id__session_exercises__id');

  $$SessionExercisesTableProcessedTableManager get sessionExerciseId {
    final $_column = $_itemColumn<int>('session_exercise_id')!;

    final manager = $$SessionExercisesTableTableManager(
      $_db,
      $_db.sessionExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SetLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableFilterComposer({
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

  ColumnFilters<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionExercisesTableFilterComposer get sessionExerciseId {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionExerciseId,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableOrderingComposer({
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

  ColumnOrderings<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionExercisesTableOrderingComposer get sessionExerciseId {
    final $$SessionExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionExerciseId,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get rir =>
      $composableBuilder(column: $table.rir, builder: (column) => column);

  GeneratedColumn<double> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  $$SessionExercisesTableAnnotationComposer get sessionExerciseId {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionExerciseId,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SetLogsTable,
          SetLogRow,
          $$SetLogsTableFilterComposer,
          $$SetLogsTableOrderingComposer,
          $$SetLogsTableAnnotationComposer,
          $$SetLogsTableCreateCompanionBuilder,
          $$SetLogsTableUpdateCompanionBuilder,
          (SetLogRow, $$SetLogsTableReferences),
          SetLogRow,
          PrefetchHooks Function({bool sessionExerciseId})
        > {
  $$SetLogsTableTableManager(_$AppDatabase db, $SetLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionExerciseId = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<int?> rir = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
              }) => SetLogsCompanion(
                id: id,
                sessionExerciseId: sessionExerciseId,
                setNumber: setNumber,
                value: value,
                rir: rir,
                rpe: rpe,
                method: method,
                loggedAt: loggedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionExerciseId,
                required int setNumber,
                required int value,
                Value<int?> rir = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                required String method,
                required DateTime loggedAt,
              }) => SetLogsCompanion.insert(
                id: id,
                sessionExerciseId: sessionExerciseId,
                setNumber: setNumber,
                value: value,
                rir: rir,
                rpe: rpe,
                method: method,
                loggedAt: loggedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SetLogsTable, SetLogRow>(table),
                  $$SetLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionExerciseId = false}) {
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
                    if (sessionExerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionExerciseId,
                        referencedTable: $$SetLogsTableReferences
                            ._sessionExerciseIdTable(db),
                        referencedColumn: $$SetLogsTableReferences
                            ._sessionExerciseIdTable(db)
                            .id,
                      ) as T;
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

typedef $$SetLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SetLogsTable,
      SetLogRow,
      $$SetLogsTableFilterComposer,
      $$SetLogsTableOrderingComposer,
      $$SetLogsTableAnnotationComposer,
      $$SetLogsTableCreateCompanionBuilder,
      $$SetLogsTableUpdateCompanionBuilder,
      (SetLogRow, $$SetLogsTableReferences),
      SetLogRow,
      PrefetchHooks Function({bool sessionExerciseId})
    >;
typedef $$ChainProgressTableCreateCompanionBuilder =
    ChainProgressCompanion Function({
      required String chainId,
      required String exerciseId,
      Value<int?> holdTarget,
      Value<int> bonus,
      Value<int> successStreak,
      Value<int> failStreak,
      Value<int> dropStreak,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ChainProgressTableUpdateCompanionBuilder =
    ChainProgressCompanion Function({
      Value<String> chainId,
      Value<String> exerciseId,
      Value<int?> holdTarget,
      Value<int> bonus,
      Value<int> successStreak,
      Value<int> failStreak,
      Value<int> dropStreak,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ChainProgressTableFilterComposer
    extends Composer<_$AppDatabase, $ChainProgressTable> {
  $$ChainProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get chainId => $composableBuilder(
    column: $table.chainId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get holdTarget => $composableBuilder(
    column: $table.holdTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bonus => $composableBuilder(
    column: $table.bonus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get successStreak => $composableBuilder(
    column: $table.successStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get failStreak => $composableBuilder(
    column: $table.failStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dropStreak => $composableBuilder(
    column: $table.dropStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChainProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $ChainProgressTable> {
  $$ChainProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get chainId => $composableBuilder(
    column: $table.chainId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get holdTarget => $composableBuilder(
    column: $table.holdTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bonus => $composableBuilder(
    column: $table.bonus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get successStreak => $composableBuilder(
    column: $table.successStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get failStreak => $composableBuilder(
    column: $table.failStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dropStreak => $composableBuilder(
    column: $table.dropStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChainProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChainProgressTable> {
  $$ChainProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get chainId =>
      $composableBuilder(column: $table.chainId, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get holdTarget => $composableBuilder(
    column: $table.holdTarget,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bonus =>
      $composableBuilder(column: $table.bonus, builder: (column) => column);

  GeneratedColumn<int> get successStreak => $composableBuilder(
    column: $table.successStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get failStreak => $composableBuilder(
    column: $table.failStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dropStreak => $composableBuilder(
    column: $table.dropStreak,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ChainProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChainProgressTable,
          ChainProgressRow,
          $$ChainProgressTableFilterComposer,
          $$ChainProgressTableOrderingComposer,
          $$ChainProgressTableAnnotationComposer,
          $$ChainProgressTableCreateCompanionBuilder,
          $$ChainProgressTableUpdateCompanionBuilder,
          (
            ChainProgressRow,
            BaseReferences<
              _$AppDatabase,
              $ChainProgressTable,
              ChainProgressRow
            >,
          ),
          ChainProgressRow,
          PrefetchHooks Function()
        > {
  $$ChainProgressTableTableManager(_$AppDatabase db, $ChainProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChainProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChainProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChainProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> chainId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int?> holdTarget = const Value.absent(),
                Value<int> bonus = const Value.absent(),
                Value<int> successStreak = const Value.absent(),
                Value<int> failStreak = const Value.absent(),
                Value<int> dropStreak = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChainProgressCompanion(
                chainId: chainId,
                exerciseId: exerciseId,
                holdTarget: holdTarget,
                bonus: bonus,
                successStreak: successStreak,
                failStreak: failStreak,
                dropStreak: dropStreak,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String chainId,
                required String exerciseId,
                Value<int?> holdTarget = const Value.absent(),
                Value<int> bonus = const Value.absent(),
                Value<int> successStreak = const Value.absent(),
                Value<int> failStreak = const Value.absent(),
                Value<int> dropStreak = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ChainProgressCompanion.insert(
                chainId: chainId,
                exerciseId: exerciseId,
                holdTarget: holdTarget,
                bonus: bonus,
                successStreak: successStreak,
                failStreak: failStreak,
                dropStreak: dropStreak,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChainProgressTable, ChainProgressRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ChainProgressTable,
                    ChainProgressRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChainProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChainProgressTable,
      ChainProgressRow,
      $$ChainProgressTableFilterComposer,
      $$ChainProgressTableOrderingComposer,
      $$ChainProgressTableAnnotationComposer,
      $$ChainProgressTableCreateCompanionBuilder,
      $$ChainProgressTableUpdateCompanionBuilder,
      (
        ChainProgressRow,
        BaseReferences<_$AppDatabase, $ChainProgressTable, ChainProgressRow>,
      ),
      ChainProgressRow,
      PrefetchHooks Function()
    >;
typedef $$MilestonesTableCreateCompanionBuilder = MilestonesCompanion Function({
  Value<int> id,
  required String chainId,
  required String exerciseId,
  required DateTime achievedAt,
});
typedef $$MilestonesTableUpdateCompanionBuilder = MilestonesCompanion Function({
  Value<int> id,
  Value<String> chainId,
  Value<String> exerciseId,
  Value<DateTime> achievedAt,
});

class $$MilestonesTableFilterComposer
    extends Composer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableFilterComposer({
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

  ColumnFilters<String> get chainId => $composableBuilder(
    column: $table.chainId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MilestonesTableOrderingComposer
    extends Composer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableOrderingComposer({
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

  ColumnOrderings<String> get chainId => $composableBuilder(
    column: $table.chainId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MilestonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get chainId =>
      $composableBuilder(column: $table.chainId, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => column,
  );
}

class $$MilestonesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MilestonesTable,
          MilestoneRow,
          $$MilestonesTableFilterComposer,
          $$MilestonesTableOrderingComposer,
          $$MilestonesTableAnnotationComposer,
          $$MilestonesTableCreateCompanionBuilder,
          $$MilestonesTableUpdateCompanionBuilder,
          (
            MilestoneRow,
            BaseReferences<_$AppDatabase, $MilestonesTable, MilestoneRow>,
          ),
          MilestoneRow,
          PrefetchHooks Function()
        > {
  $$MilestonesTableTableManager(_$AppDatabase db, $MilestonesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MilestonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MilestonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MilestonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> chainId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<DateTime> achievedAt = const Value.absent(),
              }) => MilestonesCompanion(
                id: id,
                chainId: chainId,
                exerciseId: exerciseId,
                achievedAt: achievedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String chainId,
                required String exerciseId,
                required DateTime achievedAt,
              }) => MilestonesCompanion.insert(
                id: id,
                chainId: chainId,
                exerciseId: exerciseId,
                achievedAt: achievedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MilestonesTable, MilestoneRow>(table),
                  BaseReferences<_$AppDatabase, $MilestonesTable, MilestoneRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MilestonesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MilestonesTable,
      MilestoneRow,
      $$MilestonesTableFilterComposer,
      $$MilestonesTableOrderingComposer,
      $$MilestonesTableAnnotationComposer,
      $$MilestonesTableCreateCompanionBuilder,
      $$MilestonesTableUpdateCompanionBuilder,
      (
        MilestoneRow,
        BaseReferences<_$AppDatabase, $MilestonesTable, MilestoneRow>,
      ),
      MilestoneRow,
      PrefetchHooks Function()
    >;
typedef $$ProgressPhotosTableCreateCompanionBuilder =
    ProgressPhotosCompanion Function({
      Value<int> id,
      required DateTime takenAt,
      Value<double?> weightKg,
      required Uint8List bytes,
    });
typedef $$ProgressPhotosTableUpdateCompanionBuilder =
    ProgressPhotosCompanion Function({
      Value<int> id,
      Value<DateTime> takenAt,
      Value<double?> weightKg,
      Value<Uint8List> bytes,
    });

class $$ProgressPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressPhotosTable> {
  $$ProgressPhotosTableFilterComposer({
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

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProgressPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressPhotosTable> {
  $$ProgressPhotosTableOrderingComposer({
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

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgressPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressPhotosTable> {
  $$ProgressPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<Uint8List> get bytes =>
      $composableBuilder(column: $table.bytes, builder: (column) => column);
}

class $$ProgressPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgressPhotosTable,
          PhotoRow,
          $$ProgressPhotosTableFilterComposer,
          $$ProgressPhotosTableOrderingComposer,
          $$ProgressPhotosTableAnnotationComposer,
          $$ProgressPhotosTableCreateCompanionBuilder,
          $$ProgressPhotosTableUpdateCompanionBuilder,
          (
            PhotoRow,
            BaseReferences<_$AppDatabase, $ProgressPhotosTable, PhotoRow>,
          ),
          PhotoRow,
          PrefetchHooks Function()
        > {
  $$ProgressPhotosTableTableManager(
    _$AppDatabase db,
    $ProgressPhotosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<Uint8List> bytes = const Value.absent(),
              }) => ProgressPhotosCompanion(
                id: id,
                takenAt: takenAt,
                weightKg: weightKg,
                bytes: bytes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime takenAt,
                Value<double?> weightKg = const Value.absent(),
                required Uint8List bytes,
              }) => ProgressPhotosCompanion.insert(
                id: id,
                takenAt: takenAt,
                weightKg: weightKg,
                bytes: bytes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProgressPhotosTable, PhotoRow>(table),
                  BaseReferences<_$AppDatabase, $ProgressPhotosTable, PhotoRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProgressPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgressPhotosTable,
      PhotoRow,
      $$ProgressPhotosTableFilterComposer,
      $$ProgressPhotosTableOrderingComposer,
      $$ProgressPhotosTableAnnotationComposer,
      $$ProgressPhotosTableCreateCompanionBuilder,
      $$ProgressPhotosTableUpdateCompanionBuilder,
      (PhotoRow, BaseReferences<_$AppDatabase, $ProgressPhotosTable, PhotoRow>),
      PhotoRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$InjuriesTableTableManager get injuries =>
      $$InjuriesTableTableManager(_db, _db.injuries);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$SessionExercisesTableTableManager get sessionExercises =>
      $$SessionExercisesTableTableManager(_db, _db.sessionExercises);
  $$SetLogsTableTableManager get setLogs =>
      $$SetLogsTableTableManager(_db, _db.setLogs);
  $$ChainProgressTableTableManager get chainProgress =>
      $$ChainProgressTableTableManager(_db, _db.chainProgress);
  $$MilestonesTableTableManager get milestones =>
      $$MilestonesTableTableManager(_db, _db.milestones);
  $$ProgressPhotosTableTableManager get progressPhotos =>
      $$ProgressPhotosTableTableManager(_db, _db.progressPhotos);
}
