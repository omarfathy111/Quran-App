import 'package:dio/dio.dart';
import '../models/aya_model.dart';

abstract class AyaRemoteDataSource {
  Future<AyaModel> getAyaOfTheDay();
}

class AyaRemoteDataSourceImpl implements AyaRemoteDataSource {
  final Dio dio;

  AyaRemoteDataSourceImpl({required this.dio});

  @override
  Future<AyaModel> getAyaOfTheDay() async {
    try {
      // جلب كل السور
      final surahResponse = await dio.get("https://equran.id/api/surat");
      if (surahResponse.statusCode != 200) {
        throw Exception("فشل تحميل السور: ${surahResponse.statusCode}");
      }

      final List surahs = surahResponse.data;
      if (surahs.isEmpty) {
        throw Exception("لا يوجد سور متاحة");
      }

      // يوم السنة لتحديد السورة والآية
      final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
      final surahIndex = dayOfYear % surahs.length;
      final surah = surahs[surahIndex];

      // التأكد من أن المفتاح موجود
      if (!surah.containsKey('nomor') || !surah.containsKey('jumlah_ayat')) {
        throw Exception("السورة لا تحتوي على المفاتيح المطلوبة (nomor أو jumlah_ayat)");
      }

      final int surahNumber = surah['nomor'] as int;
      final int ayahsCount = surah['jumlah_ayat'] as int;

      // تحديد رقم الآية بشكل آمن
      final int ayahNumber = ((dayOfYear % ayahsCount) + 1).clamp(1, ayahsCount);

      final ayaUrl = "https://equran.id/api/surat/$surahNumber/ayat/$ayahNumber";
      print("جاري جلب الآية من الرابط: $ayaUrl");

      final ayaResponse = await dio.get(ayaUrl);
      if (ayaResponse.statusCode != 200) {
        throw Exception("فشل تحميل الآية: ${ayaResponse.statusCode}");
      }

      // التأكد من أن الـ response يحتوي على النص
      final ayaText = ayaResponse.data['teks'];
      if (ayaText == null || ayaText.isEmpty) {
        throw Exception("النص غير متوفر لهذه الآية");
      }

      return AyaModel(
        surah: surah['nama'] ?? "غير معروف",
        ayah: ayahNumber,
        text: ayaText,
      );
    } catch (e, s) {
      print("خطأ في جلب الآية: $e");
      print("StackTrace: $s");
      throw Exception("حدث خطأ أثناء جلب آية اليوم");
    }
  }
}