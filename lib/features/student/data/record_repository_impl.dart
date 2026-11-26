import 'package:drift/drift.dart';
import 'package:athar/core/database/app_database.dart';
import 'package:athar/core/models/models.dart';
import 'package:athar/features/student/domain/record_repository.dart';

class RecordRepositoryImpl implements RecordRepository {
  final AppDatabase _db;

  RecordRepositoryImpl(this._db);

  Attendance _mapAttendance(AttendanceTableData data) {
    return Attendance(
      id: data.id,
      studentId: data.studentId,
      date: data.date,
      isAbsent: data.isAbsent,
      arrivalTime: data.arrivalTime,
      departureTime: data.departureTime,
    );
  }

  DailyRecord _mapDailyRecord(DailyRecordsTableData data) {
    return DailyRecord(
      id: data.id,
      studentId: data.studentId,
      date: data.date,
      memorizationMethod: data.memorizationMethod,
      memorizationData: data.memorizationData,
      memorizationGrade: data.memorizationGrade,
      revisionMethod: data.revisionMethod,
      revisionData: data.revisionData,
      revisionGrade: data.revisionGrade,
      teacherNotes: data.teacherNotes,
      encouragementMessage: data.encouragementMessage,
    );
  }

  TomorrowPlan _mapTomorrowPlan(TomorrowMemorizationTableData data) {
    return TomorrowPlan(
      studentId: data.studentId,
      memorizationMethod: data.memorizationMethod,
      memorizationData: data.memorizationData,
      revisionMethod: data.revisionMethod,
      revisionData: data.revisionData,
      notes: data.notes,
      encouragementMessage: data.encouragementMessage,
    );
  }

  MemorizationPlan _mapPlan(PlansTableData data) {
    return MemorizationPlan(
      studentId: data.studentId,
      attendanceDaysPerWeek: data.attendanceDaysPerWeek,
      dailyLinesCount: data.dailyLinesCount,
      direction: data.direction,
      startSurah: data.startSurah,
      startVerse: data.startVerse,
      endSurah: data.endSurah,
      endVerse: data.endVerse,
      notes: data.notes,
    );
  }

  Future<void> _cleanupOldRecords(String studentId) async {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 60));

    await (_db.delete(_db.attendanceTable)
          ..where((a) =>
              a.studentId.equals(studentId) &
              a.date.isSmallerThan(Variable(cutoffDate))))
        .go();

    await (_db.delete(_db.dailyRecordsTable)
          ..where((r) =>
              r.studentId.equals(studentId) &
              r.date.isSmallerThan(Variable(cutoffDate))))
        .go();
  }

  @override
  Future<Attendance?> getAttendance(String studentId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final data = await (_db.select(_db.attendanceTable)
          ..where((a) =>
              a.studentId.equals(studentId) &
              a.date.isBetweenValues(startOfDay, endOfDay)))
        .getSingleOrNull();

    return data != null ? _mapAttendance(data) : null;
  }

  @override
  Future<void> saveAttendance(Attendance attendance) async {
    await _cleanupOldRecords(attendance.studentId);

    final startOfDay = DateTime(
      attendance.date.year,
      attendance.date.month,
      attendance.date.day,
    );
    final endOfDay = DateTime(
      attendance.date.year,
      attendance.date.month,
      attendance.date.day,
      23,
      59,
      59,
    );

    final existing = await (_db.select(_db.attendanceTable)
          ..where((a) =>
              a.studentId.equals(attendance.studentId) &
              a.date.isBetweenValues(startOfDay, endOfDay)))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.attendanceTable)
            ..where((a) => a.id.equals(existing.id)))
          .write(
        AttendanceTableCompanion(
          isAbsent: Value(attendance.isAbsent),
          arrivalTime: Value(attendance.arrivalTime),
          departureTime: Value(attendance.departureTime),
        ),
      );
    } else {
      await _db.into(_db.attendanceTable).insert(
            AttendanceTableCompanion.insert(
              id: attendance.id,
              studentId: attendance.studentId,
              date: attendance.date,
              isAbsent: Value(attendance.isAbsent),
              arrivalTime: Value(attendance.arrivalTime),
              departureTime: Value(attendance.departureTime),
            ),
          );
    }
  }

  @override
  Future<double> getDailyAttendanceRate(String teacherId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final students = await (_db.select(_db.studentsTable)
          ..where((s) => s.teacherId.equals(teacherId)))
        .get();
    if (students.isEmpty) return 0;

    final studentIds = students.map((s) => s.id).toList();
    final attendance = await (_db.select(_db.attendanceTable)
          ..where((a) =>
              a.studentId.isIn(studentIds) &
              a.date.isBetweenValues(startOfDay, endOfDay)))
        .get();

    final presentCount = attendance.where((a) => !a.isAbsent).length;
    return (presentCount / students.length) * 100;
  }

  @override
  Future<DailyRecord?> getDailyRecord(String studentId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final data = await (_db.select(_db.dailyRecordsTable)
          ..where((r) =>
              r.studentId.equals(studentId) &
              r.date.isBetweenValues(startOfDay, endOfDay)))
        .getSingleOrNull();

    return data != null ? _mapDailyRecord(data) : null;
  }

  @override
  Future<void> saveDailyRecord(DailyRecord record) async {
    await _cleanupOldRecords(record.studentId);

    final startOfDay =
        DateTime(record.date.year, record.date.month, record.date.day);
    final endOfDay = DateTime(
      record.date.year,
      record.date.month,
      record.date.day,
      23,
      59,
      59,
    );

    final existing = await (_db.select(_db.dailyRecordsTable)
          ..where((r) =>
              r.studentId.equals(record.studentId) &
              r.date.isBetweenValues(startOfDay, endOfDay)))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.dailyRecordsTable)
            ..where((r) => r.id.equals(existing.id)))
          .write(
        DailyRecordsTableCompanion(
          memorizationMethod: Value(record.memorizationMethod),
          memorizationData: Value(record.memorizationData),
          memorizationGrade: Value(record.memorizationGrade),
          revisionMethod: Value(record.revisionMethod),
          revisionData: Value(record.revisionData),
          revisionGrade: Value(record.revisionGrade),
          teacherNotes: Value(record.teacherNotes),
          encouragementMessage: Value(record.encouragementMessage),
        ),
      );
    } else {
      await _db.into(_db.dailyRecordsTable).insert(
            DailyRecordsTableCompanion.insert(
              id: record.id,
              studentId: record.studentId,
              date: record.date,
              memorizationMethod: record.memorizationMethod,
              memorizationData: record.memorizationData,
              memorizationGrade: record.memorizationGrade,
              revisionMethod: record.revisionMethod,
              revisionData: record.revisionData,
              revisionGrade: record.revisionGrade,
              teacherNotes: Value(record.teacherNotes),
              encouragementMessage: Value(record.encouragementMessage),
            ),
          );
    }
  }

  @override
  Future<List<DailyRecord>> getDailyArchive(String studentId) async {
    final list = await (_db.select(_db.dailyRecordsTable)
          ..where((r) => r.studentId.equals(studentId))
          ..orderBy([
            (r) => OrderingTerm(expression: r.date, mode: OrderingMode.desc)
          ]))
        .get();
    return list.map(_mapDailyRecord).toList();
  }

  @override
  Future<TomorrowPlan?> getTomorrowPlan(String studentId) async {
    final data = await (_db.select(_db.tomorrowMemorizationTable)
          ..where((t) => t.studentId.equals(studentId)))
        .getSingleOrNull();
    return data != null ? _mapTomorrowPlan(data) : null;
  }

  @override
  Future<void> saveTomorrowPlan(TomorrowPlan plan) async {
    final existing = await (_db.select(_db.tomorrowMemorizationTable)
          ..where((t) => t.studentId.equals(plan.studentId)))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.tomorrowMemorizationTable)
            ..where((t) => t.studentId.equals(plan.studentId)))
          .write(
        TomorrowMemorizationTableCompanion(
          memorizationMethod: Value(plan.memorizationMethod),
          memorizationData: Value(plan.memorizationData),
          revisionMethod: Value(plan.revisionMethod),
          revisionData: Value(plan.revisionData),
          notes: Value(plan.notes),
          encouragementMessage: Value(plan.encouragementMessage),
        ),
      );
    } else {
      await _db.into(_db.tomorrowMemorizationTable).insert(
            TomorrowMemorizationTableCompanion.insert(
              studentId: plan.studentId,
              memorizationMethod: plan.memorizationMethod,
              memorizationData: plan.memorizationData,
              revisionMethod: plan.revisionMethod,
              revisionData: plan.revisionData,
              notes: Value(plan.notes),
              encouragementMessage: Value(plan.encouragementMessage),
            ),
          );
    }
  }

  @override
  Future<MemorizationPlan?> getMemorizationPlan(String studentId) async {
    final data = await (_db.select(_db.plansTable)
          ..where((p) => p.studentId.equals(studentId)))
        .getSingleOrNull();
    return data != null ? _mapPlan(data) : null;
  }

  @override
  Future<void> saveMemorizationPlan(MemorizationPlan plan) async {
    final existing = await (_db.select(_db.plansTable)
          ..where((p) => p.studentId.equals(plan.studentId)))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.plansTable)
            ..where((p) => p.studentId.equals(plan.studentId)))
          .write(
        PlansTableCompanion(
          attendanceDaysPerWeek: Value(plan.attendanceDaysPerWeek),
          dailyLinesCount: Value(plan.dailyLinesCount),
          direction: Value(plan.direction),
          startSurah: Value(plan.startSurah),
          startVerse: Value(plan.startVerse),
          endSurah: Value(plan.endSurah),
          endVerse: Value(plan.endVerse),
          notes: Value(plan.notes),
        ),
      );
    } else {
      await _db.into(_db.plansTable).insert(
            PlansTableCompanion.insert(
              studentId: plan.studentId,
              attendanceDaysPerWeek: Value(plan.attendanceDaysPerWeek),
              dailyLinesCount: Value(plan.dailyLinesCount),
              direction: Value(plan.direction),
              startSurah: plan.startSurah,
              startVerse: plan.startVerse,
              endSurah: plan.endSurah,
              endVerse: plan.endVerse,
              notes: Value(plan.notes),
            ),
          );
    }
  }

  @override
  Future<ParentSchedule?> getParentSchedule(String studentId) async {
    final data = await (_db.select(_db.schedulesTable)
          ..where((s) => s.studentId.equals(studentId)))
        .getSingleOrNull();

    if (data == null) return null;
    return ParentSchedule(
      studentId: data.studentId,
      lessonsJson: data.lessonsJson,
      lastModified: data.lastModified,
      modificationHistoryJson: data.modificationHistoryJson,
    );
  }

  @override
  Future<void> saveParentSchedule(String studentId, String lessonsJson) async {
    final existing = await (_db.select(_db.schedulesTable)
          ..where((s) => s.studentId.equals(studentId)))
        .getSingleOrNull();

    final now = DateTime.now();
    String history = 'Created at $now';
    if (existing != null) {
      history = '${existing.modificationHistoryJson ?? ""}\nModified at $now';
      await (_db.update(_db.schedulesTable)
            ..where((s) => s.studentId.equals(studentId)))
          .write(
        SchedulesTableCompanion(
          lessonsJson: Value(lessonsJson),
          lastModified: Value(now),
          modificationHistoryJson: Value(history),
        ),
      );
    } else {
      await _db.into(_db.schedulesTable).insert(
            SchedulesTableCompanion.insert(
              studentId: studentId,
              lessonsJson: lessonsJson,
              lastModified: now,
              modificationHistoryJson: Value(history),
            ),
          );
    }
  }

  @override
  Future<void> copyTodayToTomorrow(String studentId, DateTime date) async {
    final todayRecord = await getDailyRecord(studentId, date);
    if (todayRecord == null) return;

    await saveTomorrowPlan(TomorrowPlan(
      studentId: studentId,
      memorizationMethod: todayRecord.memorizationMethod,
      memorizationData: todayRecord.memorizationData,
      revisionMethod: todayRecord.revisionMethod,
      revisionData: todayRecord.revisionData,
      notes: todayRecord.teacherNotes,
      encouragementMessage: todayRecord.encouragementMessage,
    ));
  }

  @override
  Future<void> runMidnightTransfer(String studentId, DateTime nextDay) async {
    final plan = await getTomorrowPlan(studentId);
    if (plan == null) return;

    await saveDailyRecord(
      DailyRecord(
        id: 'AUTO_${studentId}_${nextDay.year}_${nextDay.month}_${nextDay.day}',
        studentId: studentId,
        date: nextDay,
        memorizationMethod: plan.memorizationMethod,
        memorizationData: plan.memorizationData,
        memorizationGrade: 'postponed',
        revisionMethod: plan.revisionMethod,
        revisionData: plan.revisionData,
        revisionGrade: 'postponed',
        teacherNotes: plan.notes,
        encouragementMessage: plan.encouragementMessage,
      ),
    );
  }

  @override
  Future<void> deleteTomorrowPlan(String studentId) async {
    await (_db.delete(_db.tomorrowMemorizationTable)
          ..where((t) => t.studentId.equals(studentId)))
        .go();
  }
}
