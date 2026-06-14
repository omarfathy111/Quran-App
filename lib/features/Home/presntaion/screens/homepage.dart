import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/colors/colors.dart';
import '../widgets/surah_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.purple[900],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Set back button color to white
        title: Row(
          children: [
            Text(
              "القرآن الكريم",
              style: TextStyle(fontSize: 22.sp, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search field below the AppBar
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(color: Colors.white), // Change text color to white
              decoration: InputDecoration(
                hintText: "بحث في سورة",
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 20), // Change hint text color to white
                filled: true,
                fillColor: Colors.purple.shade700.withOpacity(0.3), // Set a suitable fill color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    // تنفيذ البحث هنا
                  },
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: _clearSearch,
                ),
              ),
            ),
          ),
          // Surah Tab widget
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SurahTab(searchQuery: _searchQuery),
            ),
          ),
        ],
      ),
    );
  }
}