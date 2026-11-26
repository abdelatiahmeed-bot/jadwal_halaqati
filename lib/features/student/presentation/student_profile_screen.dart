import 'package:athar/core/widgets/app_notification.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:athar/core/theme/theme.dart';
import 'package:athar/core/utils/whatsapp_launcher.dart';
import 'package:athar/core/models/models.dart';
import 'package:athar/core/quran/quran_data.dart';
import 'package:athar/core/quran/quran_engine.dart';
import 'package:athar/core/providers/app_providers.dart';
import 'package:athar/core/widgets/islamic_pattern.dart';
import 'package:athar/core/widgets/fade_in_slide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:athar/core/theme/motion.dart';

class QuranEntry {
  String method; // 'surah', 'range', 'juz', 'multiple'
  int surahId;
  int startVerse;
  int endVerse;
  int startSurahId;
  int endSurahId;
  int juzId;
  List<int> selectedSurahs;
  String grade; // Only used for daily record (today's record)

  QuranEntry({
    this.method = 'surah',
    this.surahId = 1,
    this.startVerse = 1,
    this.endVerse = 7,
    this.startSurahId = 1,
    this.endSurahId = 2,
    this.juzId = 30,
    List<int>? selectedSurahs,
    this.grade = 'excellent',
  }) : selectedSurahs = selectedSurahs ?? [];

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'surahId': surahId,
      'startVerse': startVerse,
      'endVerse': endVerse,
      'startSurahId': startSurahId,
      'endSurahId': endSurahId,
      'juzId': juzId,
      'surahIds': selectedSurahs,
      'grade': grade,
    };
  }

  factory QuranEntry.fromJson(Map<String, dynamic> json) {
    return QuranEntry(
      method: json['method'] as String? ?? 'surah',
      surahId: json['surahId'] as int? ?? 1,
      startVerse: json['startVerse'] as int? ?? 1,
      endVerse: json['endVerse'] as int? ?? 7,
      startSurahId: json['startSurahId'] as int? ?? 1,
      endSurahId: json['endSurahId'] as int? ?? 2,
      juzId: json['juzId'] as int? ?? 30,
      selectedSurahs: List<int>.from(json['surahIds'] ?? []),
      grade: json['grade'] as String? ?? 'excellent',
    );
  }

  QuranEntry clone() {
    return QuranEntry(
      method: method,
      surahId: surahId,
      startVerse: startVerse,
      endVerse: endVerse,
      startSurahId: startSurahId,
      endSurahId: endSurahId,
      juzId: juzId,
      selectedSurahs: List.from(selectedSurahs),
      grade: grade,
    );
  }
}

class StudentProfileScreen extends ConsumerStatefulWidget {
  final String studentId;

  const StudentProfileScreen({super.key, required this.studentId});

  @override
  ConsumerState<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState extends ConsumerState<StudentProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _todaySaved = false;
  bool _tomorrowSaved = false;
  late TabController _tabController;
  Timer? _midnightTimer;
  bool _isLoading = false;

  // Daily Record Inputs
  List<QuranEntry> _memoEntries = [QuranEntry()];
  List<QuranEntry> _revEntries = [QuranEntry()];

  final TextEditingController _notesCtrl = TextEditingController();

  // Arrival / Departure Times
  TimeOfDay _arrivalTime = const TimeOfDay(hour: 16, minute: 0);
  TimeOfDay _departureTime = const TimeOfDay(hour: 17, minute: 30);

  // Tomorrow Plan Inputs
  List<QuranEntry> _tMemoEntries = [QuranEntry()];
  List<QuranEntry> _tRevEntries = [QuranEntry()];

  final TextEditingController _tNotesCtrl = TextEditingController();

  // Memorization Plan Inputs
  int _daysPerWeek = 5;
  int _linesPerDay = 15;
  int _direction = 0; // 0: Forward, 1: Reverse
  int _planStartSurah = 2;
  int _planStartVerse = 1;
  int _planEndSurah = 114;
  int _planEndVerse = 6;
  final TextEditingController _planNotesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _loadAllData();
    _scheduleMidnightReload();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _midnightTimer?.cancel();
    _notesCtrl.dispose();
    _tNotesCtrl.dispose();
    _planNotesCtrl.dispose();
    super.dispose();
  }

  List<QuranEntry> _parseQuranEntries(
      String rawData, String method, String grade) {
    if (rawData.isEmpty) return [QuranEntry(grade: grade)];
    try {
      final decoded = jsonDecode(rawData);
      if (decoded is Map<String, dynamic> && decoded.containsKey('entries')) {
        final list = decoded['entries'] as List;
        return list.map((e) => QuranEntry.fromJson(e)).toList();
      } else {
        // Legacy single entry
        final entry = QuranEntry(
          method: method,
          grade: grade,
        );
        final data = decoded as Map<String, dynamic>;
        if (method == 'surah') {
          entry.surahId = data['surahId'] ?? 1;
          entry.startVerse = data['startVerse'] ?? 1;
          entry.endVerse = data['endVerse'] ?? 7;
        } else if (method == 'range') {
          entry.startSurahId = data['startSurahId'] ?? 1;
          entry.endSurahId = data['endSurahId'] ?? 2;
        } else if (method == 'juz') {
          entry.juzId = data['juzId'] ?? 30;
        } else if (method == 'multiple') {
          entry.selectedSurahs = List<int>.from(data['surahIds'] ?? []);
        }
        return [entry];
      }
    } catch (_) {
      return [QuranEntry(grade: grade)];
    }
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    final recordRepo = ref.read(recordRepositoryProvider);

    // Load Today's Daily Record & Tomorrow Plan
    final todayRecord =
        await recordRepo.getDailyRecord(widget.studentId, DateTime.now());
    final tomorrowPlan = await recordRepo.getTomorrowPlan(widget.studentId);

    final shouldUseTomorrowPlan =
        tomorrowPlan != null && await _shouldUseTomorrowPlanToday();

    if (todayRecord != null) {
      _todaySaved = true;
      _notesCtrl.text = todayRecord.teacherNotes ?? "";
      _memoEntries = _parseQuranEntries(
        todayRecord.memorizationData,
        todayRecord.memorizationMethod,
        todayRecord.memorizationGrade,
      );
      _revEntries = _parseQuranEntries(
        todayRecord.revisionData,
        todayRecord.revisionMethod,
        todayRecord.revisionGrade,
      );

      if (tomorrowPlan != null) {
        _tNotesCtrl.text = tomorrowPlan.notes ?? "";
        _tMemoEntries = _parseQuranEntries(
          tomorrowPlan.memorizationData,
          tomorrowPlan.memorizationMethod,
          'excellent',
        );
        _tRevEntries = _parseQuranEntries(
          tomorrowPlan.revisionData,
          tomorrowPlan.revisionMethod,
          'excellent',
        );
      }
    } else if (tomorrowPlan != null && shouldUseTomorrowPlan) {
      // Auto-transition tomorrow's plan to today's record inputs
      _notesCtrl.text = tomorrowPlan.notes ?? "";
      _memoEntries = _parseQuranEntries(
        tomorrowPlan.memorizationData,
        tomorrowPlan.memorizationMethod,
        'excellent',
      );
      _revEntries = _parseQuranEntries(
        tomorrowPlan.revisionData,
        tomorrowPlan.revisionMethod,
        'excellent',
      );

      _tNotesCtrl.text = tomorrowPlan.notes ?? "";
      _tMemoEntries = _parseQuranEntries(
        tomorrowPlan.memorizationData,
        tomorrowPlan.memorizationMethod,
        'excellent',
      );
      _tRevEntries = _parseQuranEntries(
        tomorrowPlan.revisionData,
        tomorrowPlan.revisionMethod,
        'excellent',
      );
    } else {
      _memoEntries = [QuranEntry()];
      _revEntries = [QuranEntry()];

      if (tomorrowPlan != null) {
        _tNotesCtrl.text = tomorrowPlan.notes ?? "";
        _tMemoEntries = _parseQuranEntries(
          tomorrowPlan.memorizationData,
          tomorrowPlan.memorizationMethod,
          'excellent',
        );
        _tRevEntries = _parseQuranEntries(
          tomorrowPlan.revisionData,
          tomorrowPlan.revisionMethod,
          'excellent',
        );
      } else {
        _tMemoEntries = [QuranEntry()];
        _tRevEntries = [QuranEntry()];
      }
    }

    // Load Today's Attendance for arrival / departure times
    final todayAttendance =
        await recordRepo.getAttendance(widget.studentId, DateTime.now());
    if (todayAttendance != null) {
      if (!todayAttendance.isAbsent) {
        _todaySaved = true;
      }
      if (todayAttendance.arrivalTime != null) {
        _arrivalTime = TimeOfDay.fromDateTime(todayAttendance.arrivalTime!);
      }
      if (todayAttendance.departureTime != null) {
        _departureTime = TimeOfDay.fromDateTime(todayAttendance.departureTime!);
      }
    }

    // Load Memorization General Plan
    final plan = await recordRepo.getMemorizationPlan(widget.studentId);
    if (plan != null) {
      _daysPerWeek = plan.attendanceDaysPerWeek;
      _linesPerDay = plan.dailyLinesCount;
      _direction = plan.direction;
      _planStartSurah = plan.startSurah;
      _planStartVerse = plan.startVerse;
      _planEndSurah = plan.endSurah;
      _planEndVerse = plan.endVerse;
      _planNotesCtrl.text = plan.notes ?? "";
    }

    setState(() => _isLoading = false);
  }

  void _scheduleMidnightReload() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    _midnightTimer = Timer(nextMidnight.difference(now), () {
      if (!mounted) return;
      _loadAllData();
      _scheduleMidnightReload();
    });
  }

  Future<bool> _shouldUseTomorrowPlanToday() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate =
        prefs.getString('tomorrow_plan_saved_date_${widget.studentId}');
    if (savedDate == null) return true;

    final today = intl.DateFormat('yyyy-MM-dd').format(DateTime.now());
    return savedDate != today;
  }

  Future<void> _markTomorrowPlanSavedToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = intl.DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setString(
        'tomorrow_plan_saved_date_${widget.studentId}', today);
  }

  String _buildRecordJson({
    required String method,
    required int surahId,
    required int startVerse,
    required int endVerse,
    required int startSurahId,
    required int endSurahId,
    required int juzId,
    required List<int> selectedSurahs,
  }) {
    switch (method) {
      case 'surah':
        return jsonEncode({
          'surahId': surahId,
          'startVerse': startVerse,
          'endVerse': endVerse,
        });
      case 'range':
        return jsonEncode({
          'startSurahId': startSurahId,
          'endSurahId': endSurahId,
        });
      case 'juz':
        return jsonEncode({
          'juzId': juzId,
        });
      case 'multiple':
        return jsonEncode({
          'surahIds': selectedSurahs,
        });
      default:
        return '{}';
    }
  }

  String _buildRecordJsonList(List<QuranEntry> entries) {
    if (entries.isEmpty) return '{}';
    if (entries.length == 1) {
      final entry = entries.first;
      return _buildRecordJson(
        method: entry.method,
        surahId: entry.surahId,
        startVerse: entry.startVerse,
        endVerse: entry.endVerse,
        startSurahId: entry.startSurahId,
        endSurahId: entry.endSurahId,
        juzId: entry.juzId,
        selectedSurahs: entry.selectedSurahs,
      );
    } else {
      return jsonEncode({
        'entries': entries.map((e) => e.toJson()).toList(),
      });
    }
  }

  Future<void> _saveTodayRecord() async {
    if (_memoEntries.isEmpty || _revEntries.isEmpty) return;
    final recordRepo = ref.read(recordRepositoryProvider);
    final now = DateTime.now();

    final record = DailyRecord(
      id: 'R_${widget.studentId}_${now.millisecondsSinceEpoch}',
      studentId: widget.studentId,
      date: now,
      memorizationMethod: _memoEntries.length == 1
          ? _memoEntries.first.method
          : 'multiple_entries',
      memorizationData: _buildRecordJsonList(_memoEntries),
      memorizationGrade:
          _memoEntries.isNotEmpty ? _memoEntries.first.grade : 'excellent',
      revisionMethod: _revEntries.length == 1
          ? _revEntries.first.method
          : 'multiple_entries',
      revisionData: _buildRecordJsonList(_revEntries),
      revisionGrade:
          _revEntries.isNotEmpty ? _revEntries.first.grade : 'excellent',
      teacherNotes: _notesCtrl.text.trim(),
      encouragementMessage: null,
    );

    await recordRepo.saveDailyRecord(record);

    // Save attendance along with daily record (marks present)
    final attendance = Attendance(
      id: 'ATT_${widget.studentId}_${now.year}_${now.month}_${now.day}',
      studentId: widget.studentId,
      date: now,
      isAbsent: false,
      arrivalTime:
          now.copyWith(hour: _arrivalTime.hour, minute: _arrivalTime.minute),
      departureTime: now.copyWith(
          hour: _departureTime.hour, minute: _departureTime.minute),
    );
    await recordRepo.saveAttendance(attendance);

    // Add points for excellent memorization
    if (_memoEntries.any((e) => e.grade == 'excellent')) {
      final studentRepo = ref.read(studentRepositoryProvider);
      await studentRepo.updateStudentRewards(widget.studentId, 15, 2);
    }

    if (!mounted) return;
    setState(() => _todaySaved = true);
    AppNotification.showSuccess(context, 'تم حفظ السجل اليومي للحلقة بنجاح');
    ref.invalidate(studentDailyArchiveProvider(widget.studentId));
    ref.invalidate(studentAttendanceProvider((studentId: widget.studentId, date: DateTime.now())));
  }

  Future<void> _sendWhatsAppDailyReport(Student student) async {
    final now = DateTime.now();
    final arabicDate = '${now.year}/${now.month}/${now.day}';

    // Grades Translation helper
    String translateGrade(String grade) {
      switch (grade) {
        case 'excellent':
          return 'ممتاز 🌟';
        case 'very_good':
          return 'جيد جداً 👍';
        case 'good':
          return 'جيد 👏';
        case 'not_memorized':
          return 'لم يحفظ ⚠️';
        case 'postponed':
          return 'مؤجل ⏳';
        default:
          return grade;
      }
    }

    // Format today's memo entries
    final String todayMemoFormatted;
    if (_memoEntries.length == 1) {
      todayMemoFormatted =
          '${_formatSingleQuranEntry(_memoEntries.first)}\n    └ *التقدير:* ${translateGrade(_memoEntries.first.grade)}';
    } else {
      todayMemoFormatted = '\n' +
          _memoEntries.asMap().entries.map((e) {
            return '    ${e.key + 1}. ${_formatSingleQuranEntry(e.value)} (${translateGrade(e.value.grade)})';
          }).join('\n');
    }

    // Format today's rev entries
    final String todayRevFormatted;
    if (_revEntries.length == 1) {
      todayRevFormatted =
          '${_formatSingleQuranEntry(_revEntries.first)}\n    └ *التقدير:* ${translateGrade(_revEntries.first.grade)}';
    } else {
      todayRevFormatted = '\n' +
          _revEntries.asMap().entries.map((e) {
            return '    ${e.key + 1}. ${_formatSingleQuranEntry(e.value)} (${translateGrade(e.value.grade)})';
          }).join('\n');
    }

    // Format tomorrow's memo entries
    final String tomorrowMemoFormatted;
    if (_tMemoEntries.length == 1) {
      tomorrowMemoFormatted = _formatSingleQuranEntry(_tMemoEntries.first);
    } else {
      tomorrowMemoFormatted = '\n' +
          _tMemoEntries.asMap().entries.map((e) {
            return '    ${e.key + 1}. ${_formatSingleQuranEntry(e.value)}';
          }).join('\n');
    }

    // Format tomorrow's rev entries
    final String tomorrowRevFormatted;
    if (_tRevEntries.length == 1) {
      tomorrowRevFormatted = _formatSingleQuranEntry(_tRevEntries.first);
    } else {
      tomorrowRevFormatted = '\n' +
          _tRevEntries.asMap().entries.map((e) {
            return '    ${e.key + 1}. ${_formatSingleQuranEntry(e.value)}';
          }).join('\n');
    }

    final String parentPrayer =
        'نسأل الله العلي القدير أن يبارك فيكم وفي أولادكم وأن يقر أعينكم بصلاحهم وحفظهم لكتاب الله العزيز.';

    // Teacher notes
    final notes = _notesCtrl.text.trim().isEmpty
        ? 'لا توجد ملاحظات إضافية اليوم.'
        : _notesCtrl.text.trim();

    // Construct message
    final String message = 'السلام عليكم ورحمة الله وبركاته 🌸\n\n'
        '📬 *تقرير التسميع اليومي للطالب: ${student.name}*\n'
        '🗓️ *التاريخ:* $arabicDate\n'
        '⏰ *حالة الحضور:* حاضر\n'
        '⏱️ *وقت التسميع:* من ${_arrivalTime.format(context)} إلى ${_departureTime.format(context)}\n\n'
        '📖 *لوح اليوم:* \n'
        '  - *الحفظ الجديد:* $todayMemoFormatted\n'
        '  - *المراجعة والتمكين:* $todayRevFormatted\n\n'
        '-----------------------------------\n\n'
        '✍ *ملاحظات المعلم:* $notes\n\n'
        '📅 *لوح الغد (التحضير المتوقع):* \n'
        '  - *الحفظ الجديد:* $tomorrowMemoFormatted\n'
        '  - *المراجعة:* $tomorrowRevFormatted\n\n'
        '-----------------------------------\n\n'
        '🤲 *دعاء للوالدين:* \n'
        '$parentPrayer';

    await launchWhatsAppMessage(
      context: context,
      phone: student.parentPhone,
      message: message,
    );
  }

  Future<void> _saveTomorrowPlan() async {
    final recordRepo = ref.read(recordRepositoryProvider);

    final plan = TomorrowPlan(
      studentId: widget.studentId,
      memorizationMethod: _tMemoEntries.length == 1
          ? _tMemoEntries.first.method
          : 'multiple_entries',
      memorizationData: _buildRecordJsonList(_tMemoEntries),
      revisionMethod: _tRevEntries.length == 1
          ? _tRevEntries.first.method
          : 'multiple_entries',
      revisionData: _buildRecordJsonList(_tRevEntries),
      notes: _tNotesCtrl.text.trim(),
      encouragementMessage: null,
    );

    await recordRepo.saveTomorrowPlan(plan);
    await _markTomorrowPlanSavedToday();

    if (!mounted) return;
    setState(() => _tomorrowSaved = true);
    AppNotification.showSuccess(context, 'تم حفظ خطة الغد للتحضير بنجاح');
  }

  Future<void> _saveMemorizationPlan() async {
    final recordRepo = ref.read(recordRepositoryProvider);

    final plan = MemorizationPlan(
      studentId: widget.studentId,
      attendanceDaysPerWeek: _daysPerWeek,
      dailyLinesCount: _linesPerDay,
      direction: _direction,
      startSurah: _planStartSurah,
      startVerse: _planStartVerse,
      endSurah: _planEndSurah,
      endVerse: _planEndVerse,
      notes: _planNotesCtrl.text.trim(),
    );

    await recordRepo.saveMemorizationPlan(plan);

    if (!mounted) return;
    AppNotification.showInfo(context, 'تم حفظ الخطة العامة للقرآن');
    _loadAllData();
  }

  Future<List<int>?> _showMultiSurahPickerDialog(
      List<int> initialSelection) async {
    List<int> selected = List.from(initialSelection);
    String filter = '';

    return showDialog<List<int>>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filteredSurahs = QuranData.surahs.where((s) {
              return s.nameAr.contains(filter) ||
                  s.nameEn.toLowerCase().contains(filter.toLowerCase());
            }).toList();

            return AlertDialog(
              title: Text('اختر السور المتفرقة',
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'ابحث عن السورة...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (val) {
                        setDialogState(() {
                          filter = val.trim();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredSurahs.length,
                        itemBuilder: (context, idx) {
                          final surah = filteredSurahs[idx];
                          final isChecked = selected.contains(surah.id);
                          return CheckboxListTile(
                            title: Text(surah.nameAr,
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(surah.nameEn,
                                style: const TextStyle(fontSize: 11)),
                            value: isChecked,
                            onChanged: (checked) {
                              setDialogState(() {
                                if (checked == true) {
                                  selected.add(surah.id);
                                } else {
                                  selected.remove(surah.id);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, selected),
                  child: const Text('تأكيد الاختيار'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<String> getVersesForSurah(int surahId) {
    final surah = QuranData.getSurahById(surahId);
    if (surah == null) return ['1'];
    return List.generate(surah.totalVerses, (i) => '${i + 1}');
  }

  String _formatSingleQuranEntry(QuranEntry entry) {
    switch (entry.method) {
      case 'surah':
        final surahName = QuranData.getSurahById(entry.surahId)?.nameAr ?? '';
        return 'سورة $surahName [${entry.startVerse} - ${entry.endVerse}]';
      case 'range':
        final startName =
            QuranData.getSurahById(entry.startSurahId)?.nameAr ?? '';
        final endName = QuranData.getSurahById(entry.endSurahId)?.nameAr ?? '';
        return 'من $startName إلى $endName';
      case 'juz':
        return 'الجزء ${entry.juzId} كاملاً';
      case 'multiple':
        final names = entry.selectedSurahs
            .map((id) => QuranData.getSurahById(id)?.nameAr ?? '')
            .join('، ');
        return 'متعدد: $names';
      default:
        return '';
    }
  }

  String _formatQuranData(String method, String rawData) {
    if (rawData.isEmpty) return '';
    try {
      final decoded = jsonDecode(rawData);
      if (decoded is Map<String, dynamic> && decoded.containsKey('entries')) {
        final list = decoded['entries'] as List;
        final entries = list.map((e) => QuranEntry.fromJson(e)).toList();
        return entries.map((entry) {
          return _formatSingleQuranEntry(entry);
        }).join(' + ');
      } else {
        // Legacy single entry
        final entry = QuranEntry(method: method);
        final data = decoded as Map<String, dynamic>;
        if (method == 'surah') {
          entry.surahId = data['surahId'] ?? 1;
          entry.startVerse = data['startVerse'] ?? 1;
          entry.endVerse = data['endVerse'] ?? 7;
        } else if (method == 'range') {
          entry.startSurahId = data['startSurahId'] ?? 1;
          entry.endSurahId = data['endSurahId'] ?? 2;
        } else if (method == 'juz') {
          entry.juzId = data['juzId'] ?? 30;
        } else if (method == 'multiple') {
          entry.selectedSurahs = List<int>.from(data['surahIds'] ?? []);
        }
        return _formatSingleQuranEntry(entry);
      }
    } catch (_) {
      return rawData;
    }
  }

  void _showEditStudentDialog(Student student) {
    final nameCtrl = TextEditingController(text: student.name);
    final phoneCtrl = TextEditingController(text: student.parentPhone);
    final subCtrl = TextEditingController(text: student.monthlySubscription.toString());

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'تعديل بيانات الطالب',
                style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'اسم الطالب كامل',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: phoneCtrl,
                      decoration: const InputDecoration(
                        labelText: 'رقم هاتف ولي الأمر (واتساب)',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: subCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'قيمة الاشتراك الشهري (ج.م)',
                        prefixIcon: Icon(Icons.attach_money_rounded),
                        border: OutlineInputBorder(),
                      ),
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
                    if (nameCtrl.text.trim().isEmpty ||
                        phoneCtrl.text.trim().isEmpty) {
                      AppNotification.showError(context, 'يرجى ملء جميع الحقول المطلوبة');
                      return;
                    }
                    final parsedSub = int.tryParse(subCtrl.text.trim()) ?? student.monthlySubscription;
                    final updatedStudent = Student(
                      id: student.id,
                      name: nameCtrl.text.trim(),
                      parentName: nameCtrl.text.trim(),
                      parentPhone: phoneCtrl.text.trim(),
                      loginCode: student.loginCode,
                      teacherId: student.teacherId,
                      points: student.points,
                      stars: student.stars,
                      achievementLevel: student.achievementLevel,
                      monthlySubscription: parsedSub,
                    );

                    await ref
                        .read(studentRepositoryProvider)
                        .updateStudent(updatedStudent);
                    ref.invalidate(studentProfileProvider(student.id));

                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                      AppNotification.showSuccess(context, 'تم تحديث بيانات الطالب بنجاح');
                    }
                  },
                  child: const Text('حفظ التعديل'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentAsync = ref.watch(studentProfileProvider(widget.studentId));
    final archiveAsync =
        ref.watch(studentDailyArchiveProvider(widget.studentId));
    final scheduleAsync = ref.watch(studentScheduleProvider(widget.studentId));
    final todayAttAsync = ref.watch(studentAttendanceProvider((studentId: widget.studentId, date: DateTime.now())));
    final bool isPresentToday = (todayAttAsync.valueOrNull != null && !todayAttAsync.valueOrNull!.isAbsent) || _todaySaved;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل اليوم'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: IslamicTheme.goldMetallic,
          unselectedLabelColor: Colors.white,
          indicatorColor: IslamicTheme.goldMetallic,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'تسجيل اليوم'),
            Tab(text: 'لوح غد'),
            Tab(text: 'الأرشيف'),
            Tab(text: 'الحصاد الشهري'),
            Tab(text: 'خطة الحفظ'),
            Tab(text: 'الجدول'),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Premium solid gradient background
          const Positioned.fill(
            child: IslamicPatternBackground(),
          ),

          _isLoading
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: const [
                        AppShimmer(width: double.infinity, height: 80, borderRadius: 12),
                        SizedBox(height: 16),
                        AppShimmer(width: double.infinity, height: 160, borderRadius: 12),
                        SizedBox(height: 16),
                        AppShimmer(width: double.infinity, height: 140, borderRadius: 12),
                      ],
                    ),
                  ),
                )
              : studentAsync.when(
                  data: (student) {
                    if (student == null) {
                      return const Center(child: Text('الطالب غير موجود'));
                    }

                    return SafeArea(
                      child: Column(
                        children: [
                          // Student Info Header (Premium visual look)
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: 0.3),
                            child: Row(
                              children: [
                                Hero(
                                  tag: 'student_avatar_${student.id}',
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    child: Text(
                                      student.name.isNotEmpty ? student.name[0] : 'ط',
                                      style: GoogleFonts.cairo(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        student.name,
                                        style: GoogleFonts.cairo(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'هاتف ولي الأمر: ${student.parentPhone}  |  الاشتراك: ${student.monthlySubscription} ج.م',
                                        style: GoogleFonts.cairo(
                                            fontSize: 12,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                AppPressable(
                                  onTap: () => _showEditStudentDialog(student),
                                  child: IconButton(
                                    icon: Icon(Icons.edit_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    onPressed: () =>
                                        _showEditStudentDialog(student),
                                    tooltip: 'تعديل بيانات الطالب',
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 350.ms, curve: AppMotion.standard).slideY(begin: -0.05, end: 0),

                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: <Widget>[
                                // 1. DAILY RECORD TAB
                                SingleChildScrollView(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FadeInSlide(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // Memorization Entries
                                        ..._memoEntries
                                            .asMap()
                                            .entries
                                            .map((entryItem) {
                                          final index = entryItem.key;
                                          final entry = entryItem.value;
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16.0),
                                            child: _buildSurahSelectorCard(
                                              title: _memoEntries.length > 1
                                                  ? 'الحفظ الجديد (${index + 1})'
                                                  : 'الحفظ الجديد',
                                              entry: entry,
                                              showDelete:
                                                  _memoEntries.length > 1,
                                              onDelete: () => setState(() =>
                                                  _memoEntries.removeAt(index)),
                                              showGrade: true,
                                              onSelectMultiplePressed:
                                                  () async {
                                                final res =
                                                    await _showMultiSurahPickerDialog(
                                                        entry.selectedSurahs);
                                                if (res != null) {
                                                  setState(() => entry
                                                      .selectedSurahs = res);
                                                }
                                              },
                                              onChanged: () => setState(() {}),
                                            ),
                                          );
                                        }),

                                        // Add Memorization Button
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton.icon(
                                            onPressed: () => setState(() =>
                                                _memoEntries.add(QuranEntry())),
                                            icon: Icon(Icons.add_circle_outline,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                            label: Text('إضافة جديد آخر',
                                                style: GoogleFonts.cairo(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                        const Divider(height: 32),

                                        // Revision Entries
                                        ..._revEntries
                                            .asMap()
                                            .entries
                                            .map((entryItem) {
                                          final index = entryItem.key;
                                          final entry = entryItem.value;
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16.0),
                                            child: _buildSurahSelectorCard(
                                              title: _revEntries.length > 1
                                                  ? 'المراجعة والتمكين (${index + 1})'
                                                  : 'المراجعة والتمكين',
                                              entry: entry,
                                              showDelete:
                                                  _revEntries.length > 1,
                                              onDelete: () => setState(() =>
                                                  _revEntries.removeAt(index)),
                                              showGrade: true,
                                              onSelectMultiplePressed:
                                                  () async {
                                                final res =
                                                    await _showMultiSurahPickerDialog(
                                                        entry.selectedSurahs);
                                                if (res != null) {
                                                  setState(() => entry
                                                      .selectedSurahs = res);
                                                }
                                              },
                                              onChanged: () => setState(() {}),
                                            ),
                                          );
                                        }),

                                        // Add Revision Button
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton.icon(
                                            onPressed: () => setState(() =>
                                                _revEntries.add(QuranEntry())),
                                            icon: Icon(Icons.add_circle_outline,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                            label: Text('إضافة مراجعة أخرى',
                                                style: GoogleFonts.cairo(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                        const Divider(height: 32),

                                        TextField(
                                          controller: _notesCtrl,
                                          decoration: const InputDecoration(
                                              labelText:
                                                  'ملاحظات المعلم والأداء'),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton.icon(
                                                onPressed: () async {
                                                  final time =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: _arrivalTime,
                                                  );
                                                  if (time != null) {
                                                    setState(() =>
                                                        _arrivalTime = time);
                                                  }
                                                },
                                                icon: const Icon(
                                                    Icons.login_rounded),
                                                label: Text(
                                                    'الحضور: ${_arrivalTime.format(context)}'),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: OutlinedButton.icon(
                                                onPressed: () async {
                                                  final time =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: _departureTime,
                                                  );
                                                  if (time != null) {
                                                    setState(() =>
                                                        _departureTime = time);
                                                  }
                                                },
                                                icon: const Icon(
                                                    Icons.logout_rounded),
                                                label: Text(
                                                    'الانصراف: ${_departureTime.format(context)}'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 24),
                                        ElevatedButton(
                                          onPressed: _saveTodayRecord,
                                          child: const Text('حفظ تسميع اليوم'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // 2. TOMORROW PLAN TAB
                                SingleChildScrollView(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FadeInSlide(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text('خطة الحفظ والمراجعة للغد',
                                            style: GoogleFonts.cairo(
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 16),

                                        // Tomorrow Memorization Plan Entries
                                        ..._tMemoEntries
                                            .asMap()
                                            .entries
                                            .map((entryItem) {
                                          final index = entryItem.key;
                                          final entry = entryItem.value;
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16.0),
                                            child: _buildSurahSelectorCard(
                                              title: _tMemoEntries.length > 1
                                                  ? 'خطة حفظ الغد (${index + 1})'
                                                  : 'خطة حفظ الغد',
                                              entry: entry,
                                              showDelete:
                                                  _tMemoEntries.length > 1,
                                              onDelete: () => setState(() =>
                                                  _tMemoEntries
                                                      .removeAt(index)),
                                              showGrade: false,
                                              onSelectMultiplePressed:
                                                  () async {
                                                final res =
                                                    await _showMultiSurahPickerDialog(
                                                        entry.selectedSurahs);
                                                if (res != null) {
                                                  setState(() => entry
                                                      .selectedSurahs = res);
                                                }
                                              },
                                              onChanged: () => setState(() {}),
                                            ),
                                          );
                                        }),

                                        // Add Tomorrow Memorization Button
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton.icon(
                                            onPressed: () => setState(() =>
                                                _tMemoEntries
                                                    .add(QuranEntry())),
                                            icon: Icon(Icons.add_circle_outline,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                            label: Text('إضافة جديد آخر للغد',
                                                style: GoogleFonts.cairo(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                        const Divider(height: 32),

                                        // Tomorrow Revision Plan Entries
                                        ..._tRevEntries
                                            .asMap()
                                            .entries
                                            .map((entryItem) {
                                          final index = entryItem.key;
                                          final entry = entryItem.value;
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16.0),
                                            child: _buildSurahSelectorCard(
                                              title: _tRevEntries.length > 1
                                                  ? 'خطة مراجعة الغد (${index + 1})'
                                                  : 'خطة مراجعة الغد',
                                              entry: entry,
                                              showDelete:
                                                  _tRevEntries.length > 1,
                                              onDelete: () => setState(() =>
                                                  _tRevEntries.removeAt(index)),
                                              showGrade: false,
                                              onSelectMultiplePressed:
                                                  () async {
                                                final res =
                                                    await _showMultiSurahPickerDialog(
                                                        entry.selectedSurahs);
                                                if (res != null) {
                                                  setState(() => entry
                                                      .selectedSurahs = res);
                                                }
                                              },
                                              onChanged: () => setState(() {}),
                                            ),
                                          );
                                        }),

                                        // Add Tomorrow Revision Button
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton.icon(
                                            onPressed: () => setState(() =>
                                                _tRevEntries.add(QuranEntry())),
                                            icon: Icon(Icons.add_circle_outline,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                            label: Text(
                                                'إضافة مراجعة أخرى للغد',
                                                style: GoogleFonts.cairo(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                        const Divider(height: 32),

                                        TextField(
                                          controller: _tNotesCtrl,
                                          decoration: const InputDecoration(
                                              labelText:
                                                  'ملاحظات وتوجيهات للغد'),
                                        ),
                                        const SizedBox(height: 12),
                                        const SizedBox(height: 24),
                                        ElevatedButton(
                                          onPressed: _saveTomorrowPlan,
                                          child: const Text('حفظ خطة الغد'),
                                        ),
                                        const SizedBox(height: 12),
                                        ElevatedButton.icon(
                                          onPressed: isPresentToday
                                              ? () => _sendWhatsAppDailyReport(student)
                                              : null,
                                          icon: Icon(
                                            Icons.share_rounded,
                                            color: isPresentToday ? Colors.white : Colors.grey[500],
                                          ),
                                          label: Text(
                                            isPresentToday
                                                ? 'إرسال التقرير لولي الأمر (واتساب)'
                                                : 'سجل حضور أو تسميع الطالب أولاً لتفعيل الإرسال',
                                            style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF1E6B38),
                                            foregroundColor: Colors.white,
                                            disabledBackgroundColor: Colors.grey[300],
                                            disabledForegroundColor: Colors.grey[600],
                                            elevation: isPresentToday ? 3 : 0,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                              horizontal: 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // 3. DAILY ARCHIVE TAB
                                archiveAsync.when(
                                  data: (records) {
                                    if (records.isEmpty) {
                                      return const Center(
                                          child: Text(
                                              'لا يوجد سجلات سابقة متوفرة'));
                                    }
                                    return ListView.builder(
                                      padding: const EdgeInsets.all(16),
                                      itemCount: records.length,
                                      itemBuilder: (context, idx) {
                                        final record = records[idx];
                                        final formattedDate =
                                            intl.DateFormat('yyyy-MM-dd')
                                                .format(record.date);

                                        return _buildEnhancedArchiveCard(record, idx);
                                      },
                                    );
                                  },
                                  loading: () => const Center(
                                      child: CircularProgressIndicator()),
                                  error: (err, s) =>
                                      Center(child: Text('خطأ: $err')),
                                ),

                                // 4. MONTHLY HARVEST TAB
                                archiveAsync.when(
                                  data: (records) {
                                    final now = DateTime.now();
                                    final currentMonthRecords = records
                                        .where((r) =>
                                            r.date.year == now.year &&
                                            r.date.month == now.month)
                                        .toList();
                                    final double presentDays =
                                        currentMonthRecords.length.toDouble();

                                    List<int> extractSurahs(
                                        String method, String dataJson) {
                                      if (dataJson.isEmpty) return [];
                                      try {
                                        final data = jsonDecode(dataJson);
                                        switch (method) {
                                          case 'surah':
                                            final surahId =
                                                data['surahId'] as int?;
                                            return surahId != null
                                                ? [surahId]
                                                : [];
                                          case 'range':
                                            final start =
                                                data['startSurahId'] as int?;
                                            final end =
                                                data['endSurahId'] as int?;
                                            if (start != null && end != null) {
                                              final s =
                                                  start < end ? start : end;
                                              final e =
                                                  start < end ? end : start;
                                              return List.generate(
                                                  e - s + 1, (i) => s + i);
                                            }
                                            return [];
                                          case 'juz':
                                            final juzId = data['juzId'] as int?;
                                            if (juzId != null) {
                                              final juz =
                                                  QuranData.getJuzByNumber(
                                                      juzId);
                                              if (juz != null) {
                                                return QuranData.surahs
                                                    .where((s) =>
                                                        s.startPage <=
                                                            juz.endPage &&
                                                        s.endPage >=
                                                            juz.startPage)
                                                    .map((s) => s.id)
                                                    .toList();
                                              }
                                            }
                                            return [];
                                          case 'multiple':
                                            final List<dynamic>? ids =
                                                data['surahIds']
                                                    as List<dynamic>?;
                                            return ids
                                                    ?.map((e) => e as int)
                                                    .toList() ??
                                                [];
                                          default:
                                            return [];
                                        }
                                      } catch (_) {
                                        return [];
                                      }
                                    }

                                    final Set<int> memorizedSurahIds = {};
                                    final Set<int> reviewedSurahIds = {};

                                    for (var r in currentMonthRecords) {
                                      if (r.memorizationGrade !=
                                              'not_memorized' &&
                                          r.memorizationGrade != 'postponed') {
                                        memorizedSurahIds.addAll(extractSurahs(
                                            r.memorizationMethod,
                                            r.memorizationData));
                                      }
                                      if (r.revisionGrade != 'not_memorized' &&
                                          r.revisionGrade != 'postponed') {
                                        reviewedSurahIds.addAll(extractSurahs(
                                            r.revisionMethod, r.revisionData));
                                      }
                                    }

                                    final memorizedNames = memorizedSurahIds
                                        .map((id) =>
                                            QuranData.getSurahById(id)
                                                ?.nameAr ??
                                            '')
                                        .where((n) => n.isNotEmpty)
                                        .join('، ');
                                    final reviewedNames = reviewedSurahIds
                                        .map((id) =>
                                            QuranData.getSurahById(id)
                                                ?.nameAr ??
                                            '')
                                        .where((n) => n.isNotEmpty)
                                        .join('، ');

                                    return SingleChildScrollView(
                                      padding: const EdgeInsets.all(24.0),
                                      child: FadeInSlide(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              'الحصاد الشهري لإنجاز الطالب 🌾',
                                              style: GoogleFonts.cairo(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color:
                                                      IslamicTheme.oliveLight),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 24),
                                            Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: IslamicTheme
                                                  .premiumCardDecoration(
                                                      context: context),
                                              child: Column(
                                                children: [
                                                  _buildHarvestRow(
                                                      'عدد أيام الحضور الفعلي:',
                                                      '${presentDays.toInt()} أيام'),
                                                  const Divider(height: 24),
                                                  _buildHarvestRow(
                                                      'السور التي تم حفظها:',
                                                      memorizedNames.isEmpty
                                                          ? 'لا يوجد'
                                                          : memorizedNames),
                                                  const Divider(height: 24),
                                                  _buildHarvestRow(
                                                      'السور التي تم مراجعتها:',
                                                      reviewedNames.isEmpty
                                                          ? 'لا يوجد'
                                                          : reviewedNames),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  loading: () => const Center(
                                      child: CircularProgressIndicator()),
                                  error: (err, s) =>
                                      Center(child: Text('خطأ: $err')),
                                ),

                                // 5. MEMORIZATION PLAN TAB
                                SingleChildScrollView(
                                  padding: const EdgeInsets.all(24.0),
                                  child: FadeInSlide(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          'الخطة العامة لحفظ ومراجعة الطالب',
                                          style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(height: 24),
                                        DropdownButtonFormField<int>(
                                          value: _daysPerWeek,
                                          decoration: const InputDecoration(
                                              labelText:
                                                  'عدد أيام الحضور الأسبوعي للولد'),
                                          items: const [
                                            DropdownMenuItem(
                                                value: 2,
                                                child:
                                                    Text('يومين في الأسبوع')),
                                            DropdownMenuItem(
                                                value: 3,
                                                child: Text('ثلاثة أيام')),
                                            DropdownMenuItem(
                                                value: 4,
                                                child: Text('أربعة أيام')),
                                            DropdownMenuItem(
                                                value: 5,
                                                child: Text(
                                                    'خمسة أيام (افتراضي)')),
                                            DropdownMenuItem(
                                                value: 6,
                                                child: Text('ستة أيام')),
                                          ],
                                          onChanged: (val) => setState(
                                              () => _daysPerWeek = val!),
                                        ),
                                        const SizedBox(height: 16),
                                        DropdownButtonFormField<int>(
                                          value: _linesPerDay,
                                          decoration: const InputDecoration(
                                              labelText:
                                                  'مقدار الحفظ اليومي بالسطر'),
                                          items: const [
                                            DropdownMenuItem(
                                                value: 5,
                                                child: Text('٥ أسطر يومياً')),
                                            DropdownMenuItem(
                                                value: 10,
                                                child: Text('١٠ أسطر يومياً')),
                                            DropdownMenuItem(
                                                value: 15,
                                                child: Text(
                                                    'صفحة كاملة (١٥ سطرًا)')),
                                            DropdownMenuItem(
                                                value: 30,
                                                child:
                                                    Text('صفحتين (٣٠ سطرًا)')),
                                          ],
                                          onChanged: (val) => setState(
                                              () => _linesPerDay = val!),
                                        ),
                                        const SizedBox(height: 16),
                                        DropdownButtonFormField<int>(
                                          value: _direction,
                                          decoration: const InputDecoration(
                                              labelText:
                                                  'اتجاه وسير خطة الحفظ'),
                                          items: const [
                                            DropdownMenuItem(
                                                value: 0,
                                                child: Text(
                                                    'من الناس إلى البقرة (عكسي)')),
                                            DropdownMenuItem(
                                                value: 1,
                                                child: Text(
                                                    'من البقرة إلى الناس (تصاعدي)')),
                                          ],
                                          onChanged: (val) =>
                                              setState(() => _direction = val!),
                                        ),
                                        const SizedBox(height: 24),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.green
                                                .withValues(alpha: 0.05),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.green
                                                    .withValues(alpha: 0.2)),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                'تاريخ الختم المتوقع بناءً على الخطة:',
                                                style: GoogleFonts.cairo(
                                                    fontSize: 13,
                                                    color: Colors.grey[700]),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                intl.DateFormat('yyyy-MM-dd')
                                                    .format(
                                                  (() {
                                                    int pagesRemaining = 604;
                                                    final sSurah =
                                                        QuranData.getSurahById(
                                                            _planStartSurah);
                                                    final eSurah =
                                                        QuranData.getSurahById(
                                                            _planEndSurah);
                                                    if (sSurah != null &&
                                                        eSurah != null) {
                                                      pagesRemaining = (eSurah
                                                                      .endPage -
                                                                  sSurah
                                                                      .startPage)
                                                              .abs() +
                                                          1;
                                                    }
                                                    return QuranEngine
                                                        .estimateCompletionDate(
                                                      pagesRemaining:
                                                          pagesRemaining
                                                              .toDouble(),
                                                      dailyLines: _linesPerDay
                                                          .toDouble(),
                                                      attendanceDaysPerWeek:
                                                          _daysPerWeek,
                                                    );
                                                  })(),
                                                ),
                                                style: GoogleFonts.cairo(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.blue
                                                .withValues(alpha: 0.05),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.blue
                                                    .withValues(alpha: 0.2)),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                'معدل الحفظ الشهري المتوقع:',
                                                style: GoogleFonts.cairo(
                                                    fontSize: 13,
                                                    color: Colors.grey[700]),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                '${((_linesPerDay * _daysPerWeek * 4) / 15).toStringAsFixed(1)} صفحة شهرياً',
                                                style: GoogleFonts.cairo(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextField(
                                          controller: _planNotesCtrl,
                                          decoration: const InputDecoration(
                                              labelText:
                                                  'توجيهات وملاحظات الخطة العامة'),
                                        ),
                                        const SizedBox(height: 24),
                                        ElevatedButton(
                                          onPressed: _saveMemorizationPlan,
                                          child: const Text('حفظ الخطة العامة'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // 6. SCHEDULE TAB
                                scheduleAsync.when(
                                  data: (schedule) {
                                    return _TeacherWeeklyScheduleWidget(
                                      studentId: widget.studentId,
                                      initialSchedule: schedule,
                                    );
                                  },
                                  loading: () => const Center(
                                      child: CircularProgressIndicator()),
                                  error: (err, s) => _TeacherWeeklyScheduleWidget(
                                    studentId: widget.studentId,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, s) =>
                      Center(child: Text('خطأ في تحميل الملف الشخصي: $err')),
                ),
        ],
      ),
    );
  }

  Widget _buildHarvestRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildSurahSelectorCard({
    required String title,
    required QuranEntry entry,
    bool showDelete = false,
    VoidCallback? onDelete,
    bool showGrade = true,
    required VoidCallback onSelectMultiplePressed,
    required VoidCallback onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: IslamicTheme.premiumCardDecoration(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary)),
              if (showDelete)
                IconButton(
                  icon: const Icon(Icons.delete_forever_rounded,
                      color: Colors.redAccent),
                  onPressed: onDelete,
                  tooltip: 'حذف هذا المدخل',
                ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: entry.method,
            decoration: const InputDecoration(labelText: 'طريقة الاختيار'),
            items: const [
              DropdownMenuItem(value: 'surah', child: Text('طريقة السورة')),
              DropdownMenuItem(
                  value: 'range',
                  child: Text('طريقة النطاق (من سورة إلى سورة)')),
              DropdownMenuItem(
                  value: 'juz', child: Text('طريقة الجزء (جزء كامل)')),
              DropdownMenuItem(
                  value: 'multiple', child: Text('طريقة متعدد (سور متفرقة)')),
            ],
            onChanged: (val) {
              entry.method = val!;
              onChanged();
            },
          ),
          const SizedBox(height: 12),
          if (entry.method == 'surah') ...[
            DropdownButtonFormField<int>(
              value: entry.surahId,
              decoration: const InputDecoration(labelText: 'اختر السورة'),
              items: QuranData.surahs.map((s) {
                return DropdownMenuItem(value: s.id, child: Text(s.nameAr));
              }).toList(),
              onChanged: (val) {
                entry.surahId = val!;
                entry.startVerse = 1;
                entry.endVerse = QuranData.getSurahById(val)?.totalVerses ?? 7;
                onChanged();
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      final totalVerses =
                          QuranData.getSurahById(entry.surahId)?.totalVerses ??
                              1;
                      final firstHalfEnd = (totalVerses + 1) ~/ 2;
                      entry.startVerse = 1;
                      entry.endVerse = firstHalfEnd;
                      onChanged();
                    },
                    child: const Text('النصف الأول'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      final totalVerses =
                          QuranData.getSurahById(entry.surahId)?.totalVerses ??
                              1;
                      final firstHalfEnd = (totalVerses + 1) ~/ 2;
                      entry.startVerse =
                          firstHalfEnd < totalVerses ? firstHalfEnd + 1 : 1;
                      entry.endVerse = totalVerses;
                      onChanged();
                    },
                    child: const Text('النصف الثاني'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: getVersesForSurah(entry.surahId)
                            .contains('${entry.startVerse}')
                        ? '${entry.startVerse}'
                        : '1',
                    decoration: const InputDecoration(labelText: 'من آية'),
                    items: getVersesForSurah(entry.surahId).map((val) {
                      return DropdownMenuItem(value: val, child: Text(val));
                    }).toList(),
                    onChanged: (val) {
                      entry.startVerse = int.parse(val!);
                      onChanged();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: getVersesForSurah(entry.surahId)
                            .contains('${entry.endVerse}')
                        ? '${entry.endVerse}'
                        : (getVersesForSurah(entry.surahId).isNotEmpty
                            ? getVersesForSurah(entry.surahId).last
                            : '1'),
                    decoration: const InputDecoration(labelText: 'إلى آية'),
                    items: getVersesForSurah(entry.surahId).map((val) {
                      return DropdownMenuItem(value: val, child: Text(val));
                    }).toList(),
                    onChanged: (val) {
                      entry.endVerse = int.parse(val!);
                      onChanged();
                    },
                  ),
                ),
              ],
            ),
          ],
          if (entry.method == 'range') ...[
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: entry.startSurahId,
                    decoration: const InputDecoration(labelText: 'من سورة'),
                    items: QuranData.surahs.map((s) {
                      return DropdownMenuItem(
                          value: s.id, child: Text(s.nameAr));
                    }).toList(),
                    onChanged: (val) {
                      entry.startSurahId = val!;
                      onChanged();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: entry.endSurahId,
                    decoration: const InputDecoration(labelText: 'إلى سورة'),
                    items: QuranData.surahs.map((s) {
                      return DropdownMenuItem(
                          value: s.id, child: Text(s.nameAr));
                    }).toList(),
                    onChanged: (val) {
                      entry.endSurahId = val!;
                      onChanged();
                    },
                  ),
                ),
              ],
            ),
          ],
          if (entry.method == 'juz') ...[
            DropdownButtonFormField<int>(
              value: entry.juzId,
              decoration: const InputDecoration(labelText: 'اختر الجزء'),
              items: List.generate(30, (i) => i + 1).map((n) {
                return DropdownMenuItem(value: n, child: Text('الجزء $n'));
              }).toList(),
              onChanged: (val) {
                entry.juzId = val!;
                onChanged();
              },
            ),
          ],
          if (entry.method == 'multiple') ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton.icon(
                  onPressed: onSelectMultiplePressed,
                  icon: const Icon(Icons.playlist_add_check_rounded),
                  label: const Text('تحديد السور المتفرقة'),
                ),
                const SizedBox(height: 8),
                Text(
                  entry.selectedSurahs.isEmpty
                      ? 'لم يتم اختيار سور بعد'
                      : 'السور المختارة: ${entry.selectedSurahs.map((id) => QuranData.getSurahById(id)?.nameAr ?? '').join('، ')}',
                  style:
                      GoogleFonts.cairo(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ],
          if (showGrade) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: entry.grade,
              decoration: const InputDecoration(labelText: 'التقدير / الدرجة'),
              items: const [
                DropdownMenuItem(value: 'excellent', child: Text('ممتاز (أ)')),
                DropdownMenuItem(
                    value: 'very_good', child: Text('جيد جداً (ب)')),
                DropdownMenuItem(value: 'good', child: Text('جيد (ج)')),
                DropdownMenuItem(
                    value: 'not_memorized', child: Text('لم يحفظ')),
                DropdownMenuItem(value: 'postponed', child: Text('مؤجل')),
              ],
              onChanged: (val) {
                entry.grade = val!;
                onChanged();
              },
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildEnhancedArchiveCard(DailyRecord record, int idx) {
    String formatGradeText(String grade) {
      switch (grade) {
        case 'excellent':
          return 'ممتاز 🌟';
        case 'very_good':
          return 'جيد جداً 👍';
        case 'good':
          return 'جيد 👏';
        case 'not_memorized':
          return 'لم يحفظ ⚠️';
        case 'postponed':
          return 'مؤجل ⏳';
        default:
          return grade;
      }
    }

    Color getGradeColor(String grade) {
      switch (grade) {
        case 'excellent':
          return Colors.green[800]!;
        case 'very_good':
          return Colors.blue[800]!;
        case 'good':
          return Colors.amber[900]!;
        case 'not_memorized':
          return Colors.orange[900]!;
        case 'postponed':
          return Colors.red[800]!;
        default:
          return Colors.grey[800]!;
      }
    }

    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(record.date);

    return FadeInSlide(
      delay: Duration(milliseconds: idx * 40),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFCF9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFC5A85A).withValues(alpha: 0.35),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC5A85A).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.event_note_rounded, size: 18, color: Color(0xFF34422B)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'سجل يوم: $formattedDate',
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: const Color(0xFF2B3724),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),

            // لوح الحفظ الجديد
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.menu_book_rounded, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'لوح الحفظ الجديد:',
                          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green[900]),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatQuranData(record.memorizationMethod, record.memorizationData),
                          style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: getGradeColor(record.memorizationGrade).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: getGradeColor(record.memorizationGrade).withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      formatGradeText(record.memorizationGrade),
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: getGradeColor(record.memorizationGrade),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // لوح المراجعة
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.auto_stories_rounded, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'لوح المراجعة والتثبيت:',
                          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue[900]),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatQuranData(record.revisionMethod, record.revisionData),
                          style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: getGradeColor(record.revisionGrade).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: getGradeColor(record.revisionGrade).withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      formatGradeText(record.revisionGrade),
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: getGradeColor(record.revisionGrade),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (record.teacherNotes != null && record.teacherNotes!.trim().isNotEmpty) ...[
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.comment_outlined, size: 16, color: Colors.black54),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'ملاحظات المعلم: ${record.teacherNotes}',
                        style: GoogleFonts.cairo(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

}
// ==================== TEACHER WEEKLY SCHEDULE WIDGET ====================
class _TeacherWeeklyScheduleWidget extends ConsumerStatefulWidget {
  final String studentId;
  final ParentSchedule? initialSchedule;

  const _TeacherWeeklyScheduleWidget({
    required this.studentId,
    this.initialSchedule,
  });

  @override
  ConsumerState<_TeacherWeeklyScheduleWidget> createState() =>
      _TeacherWeeklyScheduleWidgetState();
}

class _TeacherWeeklyScheduleWidgetState
    extends ConsumerState<_TeacherWeeklyScheduleWidget> {
  final List<String> _days = [
    'السبت',
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
  ];

  final Map<String, String> _dayTimes = {};
  final Map<String, TextEditingController> _dayNotesControllers = {};

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> parsed = {};
    if (widget.initialSchedule != null &&
        widget.initialSchedule!.lessonsJson.isNotEmpty) {
      try {
        parsed = jsonDecode(widget.initialSchedule!.lessonsJson);
      } catch (_) {}
    }

    for (final day in _days) {
      final dayData = parsed[day];
      if (dayData is Map<String, dynamic>) {
        _dayTimes[day] = dayData['time']?.toString() ?? '04:00 م';
        _dayNotesControllers[day] =
            TextEditingController(text: dayData['notes']?.toString() ?? '');
      } else {
        _dayTimes[day] = '04:00 م';
        _dayNotesControllers[day] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final c in _dayNotesControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickTime(String day) async {
    final currentStr = _dayTimes[day] ?? '04:00 م';
    TimeOfDay initial = const TimeOfDay(hour: 16, minute: 0);
    try {
      final parts = currentStr.split(' ');
      if (parts.isNotEmpty) {
        final timeParts = parts[0].split(':');
        int hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        if (parts.length > 1 && parts[1] == 'م' && hour < 12) {
          hour += 12;
        } else if (parts.length > 1 && parts[1] == 'ص' && hour == 12) {
          hour = 0;
        }
        initial = TimeOfDay(hour: hour, minute: minute);
      }
    } catch (_) {}

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: 'اختر موعد حضور الحلقة ليوم $day',
    );

    if (picked != null) {
      setState(() {
        _dayTimes[day] = picked.format(context);
      });
    }
  }

  Future<void> _saveSchedule() async {
    final Map<String, dynamic> exportMap = {};
    for (final day in _days) {
      exportMap[day] = {
        'time': _dayTimes[day] ?? '04:00 م',
        'notes': _dayNotesControllers[day]?.text.trim() ?? '',
      };
    }

    final repo = ref.read(recordRepositoryProvider);
    await repo.saveParentSchedule(
      widget.studentId,
      jsonEncode(exportMap),
    );

    if (!mounted) return;
    AppNotification.showSuccess(context, 'تم حفظ جدول مواعيد وملاحظات الطالب بنجاح');
    ref.invalidate(studentScheduleProvider(widget.studentId));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: FadeInSlide(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFC5A85A).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFC5A85A).withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule_rounded, color: Color(0xFF34422B)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'سجل مواعيد حضور الطالب في الحلقة لكل يوم من أيام الأسبوع مع الملاحظات المخصصة.',
                      style: GoogleFonts.cairo(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2B3724),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            ..._days.map((day) {
              final isHoliday = _dayTimes[day] == 'إجازة';
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isHoliday
                        ? Colors.grey.withValues(alpha: 0.25)
                        : const Color(0xFFC5A85A).withValues(alpha: 0.35),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF34422B).withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF34422B)),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              day,
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: const Color(0xFF2B3724),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _dayTimes[day] = isHoliday ? '04:00 م' : 'إجازة';
                                });
                              },
                              icon: Icon(
                                isHoliday
                                    ? Icons.check_circle_outline
                                    : Icons.beach_access_outlined,
                                size: 16,
                                color: isHoliday ? Colors.green : Colors.grey,
                              ),
                              label: Text(
                                isHoliday ? 'يوم دوام' : 'إجازة',
                                style: GoogleFonts.cairo(
                                  fontSize: 11,
                                  color: isHoliday ? Colors.green : Colors.grey[700],
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: isHoliday ? null : () => _pickTime(day),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isHoliday
                                      ? Colors.grey.withValues(alpha: 0.15)
                                      : const Color(0xFFC5A85A).withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isHoliday
                                        ? Colors.grey.withValues(alpha: 0.3)
                                        : const Color(0xFFC5A85A),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.access_time_filled_rounded,
                                        size: 14,
                                        color: isHoliday
                                            ? Colors.grey
                                            : const Color(0xFF2B3724)),
                                    const SizedBox(width: 6),
                                    Text(
                                      _dayTimes[day] ?? '04:00 م',
                                      style: GoogleFonts.cairo(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isHoliday
                                            ? Colors.grey
                                            : const Color(0xFF2B3724),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _dayNotesControllers[day],
                      decoration: InputDecoration(
                        hintText: 'ملاحظات يوم $day (مثلاً: مراجعة جزء عم، حفظ سورة...)',
                        hintStyle: GoogleFonts.cairo(fontSize: 11, color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.note_alt_outlined, size: 18),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFBFBF8),
                      ),
                      style: GoogleFonts.cairo(fontSize: 12),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _saveSchedule,
              icon: const Icon(Icons.save_rounded, color: Colors.white),
              label: Text(
                'حفظ وتثبيت جدول الأسبوع للطالب',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: IslamicTheme.oliveDeep,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
