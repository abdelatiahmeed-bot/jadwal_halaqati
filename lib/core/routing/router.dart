import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';
import 'package:athar/core/theme/motion.dart';
import 'package:athar/features/auth/presentation/teacher_auth_screen.dart';
import 'package:athar/features/auth/presentation/parent_auth_screen.dart';
import 'package:athar/features/admin/presentation/admin_dashboard.dart';
import 'package:athar/features/teacher/presentation/teacher_dashboard.dart';
import 'package:athar/features/student/presentation/student_profile_screen.dart';
import 'package:athar/features/parent/presentation/parent_dashboard.dart';
import 'package:athar/features/jadwal/presentation/jadwal_home_screen.dart';
import 'package:athar/features/jadwal/presentation/student_schedule_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  Page<dynamic> buildSharedAxisPage(
    GoRouterState state,
    Widget child, {
    SharedAxisTransitionType transitionType = SharedAxisTransitionType.horizontal,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: AppMotion.medium,
      reverseTransitionDuration: AppMotion.quick,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (AppMotion.prefersReducedMotion(context)) {
          return child;
        }
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: transitionType,
          child: child,
        );
      },
    );
  }

  Page<dynamic> buildFadeThroughPage(GoRouterState state, Widget child) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: AppMotion.medium,
      reverseTransitionDuration: AppMotion.quick,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (AppMotion.prefersReducedMotion(context)) {
          return child;
        }
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  return GoRouter(
    initialLocation: '/',
    routes: [
      // Entry / Jadwal Halaqati Home Screen
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => buildFadeThroughPage(state, const JadwalHomeScreen()),
      ),

      // Dedicated Student Schedule Screen
      GoRoute(
        path: '/student/:id',
        pageBuilder: (context, state) {
          final studentId = state.pathParameters['id']!;
          return buildSharedAxisPage(
            state,
            StudentScheduleScreen(studentId: studentId),
            transitionType: SharedAxisTransitionType.horizontal,
          );
        },
      ),
      
      // Teacher Auth Screen
      GoRoute(
        path: '/teacher/auth',
        pageBuilder: (context, state) => buildSharedAxisPage(
          state,
          const TeacherAuthScreen(),
          transitionType: SharedAxisTransitionType.scaled,
        ),
      ),

      // Parent Auth Screen
      GoRoute(
        path: '/parent/auth',
        pageBuilder: (context, state) => buildSharedAxisPage(
          state,
          const ParentAuthScreen(),
          transitionType: SharedAxisTransitionType.scaled,
        ),
      ),

      // Admin Dashboard Screen
      GoRoute(
        path: '/admin',
        pageBuilder: (context, state) => buildFadeThroughPage(state, const AdminDashboardScreen()),
      ),

      // Teacher Dashboard Screen
      GoRoute(
        path: '/teacher',
        pageBuilder: (context, state) => buildFadeThroughPage(state, const TeacherDashboardScreen()),
      ),

      // Student Profile Screen (Detailed logs, plan, archive)
      GoRoute(
        path: '/teacher/student/:id',
        pageBuilder: (context, state) {
          final studentId = state.pathParameters['id']!;
          return buildSharedAxisPage(
            state,
            StudentProfileScreen(studentId: studentId),
            transitionType: SharedAxisTransitionType.horizontal,
          );
        },
      ),

      // Parent Dashboard Screen
      GoRoute(
        path: '/parent',
        pageBuilder: (context, state) => buildFadeThroughPage(state, const ParentDashboardScreen()),
      ),
    ],
  );
});
