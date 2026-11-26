import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:google_fonts/google_fonts.dart';
import 'package:athar/core/database/app_database.dart';
import 'package:athar/core/database/database_provider.dart';
import 'package:athar/core/providers/app_providers.dart';
import 'package:athar/core/theme/theme.dart';
import 'package:athar/core/utils/schedule_helper.dart';
import 'package:athar/core/widgets/app_notification.dart';
import 'package:athar/core/widgets/islamic_pattern.dart';

class StudentScheduleScreen extends ConsumerStatefulWidget {
  final String studentId;

  const StudentScheduleScreen({
    super.key,
    required this.studentId,
  });

  @override
  ConsumerState<StudentScheduleScreen> createState() =>
      _StudentScheduleScreenState();
}

class _StudentScheduleScreenState extends ConsumerState<StudentScheduleScreen> {
  late StudentWeeklySchedule _schedule;
  final Map<String, TextEditingController> _notesControllers = {};
  bool _isLoaded = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _schedule = StudentWeeklySchedule();
    for (final day in StudentWeeklySchedule.weekDays) {
      _notesControllers[day] = TextEditingController();
    }
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final db = ref.read(databaseProvider);
    final row = await (db.select(db.schedulesTable)
          ..where((s) => s.studentId.equals(widget.studentId)))
        .getSingleOrNull();

    if (!mounted) return;
    setState(() {
      _schedule = StudentWeeklySchedule.fromJsonString(row?.lessonsJson);
      for (final day in StudentWeeklySchedule.weekDays) {
        _notesControllers[day]?.text = _schedule.days[day]?.notes ?? '';
      }
      _isLoaded = true;
    });
  }

  @override
  void dispose() {
    for (final c in _notesControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TimeOfDay _parseTime(String timeStr, {TimeOfDay fallback = const TimeOfDay(hour: 16, minute: 0)}) {
    try {
      final cleaned = timeStr.trim();
      final parts = cleaned.split(' ');
      if (parts.isNotEmpty) {
        final hm = parts[0].split(':');
        if (hm.length >= 2) {
          int hour = int.parse(hm[0]);
          final minute = int.parse(hm[1]);
          final isPm = cleaned.contains('م') || cleaned.toUpperCase().contains('PM');
          final isAm = cleaned.contains('ص') || cleaned.toUpperCase().contains('AM');
          if (isPm && hour < 12) hour += 12;
          if (isAm && hour == 12) hour = 0;
          return TimeOfDay(hour: hour.clamp(0, 23), minute: minute.clamp(0, 59));
        }
      }
    } catch (_) {}
    return fallback;
  }

  String _formatTimeArabic(TimeOfDay t) {
    final period = t.period == DayPeriod.am ? 'ص' : 'م';
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m $period';
  }

  Future<void> _pickQuranTime(String day) async {
    final daySchedule = _schedule.days[day]!;
    final picked = await showTimePicker(
      context: context,
      initialTime: _parseTime(daySchedule.quranTime),
      helpText: 'اختر ميعاد درس القرآن يوم $day',
    );
    if (picked != null) {
      setState(() {
        daySchedule.quranTime = _formatTimeArabic(picked);
        daySchedule.hasQuran = true;
      });
    }
  }

  Future<void> _addOtherLessonDialog(String day) async {
    final subjectController = TextEditingController();
    TimeOfDay selectedTime = const TimeOfDay(hour: 14, minute: 0);

    final result = await showDialog<LessonItem>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(
                'إضافة درس يوم $day',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: IslamicTheme.oliveDeep,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: subjectController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'اسم الدرس / المادة',
                      hintText: 'مثال: رياضيات، علوم، إنجليزي...',
                      prefixIcon: const Icon(Icons.book_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: ctx,
                        initialTime: selectedTime,
                        helpText: 'اختر ميعاد الدرس',
                      );
                      if (picked != null) {
                        setDialogState(() {
                          selectedTime = picked;
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: IslamicTheme.oliveDeep.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: IslamicTheme.oliveDeep.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                color: IslamicTheme.oliveDeep,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'ميعاد الدرس:',
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _formatTimeArabic(selectedTime),
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: IslamicTheme.oliveDeep,
                            ),
                          ),
                        ],
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
                  onPressed: () {
                    final subject = subjectController.text.trim();
                    if (subject.isEmpty) {
                      AppNotification.showWarning(ctx, 'يرجى كتابة اسم الدرس');
                      return;
                    }
                    Navigator.pop(
                      ctx,
                      LessonItem(
                        subject: subject,
                        time: _formatTimeArabic(selectedTime),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: IslamicTheme.oliveDeep,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('إضافة', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _schedule.days[day]!.lessons.add(result);
      });
    }
  }

  Future<void> _saveSchedule() async {
    setState(() => _isSaving = true);
    try {
      for (final day in StudentWeeklySchedule.weekDays) {
        _schedule.days[day]!.notes = _notesControllers[day]?.text.trim() ?? '';
      }

      final repo = ref.read(recordRepositoryProvider);
      await repo.saveParentSchedule(
        widget.studentId,
        _schedule.toJsonString(),
      );
      ref.invalidate(studentScheduleProvider(widget.studentId));

      if (!mounted) return;
      AppNotification.showSuccess(context, 'تم حفظ جدول الطالب بنجاح');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _editStudentInfo(StudentsTableData student) async {
    final nameCtrl = TextEditingController(text: student.name);
    final phoneCtrl = TextEditingController(text: student.parentPhone);

    final updated = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'تعديل بيانات الطالب',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: IslamicTheme.oliveDeep,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'اسم الطالب',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'رقم الهاتف (اختياري)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameCtrl.text.trim();
              if (newName.isEmpty) return;
              final db = ref.read(databaseProvider);
              await (db.update(db.studentsTable)
                    ..where((s) => s.id.equals(student.id)))
                  .write(
                StudentsTableCompanion(
                  name: Value(newName),
                  parentPhone: Value(phoneCtrl.text.trim()),
                ),
              );
              if (ctx.mounted) Navigator.pop(ctx, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: IslamicTheme.oliveDeep,
              foregroundColor: Colors.white,
            ),
            child: Text('حفظ', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (updated == true && mounted) {
      AppNotification.showSuccess(context, 'تم تحديث بيانات الطالب');
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);

    return StreamBuilder<StudentsTableData?>(
      stream: (db.select(db.studentsTable)
            ..where((s) => s.id.equals(widget.studentId)))
          .watchSingleOrNull(),
      builder: (context, snapshot) {
        final student = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: Text(student?.name ?? 'جدول الطالب'),
            actions: [
              if (student != null)
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'تعديل الاسم والهاتف',
                  onPressed: () => _editStudentInfo(student),
                ),
            ],
          ),
          body: Stack(
            children: [
              const Positioned.fill(child: IslamicPatternBackground()),
              if (!_isLoaded)
                const Center(child: CircularProgressIndicator())
              else
                Column(
                  children: [
                    // Info banner
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: IslamicTheme.goldMetallic.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: IslamicTheme.goldMetallic.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            color: IslamicTheme.oliveDeep,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'حدّد ميعاد درس القرآن في المربع المخصص لكل يوم، وأضف مواعيد الدروس الأخرى ليتم ربطها تلقائياً بتبويب الغياب.',
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: IslamicTheme.oliveDeep,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Days List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                        itemCount: StudentWeeklySchedule.weekDays.length,
                        itemBuilder: (context, index) {
                          final day = StudentWeeklySchedule.weekDays[index];
                          final daySchedule = _schedule.days[day]!;
                          return _buildDayCard(day, daySchedule);
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
          bottomNavigationBar: _isLoaded
              ? SafeArea(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _saveSchedule,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: IslamicTheme.oliveDeep,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_rounded),
                      label: Text(
                        'حفظ جدول الدروس',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildDayCard(String day, DaySchedule daySchedule) {
    final bool hasQuran = daySchedule.hasQuran;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: hasQuran
              ? IslamicTheme.goldMetallic.withValues(alpha: 0.5)
              : Colors.grey.withValues(alpha: 0.2),
          width: hasQuran ? 1.4 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Day Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: hasQuran
                            ? IslamicTheme.oliveDeep.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.today_rounded,
                        size: 18,
                        color: hasQuran ? IslamicTheme.oliveDeep : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      day,
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFF2B3724),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: hasQuran
                        ? const Color(0xFFE4ECD5)
                        : Colors.grey.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    hasQuran ? 'مقرر حضور القرآن' : 'إجازة',
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: hasQuran
                          ? const Color(0xFF3E6319)
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Dedicated Quran Lesson Time Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: hasQuran
                    ? const Color(0xFFFDF8E7)
                    : const Color(0xFFF7F7F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasQuran
                      ? IslamicTheme.goldMetallic
                      : Colors.grey.withValues(alpha: 0.3),
                  width: 1.4,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        color: hasQuran
                            ? IslamicTheme.oliveDeep
                            : Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'ميعاد درس القرآن الكريم',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                            color: hasQuran
                                ? IslamicTheme.oliveDeep
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                      Switch(
                        value: hasQuran,
                        activeColor: IslamicTheme.oliveDeep,
                        onChanged: (val) {
                          setState(() {
                            daySchedule.hasQuran = val;
                          });
                        },
                      ),
                    ],
                  ),
                  if (hasQuran) ...[
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _pickQuranTime(day),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: IslamicTheme.goldMetallic.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_filled_rounded,
                                  size: 18,
                                  color: IslamicTheme.goldMetallic,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'الساعة المحددة للحلقة:',
                                  style: GoogleFonts.cairo(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2B3724),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  daySchedule.quranTime,
                                  style: GoogleFonts.cairo(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: IslamicTheme.oliveDeep,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.edit_calendar_rounded,
                                  size: 16,
                                  color: IslamicTheme.oliveDeep,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Other Lessons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'مواعيد الدروس الأخرى:',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: const Color(0xFF2B3724),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _addOtherLessonDialog(day),
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: Text(
                    'إضافة درس',
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: IslamicTheme.oliveDeep,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),

            if (daySchedule.lessons.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'لا توجد دروس أخرى مسجلة لهذا اليوم',
                  style: GoogleFonts.cairo(
                    fontSize: 11.5,
                    color: Colors.grey[500],
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: List.generate(daySchedule.lessons.length, (i) {
                  final lesson = daySchedule.lessons[i];
                  return Chip(
                    backgroundColor: const Color(0xFFF3F6EE),
                    side: BorderSide(
                      color: IslamicTheme.oliveDeep.withValues(alpha: 0.2),
                    ),
                    label: Text(
                      '${lesson.subject} (${lesson.time})',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: IslamicTheme.oliveDeep,
                      ),
                    ),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    deleteIconColor: Colors.red[400],
                    onDeleted: () {
                      setState(() {
                        daySchedule.lessons.removeAt(i);
                      });
                    },
                  );
                }),
              ),

            const SizedBox(height: 10),

            // Optional Notes
            TextField(
              controller: _notesControllers[day],
              decoration: InputDecoration(
                hintText: 'ملاحظات إضافية لليوم (اختياري)...',
                hintStyle: GoogleFonts.cairo(fontSize: 11.5, color: Colors.grey),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                ),
              ),
              style: GoogleFonts.cairo(fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}
