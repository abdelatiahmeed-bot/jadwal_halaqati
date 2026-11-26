// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TeachersTableTable extends TeachersTable
    with TableInfo<$TeachersTableTable, TeachersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeachersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _loginCodeMeta =
      const VerificationMeta('loginCode');
  @override
  late final GeneratedColumn<String> loginCode = GeneratedColumn<String>(
      'login_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _studentCountMeta =
      const VerificationMeta('studentCount');
  @override
  late final GeneratedColumn<int> studentCount = GeneratedColumn<int>(
      'student_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, fullName, phoneNumber, loginCode, isActive, studentCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teachers_table';
  @override
  VerificationContext validateIntegrity(Insertable<TeachersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('login_code')) {
      context.handle(_loginCodeMeta,
          loginCode.isAcceptableOrUnknown(data['login_code']!, _loginCodeMeta));
    } else if (isInserting) {
      context.missing(_loginCodeMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('student_count')) {
      context.handle(
          _studentCountMeta,
          studentCount.isAcceptableOrUnknown(
              data['student_count']!, _studentCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TeachersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeachersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number'])!,
      loginCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}login_code'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      studentCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}student_count'])!,
    );
  }

  @override
  $TeachersTableTable createAlias(String alias) {
    return $TeachersTableTable(attachedDatabase, alias);
  }
}

class TeachersTableData extends DataClass
    implements Insertable<TeachersTableData> {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String loginCode;
  final bool isActive;
  final int studentCount;
  const TeachersTableData(
      {required this.id,
      required this.fullName,
      required this.phoneNumber,
      required this.loginCode,
      required this.isActive,
      required this.studentCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['login_code'] = Variable<String>(loginCode);
    map['is_active'] = Variable<bool>(isActive);
    map['student_count'] = Variable<int>(studentCount);
    return map;
  }

  TeachersTableCompanion toCompanion(bool nullToAbsent) {
    return TeachersTableCompanion(
      id: Value(id),
      fullName: Value(fullName),
      phoneNumber: Value(phoneNumber),
      loginCode: Value(loginCode),
      isActive: Value(isActive),
      studentCount: Value(studentCount),
    );
  }

  factory TeachersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeachersTableData(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      loginCode: serializer.fromJson<String>(json['loginCode']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      studentCount: serializer.fromJson<int>(json['studentCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'loginCode': serializer.toJson<String>(loginCode),
      'isActive': serializer.toJson<bool>(isActive),
      'studentCount': serializer.toJson<int>(studentCount),
    };
  }

  TeachersTableData copyWith(
          {String? id,
          String? fullName,
          String? phoneNumber,
          String? loginCode,
          bool? isActive,
          int? studentCount}) =>
      TeachersTableData(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        loginCode: loginCode ?? this.loginCode,
        isActive: isActive ?? this.isActive,
        studentCount: studentCount ?? this.studentCount,
      );
  TeachersTableData copyWithCompanion(TeachersTableCompanion data) {
    return TeachersTableData(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      loginCode: data.loginCode.present ? data.loginCode.value : this.loginCode,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      studentCount: data.studentCount.present
          ? data.studentCount.value
          : this.studentCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeachersTableData(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('loginCode: $loginCode, ')
          ..write('isActive: $isActive, ')
          ..write('studentCount: $studentCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fullName, phoneNumber, loginCode, isActive, studentCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeachersTableData &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.phoneNumber == this.phoneNumber &&
          other.loginCode == this.loginCode &&
          other.isActive == this.isActive &&
          other.studentCount == this.studentCount);
}

class TeachersTableCompanion extends UpdateCompanion<TeachersTableData> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String> phoneNumber;
  final Value<String> loginCode;
  final Value<bool> isActive;
  final Value<int> studentCount;
  final Value<int> rowid;
  const TeachersTableCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.loginCode = const Value.absent(),
    this.isActive = const Value.absent(),
    this.studentCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TeachersTableCompanion.insert({
    required String id,
    required String fullName,
    required String phoneNumber,
    required String loginCode,
    this.isActive = const Value.absent(),
    this.studentCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        fullName = Value(fullName),
        phoneNumber = Value(phoneNumber),
        loginCode = Value(loginCode);
  static Insertable<TeachersTableData> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? phoneNumber,
    Expression<String>? loginCode,
    Expression<bool>? isActive,
    Expression<int>? studentCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (loginCode != null) 'login_code': loginCode,
      if (isActive != null) 'is_active': isActive,
      if (studentCount != null) 'student_count': studentCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TeachersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? fullName,
      Value<String>? phoneNumber,
      Value<String>? loginCode,
      Value<bool>? isActive,
      Value<int>? studentCount,
      Value<int>? rowid}) {
    return TeachersTableCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      loginCode: loginCode ?? this.loginCode,
      isActive: isActive ?? this.isActive,
      studentCount: studentCount ?? this.studentCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (loginCode.present) {
      map['login_code'] = Variable<String>(loginCode.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (studentCount.present) {
      map['student_count'] = Variable<int>(studentCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeachersTableCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('loginCode: $loginCode, ')
          ..write('isActive: $isActive, ')
          ..write('studentCount: $studentCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudentsTableTable extends StudentsTable
    with TableInfo<$StudentsTableTable, StudentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentNameMeta =
      const VerificationMeta('parentName');
  @override
  late final GeneratedColumn<String> parentName = GeneratedColumn<String>(
      'parent_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentPhoneMeta =
      const VerificationMeta('parentPhone');
  @override
  late final GeneratedColumn<String> parentPhone = GeneratedColumn<String>(
      'parent_phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _loginCodeMeta =
      const VerificationMeta('loginCode');
  @override
  late final GeneratedColumn<String> loginCode = GeneratedColumn<String>(
      'login_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _teacherIdMeta =
      const VerificationMeta('teacherId');
  @override
  late final GeneratedColumn<String> teacherId = GeneratedColumn<String>(
      'teacher_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
      'points', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _starsMeta = const VerificationMeta('stars');
  @override
  late final GeneratedColumn<int> stars = GeneratedColumn<int>(
      'stars', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _achievementLevelMeta =
      const VerificationMeta('achievementLevel');
  @override
  late final GeneratedColumn<String> achievementLevel = GeneratedColumn<String>(
      'achievement_level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Novice'));
  static const VerificationMeta _lastProgressSyncMeta =
      const VerificationMeta('lastProgressSync');
  @override
  late final GeneratedColumn<DateTime> lastProgressSync =
      GeneratedColumn<DateTime>('last_progress_sync', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _monthlySubscriptionMeta =
      const VerificationMeta('monthlySubscription');
  @override
  late final GeneratedColumn<int> monthlySubscription = GeneratedColumn<int>(
      'monthly_subscription', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(60));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        parentName,
        parentPhone,
        loginCode,
        teacherId,
        points,
        stars,
        achievementLevel,
        lastProgressSync,
        monthlySubscription
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students_table';
  @override
  VerificationContext validateIntegrity(Insertable<StudentsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_name')) {
      context.handle(
          _parentNameMeta,
          parentName.isAcceptableOrUnknown(
              data['parent_name']!, _parentNameMeta));
    } else if (isInserting) {
      context.missing(_parentNameMeta);
    }
    if (data.containsKey('parent_phone')) {
      context.handle(
          _parentPhoneMeta,
          parentPhone.isAcceptableOrUnknown(
              data['parent_phone']!, _parentPhoneMeta));
    } else if (isInserting) {
      context.missing(_parentPhoneMeta);
    }
    if (data.containsKey('login_code')) {
      context.handle(_loginCodeMeta,
          loginCode.isAcceptableOrUnknown(data['login_code']!, _loginCodeMeta));
    } else if (isInserting) {
      context.missing(_loginCodeMeta);
    }
    if (data.containsKey('teacher_id')) {
      context.handle(_teacherIdMeta,
          teacherId.isAcceptableOrUnknown(data['teacher_id']!, _teacherIdMeta));
    }
    if (data.containsKey('points')) {
      context.handle(_pointsMeta,
          points.isAcceptableOrUnknown(data['points']!, _pointsMeta));
    }
    if (data.containsKey('stars')) {
      context.handle(
          _starsMeta, stars.isAcceptableOrUnknown(data['stars']!, _starsMeta));
    }
    if (data.containsKey('achievement_level')) {
      context.handle(
          _achievementLevelMeta,
          achievementLevel.isAcceptableOrUnknown(
              data['achievement_level']!, _achievementLevelMeta));
    }
    if (data.containsKey('last_progress_sync')) {
      context.handle(
          _lastProgressSyncMeta,
          lastProgressSync.isAcceptableOrUnknown(
              data['last_progress_sync']!, _lastProgressSyncMeta));
    }
    if (data.containsKey('monthly_subscription')) {
      context.handle(
          _monthlySubscriptionMeta,
          monthlySubscription.isAcceptableOrUnknown(
              data['monthly_subscription']!, _monthlySubscriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      parentName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_name'])!,
      parentPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_phone'])!,
      loginCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}login_code'])!,
      teacherId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}teacher_id']),
      points: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}points'])!,
      stars: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stars'])!,
      achievementLevel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}achievement_level'])!,
      lastProgressSync: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_progress_sync']),
      monthlySubscription: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}monthly_subscription'])!,
    );
  }

  @override
  $StudentsTableTable createAlias(String alias) {
    return $StudentsTableTable(attachedDatabase, alias);
  }
}

class StudentsTableData extends DataClass
    implements Insertable<StudentsTableData> {
  final String id;
  final String name;
  final String parentName;
  final String parentPhone;
  final String loginCode;
  final String? teacherId;
  final int points;
  final int stars;
  final String achievementLevel;
  final DateTime? lastProgressSync;
  final int monthlySubscription;
  const StudentsTableData(
      {required this.id,
      required this.name,
      required this.parentName,
      required this.parentPhone,
      required this.loginCode,
      this.teacherId,
      required this.points,
      required this.stars,
      required this.achievementLevel,
      this.lastProgressSync,
      required this.monthlySubscription});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['parent_name'] = Variable<String>(parentName);
    map['parent_phone'] = Variable<String>(parentPhone);
    map['login_code'] = Variable<String>(loginCode);
    if (!nullToAbsent || teacherId != null) {
      map['teacher_id'] = Variable<String>(teacherId);
    }
    map['points'] = Variable<int>(points);
    map['stars'] = Variable<int>(stars);
    map['achievement_level'] = Variable<String>(achievementLevel);
    if (!nullToAbsent || lastProgressSync != null) {
      map['last_progress_sync'] = Variable<DateTime>(lastProgressSync);
    }
    map['monthly_subscription'] = Variable<int>(monthlySubscription);
    return map;
  }

  StudentsTableCompanion toCompanion(bool nullToAbsent) {
    return StudentsTableCompanion(
      id: Value(id),
      name: Value(name),
      parentName: Value(parentName),
      parentPhone: Value(parentPhone),
      loginCode: Value(loginCode),
      teacherId: teacherId == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherId),
      points: Value(points),
      stars: Value(stars),
      achievementLevel: Value(achievementLevel),
      lastProgressSync: lastProgressSync == null && nullToAbsent
          ? const Value.absent()
          : Value(lastProgressSync),
      monthlySubscription: Value(monthlySubscription),
    );
  }

  factory StudentsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentName: serializer.fromJson<String>(json['parentName']),
      parentPhone: serializer.fromJson<String>(json['parentPhone']),
      loginCode: serializer.fromJson<String>(json['loginCode']),
      teacherId: serializer.fromJson<String?>(json['teacherId']),
      points: serializer.fromJson<int>(json['points']),
      stars: serializer.fromJson<int>(json['stars']),
      achievementLevel: serializer.fromJson<String>(json['achievementLevel']),
      lastProgressSync:
          serializer.fromJson<DateTime?>(json['lastProgressSync']),
      monthlySubscription:
          serializer.fromJson<int>(json['monthlySubscription']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentName': serializer.toJson<String>(parentName),
      'parentPhone': serializer.toJson<String>(parentPhone),
      'loginCode': serializer.toJson<String>(loginCode),
      'teacherId': serializer.toJson<String?>(teacherId),
      'points': serializer.toJson<int>(points),
      'stars': serializer.toJson<int>(stars),
      'achievementLevel': serializer.toJson<String>(achievementLevel),
      'lastProgressSync': serializer.toJson<DateTime?>(lastProgressSync),
      'monthlySubscription': serializer.toJson<int>(monthlySubscription),
    };
  }

  StudentsTableData copyWith(
          {String? id,
          String? name,
          String? parentName,
          String? parentPhone,
          String? loginCode,
          Value<String?> teacherId = const Value.absent(),
          int? points,
          int? stars,
          String? achievementLevel,
          Value<DateTime?> lastProgressSync = const Value.absent(),
          int? monthlySubscription}) =>
      StudentsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        parentName: parentName ?? this.parentName,
        parentPhone: parentPhone ?? this.parentPhone,
        loginCode: loginCode ?? this.loginCode,
        teacherId: teacherId.present ? teacherId.value : this.teacherId,
        points: points ?? this.points,
        stars: stars ?? this.stars,
        achievementLevel: achievementLevel ?? this.achievementLevel,
        lastProgressSync: lastProgressSync.present
            ? lastProgressSync.value
            : this.lastProgressSync,
        monthlySubscription: monthlySubscription ?? this.monthlySubscription,
      );
  StudentsTableData copyWithCompanion(StudentsTableCompanion data) {
    return StudentsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentName:
          data.parentName.present ? data.parentName.value : this.parentName,
      parentPhone:
          data.parentPhone.present ? data.parentPhone.value : this.parentPhone,
      loginCode: data.loginCode.present ? data.loginCode.value : this.loginCode,
      teacherId: data.teacherId.present ? data.teacherId.value : this.teacherId,
      points: data.points.present ? data.points.value : this.points,
      stars: data.stars.present ? data.stars.value : this.stars,
      achievementLevel: data.achievementLevel.present
          ? data.achievementLevel.value
          : this.achievementLevel,
      lastProgressSync: data.lastProgressSync.present
          ? data.lastProgressSync.value
          : this.lastProgressSync,
      monthlySubscription: data.monthlySubscription.present
          ? data.monthlySubscription.value
          : this.monthlySubscription,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentName: $parentName, ')
          ..write('parentPhone: $parentPhone, ')
          ..write('loginCode: $loginCode, ')
          ..write('teacherId: $teacherId, ')
          ..write('points: $points, ')
          ..write('stars: $stars, ')
          ..write('achievementLevel: $achievementLevel, ')
          ..write('lastProgressSync: $lastProgressSync, ')
          ..write('monthlySubscription: $monthlySubscription')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      parentName,
      parentPhone,
      loginCode,
      teacherId,
      points,
      stars,
      achievementLevel,
      lastProgressSync,
      monthlySubscription);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentName == this.parentName &&
          other.parentPhone == this.parentPhone &&
          other.loginCode == this.loginCode &&
          other.teacherId == this.teacherId &&
          other.points == this.points &&
          other.stars == this.stars &&
          other.achievementLevel == this.achievementLevel &&
          other.lastProgressSync == this.lastProgressSync &&
          other.monthlySubscription == this.monthlySubscription);
}

class StudentsTableCompanion extends UpdateCompanion<StudentsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> parentName;
  final Value<String> parentPhone;
  final Value<String> loginCode;
  final Value<String?> teacherId;
  final Value<int> points;
  final Value<int> stars;
  final Value<String> achievementLevel;
  final Value<DateTime?> lastProgressSync;
  final Value<int> monthlySubscription;
  final Value<int> rowid;
  const StudentsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentName = const Value.absent(),
    this.parentPhone = const Value.absent(),
    this.loginCode = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.points = const Value.absent(),
    this.stars = const Value.absent(),
    this.achievementLevel = const Value.absent(),
    this.lastProgressSync = const Value.absent(),
    this.monthlySubscription = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentsTableCompanion.insert({
    required String id,
    required String name,
    required String parentName,
    required String parentPhone,
    required String loginCode,
    this.teacherId = const Value.absent(),
    this.points = const Value.absent(),
    this.stars = const Value.absent(),
    this.achievementLevel = const Value.absent(),
    this.lastProgressSync = const Value.absent(),
    this.monthlySubscription = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        parentName = Value(parentName),
        parentPhone = Value(parentPhone),
        loginCode = Value(loginCode);
  static Insertable<StudentsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentName,
    Expression<String>? parentPhone,
    Expression<String>? loginCode,
    Expression<String>? teacherId,
    Expression<int>? points,
    Expression<int>? stars,
    Expression<String>? achievementLevel,
    Expression<DateTime>? lastProgressSync,
    Expression<int>? monthlySubscription,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentName != null) 'parent_name': parentName,
      if (parentPhone != null) 'parent_phone': parentPhone,
      if (loginCode != null) 'login_code': loginCode,
      if (teacherId != null) 'teacher_id': teacherId,
      if (points != null) 'points': points,
      if (stars != null) 'stars': stars,
      if (achievementLevel != null) 'achievement_level': achievementLevel,
      if (lastProgressSync != null) 'last_progress_sync': lastProgressSync,
      if (monthlySubscription != null)
        'monthly_subscription': monthlySubscription,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? parentName,
      Value<String>? parentPhone,
      Value<String>? loginCode,
      Value<String?>? teacherId,
      Value<int>? points,
      Value<int>? stars,
      Value<String>? achievementLevel,
      Value<DateTime?>? lastProgressSync,
      Value<int>? monthlySubscription,
      Value<int>? rowid}) {
    return StudentsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentName: parentName ?? this.parentName,
      parentPhone: parentPhone ?? this.parentPhone,
      loginCode: loginCode ?? this.loginCode,
      teacherId: teacherId ?? this.teacherId,
      points: points ?? this.points,
      stars: stars ?? this.stars,
      achievementLevel: achievementLevel ?? this.achievementLevel,
      lastProgressSync: lastProgressSync ?? this.lastProgressSync,
      monthlySubscription: monthlySubscription ?? this.monthlySubscription,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentName.present) {
      map['parent_name'] = Variable<String>(parentName.value);
    }
    if (parentPhone.present) {
      map['parent_phone'] = Variable<String>(parentPhone.value);
    }
    if (loginCode.present) {
      map['login_code'] = Variable<String>(loginCode.value);
    }
    if (teacherId.present) {
      map['teacher_id'] = Variable<String>(teacherId.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (stars.present) {
      map['stars'] = Variable<int>(stars.value);
    }
    if (achievementLevel.present) {
      map['achievement_level'] = Variable<String>(achievementLevel.value);
    }
    if (lastProgressSync.present) {
      map['last_progress_sync'] = Variable<DateTime>(lastProgressSync.value);
    }
    if (monthlySubscription.present) {
      map['monthly_subscription'] = Variable<int>(monthlySubscription.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentName: $parentName, ')
          ..write('parentPhone: $parentPhone, ')
          ..write('loginCode: $loginCode, ')
          ..write('teacherId: $teacherId, ')
          ..write('points: $points, ')
          ..write('stars: $stars, ')
          ..write('achievementLevel: $achievementLevel, ')
          ..write('lastProgressSync: $lastProgressSync, ')
          ..write('monthlySubscription: $monthlySubscription, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttendanceTableTable extends AttendanceTable
    with TableInfo<$AttendanceTableTable, AttendanceTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
      'student_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isAbsentMeta =
      const VerificationMeta('isAbsent');
  @override
  late final GeneratedColumn<bool> isAbsent = GeneratedColumn<bool>(
      'is_absent', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_absent" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _arrivalTimeMeta =
      const VerificationMeta('arrivalTime');
  @override
  late final GeneratedColumn<DateTime> arrivalTime = GeneratedColumn<DateTime>(
      'arrival_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _departureTimeMeta =
      const VerificationMeta('departureTime');
  @override
  late final GeneratedColumn<DateTime> departureTime =
      GeneratedColumn<DateTime>('departure_time', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, studentId, date, isAbsent, arrivalTime, departureTime];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AttendanceTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_absent')) {
      context.handle(_isAbsentMeta,
          isAbsent.isAcceptableOrUnknown(data['is_absent']!, _isAbsentMeta));
    }
    if (data.containsKey('arrival_time')) {
      context.handle(
          _arrivalTimeMeta,
          arrivalTime.isAcceptableOrUnknown(
              data['arrival_time']!, _arrivalTimeMeta));
    }
    if (data.containsKey('departure_time')) {
      context.handle(
          _departureTimeMeta,
          departureTime.isAcceptableOrUnknown(
              data['departure_time']!, _departureTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttendanceTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      isAbsent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_absent'])!,
      arrivalTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}arrival_time']),
      departureTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}departure_time']),
    );
  }

  @override
  $AttendanceTableTable createAlias(String alias) {
    return $AttendanceTableTable(attachedDatabase, alias);
  }
}

class AttendanceTableData extends DataClass
    implements Insertable<AttendanceTableData> {
  final String id;
  final String studentId;
  final DateTime date;
  final bool isAbsent;
  final DateTime? arrivalTime;
  final DateTime? departureTime;
  const AttendanceTableData(
      {required this.id,
      required this.studentId,
      required this.date,
      required this.isAbsent,
      this.arrivalTime,
      this.departureTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['date'] = Variable<DateTime>(date);
    map['is_absent'] = Variable<bool>(isAbsent);
    if (!nullToAbsent || arrivalTime != null) {
      map['arrival_time'] = Variable<DateTime>(arrivalTime);
    }
    if (!nullToAbsent || departureTime != null) {
      map['departure_time'] = Variable<DateTime>(departureTime);
    }
    return map;
  }

  AttendanceTableCompanion toCompanion(bool nullToAbsent) {
    return AttendanceTableCompanion(
      id: Value(id),
      studentId: Value(studentId),
      date: Value(date),
      isAbsent: Value(isAbsent),
      arrivalTime: arrivalTime == null && nullToAbsent
          ? const Value.absent()
          : Value(arrivalTime),
      departureTime: departureTime == null && nullToAbsent
          ? const Value.absent()
          : Value(departureTime),
    );
  }

  factory AttendanceTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceTableData(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      date: serializer.fromJson<DateTime>(json['date']),
      isAbsent: serializer.fromJson<bool>(json['isAbsent']),
      arrivalTime: serializer.fromJson<DateTime?>(json['arrivalTime']),
      departureTime: serializer.fromJson<DateTime?>(json['departureTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'date': serializer.toJson<DateTime>(date),
      'isAbsent': serializer.toJson<bool>(isAbsent),
      'arrivalTime': serializer.toJson<DateTime?>(arrivalTime),
      'departureTime': serializer.toJson<DateTime?>(departureTime),
    };
  }

  AttendanceTableData copyWith(
          {String? id,
          String? studentId,
          DateTime? date,
          bool? isAbsent,
          Value<DateTime?> arrivalTime = const Value.absent(),
          Value<DateTime?> departureTime = const Value.absent()}) =>
      AttendanceTableData(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        date: date ?? this.date,
        isAbsent: isAbsent ?? this.isAbsent,
        arrivalTime: arrivalTime.present ? arrivalTime.value : this.arrivalTime,
        departureTime:
            departureTime.present ? departureTime.value : this.departureTime,
      );
  AttendanceTableData copyWithCompanion(AttendanceTableCompanion data) {
    return AttendanceTableData(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      date: data.date.present ? data.date.value : this.date,
      isAbsent: data.isAbsent.present ? data.isAbsent.value : this.isAbsent,
      arrivalTime:
          data.arrivalTime.present ? data.arrivalTime.value : this.arrivalTime,
      departureTime: data.departureTime.present
          ? data.departureTime.value
          : this.departureTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceTableData(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('date: $date, ')
          ..write('isAbsent: $isAbsent, ')
          ..write('arrivalTime: $arrivalTime, ')
          ..write('departureTime: $departureTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, studentId, date, isAbsent, arrivalTime, departureTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceTableData &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.date == this.date &&
          other.isAbsent == this.isAbsent &&
          other.arrivalTime == this.arrivalTime &&
          other.departureTime == this.departureTime);
}

class AttendanceTableCompanion extends UpdateCompanion<AttendanceTableData> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<DateTime> date;
  final Value<bool> isAbsent;
  final Value<DateTime?> arrivalTime;
  final Value<DateTime?> departureTime;
  final Value<int> rowid;
  const AttendanceTableCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.date = const Value.absent(),
    this.isAbsent = const Value.absent(),
    this.arrivalTime = const Value.absent(),
    this.departureTime = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttendanceTableCompanion.insert({
    required String id,
    required String studentId,
    required DateTime date,
    this.isAbsent = const Value.absent(),
    this.arrivalTime = const Value.absent(),
    this.departureTime = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        studentId = Value(studentId),
        date = Value(date);
  static Insertable<AttendanceTableData> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<DateTime>? date,
    Expression<bool>? isAbsent,
    Expression<DateTime>? arrivalTime,
    Expression<DateTime>? departureTime,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (date != null) 'date': date,
      if (isAbsent != null) 'is_absent': isAbsent,
      if (arrivalTime != null) 'arrival_time': arrivalTime,
      if (departureTime != null) 'departure_time': departureTime,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttendanceTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? studentId,
      Value<DateTime>? date,
      Value<bool>? isAbsent,
      Value<DateTime?>? arrivalTime,
      Value<DateTime?>? departureTime,
      Value<int>? rowid}) {
    return AttendanceTableCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
      isAbsent: isAbsent ?? this.isAbsent,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      departureTime: departureTime ?? this.departureTime,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isAbsent.present) {
      map['is_absent'] = Variable<bool>(isAbsent.value);
    }
    if (arrivalTime.present) {
      map['arrival_time'] = Variable<DateTime>(arrivalTime.value);
    }
    if (departureTime.present) {
      map['departure_time'] = Variable<DateTime>(departureTime.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceTableCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('date: $date, ')
          ..write('isAbsent: $isAbsent, ')
          ..write('arrivalTime: $arrivalTime, ')
          ..write('departureTime: $departureTime, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyRecordsTableTable extends DailyRecordsTable
    with TableInfo<$DailyRecordsTableTable, DailyRecordsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyRecordsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
      'student_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _memorizationMethodMeta =
      const VerificationMeta('memorizationMethod');
  @override
  late final GeneratedColumn<String> memorizationMethod =
      GeneratedColumn<String>('memorization_method', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _memorizationDataMeta =
      const VerificationMeta('memorizationData');
  @override
  late final GeneratedColumn<String> memorizationData = GeneratedColumn<String>(
      'memorization_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _memorizationGradeMeta =
      const VerificationMeta('memorizationGrade');
  @override
  late final GeneratedColumn<String> memorizationGrade =
      GeneratedColumn<String>('memorization_grade', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _revisionMethodMeta =
      const VerificationMeta('revisionMethod');
  @override
  late final GeneratedColumn<String> revisionMethod = GeneratedColumn<String>(
      'revision_method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _revisionDataMeta =
      const VerificationMeta('revisionData');
  @override
  late final GeneratedColumn<String> revisionData = GeneratedColumn<String>(
      'revision_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _revisionGradeMeta =
      const VerificationMeta('revisionGrade');
  @override
  late final GeneratedColumn<String> revisionGrade = GeneratedColumn<String>(
      'revision_grade', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _teacherNotesMeta =
      const VerificationMeta('teacherNotes');
  @override
  late final GeneratedColumn<String> teacherNotes = GeneratedColumn<String>(
      'teacher_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _encouragementMessageMeta =
      const VerificationMeta('encouragementMessage');
  @override
  late final GeneratedColumn<String> encouragementMessage =
      GeneratedColumn<String>('encouragement_message', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        studentId,
        date,
        memorizationMethod,
        memorizationData,
        memorizationGrade,
        revisionMethod,
        revisionData,
        revisionGrade,
        teacherNotes,
        encouragementMessage
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_records_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<DailyRecordsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('memorization_method')) {
      context.handle(
          _memorizationMethodMeta,
          memorizationMethod.isAcceptableOrUnknown(
              data['memorization_method']!, _memorizationMethodMeta));
    } else if (isInserting) {
      context.missing(_memorizationMethodMeta);
    }
    if (data.containsKey('memorization_data')) {
      context.handle(
          _memorizationDataMeta,
          memorizationData.isAcceptableOrUnknown(
              data['memorization_data']!, _memorizationDataMeta));
    } else if (isInserting) {
      context.missing(_memorizationDataMeta);
    }
    if (data.containsKey('memorization_grade')) {
      context.handle(
          _memorizationGradeMeta,
          memorizationGrade.isAcceptableOrUnknown(
              data['memorization_grade']!, _memorizationGradeMeta));
    } else if (isInserting) {
      context.missing(_memorizationGradeMeta);
    }
    if (data.containsKey('revision_method')) {
      context.handle(
          _revisionMethodMeta,
          revisionMethod.isAcceptableOrUnknown(
              data['revision_method']!, _revisionMethodMeta));
    } else if (isInserting) {
      context.missing(_revisionMethodMeta);
    }
    if (data.containsKey('revision_data')) {
      context.handle(
          _revisionDataMeta,
          revisionData.isAcceptableOrUnknown(
              data['revision_data']!, _revisionDataMeta));
    } else if (isInserting) {
      context.missing(_revisionDataMeta);
    }
    if (data.containsKey('revision_grade')) {
      context.handle(
          _revisionGradeMeta,
          revisionGrade.isAcceptableOrUnknown(
              data['revision_grade']!, _revisionGradeMeta));
    } else if (isInserting) {
      context.missing(_revisionGradeMeta);
    }
    if (data.containsKey('teacher_notes')) {
      context.handle(
          _teacherNotesMeta,
          teacherNotes.isAcceptableOrUnknown(
              data['teacher_notes']!, _teacherNotesMeta));
    }
    if (data.containsKey('encouragement_message')) {
      context.handle(
          _encouragementMessageMeta,
          encouragementMessage.isAcceptableOrUnknown(
              data['encouragement_message']!, _encouragementMessageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyRecordsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyRecordsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      memorizationMethod: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}memorization_method'])!,
      memorizationData: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}memorization_data'])!,
      memorizationGrade: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}memorization_grade'])!,
      revisionMethod: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}revision_method'])!,
      revisionData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}revision_data'])!,
      revisionGrade: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}revision_grade'])!,
      teacherNotes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}teacher_notes']),
      encouragementMessage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}encouragement_message']),
    );
  }

  @override
  $DailyRecordsTableTable createAlias(String alias) {
    return $DailyRecordsTableTable(attachedDatabase, alias);
  }
}

class DailyRecordsTableData extends DataClass
    implements Insertable<DailyRecordsTableData> {
  final String id;
  final String studentId;
  final DateTime date;
  final String memorizationMethod;
  final String memorizationData;
  final String memorizationGrade;
  final String revisionMethod;
  final String revisionData;
  final String revisionGrade;
  final String? teacherNotes;
  final String? encouragementMessage;
  const DailyRecordsTableData(
      {required this.id,
      required this.studentId,
      required this.date,
      required this.memorizationMethod,
      required this.memorizationData,
      required this.memorizationGrade,
      required this.revisionMethod,
      required this.revisionData,
      required this.revisionGrade,
      this.teacherNotes,
      this.encouragementMessage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['date'] = Variable<DateTime>(date);
    map['memorization_method'] = Variable<String>(memorizationMethod);
    map['memorization_data'] = Variable<String>(memorizationData);
    map['memorization_grade'] = Variable<String>(memorizationGrade);
    map['revision_method'] = Variable<String>(revisionMethod);
    map['revision_data'] = Variable<String>(revisionData);
    map['revision_grade'] = Variable<String>(revisionGrade);
    if (!nullToAbsent || teacherNotes != null) {
      map['teacher_notes'] = Variable<String>(teacherNotes);
    }
    if (!nullToAbsent || encouragementMessage != null) {
      map['encouragement_message'] = Variable<String>(encouragementMessage);
    }
    return map;
  }

  DailyRecordsTableCompanion toCompanion(bool nullToAbsent) {
    return DailyRecordsTableCompanion(
      id: Value(id),
      studentId: Value(studentId),
      date: Value(date),
      memorizationMethod: Value(memorizationMethod),
      memorizationData: Value(memorizationData),
      memorizationGrade: Value(memorizationGrade),
      revisionMethod: Value(revisionMethod),
      revisionData: Value(revisionData),
      revisionGrade: Value(revisionGrade),
      teacherNotes: teacherNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherNotes),
      encouragementMessage: encouragementMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(encouragementMessage),
    );
  }

  factory DailyRecordsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyRecordsTableData(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      date: serializer.fromJson<DateTime>(json['date']),
      memorizationMethod:
          serializer.fromJson<String>(json['memorizationMethod']),
      memorizationData: serializer.fromJson<String>(json['memorizationData']),
      memorizationGrade: serializer.fromJson<String>(json['memorizationGrade']),
      revisionMethod: serializer.fromJson<String>(json['revisionMethod']),
      revisionData: serializer.fromJson<String>(json['revisionData']),
      revisionGrade: serializer.fromJson<String>(json['revisionGrade']),
      teacherNotes: serializer.fromJson<String?>(json['teacherNotes']),
      encouragementMessage:
          serializer.fromJson<String?>(json['encouragementMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'date': serializer.toJson<DateTime>(date),
      'memorizationMethod': serializer.toJson<String>(memorizationMethod),
      'memorizationData': serializer.toJson<String>(memorizationData),
      'memorizationGrade': serializer.toJson<String>(memorizationGrade),
      'revisionMethod': serializer.toJson<String>(revisionMethod),
      'revisionData': serializer.toJson<String>(revisionData),
      'revisionGrade': serializer.toJson<String>(revisionGrade),
      'teacherNotes': serializer.toJson<String?>(teacherNotes),
      'encouragementMessage': serializer.toJson<String?>(encouragementMessage),
    };
  }

  DailyRecordsTableData copyWith(
          {String? id,
          String? studentId,
          DateTime? date,
          String? memorizationMethod,
          String? memorizationData,
          String? memorizationGrade,
          String? revisionMethod,
          String? revisionData,
          String? revisionGrade,
          Value<String?> teacherNotes = const Value.absent(),
          Value<String?> encouragementMessage = const Value.absent()}) =>
      DailyRecordsTableData(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        date: date ?? this.date,
        memorizationMethod: memorizationMethod ?? this.memorizationMethod,
        memorizationData: memorizationData ?? this.memorizationData,
        memorizationGrade: memorizationGrade ?? this.memorizationGrade,
        revisionMethod: revisionMethod ?? this.revisionMethod,
        revisionData: revisionData ?? this.revisionData,
        revisionGrade: revisionGrade ?? this.revisionGrade,
        teacherNotes:
            teacherNotes.present ? teacherNotes.value : this.teacherNotes,
        encouragementMessage: encouragementMessage.present
            ? encouragementMessage.value
            : this.encouragementMessage,
      );
  DailyRecordsTableData copyWithCompanion(DailyRecordsTableCompanion data) {
    return DailyRecordsTableData(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      date: data.date.present ? data.date.value : this.date,
      memorizationMethod: data.memorizationMethod.present
          ? data.memorizationMethod.value
          : this.memorizationMethod,
      memorizationData: data.memorizationData.present
          ? data.memorizationData.value
          : this.memorizationData,
      memorizationGrade: data.memorizationGrade.present
          ? data.memorizationGrade.value
          : this.memorizationGrade,
      revisionMethod: data.revisionMethod.present
          ? data.revisionMethod.value
          : this.revisionMethod,
      revisionData: data.revisionData.present
          ? data.revisionData.value
          : this.revisionData,
      revisionGrade: data.revisionGrade.present
          ? data.revisionGrade.value
          : this.revisionGrade,
      teacherNotes: data.teacherNotes.present
          ? data.teacherNotes.value
          : this.teacherNotes,
      encouragementMessage: data.encouragementMessage.present
          ? data.encouragementMessage.value
          : this.encouragementMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyRecordsTableData(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('date: $date, ')
          ..write('memorizationMethod: $memorizationMethod, ')
          ..write('memorizationData: $memorizationData, ')
          ..write('memorizationGrade: $memorizationGrade, ')
          ..write('revisionMethod: $revisionMethod, ')
          ..write('revisionData: $revisionData, ')
          ..write('revisionGrade: $revisionGrade, ')
          ..write('teacherNotes: $teacherNotes, ')
          ..write('encouragementMessage: $encouragementMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      studentId,
      date,
      memorizationMethod,
      memorizationData,
      memorizationGrade,
      revisionMethod,
      revisionData,
      revisionGrade,
      teacherNotes,
      encouragementMessage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyRecordsTableData &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.date == this.date &&
          other.memorizationMethod == this.memorizationMethod &&
          other.memorizationData == this.memorizationData &&
          other.memorizationGrade == this.memorizationGrade &&
          other.revisionMethod == this.revisionMethod &&
          other.revisionData == this.revisionData &&
          other.revisionGrade == this.revisionGrade &&
          other.teacherNotes == this.teacherNotes &&
          other.encouragementMessage == this.encouragementMessage);
}

class DailyRecordsTableCompanion
    extends UpdateCompanion<DailyRecordsTableData> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<DateTime> date;
  final Value<String> memorizationMethod;
  final Value<String> memorizationData;
  final Value<String> memorizationGrade;
  final Value<String> revisionMethod;
  final Value<String> revisionData;
  final Value<String> revisionGrade;
  final Value<String?> teacherNotes;
  final Value<String?> encouragementMessage;
  final Value<int> rowid;
  const DailyRecordsTableCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.date = const Value.absent(),
    this.memorizationMethod = const Value.absent(),
    this.memorizationData = const Value.absent(),
    this.memorizationGrade = const Value.absent(),
    this.revisionMethod = const Value.absent(),
    this.revisionData = const Value.absent(),
    this.revisionGrade = const Value.absent(),
    this.teacherNotes = const Value.absent(),
    this.encouragementMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyRecordsTableCompanion.insert({
    required String id,
    required String studentId,
    required DateTime date,
    required String memorizationMethod,
    required String memorizationData,
    required String memorizationGrade,
    required String revisionMethod,
    required String revisionData,
    required String revisionGrade,
    this.teacherNotes = const Value.absent(),
    this.encouragementMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        studentId = Value(studentId),
        date = Value(date),
        memorizationMethod = Value(memorizationMethod),
        memorizationData = Value(memorizationData),
        memorizationGrade = Value(memorizationGrade),
        revisionMethod = Value(revisionMethod),
        revisionData = Value(revisionData),
        revisionGrade = Value(revisionGrade);
  static Insertable<DailyRecordsTableData> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<DateTime>? date,
    Expression<String>? memorizationMethod,
    Expression<String>? memorizationData,
    Expression<String>? memorizationGrade,
    Expression<String>? revisionMethod,
    Expression<String>? revisionData,
    Expression<String>? revisionGrade,
    Expression<String>? teacherNotes,
    Expression<String>? encouragementMessage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (date != null) 'date': date,
      if (memorizationMethod != null) 'memorization_method': memorizationMethod,
      if (memorizationData != null) 'memorization_data': memorizationData,
      if (memorizationGrade != null) 'memorization_grade': memorizationGrade,
      if (revisionMethod != null) 'revision_method': revisionMethod,
      if (revisionData != null) 'revision_data': revisionData,
      if (revisionGrade != null) 'revision_grade': revisionGrade,
      if (teacherNotes != null) 'teacher_notes': teacherNotes,
      if (encouragementMessage != null)
        'encouragement_message': encouragementMessage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyRecordsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? studentId,
      Value<DateTime>? date,
      Value<String>? memorizationMethod,
      Value<String>? memorizationData,
      Value<String>? memorizationGrade,
      Value<String>? revisionMethod,
      Value<String>? revisionData,
      Value<String>? revisionGrade,
      Value<String?>? teacherNotes,
      Value<String?>? encouragementMessage,
      Value<int>? rowid}) {
    return DailyRecordsTableCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
      memorizationMethod: memorizationMethod ?? this.memorizationMethod,
      memorizationData: memorizationData ?? this.memorizationData,
      memorizationGrade: memorizationGrade ?? this.memorizationGrade,
      revisionMethod: revisionMethod ?? this.revisionMethod,
      revisionData: revisionData ?? this.revisionData,
      revisionGrade: revisionGrade ?? this.revisionGrade,
      teacherNotes: teacherNotes ?? this.teacherNotes,
      encouragementMessage: encouragementMessage ?? this.encouragementMessage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (memorizationMethod.present) {
      map['memorization_method'] = Variable<String>(memorizationMethod.value);
    }
    if (memorizationData.present) {
      map['memorization_data'] = Variable<String>(memorizationData.value);
    }
    if (memorizationGrade.present) {
      map['memorization_grade'] = Variable<String>(memorizationGrade.value);
    }
    if (revisionMethod.present) {
      map['revision_method'] = Variable<String>(revisionMethod.value);
    }
    if (revisionData.present) {
      map['revision_data'] = Variable<String>(revisionData.value);
    }
    if (revisionGrade.present) {
      map['revision_grade'] = Variable<String>(revisionGrade.value);
    }
    if (teacherNotes.present) {
      map['teacher_notes'] = Variable<String>(teacherNotes.value);
    }
    if (encouragementMessage.present) {
      map['encouragement_message'] =
          Variable<String>(encouragementMessage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyRecordsTableCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('date: $date, ')
          ..write('memorizationMethod: $memorizationMethod, ')
          ..write('memorizationData: $memorizationData, ')
          ..write('memorizationGrade: $memorizationGrade, ')
          ..write('revisionMethod: $revisionMethod, ')
          ..write('revisionData: $revisionData, ')
          ..write('revisionGrade: $revisionGrade, ')
          ..write('teacherNotes: $teacherNotes, ')
          ..write('encouragementMessage: $encouragementMessage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TomorrowMemorizationTableTable extends TomorrowMemorizationTable
    with
        TableInfo<$TomorrowMemorizationTableTable,
            TomorrowMemorizationTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TomorrowMemorizationTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
      'student_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _memorizationMethodMeta =
      const VerificationMeta('memorizationMethod');
  @override
  late final GeneratedColumn<String> memorizationMethod =
      GeneratedColumn<String>('memorization_method', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _memorizationDataMeta =
      const VerificationMeta('memorizationData');
  @override
  late final GeneratedColumn<String> memorizationData = GeneratedColumn<String>(
      'memorization_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _revisionMethodMeta =
      const VerificationMeta('revisionMethod');
  @override
  late final GeneratedColumn<String> revisionMethod = GeneratedColumn<String>(
      'revision_method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _revisionDataMeta =
      const VerificationMeta('revisionData');
  @override
  late final GeneratedColumn<String> revisionData = GeneratedColumn<String>(
      'revision_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _encouragementMessageMeta =
      const VerificationMeta('encouragementMessage');
  @override
  late final GeneratedColumn<String> encouragementMessage =
      GeneratedColumn<String>('encouragement_message', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        studentId,
        memorizationMethod,
        memorizationData,
        revisionMethod,
        revisionData,
        notes,
        encouragementMessage
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tomorrow_memorization_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<TomorrowMemorizationTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('memorization_method')) {
      context.handle(
          _memorizationMethodMeta,
          memorizationMethod.isAcceptableOrUnknown(
              data['memorization_method']!, _memorizationMethodMeta));
    } else if (isInserting) {
      context.missing(_memorizationMethodMeta);
    }
    if (data.containsKey('memorization_data')) {
      context.handle(
          _memorizationDataMeta,
          memorizationData.isAcceptableOrUnknown(
              data['memorization_data']!, _memorizationDataMeta));
    } else if (isInserting) {
      context.missing(_memorizationDataMeta);
    }
    if (data.containsKey('revision_method')) {
      context.handle(
          _revisionMethodMeta,
          revisionMethod.isAcceptableOrUnknown(
              data['revision_method']!, _revisionMethodMeta));
    } else if (isInserting) {
      context.missing(_revisionMethodMeta);
    }
    if (data.containsKey('revision_data')) {
      context.handle(
          _revisionDataMeta,
          revisionData.isAcceptableOrUnknown(
              data['revision_data']!, _revisionDataMeta));
    } else if (isInserting) {
      context.missing(_revisionDataMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('encouragement_message')) {
      context.handle(
          _encouragementMessageMeta,
          encouragementMessage.isAcceptableOrUnknown(
              data['encouragement_message']!, _encouragementMessageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {studentId};
  @override
  TomorrowMemorizationTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TomorrowMemorizationTableData(
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id'])!,
      memorizationMethod: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}memorization_method'])!,
      memorizationData: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}memorization_data'])!,
      revisionMethod: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}revision_method'])!,
      revisionData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}revision_data'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      encouragementMessage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}encouragement_message']),
    );
  }

  @override
  $TomorrowMemorizationTableTable createAlias(String alias) {
    return $TomorrowMemorizationTableTable(attachedDatabase, alias);
  }
}

class TomorrowMemorizationTableData extends DataClass
    implements Insertable<TomorrowMemorizationTableData> {
  final String studentId;
  final String memorizationMethod;
  final String memorizationData;
  final String revisionMethod;
  final String revisionData;
  final String? notes;
  final String? encouragementMessage;
  const TomorrowMemorizationTableData(
      {required this.studentId,
      required this.memorizationMethod,
      required this.memorizationData,
      required this.revisionMethod,
      required this.revisionData,
      this.notes,
      this.encouragementMessage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['student_id'] = Variable<String>(studentId);
    map['memorization_method'] = Variable<String>(memorizationMethod);
    map['memorization_data'] = Variable<String>(memorizationData);
    map['revision_method'] = Variable<String>(revisionMethod);
    map['revision_data'] = Variable<String>(revisionData);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || encouragementMessage != null) {
      map['encouragement_message'] = Variable<String>(encouragementMessage);
    }
    return map;
  }

  TomorrowMemorizationTableCompanion toCompanion(bool nullToAbsent) {
    return TomorrowMemorizationTableCompanion(
      studentId: Value(studentId),
      memorizationMethod: Value(memorizationMethod),
      memorizationData: Value(memorizationData),
      revisionMethod: Value(revisionMethod),
      revisionData: Value(revisionData),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      encouragementMessage: encouragementMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(encouragementMessage),
    );
  }

  factory TomorrowMemorizationTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TomorrowMemorizationTableData(
      studentId: serializer.fromJson<String>(json['studentId']),
      memorizationMethod:
          serializer.fromJson<String>(json['memorizationMethod']),
      memorizationData: serializer.fromJson<String>(json['memorizationData']),
      revisionMethod: serializer.fromJson<String>(json['revisionMethod']),
      revisionData: serializer.fromJson<String>(json['revisionData']),
      notes: serializer.fromJson<String?>(json['notes']),
      encouragementMessage:
          serializer.fromJson<String?>(json['encouragementMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'studentId': serializer.toJson<String>(studentId),
      'memorizationMethod': serializer.toJson<String>(memorizationMethod),
      'memorizationData': serializer.toJson<String>(memorizationData),
      'revisionMethod': serializer.toJson<String>(revisionMethod),
      'revisionData': serializer.toJson<String>(revisionData),
      'notes': serializer.toJson<String?>(notes),
      'encouragementMessage': serializer.toJson<String?>(encouragementMessage),
    };
  }

  TomorrowMemorizationTableData copyWith(
          {String? studentId,
          String? memorizationMethod,
          String? memorizationData,
          String? revisionMethod,
          String? revisionData,
          Value<String?> notes = const Value.absent(),
          Value<String?> encouragementMessage = const Value.absent()}) =>
      TomorrowMemorizationTableData(
        studentId: studentId ?? this.studentId,
        memorizationMethod: memorizationMethod ?? this.memorizationMethod,
        memorizationData: memorizationData ?? this.memorizationData,
        revisionMethod: revisionMethod ?? this.revisionMethod,
        revisionData: revisionData ?? this.revisionData,
        notes: notes.present ? notes.value : this.notes,
        encouragementMessage: encouragementMessage.present
            ? encouragementMessage.value
            : this.encouragementMessage,
      );
  TomorrowMemorizationTableData copyWithCompanion(
      TomorrowMemorizationTableCompanion data) {
    return TomorrowMemorizationTableData(
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      memorizationMethod: data.memorizationMethod.present
          ? data.memorizationMethod.value
          : this.memorizationMethod,
      memorizationData: data.memorizationData.present
          ? data.memorizationData.value
          : this.memorizationData,
      revisionMethod: data.revisionMethod.present
          ? data.revisionMethod.value
          : this.revisionMethod,
      revisionData: data.revisionData.present
          ? data.revisionData.value
          : this.revisionData,
      notes: data.notes.present ? data.notes.value : this.notes,
      encouragementMessage: data.encouragementMessage.present
          ? data.encouragementMessage.value
          : this.encouragementMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TomorrowMemorizationTableData(')
          ..write('studentId: $studentId, ')
          ..write('memorizationMethod: $memorizationMethod, ')
          ..write('memorizationData: $memorizationData, ')
          ..write('revisionMethod: $revisionMethod, ')
          ..write('revisionData: $revisionData, ')
          ..write('notes: $notes, ')
          ..write('encouragementMessage: $encouragementMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      studentId,
      memorizationMethod,
      memorizationData,
      revisionMethod,
      revisionData,
      notes,
      encouragementMessage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TomorrowMemorizationTableData &&
          other.studentId == this.studentId &&
          other.memorizationMethod == this.memorizationMethod &&
          other.memorizationData == this.memorizationData &&
          other.revisionMethod == this.revisionMethod &&
          other.revisionData == this.revisionData &&
          other.notes == this.notes &&
          other.encouragementMessage == this.encouragementMessage);
}

class TomorrowMemorizationTableCompanion
    extends UpdateCompanion<TomorrowMemorizationTableData> {
  final Value<String> studentId;
  final Value<String> memorizationMethod;
  final Value<String> memorizationData;
  final Value<String> revisionMethod;
  final Value<String> revisionData;
  final Value<String?> notes;
  final Value<String?> encouragementMessage;
  final Value<int> rowid;
  const TomorrowMemorizationTableCompanion({
    this.studentId = const Value.absent(),
    this.memorizationMethod = const Value.absent(),
    this.memorizationData = const Value.absent(),
    this.revisionMethod = const Value.absent(),
    this.revisionData = const Value.absent(),
    this.notes = const Value.absent(),
    this.encouragementMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TomorrowMemorizationTableCompanion.insert({
    required String studentId,
    required String memorizationMethod,
    required String memorizationData,
    required String revisionMethod,
    required String revisionData,
    this.notes = const Value.absent(),
    this.encouragementMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : studentId = Value(studentId),
        memorizationMethod = Value(memorizationMethod),
        memorizationData = Value(memorizationData),
        revisionMethod = Value(revisionMethod),
        revisionData = Value(revisionData);
  static Insertable<TomorrowMemorizationTableData> custom({
    Expression<String>? studentId,
    Expression<String>? memorizationMethod,
    Expression<String>? memorizationData,
    Expression<String>? revisionMethod,
    Expression<String>? revisionData,
    Expression<String>? notes,
    Expression<String>? encouragementMessage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (studentId != null) 'student_id': studentId,
      if (memorizationMethod != null) 'memorization_method': memorizationMethod,
      if (memorizationData != null) 'memorization_data': memorizationData,
      if (revisionMethod != null) 'revision_method': revisionMethod,
      if (revisionData != null) 'revision_data': revisionData,
      if (notes != null) 'notes': notes,
      if (encouragementMessage != null)
        'encouragement_message': encouragementMessage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TomorrowMemorizationTableCompanion copyWith(
      {Value<String>? studentId,
      Value<String>? memorizationMethod,
      Value<String>? memorizationData,
      Value<String>? revisionMethod,
      Value<String>? revisionData,
      Value<String?>? notes,
      Value<String?>? encouragementMessage,
      Value<int>? rowid}) {
    return TomorrowMemorizationTableCompanion(
      studentId: studentId ?? this.studentId,
      memorizationMethod: memorizationMethod ?? this.memorizationMethod,
      memorizationData: memorizationData ?? this.memorizationData,
      revisionMethod: revisionMethod ?? this.revisionMethod,
      revisionData: revisionData ?? this.revisionData,
      notes: notes ?? this.notes,
      encouragementMessage: encouragementMessage ?? this.encouragementMessage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (memorizationMethod.present) {
      map['memorization_method'] = Variable<String>(memorizationMethod.value);
    }
    if (memorizationData.present) {
      map['memorization_data'] = Variable<String>(memorizationData.value);
    }
    if (revisionMethod.present) {
      map['revision_method'] = Variable<String>(revisionMethod.value);
    }
    if (revisionData.present) {
      map['revision_data'] = Variable<String>(revisionData.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (encouragementMessage.present) {
      map['encouragement_message'] =
          Variable<String>(encouragementMessage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TomorrowMemorizationTableCompanion(')
          ..write('studentId: $studentId, ')
          ..write('memorizationMethod: $memorizationMethod, ')
          ..write('memorizationData: $memorizationData, ')
          ..write('revisionMethod: $revisionMethod, ')
          ..write('revisionData: $revisionData, ')
          ..write('notes: $notes, ')
          ..write('encouragementMessage: $encouragementMessage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlansTableTable extends PlansTable
    with TableInfo<$PlansTableTable, PlansTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlansTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
      'student_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _attendanceDaysPerWeekMeta =
      const VerificationMeta('attendanceDaysPerWeek');
  @override
  late final GeneratedColumn<int> attendanceDaysPerWeek = GeneratedColumn<int>(
      'attendance_days_per_week', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _dailyLinesCountMeta =
      const VerificationMeta('dailyLinesCount');
  @override
  late final GeneratedColumn<int> dailyLinesCount = GeneratedColumn<int>(
      'daily_lines_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(15));
  static const VerificationMeta _directionMeta =
      const VerificationMeta('direction');
  @override
  late final GeneratedColumn<int> direction = GeneratedColumn<int>(
      'direction', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _startSurahMeta =
      const VerificationMeta('startSurah');
  @override
  late final GeneratedColumn<int> startSurah = GeneratedColumn<int>(
      'start_surah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _startVerseMeta =
      const VerificationMeta('startVerse');
  @override
  late final GeneratedColumn<int> startVerse = GeneratedColumn<int>(
      'start_verse', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endSurahMeta =
      const VerificationMeta('endSurah');
  @override
  late final GeneratedColumn<int> endSurah = GeneratedColumn<int>(
      'end_surah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endVerseMeta =
      const VerificationMeta('endVerse');
  @override
  late final GeneratedColumn<int> endVerse = GeneratedColumn<int>(
      'end_verse', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        studentId,
        attendanceDaysPerWeek,
        dailyLinesCount,
        direction,
        startSurah,
        startVerse,
        endSurah,
        endVerse,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plans_table';
  @override
  VerificationContext validateIntegrity(Insertable<PlansTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('attendance_days_per_week')) {
      context.handle(
          _attendanceDaysPerWeekMeta,
          attendanceDaysPerWeek.isAcceptableOrUnknown(
              data['attendance_days_per_week']!, _attendanceDaysPerWeekMeta));
    }
    if (data.containsKey('daily_lines_count')) {
      context.handle(
          _dailyLinesCountMeta,
          dailyLinesCount.isAcceptableOrUnknown(
              data['daily_lines_count']!, _dailyLinesCountMeta));
    }
    if (data.containsKey('direction')) {
      context.handle(_directionMeta,
          direction.isAcceptableOrUnknown(data['direction']!, _directionMeta));
    }
    if (data.containsKey('start_surah')) {
      context.handle(
          _startSurahMeta,
          startSurah.isAcceptableOrUnknown(
              data['start_surah']!, _startSurahMeta));
    } else if (isInserting) {
      context.missing(_startSurahMeta);
    }
    if (data.containsKey('start_verse')) {
      context.handle(
          _startVerseMeta,
          startVerse.isAcceptableOrUnknown(
              data['start_verse']!, _startVerseMeta));
    } else if (isInserting) {
      context.missing(_startVerseMeta);
    }
    if (data.containsKey('end_surah')) {
      context.handle(_endSurahMeta,
          endSurah.isAcceptableOrUnknown(data['end_surah']!, _endSurahMeta));
    } else if (isInserting) {
      context.missing(_endSurahMeta);
    }
    if (data.containsKey('end_verse')) {
      context.handle(_endVerseMeta,
          endVerse.isAcceptableOrUnknown(data['end_verse']!, _endVerseMeta));
    } else if (isInserting) {
      context.missing(_endVerseMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {studentId};
  @override
  PlansTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlansTableData(
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id'])!,
      attendanceDaysPerWeek: attachedDatabase.typeMapping.read(DriftSqlType.int,
          data['${effectivePrefix}attendance_days_per_week'])!,
      dailyLinesCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}daily_lines_count'])!,
      direction: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}direction'])!,
      startSurah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_surah'])!,
      startVerse: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_verse'])!,
      endSurah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_surah'])!,
      endVerse: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_verse'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $PlansTableTable createAlias(String alias) {
    return $PlansTableTable(attachedDatabase, alias);
  }
}

class PlansTableData extends DataClass implements Insertable<PlansTableData> {
  final String studentId;
  final int attendanceDaysPerWeek;
  final int dailyLinesCount;
  final int direction;
  final int startSurah;
  final int startVerse;
  final int endSurah;
  final int endVerse;
  final String? notes;
  const PlansTableData(
      {required this.studentId,
      required this.attendanceDaysPerWeek,
      required this.dailyLinesCount,
      required this.direction,
      required this.startSurah,
      required this.startVerse,
      required this.endSurah,
      required this.endVerse,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['student_id'] = Variable<String>(studentId);
    map['attendance_days_per_week'] = Variable<int>(attendanceDaysPerWeek);
    map['daily_lines_count'] = Variable<int>(dailyLinesCount);
    map['direction'] = Variable<int>(direction);
    map['start_surah'] = Variable<int>(startSurah);
    map['start_verse'] = Variable<int>(startVerse);
    map['end_surah'] = Variable<int>(endSurah);
    map['end_verse'] = Variable<int>(endVerse);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PlansTableCompanion toCompanion(bool nullToAbsent) {
    return PlansTableCompanion(
      studentId: Value(studentId),
      attendanceDaysPerWeek: Value(attendanceDaysPerWeek),
      dailyLinesCount: Value(dailyLinesCount),
      direction: Value(direction),
      startSurah: Value(startSurah),
      startVerse: Value(startVerse),
      endSurah: Value(endSurah),
      endVerse: Value(endVerse),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory PlansTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlansTableData(
      studentId: serializer.fromJson<String>(json['studentId']),
      attendanceDaysPerWeek:
          serializer.fromJson<int>(json['attendanceDaysPerWeek']),
      dailyLinesCount: serializer.fromJson<int>(json['dailyLinesCount']),
      direction: serializer.fromJson<int>(json['direction']),
      startSurah: serializer.fromJson<int>(json['startSurah']),
      startVerse: serializer.fromJson<int>(json['startVerse']),
      endSurah: serializer.fromJson<int>(json['endSurah']),
      endVerse: serializer.fromJson<int>(json['endVerse']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'studentId': serializer.toJson<String>(studentId),
      'attendanceDaysPerWeek': serializer.toJson<int>(attendanceDaysPerWeek),
      'dailyLinesCount': serializer.toJson<int>(dailyLinesCount),
      'direction': serializer.toJson<int>(direction),
      'startSurah': serializer.toJson<int>(startSurah),
      'startVerse': serializer.toJson<int>(startVerse),
      'endSurah': serializer.toJson<int>(endSurah),
      'endVerse': serializer.toJson<int>(endVerse),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  PlansTableData copyWith(
          {String? studentId,
          int? attendanceDaysPerWeek,
          int? dailyLinesCount,
          int? direction,
          int? startSurah,
          int? startVerse,
          int? endSurah,
          int? endVerse,
          Value<String?> notes = const Value.absent()}) =>
      PlansTableData(
        studentId: studentId ?? this.studentId,
        attendanceDaysPerWeek:
            attendanceDaysPerWeek ?? this.attendanceDaysPerWeek,
        dailyLinesCount: dailyLinesCount ?? this.dailyLinesCount,
        direction: direction ?? this.direction,
        startSurah: startSurah ?? this.startSurah,
        startVerse: startVerse ?? this.startVerse,
        endSurah: endSurah ?? this.endSurah,
        endVerse: endVerse ?? this.endVerse,
        notes: notes.present ? notes.value : this.notes,
      );
  PlansTableData copyWithCompanion(PlansTableCompanion data) {
    return PlansTableData(
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      attendanceDaysPerWeek: data.attendanceDaysPerWeek.present
          ? data.attendanceDaysPerWeek.value
          : this.attendanceDaysPerWeek,
      dailyLinesCount: data.dailyLinesCount.present
          ? data.dailyLinesCount.value
          : this.dailyLinesCount,
      direction: data.direction.present ? data.direction.value : this.direction,
      startSurah:
          data.startSurah.present ? data.startSurah.value : this.startSurah,
      startVerse:
          data.startVerse.present ? data.startVerse.value : this.startVerse,
      endSurah: data.endSurah.present ? data.endSurah.value : this.endSurah,
      endVerse: data.endVerse.present ? data.endVerse.value : this.endVerse,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlansTableData(')
          ..write('studentId: $studentId, ')
          ..write('attendanceDaysPerWeek: $attendanceDaysPerWeek, ')
          ..write('dailyLinesCount: $dailyLinesCount, ')
          ..write('direction: $direction, ')
          ..write('startSurah: $startSurah, ')
          ..write('startVerse: $startVerse, ')
          ..write('endSurah: $endSurah, ')
          ..write('endVerse: $endVerse, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      studentId,
      attendanceDaysPerWeek,
      dailyLinesCount,
      direction,
      startSurah,
      startVerse,
      endSurah,
      endVerse,
      notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlansTableData &&
          other.studentId == this.studentId &&
          other.attendanceDaysPerWeek == this.attendanceDaysPerWeek &&
          other.dailyLinesCount == this.dailyLinesCount &&
          other.direction == this.direction &&
          other.startSurah == this.startSurah &&
          other.startVerse == this.startVerse &&
          other.endSurah == this.endSurah &&
          other.endVerse == this.endVerse &&
          other.notes == this.notes);
}

class PlansTableCompanion extends UpdateCompanion<PlansTableData> {
  final Value<String> studentId;
  final Value<int> attendanceDaysPerWeek;
  final Value<int> dailyLinesCount;
  final Value<int> direction;
  final Value<int> startSurah;
  final Value<int> startVerse;
  final Value<int> endSurah;
  final Value<int> endVerse;
  final Value<String?> notes;
  final Value<int> rowid;
  const PlansTableCompanion({
    this.studentId = const Value.absent(),
    this.attendanceDaysPerWeek = const Value.absent(),
    this.dailyLinesCount = const Value.absent(),
    this.direction = const Value.absent(),
    this.startSurah = const Value.absent(),
    this.startVerse = const Value.absent(),
    this.endSurah = const Value.absent(),
    this.endVerse = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlansTableCompanion.insert({
    required String studentId,
    this.attendanceDaysPerWeek = const Value.absent(),
    this.dailyLinesCount = const Value.absent(),
    this.direction = const Value.absent(),
    required int startSurah,
    required int startVerse,
    required int endSurah,
    required int endVerse,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : studentId = Value(studentId),
        startSurah = Value(startSurah),
        startVerse = Value(startVerse),
        endSurah = Value(endSurah),
        endVerse = Value(endVerse);
  static Insertable<PlansTableData> custom({
    Expression<String>? studentId,
    Expression<int>? attendanceDaysPerWeek,
    Expression<int>? dailyLinesCount,
    Expression<int>? direction,
    Expression<int>? startSurah,
    Expression<int>? startVerse,
    Expression<int>? endSurah,
    Expression<int>? endVerse,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (studentId != null) 'student_id': studentId,
      if (attendanceDaysPerWeek != null)
        'attendance_days_per_week': attendanceDaysPerWeek,
      if (dailyLinesCount != null) 'daily_lines_count': dailyLinesCount,
      if (direction != null) 'direction': direction,
      if (startSurah != null) 'start_surah': startSurah,
      if (startVerse != null) 'start_verse': startVerse,
      if (endSurah != null) 'end_surah': endSurah,
      if (endVerse != null) 'end_verse': endVerse,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlansTableCompanion copyWith(
      {Value<String>? studentId,
      Value<int>? attendanceDaysPerWeek,
      Value<int>? dailyLinesCount,
      Value<int>? direction,
      Value<int>? startSurah,
      Value<int>? startVerse,
      Value<int>? endSurah,
      Value<int>? endVerse,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return PlansTableCompanion(
      studentId: studentId ?? this.studentId,
      attendanceDaysPerWeek:
          attendanceDaysPerWeek ?? this.attendanceDaysPerWeek,
      dailyLinesCount: dailyLinesCount ?? this.dailyLinesCount,
      direction: direction ?? this.direction,
      startSurah: startSurah ?? this.startSurah,
      startVerse: startVerse ?? this.startVerse,
      endSurah: endSurah ?? this.endSurah,
      endVerse: endVerse ?? this.endVerse,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (attendanceDaysPerWeek.present) {
      map['attendance_days_per_week'] =
          Variable<int>(attendanceDaysPerWeek.value);
    }
    if (dailyLinesCount.present) {
      map['daily_lines_count'] = Variable<int>(dailyLinesCount.value);
    }
    if (direction.present) {
      map['direction'] = Variable<int>(direction.value);
    }
    if (startSurah.present) {
      map['start_surah'] = Variable<int>(startSurah.value);
    }
    if (startVerse.present) {
      map['start_verse'] = Variable<int>(startVerse.value);
    }
    if (endSurah.present) {
      map['end_surah'] = Variable<int>(endSurah.value);
    }
    if (endVerse.present) {
      map['end_verse'] = Variable<int>(endVerse.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlansTableCompanion(')
          ..write('studentId: $studentId, ')
          ..write('attendanceDaysPerWeek: $attendanceDaysPerWeek, ')
          ..write('dailyLinesCount: $dailyLinesCount, ')
          ..write('direction: $direction, ')
          ..write('startSurah: $startSurah, ')
          ..write('startVerse: $startVerse, ')
          ..write('endSurah: $endSurah, ')
          ..write('endVerse: $endVerse, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SchedulesTableTable extends SchedulesTable
    with TableInfo<$SchedulesTableTable, SchedulesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchedulesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
      'student_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonsJsonMeta =
      const VerificationMeta('lessonsJson');
  @override
  late final GeneratedColumn<String> lessonsJson = GeneratedColumn<String>(
      'lessons_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
      'last_modified', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _modificationHistoryJsonMeta =
      const VerificationMeta('modificationHistoryJson');
  @override
  late final GeneratedColumn<String> modificationHistoryJson =
      GeneratedColumn<String>('modification_history_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [studentId, lessonsJson, lastModified, modificationHistoryJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedules_table';
  @override
  VerificationContext validateIntegrity(Insertable<SchedulesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('lessons_json')) {
      context.handle(
          _lessonsJsonMeta,
          lessonsJson.isAcceptableOrUnknown(
              data['lessons_json']!, _lessonsJsonMeta));
    } else if (isInserting) {
      context.missing(_lessonsJsonMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    if (data.containsKey('modification_history_json')) {
      context.handle(
          _modificationHistoryJsonMeta,
          modificationHistoryJson.isAcceptableOrUnknown(
              data['modification_history_json']!,
              _modificationHistoryJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {studentId};
  @override
  SchedulesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchedulesTableData(
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id'])!,
      lessonsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lessons_json'])!,
      lastModified: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_modified'])!,
      modificationHistoryJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}modification_history_json']),
    );
  }

  @override
  $SchedulesTableTable createAlias(String alias) {
    return $SchedulesTableTable(attachedDatabase, alias);
  }
}

class SchedulesTableData extends DataClass
    implements Insertable<SchedulesTableData> {
  final String studentId;
  final String lessonsJson;
  final DateTime lastModified;
  final String? modificationHistoryJson;
  const SchedulesTableData(
      {required this.studentId,
      required this.lessonsJson,
      required this.lastModified,
      this.modificationHistoryJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['student_id'] = Variable<String>(studentId);
    map['lessons_json'] = Variable<String>(lessonsJson);
    map['last_modified'] = Variable<DateTime>(lastModified);
    if (!nullToAbsent || modificationHistoryJson != null) {
      map['modification_history_json'] =
          Variable<String>(modificationHistoryJson);
    }
    return map;
  }

  SchedulesTableCompanion toCompanion(bool nullToAbsent) {
    return SchedulesTableCompanion(
      studentId: Value(studentId),
      lessonsJson: Value(lessonsJson),
      lastModified: Value(lastModified),
      modificationHistoryJson: modificationHistoryJson == null && nullToAbsent
          ? const Value.absent()
          : Value(modificationHistoryJson),
    );
  }

  factory SchedulesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchedulesTableData(
      studentId: serializer.fromJson<String>(json['studentId']),
      lessonsJson: serializer.fromJson<String>(json['lessonsJson']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
      modificationHistoryJson:
          serializer.fromJson<String?>(json['modificationHistoryJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'studentId': serializer.toJson<String>(studentId),
      'lessonsJson': serializer.toJson<String>(lessonsJson),
      'lastModified': serializer.toJson<DateTime>(lastModified),
      'modificationHistoryJson':
          serializer.toJson<String?>(modificationHistoryJson),
    };
  }

  SchedulesTableData copyWith(
          {String? studentId,
          String? lessonsJson,
          DateTime? lastModified,
          Value<String?> modificationHistoryJson = const Value.absent()}) =>
      SchedulesTableData(
        studentId: studentId ?? this.studentId,
        lessonsJson: lessonsJson ?? this.lessonsJson,
        lastModified: lastModified ?? this.lastModified,
        modificationHistoryJson: modificationHistoryJson.present
            ? modificationHistoryJson.value
            : this.modificationHistoryJson,
      );
  SchedulesTableData copyWithCompanion(SchedulesTableCompanion data) {
    return SchedulesTableData(
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      lessonsJson:
          data.lessonsJson.present ? data.lessonsJson.value : this.lessonsJson,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      modificationHistoryJson: data.modificationHistoryJson.present
          ? data.modificationHistoryJson.value
          : this.modificationHistoryJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchedulesTableData(')
          ..write('studentId: $studentId, ')
          ..write('lessonsJson: $lessonsJson, ')
          ..write('lastModified: $lastModified, ')
          ..write('modificationHistoryJson: $modificationHistoryJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      studentId, lessonsJson, lastModified, modificationHistoryJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchedulesTableData &&
          other.studentId == this.studentId &&
          other.lessonsJson == this.lessonsJson &&
          other.lastModified == this.lastModified &&
          other.modificationHistoryJson == this.modificationHistoryJson);
}

class SchedulesTableCompanion extends UpdateCompanion<SchedulesTableData> {
  final Value<String> studentId;
  final Value<String> lessonsJson;
  final Value<DateTime> lastModified;
  final Value<String?> modificationHistoryJson;
  final Value<int> rowid;
  const SchedulesTableCompanion({
    this.studentId = const Value.absent(),
    this.lessonsJson = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.modificationHistoryJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchedulesTableCompanion.insert({
    required String studentId,
    required String lessonsJson,
    required DateTime lastModified,
    this.modificationHistoryJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : studentId = Value(studentId),
        lessonsJson = Value(lessonsJson),
        lastModified = Value(lastModified);
  static Insertable<SchedulesTableData> custom({
    Expression<String>? studentId,
    Expression<String>? lessonsJson,
    Expression<DateTime>? lastModified,
    Expression<String>? modificationHistoryJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (studentId != null) 'student_id': studentId,
      if (lessonsJson != null) 'lessons_json': lessonsJson,
      if (lastModified != null) 'last_modified': lastModified,
      if (modificationHistoryJson != null)
        'modification_history_json': modificationHistoryJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchedulesTableCompanion copyWith(
      {Value<String>? studentId,
      Value<String>? lessonsJson,
      Value<DateTime>? lastModified,
      Value<String?>? modificationHistoryJson,
      Value<int>? rowid}) {
    return SchedulesTableCompanion(
      studentId: studentId ?? this.studentId,
      lessonsJson: lessonsJson ?? this.lessonsJson,
      lastModified: lastModified ?? this.lastModified,
      modificationHistoryJson:
          modificationHistoryJson ?? this.modificationHistoryJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (lessonsJson.present) {
      map['lessons_json'] = Variable<String>(lessonsJson.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (modificationHistoryJson.present) {
      map['modification_history_json'] =
          Variable<String>(modificationHistoryJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchedulesTableCompanion(')
          ..write('studentId: $studentId, ')
          ..write('lessonsJson: $lessonsJson, ')
          ..write('lastModified: $lastModified, ')
          ..write('modificationHistoryJson: $modificationHistoryJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizzesTableTable extends QuizzesTable
    with TableInfo<$QuizzesTableTable, QuizzesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizzesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _teacherIdMeta =
      const VerificationMeta('teacherId');
  @override
  late final GeneratedColumn<String> teacherId = GeneratedColumn<String>(
      'teacher_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _questionsJsonMeta =
      const VerificationMeta('questionsJson');
  @override
  late final GeneratedColumn<String> questionsJson = GeneratedColumn<String>(
      'questions_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, teacherId, title, description, questionsJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quizzes_table';
  @override
  VerificationContext validateIntegrity(Insertable<QuizzesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('teacher_id')) {
      context.handle(_teacherIdMeta,
          teacherId.isAcceptableOrUnknown(data['teacher_id']!, _teacherIdMeta));
    } else if (isInserting) {
      context.missing(_teacherIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('questions_json')) {
      context.handle(
          _questionsJsonMeta,
          questionsJson.isAcceptableOrUnknown(
              data['questions_json']!, _questionsJsonMeta));
    } else if (isInserting) {
      context.missing(_questionsJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizzesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizzesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      teacherId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}teacher_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      questionsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}questions_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $QuizzesTableTable createAlias(String alias) {
    return $QuizzesTableTable(attachedDatabase, alias);
  }
}

class QuizzesTableData extends DataClass
    implements Insertable<QuizzesTableData> {
  final String id;
  final String teacherId;
  final String title;
  final String? description;
  final String questionsJson;
  final DateTime createdAt;
  const QuizzesTableData(
      {required this.id,
      required this.teacherId,
      required this.title,
      this.description,
      required this.questionsJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['teacher_id'] = Variable<String>(teacherId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['questions_json'] = Variable<String>(questionsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  QuizzesTableCompanion toCompanion(bool nullToAbsent) {
    return QuizzesTableCompanion(
      id: Value(id),
      teacherId: Value(teacherId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      questionsJson: Value(questionsJson),
      createdAt: Value(createdAt),
    );
  }

  factory QuizzesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizzesTableData(
      id: serializer.fromJson<String>(json['id']),
      teacherId: serializer.fromJson<String>(json['teacherId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      questionsJson: serializer.fromJson<String>(json['questionsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'teacherId': serializer.toJson<String>(teacherId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'questionsJson': serializer.toJson<String>(questionsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  QuizzesTableData copyWith(
          {String? id,
          String? teacherId,
          String? title,
          Value<String?> description = const Value.absent(),
          String? questionsJson,
          DateTime? createdAt}) =>
      QuizzesTableData(
        id: id ?? this.id,
        teacherId: teacherId ?? this.teacherId,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        questionsJson: questionsJson ?? this.questionsJson,
        createdAt: createdAt ?? this.createdAt,
      );
  QuizzesTableData copyWithCompanion(QuizzesTableCompanion data) {
    return QuizzesTableData(
      id: data.id.present ? data.id.value : this.id,
      teacherId: data.teacherId.present ? data.teacherId.value : this.teacherId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      questionsJson: data.questionsJson.present
          ? data.questionsJson.value
          : this.questionsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizzesTableData(')
          ..write('id: $id, ')
          ..write('teacherId: $teacherId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('questionsJson: $questionsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, teacherId, title, description, questionsJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizzesTableData &&
          other.id == this.id &&
          other.teacherId == this.teacherId &&
          other.title == this.title &&
          other.description == this.description &&
          other.questionsJson == this.questionsJson &&
          other.createdAt == this.createdAt);
}

class QuizzesTableCompanion extends UpdateCompanion<QuizzesTableData> {
  final Value<String> id;
  final Value<String> teacherId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> questionsJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const QuizzesTableCompanion({
    this.id = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.questionsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizzesTableCompanion.insert({
    required String id,
    required String teacherId,
    required String title,
    this.description = const Value.absent(),
    required String questionsJson,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        teacherId = Value(teacherId),
        title = Value(title),
        questionsJson = Value(questionsJson),
        createdAt = Value(createdAt);
  static Insertable<QuizzesTableData> custom({
    Expression<String>? id,
    Expression<String>? teacherId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? questionsJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (teacherId != null) 'teacher_id': teacherId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (questionsJson != null) 'questions_json': questionsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizzesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? teacherId,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? questionsJson,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return QuizzesTableCompanion(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      title: title ?? this.title,
      description: description ?? this.description,
      questionsJson: questionsJson ?? this.questionsJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (teacherId.present) {
      map['teacher_id'] = Variable<String>(teacherId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (questionsJson.present) {
      map['questions_json'] = Variable<String>(questionsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizzesTableCompanion(')
          ..write('id: $id, ')
          ..write('teacherId: $teacherId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('questionsJson: $questionsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizAnswersTableTable extends QuizAnswersTable
    with TableInfo<$QuizAnswersTableTable, QuizAnswersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizAnswersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quizIdMeta = const VerificationMeta('quizId');
  @override
  late final GeneratedColumn<String> quizId = GeneratedColumn<String>(
      'quiz_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
      'student_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _answersJsonMeta =
      const VerificationMeta('answersJson');
  @override
  late final GeneratedColumn<String> answersJson = GeneratedColumn<String>(
      'answers_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, quizId, studentId, score, answersJson, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_answers_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<QuizAnswersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('quiz_id')) {
      context.handle(_quizIdMeta,
          quizId.isAcceptableOrUnknown(data['quiz_id']!, _quizIdMeta));
    } else if (isInserting) {
      context.missing(_quizIdMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('answers_json')) {
      context.handle(
          _answersJsonMeta,
          answersJson.isAcceptableOrUnknown(
              data['answers_json']!, _answersJsonMeta));
    } else if (isInserting) {
      context.missing(_answersJsonMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizAnswersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizAnswersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      quizId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quiz_id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      answersJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answers_json'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at'])!,
    );
  }

  @override
  $QuizAnswersTableTable createAlias(String alias) {
    return $QuizAnswersTableTable(attachedDatabase, alias);
  }
}

class QuizAnswersTableData extends DataClass
    implements Insertable<QuizAnswersTableData> {
  final String id;
  final String quizId;
  final String studentId;
  final int score;
  final String answersJson;
  final DateTime completedAt;
  const QuizAnswersTableData(
      {required this.id,
      required this.quizId,
      required this.studentId,
      required this.score,
      required this.answersJson,
      required this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quiz_id'] = Variable<String>(quizId);
    map['student_id'] = Variable<String>(studentId);
    map['score'] = Variable<int>(score);
    map['answers_json'] = Variable<String>(answersJson);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  QuizAnswersTableCompanion toCompanion(bool nullToAbsent) {
    return QuizAnswersTableCompanion(
      id: Value(id),
      quizId: Value(quizId),
      studentId: Value(studentId),
      score: Value(score),
      answersJson: Value(answersJson),
      completedAt: Value(completedAt),
    );
  }

  factory QuizAnswersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizAnswersTableData(
      id: serializer.fromJson<String>(json['id']),
      quizId: serializer.fromJson<String>(json['quizId']),
      studentId: serializer.fromJson<String>(json['studentId']),
      score: serializer.fromJson<int>(json['score']),
      answersJson: serializer.fromJson<String>(json['answersJson']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'quizId': serializer.toJson<String>(quizId),
      'studentId': serializer.toJson<String>(studentId),
      'score': serializer.toJson<int>(score),
      'answersJson': serializer.toJson<String>(answersJson),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  QuizAnswersTableData copyWith(
          {String? id,
          String? quizId,
          String? studentId,
          int? score,
          String? answersJson,
          DateTime? completedAt}) =>
      QuizAnswersTableData(
        id: id ?? this.id,
        quizId: quizId ?? this.quizId,
        studentId: studentId ?? this.studentId,
        score: score ?? this.score,
        answersJson: answersJson ?? this.answersJson,
        completedAt: completedAt ?? this.completedAt,
      );
  QuizAnswersTableData copyWithCompanion(QuizAnswersTableCompanion data) {
    return QuizAnswersTableData(
      id: data.id.present ? data.id.value : this.id,
      quizId: data.quizId.present ? data.quizId.value : this.quizId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      score: data.score.present ? data.score.value : this.score,
      answersJson:
          data.answersJson.present ? data.answersJson.value : this.answersJson,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizAnswersTableData(')
          ..write('id: $id, ')
          ..write('quizId: $quizId, ')
          ..write('studentId: $studentId, ')
          ..write('score: $score, ')
          ..write('answersJson: $answersJson, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, quizId, studentId, score, answersJson, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizAnswersTableData &&
          other.id == this.id &&
          other.quizId == this.quizId &&
          other.studentId == this.studentId &&
          other.score == this.score &&
          other.answersJson == this.answersJson &&
          other.completedAt == this.completedAt);
}

class QuizAnswersTableCompanion extends UpdateCompanion<QuizAnswersTableData> {
  final Value<String> id;
  final Value<String> quizId;
  final Value<String> studentId;
  final Value<int> score;
  final Value<String> answersJson;
  final Value<DateTime> completedAt;
  final Value<int> rowid;
  const QuizAnswersTableCompanion({
    this.id = const Value.absent(),
    this.quizId = const Value.absent(),
    this.studentId = const Value.absent(),
    this.score = const Value.absent(),
    this.answersJson = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizAnswersTableCompanion.insert({
    required String id,
    required String quizId,
    required String studentId,
    required int score,
    required String answersJson,
    required DateTime completedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        quizId = Value(quizId),
        studentId = Value(studentId),
        score = Value(score),
        answersJson = Value(answersJson),
        completedAt = Value(completedAt);
  static Insertable<QuizAnswersTableData> custom({
    Expression<String>? id,
    Expression<String>? quizId,
    Expression<String>? studentId,
    Expression<int>? score,
    Expression<String>? answersJson,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quizId != null) 'quiz_id': quizId,
      if (studentId != null) 'student_id': studentId,
      if (score != null) 'score': score,
      if (answersJson != null) 'answers_json': answersJson,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizAnswersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? quizId,
      Value<String>? studentId,
      Value<int>? score,
      Value<String>? answersJson,
      Value<DateTime>? completedAt,
      Value<int>? rowid}) {
    return QuizAnswersTableCompanion(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      studentId: studentId ?? this.studentId,
      score: score ?? this.score,
      answersJson: answersJson ?? this.answersJson,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (quizId.present) {
      map['quiz_id'] = Variable<String>(quizId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (answersJson.present) {
      map['answers_json'] = Variable<String>(answersJson.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizAnswersTableCompanion(')
          ..write('id: $id, ')
          ..write('quizId: $quizId, ')
          ..write('studentId: $studentId, ')
          ..write('score: $score, ')
          ..write('answersJson: $answersJson, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTableTable extends PaymentsTable
    with TableInfo<$PaymentsTableTable, PaymentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
      'student_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
      'month', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
      'is_paid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_paid" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _paymentDateMeta =
      const VerificationMeta('paymentDate');
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
      'payment_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, studentId, amount, month, isPaid, paymentDate, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments_table';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('is_paid')) {
      context.handle(_isPaidMeta,
          isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta));
    }
    if (data.containsKey('payment_date')) {
      context.handle(
          _paymentDateMeta,
          paymentDate.isAcceptableOrUnknown(
              data['payment_date']!, _paymentDateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}month'])!,
      isPaid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_paid'])!,
      paymentDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}payment_date']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $PaymentsTableTable createAlias(String alias) {
    return $PaymentsTableTable(attachedDatabase, alias);
  }
}

class PaymentsTableData extends DataClass
    implements Insertable<PaymentsTableData> {
  final String id;
  final String studentId;
  final double amount;
  final String month;
  final bool isPaid;
  final DateTime? paymentDate;
  final String? notes;
  const PaymentsTableData(
      {required this.id,
      required this.studentId,
      required this.amount,
      required this.month,
      required this.isPaid,
      this.paymentDate,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['amount'] = Variable<double>(amount);
    map['month'] = Variable<String>(month);
    map['is_paid'] = Variable<bool>(isPaid);
    if (!nullToAbsent || paymentDate != null) {
      map['payment_date'] = Variable<DateTime>(paymentDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PaymentsTableCompanion toCompanion(bool nullToAbsent) {
    return PaymentsTableCompanion(
      id: Value(id),
      studentId: Value(studentId),
      amount: Value(amount),
      month: Value(month),
      isPaid: Value(isPaid),
      paymentDate: paymentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory PaymentsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentsTableData(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      amount: serializer.fromJson<double>(json['amount']),
      month: serializer.fromJson<String>(json['month']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      paymentDate: serializer.fromJson<DateTime?>(json['paymentDate']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'amount': serializer.toJson<double>(amount),
      'month': serializer.toJson<String>(month),
      'isPaid': serializer.toJson<bool>(isPaid),
      'paymentDate': serializer.toJson<DateTime?>(paymentDate),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  PaymentsTableData copyWith(
          {String? id,
          String? studentId,
          double? amount,
          String? month,
          bool? isPaid,
          Value<DateTime?> paymentDate = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      PaymentsTableData(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        amount: amount ?? this.amount,
        month: month ?? this.month,
        isPaid: isPaid ?? this.isPaid,
        paymentDate: paymentDate.present ? paymentDate.value : this.paymentDate,
        notes: notes.present ? notes.value : this.notes,
      );
  PaymentsTableData copyWithCompanion(PaymentsTableCompanion data) {
    return PaymentsTableData(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      amount: data.amount.present ? data.amount.value : this.amount,
      month: data.month.present ? data.month.value : this.month,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      paymentDate:
          data.paymentDate.present ? data.paymentDate.value : this.paymentDate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsTableData(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('amount: $amount, ')
          ..write('month: $month, ')
          ..write('isPaid: $isPaid, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, studentId, amount, month, isPaid, paymentDate, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentsTableData &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.amount == this.amount &&
          other.month == this.month &&
          other.isPaid == this.isPaid &&
          other.paymentDate == this.paymentDate &&
          other.notes == this.notes);
}

class PaymentsTableCompanion extends UpdateCompanion<PaymentsTableData> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<double> amount;
  final Value<String> month;
  final Value<bool> isPaid;
  final Value<DateTime?> paymentDate;
  final Value<String?> notes;
  final Value<int> rowid;
  const PaymentsTableCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.amount = const Value.absent(),
    this.month = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsTableCompanion.insert({
    required String id,
    required String studentId,
    required double amount,
    required String month,
    this.isPaid = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        studentId = Value(studentId),
        amount = Value(amount),
        month = Value(month);
  static Insertable<PaymentsTableData> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<double>? amount,
    Expression<String>? month,
    Expression<bool>? isPaid,
    Expression<DateTime>? paymentDate,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (amount != null) 'amount': amount,
      if (month != null) 'month': month,
      if (isPaid != null) 'is_paid': isPaid,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? studentId,
      Value<double>? amount,
      Value<String>? month,
      Value<bool>? isPaid,
      Value<DateTime?>? paymentDate,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return PaymentsTableCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      amount: amount ?? this.amount,
      month: month ?? this.month,
      isPaid: isPaid ?? this.isPaid,
      paymentDate: paymentDate ?? this.paymentDate,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsTableCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('amount: $amount, ')
          ..write('month: $month, ')
          ..write('isPaid: $isPaid, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HonorBoardTableTable extends HonorBoardTable
    with TableInfo<$HonorBoardTableTable, HonorBoardTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HonorBoardTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _teacherIdMeta =
      const VerificationMeta('teacherId');
  @override
  late final GeneratedColumn<String> teacherId = GeneratedColumn<String>(
      'teacher_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
      'student_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentNameMeta =
      const VerificationMeta('studentName');
  @override
  late final GeneratedColumn<String> studentName = GeneratedColumn<String>(
      'student_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _achievementMeta =
      const VerificationMeta('achievement');
  @override
  late final GeneratedColumn<String> achievement = GeneratedColumn<String>(
      'achievement', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _honorMessageMeta =
      const VerificationMeta('honorMessage');
  @override
  late final GeneratedColumn<String> honorMessage = GeneratedColumn<String>(
      'honor_message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weekDateMeta =
      const VerificationMeta('weekDate');
  @override
  late final GeneratedColumn<DateTime> weekDate = GeneratedColumn<DateTime>(
      'week_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        teacherId,
        studentId,
        studentName,
        achievement,
        honorMessage,
        weekDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'honor_board_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<HonorBoardTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('teacher_id')) {
      context.handle(_teacherIdMeta,
          teacherId.isAcceptableOrUnknown(data['teacher_id']!, _teacherIdMeta));
    } else if (isInserting) {
      context.missing(_teacherIdMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('student_name')) {
      context.handle(
          _studentNameMeta,
          studentName.isAcceptableOrUnknown(
              data['student_name']!, _studentNameMeta));
    } else if (isInserting) {
      context.missing(_studentNameMeta);
    }
    if (data.containsKey('achievement')) {
      context.handle(
          _achievementMeta,
          achievement.isAcceptableOrUnknown(
              data['achievement']!, _achievementMeta));
    } else if (isInserting) {
      context.missing(_achievementMeta);
    }
    if (data.containsKey('honor_message')) {
      context.handle(
          _honorMessageMeta,
          honorMessage.isAcceptableOrUnknown(
              data['honor_message']!, _honorMessageMeta));
    } else if (isInserting) {
      context.missing(_honorMessageMeta);
    }
    if (data.containsKey('week_date')) {
      context.handle(_weekDateMeta,
          weekDate.isAcceptableOrUnknown(data['week_date']!, _weekDateMeta));
    } else if (isInserting) {
      context.missing(_weekDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HonorBoardTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HonorBoardTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      teacherId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}teacher_id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id'])!,
      studentName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_name'])!,
      achievement: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}achievement'])!,
      honorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}honor_message'])!,
      weekDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}week_date'])!,
    );
  }

  @override
  $HonorBoardTableTable createAlias(String alias) {
    return $HonorBoardTableTable(attachedDatabase, alias);
  }
}

class HonorBoardTableData extends DataClass
    implements Insertable<HonorBoardTableData> {
  final String id;
  final String teacherId;
  final String studentId;
  final String studentName;
  final String achievement;
  final String honorMessage;
  final DateTime weekDate;
  const HonorBoardTableData(
      {required this.id,
      required this.teacherId,
      required this.studentId,
      required this.studentName,
      required this.achievement,
      required this.honorMessage,
      required this.weekDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['teacher_id'] = Variable<String>(teacherId);
    map['student_id'] = Variable<String>(studentId);
    map['student_name'] = Variable<String>(studentName);
    map['achievement'] = Variable<String>(achievement);
    map['honor_message'] = Variable<String>(honorMessage);
    map['week_date'] = Variable<DateTime>(weekDate);
    return map;
  }

  HonorBoardTableCompanion toCompanion(bool nullToAbsent) {
    return HonorBoardTableCompanion(
      id: Value(id),
      teacherId: Value(teacherId),
      studentId: Value(studentId),
      studentName: Value(studentName),
      achievement: Value(achievement),
      honorMessage: Value(honorMessage),
      weekDate: Value(weekDate),
    );
  }

  factory HonorBoardTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HonorBoardTableData(
      id: serializer.fromJson<String>(json['id']),
      teacherId: serializer.fromJson<String>(json['teacherId']),
      studentId: serializer.fromJson<String>(json['studentId']),
      studentName: serializer.fromJson<String>(json['studentName']),
      achievement: serializer.fromJson<String>(json['achievement']),
      honorMessage: serializer.fromJson<String>(json['honorMessage']),
      weekDate: serializer.fromJson<DateTime>(json['weekDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'teacherId': serializer.toJson<String>(teacherId),
      'studentId': serializer.toJson<String>(studentId),
      'studentName': serializer.toJson<String>(studentName),
      'achievement': serializer.toJson<String>(achievement),
      'honorMessage': serializer.toJson<String>(honorMessage),
      'weekDate': serializer.toJson<DateTime>(weekDate),
    };
  }

  HonorBoardTableData copyWith(
          {String? id,
          String? teacherId,
          String? studentId,
          String? studentName,
          String? achievement,
          String? honorMessage,
          DateTime? weekDate}) =>
      HonorBoardTableData(
        id: id ?? this.id,
        teacherId: teacherId ?? this.teacherId,
        studentId: studentId ?? this.studentId,
        studentName: studentName ?? this.studentName,
        achievement: achievement ?? this.achievement,
        honorMessage: honorMessage ?? this.honorMessage,
        weekDate: weekDate ?? this.weekDate,
      );
  HonorBoardTableData copyWithCompanion(HonorBoardTableCompanion data) {
    return HonorBoardTableData(
      id: data.id.present ? data.id.value : this.id,
      teacherId: data.teacherId.present ? data.teacherId.value : this.teacherId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      studentName:
          data.studentName.present ? data.studentName.value : this.studentName,
      achievement:
          data.achievement.present ? data.achievement.value : this.achievement,
      honorMessage: data.honorMessage.present
          ? data.honorMessage.value
          : this.honorMessage,
      weekDate: data.weekDate.present ? data.weekDate.value : this.weekDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HonorBoardTableData(')
          ..write('id: $id, ')
          ..write('teacherId: $teacherId, ')
          ..write('studentId: $studentId, ')
          ..write('studentName: $studentName, ')
          ..write('achievement: $achievement, ')
          ..write('honorMessage: $honorMessage, ')
          ..write('weekDate: $weekDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, teacherId, studentId, studentName,
      achievement, honorMessage, weekDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HonorBoardTableData &&
          other.id == this.id &&
          other.teacherId == this.teacherId &&
          other.studentId == this.studentId &&
          other.studentName == this.studentName &&
          other.achievement == this.achievement &&
          other.honorMessage == this.honorMessage &&
          other.weekDate == this.weekDate);
}

class HonorBoardTableCompanion extends UpdateCompanion<HonorBoardTableData> {
  final Value<String> id;
  final Value<String> teacherId;
  final Value<String> studentId;
  final Value<String> studentName;
  final Value<String> achievement;
  final Value<String> honorMessage;
  final Value<DateTime> weekDate;
  final Value<int> rowid;
  const HonorBoardTableCompanion({
    this.id = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.studentId = const Value.absent(),
    this.studentName = const Value.absent(),
    this.achievement = const Value.absent(),
    this.honorMessage = const Value.absent(),
    this.weekDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HonorBoardTableCompanion.insert({
    required String id,
    required String teacherId,
    required String studentId,
    required String studentName,
    required String achievement,
    required String honorMessage,
    required DateTime weekDate,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        teacherId = Value(teacherId),
        studentId = Value(studentId),
        studentName = Value(studentName),
        achievement = Value(achievement),
        honorMessage = Value(honorMessage),
        weekDate = Value(weekDate);
  static Insertable<HonorBoardTableData> custom({
    Expression<String>? id,
    Expression<String>? teacherId,
    Expression<String>? studentId,
    Expression<String>? studentName,
    Expression<String>? achievement,
    Expression<String>? honorMessage,
    Expression<DateTime>? weekDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (teacherId != null) 'teacher_id': teacherId,
      if (studentId != null) 'student_id': studentId,
      if (studentName != null) 'student_name': studentName,
      if (achievement != null) 'achievement': achievement,
      if (honorMessage != null) 'honor_message': honorMessage,
      if (weekDate != null) 'week_date': weekDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HonorBoardTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? teacherId,
      Value<String>? studentId,
      Value<String>? studentName,
      Value<String>? achievement,
      Value<String>? honorMessage,
      Value<DateTime>? weekDate,
      Value<int>? rowid}) {
    return HonorBoardTableCompanion(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      achievement: achievement ?? this.achievement,
      honorMessage: honorMessage ?? this.honorMessage,
      weekDate: weekDate ?? this.weekDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (teacherId.present) {
      map['teacher_id'] = Variable<String>(teacherId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (studentName.present) {
      map['student_name'] = Variable<String>(studentName.value);
    }
    if (achievement.present) {
      map['achievement'] = Variable<String>(achievement.value);
    }
    if (honorMessage.present) {
      map['honor_message'] = Variable<String>(honorMessage.value);
    }
    if (weekDate.present) {
      map['week_date'] = Variable<DateTime>(weekDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HonorBoardTableCompanion(')
          ..write('id: $id, ')
          ..write('teacherId: $teacherId, ')
          ..write('studentId: $studentId, ')
          ..write('studentName: $studentName, ')
          ..write('achievement: $achievement, ')
          ..write('honorMessage: $honorMessage, ')
          ..write('weekDate: $weekDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnnouncementsTableTable extends AnnouncementsTable
    with TableInfo<$AnnouncementsTableTable, AnnouncementsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnnouncementsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _teacherIdMeta =
      const VerificationMeta('teacherId');
  @override
  late final GeneratedColumn<String> teacherId = GeneratedColumn<String>(
      'teacher_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expiryDateMeta =
      const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
      'expiry_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, teacherId, title, content, createdAt, expiryDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'announcements_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AnnouncementsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('teacher_id')) {
      context.handle(_teacherIdMeta,
          teacherId.isAcceptableOrUnknown(data['teacher_id']!, _teacherIdMeta));
    } else if (isInserting) {
      context.missing(_teacherIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiryDateMeta,
          expiryDate.isAcceptableOrUnknown(
              data['expiry_date']!, _expiryDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnnouncementsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnnouncementsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      teacherId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}teacher_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      expiryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiry_date']),
    );
  }

  @override
  $AnnouncementsTableTable createAlias(String alias) {
    return $AnnouncementsTableTable(attachedDatabase, alias);
  }
}

class AnnouncementsTableData extends DataClass
    implements Insertable<AnnouncementsTableData> {
  final String id;
  final String teacherId;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? expiryDate;
  const AnnouncementsTableData(
      {required this.id,
      required this.teacherId,
      required this.title,
      required this.content,
      required this.createdAt,
      this.expiryDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['teacher_id'] = Variable<String>(teacherId);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    return map;
  }

  AnnouncementsTableCompanion toCompanion(bool nullToAbsent) {
    return AnnouncementsTableCompanion(
      id: Value(id),
      teacherId: Value(teacherId),
      title: Value(title),
      content: Value(content),
      createdAt: Value(createdAt),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
    );
  }

  factory AnnouncementsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnnouncementsTableData(
      id: serializer.fromJson<String>(json['id']),
      teacherId: serializer.fromJson<String>(json['teacherId']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'teacherId': serializer.toJson<String>(teacherId),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
    };
  }

  AnnouncementsTableData copyWith(
          {String? id,
          String? teacherId,
          String? title,
          String? content,
          DateTime? createdAt,
          Value<DateTime?> expiryDate = const Value.absent()}) =>
      AnnouncementsTableData(
        id: id ?? this.id,
        teacherId: teacherId ?? this.teacherId,
        title: title ?? this.title,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
      );
  AnnouncementsTableData copyWithCompanion(AnnouncementsTableCompanion data) {
    return AnnouncementsTableData(
      id: data.id.present ? data.id.value : this.id,
      teacherId: data.teacherId.present ? data.teacherId.value : this.teacherId,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnnouncementsTableData(')
          ..write('id: $id, ')
          ..write('teacherId: $teacherId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiryDate: $expiryDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, teacherId, title, content, createdAt, expiryDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnnouncementsTableData &&
          other.id == this.id &&
          other.teacherId == this.teacherId &&
          other.title == this.title &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.expiryDate == this.expiryDate);
}

class AnnouncementsTableCompanion
    extends UpdateCompanion<AnnouncementsTableData> {
  final Value<String> id;
  final Value<String> teacherId;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<DateTime?> expiryDate;
  final Value<int> rowid;
  const AnnouncementsTableCompanion({
    this.id = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnnouncementsTableCompanion.insert({
    required String id,
    required String teacherId,
    required String title,
    required String content,
    required DateTime createdAt,
    this.expiryDate = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        teacherId = Value(teacherId),
        title = Value(title),
        content = Value(content),
        createdAt = Value(createdAt);
  static Insertable<AnnouncementsTableData> custom({
    Expression<String>? id,
    Expression<String>? teacherId,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiryDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (teacherId != null) 'teacher_id': teacherId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnnouncementsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? teacherId,
      Value<String>? title,
      Value<String>? content,
      Value<DateTime>? createdAt,
      Value<DateTime?>? expiryDate,
      Value<int>? rowid}) {
    return AnnouncementsTableCompanion(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      expiryDate: expiryDate ?? this.expiryDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (teacherId.present) {
      map['teacher_id'] = Variable<String>(teacherId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnnouncementsTableCompanion(')
          ..write('id: $id, ')
          ..write('teacherId: $teacherId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTableTable extends RemindersTable
    with TableInfo<$RemindersTableTable, RemindersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
      'student_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, studentId, title, content, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders_table';
  @override
  VerificationContext validateIntegrity(Insertable<RemindersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RemindersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RemindersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RemindersTableTable createAlias(String alias) {
    return $RemindersTableTable(attachedDatabase, alias);
  }
}

class RemindersTableData extends DataClass
    implements Insertable<RemindersTableData> {
  final String id;
  final String? studentId;
  final String title;
  final String content;
  final DateTime createdAt;
  const RemindersTableData(
      {required this.id,
      this.studentId,
      required this.title,
      required this.content,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || studentId != null) {
      map['student_id'] = Variable<String>(studentId);
    }
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RemindersTableCompanion toCompanion(bool nullToAbsent) {
    return RemindersTableCompanion(
      id: Value(id),
      studentId: studentId == null && nullToAbsent
          ? const Value.absent()
          : Value(studentId),
      title: Value(title),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory RemindersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RemindersTableData(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String?>(json['studentId']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String?>(studentId),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RemindersTableData copyWith(
          {String? id,
          Value<String?> studentId = const Value.absent(),
          String? title,
          String? content,
          DateTime? createdAt}) =>
      RemindersTableData(
        id: id ?? this.id,
        studentId: studentId.present ? studentId.value : this.studentId,
        title: title ?? this.title,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
      );
  RemindersTableData copyWithCompanion(RemindersTableCompanion data) {
    return RemindersTableData(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RemindersTableData(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studentId, title, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RemindersTableData &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.title == this.title &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class RemindersTableCompanion extends UpdateCompanion<RemindersTableData> {
  final Value<String> id;
  final Value<String?> studentId;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RemindersTableCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersTableCompanion.insert({
    required String id,
    this.studentId = const Value.absent(),
    required String title,
    required String content,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        content = Value(content),
        createdAt = Value(createdAt);
  static Insertable<RemindersTableData> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? studentId,
      Value<String>? title,
      Value<String>? content,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return RemindersTableCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersTableCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TeachersTableTable teachersTable = $TeachersTableTable(this);
  late final $StudentsTableTable studentsTable = $StudentsTableTable(this);
  late final $AttendanceTableTable attendanceTable =
      $AttendanceTableTable(this);
  late final $DailyRecordsTableTable dailyRecordsTable =
      $DailyRecordsTableTable(this);
  late final $TomorrowMemorizationTableTable tomorrowMemorizationTable =
      $TomorrowMemorizationTableTable(this);
  late final $PlansTableTable plansTable = $PlansTableTable(this);
  late final $SchedulesTableTable schedulesTable = $SchedulesTableTable(this);
  late final $QuizzesTableTable quizzesTable = $QuizzesTableTable(this);
  late final $QuizAnswersTableTable quizAnswersTable =
      $QuizAnswersTableTable(this);
  late final $PaymentsTableTable paymentsTable = $PaymentsTableTable(this);
  late final $HonorBoardTableTable honorBoardTable =
      $HonorBoardTableTable(this);
  late final $AnnouncementsTableTable announcementsTable =
      $AnnouncementsTableTable(this);
  late final $RemindersTableTable remindersTable = $RemindersTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        teachersTable,
        studentsTable,
        attendanceTable,
        dailyRecordsTable,
        tomorrowMemorizationTable,
        plansTable,
        schedulesTable,
        quizzesTable,
        quizAnswersTable,
        paymentsTable,
        honorBoardTable,
        announcementsTable,
        remindersTable
      ];
}

typedef $$TeachersTableTableCreateCompanionBuilder = TeachersTableCompanion
    Function({
  required String id,
  required String fullName,
  required String phoneNumber,
  required String loginCode,
  Value<bool> isActive,
  Value<int> studentCount,
  Value<int> rowid,
});
typedef $$TeachersTableTableUpdateCompanionBuilder = TeachersTableCompanion
    Function({
  Value<String> id,
  Value<String> fullName,
  Value<String> phoneNumber,
  Value<String> loginCode,
  Value<bool> isActive,
  Value<int> studentCount,
  Value<int> rowid,
});

class $$TeachersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TeachersTableTable,
    TeachersTableData,
    $$TeachersTableTableFilterComposer,
    $$TeachersTableTableOrderingComposer,
    $$TeachersTableTableCreateCompanionBuilder,
    $$TeachersTableTableUpdateCompanionBuilder> {
  $$TeachersTableTableTableManager(_$AppDatabase db, $TeachersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TeachersTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TeachersTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String> phoneNumber = const Value.absent(),
            Value<String> loginCode = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> studentCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TeachersTableCompanion(
            id: id,
            fullName: fullName,
            phoneNumber: phoneNumber,
            loginCode: loginCode,
            isActive: isActive,
            studentCount: studentCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String fullName,
            required String phoneNumber,
            required String loginCode,
            Value<bool> isActive = const Value.absent(),
            Value<int> studentCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TeachersTableCompanion.insert(
            id: id,
            fullName: fullName,
            phoneNumber: phoneNumber,
            loginCode: loginCode,
            isActive: isActive,
            studentCount: studentCount,
            rowid: rowid,
          ),
        ));
}

class $$TeachersTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TeachersTableTable> {
  $$TeachersTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fullName => $state.composableBuilder(
      column: $state.table.fullName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get phoneNumber => $state.composableBuilder(
      column: $state.table.phoneNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get loginCode => $state.composableBuilder(
      column: $state.table.loginCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get studentCount => $state.composableBuilder(
      column: $state.table.studentCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$TeachersTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TeachersTableTable> {
  $$TeachersTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fullName => $state.composableBuilder(
      column: $state.table.fullName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get phoneNumber => $state.composableBuilder(
      column: $state.table.phoneNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get loginCode => $state.composableBuilder(
      column: $state.table.loginCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get studentCount => $state.composableBuilder(
      column: $state.table.studentCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$StudentsTableTableCreateCompanionBuilder = StudentsTableCompanion
    Function({
  required String id,
  required String name,
  required String parentName,
  required String parentPhone,
  required String loginCode,
  Value<String?> teacherId,
  Value<int> points,
  Value<int> stars,
  Value<String> achievementLevel,
  Value<DateTime?> lastProgressSync,
  Value<int> monthlySubscription,
  Value<int> rowid,
});
typedef $$StudentsTableTableUpdateCompanionBuilder = StudentsTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> parentName,
  Value<String> parentPhone,
  Value<String> loginCode,
  Value<String?> teacherId,
  Value<int> points,
  Value<int> stars,
  Value<String> achievementLevel,
  Value<DateTime?> lastProgressSync,
  Value<int> monthlySubscription,
  Value<int> rowid,
});

class $$StudentsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudentsTableTable,
    StudentsTableData,
    $$StudentsTableTableFilterComposer,
    $$StudentsTableTableOrderingComposer,
    $$StudentsTableTableCreateCompanionBuilder,
    $$StudentsTableTableUpdateCompanionBuilder> {
  $$StudentsTableTableTableManager(_$AppDatabase db, $StudentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$StudentsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$StudentsTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> parentName = const Value.absent(),
            Value<String> parentPhone = const Value.absent(),
            Value<String> loginCode = const Value.absent(),
            Value<String?> teacherId = const Value.absent(),
            Value<int> points = const Value.absent(),
            Value<int> stars = const Value.absent(),
            Value<String> achievementLevel = const Value.absent(),
            Value<DateTime?> lastProgressSync = const Value.absent(),
            Value<int> monthlySubscription = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentsTableCompanion(
            id: id,
            name: name,
            parentName: parentName,
            parentPhone: parentPhone,
            loginCode: loginCode,
            teacherId: teacherId,
            points: points,
            stars: stars,
            achievementLevel: achievementLevel,
            lastProgressSync: lastProgressSync,
            monthlySubscription: monthlySubscription,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String parentName,
            required String parentPhone,
            required String loginCode,
            Value<String?> teacherId = const Value.absent(),
            Value<int> points = const Value.absent(),
            Value<int> stars = const Value.absent(),
            Value<String> achievementLevel = const Value.absent(),
            Value<DateTime?> lastProgressSync = const Value.absent(),
            Value<int> monthlySubscription = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentsTableCompanion.insert(
            id: id,
            name: name,
            parentName: parentName,
            parentPhone: parentPhone,
            loginCode: loginCode,
            teacherId: teacherId,
            points: points,
            stars: stars,
            achievementLevel: achievementLevel,
            lastProgressSync: lastProgressSync,
            monthlySubscription: monthlySubscription,
            rowid: rowid,
          ),
        ));
}

class $$StudentsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $StudentsTableTable> {
  $$StudentsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get parentName => $state.composableBuilder(
      column: $state.table.parentName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get parentPhone => $state.composableBuilder(
      column: $state.table.parentPhone,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get loginCode => $state.composableBuilder(
      column: $state.table.loginCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get teacherId => $state.composableBuilder(
      column: $state.table.teacherId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get points => $state.composableBuilder(
      column: $state.table.points,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get stars => $state.composableBuilder(
      column: $state.table.stars,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get achievementLevel => $state.composableBuilder(
      column: $state.table.achievementLevel,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastProgressSync => $state.composableBuilder(
      column: $state.table.lastProgressSync,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get monthlySubscription => $state.composableBuilder(
      column: $state.table.monthlySubscription,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$StudentsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $StudentsTableTable> {
  $$StudentsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get parentName => $state.composableBuilder(
      column: $state.table.parentName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get parentPhone => $state.composableBuilder(
      column: $state.table.parentPhone,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get loginCode => $state.composableBuilder(
      column: $state.table.loginCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get teacherId => $state.composableBuilder(
      column: $state.table.teacherId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get points => $state.composableBuilder(
      column: $state.table.points,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get stars => $state.composableBuilder(
      column: $state.table.stars,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get achievementLevel => $state.composableBuilder(
      column: $state.table.achievementLevel,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastProgressSync => $state.composableBuilder(
      column: $state.table.lastProgressSync,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get monthlySubscription => $state.composableBuilder(
      column: $state.table.monthlySubscription,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$AttendanceTableTableCreateCompanionBuilder = AttendanceTableCompanion
    Function({
  required String id,
  required String studentId,
  required DateTime date,
  Value<bool> isAbsent,
  Value<DateTime?> arrivalTime,
  Value<DateTime?> departureTime,
  Value<int> rowid,
});
typedef $$AttendanceTableTableUpdateCompanionBuilder = AttendanceTableCompanion
    Function({
  Value<String> id,
  Value<String> studentId,
  Value<DateTime> date,
  Value<bool> isAbsent,
  Value<DateTime?> arrivalTime,
  Value<DateTime?> departureTime,
  Value<int> rowid,
});

class $$AttendanceTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AttendanceTableTable,
    AttendanceTableData,
    $$AttendanceTableTableFilterComposer,
    $$AttendanceTableTableOrderingComposer,
    $$AttendanceTableTableCreateCompanionBuilder,
    $$AttendanceTableTableUpdateCompanionBuilder> {
  $$AttendanceTableTableTableManager(
      _$AppDatabase db, $AttendanceTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AttendanceTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AttendanceTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> studentId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<bool> isAbsent = const Value.absent(),
            Value<DateTime?> arrivalTime = const Value.absent(),
            Value<DateTime?> departureTime = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AttendanceTableCompanion(
            id: id,
            studentId: studentId,
            date: date,
            isAbsent: isAbsent,
            arrivalTime: arrivalTime,
            departureTime: departureTime,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String studentId,
            required DateTime date,
            Value<bool> isAbsent = const Value.absent(),
            Value<DateTime?> arrivalTime = const Value.absent(),
            Value<DateTime?> departureTime = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AttendanceTableCompanion.insert(
            id: id,
            studentId: studentId,
            date: date,
            isAbsent: isAbsent,
            arrivalTime: arrivalTime,
            departureTime: departureTime,
            rowid: rowid,
          ),
        ));
}

class $$AttendanceTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AttendanceTableTable> {
  $$AttendanceTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isAbsent => $state.composableBuilder(
      column: $state.table.isAbsent,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get arrivalTime => $state.composableBuilder(
      column: $state.table.arrivalTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get departureTime => $state.composableBuilder(
      column: $state.table.departureTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AttendanceTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AttendanceTableTable> {
  $$AttendanceTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isAbsent => $state.composableBuilder(
      column: $state.table.isAbsent,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get arrivalTime => $state.composableBuilder(
      column: $state.table.arrivalTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get departureTime => $state.composableBuilder(
      column: $state.table.departureTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$DailyRecordsTableTableCreateCompanionBuilder
    = DailyRecordsTableCompanion Function({
  required String id,
  required String studentId,
  required DateTime date,
  required String memorizationMethod,
  required String memorizationData,
  required String memorizationGrade,
  required String revisionMethod,
  required String revisionData,
  required String revisionGrade,
  Value<String?> teacherNotes,
  Value<String?> encouragementMessage,
  Value<int> rowid,
});
typedef $$DailyRecordsTableTableUpdateCompanionBuilder
    = DailyRecordsTableCompanion Function({
  Value<String> id,
  Value<String> studentId,
  Value<DateTime> date,
  Value<String> memorizationMethod,
  Value<String> memorizationData,
  Value<String> memorizationGrade,
  Value<String> revisionMethod,
  Value<String> revisionData,
  Value<String> revisionGrade,
  Value<String?> teacherNotes,
  Value<String?> encouragementMessage,
  Value<int> rowid,
});

class $$DailyRecordsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyRecordsTableTable,
    DailyRecordsTableData,
    $$DailyRecordsTableTableFilterComposer,
    $$DailyRecordsTableTableOrderingComposer,
    $$DailyRecordsTableTableCreateCompanionBuilder,
    $$DailyRecordsTableTableUpdateCompanionBuilder> {
  $$DailyRecordsTableTableTableManager(
      _$AppDatabase db, $DailyRecordsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$DailyRecordsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$DailyRecordsTableTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> studentId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> memorizationMethod = const Value.absent(),
            Value<String> memorizationData = const Value.absent(),
            Value<String> memorizationGrade = const Value.absent(),
            Value<String> revisionMethod = const Value.absent(),
            Value<String> revisionData = const Value.absent(),
            Value<String> revisionGrade = const Value.absent(),
            Value<String?> teacherNotes = const Value.absent(),
            Value<String?> encouragementMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyRecordsTableCompanion(
            id: id,
            studentId: studentId,
            date: date,
            memorizationMethod: memorizationMethod,
            memorizationData: memorizationData,
            memorizationGrade: memorizationGrade,
            revisionMethod: revisionMethod,
            revisionData: revisionData,
            revisionGrade: revisionGrade,
            teacherNotes: teacherNotes,
            encouragementMessage: encouragementMessage,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String studentId,
            required DateTime date,
            required String memorizationMethod,
            required String memorizationData,
            required String memorizationGrade,
            required String revisionMethod,
            required String revisionData,
            required String revisionGrade,
            Value<String?> teacherNotes = const Value.absent(),
            Value<String?> encouragementMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyRecordsTableCompanion.insert(
            id: id,
            studentId: studentId,
            date: date,
            memorizationMethod: memorizationMethod,
            memorizationData: memorizationData,
            memorizationGrade: memorizationGrade,
            revisionMethod: revisionMethod,
            revisionData: revisionData,
            revisionGrade: revisionGrade,
            teacherNotes: teacherNotes,
            encouragementMessage: encouragementMessage,
            rowid: rowid,
          ),
        ));
}

class $$DailyRecordsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $DailyRecordsTableTable> {
  $$DailyRecordsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get memorizationMethod => $state.composableBuilder(
      column: $state.table.memorizationMethod,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get memorizationData => $state.composableBuilder(
      column: $state.table.memorizationData,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get memorizationGrade => $state.composableBuilder(
      column: $state.table.memorizationGrade,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get revisionMethod => $state.composableBuilder(
      column: $state.table.revisionMethod,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get revisionData => $state.composableBuilder(
      column: $state.table.revisionData,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get revisionGrade => $state.composableBuilder(
      column: $state.table.revisionGrade,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get teacherNotes => $state.composableBuilder(
      column: $state.table.teacherNotes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get encouragementMessage => $state.composableBuilder(
      column: $state.table.encouragementMessage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$DailyRecordsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $DailyRecordsTableTable> {
  $$DailyRecordsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get memorizationMethod => $state.composableBuilder(
      column: $state.table.memorizationMethod,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get memorizationData => $state.composableBuilder(
      column: $state.table.memorizationData,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get memorizationGrade => $state.composableBuilder(
      column: $state.table.memorizationGrade,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get revisionMethod => $state.composableBuilder(
      column: $state.table.revisionMethod,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get revisionData => $state.composableBuilder(
      column: $state.table.revisionData,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get revisionGrade => $state.composableBuilder(
      column: $state.table.revisionGrade,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get teacherNotes => $state.composableBuilder(
      column: $state.table.teacherNotes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get encouragementMessage => $state.composableBuilder(
      column: $state.table.encouragementMessage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$TomorrowMemorizationTableTableCreateCompanionBuilder
    = TomorrowMemorizationTableCompanion Function({
  required String studentId,
  required String memorizationMethod,
  required String memorizationData,
  required String revisionMethod,
  required String revisionData,
  Value<String?> notes,
  Value<String?> encouragementMessage,
  Value<int> rowid,
});
typedef $$TomorrowMemorizationTableTableUpdateCompanionBuilder
    = TomorrowMemorizationTableCompanion Function({
  Value<String> studentId,
  Value<String> memorizationMethod,
  Value<String> memorizationData,
  Value<String> revisionMethod,
  Value<String> revisionData,
  Value<String?> notes,
  Value<String?> encouragementMessage,
  Value<int> rowid,
});

class $$TomorrowMemorizationTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TomorrowMemorizationTableTable,
    TomorrowMemorizationTableData,
    $$TomorrowMemorizationTableTableFilterComposer,
    $$TomorrowMemorizationTableTableOrderingComposer,
    $$TomorrowMemorizationTableTableCreateCompanionBuilder,
    $$TomorrowMemorizationTableTableUpdateCompanionBuilder> {
  $$TomorrowMemorizationTableTableTableManager(
      _$AppDatabase db, $TomorrowMemorizationTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$TomorrowMemorizationTableTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$TomorrowMemorizationTableTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> studentId = const Value.absent(),
            Value<String> memorizationMethod = const Value.absent(),
            Value<String> memorizationData = const Value.absent(),
            Value<String> revisionMethod = const Value.absent(),
            Value<String> revisionData = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> encouragementMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TomorrowMemorizationTableCompanion(
            studentId: studentId,
            memorizationMethod: memorizationMethod,
            memorizationData: memorizationData,
            revisionMethod: revisionMethod,
            revisionData: revisionData,
            notes: notes,
            encouragementMessage: encouragementMessage,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String studentId,
            required String memorizationMethod,
            required String memorizationData,
            required String revisionMethod,
            required String revisionData,
            Value<String?> notes = const Value.absent(),
            Value<String?> encouragementMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TomorrowMemorizationTableCompanion.insert(
            studentId: studentId,
            memorizationMethod: memorizationMethod,
            memorizationData: memorizationData,
            revisionMethod: revisionMethod,
            revisionData: revisionData,
            notes: notes,
            encouragementMessage: encouragementMessage,
            rowid: rowid,
          ),
        ));
}

class $$TomorrowMemorizationTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TomorrowMemorizationTableTable> {
  $$TomorrowMemorizationTableTableFilterComposer(super.$state);
  ColumnFilters<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get memorizationMethod => $state.composableBuilder(
      column: $state.table.memorizationMethod,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get memorizationData => $state.composableBuilder(
      column: $state.table.memorizationData,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get revisionMethod => $state.composableBuilder(
      column: $state.table.revisionMethod,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get revisionData => $state.composableBuilder(
      column: $state.table.revisionData,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get encouragementMessage => $state.composableBuilder(
      column: $state.table.encouragementMessage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$TomorrowMemorizationTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TomorrowMemorizationTableTable> {
  $$TomorrowMemorizationTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get memorizationMethod => $state.composableBuilder(
      column: $state.table.memorizationMethod,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get memorizationData => $state.composableBuilder(
      column: $state.table.memorizationData,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get revisionMethod => $state.composableBuilder(
      column: $state.table.revisionMethod,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get revisionData => $state.composableBuilder(
      column: $state.table.revisionData,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get encouragementMessage => $state.composableBuilder(
      column: $state.table.encouragementMessage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PlansTableTableCreateCompanionBuilder = PlansTableCompanion Function({
  required String studentId,
  Value<int> attendanceDaysPerWeek,
  Value<int> dailyLinesCount,
  Value<int> direction,
  required int startSurah,
  required int startVerse,
  required int endSurah,
  required int endVerse,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$PlansTableTableUpdateCompanionBuilder = PlansTableCompanion Function({
  Value<String> studentId,
  Value<int> attendanceDaysPerWeek,
  Value<int> dailyLinesCount,
  Value<int> direction,
  Value<int> startSurah,
  Value<int> startVerse,
  Value<int> endSurah,
  Value<int> endVerse,
  Value<String?> notes,
  Value<int> rowid,
});

class $$PlansTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlansTableTable,
    PlansTableData,
    $$PlansTableTableFilterComposer,
    $$PlansTableTableOrderingComposer,
    $$PlansTableTableCreateCompanionBuilder,
    $$PlansTableTableUpdateCompanionBuilder> {
  $$PlansTableTableTableManager(_$AppDatabase db, $PlansTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PlansTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PlansTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> studentId = const Value.absent(),
            Value<int> attendanceDaysPerWeek = const Value.absent(),
            Value<int> dailyLinesCount = const Value.absent(),
            Value<int> direction = const Value.absent(),
            Value<int> startSurah = const Value.absent(),
            Value<int> startVerse = const Value.absent(),
            Value<int> endSurah = const Value.absent(),
            Value<int> endVerse = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlansTableCompanion(
            studentId: studentId,
            attendanceDaysPerWeek: attendanceDaysPerWeek,
            dailyLinesCount: dailyLinesCount,
            direction: direction,
            startSurah: startSurah,
            startVerse: startVerse,
            endSurah: endSurah,
            endVerse: endVerse,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String studentId,
            Value<int> attendanceDaysPerWeek = const Value.absent(),
            Value<int> dailyLinesCount = const Value.absent(),
            Value<int> direction = const Value.absent(),
            required int startSurah,
            required int startVerse,
            required int endSurah,
            required int endVerse,
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlansTableCompanion.insert(
            studentId: studentId,
            attendanceDaysPerWeek: attendanceDaysPerWeek,
            dailyLinesCount: dailyLinesCount,
            direction: direction,
            startSurah: startSurah,
            startVerse: startVerse,
            endSurah: endSurah,
            endVerse: endVerse,
            notes: notes,
            rowid: rowid,
          ),
        ));
}

class $$PlansTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PlansTableTable> {
  $$PlansTableTableFilterComposer(super.$state);
  ColumnFilters<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get attendanceDaysPerWeek => $state.composableBuilder(
      column: $state.table.attendanceDaysPerWeek,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get dailyLinesCount => $state.composableBuilder(
      column: $state.table.dailyLinesCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get direction => $state.composableBuilder(
      column: $state.table.direction,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get startSurah => $state.composableBuilder(
      column: $state.table.startSurah,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get startVerse => $state.composableBuilder(
      column: $state.table.startVerse,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get endSurah => $state.composableBuilder(
      column: $state.table.endSurah,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get endVerse => $state.composableBuilder(
      column: $state.table.endVerse,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PlansTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PlansTableTable> {
  $$PlansTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get attendanceDaysPerWeek => $state.composableBuilder(
      column: $state.table.attendanceDaysPerWeek,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get dailyLinesCount => $state.composableBuilder(
      column: $state.table.dailyLinesCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get direction => $state.composableBuilder(
      column: $state.table.direction,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get startSurah => $state.composableBuilder(
      column: $state.table.startSurah,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get startVerse => $state.composableBuilder(
      column: $state.table.startVerse,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get endSurah => $state.composableBuilder(
      column: $state.table.endSurah,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get endVerse => $state.composableBuilder(
      column: $state.table.endVerse,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SchedulesTableTableCreateCompanionBuilder = SchedulesTableCompanion
    Function({
  required String studentId,
  required String lessonsJson,
  required DateTime lastModified,
  Value<String?> modificationHistoryJson,
  Value<int> rowid,
});
typedef $$SchedulesTableTableUpdateCompanionBuilder = SchedulesTableCompanion
    Function({
  Value<String> studentId,
  Value<String> lessonsJson,
  Value<DateTime> lastModified,
  Value<String?> modificationHistoryJson,
  Value<int> rowid,
});

class $$SchedulesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SchedulesTableTable,
    SchedulesTableData,
    $$SchedulesTableTableFilterComposer,
    $$SchedulesTableTableOrderingComposer,
    $$SchedulesTableTableCreateCompanionBuilder,
    $$SchedulesTableTableUpdateCompanionBuilder> {
  $$SchedulesTableTableTableManager(
      _$AppDatabase db, $SchedulesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SchedulesTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SchedulesTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> studentId = const Value.absent(),
            Value<String> lessonsJson = const Value.absent(),
            Value<DateTime> lastModified = const Value.absent(),
            Value<String?> modificationHistoryJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SchedulesTableCompanion(
            studentId: studentId,
            lessonsJson: lessonsJson,
            lastModified: lastModified,
            modificationHistoryJson: modificationHistoryJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String studentId,
            required String lessonsJson,
            required DateTime lastModified,
            Value<String?> modificationHistoryJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SchedulesTableCompanion.insert(
            studentId: studentId,
            lessonsJson: lessonsJson,
            lastModified: lastModified,
            modificationHistoryJson: modificationHistoryJson,
            rowid: rowid,
          ),
        ));
}

class $$SchedulesTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SchedulesTableTable> {
  $$SchedulesTableTableFilterComposer(super.$state);
  ColumnFilters<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get lessonsJson => $state.composableBuilder(
      column: $state.table.lessonsJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastModified => $state.composableBuilder(
      column: $state.table.lastModified,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get modificationHistoryJson => $state.composableBuilder(
      column: $state.table.modificationHistoryJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SchedulesTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SchedulesTableTable> {
  $$SchedulesTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get lessonsJson => $state.composableBuilder(
      column: $state.table.lessonsJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastModified => $state.composableBuilder(
      column: $state.table.lastModified,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get modificationHistoryJson =>
      $state.composableBuilder(
          column: $state.table.modificationHistoryJson,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$QuizzesTableTableCreateCompanionBuilder = QuizzesTableCompanion
    Function({
  required String id,
  required String teacherId,
  required String title,
  Value<String?> description,
  required String questionsJson,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$QuizzesTableTableUpdateCompanionBuilder = QuizzesTableCompanion
    Function({
  Value<String> id,
  Value<String> teacherId,
  Value<String> title,
  Value<String?> description,
  Value<String> questionsJson,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$QuizzesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuizzesTableTable,
    QuizzesTableData,
    $$QuizzesTableTableFilterComposer,
    $$QuizzesTableTableOrderingComposer,
    $$QuizzesTableTableCreateCompanionBuilder,
    $$QuizzesTableTableUpdateCompanionBuilder> {
  $$QuizzesTableTableTableManager(_$AppDatabase db, $QuizzesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$QuizzesTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$QuizzesTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> teacherId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> questionsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuizzesTableCompanion(
            id: id,
            teacherId: teacherId,
            title: title,
            description: description,
            questionsJson: questionsJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String teacherId,
            required String title,
            Value<String?> description = const Value.absent(),
            required String questionsJson,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              QuizzesTableCompanion.insert(
            id: id,
            teacherId: teacherId,
            title: title,
            description: description,
            questionsJson: questionsJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$QuizzesTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $QuizzesTableTable> {
  $$QuizzesTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get teacherId => $state.composableBuilder(
      column: $state.table.teacherId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get questionsJson => $state.composableBuilder(
      column: $state.table.questionsJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$QuizzesTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $QuizzesTableTable> {
  $$QuizzesTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get teacherId => $state.composableBuilder(
      column: $state.table.teacherId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get questionsJson => $state.composableBuilder(
      column: $state.table.questionsJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$QuizAnswersTableTableCreateCompanionBuilder
    = QuizAnswersTableCompanion Function({
  required String id,
  required String quizId,
  required String studentId,
  required int score,
  required String answersJson,
  required DateTime completedAt,
  Value<int> rowid,
});
typedef $$QuizAnswersTableTableUpdateCompanionBuilder
    = QuizAnswersTableCompanion Function({
  Value<String> id,
  Value<String> quizId,
  Value<String> studentId,
  Value<int> score,
  Value<String> answersJson,
  Value<DateTime> completedAt,
  Value<int> rowid,
});

class $$QuizAnswersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuizAnswersTableTable,
    QuizAnswersTableData,
    $$QuizAnswersTableTableFilterComposer,
    $$QuizAnswersTableTableOrderingComposer,
    $$QuizAnswersTableTableCreateCompanionBuilder,
    $$QuizAnswersTableTableUpdateCompanionBuilder> {
  $$QuizAnswersTableTableTableManager(
      _$AppDatabase db, $QuizAnswersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$QuizAnswersTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$QuizAnswersTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> quizId = const Value.absent(),
            Value<String> studentId = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<String> answersJson = const Value.absent(),
            Value<DateTime> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuizAnswersTableCompanion(
            id: id,
            quizId: quizId,
            studentId: studentId,
            score: score,
            answersJson: answersJson,
            completedAt: completedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String quizId,
            required String studentId,
            required int score,
            required String answersJson,
            required DateTime completedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              QuizAnswersTableCompanion.insert(
            id: id,
            quizId: quizId,
            studentId: studentId,
            score: score,
            answersJson: answersJson,
            completedAt: completedAt,
            rowid: rowid,
          ),
        ));
}

class $$QuizAnswersTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $QuizAnswersTableTable> {
  $$QuizAnswersTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get quizId => $state.composableBuilder(
      column: $state.table.quizId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get score => $state.composableBuilder(
      column: $state.table.score,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get answersJson => $state.composableBuilder(
      column: $state.table.answersJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get completedAt => $state.composableBuilder(
      column: $state.table.completedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$QuizAnswersTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $QuizAnswersTableTable> {
  $$QuizAnswersTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get quizId => $state.composableBuilder(
      column: $state.table.quizId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get score => $state.composableBuilder(
      column: $state.table.score,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get answersJson => $state.composableBuilder(
      column: $state.table.answersJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get completedAt => $state.composableBuilder(
      column: $state.table.completedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PaymentsTableTableCreateCompanionBuilder = PaymentsTableCompanion
    Function({
  required String id,
  required String studentId,
  required double amount,
  required String month,
  Value<bool> isPaid,
  Value<DateTime?> paymentDate,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$PaymentsTableTableUpdateCompanionBuilder = PaymentsTableCompanion
    Function({
  Value<String> id,
  Value<String> studentId,
  Value<double> amount,
  Value<String> month,
  Value<bool> isPaid,
  Value<DateTime?> paymentDate,
  Value<String?> notes,
  Value<int> rowid,
});

class $$PaymentsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentsTableTable,
    PaymentsTableData,
    $$PaymentsTableTableFilterComposer,
    $$PaymentsTableTableOrderingComposer,
    $$PaymentsTableTableCreateCompanionBuilder,
    $$PaymentsTableTableUpdateCompanionBuilder> {
  $$PaymentsTableTableTableManager(_$AppDatabase db, $PaymentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PaymentsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PaymentsTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> studentId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> month = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
            Value<DateTime?> paymentDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsTableCompanion(
            id: id,
            studentId: studentId,
            amount: amount,
            month: month,
            isPaid: isPaid,
            paymentDate: paymentDate,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String studentId,
            required double amount,
            required String month,
            Value<bool> isPaid = const Value.absent(),
            Value<DateTime?> paymentDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsTableCompanion.insert(
            id: id,
            studentId: studentId,
            amount: amount,
            month: month,
            isPaid: isPaid,
            paymentDate: paymentDate,
            notes: notes,
            rowid: rowid,
          ),
        ));
}

class $$PaymentsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PaymentsTableTable> {
  $$PaymentsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get month => $state.composableBuilder(
      column: $state.table.month,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isPaid => $state.composableBuilder(
      column: $state.table.isPaid,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get paymentDate => $state.composableBuilder(
      column: $state.table.paymentDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PaymentsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PaymentsTableTable> {
  $$PaymentsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get month => $state.composableBuilder(
      column: $state.table.month,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isPaid => $state.composableBuilder(
      column: $state.table.isPaid,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get paymentDate => $state.composableBuilder(
      column: $state.table.paymentDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$HonorBoardTableTableCreateCompanionBuilder = HonorBoardTableCompanion
    Function({
  required String id,
  required String teacherId,
  required String studentId,
  required String studentName,
  required String achievement,
  required String honorMessage,
  required DateTime weekDate,
  Value<int> rowid,
});
typedef $$HonorBoardTableTableUpdateCompanionBuilder = HonorBoardTableCompanion
    Function({
  Value<String> id,
  Value<String> teacherId,
  Value<String> studentId,
  Value<String> studentName,
  Value<String> achievement,
  Value<String> honorMessage,
  Value<DateTime> weekDate,
  Value<int> rowid,
});

class $$HonorBoardTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HonorBoardTableTable,
    HonorBoardTableData,
    $$HonorBoardTableTableFilterComposer,
    $$HonorBoardTableTableOrderingComposer,
    $$HonorBoardTableTableCreateCompanionBuilder,
    $$HonorBoardTableTableUpdateCompanionBuilder> {
  $$HonorBoardTableTableTableManager(
      _$AppDatabase db, $HonorBoardTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$HonorBoardTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$HonorBoardTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> teacherId = const Value.absent(),
            Value<String> studentId = const Value.absent(),
            Value<String> studentName = const Value.absent(),
            Value<String> achievement = const Value.absent(),
            Value<String> honorMessage = const Value.absent(),
            Value<DateTime> weekDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HonorBoardTableCompanion(
            id: id,
            teacherId: teacherId,
            studentId: studentId,
            studentName: studentName,
            achievement: achievement,
            honorMessage: honorMessage,
            weekDate: weekDate,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String teacherId,
            required String studentId,
            required String studentName,
            required String achievement,
            required String honorMessage,
            required DateTime weekDate,
            Value<int> rowid = const Value.absent(),
          }) =>
              HonorBoardTableCompanion.insert(
            id: id,
            teacherId: teacherId,
            studentId: studentId,
            studentName: studentName,
            achievement: achievement,
            honorMessage: honorMessage,
            weekDate: weekDate,
            rowid: rowid,
          ),
        ));
}

class $$HonorBoardTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $HonorBoardTableTable> {
  $$HonorBoardTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get teacherId => $state.composableBuilder(
      column: $state.table.teacherId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get studentName => $state.composableBuilder(
      column: $state.table.studentName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get achievement => $state.composableBuilder(
      column: $state.table.achievement,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get honorMessage => $state.composableBuilder(
      column: $state.table.honorMessage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get weekDate => $state.composableBuilder(
      column: $state.table.weekDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$HonorBoardTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $HonorBoardTableTable> {
  $$HonorBoardTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get teacherId => $state.composableBuilder(
      column: $state.table.teacherId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get studentName => $state.composableBuilder(
      column: $state.table.studentName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get achievement => $state.composableBuilder(
      column: $state.table.achievement,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get honorMessage => $state.composableBuilder(
      column: $state.table.honorMessage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get weekDate => $state.composableBuilder(
      column: $state.table.weekDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$AnnouncementsTableTableCreateCompanionBuilder
    = AnnouncementsTableCompanion Function({
  required String id,
  required String teacherId,
  required String title,
  required String content,
  required DateTime createdAt,
  Value<DateTime?> expiryDate,
  Value<int> rowid,
});
typedef $$AnnouncementsTableTableUpdateCompanionBuilder
    = AnnouncementsTableCompanion Function({
  Value<String> id,
  Value<String> teacherId,
  Value<String> title,
  Value<String> content,
  Value<DateTime> createdAt,
  Value<DateTime?> expiryDate,
  Value<int> rowid,
});

class $$AnnouncementsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AnnouncementsTableTable,
    AnnouncementsTableData,
    $$AnnouncementsTableTableFilterComposer,
    $$AnnouncementsTableTableOrderingComposer,
    $$AnnouncementsTableTableCreateCompanionBuilder,
    $$AnnouncementsTableTableUpdateCompanionBuilder> {
  $$AnnouncementsTableTableTableManager(
      _$AppDatabase db, $AnnouncementsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AnnouncementsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$AnnouncementsTableTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> teacherId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AnnouncementsTableCompanion(
            id: id,
            teacherId: teacherId,
            title: title,
            content: content,
            createdAt: createdAt,
            expiryDate: expiryDate,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String teacherId,
            required String title,
            required String content,
            required DateTime createdAt,
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AnnouncementsTableCompanion.insert(
            id: id,
            teacherId: teacherId,
            title: title,
            content: content,
            createdAt: createdAt,
            expiryDate: expiryDate,
            rowid: rowid,
          ),
        ));
}

class $$AnnouncementsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AnnouncementsTableTable> {
  $$AnnouncementsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get teacherId => $state.composableBuilder(
      column: $state.table.teacherId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get expiryDate => $state.composableBuilder(
      column: $state.table.expiryDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AnnouncementsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AnnouncementsTableTable> {
  $$AnnouncementsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get teacherId => $state.composableBuilder(
      column: $state.table.teacherId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get expiryDate => $state.composableBuilder(
      column: $state.table.expiryDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$RemindersTableTableCreateCompanionBuilder = RemindersTableCompanion
    Function({
  required String id,
  Value<String?> studentId,
  required String title,
  required String content,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$RemindersTableTableUpdateCompanionBuilder = RemindersTableCompanion
    Function({
  Value<String> id,
  Value<String?> studentId,
  Value<String> title,
  Value<String> content,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$RemindersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RemindersTableTable,
    RemindersTableData,
    $$RemindersTableTableFilterComposer,
    $$RemindersTableTableOrderingComposer,
    $$RemindersTableTableCreateCompanionBuilder,
    $$RemindersTableTableUpdateCompanionBuilder> {
  $$RemindersTableTableTableManager(
      _$AppDatabase db, $RemindersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$RemindersTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$RemindersTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> studentId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersTableCompanion(
            id: id,
            studentId: studentId,
            title: title,
            content: content,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> studentId = const Value.absent(),
            required String title,
            required String content,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersTableCompanion.insert(
            id: id,
            studentId: studentId,
            title: title,
            content: content,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$RemindersTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$RemindersTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get studentId => $state.composableBuilder(
      column: $state.table.studentId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TeachersTableTableTableManager get teachersTable =>
      $$TeachersTableTableTableManager(_db, _db.teachersTable);
  $$StudentsTableTableTableManager get studentsTable =>
      $$StudentsTableTableTableManager(_db, _db.studentsTable);
  $$AttendanceTableTableTableManager get attendanceTable =>
      $$AttendanceTableTableTableManager(_db, _db.attendanceTable);
  $$DailyRecordsTableTableTableManager get dailyRecordsTable =>
      $$DailyRecordsTableTableTableManager(_db, _db.dailyRecordsTable);
  $$TomorrowMemorizationTableTableTableManager get tomorrowMemorizationTable =>
      $$TomorrowMemorizationTableTableTableManager(
          _db, _db.tomorrowMemorizationTable);
  $$PlansTableTableTableManager get plansTable =>
      $$PlansTableTableTableManager(_db, _db.plansTable);
  $$SchedulesTableTableTableManager get schedulesTable =>
      $$SchedulesTableTableTableManager(_db, _db.schedulesTable);
  $$QuizzesTableTableTableManager get quizzesTable =>
      $$QuizzesTableTableTableManager(_db, _db.quizzesTable);
  $$QuizAnswersTableTableTableManager get quizAnswersTable =>
      $$QuizAnswersTableTableTableManager(_db, _db.quizAnswersTable);
  $$PaymentsTableTableTableManager get paymentsTable =>
      $$PaymentsTableTableTableManager(_db, _db.paymentsTable);
  $$HonorBoardTableTableTableManager get honorBoardTable =>
      $$HonorBoardTableTableTableManager(_db, _db.honorBoardTable);
  $$AnnouncementsTableTableTableManager get announcementsTable =>
      $$AnnouncementsTableTableTableManager(_db, _db.announcementsTable);
  $$RemindersTableTableTableManager get remindersTable =>
      $$RemindersTableTableTableManager(_db, _db.remindersTable);
}
