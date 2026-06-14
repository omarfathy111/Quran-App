import 'package:flutter/material.dart';
import 'package:noor_aliman/features/Home/data/repositories/aya_remote_data_source.dart' show AyaRemoteDataSourceImpl;
import 'package:noor_aliman/features/Home/domain/entites/aya.dart' show Aya;
import '../../domain/usecases/get_aya_of_the_day.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';

class AyaOfTheDayWidget extends StatelessWidget {
  const AyaOfTheDayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final getAya = GetAyaOfTheDay(
      remoteDataSource: AyaRemoteDataSourceImpl(dio: Dio()),
    );

    return FutureBuilder<Aya>(
      future: getAya.call(),
      builder: (context, snapshot) {
        // أثناء التحميل
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // لو فيه خطأ
        if (snapshot.hasError) {
          print("خطأ في جلب الآية: ${snapshot.error}");
          return Text("حدث خطأ: ${snapshot.error}");
        }

        // لو مفيش بيانات
        if (!snapshot.hasData) {
          return const Text("لا توجد بيانات للآية اليوم");
        }

        // البيانات جاهزة
        final aya = snapshot.data!;
        return Card(
          margin: const EdgeInsets.all(16),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${aya.surah} : ${aya.ayah}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 12),
                Text(aya.text, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Share.share("آية اليوم:\n${aya.text}\n-- ${aya.surah} : ${aya.ayah}");
                  },
                  icon: const Icon(Icons.share),
                  label: const Text("شارك الآية"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}