import 'package:drift/drift.dart';
import 'package:athar/core/database/app_database.dart';
import 'package:athar/core/models/models.dart';
import 'package:athar/features/student/domain/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final AppDatabase _db;

  StudentRepositoryImpl(this._db);

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
  Future<List<Student>> getStudentsForTeacher(String teacherId) async {
    final list = await (_db.select(_db.studentsTable)
          ..where((s) => s.teacherId.equals(teacherId)))
        .get();
    return list.map(_mapStudent).toList();
  }

  @override
  Future<Student?> getStudentById(String studentId) async {
    final data = await (_db.select(_db.studentsTable)
          ..where((s) => s.id.equals(studentId)))
        .getSingleOrNull();
    return data != null ? _mapStudent(data) : null;
  }

  @override
  Future<void> addStudent(Student student) async {
    await _db.into(_db.studentsTable).insert(
          StudentsTableCompanion.insert(
            id: student.id,
            name: student.name,
            parentName: student.parentName,
            parentPhone: student.parentPhone,
            loginCode: student.loginCode,
            teacherId: Value(student.teacherId),
            points: Value(student.points),
            stars: Value(student.stars),
            achievementLevel: Value(student.achievementLevel),
            monthlySubscription: Value(student.monthlySubscription),
          ),
        );

    if (student.teacherId != null) {
      await _updateTeacherStudentCount(student.teacherId!);
    }
  }

  @override
  Future<void> updateStudent(Student student) async {
    await (_db.update(_db.studentsTable)..where((s) => s.id.equals(student.id)))
        .write(
      StudentsTableCompanion(
        name: Value(student.name),
        parentName: Value(student.parentName),
        parentPhone: Value(student.parentPhone),
        loginCode: Value(student.loginCode),
        teacherId: Value(student.teacherId),
        points: Value(student.points),
        stars: Value(student.stars),
        achievementLevel: Value(student.achievementLevel),
        monthlySubscription: Value(student.monthlySubscription),
      ),
    );

    if (student.teacherId != null) {
      await _updateTeacherStudentCount(student.teacherId!);
    }
  }

  @override
  Future<void> deleteStudent(String studentId) async {
    final student = await getStudentById(studentId);
    await (_db.delete(_db.studentsTable)..where((s) => s.id.equals(studentId)))
        .go();

    if (student?.teacherId != null) {
      await _updateTeacherStudentCount(student!.teacherId!);
    }
  }

  @override
  Future<void> transferStudent(String studentId, String targetTeacherId) async {
    final student = await getStudentById(studentId);
    final oldTeacherId = student?.teacherId;

    await (_db.update(_db.studentsTable)..where((s) => s.id.equals(studentId)))
        .write(
      StudentsTableCompanion(
        teacherId: Value(targetTeacherId),
      ),
    );

    if (oldTeacherId != null) {
      await _updateTeacherStudentCount(oldTeacherId);
    }
    await _updateTeacherStudentCount(targetTeacherId);
  }

  @override
  Future<void> updateStudentRewards(
    String studentId,
    int pointsToAdd,
    int starsToAdd,
  ) async {
    final student = await getStudentById(studentId);
    if (student == null) return;

    final newPoints = student.points + pointsToAdd;
    final newStars = student.stars + starsToAdd;

    String level = student.achievementLevel;
    if (newPoints >= 200) {
      level = 'فارس الحلقة';
    } else if (newPoints >= 150) {
      level = 'الدرة الذهبية';
    } else if (newPoints >= 100) {
      level = 'حافظ مميز';
    } else if (newPoints >= 50) {
      level = 'مبادر الفجر';
    }

    await (_db.update(_db.studentsTable)..where((s) => s.id.equals(studentId)))
        .write(
      StudentsTableCompanion(
        points: Value(newPoints),
        stars: Value(newStars),
        achievementLevel: Value(level),
      ),
    );
  }

  Future<void> _updateTeacherStudentCount(String teacherId) async {
    final count = await (_db.select(_db.studentsTable)
          ..where((s) => s.teacherId.equals(teacherId)))
        .get();

    await (_db.update(_db.teachersTable)..where((t) => t.id.equals(teacherId)))
        .write(
      TeachersTableCompanion(
        studentCount: Value(count.length),
      ),
    );
  }
}
