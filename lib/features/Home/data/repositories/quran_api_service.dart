import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:noor_aliman/features/Home/domain/entites/surah.dart';

class QuranApiService {
  // الرابط الأساسي للـ API لـ Quran.com (الإصدار الرابع)
  static const String baseUrl = "https://api.quran.com/api/v4";

  // دالة لجلب قائمة كل السور
  Future<List<Surah>> getAllSurahs() async {
    final response = await http.get(Uri.parse('$baseUrl/chapters?language=ar'));

    if (response.statusCode == 200) {
      // إذا كانت الاستجابة ناجحة (200)، نقوم بتحليل البيانات
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> chapters = data['chapters'];
      
      // تحويل القائمة المليئة بـ JSON إلى قائمة مليئة بـ Objects من نوع Surah
      return chapters.map((json) => Surah.fromJson(json)).toList();
    } else {
      // في حال حدوث خطأ في السيرفر
      throw Exception('فشل في تحميل قائمة السور، جرب لاحقاً');
    }
  }
}