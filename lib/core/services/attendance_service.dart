import 'package:drift/drift.dart';
import 'package:athar/core/database/app_database.dart';

class AttendanceService {
  /// Checks if the teacher has recorded today's attendance for all students.
  /// Returns false if at least one student is not recorded yet.
  static Future<bool> isTodayAttendanceCompleted(AppDatabase db, String teacherId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final students = await (db.select(db.studentsTable)
          ..where((s) => s.teacherId.equals(teacherId)))
        .get();

    if (students.isEmpty) return true;

    final todayAttendance = await (db.select(db.attendanceTable)
          ..where((a) => a.date.isBetweenValues(startOfDay, endOfDay)))
        .get();

    final recordedStudentIds = todayAttendance.map((a) => a.studentId).toSet();
    return students.every((s) => recordedStudentIds.contains(s.id));
  }

  /// Automatically marks all unrecorded students as absent at midnight or when reviewing past dates.
  static Future<int> autoMarkMidnightAbsence(AppDatabase db, String teacherId) async {
    final now = DateTime.now();
    // Yesterday or earlier dates where attendance was left unfinished
    final yesterday = now.subtract(const Duration(days: 1));
    final startOfYesterday = DateTime(yesterday.year, yesterday.month, yesterday.day);
    final endOfYesterday = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);

    final students = await (db.select(db.studentsTable)
          ..where((s) => s.teacherId.equals(teacherId)))
        .get();

    if (students.isEmpty) return 0;

    final yesterdayRecords = await (db.select(db.attendanceTable)
          ..where((a) => a.date.isBetweenValues(startOfYesterday, endOfYesterday)))
        .get();

    final recordedIds = yesterdayRecords.map((a) => a.studentId).toSet();
    int markedCount = 0;

    for (final s in students) {
      if (!recordedIds.contains(s.id)) {
        await db.into(db.attendanceTable).insertOnConflictUpdate(
              AttendanceTableCompanion.insert(
                id: 'ATT_${s.id}_${yesterday.year}_${yesterday.month}_${yesterday.day}',
                studentId: s.id,
                date: startOfYesterday,
                isAbsent: const Value(true),
              ),
            );
        markedCount++;
      }
    }

    return markedCount;
  }
}
