import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:athar/core/database/app_database.dart';
import 'package:athar/core/database/database_provider.dart';
import 'package:athar/core/theme/theme.dart';
import 'package:athar/core/utils/schedule_helper.dart';
import 'package:athar/core/widgets/app_notification.dart';
import 'package:athar/core/widgets/islamic_pattern.dart';
import 'package:athar/features/jadwal/presentation/student_schedule_screen.dart';

class JadwalHomeScreen extends ConsumerStatefulWidget {
  const JadwalHomeScreen({super.key});

  @override
  ConsumerState<JadwalHomeScreen> createState() => _JadwalHomeScreenState();
}

class _JadwalHomeScreenState extends ConsumerState<JadwalHomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final TextEditingController _absenceSearchController = TextEditingController();
  String _absenceSearchQuery = '';

  DateTime _selectedDate = DateTime.now();
  String _absenceFilter = 'all'; // 'all', 'absent', 'present'
  bool _showScheduleBreakdown = false;

  @override
  void dispose() {
    _searchController.dispose();
    _absenceSearchController.dispose();
    super.dispose();
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _showAddStudentDialog() async {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    final createdStudentId = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: IslamicTheme.oliveDeep.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_add_alt_1_rounded,
                color: IslamicTheme.oliveDeep,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'إضافة طالب جديد',
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: IslamicTheme.oliveDeep,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'اسم الطالب *',
                hintText: 'اكتب اسم الطالب ثلاثياً...',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'رقم الهاتف (اختياري)',
                hintText: '01xxxxxxxxx',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) {
                AppNotification.showWarning(ctx, 'يرجى إدخال اسم الطالب');
                return;
              }
              final db = ref.read(databaseProvider);
              final id = const Uuid().v4();
              await db.into(db.studentsTable).insert(
                    StudentsTableCompanion.insert(
                      id: id,
                      name: name,
                      parentName: '',
                      parentPhone: phoneCtrl.text.trim(),
                      loginCode: id.substring(0, 6).toUpperCase(),
                      teacherId: const Value('T1'),
                    ),
                  );
              if (ctx.mounted) Navigator.pop(ctx, id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: IslamicTheme.oliveDeep,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'إضافة',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (createdStudentId != null && mounted) {
      AppNotification.showSuccess(context, 'تمت إضافة الطالب بنجاح');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StudentScheduleScreen(studentId: createdStudentId),
        ),
      );
    }
  }

  Future<void> _confirmDeleteStudent(StudentsTableData student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'حذف الطالب',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: Colors.red[700],
          ),
        ),
        content: Text(
          'هل تريد حذف الطالب "${student.name}" وجدول دروسه نهائياً؟',
          style: GoogleFonts.cairo(fontSize: 13.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
            ),
            child: Text('حذف', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      await (db.delete(db.schedulesTable)
            ..where((s) => s.studentId.equals(student.id)))
          .go();
      await (db.delete(db.attendanceTable)
            ..where((a) => a.studentId.equals(student.id)))
          .go();
      await (db.delete(db.studentsTable)
            ..where((s) => s.id.equals(student.id)))
          .go();
      if (mounted) {
        AppNotification.showInfo(context, 'تم حذف الطالب "${student.name}"');
      }
    }
  }

  Future<void> _markAttendance({
    required String studentId,
    required bool isAbsent,
  }) async {
    final db = ref.read(databaseProvider);
    final startOfDay = _dateOnly(_selectedDate);
    final endOfDay = DateTime(
      startOfDay.year,
      startOfDay.month,
      startOfDay.day,
      23,
      59,
      59,
    );

    final existing = await (db.select(db.attendanceTable)
          ..where(
            (a) =>
                a.studentId.equals(studentId) &
                a.date.isBetweenValues(startOfDay, endOfDay),
          ))
        .getSingleOrNull();

    if (existing != null) {
      await (db.update(db.attendanceTable)
            ..where((a) => a.id.equals(existing.id)))
          .write(
        AttendanceTableCompanion(
          isAbsent: Value(isAbsent),
          arrivalTime: Value(isAbsent ? null : DateTime.now()),
        ),
      );
    } else {
      await db.into(db.attendanceTable).insert(
            AttendanceTableCompanion.insert(
              id: const Uuid().v4(),
              studentId: studentId,
              date: startOfDay,
              isAbsent: Value(isAbsent),
              arrivalTime: Value(isAbsent ? null : DateTime.now()),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('جدول حلقتي'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: IslamicPatternBackground()),
          StreamBuilder<List<StudentsTableData>>(
            stream: (db.select(db.studentsTable)
                  ..orderBy([(s) => OrderingTerm.asc(s.name)]))
                .watch(),
            builder: (context, studentsSnap) {
              if (studentsSnap.connectionState == ConnectionState.waiting &&
                  !studentsSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final allStudents = studentsSnap.data ?? [];

              return StreamBuilder<List<SchedulesTableData>>(
                stream: db.select(db.schedulesTable).watch(),
                builder: (context, schedulesSnap) {
                  final scheduleRows = schedulesSnap.data ?? [];
                  final Map<String, StudentWeeklySchedule> scheduleMap = {
                    for (final row in scheduleRows)
                      row.studentId:
                          StudentWeeklySchedule.fromJsonString(row.lessonsJson),
                  };

                  if (_currentIndex == 0) {
                    return _buildStudentsTab(allStudents, scheduleMap);
                  } else if (_currentIndex == 1) {
                    return _buildAbsenceTab(db, allStudents, scheduleMap);
                  } else {
                    return _buildDeleteStudentsTab(allStudents);
                  }
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _showAddStudentDialog,
              backgroundColor: IslamicTheme.oliveDeep,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: Text(
                'إضافة طالب',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        selectedItemColor: IslamicTheme.oliveDeep,
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.cairo(),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_rounded),
            activeIcon: Icon(Icons.people_rounded),
            label: 'الطلاب',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined),
            activeIcon: Icon(Icons.fact_check_rounded),
            label: 'الغياب والحضور',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_remove_outlined),
            activeIcon: Icon(Icons.person_remove_rounded),
            label: 'حذف طالب',
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsTab(
    List<StudentsTableData> allStudents,
    Map<String, StudentWeeklySchedule> scheduleMap,
  ) {
    final filtered = allStudents.where((s) {
      if (_searchQuery.trim().isEmpty) return true;
      return s.name.toLowerCase().contains(_searchQuery.trim().toLowerCase());
    }).toList();

    final todayName = StudentWeeklySchedule.weekdayName(DateTime.now());

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'ابحث عن طالب...',
              hintStyle: GoogleFonts.cairo(fontSize: 13),
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: IslamicTheme.oliveDeep.withValues(alpha: 0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: IslamicTheme.oliveDeep.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
        ),

        // Students Count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'عدد الطلاب: ${filtered.length}',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: IslamicTheme.oliveDeep,
                ),
              ),
              Text(
                'اليوم: $todayName',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 64,
                          color: IslamicTheme.oliveDeep.withValues(alpha: 0.35),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          allStudents.isEmpty
                              ? 'لا يوجد طلاب مسجلون بعد'
                              : 'لا توجد نتائج مطابقة للبحث',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        if (allStudents.isEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            'اضغط على زر "إضافة طالب" بالأسفل لإضافة أول طالب وتحديد جدول دروسه',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              fontSize: 12.5,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
                  itemCount: filtered.length,
                  itemBuilder: (context, idx) {
                    final student = filtered[idx];
                    final schedule =
                        scheduleMap[student.id] ?? StudentWeeklySchedule();
                    final todaySchedule = schedule.forDate(DateTime.now());
                    final quranDays = schedule.quranDaysCount;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 1.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: todaySchedule.hasQuran
                              ? IslamicTheme.goldMetallic.withValues(alpha: 0.45)
                              : Colors.grey.withValues(alpha: 0.18),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  StudentScheduleScreen(studentId: student.id),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          radius: 23,
                          backgroundColor:
                              IslamicTheme.oliveDeep.withValues(alpha: 0.12),
                          child: Text(
                            student.name.isNotEmpty ? student.name[0] : 'ط',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: IslamicTheme.oliveDeep,
                            ),
                          ),
                        ),
                        title: Text(
                          student.name,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5,
                            color: const Color(0xFF2B3724),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: todaySchedule.hasQuran
                                      ? const Color(0xFFE4ECD5)
                                      : Colors.grey.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  todaySchedule.hasQuran
                                      ? 'القرآن اليوم: ${todaySchedule.quranTime}'
                                      : 'لا يوجد قرآن اليوم',
                                  style: GoogleFonts.cairo(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: todaySchedule.hasQuran
                                        ? const Color(0xFF3E6319)
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: IslamicTheme.goldMetallic
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$quranDays أيام/أسبوع',
                                  style: GoogleFonts.cairo(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: IslamicTheme.oliveDeep,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAbsenceTab(
    AppDatabase db,
    List<StudentsTableData> allStudents,
    Map<String, StudentWeeklySchedule> scheduleMap,
  ) {
    final startOfDay = _dateOnly(_selectedDate);
    final endOfDay = DateTime(
      startOfDay.year,
      startOfDay.month,
      startOfDay.day,
      23,
      59,
      59,
    );
    final dayName = StudentWeeklySchedule.weekdayName(_selectedDate);
    final isToday = _isSameDay(_selectedDate, DateTime.now());

    return StreamBuilder<List<AttendanceTableData>>(
      stream: (db.select(db.attendanceTable)
            ..where((a) => a.date.isBetweenValues(startOfDay, endOfDay)))
          .watch(),
      builder: (context, attendanceSnap) {
        final attendanceList = attendanceSnap.data ?? [];
        final Map<String, AttendanceTableData> attendanceMap = {
          for (final a in attendanceList) a.studentId: a,
        };

        // Students expected today based on their weekly schedule
        final expectedToday = <StudentsTableData>[];
        final offToday = <StudentsTableData>[];

        for (final student in allStudents) {
          final schedule = scheduleMap[student.id] ?? StudentWeeklySchedule();
          final daySchedule = schedule.forDate(_selectedDate);
          if (daySchedule.hasQuran) {
            expectedToday.add(student);
          } else {
            offToday.add(student);
          }
        }

        int presentCount = 0;
        int absentCount = 0;
        for (final s in expectedToday) {
          final rec = attendanceMap[s.id];
          if (rec != null) {
            if (rec.isAbsent) {
              absentCount++;
            } else {
              presentCount++;
            }
          }
        }

        final q = _absenceSearchQuery.trim().toLowerCase();
        final filteredExpected = expectedToday.where((s) {
          if (q.isNotEmpty && !s.name.toLowerCase().contains(q)) {
            return false;
          }
          final rec = attendanceMap[s.id];
          switch (_absenceFilter) {
            case 'absent':
              return rec != null && rec.isAbsent;
            case 'present':
              return rec != null && !rec.isAbsent;
            default:
              return true;
          }
        }).toList();

        final filteredOffToday = offToday.where((s) {
          if (q.isEmpty) return true;
          return s.name.toLowerCase().contains(q);
        }).toList();

        return Column(
          children: [
            // Date Switcher Header
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: IslamicTheme.oliveDeep.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () {
                      setState(() {
                        _selectedDate =
                            _selectedDate.subtract(const Duration(days: 1));
                      });
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: Column(
                      children: [
                        Text(
                          isToday ? 'اليوم: $dayName' : dayName,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: IslamicTheme.oliveDeep,
                          ),
                        ),
                        Text(
                          '${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
                          style: GoogleFonts.cairo(
                            fontSize: 11.5,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: () {
                      setState(() {
                        _selectedDate =
                            _selectedDate.add(const Duration(days: 1));
                      });
                    },
                  ),
                ],
              ),
            ),

            // Search Bar in Absence Tab
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
              child: TextField(
                controller: _absenceSearchController,
                onChanged: (val) => setState(() => _absenceSearchQuery = val),
                decoration: InputDecoration(
                  hintText: 'ابحث عن طالب في الغياب...',
                  hintStyle: GoogleFonts.cairo(fontSize: 13),
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _absenceSearchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _absenceSearchController.clear();
                            setState(() => _absenceSearchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: IslamicTheme.oliveDeep.withValues(alpha: 0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: IslamicTheme.oliveDeep.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
            ),

            // Summary Stats Row (Interactive Buttons)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      label: 'المفترض حضورهم',
                      count: expectedToday.length,
                      color: IslamicTheme.oliveDeep,
                      bgColor: const Color(0xFFF3F6EE),
                      isSelected: _absenceFilter == 'all',
                      onTap: () {
                        setState(() {
                          _absenceFilter = 'all';
                          _showScheduleBreakdown = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      label: 'حضر',
                      count: presentCount,
                      color: const Color(0xFF1E6B38),
                      bgColor: const Color(0xFFE8F5E9),
                      isSelected: _absenceFilter == 'present',
                      onTap: () {
                        setState(() {
                          _absenceFilter = 'present';
                          _showScheduleBreakdown = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      label: 'غاب',
                      count: absentCount,
                      color: const Color(0xFFB3261E),
                      bgColor: const Color(0xFFFDECEA),
                      isSelected: _absenceFilter == 'absent',
                      onTap: () {
                        setState(() {
                          _absenceFilter = 'absent';
                          _showScheduleBreakdown = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Filter Chips (Centered)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _buildFilterChip('all', 'الكل (${expectedToday.length})'),
                    _buildFilterChip('absent', 'الغائبون ($absentCount)'),
                    _buildFilterChip('present', 'الحاضرون ($presentCount)'),
                  ],
                ),
              ),
            ),

            // List of Expected Students & Off Today
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  if (_showScheduleBreakdown && _absenceFilter == 'all') ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4ECD5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'من سيحضر اليوم (${filteredExpected.length}):',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: const Color(0xFF2B3724),
                        ),
                      ),
                    ),
                  ],

                  if (expectedToday.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.event_busy_rounded,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'لا يوجد طلاب مقرر حضورهم يوم $dayName',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'افتح ملف أي طالب وحدد يوم $dayName في مربع ميعاد درس القرآن ليظهر هنا تلقائياً.',
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else if (filteredExpected.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Center(
                        child: Text(
                          'لا يوجد طلاب في هذا التصنيف حالياً',
                          style: GoogleFonts.cairo(
                            color: Colors.grey[600],
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    )
                  else
                    ...filteredExpected.map((student) {
                      final schedule =
                          scheduleMap[student.id] ?? StudentWeeklySchedule();
                      final daySchedule = schedule.forDate(_selectedDate);
                      final att = attendanceMap[student.id];
                      final bool isPresent = att != null && !att.isAbsent;
                      final bool isAbsent = att != null && att.isAbsent;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 1.2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: isAbsent
                                ? Colors.red.withValues(alpha: 0.4)
                                : isPresent
                                    ? Colors.green.withValues(alpha: 0.4)
                                    : IslamicTheme.goldMetallic
                                        .withValues(alpha: 0.35),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: isAbsent
                                        ? Colors.red.withValues(alpha: 0.12)
                                        : isPresent
                                            ? Colors.green
                                                .withValues(alpha: 0.12)
                                            : IslamicTheme.oliveDeep
                                                .withValues(alpha: 0.1),
                                    child: Text(
                                      student.name.isNotEmpty
                                          ? student.name[0]
                                          : 'ط',
                                      style: GoogleFonts.cairo(
                                        fontWeight: FontWeight.bold,
                                        color: isAbsent
                                            ? Colors.red[700]
                                            : isPresent
                                                ? Colors.green[700]
                                                : IslamicTheme.oliveDeep,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student.name,
                                          style: GoogleFonts.cairo(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'ميعاد درس القرآن: ${daySchedule.quranTime}',
                                          style: GoogleFonts.cairo(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            color: IslamicTheme.oliveDeep,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.calendar_month_outlined,
                                      size: 20,
                                    ),
                                    tooltip: 'عرض جدول الطالب',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => StudentScheduleScreen(
                                            studentId: student.id,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              if (daySchedule.lessons.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'دروس أخرى اليوم: ${daySchedule.lessons.map((l) => "${l.subject} (${l.time})").join(" • ")}',
                                  style: GoogleFonts.cairo(
                                    fontSize: 11,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _markAttendance(
                                        studentId: student.id,
                                        isAbsent: false,
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: isPresent
                                            ? const Color(0xFF1E6B38)
                                            : Colors.white,
                                        foregroundColor: isPresent
                                            ? Colors.white
                                            : const Color(0xFF1E6B38),
                                        side: const BorderSide(
                                          color: Color(0xFF1E6B38),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.check_circle_outline,
                                        size: 18,
                                      ),
                                      label: Text(
                                        'حاضر',
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _markAttendance(
                                        studentId: student.id,
                                        isAbsent: true,
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: isAbsent
                                            ? const Color(0xFFB3261E)
                                            : Colors.white,
                                        foregroundColor: isAbsent
                                            ? Colors.white
                                            : const Color(0xFFB3261E),
                                        side: const BorderSide(
                                          color: Color(0xFFB3261E),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.cancel_outlined,
                                        size: 18,
                                      ),
                                      label: Text(
                                        'غائب',
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                  if (filteredOffToday.isNotEmpty &&
                      (_absenceFilter == 'all')) ...[
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: _showScheduleBreakdown,
                        title: Text(
                          'من لن يحضر اليوم — إجازة / بدون درس (${filteredOffToday.length})',
                          style: GoogleFonts.cairo(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        children: filteredOffToday.map((s) {
                          return ListTile(
                            dense: true,
                            title: Text(
                              s.name,
                              style: GoogleFonts.cairo(fontSize: 13),
                            ),
                            trailing: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        StudentScheduleScreen(studentId: s.id),
                                  ),
                                );
                              },
                              child: Text(
                                'تعديل الجدول',
                                style: GoogleFonts.cairo(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: IslamicTheme.oliveDeep,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String label,
    required int count,
    required Color color,
    required Color bgColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      elevation: isSelected ? 2.5 : 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : color.withValues(alpha: 0.25),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                '$count',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: color,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final selected = _absenceFilter == value;
    return ChoiceChip(
      label: Text(
        label,
        style: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: selected ? Colors.white : IslamicTheme.oliveDeep,
        ),
      ),
      selected: selected,
      selectedColor: IslamicTheme.oliveDeep,
      backgroundColor: Colors.white,
      side: BorderSide(
        color: IslamicTheme.oliveDeep.withValues(alpha: 0.25),
      ),
      onSelected: (_) => setState(() => _absenceFilter = value),
    );
  }

  Widget _buildDeleteStudentsTab(List<StudentsTableData> allStudents) {
    if (allStudents.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'لا يوجد طلاب لحذفهم حالياً',
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red[700]),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'اضغط على زر الحذف بجانب الطالب لإزالته مع جدول دروسه نهائياً.',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.red[800],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            itemCount: allStudents.length,
            itemBuilder: (context, idx) {
              final student = allStudents[idx];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: Colors.red.withValues(alpha: 0.2)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.withValues(alpha: 0.1),
                    child: Text(
                      student.name.isNotEmpty ? student.name[0] : 'ط',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                  ),
                  title: Text(
                    student.name,
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: student.parentPhone.isNotEmpty
                      ? Text(
                          student.parentPhone,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        )
                      : null,
                  trailing: ElevatedButton.icon(
                    onPressed: () => _confirmDeleteStudent(student),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: Text(
                      'حذف',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
