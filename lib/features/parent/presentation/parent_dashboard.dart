import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:intl/intl.dart' as intl;
import 'package:athar/core/localization/app_localizations.dart';
import 'package:athar/core/theme/theme.dart';
import 'package:athar/features/auth/presentation/auth_providers.dart';
import 'package:athar/core/providers/app_providers.dart';
import 'package:athar/core/models/models.dart';
import 'package:athar/core/database/database_provider.dart';
import 'package:athar/core/database/app_database.dart';
import 'package:athar/core/widgets/islamic_pattern.dart';
import 'package:athar/core/widgets/fade_in_slide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:athar/core/theme/motion.dart';
import 'package:athar/core/quran/quran_data.dart';
import 'dart:convert';

class ParentNotificationItem {
  final String title;
  final String content;
  final DateTime date;
  final IconData icon;
  final Color color;

  ParentNotificationItem({
    required this.title,
    required this.content,
    required this.date,
    required this.icon,
    required this.color,
  });
}

final studentAnnouncementsProvider = FutureProvider.family<List<Announcement>, String>((ref, studentId) async {
  final db = ref.watch(databaseProvider);
  final studentRepo = ref.watch(studentRepositoryProvider);
  final student = await studentRepo.getStudentById(studentId);
  if (student == null || student.teacherId == null) return [];
  
  final list = await (db.select(db.announcementsTable)
        ..where((a) => a.teacherId.equals(student.teacherId!))
        ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
      .get();
      
  final now = DateTime.now();
  return list.map((a) => Announcement(
    id: a.id,
    teacherId: a.teacherId,
    title: a.title,
    content: a.content,
    createdAt: a.createdAt,
    expiryDate: a.expiryDate,
  )).where((a) => a.expiryDate == null || a.expiryDate!.isAfter(now)).toList();
});

final studentUnpaidPaymentsProvider = FutureProvider.family<List<Payment>, String>((ref, studentId) async {
  final db = ref.watch(databaseProvider);
  final list = await (db.select(db.paymentsTable)
        ..where((p) => p.studentId.equals(studentId) & p.isPaid.equals(false)))
      .get();
  return list.map((p) => Payment(
    id: p.id,
    studentId: p.studentId,
    amount: p.amount,
    month: p.month,
    isPaid: p.isPaid,
    paymentDate: p.paymentDate,
    notes: p.notes,
  )).toList();
});

final studentAbsencesProvider = FutureProvider.family<List<Attendance>, String>((ref, studentId) async {
  final db = ref.watch(databaseProvider);
  final list = await (db.select(db.attendanceTable)
        ..where((a) => a.studentId.equals(studentId) & a.isAbsent.equals(true))
        ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
      .get();
  return list.map((a) => Attendance(
    id: a.id,
    studentId: a.studentId,
    date: a.date,
    isAbsent: a.isAbsent,
    arrivalTime: a.arrivalTime,
    departureTime: a.departureTime,
  )).toList();
});

final activeQuizzesProvider = FutureProvider.family<List<Quiz>, String>((ref, teacherId) async {
  final db = ref.watch(databaseProvider);
  final list = await (db.select(db.quizzesTable)
        ..where((q) => q.teacherId.equals(teacherId))
        ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
      .get();
  return list.map((q) => Quiz(
    id: q.id,
    teacherId: q.teacherId,
    title: q.title,
    description: q.description,
    questionsJson: q.questionsJson,
    createdAt: q.createdAt,
  )).toList();
});

final studentQuizAnswersProvider = FutureProvider.family<List<QuizAnswer>, String>((ref, studentId) async {
  final db = ref.watch(databaseProvider);
  final list = await (db.select(db.quizAnswersTable)
        ..where((a) => a.studentId.equals(studentId)))
      .get();
  return list.map((a) => QuizAnswer(
    id: a.id,
    quizId: a.quizId,
    studentId: a.studentId,
    score: a.score,
    answersJson: a.answersJson,
    completedAt: a.completedAt,
  )).toList();
});

final studentAttendanceHistoryProvider = FutureProvider.family<List<Attendance>, String>((ref, studentId) async {
  final db = ref.watch(databaseProvider);
  final list = await (db.select(db.attendanceTable)
        ..where((a) => a.studentId.equals(studentId))
        ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
      .get();
  return list.map((a) => Attendance(
    id: a.id,
    studentId: a.studentId,
    date: a.date,
    isAbsent: a.isAbsent,
    arrivalTime: a.arrivalTime,
    departureTime: a.departureTime,
  )).toList();
});

final studentRemindersProvider = FutureProvider.family<List<Reminder>, String>((ref, studentId) async {
  final db = ref.watch(databaseProvider);
  final list = await (db.select(db.remindersTable)
        ..where((r) => r.studentId.equals(studentId) | r.studentId.isNull())
        ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
      .get();
  return list.map((r) => Reminder(
    id: r.id,
    studentId: r.studentId,
    title: r.title,
    content: r.content,
    createdAt: r.createdAt,
  )).toList();
});

class ParentDashboardScreen extends ConsumerStatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  ConsumerState<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends ConsumerState<ParentDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _scheduleCtrl = TextEditingController();

  int _currentQuestionIndex = 0;
  List<int> _selectedAnswers = [];
  bool _quizFinished = false;
  int _quizScore = 0;
  String? _activeQuizId;
  int? _selectedOptionIndex;
  bool _hasConfirmedAnswer = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scheduleCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveParentSchedule(String studentId) async {
    if (_scheduleCtrl.text.isEmpty) return;

    final recordRepo = ref.read(recordRepositoryProvider);
    await recordRepo.saveParentSchedule(studentId, _scheduleCtrl.text.trim());

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تحديث جدول الأنشطة والحصص بنجاح')),
    );
    ref.invalidate(studentScheduleProvider(studentId));
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(translationsProvider);
    final student = ref.watch(currentStudentProvider);

    if (student == null) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('تسجيل الدخول أولاً'),
          ),
        ),
      );
    }

    final tomorrowPlanAsync = ref.watch(studentTomorrowPlanProvider(student.id));
    final attendanceHistoryAsync = ref.watch(studentAttendanceHistoryProvider(student.id));
    final archiveAsync = ref.watch(studentDailyArchiveProvider(student.id));
    final quizzesAsync = ref.watch(activeQuizzesProvider(student.teacherId ?? ''));
    final answersAsync = ref.watch(studentQuizAnswersProvider(student.id));

    // Handle initial text load for parent schedule field
    ref.listen<AsyncValue<ParentSchedule?>>(studentScheduleProvider(student.id), (prev, next) {
      next.whenData((schedule) {
        if (schedule != null && _scheduleCtrl.text.isEmpty) {
          _scheduleCtrl.text = schedule.lessonsJson;
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('parent_dashboard')),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              ref.read(currentStudentProvider.notifier).logout();
              context.go('/');
            },
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: tr.translate('teacher_report_tab')),
            Tab(text: tr.translate('tomorrow_prep_tab')),
            Tab(text: tr.translate('badges_tab')),
            Tab(text: tr.translate('honor_tab')),
            Tab(text: tr.translate('financial_tab')),
            const Tab(text: 'جدول الطالب'),
            const Tab(text: 'الإشعارات'),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Subtle Islamic geometric background pattern
          const Positioned.fill(
            child: IslamicPatternBackground(),
          ),
          
          Column(
            children: [
              // Welcome header banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: Column(
                  children: [
                    Text(
                      '${tr.translate('welcome_parent')} ${student.name}',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold, 
                        fontSize: 16, 
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'المستوى الحالي: ${student.achievementLevel} | الرصيد: ⭐ ',
                          style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[700]),
                        ),
                        AnimatedCounter(
                          value: student.stars,
                          style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                          suffix: ' نجمة',
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 350.ms, curve: AppMotion.standard).slideY(begin: -0.05, end: 0),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // 1. TODAY'S REPORT TAB (Unified Timeline)
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // MCQ Quiz Card at the top (if any unanswered active quiz)
                          quizzesAsync.when(
                            data: (quizzes) {
                              return answersAsync.when(
                                data: (answers) {
                                  final answeredQuizIds = answers.map((a) => a.quizId).toSet();
                                  final activeUnansweredQuiz = quizzes.where((q) => !answeredQuizIds.contains(q.id)).firstOrNull;
                                  
                                  if (activeUnansweredQuiz != null) {
                                    return Column(
                                      children: [
                                        _buildQuizCard(activeUnansweredQuiz, student.id),
                                        const SizedBox(height: 16),
                                      ],
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                                loading: () => const SizedBox.shrink(),
                                error: (_, __) => const SizedBox.shrink(),
                              );
                            },
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                          
                          // Timeline header
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              'تقارير المعلم اليومية 📋',
                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 15, color: IslamicTheme.oliveDeep),
                            ),
                          ),
                          
                          // Daily Timeline cards
                          attendanceHistoryAsync.when(
                            data: (attendanceList) {
                              return archiveAsync.when(
                                data: (dailyRecords) {
                                  if (attendanceList.isEmpty) {
                                    return Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Text(
                                          'لا توجد تقارير مسجلة بعد لهذا الطالب.',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: attendanceList.length,
                                    itemBuilder: (context, index) {
                                      final att = attendanceList[index];
                                      final record = dailyRecords.where((r) =>
                                          r.date.year == att.date.year &&
                                          r.date.month == att.date.month &&
                                          r.date.day == att.date.day).firstOrNull;

                                      return _buildDailyCard(context, att, record, student);
                                    },
                                  );
                                },
                                loading: () => const Center(child: CircularProgressIndicator()),
                                error: (err, s) => Center(child: Text('خطأ: $err')),
                              );
                            },
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (err, s) => Center(child: Text('خطأ: $err')),
                          ),
                        ],
                      ),
                    ),

                    // 2. TOMORROW PREPARATION TAB
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: tomorrowPlanAsync.when(
                        data: (plan) {
                          if (plan == null) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(
                                  'لم يقم المعلم بجدولة خطة الغد بعد.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }

                          return FadeInSlide(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'يرجى تهيئة الطالب ومساعدته على تحضير الآيات التالية للغد:',
                                  style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 16),
                                _buildReportBlock('خطة الحفظ للغد', plan.memorizationMethod, _formatQuranData(plan.memorizationMethod, plan.memorizationData), 'قيد التحضير', Colors.blue),
                                const SizedBox(height: 16),
                                _buildReportBlock('خطة المراجعة للغد', plan.revisionMethod, _formatQuranData(plan.revisionMethod, plan.revisionData), 'قيد التحضير', Colors.orange),
                                if (plan.notes != null && plan.notes!.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  _buildNotesCard('ملاحظات التحضير', plan.notes!, Icons.assignment_outlined),
                                ]
                              ],
                            ),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, s) => Center(child: Text('خطأ: $err')),
                      ),
                    ),

                    // 3. REWARDS & BADGES TAB (Matching Screen 8)
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: FadeInSlide(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Student Profile Details Header inside Tab
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), width: 1),
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 28,
                                    backgroundColor: IslamicTheme.mintPastel,
                                    child: Icon(Icons.person, color: IslamicTheme.oliveLight, size: 32),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student.name,
                                          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).colorScheme.primary),
                                        ),
                                        Text(
                                          'ولي الأمر: ${student.parentName} (${student.parentPhone})',
                                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'المستوى: ⭐️⭐️',
                                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.amber[800]),
                                      ),
                                      Text(
                                        'النقاط: 1250',
                                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.teal),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Medals/Badges layout (Screen 8)
                            Text('الأوسمة المحققة', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.primary)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildRibbonMedal('الانتظام', Colors.amber[700]!, Icons.verified_user_outlined),
                                _buildRibbonMedal('حفظ متميز', Colors.orange, Icons.star_border_outlined),
                                _buildRibbonMedal('بطل الحفظ', Colors.brown, Icons.emoji_events_outlined),
                                _buildRibbonMedal('المنبر', Colors.blue, Icons.campaign_outlined),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Points History Log list (Screen 8 - سجل النقاط)
                            Text('سجل النقاط', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.primary)),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), width: 1),
                              ),
                              child: ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  _buildPointsLogTile('+50', 'حفظ اليوم الجديد', '2026/06/05', Colors.green),
                                  const Divider(height: 1),
                                  _buildPointsLogTile('+100', 'تسميع ممتاز في الحلقة', '2026/06/03', Colors.green),
                                  const Divider(height: 1),
                                  _buildPointsLogTile('+20', 'حضور مبكر للحلقة', '2026/06/02', Colors.green),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 4. HONOR BOARD TAB (Podium Layout matching Screen 9)
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: FadeInSlide(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'لوحة الشرف الأسبوعية للحلقة 👑', 
                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).colorScheme.primary),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

                            // Podium blocks row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // 2nd Place (Silver - Left)
                                _buildPodiumCandidate('سليمان فيصل', '280 نقطة', '2', const Color(0xFFC0C0C0), 75),
                                
                                // 1st Place (Gold - Middle)
                                Column(
                                  children: [
                                    const Icon(Icons.workspace_premium, color: Colors.amber, size: 28),
                                    _buildPodiumCandidate(student.name, '320 نقطة', '1', const Color(0xFFD4AF37), 105),
                                  ],
                                ),
                                
                                // 3rd Place (Bronze - Right)
                                _buildPodiumCandidate('عبد الله فيصل', '250 نقطة', '3', const Color(0xFFCD7F32), 55),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // list of other honored candidates
                            Text(
                              'جميع المكرمين',
                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.primary),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), width: 1),
                              ),
                              child: Column(
                                children: [
                                  _buildHonoredRow('4', 'محمد ياسر', '240 نقطة'),
                                  const Divider(height: 1),
                                  _buildHonoredRow('5', 'يوسف ناصر', '200 نقطة'),
                                  const Divider(height: 1),
                                  _buildHonoredRow('6', 'فهد محمد', '180 نقطة'),
                                  const Divider(height: 1),
                                  _buildHonoredRow('7', 'زياد أحمد', '150 نقطة'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 5. FINANCIAL STATUS TAB
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: FadeInSlide(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('الوضع المالي وتفاصيل الاشتراكات', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).colorScheme.primary)),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), width: 1),
                              ),
                              child: Column(
                                children: [
                                  _buildFinancialRow('اشتراك شهر يونيو ٢٠٢٦', '١٥٠ ريال', 'غير مدفوع', Colors.red),
                                  const Divider(height: 24),
                                  _buildFinancialRow('اشتراك شهر مايو ٢٠٢٦', '١٥٠ ريال', 'مدفوع (رقم الإيصال: REC-1025)', Colors.green),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 6. STUDENT SCHEDULE ENTRY TAB (Parent edits)
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: FadeInSlide(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('تعديل جدول حصص وأنشطة الطالب', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).colorScheme.primary)),
                            const SizedBox(height: 4),
                            Text('سيرى المعلم هذا الجدول لمراعاة الطالب في التسميع والتحضير', style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey)),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _scheduleCtrl,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                labelText: 'أدخل تفاصيل جدول الطالب (الحصص المدرسية، أوقات الاختبارات، التدريبات والرياضة)',
                                alignLabelWithHint: true,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => _saveParentSchedule(student.id),
                              child: const Text('تحديث وحفظ الجدول'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 7. NOTIFICATIONS TAB
                    _buildNotificationsTab(student.id),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper to draw clean podium column
  Widget _buildPodiumCandidate(String name, String points, String rank, Color color, double podiumHeight) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color.withValues(alpha: 0.2),
          child: Text(
            name.isNotEmpty ? name[0] : '', 
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: color),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name, 
          style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Container(
          width: 70,
          height: podiumHeight,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Text(rank, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
              ),
              const SizedBox(height: 4),
              Text(points, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHonoredRow(String rank, String name, String points) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.grey[100],
            child: Text(rank, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.cairo(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Text(
            points,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
        ],
      ),
    );
  }

  Widget _buildRibbonMedal(String label, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.bold, color: IslamicTheme.oliveLight),
        ),
      ],
    );
  }

  Widget _buildPointsLogTile(String points, String title, String date, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.stars, color: Colors.amber[850], size: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.cairo(fontWeight: FontWeight.w600, fontSize: 13)),
                  Text(date, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
          Text(
            points,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color),
          ),
        ],
      ),
    );
  }

  String _formatQuranData(String method, String rawData) {
    if (rawData.isEmpty) return '';
    try {
      final data = jsonDecode(rawData);
      switch (method) {
        case 'surah':
          final surahId = data['surahId'] ?? 1;
          final start = data['startVerse'] ?? 1;
          final end = data['endVerse'] ?? 1;
          final surahName = QuranData.getSurahById(surahId)?.nameAr ?? '';
          return 'سورة $surahName من الآية $start إلى الآية $end';
        case 'range':
          final startSurah = data['startSurahId'] ?? 1;
          final endSurah = data['endSurahId'] ?? 1;
          final startName = QuranData.getSurahById(startSurah)?.nameAr ?? '';
          final endName = QuranData.getSurahById(endSurah)?.nameAr ?? '';
          return 'من سورة $startName إلى سورة $endName';
        case 'juz':
          final juzId = data['juzId'] ?? 1;
          return 'الجزء $juzId كاملاً';
        case 'multiple':
          final List<dynamic> surahIds = data['surahIds'] ?? [];
          final names = surahIds.map((id) => QuranData.getSurahById(id as int)?.nameAr ?? '').join('، ');
          return 'سور متفرقة: $names';
        default:
          return rawData;
      }
    } catch (_) {
      return rawData;
    }
  }

  Widget _buildReportBlock(String title, String method, String rawData, String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            'طريقة التحديد: ${method == 'surah' ? 'سورة محددة' : method == 'range' ? 'نطاق سور' : method == 'juz' ? 'أجزاء كاملة' : 'سور متفرقة'}', 
            style: GoogleFonts.cairo(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text('المحتوى: $rawData', style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildNotesCard(String title, String content, IconData icon, {bool isGold = false}) {
    return Card(
      color: isGold ? Colors.amber[50] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isGold ? Colors.amber[300]! : const Color(0xFFE4ECD5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: isGold ? Colors.orange : IslamicTheme.oliveLight, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13, color: IslamicTheme.oliveLight)),
                  const SizedBox(height: 4),
                  Text(content, style: GoogleFonts.cairo(fontSize: 12, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialRow(String title, String val, String status, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13, color: IslamicTheme.oliveLight)),
            Text(val, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        Text(status, style: GoogleFonts.cairo(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  Future<void> _saveQuizAnswer(String quizId, String studentId, int score, List<int> selectedAnswers) async {
    try {
      final db = ref.read(databaseProvider);
      final id = 'QA_${quizId}_${studentId}_${DateTime.now().millisecondsSinceEpoch}';
      
      await db.into(db.quizAnswersTable).insert(QuizAnswersTableCompanion.insert(
        id: id,
        quizId: quizId,
        studentId: studentId,
        score: score,
        answersJson: jsonEncode(selectedAnswers),
        completedAt: DateTime.now(),
      ));
      
      ref.invalidate(studentQuizAnswersProvider(studentId));
      
      final studentRepo = ref.read(studentRepositoryProvider);
      await studentRepo.updateStudentRewards(studentId, score * 5, score);
      
      final updatedStudent = await studentRepo.getStudentById(studentId);
      if (updatedStudent != null) {
        ref.read(currentStudentProvider.notifier).login(updatedStudent);
      }
    } catch (_) {}
  }

  Widget _buildQuizCard(Quiz quiz, String studentId) {
    final List<dynamic> questions = jsonDecode(quiz.questionsJson);
    if (questions.isEmpty) return const SizedBox.shrink();

    if (_activeQuizId != quiz.id) {
      _activeQuizId = quiz.id;
      _currentQuestionIndex = 0;
      _selectedAnswers = [];
      _quizFinished = false;
      _quizScore = 0;
      _selectedOptionIndex = null;
      _hasConfirmedAnswer = false;
    }

    if (_quizFinished) {
      return Card(
        color: IslamicTheme.mintPastel.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: IslamicTheme.oliveLight, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 48),
              const SizedBox(height: 12),
              Text(
                'أحسنت! لقد أكملت اختبار آداب: ${quiz.title}',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16, color: IslamicTheme.oliveLight),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'درجتك: $_quizScore من ${questions.length}',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green),
              ),
            ],
          ),
        ),
      );
    }

    final currentQuestion = questions[_currentQuestionIndex];
    final questionText = currentQuestion['question'] as String;
    final List<dynamic> options = currentQuestion['options'] as List<dynamic>;
    final int correctIdx = currentQuestion['correctIndex'] as int;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color(0xFFC5A85A).withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'سؤال آداب مقترح 📖',
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, fontSize: 13),
                ),
                Text(
                  'السؤال ${_currentQuestionIndex + 1} من ${questions.length}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              questionText,
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ...List.generate(options.length, (idx) {
              final optionText = options[idx] as String;
              
              // Styling logic for options based on state
              Color cardColor = const Color(0xFFFDFCF9);
              BorderSide borderSide = BorderSide(color: Colors.grey.withOpacity(0.2), width: 1);

              if (_hasConfirmedAnswer) {
                if (idx == correctIdx) {
                  cardColor = const Color(0xFFE8F5E9); // Light green for correct
                  borderSide = const BorderSide(color: Colors.green, width: 1.5);
                } else if (idx == _selectedOptionIndex && idx != correctIdx) {
                  cardColor = const Color(0xFFFFEBEE); // Light red for incorrect choice
                  borderSide = const BorderSide(color: Colors.red, width: 1.5);
                }
              } else {
                if (idx == _selectedOptionIndex) {
                  cardColor = const Color(0xFFFFFDF0); // Selected highlight
                  borderSide = const BorderSide(color: IslamicTheme.goldMetallic, width: 1.8);
                }
              }

              IconData trailingIcon = Icons.radio_button_off;
              Color iconColor = Colors.grey;

              if (_hasConfirmedAnswer) {
                if (idx == correctIdx) {
                  trailingIcon = Icons.check_circle;
                  iconColor = Colors.green;
                } else if (idx == _selectedOptionIndex && idx != correctIdx) {
                  trailingIcon = Icons.cancel;
                  iconColor = Colors.red;
                } else {
                  trailingIcon = Icons.radio_button_off;
                  iconColor = Colors.grey.withOpacity(0.3);
                }
              } else {
                if (idx == _selectedOptionIndex) {
                  trailingIcon = Icons.radio_button_checked;
                  iconColor = IslamicTheme.goldMetallic;
                }
              }

              return Card(
                color: cardColor,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: borderSide,
                ),
                child: ListTile(
                  title: Text(optionText, style: GoogleFonts.cairo(fontSize: 13, fontWeight: idx == _selectedOptionIndex || (_hasConfirmedAnswer && idx == correctIdx) ? FontWeight.bold : FontWeight.normal)),
                  trailing: Icon(trailingIcon, color: iconColor, size: 18),
                  onTap: _hasConfirmedAnswer ? null : () {
                    setState(() {
                      _selectedOptionIndex = idx;
                    });
                  },
                ),
              );
            }),
            const SizedBox(height: 16),
            
            // Confirm/Next action button
            if (_selectedOptionIndex != null) ...[
              if (!_hasConfirmedAnswer)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _hasConfirmedAnswer = true;
                      if (_selectedOptionIndex == correctIdx) {
                        _quizScore++;
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: IslamicTheme.oliveLight,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('تأكيد الإجابة'),
                )
              else
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _selectedAnswers.add(_selectedOptionIndex!);
                      
                      if (_currentQuestionIndex + 1 < questions.length) {
                        _currentQuestionIndex++;
                        _selectedOptionIndex = null;
                        _hasConfirmedAnswer = false;
                      } else {
                        _quizFinished = true;
                        _saveQuizAnswer(quiz.id, studentId, _quizScore, _selectedAnswers);
                      }
                    });
                  },
                  child: Text(
                    _currentQuestionIndex + 1 < questions.length ? 'السؤال التالي' : 'إنهاء وعرض النتيجة',
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsTab(String studentId) {
    final announcementsAsync = ref.watch(studentAnnouncementsProvider(studentId));
    final unpaidPaymentsAsync = ref.watch(studentUnpaidPaymentsProvider(studentId));
    final absencesAsync = ref.watch(studentAbsencesProvider(studentId));
    final remindersAsync = ref.watch(studentRemindersProvider(studentId));

    return announcementsAsync.when(
      data: (announcements) {
        return unpaidPaymentsAsync.when(
          data: (payments) {
            return absencesAsync.when(
              data: (absences) {
                return remindersAsync.when(
                  data: (reminders) {
                    final List<ParentNotificationItem> items = [];

                    for (var ann in announcements) {
                      items.add(ParentNotificationItem(
                        title: ann.title,
                        content: ann.content,
                        date: ann.createdAt,
                        icon: Icons.campaign_rounded,
                        color: const Color(0xFFC5A85A),
                      ));
                    }

                    for (var rem in reminders) {
                      items.add(ParentNotificationItem(
                        title: rem.title,
                        content: rem.content,
                        date: rem.createdAt,
                        icon: Icons.notifications_active_rounded,
                        color: IslamicTheme.oliveLight,
                      ));
                    }

                    for (var pay in payments) {
                      items.add(ParentNotificationItem(
                        title: 'تنبيه دفع: اشتراك مستحق',
                        content: 'يرجى سداد اشتراك شهر ${pay.month} البالغ قيمته ${pay.amount.toStringAsFixed(0)} ج.م. ${pay.notes ?? ""}',
                        date: DateTime.now(),
                        icon: Icons.monetization_on_outlined,
                        color: Colors.red,
                      ));
                    }

                    for (var abs in absences) {
                      final formattedDate = '${abs.date.year}/${abs.date.month}/${abs.date.day}';
                      items.add(ParentNotificationItem(
                        title: 'تسجيل غياب عن الحلقة',
                        content: 'تم تسجيل غياب الطالب يوم $formattedDate. عساه أن يكون بخير 🌸',
                        date: abs.date,
                        icon: Icons.person_off_outlined,
                        color: Colors.orange,
                      ));
                    }

                    items.sort((a, b) => b.date.compareTo(a.date));

                    if (items.isEmpty) {
                      return const Center(child: Text('لا توجد إشعارات حالية'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      itemBuilder: (context, idx) {
                        final item = items[idx];
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: item.color.withOpacity(0.3), width: 1),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: item.color.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(item.icon, color: item.color),
                            ),
                            title: Text(item.title, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13, color: IslamicTheme.oliveLight)),
                            subtitle: Text(item.content, style: GoogleFonts.cairo(fontSize: 12)),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, s) => Center(child: Text('خطأ: $err')),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, s) => Center(child: Text('خطأ: $err')),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, s) => Center(child: Text('خطأ: $err')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, s) => Center(child: Text('خطأ: $err')),
    );
  }

  Widget _buildDailyCard(BuildContext context, Attendance att, DailyRecord? record, Student student) {
    final dateStr = _formatArabicDate(att.date);
    final isAbsent = att.isAbsent;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (isAbsent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.5)),
                    ),
                    child: Text(
                      'غائب 🔴',
                      style: GoogleFonts.cairo(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withOpacity(0.5)),
                    ),
                    child: Text(
                      'حاضر 🟢',
                      style: GoogleFonts.cairo(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
            const Divider(height: 20),

            if (!isAbsent) ...[
              if (att.arrivalTime != null) ...[
                Row(
                  children: [
                    const Icon(Icons.access_time_filled_rounded, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      'وقت الحضور: ${TimeOfDay.fromDateTime(att.arrivalTime!).format(context)}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    if (att.departureTime != null) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.logout_rounded, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        'الانصراف: ${TimeOfDay.fromDateTime(att.departureTime!).format(context)}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
              ],

              if (record != null) ...[
                _buildTimelineRecordSection(
                  title: 'الحفظ الجديد 📖',
                  method: record.memorizationMethod,
                  data: record.memorizationData,
                  grade: record.memorizationGrade,
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),
                
                _buildTimelineRecordSection(
                  title: 'المراجعة والتمكين 🔁',
                  method: record.revisionMethod,
                  data: record.revisionData,
                  grade: record.revisionGrade,
                  color: Colors.orange,
                ),

                if (record.teacherNotes != null && record.teacherNotes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildNotesCard('ملاحظات المعلم', record.teacherNotes!, Icons.note_alt_outlined),
                ],

                if (record.encouragementMessage != null && record.encouragementMessage!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildNotesCard('رسالة تحفيزية للولد 🌟', record.encouragementMessage!, Icons.emoji_emotions_outlined, isGold: true),
                ],
              ] else ...[
                Text(
                  'لم يتم إدخال تفاصيل الحفظ والتسميع لهذا اليوم بعد.',
                  style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ],
            ] else ...[
              Text(
                'عسى المانع خيراً. نرجو من ولي الأمر متابعة حفظ الطالب غداً.',
                style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[750]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineRecordSection({
    required String title,
    required String method,
    required String data,
    required String grade,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: color,
                ),
              ),
              _buildGradeBadge(grade),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _formatQuranData(method, data),
            style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeBadge(String grade) {
    String text = '';
    Color color = Colors.grey;
    switch (grade) {
      case 'excellent':
        text = 'ممتاز';
        color = Colors.green;
        break;
      case 'very_good':
        text = 'جيد جداً';
        color = Colors.blue;
        break;
      case 'good':
        text = 'جيد';
        color = Colors.orange;
        break;
      case 'not_memorized':
        text = 'لم يحفظ';
        color = Colors.red;
        break;
      case 'postponed':
        text = 'مؤجل';
        color = Colors.purple;
        break;
      default:
        text = grade;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: GoogleFonts.cairo(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  String _formatArabicDate(DateTime date) {
    try {
      final formatter = intl.DateFormat('EEEE، d MMMM yyyy', 'ar');
      return formatter.format(date);
    } catch (_) {
      return '${date.year}/${date.month}/${date.day}';
    }
  }
}
