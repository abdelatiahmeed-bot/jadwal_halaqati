import 'package:athar/core/models/models.dart';

abstract class StudentRepository {
  Future<List<Student>> getStudentsForTeacher(String teacherId);
  Future<Student?> getStudentById(String studentId);
  Future<void> addStudent(Student student);
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(String studentId);
  Future<void> transferStudent(String studentId, String targetTeacherId);
  
  // Progress/Stars/Points updates
  Future<void> updateStudentRewards(String studentId, int pointsToAdd, int starsToAdd);
}
