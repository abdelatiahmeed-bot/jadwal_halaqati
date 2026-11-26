
class Teacher {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String loginCode;
  final bool isActive;
  final int studentCount;

  const Teacher({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.loginCode,
    this.isActive = true,
    this.studentCount = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'loginCode': loginCode,
        'isActive': isActive,
        'studentCount': studentCount,
      };

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        phoneNumber: json['phoneNumber'] as String,
        loginCode: json['loginCode'] as String,
        isActive: json['isActive'] as bool? ?? true,
        studentCount: json['studentCount'] as int? ?? 0,
      );
}

class Student {
  final String id;
  final String name;
  final String parentName;
  final String parentPhone;
  final String loginCode;
  final String? teacherId;
  final int points;
  final int stars;
  final String achievementLevel;
  final int monthlySubscription;

  const Student({
    required this.id,
    required this.name,
    required this.parentName,
    required this.parentPhone,
    required this.loginCode,
    this.teacherId,
    this.points = 0,
    this.stars = 0,
    this.achievementLevel = 'مبتدئ',
    this.monthlySubscription = 60,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'parentName': parentName,
        'parentPhone': parentPhone,
        'loginCode': loginCode,
        'teacherId': teacherId,
        'points': points,
        'stars': stars,
        'achievementLevel': achievementLevel,
        'monthlySubscription': monthlySubscription,
      };

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json['id'] as String,
        name: json['name'] as String,
        parentName: json['parentName'] as String,
        parentPhone: json['parentPhone'] as String,
        loginCode: json['loginCode'] as String,
        teacherId: json['teacherId'] as String?,
        points: json['points'] as int? ?? 0,
        stars: json['stars'] as int? ?? 0,
        achievementLevel: json['achievementLevel'] as String? ?? 'مبتدئ',
        monthlySubscription: json['monthlySubscription'] as int? ?? 60,
      );
}

class Attendance {
  final String id;
  final String studentId;
  final DateTime date;
  final bool isAbsent;
  final DateTime? arrivalTime;
  final DateTime? departureTime;

  const Attendance({
    required this.id,
    required this.studentId,
    required this.date,
    this.isAbsent = false,
    this.arrivalTime,
    this.departureTime,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'date': date.toIso8601String(),
        'isAbsent': isAbsent,
        'arrivalTime': arrivalTime?.toIso8601String(),
        'departureTime': departureTime?.toIso8601String(),
      };

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        id: json['id'] as String,
        studentId: json['studentId'] as String,
        date: DateTime.parse(json['date'] as String),
        isAbsent: json['isAbsent'] as bool? ?? false,
        arrivalTime: json['arrivalTime'] != null ? DateTime.parse(json['arrivalTime'] as String) : null,
        departureTime: json['departureTime'] != null ? DateTime.parse(json['departureTime'] as String) : null,
      );
}

class DailyRecord {
  final String id;
  final String studentId;
  final DateTime date;
  
  // Memorization
  final String memorizationMethod; // 'surah', 'range', 'juz', 'multi_surah'
  final String memorizationData; // JSON
  final String memorizationGrade; // 'excellent', 'very_good', etc.
  
  // Revision
  final String revisionMethod;
  final String revisionData; // JSON
  final String revisionGrade;
  
  final String? teacherNotes;
  final String? encouragementMessage;

  const DailyRecord({
    required this.id,
    required this.studentId,
    required this.date,
    required this.memorizationMethod,
    required this.memorizationData,
    required this.memorizationGrade,
    required this.revisionMethod,
    required this.revisionData,
    required this.revisionGrade,
    this.teacherNotes,
    this.encouragementMessage,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'date': date.toIso8601String(),
        'memorizationMethod': memorizationMethod,
        'memorizationData': memorizationData,
        'memorizationGrade': memorizationGrade,
        'revisionMethod': revisionMethod,
        'revisionData': revisionData,
        'revisionGrade': revisionGrade,
        'teacherNotes': teacherNotes,
        'encouragementMessage': encouragementMessage,
      };

  factory DailyRecord.fromJson(Map<String, dynamic> json) => DailyRecord(
        id: json['id'] as String,
        studentId: json['studentId'] as String,
        date: DateTime.parse(json['date'] as String),
        memorizationMethod: json['memorizationMethod'] as String,
        memorizationData: json['memorizationData'] as String,
        memorizationGrade: json['memorizationGrade'] as String,
        revisionMethod: json['revisionMethod'] as String,
        revisionData: json['revisionData'] as String,
        revisionGrade: json['revisionGrade'] as String,
        teacherNotes: json['teacherNotes'] as String?,
        encouragementMessage: json['encouragementMessage'] as String?,
      );
}

class TomorrowPlan {
  final String studentId;
  final String memorizationMethod;
  final String memorizationData;
  final String revisionMethod;
  final String revisionData;
  final String? notes;
  final String? encouragementMessage;

  const TomorrowPlan({
    required this.studentId,
    required this.memorizationMethod,
    required this.memorizationData,
    required this.revisionMethod,
    required this.revisionData,
    this.notes,
    this.encouragementMessage,
  });

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'memorizationMethod': memorizationMethod,
        'memorizationData': memorizationData,
        'revisionMethod': revisionMethod,
        'revisionData': revisionData,
        'notes': notes,
        'encouragementMessage': encouragementMessage,
      };

  factory TomorrowPlan.fromJson(Map<String, dynamic> json) => TomorrowPlan(
        studentId: json['studentId'] as String,
        memorizationMethod: json['memorizationMethod'] as String,
        memorizationData: json['memorizationData'] as String,
        revisionMethod: json['revisionMethod'] as String,
        revisionData: json['revisionData'] as String,
        notes: json['notes'] as String?,
        encouragementMessage: json['encouragementMessage'] as String?,
      );
}

class MemorizationPlan {
  final String studentId;
  final int attendanceDaysPerWeek;
  final int dailyLinesCount;
  final int direction; // 0: Forward, 1: Reverse
  final int startSurah;
  final int startVerse;
  final int endSurah;
  final int endVerse;
  final String? notes;

  const MemorizationPlan({
    required this.studentId,
    this.attendanceDaysPerWeek = 5,
    this.dailyLinesCount = 15,
    this.direction = 0,
    required this.startSurah,
    required this.startVerse,
    required this.endSurah,
    required this.endVerse,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'attendanceDaysPerWeek': attendanceDaysPerWeek,
        'dailyLinesCount': dailyLinesCount,
        'direction': direction,
        'startSurah': startSurah,
        'startVerse': startVerse,
        'endSurah': endSurah,
        'endVerse': endVerse,
        'notes': notes,
      };

  factory MemorizationPlan.fromJson(Map<String, dynamic> json) => MemorizationPlan(
        studentId: json['studentId'] as String,
        attendanceDaysPerWeek: json['attendanceDaysPerWeek'] as int? ?? 5,
        dailyLinesCount: json['dailyLinesCount'] as int? ?? 15,
        direction: json['direction'] as int? ?? 0,
        startSurah: json['startSurah'] as int,
        startVerse: json['startVerse'] as int,
        endSurah: json['endSurah'] as int,
        endVerse: json['endVerse'] as int,
        notes: json['notes'] as String?,
      );
}

class ParentSchedule {
  final String studentId;
  final String lessonsJson;
  final DateTime lastModified;
  final String? modificationHistoryJson;

  const ParentSchedule({
    required this.studentId,
    required this.lessonsJson,
    required this.lastModified,
    this.modificationHistoryJson,
  });
}

class Quiz {
  final String id;
  final String teacherId;
  final String title;
  final String? description;
  final String questionsJson;
  final DateTime createdAt;

  const Quiz({
    required this.id,
    required this.teacherId,
    required this.title,
    this.description,
    required this.questionsJson,
    required this.createdAt,
  });
}

class QuizAnswer {
  final String id;
  final String quizId;
  final String studentId;
  final int score;
  final String answersJson;
  final DateTime completedAt;

  const QuizAnswer({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.score,
    required this.answersJson,
    required this.completedAt,
  });
}

class Payment {
  final String id;
  final String studentId;
  final double amount;
  final String month;
  final bool isPaid;
  final DateTime? paymentDate;
  final String? notes;

  const Payment({
    required this.id,
    required this.studentId,
    required this.amount,
    required this.month,
    required this.isPaid,
    this.paymentDate,
    this.notes,
  });
}

class HonorBoardEntry {
  final String id;
  final String teacherId;
  final String studentId;
  final String studentName;
  final String achievement;
  final String honorMessage;
  final DateTime weekDate;

  const HonorBoardEntry({
    required this.id,
    required this.teacherId,
    required this.studentId,
    required this.studentName,
    required this.achievement,
    required this.honorMessage,
    required this.weekDate,
  });
}

class Announcement {
  final String id;
  final String teacherId;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? expiryDate;

  const Announcement({
    required this.id,
    required this.teacherId,
    required this.title,
    required this.content,
    required this.createdAt,
    this.expiryDate,
  });
}

class Reminder {
  final String id;
  final String? studentId; // Nullable if for all students
  final String title;
  final String content;
  final DateTime createdAt;

  const Reminder({
    required this.id,
    this.studentId,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        id: json['id'] as String,
        studentId: json['studentId'] as String?,
        title: json['title'] as String,
        content: json['content'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

