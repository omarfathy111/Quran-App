class Surah {
  final int id;
  final String nameArabic;
  final String nameComplex;
  final int versesCount;
  final String revelationPlace;

  Surah({
    required this.id,
    required this.nameArabic,
    required this.nameComplex,
    required this.versesCount,
    required this.revelationPlace,
  });

  // بوظيفتها تحويل الـ JSON القادم من الـ API إلى كائن (Object) داخل الفلاتر
  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      id: json['id'],
      nameArabic: json['name_arabic'],
      nameComplex: json['name_complex'],
      versesCount: json['verses_count'],
      revelationPlace: json['revelation_place'],
    );
  }
}