import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/colors/colors.dart';
import '../../core/tabs/para_tab.dart';
import '../../features/Home/domain/entites/surah.dart';

class Homereader extends StatefulWidget {
  const Homereader({super.key});

  @override
  State<Homereader> createState() => _HomereaderState();
}

class _HomereaderState extends State<Homereader> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  Future<List<Surah>> _getAllSurahs() async {
    String data = await rootBundle.loadString("assets/datas/list-surah.json");
    return surahFromJson(data); // Assuming you have this function defined to parse JSON.
  }

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
        iconTheme: const IconThemeData(color: Colors.white), // Set back button color to white
        backgroundColor: Colors.purple[900],
        elevation: 1,
        title: Text(
          "القرآن الكريم",
          style: TextStyle(fontSize: 22.sp, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // حقل البحث تحت شريط التطبيق
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.purple.shade700.withOpacity(0.3), // Set a suitable fill color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
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
          // حاوية البيانات
          Expanded(
            child: FutureBuilder<List<Surah>>(
              future: _getAllSurahs(), // Fetch the surahs when the body is built
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While the future is loading, show a loading indicator
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // If there's an error, show an error message
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // If there's no data, show a message
                  return const Center(child: Text('No Surahs found.'));
                }

                // If data is available, display the content
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ParaTab(
                    filteredSurahs: snapshot.data!,
                    searchQuery: _searchQuery, // Pass the search query
                  ), // Pass the filtered list and search query to ParaTab
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}