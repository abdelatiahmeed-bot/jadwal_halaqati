import 'package:flutter_test/flutter_test.dart';
import 'package:athar/core/quran/quran_engine.dart';

void main() {
  group('QuranEngine Tests', () {
    test('calculatePercentage returns accurate values and caps at 100', () {
      expect(QuranEngine.calculatePercentage(0), 0.0);
      expect(QuranEngine.calculatePercentage(302), closeTo(50.0, 0.1));
      expect(QuranEngine.calculatePercentage(604), 100.0);
      expect(QuranEngine.calculatePercentage(700), 100.0); // should cap at 100
    });

    test('getApproximatePageForVerse returns correct pages', () {
      // Al-Fatihah is on page 1
      expect(QuranEngine.getApproximatePageForVerse(1, 1), 1);
      expect(QuranEngine.getApproximatePageForVerse(1, 7), 1);

      // Al-Baqarah spans pages 2-49
      expect(QuranEngine.getApproximatePageForVerse(2, 1), 2);
      expect(QuranEngine.getApproximatePageForVerse(2, 286), 49);
    });

    test('calculatePagesMemorized calculates fractional surah page counts', () {
      // 1. Full Surah Al-Fatihah (1 page)
      final segments = [
        const MemorizedSegment(surahId: 1, startVerse: 1, endVerse: 7),
      ];
      expect(QuranEngine.calculatePagesMemorized(segments), closeTo(1.0, 0.01));

      // 2. Partial Surah Al-Baqarah (half of Al-Baqarah verses = approx half of Al-Baqarah pages)
      // Al-Baqarah has 48 pages (2 to 49)
      final partialBaqarah = [
        const MemorizedSegment(surahId: 2, startVerse: 1, endVerse: 143),
      ];
      expect(QuranEngine.calculatePagesMemorized(partialBaqarah), closeTo(24.0, 0.5));
    });

    test('estimateCompletionDate projects dates accurately', () {
      final start = DateTime(2026, 6, 4);

      // Remaining: 30 pages
      // Daily Lines: 15 (1 page per attendance day)
      // Attendance Days: 5 per week
      // Weekly pages: 5
      // 30 pages / 5 pages/week = 6 weeks needed = 42 days
      final expectedDate = start.add(const Duration(days: 42));
      final projected = QuranEngine.estimateCompletionDate(
        pagesRemaining: 30,
        dailyLines: 15,
        attendanceDaysPerWeek: 5,
        startDate: start,
      );
      expect(projected, expectedDate);
    });

    test('getSegmentsForJuz expands Juz 30 boundary segments correctly', () {
      // Juz 30 is pages 582-604
      final segments = QuranEngine.getSegmentsForJuz(30);
      expect(segments, isNotEmpty);

      // Verify that Surah An-Naba (78) is included
      final hasAnNaba = segments.any((s) => s.surahId == 78);
      expect(hasAnNaba, isTrue);

      // Verify that Surah An-Nas (114) is included
      final hasAnNas = segments.any((s) => s.surahId == 114);
      expect(hasAnNas, isTrue);
      
      // Verify that Surah Al-Fatihah (1) is NOT included in Juz 30
      final hasAlFatihah = segments.any((s) => s.surahId == 1);
      expect(hasAlFatihah, isFalse);
    });
  });
}
