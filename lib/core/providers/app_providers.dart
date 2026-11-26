import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athar/core/database/database_provider.dart';
import 'package:athar/core/models/models.dart';
import 'package:athar/features/student/domain/student_repository.dart';
import 'package:athar/features/student/data/student_repository_impl.dart';
import 'package:athar/features/student/domain/record_repository.dart';
import 'package:athar/features/student/data/record_repository_impl.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return StudentRepositoryImpl(db);
});

final recordRepositoryProvider = Provider<RecordRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return RecordRepositoryImpl(db);
});

// Auto-refreshable List of Students for a given Teacher
final teacherStudentsProvider = FutureProvider.family<List<Student>, String>((ref, teacherId) async {
  return ref.watch(studentRepositoryProvider).getStudentsForTeacher(teacherId);
});

// Student Profile Detail Provider
final studentProfileProvider = FutureProvider.family<Student?, String>((ref, studentId) async {
  return ref.watch(studentRepositoryProvider).getStudentById(studentId);
});

// Current Record parameters
final studentAttendanceProvider = FutureProvider.family<Attendance?, ({String studentId, DateTime date})>((ref, arg) async {
  return ref.watch(recordRepositoryProvider).getAttendance(arg.studentId, arg.date);
});

final studentDailyRecordProvider = FutureProvider.family<DailyRecord?, ({String studentId, DateTime date})>((ref, arg) async {
  return ref.watch(recordRepositoryProvider).getDailyRecord(arg.studentId, arg.date);
});

final studentTomorrowPlanProvider = FutureProvider.family<TomorrowPlan?, String>((ref, studentId) async {
  return ref.watch(recordRepositoryProvider).getTomorrowPlan(studentId);
});

final studentMemorizationPlanProvider = FutureProvider.family<MemorizationPlan?, String>((ref, studentId) async {
  return ref.watch(recordRepositoryProvider).getMemorizationPlan(studentId);
});

final studentDailyArchiveProvider = FutureProvider.family<List<DailyRecord>, String>((ref, studentId) async {
  return ref.watch(recordRepositoryProvider).getDailyArchive(studentId);
});

final studentScheduleProvider = FutureProvider.family<ParentSchedule?, String>((ref, studentId) async {
  return ref.watch(recordRepositoryProvider).getParentSchedule(studentId);
});
