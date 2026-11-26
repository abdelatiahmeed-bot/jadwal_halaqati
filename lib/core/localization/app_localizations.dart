import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppTranslations {
  static const Map<String, Map<String, String>> _values = {
    'ar': {
      'app_title': 'أثر - منصة إدارة تحفيظ القرآن',
      'role_selection': 'بوابة الدخول',
      'parent': 'ولي أمر الطالب',
      'teacher': 'معلم الحلقة (المحفظ)',
      'admin': 'إدارة المركز',
      'welcome': 'مرحباً بك',
      'logout': 'تسجيل الخروج',
      
      // Admin Dashboard
      'admin_dashboard': 'لوحة الإدارة',
      'total_teachers': 'إجمالي المعلمين',
      'total_students': 'إجمالي الطلاب',
      'active_students': 'الطلاب النشطون',
      'daily_attendance': 'حضور اليوم',
      'weekly_stats': 'إحصائيات الأسبوع',
      'monthly_stats': 'إحصائيات الشهر',
      'revenue_summary': 'ملخص الإيرادات',
      'collection_stats': 'نسبة التحصيل',
      
      // Teacher Management
      'teachers_management': 'إدارة المعلمين',
      'add_teacher': 'إضافة معلم',
      'edit_teacher': 'تعديل المعلم',
      'delete_teacher': 'حذف المعلم',
      'disable_teacher': 'تعطيل الحساب',
      'transfer_students': 'نقل الطلاب بين الحلقات',
      'teacher_name': 'اسم المعلم',
      'phone_number': 'رقم الهاتف',
      'login_code': 'رمز الدخول',
      'active_status': 'حالة الحساب',
      'student_count': 'عدد الطلاب',
      
      // Auth & Login
      'select_teacher': 'اختر اسمك كمعلم',
      'enter_teacher_code': 'أدخل الرمز السري للمعلم',
      'enter_student_code': 'أدخل رمز الطالب السري',
      'login_button': 'تسجيل الدخول',
      'invalid_credentials': 'رمز الدخول غير صحيح',
      
      // Teacher Dashboard
      'teacher_dashboard': 'لوحة المعلم',
      'students_tab': 'الطلاب',
      'add_student_tab': 'إضافة طالب',
      'absence_tab': 'الغياب وحضور اليوم',
      'announcements_tab': 'الإعلانات',
      'quizzes_tab': 'الآداب والاختبارات',
      'collections_tab': 'الاشتراكات والتحصيل',
      'statistics_tab': 'الإحصائيات',
      
      // Students List Status
      'heard_today': 'تسميع اليوم',
      'absent': 'غائب',
      'record_incomplete': 'السجل غير مكتمل',
      'search_students': 'البحث عن طالب...',
      
      // Student Fields
      'student_name': 'اسم الطالب',
      'parent_name': 'اسم ولي الأمر',
      'parent_phone': 'رقم ولي الأمر',
      'student_login_code': 'رمز دخول الطالب',
      
      // Absence System
      'auto_absence': 'تسجيل الغياب التلقائي (10 مساءً)',
      'manual_attendance': 'تحضير يدوي',
      'daily_attendance_analytics': 'تحليل الحضور اليومي',
      
      // Quizzes
      'create_quiz': 'إنشاء اختبار جديد',
      'quiz_title': 'عنوان الاختبار',
      'quiz_description': 'وصف الاختبار (اختياري)',
      'add_question': 'إضافة سؤال',
      'question_text': 'نص السؤال',
      'options': 'الخيارات',
      'correct_answer': 'الإجابة الصحيحة',
      'scores_history': 'سجل الدرجات ومشاركة أولياء الأمور',
      
      // Collections
      'confirm_payment': 'تأكيد الدفع',
      'bulk_reminders': 'تذكير جماعي (إشعارات)',
      'whatsapp_reminders': 'تذكير جماعي (واتساب)',
      'paid': 'مدفوع',
      'unpaid': 'غير مدفوع',
      'payment_date': 'تاريخ الدفع',
      'amount': 'المبلغ',
      'month': 'الشهر',
      
      // Student Profile
      'daily_record': 'اليومية والتسميع',
      'tomorrow_memorization': 'خطة الغد',
      'daily_archive': 'السجل التاريخي',
      'monthly_harvest': 'الحصاد الشهري',
      'memorization_plan': 'الخطة العامة',
      'schedule': 'جدول الطالب',
      
      // Progress Record Details
      'arrival_time': 'وقت الحضور',
      'departure_time': 'وقت الانصراف',
      'new_memorization': 'الحفظ الجديد',
      'revision': 'المراجعة',
      'teacher_notes': 'ملاحظات المعلم',
      'encouragement_message': 'رسالة تشجيعية للتحفيز',
      'tomorrow_plan': 'خطة الحفظ والمراجعة للغد',
      'copy_today_to_tomorrow': 'نسخ خطة اليوم إلى الغد',
      
      // Quran Engine Methods
      'method_surah': 'طريقة السورة',
      'method_range': 'طريقة النطاق',
      'method_juz': 'طريقة الجزء',
      'method_multisurah': 'سورة متعددة عشوائية',
      'select_surah': 'اختر السورة',
      'from_verse': 'من آية',
      'to_verse': 'إلى آية',
      'select_juz': 'اختر الجزء',
      
      // Grades
      'grade_excellent': 'ممتاز (أ)',
      'grade_verygood': 'جيد جداً (ب)',
      'grade_good': 'جيد (ج)',
      'grade_notmemorized': 'لم يحفظ',
      'grade_postponed': 'مؤجل',
      
      // General Plan
      'days_per_week': 'أيام الحضور أسبوعياً',
      'daily_lines': 'عدد الأسطر اليومية',
      'direction_forward': 'من البقرة إلى الناس (تصاعدي)',
      'direction_reverse': 'من الناس إلى البقرة (تنازلي)',
      'estimated_completion': 'تاريخ الإنجاز المتوقع',
      'weekly_progress': 'التقدم الأسبوعي',
      'monthly_progress': 'التقدم الشهري',
      
      // Rewards & Badges
      'points': 'النقاط',
      'stars': 'النجوم',
      'achievement_level': 'مستوى الإنجاز',
      'badges_collection': 'مجموعة الأوسمة الحاصل عليها',
      
      // Honor Board
      'honor_board': 'لوحة الشرف الأسبوعية',
      'honor_nomination': 'ترشيح طالب للوحة الشرف',
      'honor_message': 'رسالة الشرف والتهنئة',
      
      // Parent Dashboard
      'parent_dashboard': 'لوحة ولي الأمر',
      'welcome_parent': 'أهلاً بك ولي أمر الطالب:',
      'teacher_report_tab': 'تقرير المعلم اليومي',
      'tomorrow_prep_tab': 'التحضير للغد',
      'badges_tab': 'الجوائز والأوسمة',
      'honor_tab': 'لوحة الشرف الأسبوعية',
      'financial_tab': 'الوضع المالي',
    },
    'en': {
      'app_title': 'ATHAR - Quran Memorization Platform',
      'role_selection': 'Entry Portal',
      'parent': 'Parent Login',
      'teacher': 'Teacher (Muhafiz) Login',
      'admin': 'Administration Portal',
      'welcome': 'Welcome',
      'logout': 'Logout',
      
      // Admin Dashboard
      'admin_dashboard': 'Admin Dashboard',
      'total_teachers': 'Total Teachers',
      'total_students': 'Total Students',
      'active_students': 'Active Students',
      'daily_attendance': 'Today\'s Attendance',
      'weekly_stats': 'Weekly Stats',
      'monthly_stats': 'Monthly Stats',
      'revenue_summary': 'Revenue Summary',
      'collection_stats': 'Collection Rate',
      
      // Teacher Management
      'teachers_management': 'Teachers Management',
      'add_teacher': 'Add Teacher',
      'edit_teacher': 'Edit Teacher',
      'delete_teacher': 'Delete Teacher',
      'disable_teacher': 'Disable Account',
      'transfer_students': 'Transfer Students',
      'teacher_name': 'Teacher Name',
      'phone_number': 'Phone Number',
      'login_code': 'Login Code',
      'active_status': 'Status',
      'student_count': 'Student Count',
      
      // Auth & Login
      'select_teacher': 'Select Teacher',
      'enter_teacher_code': 'Enter Teacher Secret Code',
      'enter_student_code': 'Enter Student Access Code',
      'login_button': 'Login',
      'invalid_credentials': 'Invalid Login Code',
      
      // Teacher Dashboard
      'teacher_dashboard': 'Teacher Dashboard',
      'students_tab': 'Students',
      'add_student_tab': 'Add Student',
      'absence_tab': 'Absence & Attendance',
      'announcements_tab': 'Announcements',
      'quizzes_tab': 'Islamic Quizzes',
      'collections_tab': 'Collections',
      'statistics_tab': 'Statistics',
      
      // Students List Status
      'heard_today': 'Recited Today',
      'absent': 'Absent',
      'record_incomplete': 'Record Incomplete',
      'search_students': 'Search students...',
      
      // Student Fields
      'student_name': 'Student Name',
      'parent_name': 'Parent Name',
      'parent_phone': 'Parent Phone',
      'student_login_code': 'Student Access Code',
      
      // Absence System
      'auto_absence': 'Auto Absence Registration (10 PM)',
      'manual_attendance': 'Manual Attendance',
      'daily_attendance_analytics': 'Attendance Analytics',
      
      // Quizzes
      'create_quiz': 'Create New Quiz',
      'quiz_title': 'Quiz Title',
      'quiz_description': 'Quiz Description (Optional)',
      'add_question': 'Add Question',
      'question_text': 'Question Text',
      'options': 'Options',
      'correct_answer': 'Correct Answer',
      'scores_history': 'Score History',
      
      // Collections
      'confirm_payment': 'Confirm Payment',
      'bulk_reminders': 'Bulk Push Reminders',
      'whatsapp_reminders': 'Bulk WhatsApp Reminders',
      'paid': 'Paid',
      'unpaid': 'Unpaid',
      'payment_date': 'Payment Date',
      'amount': 'Amount',
      'month': 'Month',
      
      // Student Profile
      'daily_record': 'Daily Progress',
      'tomorrow_memorization': 'Tomorrow Plan',
      'daily_archive': 'History Log',
      'monthly_harvest': 'Monthly Harvest',
      'memorization_plan': 'General Plan',
      'schedule': 'Student Schedule',
      
      // Progress Record Details
      'arrival_time': 'Arrival Time',
      'departure_time': 'Departure Time',
      'new_memorization': 'New Memorization',
      'revision': 'Revision',
      'teacher_notes': 'Teacher Notes',
      'encouragement_message': 'Encouragement Message',
      'tomorrow_plan': 'Tomorrow Memorization & Revision Plan',
      'copy_today_to_tomorrow': 'Copy Today\'s Plan to Tomorrow',
      
      // Quran Engine Methods
      'method_surah': 'Surah Method',
      'method_range': 'Range Method',
      'method_juz': 'Juz Method',
      'method_multisurah': 'Multi-Surah Method',
      'select_surah': 'Select Surah',
      'from_verse': 'From Verse',
      'to_verse': 'To Verse',
      'select_juz': 'Select Juz',
      
      // Grades
      'grade_excellent': 'Excellent (A)',
      'grade_verygood': 'Very Good (B)',
      'grade_good': 'Good (C)',
      'grade_notmemorized': 'Not Memorized',
      'grade_postponed': 'Postponed',
      
      // General Plan
      'days_per_week': 'Days per Week',
      'daily_lines': 'Lines per Day',
      'direction_forward': 'Al-Baqarah -> An-Nas (Forward)',
      'direction_reverse': 'An-Nas -> Al-Baqarah (Reverse)',
      'estimated_completion': 'Estimated Completion',
      'weekly_progress': 'Weekly Progress',
      'monthly_progress': 'Monthly Progress',
      
      // Rewards & Badges
      'points': 'Points',
      'stars': 'Stars',
      'achievement_level': 'Level',
      'badges_collection': 'Badges Collection',
      
      // Honor Board
      'honor_board': 'Weekly Honor Board',
      'honor_nomination': 'Nominate to Honor Board',
      'honor_message': 'Honor Message',
      
      // Parent Dashboard
      'parent_dashboard': 'Parent Dashboard',
      'welcome_parent': 'Welcome Parent of:',
      'teacher_report_tab': 'Today\'s Performance',
      'tomorrow_prep_tab': 'Tomorrow\'s Prep',
      'badges_tab': 'Rewards & Badges',
      'honor_tab': 'Honor Board',
      'financial_tab': 'Financial Status',
    }
  };

  final String langCode;

  AppTranslations(this.langCode);

  String translate(String key) {
    return _values[langCode]?[key] ?? key;
  }
}

// Localization State Provider
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ar'));

  void toggleLanguage() {
    if (state.languageCode == 'ar') {
      state = const Locale('en');
    } else {
      state = const Locale('ar');
    }
  }

  void setLanguage(String code) {
    state = Locale(code);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

final translationsProvider = Provider<AppTranslations>((ref) {
  final locale = ref.watch(localeProvider);
  return AppTranslations(locale.languageCode);
});
