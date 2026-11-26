import 'dart:convert';

class LessonItem {
  final String subject;
  final String time;

  const LessonItem({
    required this.subject,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
        'subject': subject,
        'time': time,
      };

  factory LessonItem.fromJson(Map<String, dynamic> json) {
    return LessonItem(
      subject: json['subject']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
    );
  }
}

class DaySchedule {
  bool hasQuran;
  String quranTime;
  List<LessonItem> lessons;
  String notes;

  DaySchedule({
    this.hasQuran = false,
    this.quranTime = '04:00 م',
    List<LessonItem>? lessons,
    this.notes = '',
  }) : lessons = lessons ?? [];

  Map<String, dynamic> toJson() => {
        'hasQuran': hasQuran,
        'quranTime': quranTime,
        'lessons': lessons.map((e) => e.toJson()).toList(),
        'notes': notes,
      };

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    final rawLessons = json['lessons'];
    final List<LessonItem> parsedLessons = [];
    if (rawLessons is List) {
      for (final item in rawLessons) {
        if (item is Map<String, dynamic>) {
          parsedLessons.add(LessonItem.fromJson(item));
        }
      }
    }
    return DaySchedule(
      hasQuran: json['hasQuran'] == true,
      quranTime: json['quranTime']?.toString() ??
          json['time']?.toString() ??
          '04:00 م',
      lessons: parsedLessons,
      notes: json['notes']?.toString() ?? '',
    );
  }
}

class StudentWeeklySchedule {
  static const List<String> weekDays = [
    'السبت',
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
  ];

  final Map<String, DaySchedule> days;

  StudentWeeklySchedule({Map<String, DaySchedule>? days})
      : days = days ?? {for (final d in weekDays) d: DaySchedule()};

  static String weekdayName(DateTime date) {
    switch (date.weekday) {
      case DateTime.saturday:
        return 'السبت';
      case DateTime.sunday:
        return 'الأحد';
      case DateTime.monday:
        return 'الإثنين';
      case DateTime.tuesday:
        return 'الثلاثاء';
      case DateTime.wednesday:
        return 'الأربعاء';
      case DateTime.thursday:
        return 'الخميس';
      case DateTime.friday:
        return 'الجمعة';
      default:
        return 'السبت';
    }
  }

  DaySchedule forDate(DateTime date) {
    final name = weekdayName(date);
    return days[name] ?? DaySchedule();
  }

  int get quranDaysCount =>
      days.values.where((d) => d.hasQuran).length;

  factory StudentWeeklySchedule.fromJsonString(String? jsonStr) {
    final Map<String, DaySchedule> map = {
      for (final d in weekDays) d: DaySchedule(),
    };
    if (jsonStr == null || jsonStr.trim().isEmpty) {
      return StudentWeeklySchedule(days: map);
    }
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is Map<String, dynamic>) {
        for (final d in weekDays) {
          final dayJson = decoded[d];
          if (dayJson is Map<String, dynamic>) {
            map[d] = DaySchedule.fromJson(dayJson);
          }
        }
      }
    } catch (_) {}
    return StudentWeeklySchedule(days: map);
  }

  String toJsonString() {
    final Map<String, dynamic> map = {};
    for (final d in weekDays) {
      map[d] = (days[d] ?? DaySchedule()).toJson();
    }
    return jsonEncode(map);
  }
}
