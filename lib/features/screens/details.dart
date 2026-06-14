import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home/domain/entites/surah.dart';

class DetailScreen extends StatefulWidget {
  final int noSurat;

  const DetailScreen({super.key, required this.noSurat});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSurahNumber = prefs.getInt('markedSurat');
    if (savedSurahNumber == widget.noSurat) {
      setState(() {
        isBookmarked = true;
      });
    }
  }

  Future<Surah> _getDetailSurah() async {
    final data = await Dio().get("https://equran.id/api/surat/${widget.noSurat}");
    return Surah.fromJson(json.decode(data.toString()));
  }

  Future<void> _saveSurah(Surah surah) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${surah.namaLatin}.txt';
    String surahContent = 'Surah: ${surah.namaLatin}\n\n';
    for (var ayat in surah.ayat!) {
      surahContent += '(${ayat.nomor}) ${ayat.ar}\n';
    }

    try {
      final file = File(filePath);
      await file.writeAsString(surahContent);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('markedSurat', surah.nomor);

      setState(() {
        isBookmarked = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حفظ السورة: ${surah.namaLatin}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل حفظ السورة: $e')),
      );
    }
  }

  Future<void> _removeSurah(Surah surah) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${surah.namaLatin}.txt';
    final file = File(filePath);

    try {
      if (await file.exists()) await file.delete();

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('markedSurat');

      setState(() => isBookmarked = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إلغاء حفظ السورة: ${surah.namaLatin}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل إلغاء حفظ السورة: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Surah>(
      future: _getDetailSurah(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Color(0xff0b132b),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final surah = snapshot.data!;

        return Scaffold(
          backgroundColor: const Color(0xff0b132b),
          appBar: AppBar(
            backgroundColor: const Color(0xff1c2541),
            elevation: 4,
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  surah.nama,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  surah.namaLatin,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.bookmark,
                  color: isBookmarked ? Colors.amber : Colors.white,
                  size: 26,
                ),
                onPressed: () {
                  isBookmarked ? _removeSurah(surah) : _saveSurah(surah);
                },
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff1c2541).withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
                child: SelectableText.rich(
                  TextSpan(
                    children: surah.ayat!.map((ayat) {
                      return TextSpan(
                        children: [
                           WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                                      padding: EdgeInsets.all(6.w),
                                      decoration: const BoxDecoration(
                                        color: Colors.white12,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${ayat.nomor}',
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                          TextSpan(
                            text: ' ${ayat.ar} ',
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              height: 2.2,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
