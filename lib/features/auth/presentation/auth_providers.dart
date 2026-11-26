import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athar/core/database/database_provider.dart';
import 'package:athar/core/models/models.dart';
import 'package:athar/features/auth/domain/auth_repository.dart';
import 'package:athar/features/auth/data/auth_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return AuthRepositoryImpl(db);
});

final activeTeachersProvider = FutureProvider<List<Teacher>>((ref) async {
  return ref.watch(authRepositoryProvider).getActiveTeachers();
});

// Teacher Session Notifier
class CurrentTeacherNotifier extends StateNotifier<Teacher?> {
  CurrentTeacherNotifier() : super(
    const Teacher(
      id: 'T1',
      fullName: 'احمد محمد عبد العاطى',
      phoneNumber: '0501234567',
      loginCode: '1234',
      isActive: true,
      studentCount: 0,
    ),
  );

  void login(Teacher teacher) {
    state = teacher;
  }

  void logout() {
    state = null;
  }
}

final currentTeacherProvider = StateNotifierProvider<CurrentTeacherNotifier, Teacher?>((ref) {
  return CurrentTeacherNotifier();
});

// Parent/Student Session Notifier
class CurrentStudentNotifier extends StateNotifier<Student?> {
  CurrentStudentNotifier() : super(null);

  void login(Student student) {
    state = student;
  }

  void logout() {
    state = null;
  }
}

final currentStudentProvider = StateNotifierProvider<CurrentStudentNotifier, Student?>((ref) {
  return CurrentStudentNotifier();
});

// Admin Session Notifier
class AdminAuthNotifier extends StateNotifier<bool> {
  AdminAuthNotifier() : super(false);

  void login() {
    state = true;
  }

  void logout() {
    state = false;
  }
}

final isAdminLoggedInProvider = StateNotifierProvider<AdminAuthNotifier, bool>((ref) {
  return AdminAuthNotifier();
});
