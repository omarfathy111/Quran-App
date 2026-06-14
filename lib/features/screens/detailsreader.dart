import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../core/colors/colors.dart';
import '../Home/domain/entites/surah.dart';
import '../splach/widgets/audio_provider.dart';

class DetailsScreen extends StatefulWidget {
  final int noSurat;

  const DetailsScreen({super.key, required this.noSurat});

  @override
  State<DetailsScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailsScreen> {
  Future<Surah> _getDetailSurah() async {
    final data = await Dio().get("https://equran.id/api/surat/${widget.noSurat}");
    return Surah.fromJson(json.decode(data.toString()));
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Surah>(
      future: _getDetailSurah(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return  Scaffold(backgroundColor: background);
        }

        final surah = snapshot.data!;
        final audioProvider = Provider.of<AudioProvider>(context);

        return Scaffold(
          backgroundColor: background,
          appBar: _appBar(context: context, surah: surah),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(child: _details(surah: surah)),
            ],
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔊 Play / Pause Button
                  IconButton(
                    onPressed: () async {
                      if (audioProvider.isPlaying &&
                          audioProvider.currentSurah == widget.noSurat) {
                        audioProvider.pause();
                      } else {
                        audioProvider.stop();
                        audioProvider.play(surah.audio, widget.noSurat);
                      }
                    },
                    icon: Icon(
                      audioProvider.isPlaying &&
                              audioProvider.currentSurah == widget.noSurat
                          ? Icons.pause
                          : Icons.play_arrow_outlined,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // 🎚️ Audio Progress Slider
                  Column(
                    children: [
                      Slider(
                        value: audioProvider.position.inMilliseconds.toDouble().clamp(
                              0.0,
                              audioProvider.duration.inMilliseconds.toDouble() > 0
                                  ? audioProvider.duration.inMilliseconds.toDouble()
                                  : 1.0,
                            ),
                        min: 0.0,
                        max: audioProvider.duration.inMilliseconds.toDouble() > 0
                            ? audioProvider.duration.inMilliseconds.toDouble()
                            : 1.0,
                        onChanged: (value) {
                          audioProvider.seek(Duration(milliseconds: value.toInt()));
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(audioProvider.position),
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            _formatDuration(audioProvider.duration),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // ⏪⏩ Skip buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.replay_10, color: Colors.white),
                        onPressed: () {
                          final newPos = audioProvider.position - const Duration(seconds: 10);
                          audioProvider.seek(newPos > Duration.zero ? newPos : Duration.zero);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.forward_10, color: Colors.white),
                        onPressed: () {
                          final newPos = audioProvider.position + const Duration(seconds: 10);
                          if (newPos < audioProvider.duration) {
                            audioProvider.seek(newPos);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _details({required Surah surah}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          children: [
            Container(
              height: 257,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, .6, 1],
                  colors: [
                    Color(0xFFDF98FA),
                    Color(0xFFB070FD),
                    Color(0xFF9055FF),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Opacity(
                opacity: .2,
                child: SvgPicture.asset(
                  'assets/svgs/quran.svg',
                  width: 324 - 55,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  Text(
                    surah.namaLatin,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 26.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Divider(
                    color: Colors.white.withOpacity(.35),
                    thickness: 2,
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        surah.tempatTurun.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Container(
                        width: 4.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "${surah.jumlahAyat} Ayat",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  SvgPicture.asset('assets/svgs/bismillah.svg'),
                ],
              ),
            ),
          ],
        ),
      );

  AppBar _appBar({required BuildContext context, required Surah surah}) => AppBar(
        backgroundColor: background,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: SvgPicture.asset('assets/svgs/back-icon.svg'),
              color: Colors.white,
            ),
            SizedBox(width: 24.w),
            Text(
              surah.nama,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
          ],
        ),
      );
}
