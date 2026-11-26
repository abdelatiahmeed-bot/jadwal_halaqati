import 'package:athar/core/widgets/app_notification.dart';
import 'package:athar/core/services/attendance_service.dart';
import 'package:athar/core/services/backup_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:athar/core/localization/app_localizations.dart';
import 'package:athar/core/theme/theme.dart';
import 'package:athar/features/auth/presentation/auth_providers.dart';
import 'package:athar/core/providers/app_providers.dart';
import 'package:athar/core/utils/whatsapp_launcher.dart';
import 'package:athar/core/models/models.dart';
import 'package:athar/core/database/app_database.dart';
import 'package:athar/core/database/database_provider.dart';
import 'package:athar/core/widgets/islamic_pattern.dart';
import 'package:athar/core/widgets/fade_in_slide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:athar/core/theme/motion.dart';
import 'package:athar/core/utils/report_generator.dart';
import 'package:share_plus/share_plus.dart';

// Stream today's attendance records
final todayAttendanceProvider =
    StreamProvider.family<List<AttendanceTableData>, DateTime>((ref, date) {
  final db = ref.watch(databaseProvider);
  final startOfDay = DateTime(date.year, date.month, date.day);
  final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
  return (db.select(db.attendanceTable)
        ..where((a) => a.date.isBetweenValues(startOfDay, endOfDay)))
      .watch();
});

// Stream today's daily records
final todayDailyRecordsProvider =
    StreamProvider.family<List<DailyRecordsTableData>, DateTime>((ref, date) {
  final db = ref.watch(databaseProvider);
  final startOfDay = DateTime(date.year, date.month, date.day);
  final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
  return (db.select(db.dailyRecordsTable)
        ..where((r) => r.date.isBetweenValues(startOfDay, endOfDay)))
      .watch();
});

final localTeacherStudentsProvider =
    StreamProvider.family<List<Student>, String>((ref, teacherId) {
  final db = ref.watch(databaseProvider);
  unawaited(
      ref.read(studentRepositoryProvider).getStudentsForTeacher(teacherId));
  return (db.select(db.studentsTable)
        ..where((s) => s.teacherId.equals(teacherId)))
      .watch()
      .map(
        (rows) => rows
            .map(
              (s) => Student(
                id: s.id,
                name: s.name,
                parentName: s.parentName,
                parentPhone: s.parentPhone,
                loginCode: s.loginCode,
                teacherId: s.teacherId,
                points: s.points,
                stars: s.stars,
                achievementLevel: s.achievementLevel,
                monthlySubscription: s.monthlySubscription,
              ),
            )
            .toList(),
      );
});

class TeacherDashboardScreen extends ConsumerStatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  ConsumerState<TeacherDashboardScreen> createState() =>
      _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState
    extends ConsumerState<TeacherDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final teacher = ref.read(currentTeacherProvider);
      if (teacher != null) {
        AttendanceService.autoMarkMidnightAbsence(ref.read(databaseProvider), teacher.id);
      }
    });
  }

  Future<void> _showBackupRestoreDialog(BuildContext context, WidgetRef ref) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: IslamicTheme.goldMetallic.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.cloud_sync_rounded, color: IslamicTheme.oliveDeep),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'النسخ الاحتياطي السحابي للبيانات',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'يمكنك حفظ نسخة كاملة من بيانات الحلقة على Google Drive أو إرسالها لنفسك عبر الواتساب، أو استرجاع بياناتك في حال تغيير الهاتف.',
                  style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    try {
                      final db = ref.read(databaseProvider);
                      await BackupService.shareBackup(db);
                      if (context.mounted) {
                        AppNotification.showSuccess(context, 'تم تجهيز ملف النسخة الاحتياطية بنجاح');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        AppNotification.showError(context, 'خطأ أثناء النسخ الاحتياطي: $e');
                      }
                    }
                  },
                  icon: const Icon(Icons.cloud_upload_rounded, color: Colors.white),
                  label: Text('حفظ نسخة احتياطية سحابياً (.athar)', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: IslamicTheme.oliveDeep,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    try {
                      final db = ref.read(databaseProvider);
                      final result = await BackupService.restoreFromFile(db);
                      if (result != null && context.mounted) {
                        AppNotification.showSuccess(
                          context,
                          'تمت استعادة البيانات بنجاح: ${result.studentsCount} طالب، ${result.recordsCount} سجل تسميع.',
                        );
                        final teacher = ref.read(currentTeacherProvider);
                        if (teacher != null) {
                          ref.invalidate(localTeacherStudentsProvider(teacher.id));
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        AppNotification.showError(context, 'فشل استرجاع النسخة: $e');
                      }
                    }
                  },
                  icon: const Icon(Icons.restore_page_rounded),
                  label: Text('استرجاع البيانات من ملف سابق (.athar)', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendBatchReportsDialog(
    BuildContext context,
    WidgetRef ref,
    String teacherId,
    List<Student> students,
  ) async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final todayRecords = await (db.select(db.dailyRecordsTable)
          ..where((r) => r.date.isBetweenValues(startOfDay, endOfDay)))
        .get();

    final recordedStudentIds = todayRecords.map((r) => r.studentId).toSet();
    final readyStudents = students.where((s) => recordedStudentIds.contains(s.id)).toList();

    if (!context.mounted) return;

    if (readyStudents.isEmpty) {
      AppNotification.showWarning(context, 'لم يتم تسجيل لوح اليوم لأي طالب بعد لإرسال التقارير.');
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('إرسال تقارير اليوم دفعة واحدة', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تم رصد (${readyStudents.length}) طالب تم حفظ لوح اليوم لهم وجاهزون للإرسال.',
              style: GoogleFonts.cairo(fontSize: 13),
            ),
            const SizedBox(height: 10),
            Text(
              'سيتم فتح تطبيق واتساب تباعاً لإرسال التقرير المنسق لكل ولي أمر بنقرة واحدة.',
              style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[700]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(ctx);
              for (final st in readyStudents) {
                if (st.parentPhone.trim().isNotEmpty) {
                  final rec = todayRecords.firstWhere((r) => r.studentId == st.id);
                  final msg = 'السلام عليكم ورحمة الله وبركاته،\n'
                      'تقرير إنجاز الطالب: *${st.name}* ليوم ${now.year}/${now.month}/${now.day}:\n\n'
                      '📖 *لوح اليوم:* تم التسميع بنجاح\n'
                      'بارك الله في جهودكم ونسأل الله له التوفيق والبركة 🌟';
                  await WhatsAppLauncher.sendDirectReport(
                    phone: st.parentPhone,
                    message: msg,
                  );
                  await Future.delayed(const Duration(milliseconds: 600));
                }
              }
              if (context.mounted) {
                AppNotification.showSuccess(context, 'تم تجهيز تقارير الطلاب على الواتساب بنجاح');
              }
            },
            icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
            label: const Text('بدء الإرسال الآن'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E6B38),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teacher = ref.watch(currentTeacherProvider);

    if (teacher == null) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('تسجيل الدخول أولاً'),
          ),
        ),
      );
    }

    final studentsAsync = ref.watch(localTeacherStudentsProvider(teacher.id));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('لوحة المعلم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_sync_rounded, color: IslamicTheme.goldMetallic),
            tooltip: 'النسخ الاحتياطي السحابي والاسترجاع',
            onPressed: () => _showBackupRestoreDialog(context, ref),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: IslamicPatternBackground(),
          ),
          _buildHomeTab(teacher, studentsAsync),
        ],
      ),
    );
  }

  // 1. HOME TAB (Welcome + 3x3 Grid Actions)
  Widget _buildHomeTab(
      Teacher teacher, AsyncValue<List<Student>> studentsAsync) {
    return studentsAsync.when(
      data: (students) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Builder(
                builder: (context) {
                  final todayAtt = ref.watch(todayAttendanceProvider(DateTime.now())).valueOrNull ?? [];
                  final bool attendanceDone = students.isEmpty || students.every((s) => todayAtt.any((a) => a.studentId == s.id));
                  if (attendanceDone) return const SizedBox.shrink();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFEEBA), width: 1.2),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Color(0xFF856404), size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'تنبيه: لم يتم تسجيل الغياب اليوم! (يتم احتساب الغياب تلقائياً الساعة 12 منتصف الليل)',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: const Color(0xFF856404),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AbsenceScreen(teacherId: teacher.id)),
                          ),
                          child: Text('تسجيل الغياب', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Welcome message card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً أ. ${teacher.fullName}',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      'المشرف على حلقة تحفيظ التميز والتمكين للقرآن الكريم',
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 350.ms, curve: AppMotion.standard).slideY(begin: -0.06, end: 0),
              const SizedBox(height: 24),

              // 3x2 Quick Actions Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95,
                children: [
                  _buildActionCard(
                    'الطلاب',
                    Icons.people_outline_rounded,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              StudentsListScreen(teacherId: teacher.id)),
                    ),
                    0,
                  ),
                  _buildActionCard(
                    'إضافة طالب',
                    Icons.person_add_alt_1_outlined,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              AddStudentScreen(teacherId: teacher.id)),
                    ),
                    1,
                  ),
                  _buildActionCard(
                    'الغياب',
                    Icons.person_off_outlined,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              AbsenceScreen(teacherId: teacher.id)),
                    ),
                    2,
                  ),
                  _buildActionCard(
                    'لوحة الشرف',
                    Icons.emoji_events_outlined,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              HonorBoardScreen(teacherId: teacher.id)),
                    ),
                    3,
                  ),
                  _buildActionCard(
                    'التحصيل',
                    Icons.monetization_on_outlined,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              CollectionsScreen(teacherId: teacher.id)),
                    ),
                    4,
                  ),
                  _buildActionCard(
                    'التقارير',
                    Icons.bar_chart_rounded,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ReportsScreen(teacherId: teacher.id)),
                    ),
                    5,
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Full-width Delete Student Banner Card
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: Colors.red.withOpacity(0.35),
                    width: 1.2,
                  ),
                ),
                color: const Color(0xFFFDFCF9),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeleteStudentScreen(teacherId: teacher.id),
                    ),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_remove_outlined,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    'حذف طالب من الحلقة',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[900],
                    ),
                  ),
                  subtitle: Text(
                    'إدارة وإزالة طلاب من الحلقة وسجلاتهم بالكامل',
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const AppShimmer(width: double.infinity, height: 75),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.95,
              children: List.generate(
                6,
                (index) => const AppShimmer(width: double.infinity, height: 100),
              ),
            ),
            const SizedBox(height: 14),
            const AppShimmer(width: double.infinity, height: 60),
          ],
        ),
      ),
      error: (err, s) => Center(child: Text('خطأ: $err')),
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap, [int index = 0]) {
    return AppPressable(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFDFCF9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: const Color(0xFFC5A85A).withOpacity(0.25), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFC5A85A).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF34422B), size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: IslamicTheme.oliveLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 45).ms, duration: 320.ms, curve: AppMotion.standard).slideY(begin: 0.1, end: 0, delay: (index * 45).ms, duration: 320.ms, curve: AppMotion.standard);
  }

}

// ======================== DELETE STUDENT FULL SCREEN ========================
class DeleteStudentScreen extends ConsumerStatefulWidget {
  final String teacherId;
  const DeleteStudentScreen({super.key, required this.teacherId});

  @override
  ConsumerState<DeleteStudentScreen> createState() => _DeleteStudentScreenState();
}

class _DeleteStudentScreenState extends ConsumerState<DeleteStudentScreen> {
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(localTeacherStudentsProvider(widget.teacherId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('حذف طالب من الحلقة'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: IslamicPatternBackground()),
          studentsAsync.when(
            data: (students) {
              final filtered = students
                  .where((s) => s.name.contains(_searchQuery.trim()))
                  .toList();

              return Column(
                children: [
                  // Notice Card at top
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, color: Colors.red, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'تنبيه: حذف الطالب يؤدي إلى إزالة كافة سجلات الحفظ والتسميع والغياب والاشتراكات المرتبطة به نهائياً.',
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: Colors.red[900],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'ابحث باسم الطالب...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      ),
                      onChanged: (val) {
                        setState(() => _searchQuery = val);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),

                  // Students List
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.person_off_rounded, size: 56, color: Colors.grey[400]),
                                const SizedBox(height: 12),
                                Text(
                                  students.isEmpty
                                      ? 'لا يوجد طلاب مسجلون في هذه الحلقة حالياً'
                                      : 'لم يتم العثور على طالب بهذا الاسم',
                                  style: GoogleFonts.cairo(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, idx) {
                              final student = filtered[idx];
                              return Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: BorderSide(
                                    color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.4),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundColor: IslamicTheme.goldMetallic.withOpacity(0.18),
                                        foregroundColor: IslamicTheme.oliveDeep,
                                        child: Text(
                                          student.name.isNotEmpty ? student.name[0] : 'ط',
                                          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              student.name,
                                              style: GoogleFonts.cairo(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            if (student.parentPhone.isNotEmpty)
                                              Row(
                                                children: [
                                                  const Icon(Icons.phone_outlined, size: 12, color: Colors.grey),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'هاتف ولي الأمر: ${student.parentPhone}',
                                                    style: GoogleFonts.cairo(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            const SizedBox(height: 2),
                                            Row(
                                              children: [
                                                const Icon(Icons.monetization_on_outlined, size: 12, color: Colors.grey),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'الاشتراك الشهري: ${student.monthlySubscription} ج.م | النقاط: ${student.points}',
                                                  style: GoogleFonts.cairo(
                                                    fontSize: 10,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[800],
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                                        label: Text('حذف', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12)),
                                        onPressed: () async {
                                          final confirmed = await showDialog<bool>(
                                            context: context,
                                            builder: (c) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              title: Row(
                                                children: [
                                                  const Icon(Icons.warning_amber_rounded, color: Colors.red),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'تأكيد الحذف النهائي',
                                                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              content: Text(
                                                'هل أنت متأكد من حذف الطالب "${student.name}" نهائياً من الحلقة؟ لا يمكن استرجاع بياناته بعد الحذف.',
                                                style: GoogleFonts.cairo(fontSize: 13),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(c, false),
                                                  child: Text('إلغاء', style: GoogleFonts.cairo()),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor: Colors.white,
                                                  ),
                                                  onPressed: () => Navigator.pop(c, true),
                                                  child: Text(
                                                    'حذف نهائي',
                                                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirmed == true) {
                                            final repo = ref.read(studentRepositoryProvider);
                                            await repo.deleteStudent(student.id);
                                            ref.invalidate(localTeacherStudentsProvider(widget.teacherId));
                                            if (context.mounted) {
                                              AppNotification.showSuccess(context, 'تم حذف الطالب ${student.name} بنجاح');
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('خطأ: $err')),
          ),
        ],
      ),
    );
  }
}

// ======================== SECONDARY SCREENS ========================

// 1. ADD STUDENT SCREEN
class AddStudentScreen extends StatefulWidget {
  final String teacherId;
  const AddStudentScreen({super.key, required this.teacherId});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  late final String _generatedCode;
  int _monthlySubscription = 60;
  final _subCtrl = TextEditingController(text: "60");

  @override
  void initState() {
    super.initState();
    // Generate automatic login code: C followed by a 3-digit random number
    final int randomDigits =
        100 + (DateTime.now().microsecondsSinceEpoch % 900);
    _generatedCode = 'C$randomDigits';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _subCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة طالب جديد'),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: IslamicPatternBackground()),
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: FadeInSlide(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'تسجيل بيانات الطالب',
                    style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'اسم الطالب كامل',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(
                      labelText: 'رقم هاتف ولي الأمر (واتساب)',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'قيمة الاشتراك الشهري (التحصيل):',
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _subCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'المبلغ الشهري (ج.م)',
                      prefixIcon: Icon(Icons.attach_money_rounded),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      final parsed = int.tryParse(val.trim());
                      if (parsed != null) {
                        _monthlySubscription = parsed;
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                  Consumer(
                    builder: (context, ref, child) {
                      return ElevatedButton(
                        onPressed: () async {
                          if (_nameCtrl.text.isEmpty ||
                              _phoneCtrl.text.isEmpty) {
                            AppNotification.showWarning(context, 'يرجى ملء جميع الحقول المطلوبة');
                            return;
                          }

                          final repo = ref.read(studentRepositoryProvider);
                          final code = _generatedCode;

                          final student = Student(
                            id: const Uuid().v4(),
                            name: _nameCtrl.text.trim(),
                            parentName: _nameCtrl.text
                                .trim(), // Full name is used as parent name
                            parentPhone: _phoneCtrl.text.trim(),
                            loginCode: code,
                            teacherId: widget.teacherId,
                            monthlySubscription: _monthlySubscription,
                          );

                          await repo.addStudent(student);
                          ref.invalidate(
                              localTeacherStudentsProvider(widget.teacherId));

                          if (context.mounted) {
                            AppNotification.showSuccess(context, 'تمت إضافة الطالب بنجاح');
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('حفظ وتسجيل الطالب'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 2. ABSENCE SCREEN (Attendance logs manager)
class AbsenceScreen extends ConsumerStatefulWidget {
  final String teacherId;
  const AbsenceScreen({super.key, required this.teacherId});

  @override
  ConsumerState<AbsenceScreen> createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends ConsumerState<AbsenceScreen> {
  @override
  Widget build(BuildContext context) {
    final studentsAsync =
        ref.watch(localTeacherStudentsProvider(widget.teacherId));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final attendanceAsync = ref.watch(todayAttendanceProvider(today));
    final dailyRecordsAsync = ref.watch(todayDailyRecordsProvider(today));

    return Scaffold(
      appBar: AppBar(
        title: const Text('حضور وغياب اليوم'),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: IslamicPatternBackground()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'قائمة الحضور اليومي للحلقة',
                    style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: IslamicTheme.oliveLight),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: studentsAsync.when(
                      data: (students) {
                        return attendanceAsync.when(
                          data: (attendance) {
                            return dailyRecordsAsync.when(
                              data: (dailyRecords) {
                                // Build Map of student presence / absent states
                                final Map<String,
                                        ({bool isPresent, String detailText})>
                                    studentStates = {};

                                for (var student in students) {
                                  final hasDailyRecord = dailyRecords
                                      .any((r) => r.studentId == student.id);
                                  final attendanceEntry = attendance
                                      .where((a) => a.studentId == student.id)
                                      .firstOrNull;
                                  final hasPresentAttendance =
                                      attendanceEntry != null &&
                                          !attendanceEntry.isAbsent;

                                  bool isPresent = false;
                                  String detailText = 'قيد التسجيل';

                                  if (attendanceEntry?.isAbsent == true) {
                                    isPresent = false;
                                    detailText = 'غائب';
                                  } else if (hasDailyRecord &&
                                      hasPresentAttendance) {
                                    isPresent = true;
                                    final rec = dailyRecords.firstWhere(
                                        (r) => r.studentId == student.id);
                                    String gradeAr = '';
                                    switch (rec.memorizationGrade) {
                                      case 'excellent':
                                        gradeAr = 'ممتاز';
                                        break;
                                      case 'very_good':
                                        gradeAr = 'جيد جداً';
                                        break;
                                      case 'good':
                                        gradeAr = 'جيد';
                                        break;
                                      case 'not_memorized':
                                        gradeAr = 'لم يحفظ';
                                        break;
                                      case 'postponed':
                                        gradeAr = 'مؤجل';
                                        break;
                                      default:
                                        gradeAr = rec.memorizationGrade;
                                    }
                                    detailText = 'حاضر ($gradeAr)';
                                  } else if (attendanceEntry != null) {
                                    isPresent = !attendanceEntry.isAbsent;
                                    detailText = 'قيد التسجيل';
                                  } else {
                                    isPresent = false;
                                    detailText = 'قيد التسجيل';
                                  }

                                  studentStates[student.id] = (
                                    isPresent: isPresent,
                                    detailText: detailText
                                  );
                                }

                                return Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: students.length,
                                        itemBuilder: (context, idx) {
                                          final student = students[idx];
                                          final stateInfo =
                                              studentStates[student.id] ??
                                                  (
                                                    isPresent: false,
                                                    detailText: 'قيد التسجيل'
                                                  );

                                          final isPresent = stateInfo.isPresent;
                                          final detailText =
                                              stateInfo.detailText;
                                          final isAbsent = detailText == 'غائب';

                                          return Card(
                                            color: Colors.white,
                                            margin: const EdgeInsets.only(
                                                bottom: 12),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 12),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          student.name,
                                                          style:
                                                              GoogleFonts.cairo(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 2),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: isPresent
                                                                ? const Color(
                                                                    0xFFE4ECD5)
                                                                : isAbsent
                                                                    ? const Color(
                                                                        0xFFFADEDF)
                                                                    : const Color(
                                                                        0xFFFDF1DB),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                          child: Text(
                                                            detailText,
                                                            style: GoogleFonts
                                                                .cairo(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: isPresent
                                                                  ? const Color(
                                                                      0xFF43681D)
                                                                  : isAbsent
                                                                      ? const Color(
                                                                          0xFFA32E32)
                                                                      : const Color(
                                                                          0xFFA77322),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      OutlinedButton(
                                                        onPressed: () =>
                                                            _toggleAttendance(
                                                                ref,
                                                                context,
                                                                student,
                                                                false),
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          backgroundColor: isPresent
                                                              ? IslamicTheme
                                                                  .mintPastel
                                                              : Colors
                                                                  .transparent,
                                                          foregroundColor:
                                                              IslamicTheme
                                                                  .oliveLight,
                                                          side: isPresent
                                                              ? BorderSide.none
                                                              : const BorderSide(
                                                                  color: Colors
                                                                      .grey),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12),
                                                        ),
                                                        child:
                                                            const Text('حاضر'),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      OutlinedButton(
                                                        onPressed: () =>
                                                            _toggleAttendance(
                                                                ref,
                                                                context,
                                                                student,
                                                                true),
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              Colors.red,
                                                          backgroundColor: isAbsent
                                                              ? const Color(
                                                                  0xFFFADEDF)
                                                              : Colors
                                                                  .transparent,
                                                          side: isAbsent
                                                              ? BorderSide.none
                                                              : const BorderSide(
                                                                  color: Colors
                                                                      .grey),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12),
                                                        ),
                                                        child:
                                                            const Text('غائب'),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () => _markUnrecordedAbsent(
                                        students,
                                        studentStates,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[700],
                                        foregroundColor: Colors.white,
                                        minimumSize:
                                            const Size(double.infinity, 50),
                                      ),
                                      icon:
                                          const Icon(Icons.fact_check_outlined),
                                      label: const Text(
                                          'أخذ الغياب للطلاب غير المسجلين'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: ElevatedButton.icon(
                                        onPressed: () =>
                                            _sendWhatsAppGroupAttendanceReport(
                                                students,
                                                studentStates,
                                                dailyRecords),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green[800],
                                          foregroundColor: Colors.white,
                                          minimumSize:
                                              const Size(double.infinity, 50),
                                        ),
                                        icon: const Icon(Icons.share,
                                            color: Colors.white),
                                        label: const Text(
                                            'إرسال تقرير الغياب والحضور للمجموعة'),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              loading: () => const Center(
                                  child: CircularProgressIndicator()),
                              error: (err, s) =>
                                  Center(child: Text('خطأ: $err')),
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (err, s) => Center(child: Text('خطأ: $err')),
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, s) => Center(child: Text('خطأ: $err')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleAttendance(WidgetRef ref, BuildContext context,
      Student student, bool isAbsent) async {
    final recordRepo = ref.read(recordRepositoryProvider);
    final now = DateTime.now();

    final attendance = Attendance(
      id: 'ATT_${student.id}_${now.year}_${now.month}_${now.day}',
      studentId: student.id,
      date: now,
      isAbsent: isAbsent,
      arrivalTime: isAbsent ? null : now.copyWith(hour: 16, minute: 0),
      departureTime: isAbsent ? null : now.copyWith(hour: 17, minute: 30),
    );

    await recordRepo.saveAttendance(attendance);
    final today = DateTime(now.year, now.month, now.day);
    ref.invalidate(todayAttendanceProvider(today));

    if (context.mounted) {
      AppNotification.showSuccess(
        context,
        'تم تسجيل حضور الطالب ${student.name} بـ ${isAbsent ? "غائب" : "حاضر"}',
      );
    }
  }

  Future<void> _sendWhatsAppGroupAttendanceReport(
    List<Student> students,
    Map<String, ({bool isPresent, String detailText})> studentStates,
    List<DailyRecordsTableData> dailyRecords,
  ) async {
    final now = DateTime.now();
    final dateStr = '${now.year}/${now.month}/${now.day}';

    final recordsByStudent = {
      for (final record in dailyRecords) record.studentId: record,
    };
    final lines = <String>[];
    for (var i = 0; i < students.length; i++) {
      final student = students[i];
      final stateInfo = studentStates[student.id] ??
          (isPresent: false, detailText: 'قيد التسجيل');
      final record = recordsByStudent[student.id];

      if (stateInfo.isPresent && record != null) {
        final memoGrades = _gradesFromRecord(
          record.memorizationData,
          record.memorizationGrade,
        );
        final revisionGrades = _gradesFromRecord(
          record.revisionData,
          record.revisionGrade,
        );
        lines.add(
          '${i + 1}. ${student.name} | حاضر | الحفظ: ${memoGrades.join('، ')} | المراجعة: ${revisionGrades.join('، ')}',
        );
      } else {
        final status = stateInfo.detailText == 'غائب' ? 'غائب' : 'قيد التسجيل';
        lines.add('${i + 1}. ${student.name} | $status');
      }
    }

    final String message = '📊 *تقرير الحضور والغياب اليومي للحلقة*\n'
        '🗓️ *التاريخ:* $dateStr\n'
        '${lines.join('\n')}';

    await launchWhatsAppMessage(context: context, message: message);
  }

  List<String> _gradesFromRecord(String rawData, String fallbackGrade) {
    try {
      final decoded = jsonDecode(rawData);
      if (decoded is Map<String, dynamic> && decoded['entries'] is List) {
        return (decoded['entries'] as List)
            .map((entry) => _translateGrade(
                (entry as Map<String, dynamic>)['grade'] as String? ??
                    fallbackGrade))
            .toList();
      }
    } catch (_) {}
    return [_translateGrade(fallbackGrade)];
  }

  String _translateGrade(String grade) {
    switch (grade) {
      case 'excellent':
        return 'ممتاز';
      case 'very_good':
        return 'جيد جداً';
      case 'good':
        return 'جيد';
      case 'not_memorized':
        return 'لم يحفظ';
      case 'postponed':
        return 'مؤجل';
      default:
        return grade;
    }
  }

  Future<void> _markUnrecordedAbsent(
    List<Student> students,
    Map<String, ({bool isPresent, String detailText})> studentStates,
  ) async {
    final unrecorded = students
        .where((student) =>
            (studentStates[student.id]?.detailText ?? 'قيد التسجيل') ==
            'قيد التسجيل')
        .toList();

    final recordRepo = ref.read(recordRepositoryProvider);
    final now = DateTime.now();
    for (final student in unrecorded) {
      await recordRepo.saveAttendance(
        Attendance(
          id: 'ATT_${student.id}_${now.year}_${now.month}_${now.day}',
          studentId: student.id,
          date: now,
          isAbsent: true,
        ),
      );
    }

    final today = DateTime(now.year, now.month, now.day);
    ref.invalidate(todayAttendanceProvider(today));
    if (mounted) {
      AppNotification.showSuccess(context, 'تم تسجيل غياب ${unrecorded.length} طالب');
    }
  }
}

// 3. QUIZZES SCREEN (آداب)
class QuizzesScreen extends ConsumerStatefulWidget {
  final String teacherId;
  const QuizzesScreen({super.key, required this.teacherId});

  @override
  ConsumerState<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends ConsumerState<QuizzesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Quiz Info fields
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  // Question Form fields
  final _questionCtrl = TextEditingController();
  final List<TextEditingController> _optionCtrls =
      List.generate(4, (_) => TextEditingController());
  int _correctIndex = 0;

  // List of added questions
  final List<Map<String, dynamic>> _questionsList = [];

  // Leaderboard data
  List<Map<String, dynamic>> _leaderboard = [];
  bool _loadingLeaderboard = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLeaderboard();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _questionCtrl.dispose();
    for (var ctrl in _optionCtrls) {
      ctrl.dispose();
    }
    super.dispose();
  }

  Future<void> _loadLeaderboard() async {
    setState(() => _loadingLeaderboard = true);
    try {
      final db = ref.read(databaseProvider);

      final answers = await db.select(db.quizAnswersTable).get();
      final students = await db.select(db.studentsTable).get();
      final quizzes = await db.select(db.quizzesTable).get();

      // Filter quizzes created by this teacher
      final teacherQuizIds = quizzes
          .where((q) => q.teacherId == widget.teacherId)
          .map((q) => q.id)
          .toSet();

      final List<Map<String, dynamic>> temp = [];

      for (var ans in answers) {
        if (teacherQuizIds.contains(ans.quizId)) {
          final student =
              students.where((s) => s.id == ans.studentId).firstOrNull;
          final quiz = quizzes.where((q) => q.id == ans.quizId).firstOrNull;

          if (student != null && quiz != null) {
            temp.add({
              'studentName': student.name,
              'quizTitle': quiz.title,
              'score': ans.score,
              'completedAt': ans.completedAt,
            });
          }
        }
      }

      // Sort by score descending, then by completion date ascending
      temp.sort((a, b) {
        final int scoreComp = b['score'].compareTo(a['score']);
        if (scoreComp != 0) return scoreComp;
        return a['completedAt'].compareTo(b['completedAt']);
      });

      setState(() {
        _leaderboard = temp;
        _loadingLeaderboard = false;
      });
    } catch (e) {
      setState(() => _loadingLeaderboard = false);
    }
  }

  void _addQuestion() {
    if (_questionCtrl.text.trim().isEmpty) {
      AppNotification.showInfo(context, 'الرجاء إدخال نص السؤال');
      return;
    }
    for (int i = 0; i < 4; i++) {
      if (_optionCtrls[i].text.trim().isEmpty) {
        AppNotification.showInfo(context, 'الرجاء ملء الخيار ${i + 1}');
        return;
      }
    }

    setState(() {
      _questionsList.add({
        'question': _questionCtrl.text.trim(),
        'options': _optionCtrls.map((c) => c.text.trim()).toList(),
        'correctIndex': _correctIndex,
      });

      // Clear fields
      _questionCtrl.clear();
      for (var c in _optionCtrls) {
        c.clear();
      }
      _correctIndex = 0;
    });

    AppNotification.showInfo(context, 'تمت إضافة السؤال بنجاح');
  }

  Future<void> _saveQuiz() async {
    if (_titleCtrl.text.trim().isEmpty) {
      AppNotification.showInfo(context, 'الرجاء إدخال عنوان الاختبار');
      return;
    }
    if (_questionsList.isEmpty) {
      AppNotification.showInfo(context, 'الرجاء إضافة سؤال واحد على الأقل');
      return;
    }

    try {
      final db = ref.read(databaseProvider);
      final questionsJson = jsonEncode(_questionsList);

      await db.into(db.quizzesTable).insert(QuizzesTableCompanion.insert(
            id: const Uuid().v4(),
            teacherId: widget.teacherId,
            title: _titleCtrl.text.trim(),
            description: Value(
                _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim()),
            questionsJson: questionsJson,
            createdAt: DateTime.now(),
          ));

      if (mounted) {
        AppNotification.showInfo(context, 'تم حفظ ونشر اختبار الآداب بنجاح!');
        // Clear all fields and list
        setState(() {
          _titleCtrl.clear();
          _descCtrl.clear();
          _questionsList.clear();
        });
        // Switch tab to leaderboard
        _tabController.animateTo(1);
        _loadLeaderboard();
      }
    } catch (e) {
      AppNotification.showInfo(context, 'خطأ أثناء حفظ الاختبار: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('آداب والاختبارات الإسلامية'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: IslamicTheme.goldMetallic,
          tabs: const [
            Tab(text: 'إنشاء اختبار'),
            Tab(text: 'لوحة الصدارة (أوائل)'),
          ],
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: IslamicPatternBackground()),
          TabBarView(
            controller: _tabController,
            children: [
              _buildCreateQuizTab(),
              _buildLeaderboardTab(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreateQuizTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: FadeInSlide(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quiz details
            Text(
              'تفاصيل الاختبار الجديد',
              style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: IslamicTheme.oliveLight),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'عنوان الاختبار (مثال: آداب المسجد)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                labelText: 'تعليمات أو وصف الاختبار (اختياري)',
              ),
              maxLines: 2,
            ),
            const Divider(height: 32),

            // Questions list
            if (_questionsList.isNotEmpty) ...[
              Text(
                'الأسئلة المضافة حالياً (${_questionsList.length})',
                style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: IslamicTheme.oliveLight),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _questionsList.length,
                itemBuilder: (ctx, idx) {
                  final q = _questionsList[idx];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        '${idx + 1}. ${q['question']}',
                        style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      subtitle: Text(
                        'الخيارات: ${q['options'].join(', ')}\nالإجابة الصحيحة: الخيار ${q['correctIndex'] + 1} (${q['options'][q['correctIndex']]})',
                        style: GoogleFonts.cairo(
                            fontSize: 10, color: Colors.grey[600]),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _questionsList.removeAt(idx);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],

            // Add new question card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFDFCF9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFC5A85A).withOpacity(0.25), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'إضافة سؤال اختيار من متعدد (MCQ)',
                    style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: IslamicTheme.oliveLight),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _questionCtrl,
                    decoration: const InputDecoration(
                      labelText: 'نص السؤال',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextField(
                        controller: _optionCtrls[index],
                        decoration: InputDecoration(
                          labelText: 'الخيار ${index + 1}',
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _correctIndex,
                    decoration: const InputDecoration(
                      labelText: 'تحديد الخيار الصحيح',
                    ),
                    items: List.generate(4, (i) {
                      return DropdownMenuItem<int>(
                        value: i,
                        child: Text('الخيار ${i + 1}',
                            style: GoogleFonts.cairo(fontSize: 13)),
                      );
                    }),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _correctIndex = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _addQuestion,
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة هذا السؤال للاختبار'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: IslamicTheme.oliveLight,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Save Quiz Button
            ElevatedButton.icon(
              onPressed: _saveQuiz,
              icon: const Icon(Icons.save),
              label: const Text('حفظ ونشر الاختبار بالكامل'),
              style: ElevatedButton.styleFrom(
                backgroundColor: IslamicTheme.goldMetallic,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    if (_loadingLeaderboard) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_leaderboard.isEmpty) {
      return const Center(child: Text('لا توجد نتائج مسجلة بعد لهذه الحلقة'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _leaderboard.length,
      itemBuilder: (context, idx) {
        final entry = _leaderboard[idx];

        // Setup rank medals
        String medal = '';
        if (idx == 0) {
          medal = '🥇 ';
        } else if (idx == 1) {
          medal = '🥈 ';
        } else if (idx == 2) {
          medal = '🥉 ';
        } else {
          medal = '${idx + 1}. ';
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  idx < 3 ? const Color(0xFFF3E5AB) : const Color(0xFFE4ECD5),
              child: Text(
                '${idx + 1}',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            title: Text(
              '$medal${entry['studentName']}',
              style:
                  GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            subtitle: Text(
              'مسابقة: ${entry['quizTitle']}\nالتاريخ: ${entry['completedAt'].year}/${entry['completedAt'].month}/${entry['completedAt'].day}',
              style: GoogleFonts.cairo(fontSize: 10, color: Colors.grey[600]),
            ),
            trailing: Text(
              '${entry['score']} درجة',
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.green[800],
              ),
            ),
          ),
        );
      },
    );
  }
}

// 4. COLLECTIONS SCREEN (التحصيل المالي)
class CollectionsScreen extends ConsumerStatefulWidget {
  final String teacherId;
  const CollectionsScreen({super.key, required this.teacherId});

  @override
  ConsumerState<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends ConsumerState<CollectionsScreen> {
  final String _currentMonth = 'يونيو ٢٠٢٦';
  final String _currentMonthDb = '2026-06';

  Future<void> _sendInAppReminder(
      BuildContext context, Student student, double amount) async {
    final db = ref.read(databaseProvider);
    final id = 'REM_${student.id}_${DateTime.now().millisecondsSinceEpoch}';
    final title = 'تذكير سداد اشتراك 💳';
    final content =
        'نرجو منكم سداد اشتراك الحلقة لشهر يونيو ٢٠٢٦ وقدره ${amount.toStringAsFixed(0)} ج.م. شاكرين لكم تعاونكم 🌸';

    await db.into(db.remindersTable).insert(
          RemindersTableCompanion.insert(
            id: id,
            studentId: Value(student.id),
            title: title,
            content: content,
            createdAt: DateTime.now(),
          ),
        );

    if (context.mounted) {
      AppNotification.showSuccess(
        context,
        'تم إرسال إشعار تذكير بالدفع للطالب ${student.name}',
      );
    }
  }

  Future<void> _sendWhatsAppGroupCollectionReminder() async {
    final message = 'السلام عليكم ورحمة الله وبركاته\n'
        'أولياء الأمور الكرام، نذكّركم بلطف بموعد سداد رسوم حلقة تحفيظ القرآن الكريم لشهر $_currentMonth.\n'
        'نرجو ممن لم يتمكن من السداد بعد التكرم بإتمامه في أقرب وقت مناسب، ومن قام بالسداد فليتفضل بتجاهل هذه الرسالة.\n'
        'جزاكم الله خيراً على تعاونكم وحرصكم الدائم على استمرار أبنائنا في حفظ كتاب الله.';

    await launchWhatsAppMessage(
      context: context,
      message: message,
    );
  }

  void _showRecordPaymentDialog(
      Student student, double currentAmount, String currentNotes, bool isPaid) {
    final amountCtrl =
        TextEditingController(text: currentAmount.toStringAsFixed(0));
    final notesCtrl = TextEditingController(text: currentNotes);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          isPaid
              ? 'تعديل دفعة - ${student.name}'
              : 'تسجيل سداد - ${student.name}',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountCtrl,
              decoration: const InputDecoration(
                labelText: 'المبلغ المدفوع (ج.م)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesCtrl,
              decoration: const InputDecoration(
                labelText: 'ملاحظات الدفع (مثال: فودافون كاش)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final double amt =
                  double.tryParse(amountCtrl.text.trim()) ?? student.monthlySubscription.toDouble();
              final db = ref.read(databaseProvider);
              final paymentId = 'PAY_${student.id}_2026_06';

              await db.into(db.paymentsTable).insertOnConflictUpdate(
                    PaymentsTableCompanion.insert(
                      id: paymentId,
                      studentId: student.id,
                      amount: amt,
                      month: _currentMonthDb,
                      isPaid: const Value(true),
                      paymentDate: Value(DateTime.now()),
                      notes: Value(notesCtrl.text.trim().isEmpty
                          ? null
                          : notesCtrl.text.trim()),
                    ),
                  );

              if (ctx.mounted) {
                Navigator.pop(ctx);
                AppNotification.showSuccess(
                  context,
                  'تم تسجيل سداد مبلغ $amt ج.م للطالب ${student.name}',
                );
              }
            },
            child: const Text('تأكيد وحفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync =
        ref.watch(localTeacherStudentsProvider(widget.teacherId));
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('التحصيل والاشتراكات المالية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'تصدير إكسيل',
            onPressed: () async {
              try {
                final students = ref.read(localTeacherStudentsProvider(widget.teacherId)).value ?? [];
                final allPayments = await db.select(db.paymentsTable).get();
                final paymentsList = allPayments.map((p) => Payment(
                  id: p.id,
                  studentId: p.studentId,
                  amount: p.amount,
                  month: p.month,
                  isPaid: p.isPaid,
                  paymentDate: p.paymentDate,
                  notes: p.notes,
                )).toList();
                final file = await ReportGenerator.generateCollectionsExcel(students, paymentsList);
                await Share.shareXFiles(
                  [XFile(file.path)],
                  text: 'سجل التحصيل والاشتراكات المالية - تطبيق أثر',
                );
              } catch (e) {
                if (context.mounted) {
                  AppNotification.showInfo(context, 'حدث خطأ أثناء تصدير إكسيل: $e');
                }
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: IslamicPatternBackground()),
          StreamBuilder<List<PaymentsTableData>>(
            stream: db.select(db.paymentsTable).watch(),
            builder: (context, paymentSnapshot) {
              final payments = paymentSnapshot.data ?? [];

              return studentsAsync.when(
                data: (students) {
                  // Calculate statistics based on real db payments
                  double received = 0.0;
                  double outstanding = 0.0;

                  // Map of studentId -> PaymentData
                  final Map<String, PaymentsTableData> studentPayments = {};
                  for (var p in payments) {
                    if (p.month == _currentMonthDb) {
                      studentPayments[p.studentId] = p;
                    }
                  }

                  for (var s in students) {
                    final p = studentPayments[s.id];
                    if (p != null && p.isPaid) {
                      received += p.amount;
                    } else {
                      outstanding += s.monthlySubscription.toDouble();
                    }
                  }

                  return SafeArea(
                    child: Column(
                      children: [
                        // Status card showing EGP
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.1),
                                  width: 1),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'الوضع المالي - $_currentMonth',
                                      style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ),
                                    const Icon(Icons.arrow_drop_down,
                                        color: Colors.grey),
                                  ],
                                ),
                                const Divider(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const Text('المتأخرات المطلوبة',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey)),
                                          Text(
                                              '${outstanding.toStringAsFixed(0)} ج.م',
                                              style: GoogleFonts.cairo(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                  fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        width: 1,
                                        height: 40,
                                        color: Colors.grey[200]),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const Text('المدفوع المحصل',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey)),
                                          Text(
                                              '${received.toStringAsFixed(0)} ج.م',
                                              style: GoogleFonts.cairo(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                  fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: ElevatedButton.icon(
                            onPressed: _sendWhatsAppGroupCollectionReminder,
                            icon: const Icon(Icons.groups_outlined),
                            label: const Text(
                                'إرسال تذكير التحصيل لمجموعة أولياء الأمور'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[800],
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                          ),
                        ),

                        // Student payments list
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: students.length,
                            itemBuilder: (context, idx) {
                              final student = students[idx];
                              final p = studentPayments[student.id];
                              final isPaid = p?.isPaid ?? false;
                              final amount = p?.amount ??
                                  student.monthlySubscription.toDouble();
                              final notes = p?.notes ?? '';

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    title: Text(
                                      student.name,
                                      style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isPaid
                                              ? 'الاشتراك المدفوع: ${amount.toStringAsFixed(0)} ج.م'
                                              : 'غير مدفوع (المستحق: ${student.monthlySubscription} ج.م)',
                                          style: GoogleFonts.cairo(
                                            fontSize: 11,
                                            color: isPaid
                                                ? Colors.grey[600]
                                                : Colors.red,
                                            fontWeight: isPaid
                                                ? FontWeight.normal
                                                : FontWeight.bold,
                                          ),
                                        ),
                                        if (notes.isNotEmpty)
                                          Text(
                                            'ملاحظة: $notes',
                                            style: GoogleFonts.cairo(
                                                fontSize: 10,
                                                color: Colors.blue[800]),
                                          ),
                                      ],
                                    ),
                                    trailing: isPaid
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFE4ECD5),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  'مدفوع',
                                                  style: GoogleFonts.cairo(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green[800]),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.edit,
                                                    size: 18,
                                                    color: Colors.grey),
                                                onPressed: () =>
                                                    _showRecordPaymentDialog(
                                                        student,
                                                        amount,
                                                        notes,
                                                        true),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () =>
                                                    _showRecordPaymentDialog(
                                                        student,
                                                        amount,
                                                        notes,
                                                        false),
                                                style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                                  minimumSize: Size.zero,
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                child: const Text('سداد',
                                                    style: TextStyle(
                                                        fontSize: 11)),
                                              ),

                                              IconButton(
                                                icon: const Icon(Icons.share,
                                                    color: Colors.green,
                                                    size: 20),
                                                onPressed: () =>
                                                    _sendWhatsAppReminder(
                                                        context,
                                                        student,
                                                        amount,
                                                        _currentMonth),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, s) => Center(child: Text('خطأ: $err')),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _sendWhatsAppReminder(BuildContext context, Student student,
      double amount, String month) async {
    final String message =
        'السلام عليكم ورحمة الله وبركاته، ولي أمر الطالب ${student.name}.\n'
        'نود تذكيركم بسداد اشتراك حلقة تحفيظ القرآن الكريم لشهر $month وقدره ${amount.toStringAsFixed(0)} ج.م.\n'
        'شاكرين لكم تعاونكم معنا لحرصكم على تحفيظ أبنائكم وبناتكم 🌸.';
    await launchWhatsAppMessage(
      context: context,
      phone: student.parentPhone,
      message: message,
    );
  }
}

// 5. REPORTS SCREEN (التقارير والإحصائيات)
class ReportsScreen extends ConsumerStatefulWidget {
  final String teacherId;
  const ReportsScreen({super.key, required this.teacherId});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  int _selectedDay = DateTime.now().day;
  int _selectedMonth = DateTime.now().month;
  final int _selectedYear = DateTime.now().year;

  List<Student> _presentStudents = [];
  List<Student> _absentStudents = [];
  List<Student> _unrecordedStudents = [];
  Map<String, int> _gradesCount = {
    'excellent': 0,
    'very_good': 0,
    'good': 0,
    'not_memorized': 0,
    'postponed': 0,
  };
  int _totalGradesCount = 0;
  bool _loadingReport = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _loadDailyAttendance();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDailyAttendance() async {
    setState(() => _loadingReport = true);
    try {
      final db = ref.read(databaseProvider);
      final allStudents = await (db.select(db.studentsTable)
            ..where((t) => t.teacherId.equals(widget.teacherId)))
          .get();
      final attendanceData = await db.select(db.attendanceTable).get();

      final targetDate = DateTime(_selectedYear, _selectedMonth, _selectedDay);
      final targetRecords = attendanceData
          .where((a) =>
              a.date.year == targetDate.year &&
              a.date.month == targetDate.month &&
              a.date.day == targetDate.day)
          .toList();

      final Map<String, AttendanceTableData> attendanceMap = {
        for (var rec in targetRecords) rec.studentId: rec
      };

      final List<Student> present = [];
      final List<Student> absent = [];
      final List<Student> unrecorded = [];

      for (var sDb in allStudents) {
        final student = Student(
          id: sDb.id,
          name: sDb.name,
          parentName: sDb.parentName,
          parentPhone: sDb.parentPhone,
          loginCode: sDb.loginCode,
          teacherId: sDb.teacherId,
          points: sDb.points,
          stars: sDb.stars,
          achievementLevel: sDb.achievementLevel,
          monthlySubscription: sDb.monthlySubscription,
        );

        final record = attendanceMap[student.id];
        if (record == null) {
          unrecorded.add(student);
        } else if (record.isAbsent) {
          absent.add(student);
        } else {
          present.add(student);
        }
      }

      // Load actual daily memorization & revision grades
      final dailyRecords = await db.select(db.dailyRecordsTable).get();
      final targetDaily = dailyRecords.where((d) =>
          d.date.year == targetDate.year &&
          d.date.month == targetDate.month &&
          d.date.day == targetDate.day).toList();

      final Map<String, int> counts = {
        'excellent': 0,
        'very_good': 0,
        'good': 0,
        'not_memorized': 0,
        'postponed': 0,
      };

      for (var r in targetDaily) {
        if (counts.containsKey(r.memorizationGrade)) {
          counts[r.memorizationGrade] = counts[r.memorizationGrade]! + 1;
        }
      }

      final total = counts.values.fold<int>(0, (sum, val) => sum + val);

      setState(() {
        _presentStudents = present;
        _absentStudents = absent;
        _unrecordedStudents = unrecorded;
        _gradesCount = counts;
        _totalGradesCount = total;
        _loadingReport = false;
      });
    } catch (e) {
      setState(() => _loadingReport = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير والإحصائيات'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: const Color(0xFF2B3724),
            child: TabBar(
              controller: _tabCtrl,
              indicatorColor: const Color(0xFFE5C05B),
              indicatorWeight: 3.5,
              labelColor: const Color(0xFFE5C05B),
              unselectedLabelColor: Colors.white,
              labelStyle: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              unselectedLabelStyle: GoogleFonts.cairo(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              tabs: const [
                Tab(child: Text('يومي')),
                Tab(child: Text('أسبوعي')),
                Tab(child: Text('شهري')),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: IslamicPatternBackground()),
          TabBarView(
            controller: _tabCtrl,
            children: [
              _buildDailyReportsTab(),
              _buildMockTab('التقرير الأسبوعي للحلقة'),
              _buildMockTab('التقرير الشهري للحلقة'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMockTab(String title) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.analytics_outlined,
                  size: 48, color: IslamicTheme.oliveLight),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: IslamicTheme.oliveLight),
              ),
              const SizedBox(height: 8),
              const Text(
                  'يتم تجميع البيانات أسبوعياً وشهرياً تلقائياً وعرض الرسوم البيانية للتحصيل والحضور.'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportExcel(String attendanceRate) async {
    try {
      final periodTitle = _tabCtrl.index == 0
          ? 'ØªÙ‚Ø±ÙŠØ± ÙŠÙˆÙ…ÙŠ (--2026)'
          : (_tabCtrl.index == 1 ? 'ØªÙ‚Ø±ÙŠØ± Ø£Ø³Ø¨ÙˆØ¹ÙŠ Ù„Ù„Ø­Ù„Ù‚Ø©' : 'ØªÙ‚Ø±ÙŠØ± Ø´Ù‡Ø±ÙŠ (Ø´Ù‡Ø± )');
      final file = await ReportGenerator.generateAttendanceReportExcel(
        periodTitle: periodTitle,
        attendanceRate: attendanceRate,
        presentStudents: _presentStudents,
        absentStudents: _absentStudents,
        unrecordedStudents: _unrecordedStudents,
        gradesCount: _gradesCount,
      );
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'ØªÙ‚Ø±ÙŠØ± Ø­Ù„Ù‚Ø© Ø£Ø«Ø± - ' + periodTitle,
      );
    } catch (e) {
      if (mounted) {
        AppNotification.showInfo(context, 'Ø­Ø¯Ø« Ø®Ø·Ø£ Ø£Ø«Ù†Ø§Ø¡ ØªØµØ¯ÙŠØ± Ø§Ù„Ø¥ÙƒØ³ÙŠÙ„: ' + e.toString());
      }
    }
  }

  Future<void> _exportPdf(String attendanceRate) async {
    try {
      final periodTitle = _tabCtrl.index == 0
          ? 'ØªÙ‚Ø±ÙŠØ± ÙŠÙˆÙ…ÙŠ (--2026)'
          : (_tabCtrl.index == 1 ? 'ØªÙ‚Ø±ÙŠØ± Ø£Ø³Ø¨ÙˆØ¹ÙŠ Ù„Ù„Ø­Ù„Ù‚Ø©' : 'ØªÙ‚Ø±ÙŠØ± Ø´Ù‡Ø±ÙŠ (Ø´Ù‡Ø± )');
      final file = await ReportGenerator.generateAttendanceReportPdf(
        periodTitle: periodTitle,
        attendanceRate: attendanceRate,
        presentStudents: _presentStudents,
        absentStudents: _absentStudents,
        unrecordedStudents: _unrecordedStudents,
        gradesCount: _gradesCount,
      );
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'ØªÙ‚Ø±ÙŠØ± Ø­Ù„Ù‚Ø© Ø£Ø«Ø± - ' + periodTitle,
      );
    } catch (e) {
      if (mounted) {
        AppNotification.showInfo(context, 'Ø­Ø¯Ø« Ø®Ø·Ø£ Ø£Ø«Ù†Ø§Ø¡ ØªØµØ¯ÙŠØ± Ø§Ù„Ù€ PDF: ' + e.toString());
      }
    }
  }

  Widget _buildDailyReportsTab() {
    final double totalStudents = (_presentStudents.length +
            _absentStudents.length +
            _unrecordedStudents.length)
        .toDouble();
    final String attendanceRateStr = totalStudents > 0
        ? '${((_presentStudents.length / totalStudents) * 100).toStringAsFixed(0)}%'
        : '100%';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: FadeInSlide(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filter controls (Month & Day Dropdowns)
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تصفية التقرير اليومي باليوم والشهر:',
                      style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _selectedMonth,
                            decoration: const InputDecoration(
                                labelText: 'الشهر',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4)),
                            items: List.generate(12, (i) {
                              final m = i + 1;
                              return DropdownMenuItem(
                                  value: m,
                                  child: Text('$m',
                                      style: const TextStyle(fontSize: 13)));
                            }),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedMonth = val;
                                });
                                _loadDailyAttendance();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _selectedDay,
                            decoration: const InputDecoration(
                                labelText: 'اليوم',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4)),
                            items: List.generate(31, (i) {
                              final d = i + 1;
                              return DropdownMenuItem(
                                  value: d,
                                  child: Text('$d',
                                      style: const TextStyle(fontSize: 13)));
                            }),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedDay = val;
                                });
                                _loadDailyAttendance();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (_loadingReport)
              const Center(
                  child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator()))
            else ...[
              // Statistics Row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildReportStat(
                        'نسبة الحضور', attendanceRateStr, Colors.green[800]!),
                    Container(width: 1, height: 40, color: Colors.grey[200]),
                    _buildReportStat(
                        'الحاضرون', '${_presentStudents.length}', Colors.teal),
                    Container(width: 1, height: 40, color: Colors.grey[200]),
                    _buildReportStat('الغائبون', '${_absentStudents.length}',
                        Colors.red[800]!),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Present Students List
              Text(
                'الطلاب الحاضرون (${_presentStudents.length})',
                style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.green[800]),
              ),
              const SizedBox(height: 8),
              if (_presentStudents.isEmpty)
                const Card(
                    child: ListTile(
                        title: Text('لا يوجد حضور مسجل لهذا اليوم',
                            style:
                                TextStyle(fontSize: 12, color: Colors.grey))))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _presentStudents.length,
                  itemBuilder: (ctx, idx) {
                    final student = _presentStudents[idx];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading:
                            const Icon(Icons.check_circle, color: Colors.green),
                        title: Text(student.name,
                            style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 16),

              // Absent Students List
              Text(
                'الطلاب الغائبون (${_absentStudents.length})',
                style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.red[800]),
              ),
              const SizedBox(height: 8),
              if (_absentStudents.isEmpty)
                const Card(
                    child: ListTile(
                        title: Text('لا يوجد غياب مسجل لهذا اليوم',
                            style:
                                TextStyle(fontSize: 12, color: Colors.grey))))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _absentStudents.length,
                  itemBuilder: (ctx, idx) {
                    final student = _absentStudents[idx];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.cancel, color: Colors.red),
                        title: Text(student.name,
                            style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 16),

              // Unrecorded Students List
              if (_unrecordedStudents.isNotEmpty) ...[
                Text(
                  'طلاب لم يتم تسجيلهم بعد (${_unrecordedStudents.length})',
                  style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _unrecordedStudents.length,
                  itemBuilder: (ctx, idx) {
                    final student = _unrecordedStudents[idx];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading:
                            const Icon(Icons.help_outline, color: Colors.grey),
                        title: Text(student.name,
                            style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Custom Chart representing grades distribution
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      width: 1),
                ),
                child: _CustomBarChart(
                  gradesCount: _gradesCount,
                  totalGradesCount: _totalGradesCount,
                ),
              ),
              const SizedBox(height: 24),

              // Export Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _exportExcel(attendanceRateStr),
                      icon: const Icon(Icons.grid_on_outlined, size: 18),
                      label: const Text('تصدير Excel',
                          style: TextStyle(fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[800],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _exportPdf(attendanceRateStr),
                      icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                      label: const Text('تصدير PDF',
                          style: TextStyle(fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[900],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReportStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.cairo(
              fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          label,
          style: GoogleFonts.cairo(fontSize: 10, color: Colors.grey[700]),
        ),
      ],
    );
  }
}

// Custom Bar Chart Widget
class _CustomBarChart extends StatelessWidget {
  final Map<String, int> gradesCount;
  final int totalGradesCount;

  const _CustomBarChart({
    required this.gradesCount,
    required this.totalGradesCount,
  });

  @override
  Widget build(BuildContext context) {
    if (totalGradesCount == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'أداء التسميع والمراجعة للحلقة',
            style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: IslamicTheme.oliveLight),
          ),
          const SizedBox(height: 20),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'لا توجد سجلات تسميع مسجلة لهذا اليوم بعد',
                style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      );
    }

    int calcPct(String key) {
      final count = gradesCount[key] ?? 0;
      return ((count / totalGradesCount) * 100).round();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'أداء التسميع والمراجعة للحلقة',
              style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: IslamicTheme.oliveLight),
            ),
            Text(
              'إجمالي: $totalGradesCount تسميع',
              style: GoogleFonts.cairo(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar('ممتاز', calcPct('excellent'), Colors.green),
              _buildBar('جيد جداً', calcPct('very_good'), Colors.blue),
              _buildBar('جيد', calcPct('good'), Colors.yellow[700]!),
              _buildBar('لم يحفظ', calcPct('not_memorized'), Colors.orange),
              _buildBar('مؤجل', calcPct('postponed'), Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBar(String label, int value, Color color) {
    final double barHeight = value == 0 ? 4.0 : (value * 0.8).clamp(8.0, 80.0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('$value%',
            style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          width: 28,
          height: barHeight,
          decoration: BoxDecoration(
            color: value == 0 ? color.withOpacity(0.3) : color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// 2. STUDENTS LIST SCREEN (Standalone Screen)
class StudentsListScreen extends ConsumerStatefulWidget {
  final String teacherId;
  const StudentsListScreen({super.key, required this.teacherId});

  @override
  ConsumerState<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends ConsumerState<StudentsListScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync =
        ref.watch(localTeacherStudentsProvider(widget.teacherId));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final attendanceAsync = ref.watch(todayAttendanceProvider(today));
    final dailyRecordsAsync = ref.watch(todayDailyRecordsProvider(today));
    final tr = ref.watch(translationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: studentsAsync.when(
          data: (students) =>
              Text('${tr.translate('students_tab')} (${students.length})'),
          loading: () => Text(tr.translate('students_tab')),
          error: (_, __) => Text(tr.translate('students_tab')),
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: IslamicPatternBackground()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: tr.translate('search_students'),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim().toLowerCase();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: studentsAsync.when(
                      data: (students) {
                        return attendanceAsync.when(
                          data: (attendance) {
                            return dailyRecordsAsync.when(
                              data: (dailyRecords) {
                                final filtered = students.where((s) {
                                  return s.name
                                      .toLowerCase()
                                      .contains(_searchQuery);
                                }).toList();

                                if (filtered.isEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person_search_outlined, size: 54, color: Colors.grey.shade400)
                                            .animate()
                                            .scale(duration: 400.ms, curve: AppMotion.standard),
                                        const SizedBox(height: 12),
                                        Text('لا يوجد طلاب مطابقين للبحث', style: GoogleFonts.cairo(color: Colors.grey.shade600)),
                                      ],
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  itemCount: filtered.length,
                                  itemBuilder: (context, idx) {
                                    final student = filtered[idx];
                                    final hasDailyRecord = dailyRecords
                                        .any((r) => r.studentId == student.id);
                                    final attendanceEntry = attendance
                                        .where((a) => a.studentId == student.id)
                                        .firstOrNull;
                                    final hasPresentAttendance =
                                        attendanceEntry != null &&
                                            !attendanceEntry.isAbsent;

                                    var statusText = 'قيد التسجيل';
                                    var bg = const Color(0xFFFDF1DB);
                                    var fg = const Color(0xFFA77322);

                                    if (attendanceEntry?.isAbsent == true) {
                                      statusText = 'غائب';
                                      bg = const Color(0xFFFADEDF);
                                      fg = const Color(0xFFA32E32);
                                    } else if (hasDailyRecord &&
                                        hasPresentAttendance) {
                                      statusText = 'حاضر';
                                      bg = const Color(0xFFE4ECD5);
                                      fg = const Color(0xFF43681D);
                                    }

                                    return AppPressable(
                                      onTap: () {
                                        context.push(
                                            '/teacher/student/${student.id}');
                                      },
                                      child: Card(
                                        margin: const EdgeInsets.only(bottom: 12),
                                        child: ListTile(
                                          leading: Hero(
                                            tag: 'student_avatar_${student.id}',
                                            child: CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              child: Text(
                                                student.name[0],
                                                style: GoogleFonts.cairo(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            student.name,
                                            style: GoogleFonts.cairo(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: bg,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              statusText,
                                              style: GoogleFonts.cairo(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: fg,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ).animate().fadeIn(
                                      delay: (idx * 35).clamp(0, 300).ms,
                                      duration: 280.ms,
                                      curve: AppMotion.standard,
                                    ).slideY(
                                      begin: 0.08,
                                      end: 0,
                                      delay: (idx * 35).clamp(0, 300).ms,
                                      duration: 280.ms,
                                      curve: AppMotion.standard,
                                    );
                                  },
                                );
                              },
                              loading: () => ListView.separated(
                                itemCount: 6,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (_, __) => const AppShimmer(width: double.infinity, height: 72, borderRadius: 12),
                              ),
                              error: (err, s) =>
                                  Center(child: Text('خطأ: $err')),
                            );
                          },
                          loading: () => ListView.separated(
                            itemCount: 6,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (_, __) => const AppShimmer(width: double.infinity, height: 72, borderRadius: 12),
                          ),
                          error: (err, s) => Center(child: Text('خطأ: $err')),
                        );
                      },
                      loading: () => ListView.separated(
                        itemCount: 6,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, __) => const AppShimmer(width: double.infinity, height: 72, borderRadius: 12),
                      ),
                      error: (err, s) => Center(child: Text('خطأ: $err')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 3. TEACHER ANNOUNCEMENTS SCREEN (Standalone Screen)
class TeacherAnnouncementsScreen extends ConsumerStatefulWidget {
  final String teacherId;
  const TeacherAnnouncementsScreen({super.key, required this.teacherId});

  @override
  ConsumerState<TeacherAnnouncementsScreen> createState() =>
      _TeacherAnnouncementsScreenState();
}

class _TeacherAnnouncementsScreenState
    extends ConsumerState<TeacherAnnouncementsScreen> {
  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final announcementsStream = db.select(db.announcementsTable).watch();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعلانات'),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: IslamicPatternBackground()),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () => _showAddAnnouncementDialog(widget.teacherId),
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة إعلان جديد +'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<AnnouncementsTableData>>(
                  stream: announcementsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final list = snapshot.data ?? [];
                    if (list.isEmpty) {
                      return const Center(
                          child: Text('لا توجد إعلانات منشورة بعد'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: list.length,
                      itemBuilder: (context, idx) {
                        final announce = list[idx];

                        // Setup icons/color circles matching Screen 12
                        IconData icon = Icons.campaign_outlined;
                        Color color = Colors.orange;
                        if (idx % 3 == 1) {
                          icon = Icons.assignment_outlined;
                          color = Colors.blue;
                        } else if (idx % 3 == 2) {
                          icon = Icons.emoji_events_outlined;
                          color = Colors.green;
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(icon, color: color, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            announce.title,
                                            style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: IslamicTheme.oliveLight,
                                            ),
                                          ),
                                          Text(
                                            '${announce.createdAt.year}/${announce.createdAt.month.toString().padLeft(2, '0')}/${announce.createdAt.day.toString().padLeft(2, '0')}',
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        announce.content,
                                        style: GoogleFonts.cairo(
                                            fontSize: 12,
                                            color: Colors.grey[800]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddAnnouncementDialog(String teacherId) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('إعلان جديد لأولياء الأمور',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'عنوان الإعلان'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentCtrl,
              decoration: const InputDecoration(labelText: 'محتوى الإعلان'),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                final db = ref.read(databaseProvider);
                await db
                    .into(db.announcementsTable)
                    .insert(AnnouncementsTableCompanion.insert(
                      id: const Uuid().v4(),
                      teacherId: teacherId,
                      title: titleCtrl.text.trim(),
                      content: contentCtrl.text.trim(),
                      createdAt: DateTime.now(),
                    ));
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                }
              }
            },
            child: const Text('نشر'),
          ),
        ],
      ),
    );
  }
}

// 6. HONOR BOARD SCREEN
class HonorBoardScreen extends ConsumerStatefulWidget {
  final String teacherId;
  const HonorBoardScreen({super.key, required this.teacherId});

  @override
  ConsumerState<HonorBoardScreen> createState() => _HonorBoardScreenState();
}

class _HonorBoardScreenState extends ConsumerState<HonorBoardScreen> {
  int _limit = 5;
  List<Map<String, dynamic>> _rankings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshRankings();
  }

  Future<void> _refreshRankings() async {
    setState(() => _isLoading = true);
    try {
      final db = ref.read(databaseProvider);
      final now = DateTime.now();

      // Sat = 6 in Dart weekday
      int diff = now.weekday - DateTime.saturday;
      if (diff < 0) diff += 7;
      final startOfWeek =
          DateTime(now.year, now.month, now.day).subtract(Duration(days: diff));
      final endOfWeek = startOfWeek
          .add(const Duration(days: 7))
          .subtract(const Duration(seconds: 1));

      // Get all daily records for this week
      final records = await (db.select(db.dailyRecordsTable)
            ..where((r) => r.date.isBetweenValues(startOfWeek, endOfWeek)))
          .get();

      // Group by studentId and calculate score (excellent or very_good count)
      final Map<String, int> counts = {};
      for (var r in records) {
        int score = 0;

        // 1. Memorization score
        try {
          final mData = jsonDecode(r.memorizationData);
          if (mData is Map<String, dynamic> && mData.containsKey('entries')) {
            final list = mData['entries'] as List;
            for (var e in list) {
              final grade = e['grade'] as String?;
              if (grade == 'excellent' || grade == 'very_good') {
                score++;
              }
            }
          } else {
            if (r.memorizationGrade == 'excellent' ||
                r.memorizationGrade == 'very_good') {
              score++;
            }
          }
        } catch (_) {
          if (r.memorizationGrade == 'excellent' ||
              r.memorizationGrade == 'very_good') {
            score++;
          }
        }

        // 2. Revision score
        try {
          final rData = jsonDecode(r.revisionData);
          if (rData is Map<String, dynamic> && rData.containsKey('entries')) {
            final list = rData['entries'] as List;
            for (var e in list) {
              final grade = e['grade'] as String?;
              if (grade == 'excellent' || grade == 'very_good') {
                score++;
              }
            }
          } else {
            if (r.revisionGrade == 'excellent' ||
                r.revisionGrade == 'very_good') {
              score++;
            }
          }
        } catch (_) {
          if (r.revisionGrade == 'excellent' ||
              r.revisionGrade == 'very_good') {
            score++;
          }
        }

        if (score > 0) {
          counts[r.studentId] = (counts[r.studentId] ?? 0) + score;
        }
      }

      // Get all students for this teacher to resolve names
      final students = await (db.select(db.studentsTable)
            ..where((s) => s.teacherId.equals(widget.teacherId)))
          .get();
      final Map<String, String> studentNames = {
        for (var s in students) s.id: s.name
      };

      final List<Map<String, dynamic>> temp = [];
      counts.forEach((studentId, score) {
        if (studentNames.containsKey(studentId)) {
          temp.add({
            'studentId': studentId,
            'name': studentNames[studentId]!,
            'score': score,
          });
        }
      });

      // Sort descending by score
      temp.sort((a, b) => b['score'].compareTo(a['score']));

      setState(() {
        _rankings = temp;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _shareHonorBoard() async {
    final now = DateTime.now();
    int diff = now.weekday - DateTime.saturday;
    if (diff < 0) diff += 7;
    final startOfWeek =
        DateTime(now.year, now.month, now.day).subtract(Duration(days: diff));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final dateStr =
        '${startOfWeek.year}/${startOfWeek.month}/${startOfWeek.day} إلى ${endOfWeek.year}/${endOfWeek.month}/${endOfWeek.day}';

    final itemsToShow = _rankings.take(_limit).toList();
    if (itemsToShow.isEmpty) {
      AppNotification.showWarning(context, 'لا توجد بيانات تفوق كافية في هذا الأسبوع بعد');
      return;
    }

    String listStr = '';
    int rank = 1;
    for (var item in itemsToShow) {
      String medal = '';
      if (rank == 1)
        medal = '🥇 الأول';
      else if (rank == 2)
        medal = '🥈 الثاني';
      else if (rank == 3)
        medal = '🥉 الثالث';
      else
        medal = '$rank.';

      listStr +=
          '$medal *${item['name']}* : (${item['score']} إنجاز ممتاز/جيد جداً)\n';
      rank++;
    }

    final String message =
        '🏆 *لوحة الشرف الأسبوعية لحلقة تحفيظ التميز والتمكين* 🏆\n'
        '🗓️ *للأسبوع:* $dateStr\n\n'
        'نسأل الله العظيم أن يبارك في طلابنا المتميزين الذين حققوا أعلى مراتب التسميع والمراجعة بتقدير ممتاز وجيد جداً خلال هذا الأسبوع:\n\n'
        '$listStr\n'
        '-----------------------------------\n'
        '🤲 بارك الله في أولياء الأمور الكرام على حرصهم ومتابعتهم المستمرة، وجعل الله أبنائنا قرة أعين لنا جميعاً. 🌸✨';

    await launchWhatsAppMessage(context: context, message: message);
  }

  Widget _buildPodiumCandidate({
    required String name,
    required int score,
    required int rank,
    required Color color,
    required double podiumHeight,
    required List<Color> gradientColors,
  }) {
    final bool isFirst = rank == 1;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Crown or medal icon
        if (isFirst)
          const Text('👑', style: TextStyle(fontSize: 26))
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.15, 1.15),
                duration: 1.seconds,
              )
              .shimmer(duration: 1.8.seconds, color: Colors.amber.shade200)
        else
          Text(rank == 2 ? '🥈' : '🥉', style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),

        // Avatar
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: gradientColors),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: isFirst ? 24 : 20,
            backgroundColor: Colors.white,
            child: Text(
              name.isNotEmpty ? name[0] : 'ط',
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: isFirst ? 16 : 14,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Name
        SizedBox(
          width: 95,
          child: Text(
            name,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: const Color(0xFF2B3724),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),

        // Score Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.4), width: 1),
          ),
          child: Text(
            '$score إنجاز',
            style: GoogleFonts.cairo(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Podium Block
        Container(
          width: isFirst ? 95 : 82,
          height: podiumHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$rank',
              style: GoogleFonts.cairo(
                fontSize: isFirst ? 28 : 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                shadows: const [
                  Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedList = _rankings.take(_limit).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة الشرف الأسبوعية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshRankings,
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: IslamicPatternBackground()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Celebratory Header card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFDFCF7),
                          IslamicTheme.goldMetallic.withOpacity(0.12),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFC5A85A).withOpacity(0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC5A85A).withOpacity(0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.emoji_events_rounded,
                                size: 52, color: Color(0xFFC5A85A))
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.12, 1.12),
                              duration: 1200.ms,
                              curve: Curves.easeInOut,
                            )
                            .shimmer(
                              duration: 2000.ms,
                              color: Colors.amber.shade200,
                            ),
                        const SizedBox(height: 8),
                        Text(
                          'تاج الوقار وحفظة كتاب الله 👑',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: IslamicTheme.oliveLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'يتم حساب الترتيب أسبوعياً بناءً على عدد مرات التقديرات الممتازة والجيدة جداً للتسميع والمراجعة',
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, curve: AppMotion.standard)
                      .slideY(begin: -0.06, end: 0),
                  const SizedBox(height: 14),

                  // Selector for limit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'عرض المراكز الأولى:',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: IslamicTheme.oliveLight,
                        ),
                      ),
                      DropdownButton<int>(
                        value: _limit,
                        items: const [
                          DropdownMenuItem(
                              value: 5, child: Text('أفضل ٥ طلاب')),
                          DropdownMenuItem(
                              value: 10, child: Text('أفضل ١٠ طلاب')),
                          DropdownMenuItem(
                              value: 15, child: Text('أفضل ١٥ طالباً')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _limit = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Content
                  Expanded(
                    child: _isLoading
                        ? ListView.separated(
                            itemCount: 5,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, __) => const AppShimmer(
                                width: double.infinity,
                                height: 68,
                                borderRadius: 12),
                          )
                        : displayedList.isEmpty
                            ? Center(
                                child: Text(
                                  'لا توجد بيانات تفوق مسجلة للأسبوع الحالي بعد.',
                                  style: GoogleFonts.cairo(
                                      color: Colors.grey, fontSize: 13),
                                ),
                              )
                            : CustomScrollView(
                                slivers: [
                                  // Podium Section for Top 3
                                  if (displayedList.isNotEmpty)
                                    SliverToBoxAdapter(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            // 2nd Place (Silver)
                                            if (displayedList.length >= 2)
                                              _buildPodiumCandidate(
                                                name: displayedList[1]['name'],
                                                score: displayedList[1]['score'],
                                                rank: 2,
                                                color: const Color(0xFF8A9BA8),
                                                podiumHeight: 70,
                                                gradientColors: const [
                                                  Color(0xFFCFD8DC),
                                                  Color(0xFF90A4AE),
                                                  Color(0xFF607D8B),
                                                ],
                                              )
                                                  .animate()
                                                  .fadeIn(
                                                      duration: 450.ms,
                                                      delay: 150.ms)
                                                  .slideY(
                                                      begin: 0.25,
                                                      end: 0,
                                                      curve:
                                                          Curves.easeOutBack)
                                            else
                                              const SizedBox(width: 82),

                                            // 1st Place (Gold)
                                            _buildPodiumCandidate(
                                              name: displayedList[0]['name'],
                                              score: displayedList[0]['score'],
                                              rank: 1,
                                              color: const Color(0xFFC5A85A),
                                              podiumHeight: 100,
                                              gradientColors: const [
                                                Color(0xFFFFDF73),
                                                Color(0xFFD4AF37),
                                                Color(0xFFAA8010),
                                              ],
                                            )
                                                .animate()
                                                .fadeIn(
                                                    duration: 500.ms,
                                                    delay: 50.ms)
                                                .scale(
                                                    begin: const Offset(
                                                        0.85, 0.85),
                                                    end: const Offset(1, 1),
                                                    curve:
                                                        Curves.easeOutBack)
                                                .slideY(
                                                    begin: 0.35,
                                                    end: 0,
                                                    curve:
                                                        Curves.easeOutBack)
                                                .shimmer(
                                                    delay: 600.ms,
                                                    duration: 1500.ms,
                                                    color: Colors.amber.shade100),

                                            // 3rd Place (Bronze)
                                            if (displayedList.length >= 3)
                                              _buildPodiumCandidate(
                                                name: displayedList[2]['name'],
                                                score: displayedList[2]['score'],
                                                rank: 3,
                                                color: const Color(0xFFCD7F32),
                                                podiumHeight: 52,
                                                gradientColors: const [
                                                  Color(0xFFE6A775),
                                                  Color(0xFFCD7F32),
                                                  Color(0xFFA0551E),
                                                ],
                                              )
                                                  .animate()
                                                  .fadeIn(
                                                      duration: 450.ms,
                                                      delay: 250.ms)
                                                  .slideY(
                                                      begin: 0.25,
                                                      end: 0,
                                                      curve:
                                                          Curves.easeOutBack)
                                            else
                                              const SizedBox(width: 82),
                                          ],
                                        ),
                                      ),
                                    ),

                                  // List Header
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10.0, top: 4.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.stars_rounded,
                                              color: Color(0xFFC5A85A), size: 20),
                                          const SizedBox(width: 6),
                                          Text(
                                            'سجل ترتيب الطلاب في لوحة الشرف:',
                                            style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: IslamicTheme.oliveLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Students Cards List
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, idx) {
                                        final item = displayedList[idx];
                                        final rank = idx + 1;

                                        Color badgeColor = Colors.grey.shade400;
                                        Color cardBg = Colors.white;
                                        Border? border;

                                        if (rank == 1) {
                                          badgeColor = const Color(0xFFD4AF37);
                                          cardBg = const Color(0xFFFFFDF5);
                                          border = Border.all(
                                              color: const Color(0xFFD4AF37)
                                                  .withOpacity(0.5),
                                              width: 1.5);
                                        } else if (rank == 2) {
                                          badgeColor = const Color(0xFF90A4AE);
                                          cardBg = const Color(0xFFF9FAFB);
                                          border = Border.all(
                                              color: const Color(0xFF90A4AE)
                                                  .withOpacity(0.4),
                                              width: 1.2);
                                        } else if (rank == 3) {
                                          badgeColor = const Color(0xFFCD7F32);
                                          cardBg = const Color(0xFFFDFBF7);
                                          border = Border.all(
                                              color: const Color(0xFFCD7F32)
                                                  .withOpacity(0.4),
                                              width: 1.2);
                                        }

                                        return AppPressable(
                                          child: Card(
                                            color: cardBg,
                                            elevation: rank <= 3 ? 2 : 0.8,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              side: border?.top ??
                                                  BorderSide(
                                                      color: Colors.grey.shade200,
                                                      width: 1),
                                            ),
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            child: ListTile(
                                              leading: Container(
                                                width: 38,
                                                height: 38,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: badgeColor
                                                      .withOpacity(0.18),
                                                  border: Border.all(
                                                      color: badgeColor,
                                                      width: 1.4),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '$rank',
                                                    style: GoogleFonts.cairo(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: badgeColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              title: Row(
                                                children: [
                                                  if (rank == 1)
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 4.0),
                                                      child: Text('🥇'),
                                                    )
                                                  else if (rank == 2)
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 4.0),
                                                      child: Text('🥈'),
                                                    )
                                                  else if (rank == 3)
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 4.0),
                                                      child: Text('🥉'),
                                                    ),
                                                  Expanded(
                                                    child: Text(
                                                      item['name'],
                                                      style: GoogleFonts.cairo(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                        color: const Color(
                                                            0xFF2B3724),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              trailing: Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 10,
                                                    vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: IslamicTheme.mintPastel,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: IslamicTheme
                                                          .oliveLight
                                                          .withOpacity(0.2),
                                                      width: 1),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                        Icons.star_rounded,
                                                        size: 14,
                                                        color: Color(
                                                            0xFFC5A85A)),
                                                    const SizedBox(width: 4),
                                                    AnimatedCounter(
                                                      value: item['score'] as int,
                                                      style: GoogleFonts.cairo(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: IslamicTheme
                                                            .oliveLight,
                                                      ),
                                                    ),
                                                    Text(
                                                      ' إنجاز تفوق',
                                                      style: GoogleFonts.cairo(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: IslamicTheme
                                                            .oliveLight,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                            .animate()
                                            .fadeIn(
                                              delay: (idx * 50)
                                                  .clamp(0, 400)
                                                  .ms,
                                              duration: 320.ms,
                                              curve: Curves.easeOut,
                                            )
                                            .slideX(
                                              begin: 0.06,
                                              end: 0,
                                              delay: (idx * 50)
                                                  .clamp(0, 400)
                                                  .ms,
                                              duration: 320.ms,
                                              curve: Curves.easeOut,
                                            );
                                      },
                                      childCount: displayedList.length,
                                    ),
                                  ),
                                ],
                              ),
                  ),

                  if (!_isLoading && displayedList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: AppPressable(
                        onTap: _shareHonorBoard,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFD4AF37),
                                Color(0xFFB8972E),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD4AF37).withOpacity(0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _shareHonorBoard,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.share_rounded,
                                color: Colors.white),
                            label: Text(
                              'إرسال لوحة الشرف للمجموعة عبر واتساب',
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.12, end: 0),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}