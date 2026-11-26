import 'dart:math';
import 'package:athar/core/quran/quran_data.dart';

enum MemorizationDirection {
  forward, // Al-Baqarah -> An-Nas
  reverse, // An-Nas -> Al-Baqarah
}

class MemorizedSegment {
  final int surahId;
  final int startVerse;
  final int endVerse;

  const MemorizedSegment({
    required this.surahId,
    required this.startVerse,
    required this.endVerse,
  });

  Map<String, dynamic> toJson() => {
        'surahId': surahId,
        'startVerse': startVerse,
        'endVerse': endVerse,
      };

  factory MemorizedSegment.fromJson(Map<String, dynamic> json) => MemorizedSegment(
        surahId: json['surahId'] as int,
        startVerse: json['startVerse'] as int,
        endVerse: json['endVerse'] as int,
      );
}

class QuranEngine {
  static const int totalQuranPages = 604;
  static const int totalQuranLines = totalQuranPages * 15; // 9060 lines

  /// Calculates pages memorized from a list of segments.
  static double calculatePagesMemorized(List<MemorizedSegment> segments) {
    double totalPages = 0;
    for (final segment in segments) {
      final surah = QuranData.getSurahById(segment.surahId);
      if (surah == null) continue;

      final totalVerses = surah.totalVerses;
      if (totalVerses <= 0) continue;

      final versesCount = (segment.endVerse - segment.startVerse + 1).abs();
      final fraction = min(1.0, versesCount / totalVerses);
      totalPages += fraction * surah.totalPages;
    }
    return min(totalQuranPages.toDouble(), totalPages);
  }

  /// Calculates the progress percentage.
  static double calculatePercentage(double pagesMemorized) {
    if (pagesMemorized <= 0) return 0;
    return min(100.0, (pagesMemorized / totalQuranPages) * 100);
  }

  /// Helper to get the page number corresponding to a verse in a Surah.
  /// Standard Madinah Mushaf approximation.
  static int getApproximatePageForVerse(int surahId, int verseNumber) {
    final surah = QuranData.getSurahById(surahId);
    if (surah == null) return 1;
    if (surah.totalPages <= 1) return surah.startPage;

    // Linear distribution of verses across pages
    final totalVerses = surah.totalVerses;
    if (totalVerses <= 0) return surah.startPage;

    final progressRatio = (verseNumber - 1) / totalVerses;
    final pagesOffset = (progressRatio * surah.totalPages).floor();
    return min(surah.endPage, surah.startPage + pagesOffset);
  }

  /// Calculates estimated completion date.
  /// Each page has 15 lines.
  static DateTime estimateCompletionDate({
    required double pagesRemaining,
    required double dailyLines,
    required int attendanceDaysPerWeek,
    DateTime? startDate,
  }) {
    final start = startDate ?? DateTime.now();
    if (pagesRemaining <= 0) return start;
    if (dailyLines <= 0 || attendanceDaysPerWeek <= 0) return start.add(const Duration(days: 365 * 10)); // Far future

    final linesRemaining = pagesRemaining * 15;
    final weeklyLines = dailyLines * attendanceDaysPerWeek;
    final weeksNeeded = linesRemaining / weeklyLines;
    final daysNeeded = (weeksNeeded * 7).ceil();

    return start.add(Duration(days: daysNeeded));
  }

  /// Expands a Juz number into lists of MemorizedSegment for calculations.
  static List<MemorizedSegment> getSegmentsForJuz(int juzNumber) {
    final juz = QuranData.getJuzByNumber(juzNumber);
    if (juz == null) return [];

    final List<MemorizedSegment> segments = [];
    for (final surah in QuranData.surahs) {
      // If surah overlaps with juz pages
      if (surah.startPage <= juz.endPage && surah.endPage >= juz.startPage) {
        // Approximate which verses of the Surah are in this Juz.
        // For simplicity, we include the entire Surah if it is fully inside,
        // or approximate portions if it crosses Juz boundaries.
        // In clean data, we will just include the whole Surah or key verses.
        // A standard approach is:
        int startVerse = 1;
        int endVerse = surah.totalVerses;

        // Simple boundary checks
        if (surah.startPage < juz.startPage) {
          // Surah starts before Juz. Start verse is roughly in the middle
          final ratio = (juz.startPage - surah.startPage) / surah.totalPages;
          startVerse = max(1, (ratio * surah.totalVerses).round() + 1);
        }
        if (surah.endPage > juz.endPage) {
          // Surah ends after Juz. End verse is roughly in the middle
          final ratio = (juz.endPage - surah.startPage + 1) / surah.totalPages;
          endVerse = min(surah.totalVerses, (ratio * surah.totalVerses).round());
        }

        if (startVerse <= endVerse) {
          segments.add(MemorizedSegment(
            surahId: surah.id,
            startVerse: startVerse,
            endVerse: endVerse,
          ));
        }
      }
    }
    return segments;
  }
}
