import 'package:drift/drift.dart';
import 'package:athar/core/database/app_database.dart';
import 'package:athar/core/models/models.dart';
import 'package:athar/features/auth/domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AppDatabase _db;

  AuthRepositoryImpl(this._db);

  Future<void> initMockDataIfNeeded() async {
    final teachersCount = await _db.select(_db.teachersTable).get();
    if (teachersCount.isNotEmpty) {
      await (_db.update(_db.teachersTable)..where((t) => t.id.equals('T1')))
          .write(
        const TeachersTableCompanion(
          fullName: Value('احمد محمد عبد العاطى'),
        ),
      );
      return;
    }

    final teachers = [
      const TeachersTableCompanion(
        id: Value('T1'),
        fullName: Value('احمد محمد عبد العاطى'),
        phoneNumber: Value('0501234567'),
        loginCode: Value('1234'),
        isActive: Value(true),
        studentCount: Value(0),
      ),
    ];

    for (final teacher in teachers) {
      await _db.into(_db.teachersTable).insert(teacher);
    }
  }

  Teacher _mapTeacher(TeachersTableData data) {
    return Teacher(
      id: data.id,
      fullName: data.fullName,
      phoneNumber: data.phoneNumber,
      loginCode: data.loginCode,
      isActive: data.isActive,
      studentCount: data.studentCount,
    );
  }

  Student _mapStudent(StudentsTableData data) {
    return Student(
      id: data.id,
      name: data.name,
      parentName: data.parentName,
      parentPhone: data.parentPhone,
      loginCode: data.loginCode,
      teacherId: data.teacherId,
      points: data.points,
      stars: data.stars,
      achievementLevel: data.achievementLevel,
      monthlySubscription: data.monthlySubscription,
    );
  }

  @override
  Future<List<Teacher>> getActiveTeachers() async {
    await initMockDataIfNeeded();
    final list = await (_db.select(_db.teachersTable)
          ..where((t) => t.isActive.equals(true)))
        .get();
    return list.map(_mapTeacher).toList();
  }

  @override
  Future<Teacher?> loginTeacher(String teacherId, String loginCode) async {
    await initMockDataIfNeeded();
    final teacher = await (_db.select(_db.teachersTable)
          ..where((t) =>
              t.id.equals(teacherId) &
              t.loginCode.equals(loginCode) &
              t.isActive.equals(true)))
        .getSingleOrNull();
    return teacher != null ? _mapTeacher(teacher) : null;
  }

  @override
  Future<Student?> loginParent(String teacherId, String studentCode) async {
    await initMockDataIfNeeded();
    final student = await (_db.select(_db.studentsTable)
          ..where((s) =>
              s.teacherId.equals(teacherId) & s.loginCode.equals(studentCode)))
        .getSingleOrNull();
    return student != null ? _mapStudent(student) : null;
  }

  @override
  Future<bool> loginAdmin(String username, String password) async {
    return username.trim().toLowerCase() == 'admin' && password == 'admin123';
  }
}
