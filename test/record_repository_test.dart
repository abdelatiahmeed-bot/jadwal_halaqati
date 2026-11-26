import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:athar/core/database/app_database.dart';
import 'package:athar/core/models/models.dart';
import 'package:athar/features/student/data/record_repository_impl.dart';

void main() {
  late AppDatabase database;
  late RecordRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = RecordRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('RecordRepository Tests', () {
    test('saveAttendance and getAttendance logs correctly', () async {
      final now = DateTime.now();
      final att = Attendance(
        id: 'A1',
        studentId: 'ST1',
        date: now,
        isAbsent: false,
        arrivalTime: now,
        departureTime: now,
      );

      await repository.saveAttendance(att);
      final fetched = await repository.getAttendance('ST1', now);

      expect(fetched, isNotNull);
      expect(fetched!.studentId, 'ST1');
      expect(fetched.isAbsent, isFalse);
    });

    test('copyTodayToTomorrow duplicates record inputs into tomorrow plan', () async {
      final today = DateTime.now();
      final record = DailyRecord(
        id: 'R1',
        studentId: 'ST1',
        date: today,
        memorizationMethod: 'surah',
        memorizationData: '{"surahId":2,"startVerse":1,"endVerse":5}',
        memorizationGrade: 'excellent',
        revisionMethod: 'surah',
        revisionData: '{"surahId":1,"startVerse":1,"endVerse":7}',
        revisionGrade: 'excellent',
        teacherNotes: 'ممتاز',
        encouragementMessage: 'بطل',
      );

      await repository.saveDailyRecord(record);
      await repository.copyTodayToTomorrow('ST1', today);

      final plan = await repository.getTomorrowPlan('ST1');
      expect(plan, isNotNull);
      expect(plan!.memorizationMethod, 'surah');
      expect(plan.memorizationData, '{"surahId":2,"startVerse":1,"endVerse":5}');
      expect(plan.notes, 'ممتاز');
      expect(plan.encouragementMessage, 'بطل');
    });

    test('runMidnightTransfer successfully copies tomorrow plan to daily record', () async {
      const plan = TomorrowPlan(
        studentId: 'ST1',
        memorizationMethod: 'surah',
        memorizationData: '{"surahId":100}',
        revisionMethod: 'range',
        revisionData: '{"start":1}',
        notes: 'ملاحظة',
        encouragementMessage: 'تحفيز',
      );

      await repository.saveTomorrowPlan(plan);

      final tomorrow = DateTime.now().add(const Duration(days: 1));
      await repository.runMidnightTransfer('ST1', tomorrow);

      final record = await repository.getDailyRecord('ST1', tomorrow);
      expect(record, isNotNull);
      expect(record!.memorizationMethod, 'surah');
      expect(record.memorizationData, '{"surahId":100}');
      expect(record.memorizationGrade, 'postponed');
      expect(record.teacherNotes, 'ملاحظة');
      expect(record.encouragementMessage, 'تحفيز');
    });
   group('Drift Table Mappings', () {
      test('saveParentSchedule and getParentSchedule works correctly', () async {
        await repository.saveParentSchedule('ST1', 'schedule_data_json');
        final schedule = await repository.getParentSchedule('ST1');
        expect(schedule, isNotNull);
        expect(schedule!.lessonsJson, 'schedule_data_json');
      });
    });
  });
}
