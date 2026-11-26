import 'package:athar/core/models/models.dart';

abstract class AuthRepository {
  Future<List<Teacher>> getActiveTeachers();
  Future<Teacher?> loginTeacher(String teacherId, String loginCode);
  Future<Student?> loginParent(String teacherId, String studentCode);
  Future<bool> loginAdmin(String username, String password);
}
