import 'package:drift/drift.dart';
import 'connection.dart' as c;

part 'app_database.g.dart';

// Teachers Table
class TeachersTable extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get phoneNumber => text()();
  TextColumn get loginCode => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get studentCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// Students Table
class StudentsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get parentName => text()();
  TextColumn get parentPhone => text()();
  TextColumn get loginCode => text()();
  TextColumn get teacherId => text().nullable()();
  IntColumn get points => integer().withDefault(const Constant(0))();
  IntColumn get stars => integer().withDefault(const Constant(0))();
  TextColumn get achievementLevel => text().withDefault(const Constant('Novice'))();
  DateTimeColumn get lastProgressSync => dateTime().nullable()();
  IntColumn get monthlySubscription => integer().withDefault(const Constant(60))();

  @override
  Set<Column> get primaryKey => {id};
}

// Attendance Table
class AttendanceTable extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isAbsent => boolean().withDefault(const Constant(false))();
  DateTimeColumn get arrivalTime => dateTime().nullable()();
  DateTimeColumn get departureTime => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Daily Records Table (Memorization & Revision Status)
class DailyRecordsTable extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  DateTimeColumn get date => dateTime()();
  
  // Memorization
  TextColumn get memorizationMethod => text()(); // 'surah', 'range', 'juz', 'multi_surah'
  TextColumn get memorizationData => text()(); // JSON representation of selected method (e.g. ranges, surah id, from/to verses)
  TextColumn get memorizationGrade => text()(); // 'excellent', 'very_good', 'good', 'not_memorized', 'postponed'
  
  // Revision
  TextColumn get revisionMethod => text()();
  TextColumn get revisionData => text()(); // JSON representation
  TextColumn get revisionGrade => text()();
  
  TextColumn get teacherNotes => text().nullable()();
  TextColumn get encouragementMessage => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Tomorrow Memorization Table (Matches daily record format, no attendance or grades)
class TomorrowMemorizationTable extends Table {
  TextColumn get studentId => text()();
  TextColumn get memorizationMethod => text()();
  TextColumn get memorizationData => text()();
  TextColumn get revisionMethod => text()();
  TextColumn get revisionData => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get encouragementMessage => text().nullable()();

  @override
  Set<Column> get primaryKey => {studentId};
}

// Memorization Plan Table
class PlansTable extends Table {
  TextColumn get studentId => text()();
  IntColumn get attendanceDaysPerWeek => integer().withDefault(const Constant(5))();
  IntColumn get dailyLinesCount => integer().withDefault(const Constant(15))();
  IntColumn get direction => integer().withDefault(const Constant(0))(); // 0: Forward, 1: Reverse
  IntColumn get startSurah => integer()();
  IntColumn get startVerse => integer()();
  IntColumn get endSurah => integer()();
  IntColumn get endVerse => integer()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {studentId};
}

// Schedule Table (Parent edits, teacher views)
class SchedulesTable extends Table {
  TextColumn get studentId => text()();
  TextColumn get lessonsJson => text()(); // School schedule and lessons details
  DateTimeColumn get lastModified => dateTime()();
  TextColumn get modificationHistoryJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {studentId};
}

// Quizzes Table
class QuizzesTable extends Table {
  TextColumn get id => text()();
  TextColumn get teacherId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get questionsJson => text()(); // MCQ questions list JSON
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Quiz Answers Table
class QuizAnswersTable extends Table {
  TextColumn get id => text()();
  TextColumn get quizId => text()();
  TextColumn get studentId => text()();
  IntColumn get score => integer()();
  TextColumn get answersJson => text()(); // Selected answers list JSON
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Payments Table
class PaymentsTable extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  RealColumn get amount => real()();
  TextColumn get month => text()(); // e.g. "2026-06"
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
  DateTimeColumn get paymentDate => dateTime().nullable()();

  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Honor Board Table
class HonorBoardTable extends Table {
  TextColumn get id => text()();
  TextColumn get teacherId => text()();
  TextColumn get studentId => text()();
  TextColumn get studentName => text()();
  TextColumn get achievement => text()();
  TextColumn get honorMessage => text()();
  DateTimeColumn get weekDate => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Announcements Table
class AnnouncementsTable extends Table {
  TextColumn get id => text()();
  TextColumn get teacherId => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get expiryDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Reminders Table
class RemindersTable extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text().nullable()(); // If null, this is a global notification/reminder
  TextColumn get title => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Drift Database Manager
@DriftDatabase(tables: [
  TeachersTable,
  StudentsTable,
  AttendanceTable,
  DailyRecordsTable,
  TomorrowMemorizationTable,
  PlansTable,
  SchedulesTable,
  QuizzesTable,
  QuizAnswersTable,
  PaymentsTable,
  HonorBoardTable,
  AnnouncementsTable,
  RemindersTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? c.openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(announcementsTable, announcementsTable.expiryDate);
            await m.addColumn(paymentsTable, paymentsTable.notes);
          }
          if (from < 3) {
            await m.createTable(remindersTable);
          }
          if (from < 4) {
            await m.addColumn(studentsTable, studentsTable.monthlySubscription);
          }
        },
      );
}



