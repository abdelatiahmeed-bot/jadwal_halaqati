import 'package:athar/core/models/models.dart';

abstract class RecordRepository {
  // Attendance
  Future<Attendance?> getAttendance(String studentId, DateTime date);
  Future<void> saveAttendance(Attendance attendance);
  Future<double> getDailyAttendanceRate(String teacherId, DateTime date);

  // Daily Progress Record (Memorization & Revision)
  Future<DailyRecord?> getDailyRecord(String studentId, DateTime date);
  Future<void> saveDailyRecord(DailyRecord record);
  Future<List<DailyRecord>> getDailyArchive(String studentId);

  // Tomorrow Memorization Plan
  Future<TomorrowPlan?> getTomorrowPlan(String studentId);
  Future<void> saveTomorrowPlan(TomorrowPlan plan);

  // Memorization Plan (General Plan)
  Future<MemorizationPlan?> getMemorizationPlan(String studentId);
  Future<void> saveMemorizationPlan(MemorizationPlan plan);

  // Parent School/Lessons Schedule
  Future<ParentSchedule?> getParentSchedule(String studentId);
  Future<void> saveParentSchedule(String studentId, String lessonsJson);

  // Special Sync Routines
  Future<void> copyTodayToTomorrow(String studentId, DateTime date);
  Future<void> runMidnightTransfer(String studentId, DateTime nextDay);
  Future<void> deleteTomorrowPlan(String studentId);
}
