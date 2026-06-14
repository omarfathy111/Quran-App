import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../features/Home/domain/entites/surah.dart';
import '../../features/screens/detailsreader.dart';
import '../colors/colors.dart';

class ParaTab extends StatelessWidget {
  final List<Surah> filteredSurahs; // Accept the full list of surahs
  final String searchQuery;

  const ParaTab({super.key, required this.filteredSurahs, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    // Filter Surahs based on the search query
    List<Surah> displayedSurahs = filteredSurahs.where((surah) =>
        surah.nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
        surah.namaLatin.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    // Check if displayedSurahs is empty
    if (displayedSurahs.isEmpty) {
      return const Center(child: Text('No matching Surahs found.'));
    }

    return ListView.separated(
      itemCount: displayedSurahs.length,
      separatorBuilder: (context, index) => Divider(
        color: const Color(0xFF7B80AD).withOpacity(.35),
      ),
      itemBuilder: (context, index) {
        return _surahItem(surah: displayedSurahs[index], context: context);
      },
    );
  }

  Widget _surahItem({required BuildContext context, required Surah surah}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailsScreen(noSurat: surah.nomor),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Stack(
              children: [
                SvgPicture.asset("assets/svgs/nomor-surah.svg"),
                SizedBox(
                  height: 36,
                  width: 36,
                  child: Center(
                    child: Text(
                      "${surah.nomor}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.namaLatin,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'الشيخ مشاري العفاسي',
                        style: TextStyle(
                          fontSize: 15,
                          color: text,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: text,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              surah.nama,
              style: TextStyle(
                fontSize: 20,
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
