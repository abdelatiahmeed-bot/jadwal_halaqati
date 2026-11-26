import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:athar/core/models/models.dart';

class StudentReportStats {
  final Student student;
  final String attendanceStatus; // 'حاضر', 'غائب', 'قيد التسجيل'
  final String attendanceRate;
  final String monthlyNewMemorization;
  final String monthlyRevision;

  StudentReportStats({
    required this.student,
    required this.attendanceStatus,
    this.attendanceRate = '100%',
    this.monthlyNewMemorization = '-',
    this.monthlyRevision = '-',
  });
}

class ReportGenerator {
  /// Generates a PDF progress report for a student.
  static Future<File> generateStudentPdfReport(
      Student student, List<DailyRecord> records) async {
    final pdf = pw.Document();

    pw.Font? ttf;
    try {
      final fontData = await rootBundle.load('assets/fonts/tahoma.ttf');
      ttf = pw.Font.ttf(fontData);
    } catch (_) {}

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: ttf != null ? pw.ThemeData.withFont(base: ttf, bold: ttf) : null,
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(24),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Header(
                    level: 0,
                    child: pw.Text(
                      'أثر - تقرير تقدم الطالب في حلقة القرآن الكريم',
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.SizedBox(height: 14),
                  pw.Text('اسم الطالب: ${student.name}'),
                  pw.Text('اسم ولي الأمر: ${student.parentName}'),
                  pw.Text('هاتف ولي الأمر: ${student.parentPhone}'),
                  pw.Text('الاشتراك الشهري: ${student.monthlySubscription} ج.م'),
                  pw.SizedBox(height: 20),
                  pw.Text('سجل التسميع والحفظ الأخير:',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(),
                  pw.SizedBox(height: 8),
                  if (records.isEmpty)
                    pw.Text('لا توجد سجلات محفوظة لهذا الطالب بعد')
                  else
                    ...records.map((r) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 8),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                                'التاريخ: ${r.date.toIso8601String().substring(0, 10)} | التقدير: ${r.memorizationGrade}'),
                            pw.Text(
                                'طريقة التسميع: ${r.memorizationMethod} | الموضع: ${r.memorizationData}'),
                            if (r.teacherNotes != null &&
                                r.teacherNotes!.isNotEmpty)
                              pw.Text('ملاحظات المعلم: ${r.teacherNotes}'),
                            pw.Divider(thickness: 0.5),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          );
        },
      ),
    );

    final outputDir = await getTemporaryDirectory();
    final file = File('${outputDir.path}/progress_${student.id}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Generates a PDF attendance and grades report for the group/period with the new 7 columns layout.
  static Future<File> generateAttendanceReportPdf({
    required String periodTitle,
    required String attendanceRate,
    List<StudentReportStats>? studentStats,
    List<Student>? presentStudents,
    List<Student>? absentStudents,
    List<Student>? unrecordedStudents,
    required Map<String, int> gradesCount,
  }) async {
    final List<StudentReportStats> effectiveStats = studentStats ?? [
      ...?presentStudents?.map((s) => StudentReportStats(student: s, attendanceStatus: 'حاضر', attendanceRate: '100%')),
      ...?absentStudents?.map((s) => StudentReportStats(student: s, attendanceStatus: 'غائب', attendanceRate: '0%')),
      ...?unrecordedStudents?.map((s) => StudentReportStats(student: s, attendanceStatus: 'قيد التسجيل', attendanceRate: '-')),
    ];
    final pdf = pw.Document();

    pw.Font? ttf;
    try {
      final fontData = await rootBundle.load('assets/fonts/tahoma.ttf');
      ttf = pw.Font.ttf(fontData);
    } catch (_) {}

    final presentCount = effectiveStats.where((s) => s.attendanceStatus == 'حاضر').length;
    final absentCount = effectiveStats.where((s) => s.attendanceStatus == 'غائب').length;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape, // Landscape for wide tables
        theme: ttf != null ? pw.ThemeData.withFont(base: ttf, bold: ttf) : null,
        build: (pw.Context context) {
          return [
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  // Clean Header without strange symbols
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: const pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFF2B3724),
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'تطبيق أثر - تقرير الحلقة والإحصائيات الشاملة',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          periodTitle,
                          style: const pw.TextStyle(
                            color: PdfColor.fromInt(0xFFE5C05B),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 12),

                  // Summary Statistics
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                          color: const PdfColor.fromInt(0xFFC5A85A)),
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(6)),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                      children: [
                        pw.Text('نسبة الحضور العامة: $attendanceRate',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.green800)),
                        pw.Text('الحاضرون: $presentCount',
                            style: const pw.TextStyle(color: PdfColors.teal)),
                        pw.Text('الغائبون: $absentCount',
                            style: const pw.TextStyle(color: PdfColors.red800)),
                        pw.Text('إجمالي الطلاب: ${effectiveStats.length}'),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 14),

                  // Full 7-column Table from Right to Left
                  pw.TableHelper.fromTextArray(
                    headers: [
                      'م',
                      'اسم الطالب',
                      'رقم الهاتف',
                      'نسبة الحضور',
                      'إجمالي جديد الشهر حتى الآن',
                      'إجمالي المراجعة خلال الشهر حتى الآن',
                      'قيمة الاشتراك',
                    ],
                    data: List.generate(effectiveStats.length, (i) {
                      final item = effectiveStats[i];
                      return [
                        '${i + 1}',
                        item.student.name,
                        item.student.parentPhone.isNotEmpty
                            ? item.student.parentPhone
                            : '-',
                        item.attendanceRate,
                        item.monthlyNewMemorization,
                        item.monthlyRevision,
                        '${item.student.monthlySubscription} ج.م',
                      ];
                    }),
                    headerStyle: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                        color: PdfColors.white),
                    headerDecoration:
                        const pw.BoxDecoration(color: PdfColor.fromInt(0xFF2B3724)),
                    cellStyle: const pw.TextStyle(fontSize: 9),
                    cellAlignment: pw.Alignment.centerRight,
                    cellPadding: const pw.EdgeInsets.symmetric(
                        horizontal: 8, vertical: 6),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    final outputDir = await getTemporaryDirectory();
    final sanitizedTitle =
        periodTitle.replaceAll(RegExp(r'[^\w\u0600-\u06FF]+'), '_');
    final file = File('${outputDir.path}/athar_report_$sanitizedTitle.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Generates an Excel spreadsheet with the exact 7-column layout requested by the user.
  static Future<File> generateAttendanceReportExcel({
    required String periodTitle,
    required String attendanceRate,
    List<StudentReportStats>? studentStats,
    List<Student>? presentStudents,
    List<Student>? absentStudents,
    List<Student>? unrecordedStudents,
    required Map<String, int> gradesCount,
  }) async {
    final List<StudentReportStats> effectiveStats = studentStats ?? [
      ...?presentStudents?.map((s) => StudentReportStats(student: s, attendanceStatus: 'حاضر', attendanceRate: '100%')),
      ...?absentStudents?.map((s) => StudentReportStats(student: s, attendanceStatus: 'غائب', attendanceRate: '0%')),
      ...?unrecordedStudents?.map((s) => StudentReportStats(student: s, attendanceStatus: 'قيد التسجيل', attendanceRate: '-')),
    ];
    final excel = Excel.createExcel();
    final sheet = excel['تقرير الحلقة'];

    // Title Row
    sheet.appendRow([
      TextCellValue('تطبيق أثر - تقرير الحلقة والإحصائيات الشاملة'),
      TextCellValue(periodTitle),
    ]);
    sheet.appendRow([
      TextCellValue('نسبة الحضور:'),
      TextCellValue(attendanceRate),
      TextCellValue('إجمالي الطلاب:'),
      IntCellValue(effectiveStats.length),
    ]);
    sheet.appendRow([]); // Empty spacer row

    // Exact 7 Columns from Right to Left
    sheet.appendRow([
      TextCellValue('م'),
      TextCellValue('اسم الطالب'),
      TextCellValue('رقم الهاتف'),
      TextCellValue('نسبة الحضور'),
      TextCellValue('إجمالي جديد الشهر حتى الآن'),
      TextCellValue('إجمالي المراجعة خلال الشهر حتى الآن'),
      TextCellValue('قيمة الاشتراك'),
    ]);

    int counter = 1;
    for (final item in effectiveStats) {
      sheet.appendRow([
        IntCellValue(counter++),
        TextCellValue(item.student.name),
        TextCellValue(item.student.parentPhone.isNotEmpty
            ? item.student.parentPhone
            : '-'),
        TextCellValue(item.attendanceRate),
        TextCellValue(item.monthlyNewMemorization),
        TextCellValue(item.monthlyRevision),
        IntCellValue(item.student.monthlySubscription),
      ]);
    }

    final outputDir = await getTemporaryDirectory();
    final sanitizedTitle =
        periodTitle.replaceAll(RegExp(r'[^\w\u0600-\u06FF]+'), '_');
    final file = File('${outputDir.path}/athar_report_$sanitizedTitle.xlsx');
    final fileBytes = excel.save();
    if (fileBytes != null) {
      await file.writeAsBytes(fileBytes);
    }
    return file;
  }

  /// Generates an Excel spreadsheet summarizing payments and collections.
  static Future<File> generateCollectionsExcel(
      List<Student> students, List<Payment> payments) async {
    final excel = Excel.createExcel();
    final sheet = excel['سجل التحصيل المالي'];

    // Header Row
    sheet.appendRow([
      TextCellValue('م'),
      TextCellValue('اسم الطالب'),
      TextCellValue('الشهر'),
      TextCellValue('الاشتراك الشهري'),
      TextCellValue('المبلغ المدفوع'),
      TextCellValue('حالة السداد'),
      TextCellValue('تاريخ السداد'),
      TextCellValue('هاتف ولي الأمر'),
    ]);

    int index = 1;
    for (final student in students) {
      final studentPayments =
          payments.where((p) => p.studentId == student.id).toList();
      if (studentPayments.isEmpty) {
        sheet.appendRow([
          IntCellValue(index++),
          TextCellValue(student.name),
          TextCellValue('-'),
          IntCellValue(student.monthlySubscription),
          const IntCellValue(0),
          TextCellValue('غير مدفوع'),
          TextCellValue('-'),
          TextCellValue(student.parentPhone),
        ]);
      } else {
        for (final p in studentPayments) {
          sheet.appendRow([
            IntCellValue(index++),
            TextCellValue(student.name),
            TextCellValue(p.month),
            IntCellValue(student.monthlySubscription),
            DoubleCellValue(p.amount),
            TextCellValue(p.isPaid ? 'مدفوع' : 'غير مدفوع'),
            TextCellValue(
                p.paymentDate?.toIso8601String().substring(0, 10) ?? '-'),
            TextCellValue(student.parentPhone),
          ]);
        }
      }
    }

    final outputDir = await getTemporaryDirectory();
    final file = File('${outputDir.path}/collections_report.xlsx');
    final fileBytes = excel.save();
    if (fileBytes != null) {
      await file.writeAsBytes(fileBytes);
    }
    return file;
  }
}
