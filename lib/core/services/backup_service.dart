import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:athar/core/database/app_database.dart';

class BackupRestoreResult {
  final int teachersCount;
  final int studentsCount;
  final int recordsCount;
  final int paymentsCount;
  final int attendanceCount;

  BackupRestoreResult({
    required this.teachersCount,
    required this.studentsCount,
    required this.recordsCount,
    required this.paymentsCount,
    required this.attendanceCount,
  });
}

class BackupService {
  /// Exports all application data into a shareable backup file (.athar)
  static Future<File> exportBackup(AppDatabase db) async {
    final teachers = await db.select(db.teachersTable).get();
    final students = await db.select(db.studentsTable).get();
    final attendance = await db.select(db.attendanceTable).get();
    final dailyRecords = await db.select(db.dailyRecordsTable).get();
    final tomorrowPlans = await db.select(db.tomorrowMemorizationTable).get();
    final plans = await db.select(db.plansTable).get();
    final schedules = await db.select(db.schedulesTable).get();
    final reminders = await db.select(db.remindersTable).get();
    final payments = await db.select(db.paymentsTable).get();

    final backupData = {
      'app': 'ATHAR',
      'version': 4,
      'exportedAt': DateTime.now().toIso8601String(),
      'teachers': teachers
          .map((t) => {
                'id': t.id,
                'fullName': t.fullName,
                'phoneNumber': t.phoneNumber,
                
                'isActive': t.isActive,
                'studentCount': t.studentCount,
              })
          .toList(),
      'students': students
          .map((s) => {
                'id': s.id,
                'name': s.name,
                'parentName': s.parentName,
                'parentPhone': s.parentPhone,
                'loginCode': s.loginCode,
                'teacherId': s.teacherId,
                'points': s.points,
                'stars': s.stars,
                'achievementLevel': s.achievementLevel,
                'monthlySubscription': s.monthlySubscription,
              })
          .toList(),
      'attendance': attendance
          .map((a) => {
                'id': a.id,
                'studentId': a.studentId,
                'date': a.date.toIso8601String(),
                'isAbsent': a.isAbsent,
                
              })
          .toList(),
      'dailyRecords': dailyRecords
          .map((r) => {
                'id': r.id,
                'studentId': r.studentId,
                'date': r.date.toIso8601String(),
                'memorizationGrade': r.memorizationGrade,
                'memorizationMethod': r.memorizationMethod,
                'memorizationData': r.memorizationData,
                'revisionGrade': r.revisionGrade,
                'revisionMethod': r.revisionMethod,
                'revisionData': r.revisionData,
                'teacherNotes': r.teacherNotes,
              })
          .toList(),
      'tomorrowPlans': tomorrowPlans
          .map((p) => {
                'studentId': p.studentId,
                'memorizationMethod': p.memorizationMethod,
                'memorizationData': p.memorizationData,
                'revisionMethod': p.revisionMethod,
                'revisionData': p.revisionData,
                'notes': p.notes,
                
              })
          .toList(),
      'plans': plans
          .map((m) => {
                'studentId': m.studentId,
                'attendanceDaysPerWeek': m.attendanceDaysPerWeek,
                'dailyLinesCount': m.dailyLinesCount,
                'direction': m.direction,
                'startSurah': m.startSurah,
                'startVerse': m.startVerse,
                'endSurah': m.endSurah,
                'endVerse': m.endVerse,
                'notes': m.notes,
              })
          .toList(),
      'schedules': schedules
          .map((sc) => {
                'studentId': sc.studentId,
                'lessonsJson': sc.lessonsJson,
                'lastModified': sc.lastModified.toIso8601String(),
                'modificationHistoryJson': sc.modificationHistoryJson,
              })
          .toList(),
      'reminders': reminders
          .map((rm) => {
                'id': rm.id,
                'studentId': rm.studentId,
                'title': rm.title,
                'content': rm.content,
                'createdAt': rm.createdAt.toIso8601String(),
              })
          .toList(),
      'payments': payments
          .map((pm) => {
                'id': pm.id,
                'studentId': pm.studentId,
                'amount': pm.amount,
                'month': pm.month,
                'isPaid': pm.isPaid,
                'paymentDate': pm.paymentDate?.toIso8601String(),
                'notes': pm.notes,
              })
          .toList(),
    };

    final jsonString = jsonEncode(backupData);
    final now = DateTime.now();
    final filename =
        'athar_backup_${now.year}_${now.month.toString().padLeft(2, '0')}_${now.day.toString().padLeft(2, '0')}.athar';

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');
    await file.writeAsString(jsonString, flush: true);
    return file;
  }

  /// Shares the backup file to Google Drive, WhatsApp, Files, etc.
  static Future<void> shareBackup(AppDatabase db) async {
    final file = await exportBackup(db);
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'نسخة احتياطية لتطبيق أثر - حفظ ومزامنة البيانات السحابية',
      subject: 'نسخة احتياطية لتطبيق أثر',
    );
  }

  /// Restores data from a user-selected backup file
  static Future<BackupRestoreResult?> restoreFromFile(AppDatabase db) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result == null || result.files.isEmpty || result.files.single.path == null) {
      return null;
    }

    final filePath = result.files.single.path!;
    final file = File(filePath);
    final jsonString = await file.readAsString();
    return restoreFromJson(db, jsonString);
  }

  /// Restores database records from JSON string
  static Future<BackupRestoreResult> restoreFromJson(
      AppDatabase db, String jsonString) async {
    final Map<String, dynamic> data = jsonDecode(jsonString);

    // 1. Teachers
    final teachersList = (data['teachers'] as List? ?? []);
    for (final t in teachersList) {
      await db.into(db.teachersTable).insertOnConflictUpdate(
            TeachersTableCompanion.insert(
              id: t['id'] as String,
              fullName: (t['fullName'] ?? t['name'] ?? 'معلم') as String,
              phoneNumber: (t['phoneNumber'] ?? t['phone'] ?? '') as String,
              loginCode: (t['loginCode'] ?? 'T101') as String,
              isActive: Value(t['isActive'] as bool? ?? true),
              studentCount: Value(t['studentCount'] as int? ?? 0),
            ),
          );
    }

    // 2. Students
    final studentsList = (data['students'] as List? ?? []);
    for (final s in studentsList) {
      await db.into(db.studentsTable).insertOnConflictUpdate(
            StudentsTableCompanion.insert(
              id: s['id'] as String,
              name: s['name'] as String,
              parentName: s['parentName'] as String,
              parentPhone: s['parentPhone'] as String,
              loginCode: s['loginCode'] as String,
              teacherId: Value(s['teacherId'] as String?),
              points: Value(s['points'] as int? ?? 0),
              stars: Value(s['stars'] as int? ?? 0),
              achievementLevel:
                  Value(s['achievementLevel'] as String? ?? 'مبتدئ'),
              monthlySubscription:
                  Value(s['monthlySubscription'] as int? ?? 60),
            ),
          );
    }

    // 3. Attendance
    final attendanceList = (data['attendance'] as List? ?? []);
    for (final a in attendanceList) {
      await db.into(db.attendanceTable).insertOnConflictUpdate(
            AttendanceTableCompanion.insert(
              id: a['id'] as String,
              studentId: a['studentId'] as String,
              date: DateTime.parse(a['date'] as String),
              isAbsent: Value(a['isAbsent'] as bool? ?? false),
            ),
          );
    }

    // 4. Daily Records
    final recordsList = (data['dailyRecords'] as List? ?? []);
    for (final r in recordsList) {
      await db.into(db.dailyRecordsTable).insertOnConflictUpdate(
            DailyRecordsTableCompanion.insert(
              id: r['id'] as String,
              studentId: r['studentId'] as String,
              date: DateTime.parse(r['date'] as String),
              memorizationGrade: r['memorizationGrade'] as String,
              memorizationMethod: r['memorizationMethod'] as String,
              memorizationData: r['memorizationData'] as String,
              revisionGrade: r['revisionGrade'] as String,
              revisionMethod: r['revisionMethod'] as String,
              revisionData: r['revisionData'] as String,
              teacherNotes: Value(r['teacherNotes'] as String?),
            ),
          );
    }

    // 5. Tomorrow Plans
    final tomorrowList = (data['tomorrowPlans'] as List? ?? []);
    for (final p in tomorrowList) {
      await db.into(db.tomorrowMemorizationTable).insertOnConflictUpdate(
            TomorrowMemorizationTableCompanion.insert(
              studentId: p['studentId'] as String,
              memorizationMethod: p['memorizationMethod'] as String,
              memorizationData: p['memorizationData'] as String,
              revisionMethod: p['revisionMethod'] as String,
              revisionData: p['revisionData'] as String,
              notes: Value(p['notes'] as String?),
            ),
          );
    }

    // 6. Plans
    final plansList = (data['plans'] as List? ?? []);
    for (final m in plansList) {
      await db.into(db.plansTable).insertOnConflictUpdate(
            PlansTableCompanion.insert(
              studentId: m['studentId'] as String,
              startSurah: m['startSurah'] as int? ?? 1,
              startVerse: m['startVerse'] as int? ?? 1,
              endSurah: m['endSurah'] as int? ?? 114,
              endVerse: m['endVerse'] as int? ?? 6,
              notes: Value(m['notes'] as String?),
            ),
          );
    }

    // 7. Schedules
    final schedulesList = (data['schedules'] as List? ?? []);
    for (final sc in schedulesList) {
      await db.into(db.schedulesTable).insertOnConflictUpdate(
            SchedulesTableCompanion.insert(
              studentId: sc['studentId'] as String,
              lessonsJson: sc['lessonsJson'] as String? ?? '{}',
              lastModified: DateTime.parse(sc['lastModified'] as String),
              modificationHistoryJson:
                  Value(sc['modificationHistoryJson'] as String?),
            ),
          );
    }

    // 8. Reminders
    final remindersList = (data['reminders'] as List? ?? []);
    for (final rm in remindersList) {
      await db.into(db.remindersTable).insertOnConflictUpdate(
            RemindersTableCompanion.insert(
              id: rm['id'] as String,
              studentId: Value(rm['studentId'] as String?),
              title: rm['title'] as String,
              content: rm['content'] as String,
              createdAt: DateTime.parse(rm['createdAt'] as String),
            ),
          );
    }

    // 9. Payments
    final paymentsList = (data['payments'] as List? ?? []);
    for (final pm in paymentsList) {
      await db.into(db.paymentsTable).insertOnConflictUpdate(
            PaymentsTableCompanion.insert(
              id: pm['id'] as String,
              studentId: pm['studentId'] as String,
              amount: (pm['amount'] as num).toDouble(),
              month: pm['month'] as String,
              isPaid: Value(pm['isPaid'] as bool? ?? true),
              paymentDate: pm['paymentDate'] != null
                  ? Value(DateTime.parse(pm['paymentDate'] as String))
                  : const Value.absent(),
              notes: Value(pm['notes'] as String?),
            ),
          );
    }

    return BackupRestoreResult(
      teachersCount: teachersList.length,
      studentsCount: studentsList.length,
      recordsCount: recordsList.length,
      paymentsCount: paymentsList.length,
      attendanceCount: attendanceList.length,
    );
  }
}
