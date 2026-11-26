class SurahData {
  final int id;
  final String nameAr;
  final String nameEn;
  final int totalVerses;
  final int startPage;
  final int endPage;

  const SurahData({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.totalVerses,
    required this.startPage,
    required this.endPage,
  });

  int get totalPages => (endPage - startPage) + 1;
}

class JuzData {
  final int number;
  final int startPage;
  final int endPage;

  const JuzData({
    required this.number,
    required this.startPage,
    required this.endPage,
  });
}

class QuranData {
  static const List<SurahData> surahs = [
    SurahData(id: 1, nameAr: "الفاتحة", nameEn: "Al-Fatihah", totalVerses: 7, startPage: 1, endPage: 1),
    SurahData(id: 2, nameAr: "البقرة", nameEn: "Al-Baqarah", totalVerses: 286, startPage: 2, endPage: 49),
    SurahData(id: 3, nameAr: "آل عمران", nameEn: "Al-Imran", totalVerses: 200, startPage: 50, endPage: 76),
    SurahData(id: 4, nameAr: "النساء", nameEn: "An-Nisa", totalVerses: 176, startPage: 77, endPage: 106),
    SurahData(id: 5, nameAr: "المائدة", nameEn: "Al-Ma'idah", totalVerses: 120, startPage: 106, endPage: 127),
    SurahData(id: 6, nameAr: "الأنعام", nameEn: "Al-An'am", totalVerses: 165, startPage: 128, endPage: 150),
    SurahData(id: 7, nameAr: "الأعراف", nameEn: "Al-A'raf", totalVerses: 206, startPage: 151, endPage: 176),
    SurahData(id: 8, nameAr: "الأنفال", nameEn: "Al-Anfal", totalVerses: 75, startPage: 177, endPage: 186),
    SurahData(id: 9, nameAr: "التوبة", nameEn: "At-Tawbah", totalVerses: 129, startPage: 187, endPage: 207),
    SurahData(id: 10, nameAr: "يونس", nameEn: "Yunus", totalVerses: 109, startPage: 208, endPage: 221),
    SurahData(id: 11, nameAr: "هود", nameEn: "Hud", totalVerses: 123, startPage: 221, endPage: 235),
    SurahData(id: 12, nameAr: "يوسف", nameEn: "Yusuf", totalVerses: 111, startPage: 235, endPage: 248),
    SurahData(id: 13, nameAr: "الرعد", nameEn: "Ar-Ra'd", totalVerses: 43, startPage: 249, endPage: 255),
    SurahData(id: 14, nameAr: "إبراهيم", nameEn: "Ibrahim", totalVerses: 52, startPage: 255, endPage: 261),
    SurahData(id: 15, nameAr: "الحجر", nameEn: "Al-Hijr", totalVerses: 99, startPage: 262, endPage: 267),
    SurahData(id: 16, nameAr: "النحل", nameEn: "An-Nahl", totalVerses: 128, startPage: 267, endPage: 281),
    SurahData(id: 17, nameAr: "الإسراء", nameEn: "Al-Isra", totalVerses: 111, startPage: 282, endPage: 293),
    SurahData(id: 18, nameAr: "الكهف", nameEn: "Al-Kahf", totalVerses: 110, startPage: 293, endPage: 304),
    SurahData(id: 19, nameAr: "مريم", nameEn: "Maryam", totalVerses: 98, startPage: 305, endPage: 312),
    SurahData(id: 20, nameAr: "طه", nameEn: "Ta-Ha", totalVerses: 135, startPage: 312, endPage: 321),
    SurahData(id: 21, nameAr: "الأنبياء", nameEn: "Al-Anbiya", totalVerses: 112, startPage: 322, endPage: 331),
    SurahData(id: 22, nameAr: "الحج", nameEn: "Al-Hajj", totalVerses: 78, startPage: 332, endPage: 341),
    SurahData(id: 23, nameAr: "المؤمنون", nameEn: "Al-Mu'minun", totalVerses: 118, startPage: 342, endPage: 349),
    SurahData(id: 24, nameAr: "النور", nameEn: "An-Nur", totalVerses: 64, startPage: 350, endPage: 359),
    SurahData(id: 25, nameAr: "الفرقان", nameEn: "Al-Furqan", totalVerses: 77, startPage: 359, endPage: 366),
    SurahData(id: 26, nameAr: "الشعراء", nameEn: "Ash-Shu'ara", totalVerses: 227, startPage: 367, endPage: 376),
    SurahData(id: 27, nameAr: "النمل", nameEn: "An-Naml", totalVerses: 93, startPage: 377, endPage: 385),
    SurahData(id: 28, nameAr: "القصص", nameEn: "Al-Qasas", totalVerses: 88, startPage: 385, endPage: 396),
    SurahData(id: 29, nameAr: "العنكبوت", nameEn: "Al-Ankabut", totalVerses: 69, startPage: 396, endPage: 404),
    SurahData(id: 30, nameAr: "الروم", nameEn: "Ar-Rum", totalVerses: 60, startPage: 404, endPage: 410),
    SurahData(id: 31, nameAr: "لقمان", nameEn: "Luqman", totalVerses: 34, startPage: 411, endPage: 414),
    SurahData(id: 32, nameAr: "السجدة", nameEn: "As-Sajdah", totalVerses: 30, startPage: 415, endPage: 417),
    SurahData(id: 33, nameAr: "الأحزاب", nameEn: "Al-Ahzab", totalVerses: 73, startPage: 418, endPage: 427),
    SurahData(id: 34, nameAr: "سبأ", nameEn: "Saba", totalVerses: 54, startPage: 428, endPage: 434),
    SurahData(id: 35, nameAr: "فاطر", nameEn: "Fatir", totalVerses: 45, startPage: 434, endPage: 440),
    SurahData(id: 36, nameAr: "يس", nameEn: "Ya-Sin", totalVerses: 83, startPage: 440, endPage: 445),
    SurahData(id: 37, nameAr: "الصافات", nameEn: "As-Saffat", totalVerses: 182, startPage: 446, endPage: 452),
    SurahData(id: 38, nameAr: "ص", nameEn: "Sad", totalVerses: 88, startPage: 453, endPage: 458),
    SurahData(id: 39, nameAr: "الزمر", nameEn: "Az-Zumar", totalVerses: 75, startPage: 458, endPage: 467),
    SurahData(id: 40, nameAr: "غافر", nameEn: "Ghafir", totalVerses: 85, startPage: 467, endPage: 476),
    SurahData(id: 41, nameAr: "فصلت", nameEn: "Fussilat", totalVerses: 54, startPage: 476, endPage: 482),
    SurahData(id: 42, nameAr: "الشورى", nameEn: "Ash-Shura", totalVerses: 53, startPage: 483, endPage: 489),
    SurahData(id: 43, nameAr: "الزخرف", nameEn: "Az-Zukhruf", totalVerses: 89, startPage: 489, endPage: 495),
    SurahData(id: 44, nameAr: "الدخان", nameEn: "Ad-Dukhan", totalVerses: 59, startPage: 496, endPage: 498),
    SurahData(id: 45, nameAr: "الجاثية", nameEn: "Al-Jathiyah", totalVerses: 37, startPage: 499, endPage: 502),
    SurahData(id: 46, nameAr: "الأحقاف", nameEn: "Al-Ahqaf", totalVerses: 35, startPage: 502, endPage: 506),
    SurahData(id: 47, nameAr: "محمد", nameEn: "Muhammad", totalVerses: 38, startPage: 507, endPage: 510),
    SurahData(id: 48, nameAr: "الفتح", nameEn: "Al-Fath", totalVerses: 29, startPage: 511, endPage: 515),
    SurahData(id: 49, nameAr: "الحجرات", nameEn: "Al-Hujurat", totalVerses: 18, startPage: 515, endPage: 517),
    SurahData(id: 50, nameAr: "ق", nameEn: "Qaf", totalVerses: 45, startPage: 518, endPage: 520),
    SurahData(id: 51, nameAr: "الذاريات", nameEn: "Adh-Dhariyat", totalVerses: 60, startPage: 520, endPage: 523),
    SurahData(id: 52, nameAr: "الطور", nameEn: "At-Tur", totalVerses: 49, startPage: 523, endPage: 525),
    SurahData(id: 53, nameAr: "النجم", nameEn: "An-Najm", totalVerses: 62, startPage: 526, endPage: 528),
    SurahData(id: 54, nameAr: "القدر", nameEn: "Al-Qamar", totalVerses: 55, startPage: 528, endPage: 531),
    SurahData(id: 55, nameAr: "الرحمن", nameEn: "Ar-Rahman", totalVerses: 78, startPage: 531, endPage: 534),
    SurahData(id: 56, nameAr: "الواقعة", nameEn: "Al-Waqi'ah", totalVerses: 96, startPage: 534, endPage: 537),
    SurahData(id: 57, nameAr: "الحديد", nameEn: "Al-Hadid", totalVerses: 29, startPage: 537, endPage: 541),
    SurahData(id: 58, nameAr: "المجادلة", nameEn: "Al-Mujadilah", totalVerses: 22, startPage: 542, endPage: 545),
    SurahData(id: 59, nameAr: "الحشر", nameEn: "Al-Hashr", totalVerses: 24, startPage: 545, endPage: 548),
    SurahData(id: 60, nameAr: "الممتحنة", nameEn: "Al-Mumtahanah", totalVerses: 13, startPage: 549, endPage: 551),
    SurahData(id: 61, nameAr: "الصف", nameEn: "As-Saff", totalVerses: 14, startPage: 551, endPage: 552),
    SurahData(id: 62, nameAr: "الجمعة", nameEn: "Al-Jumu'ah", totalVerses: 11, startPage: 553, endPage: 554),
    SurahData(id: 63, nameAr: "المنافقون", nameEn: "Al-Munafiqun", totalVerses: 11, startPage: 554, endPage: 555),
    SurahData(id: 64, nameAr: "التغابن", nameEn: "At-Taghabun", totalVerses: 18, startPage: 556, endPage: 557),
    SurahData(id: 65, nameAr: "الطلاق", nameEn: "At-Talaq", totalVerses: 12, startPage: 558, endPage: 560),
    SurahData(id: 66, nameAr: "التحريم", nameEn: "At-Tahrim", totalVerses: 12, startPage: 560, endPage: 562),
    SurahData(id: 67, nameAr: "الملك", nameEn: "Al-Mulk", totalVerses: 30, startPage: 562, endPage: 564),
    SurahData(id: 68, nameAr: "القلم", nameEn: "Al-Qalam", totalVerses: 52, startPage: 564, endPage: 566),
    SurahData(id: 69, nameAr: "الحاقة", nameEn: "Al-Haqqah", totalVerses: 52, startPage: 566, endPage: 568),
    SurahData(id: 70, nameAr: "المعارج", nameEn: "Al-Ma'arij", totalVerses: 44, startPage: 568, endPage: 570),
    SurahData(id: 71, nameAr: "نوح", nameEn: "Nuh", totalVerses: 28, startPage: 570, endPage: 571),
    SurahData(id: 72, nameAr: "الجن", nameEn: "Al-Jinn", totalVerses: 28, startPage: 572, endPage: 573),
    SurahData(id: 73, nameAr: "المزمل", nameEn: "Al-Muzzammil", totalVerses: 20, startPage: 574, endPage: 575),
    SurahData(id: 74, nameAr: "المدثر", nameEn: "Al-Muddaththir", totalVerses: 56, startPage: 575, endPage: 577),
    SurahData(id: 75, nameAr: "القيامة", nameEn: "Al-Qiyamah", totalVerses: 40, startPage: 577, endPage: 578),
    SurahData(id: 76, nameAr: "الإنسان", nameEn: "Al-Insan", totalVerses: 31, startPage: 578, endPage: 580),
    SurahData(id: 77, nameAr: "المرسلات", nameEn: "Al-Mursalat", totalVerses: 50, startPage: 580, endPage: 581),
    SurahData(id: 78, nameAr: "النبأ", nameEn: "An-Naba", totalVerses: 40, startPage: 582, endPage: 583),
    SurahData(id: 79, nameAr: "النازعات", nameEn: "An-Nazi'at", totalVerses: 46, startPage: 583, endPage: 584),
    SurahData(id: 80, nameAr: "عبس", nameEn: "Abasa", totalVerses: 42, startPage: 585, endPage: 585),
    SurahData(id: 81, nameAr: "التكوير", nameEn: "At-Takwir", totalVerses: 29, startPage: 586, endPage: 586),
    SurahData(id: 82, nameAr: "الانفطار", nameEn: "Al-Infitar", totalVerses: 19, startPage: 587, endPage: 587),
    SurahData(id: 83, nameAr: "المطففين", nameEn: "Al-Mutaffifin", totalVerses: 36, startPage: 587, endPage: 589),
    SurahData(id: 84, nameAr: "الانشقاق", nameEn: "Inshiqaq", totalVerses: 25, startPage: 589, endPage: 590),
    SurahData(id: 85, nameAr: "البروج", nameEn: "Al-Buruj", totalVerses: 22, startPage: 590, endPage: 590),
    SurahData(id: 86, nameAr: "الطارق", nameEn: "At-Tariq", totalVerses: 17, startPage: 591, endPage: 591),
    SurahData(id: 87, nameAr: "الأعلى", nameEn: "Al-A'la", totalVerses: 19, startPage: 591, endPage: 592),
    SurahData(id: 88, nameAr: "الغاشية", nameEn: "Al-Ghashiyah", totalVerses: 26, startPage: 592, endPage: 593),
    SurahData(id: 89, nameAr: "الفجر", nameEn: "Al-Fajr", totalVerses: 30, startPage: 593, endPage: 594),
    SurahData(id: 90, nameAr: "البلد", nameEn: "Al-Balad", totalVerses: 20, startPage: 594, endPage: 595),
    SurahData(id: 91, nameAr: "الشمس", nameEn: "Ash-Shams", totalVerses: 15, startPage: 595, endPage: 595),
    SurahData(id: 92, nameAr: "الليل", nameEn: "Al-Layl", totalVerses: 21, startPage: 595, endPage: 596),
    SurahData(id: 93, nameAr: "الضحى", nameEn: "Ad-Duha", totalVerses: 11, startPage: 596, endPage: 596),
    SurahData(id: 94, nameAr: "الشرح", nameEn: "Ash-Sharh", totalVerses: 8, startPage: 596, endPage: 596),
    SurahData(id: 95, nameAr: "التين", nameEn: "At-Tin", totalVerses: 8, startPage: 597, endPage: 597),
    SurahData(id: 96, nameAr: "العلق", nameEn: "Al-Alaq", totalVerses: 19, startPage: 597, endPage: 598),
    SurahData(id: 97, nameAr: "القدر", nameEn: "Al-Qadr", totalVerses: 5, startPage: 598, endPage: 598),
    SurahData(id: 98, nameAr: "البينة", nameEn: "Al-Bayyinah", totalVerses: 8, startPage: 598, endPage: 599),
    SurahData(id: 99, nameAr: "الزلزلة", nameEn: "Az-Zalzalah", totalVerses: 8, startPage: 599, endPage: 599),
    SurahData(id: 100, nameAr: "العاديات", nameEn: "Al-Adiyat", totalVerses: 11, startPage: 599, endPage: 600),
    SurahData(id: 101, nameAr: "القارعة", nameEn: "Al-Qari'ah", totalVerses: 11, startPage: 600, endPage: 600),
    SurahData(id: 102, nameAr: "التكاثر", nameEn: "At-Takathur", totalVerses: 8, startPage: 600, endPage: 600),
    SurahData(id: 103, nameAr: "العصر", nameEn: "Al-Asr", totalVerses: 3, startPage: 601, endPage: 601),
    SurahData(id: 104, nameAr: "الهمزة", nameEn: "Al-Humazah", totalVerses: 9, startPage: 601, endPage: 601),
    SurahData(id: 105, nameAr: "الفيل", nameEn: "Al-Fil", totalVerses: 5, startPage: 601, endPage: 601),
    SurahData(id: 106, nameAr: "قريش", nameEn: "Quraish", totalVerses: 4, startPage: 602, endPage: 602),
    SurahData(id: 107, nameAr: "الماعون", nameEn: "Al-Ma'un", totalVerses: 7, startPage: 602, endPage: 602),
    SurahData(id: 108, nameAr: "الكوثر", nameEn: "Al-Kauthar", totalVerses: 3, startPage: 602, endPage: 602),
    SurahData(id: 109, nameAr: "الكافرون", nameEn: "Al-Kafirun", totalVerses: 6, startPage: 603, endPage: 603),
    SurahData(id: 110, nameAr: "النصر", nameEn: "An-Nasr", totalVerses: 3, startPage: 603, endPage: 603),
    SurahData(id: 111, nameAr: "المسد", nameEn: "Al-Masad", totalVerses: 5, startPage: 603, endPage: 603),
    SurahData(id: 112, nameAr: "الإخلاص", nameEn: "Al-Ikhlas", totalVerses: 4, startPage: 604, endPage: 604),
    SurahData(id: 113, nameAr: "الفلق", nameEn: "Al-Falaq", totalVerses: 5, startPage: 604, endPage: 604),
    SurahData(id: 114, nameAr: "الناس", nameEn: "An-Nas", totalVerses: 6, startPage: 604, endPage: 604),
  ];

  static const List<JuzData> juzs = [
    JuzData(number: 1, startPage: 1, endPage: 21),
    JuzData(number: 2, startPage: 22, endPage: 41),
    JuzData(number: 3, startPage: 42, endPage: 61),
    JuzData(number: 4, startPage: 62, endPage: 81),
    JuzData(number: 5, startPage: 82, endPage: 101),
    JuzData(number: 6, startPage: 102, endPage: 121),
    JuzData(number: 7, startPage: 122, endPage: 141),
    JuzData(number: 8, startPage: 142, endPage: 161),
    JuzData(number: 9, startPage: 162, endPage: 181),
    JuzData(number: 10, startPage: 182, endPage: 201),
    JuzData(number: 11, startPage: 202, endPage: 221),
    JuzData(number: 12, startPage: 222, endPage: 241),
    JuzData(number: 13, startPage: 242, endPage: 261),
    JuzData(number: 14, startPage: 262, endPage: 281),
    JuzData(number: 15, startPage: 282, endPage: 301),
    JuzData(number: 16, startPage: 302, endPage: 321),
    JuzData(number: 17, startPage: 322, endPage: 341),
    JuzData(number: 18, startPage: 342, endPage: 361),
    JuzData(number: 19, startPage: 362, endPage: 381),
    JuzData(number: 20, startPage: 382, endPage: 401),
    JuzData(number: 21, startPage: 402, endPage: 421),
    JuzData(number: 22, startPage: 422, endPage: 441),
    JuzData(number: 23, startPage: 442, endPage: 461),
    JuzData(number: 24, startPage: 462, endPage: 481),
    JuzData(number: 25, startPage: 482, endPage: 501),
    JuzData(number: 26, startPage: 502, endPage: 521),
    JuzData(number: 27, startPage: 522, endPage: 541),
    JuzData(number: 28, startPage: 542, endPage: 561),
    JuzData(number: 29, startPage: 562, endPage: 581),
    JuzData(number: 30, startPage: 582, endPage: 604),
  ];

  static SurahData? getSurahById(int id) {
    if (id < 1 || id > 114) return null;
    return surahs[id - 1];
  }

  static JuzData? getJuzByNumber(int number) {
    if (number < 1 || number > 30) return null;
    return juzs[number - 1];
  }
}
