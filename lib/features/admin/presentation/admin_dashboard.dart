import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:athar/core/localization/app_localizations.dart';
import 'package:athar/core/theme/theme.dart';
import 'package:athar/core/models/models.dart';
import 'package:athar/core/database/database_provider.dart';
import 'package:athar/core/database/app_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:athar/core/widgets/islamic_pattern.dart';
import 'package:athar/core/widgets/fade_in_slide.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Teacher> _teachers = [];
  List<Student> _students = [];
  bool _isLoading = true;

  double _attendanceRate = 100.0;
  double _collectionRate = 100.0;
  double _totalDue = 0.0;
  double _totalPaid = 0.0;
  Map<String, double> _teacherPerformances = {};
  double _averagePerformance = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final db = ref.read(databaseProvider);
    final teachersData = await db.select(db.teachersTable).get();
    final studentsData = await db.select(db.studentsTable).get();
    final attendanceData = await db.select(db.attendanceTable).get();
    final paymentsData = await db.select(db.paymentsTable).get();
    final dailyRecordsData = await db.select(db.dailyRecordsTable).get();

    _teachers = teachersData
        .map((t) => Teacher(
              id: t.id,
              fullName: t.fullName,
              phoneNumber: t.phoneNumber,
              loginCode: t.loginCode,
              isActive: t.isActive,
              studentCount: t.studentCount,
            ))
        .toList();

    _students = studentsData
        .map((s) => Student(
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
            ))
        .toList();

    // Calculate real Attendance Rate
    if (attendanceData.isNotEmpty) {
      final presentCount = attendanceData.where((a) => !a.isAbsent).length;
      _attendanceRate = (presentCount / attendanceData.length) * 100;
    } else {
      _attendanceRate = 100.0;
    }

    // Calculate real Collection Rate & Revenue Summary
    _totalDue = paymentsData.map((p) => p.amount).fold(0.0, (a, b) => a + b);
    _totalPaid = paymentsData
        .where((p) => p.isPaid)
        .map((p) => p.amount)
        .fold(0.0, (a, b) => a + b);
    if (_totalDue > 0) {
      _collectionRate = (_totalPaid / _totalDue) * 100;
    } else {
      _collectionRate = 100.0;
    }

    // Calculate Teacher Performances
    _teacherPerformances.clear();
    double totalPerfSum = 0.0;
    for (var teacher in _teachers) {
      final teacherStudentIds = _students
          .where((s) => s.teacherId == teacher.id)
          .map((s) => s.id)
          .toSet();
      final teacherRecords = dailyRecordsData
          .where((r) => teacherStudentIds.contains(r.studentId))
          .toList();

      double perf = 0.8; // Default fallback to 80% if no records yet
      if (teacherRecords.isNotEmpty) {
        final highGradesCount = teacherRecords
            .where((r) =>
                r.memorizationGrade == 'excellent' ||
                r.memorizationGrade == 'very_good')
            .length;
        perf = highGradesCount / teacherRecords.length;
      }
      _teacherPerformances[teacher.id] = perf;
      totalPerfSum += perf;
    }
    _averagePerformance =
        _teachers.isNotEmpty ? totalPerfSum / _teachers.length : 0.8;

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _addTeacher() async {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    bool isActive = true;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('إضافة معلم جديد',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'الاسم الكامل'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: codeCtrl,
                decoration:
                    const InputDecoration(labelText: 'رمز الدخول السري'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty &&
                  phoneCtrl.text.isNotEmpty &&
                  codeCtrl.text.isNotEmpty) {
                final db = ref.read(databaseProvider);
                final id = const Uuid().v4();
                final name = nameCtrl.text.trim();
                final phone = phoneCtrl.text.trim();
                final code = codeCtrl.text.trim();

                await db
                    .into(db.teachersTable)
                    .insert(TeachersTableCompanion.insert(
                      id: id,
                      fullName: name,
                      phoneNumber: phone,
                      loginCode: code,
                      isActive: Value(isActive),
                    ));

                if (ctx.mounted) {
                  Navigator.pop(ctx);
                }
                _loadData();
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  Future<void> _editTeacher(Teacher teacher) async {
    final nameCtrl = TextEditingController(text: teacher.fullName);
    final phoneCtrl = TextEditingController(text: teacher.phoneNumber);
    final codeCtrl = TextEditingController(text: teacher.loginCode);

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تعديل بيانات المعلم',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'الاسم الكامل'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: codeCtrl,
                decoration:
                    const InputDecoration(labelText: 'رمز الدخول السري'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final db = ref.read(databaseProvider);
              final name = nameCtrl.text.trim();
              final phone = phoneCtrl.text.trim();
              final code = codeCtrl.text.trim();

              await (db.update(db.teachersTable)
                    ..where((t) => t.id.equals(teacher.id)))
                  .write(
                TeachersTableCompanion(
                  fullName: Value(name),
                  phoneNumber: Value(phone),
                  loginCode: Value(code),
                ),
              );

              if (ctx.mounted) {
                Navigator.pop(ctx);
              }
              _loadData();
            },
            child: const Text('حفظ التعديلات'),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleTeacherActive(Teacher teacher) async {
    final db = ref.read(databaseProvider);
    final newActiveState = !teacher.isActive;
    await (db.update(db.teachersTable)..where((t) => t.id.equals(teacher.id)))
        .write(
      TeachersTableCompanion(
        isActive: Value(newActiveState),
      ),
    );

    _loadData();
  }

  Future<void> _deleteTeacher(Teacher teacher) async {
    final db = ref.read(databaseProvider);
    await (db.delete(db.teachersTable)..where((t) => t.id.equals(teacher.id)))
        .go();

    _loadData();
  }

  Future<void> _transferStudentsDialog(Teacher sourceTeacher) async {
    Teacher? targetTeacher;
    final otherTeachers =
        _teachers.where((t) => t.id != sourceTeacher.id && t.isActive).toList();

    if (otherTeachers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('لا يوجد معلمون آخرون نشطون لنقل الطلاب إليهم')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('نقل طلاب حلقة',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('نقل طلاب الشيخ ${sourceTeacher.fullName} إلى:'),
            const SizedBox(height: 16),
            DropdownButtonFormField<Teacher>(
              decoration:
                  const InputDecoration(labelText: 'اختر المعلم المستهدف'),
              items: otherTeachers.map((t) {
                return DropdownMenuItem<Teacher>(
                  value: t,
                  child: Text(t.fullName),
                );
              }).toList(),
              onChanged: (val) {
                targetTeacher = val;
              },
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
              if (targetTeacher != null) {
                final db = ref.read(databaseProvider);
                // Update all students belonging to sourceTeacher to targetTeacher
                await (db.update(db.studentsTable)
                      ..where((s) => s.teacherId.equals(sourceTeacher.id)))
                    .write(
                  StudentsTableCompanion(
                    teacherId: Value(targetTeacher!.id),
                  ),
                );

                // Recalculate student counts
                final sourceCount = await (db.select(db.studentsTable)
                      ..where((s) => s.teacherId.equals(sourceTeacher.id)))
                    .get();
                final targetCount = await (db.select(db.studentsTable)
                      ..where((s) => s.teacherId.equals(targetTeacher!.id)))
                    .get();

                await (db.update(db.teachersTable)
                      ..where((t) => t.id.equals(sourceTeacher.id)))
                    .write(
                  TeachersTableCompanion(
                      studentCount: Value(sourceCount.length)),
                );
                await (db.update(db.teachersTable)
                      ..where((t) => t.id.equals(targetTeacher!.id)))
                    .write(
                  TeachersTableCompanion(
                      studentCount: Value(targetCount.length)),
                );

                if (ctx.mounted) {
                  Navigator.pop(ctx);
                }
                _loadData();
              }
            },
            child: const Text('تأكيد النقل'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(translationsProvider);
    final activeCount = _teachers.where((t) => t.isActive).length;
    final totalStudentsCount = _students.length;
    final activeStudentsCount =
        _students.where((s) => s.teacherId != null).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('admin_dashboard')),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.go('/'),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الإحصائيات العامة'),
            Tab(text: 'إدارة المعلمين'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                const Positioned.fill(
                  child: IslamicPatternBackground(),
                ),
                TabBarView(
                  controller: _tabController,
                  children: [
                    // 1. STATS TAB
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: FadeInSlide(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Stat Cards Grid
                            GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              childAspectRatio: 1.4,
                              children: [
                                _buildStatCard(
                                    'إجمالي المعلمين',
                                    '${_teachers.length}',
                                    'النشطين: $activeCount',
                                    Icons.people,
                                    Colors.teal),
                                _buildStatCard(
                                    'إجمالي الطلاب',
                                    '$totalStudentsCount',
                                    'النشطين: $activeStudentsCount',
                                    Icons.school,
                                    Colors.blue),
                                _buildStatCard(
                                    'الحضور اليومي',
                                    '${_attendanceRate.toStringAsFixed(0)}٪',
                                    'معدل الحضور العام',
                                    Icons.check_circle,
                                    Colors.green),
                                _buildStatCard(
                                    'نسبة التحصيل',
                                    '${_collectionRate.toStringAsFixed(0)}٪',
                                    'حالة الاشتراكات',
                                    Icons.monetization_on,
                                    Colors.orange),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Premium visual report card
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: IslamicTheme.premiumCardDecoration(
                                  context: context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'أداء الحلقات العام لهذا الشهر',
                                    style: GoogleFonts.cairo(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 16),
                                  ..._teachers.take(3).map((teacher) {
                                    final perf =
                                        _teacherPerformances[teacher.id] ?? 0.8;
                                    final pct = (perf * 100).toStringAsFixed(0);
                                    String gradeName = 'ممتاز';
                                    Color col = Colors.teal;
                                    if (perf < 0.6) {
                                      gradeName = 'جيد';
                                      col = Colors.orange;
                                    } else if (perf < 0.85) {
                                      gradeName = 'جيد جداً';
                                      col = Colors.blue;
                                    }
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: _buildProgressRow(
                                          'حلقة الشيخ ${teacher.fullName}',
                                          perf,
                                          '$gradeName ($pct٪)',
                                          col),
                                    );
                                  }),
                                  if (_teachers.isEmpty)
                                    Text('لا توجد حلقات مسجلة',
                                        style: GoogleFonts.cairo(
                                            color: Colors.grey, fontSize: 12)),
                                  const SizedBox(height: 12),
                                  _buildProgressRow(
                                      'متوسط تقدم المركز',
                                      _averagePerformance,
                                      'جيد جداً (${(_averagePerformance * 100).toStringAsFixed(0)}٪)',
                                      Colors.orange),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Revenue summary card
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: IslamicTheme.premiumCardDecoration(
                                  context: context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ملخص الإيرادات والتحصيل',
                                    style: GoogleFonts.cairo(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('المجموع الكلي المستحق:',
                                          style: GoogleFonts.cairo(
                                              color: Colors.grey)),
                                      Text(
                                          '${_totalDue.toStringAsFixed(0)} ج.م',
                                          style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('المجموع المحصل:',
                                          style: GoogleFonts.cairo(
                                              color: Colors.grey)),
                                      Text(
                                          '${_totalPaid.toStringAsFixed(0)} ج.م',
                                          style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('المتبقي للتحصيل:',
                                          style: GoogleFonts.cairo(
                                              color: Colors.grey)),
                                      Text(
                                          '${(_totalDue - _totalPaid).toStringAsFixed(0)} ج.م',
                                          style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 2. TEACHERS MANAGEMENT TAB
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: FadeInSlide(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _addTeacher,
                              icon: const Icon(Icons.add),
                              label: Text(tr.translate('add_teacher')),
                            ),
                            const SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _teachers.length,
                              itemBuilder: (context, idx) {
                                final teacher = _teachers[idx];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: teacher.isActive
                                            ? IslamicTheme.oliveLight
                                            : Colors.grey,
                                        foregroundColor: Colors.white,
                                        child: const Icon(Icons.person),
                                      ),
                                      title: Text(
                                        teacher.fullName,
                                        style: GoogleFonts.cairo(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'رقم الهاتف: ${teacher.phoneNumber}'),
                                          Text(
                                              'رمز الدخول: ${teacher.loginCode} | الطلاب: ${teacher.studentCount}'),
                                        ],
                                      ),
                                      trailing: PopupMenuButton<String>(
                                        onSelected: (val) {
                                          if (val == 'edit') {
                                            _editTeacher(teacher);
                                          } else if (val == 'toggle') {
                                            _toggleTeacherActive(teacher);
                                          } else if (val == 'transfer') {
                                            _transferStudentsDialog(teacher);
                                          } else if (val == 'delete') {
                                            _deleteTeacher(teacher);
                                          } else if (val == 'view_students') {
                                            _viewCircleStudentsDialog(teacher);
                                          }
                                        },
                                        itemBuilder: (ctx) => [
                                          const PopupMenuItem(
                                              value: 'view_students',
                                              child: Text('عرض طلاب الحلقة')),
                                          const PopupMenuItem(
                                              value: 'edit',
                                              child: Text('تعديل البيانات')),
                                          PopupMenuItem(
                                            value: 'toggle',
                                            child: Text(teacher.isActive
                                                ? 'تعطيل الحساب'
                                                : 'تفعيل الحساب'),
                                          ),
                                          const PopupMenuItem(
                                              value: 'transfer',
                                              child: Text('نقل الطلاب لآخر')),
                                          const PopupMenuItem(
                                              value: 'delete',
                                              child: Text('حذف المعلم',
                                                  style: TextStyle(
                                                      color: Colors.red))),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildStatCard(
      String title, String val, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: IslamicTheme.premiumCardDecoration(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              Expanded(
                child: Text(
                  val,
                  style: GoogleFonts.cairo(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: GoogleFonts.cairo(fontSize: 10, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(
      String label, double progress, String trailingText, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: GoogleFonts.cairo(
                    fontSize: 13, fontWeight: FontWeight.w500)),
            Text(trailingText,
                style: GoogleFonts.cairo(
                    fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withValues(alpha: 0.1),
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Future<void> _viewCircleStudentsDialog(Teacher teacher) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final currentStudents =
                _students.where((s) => s.teacherId == teacher.id).toList();
            return AlertDialog(
              title: Text('طلاب حلقة الشيخ ${teacher.fullName}',
                  style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              content: SizedBox(
                width: double.maxFinite,
                height: 350,
                child: currentStudents.isEmpty
                    ? const Center(
                        child: Text('لا يوجد طلاب في هذه الحلقة حالياً'))
                    : ListView.builder(
                        itemCount: currentStudents.length,
                        itemBuilder: (c, idx) {
                          final student = currentStudents[idx];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(student.name,
                                  style: GoogleFonts.cairo(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              subtitle: Text('رمز الدخول: ${student.loginCode}',
                                  style: const TextStyle(fontSize: 11)),
                              trailing: IconButton(
                                icon: const Icon(Icons.swap_horiz,
                                    color: IslamicTheme.goldMetallic),
                                tooltip: 'نقل الطالب لحلقة أخرى',
                                onPressed: () async {
                                  final transferred =
                                      await _transferSingleStudentDialog(
                                          student, teacher);
                                  if (transferred == true) {
                                    setDialogState(() {});
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('إغلاق'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool?> _transferSingleStudentDialog(
      Student student, Teacher sourceTeacher) async {
    Teacher? targetTeacher;
    final otherTeachers =
        _teachers.where((t) => t.id != sourceTeacher.id && t.isActive).toList();

    if (otherTeachers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('لا يوجد معلمون آخرون نشطون لنقل الطالب إليهم')),
      );
      return false;
    }

    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('نقل الطالب ${student.name}',
            style:
                GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('نقل الطالب من حلقة الشيخ ${sourceTeacher.fullName} إلى:'),
            const SizedBox(height: 16),
            DropdownButtonFormField<Teacher>(
              decoration:
                  const InputDecoration(labelText: 'اختر المعلم المستهدف'),
              items: otherTeachers.map((t) {
                return DropdownMenuItem<Teacher>(
                  value: t,
                  child: Text(t.fullName),
                );
              }).toList(),
              onChanged: (val) {
                targetTeacher = val;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (targetTeacher != null) {
                final db = ref.read(databaseProvider);
                await (db.update(db.studentsTable)
                      ..where((s) => s.id.equals(student.id)))
                    .write(
                  StudentsTableCompanion(
                    teacherId: Value(targetTeacher!.id),
                  ),
                );

                final sourceCount = await (db.select(db.studentsTable)
                      ..where((s) => s.teacherId.equals(sourceTeacher.id)))
                    .get();
                final targetCount = await (db.select(db.studentsTable)
                      ..where((s) => s.teacherId.equals(targetTeacher!.id)))
                    .get();

                await (db.update(db.teachersTable)
                      ..where((t) => t.id.equals(sourceTeacher.id)))
                    .write(
                  TeachersTableCompanion(
                      studentCount: Value(sourceCount.length)),
                );
                await (db.update(db.teachersTable)
                      ..where((t) => t.id.equals(targetTeacher!.id)))
                    .write(
                  TeachersTableCompanion(
                      studentCount: Value(targetCount.length)),
                );

                if (ctx.mounted) {
                  Navigator.pop(ctx, true);
                }
                _loadData();
              }
            },
            child: const Text('تأكيد النقل'),
          ),
        ],
      ),
    );
  }
}
