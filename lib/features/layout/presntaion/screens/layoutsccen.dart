import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/colors/colors.dart';
import '../../../Home/presntaion/screens/homepage.dart';
import '../../../screens/details.dart';
import '../../../screens/hadith_screen.dart';
import '../../../screens/homereader.dart';
import '../../../screens/sebha_screen.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int selectedIndex = 0;

  // Removed the QiblaScreen
  List<Widget> widgetPages =  [
    const HomeScreen(),
    const Homereader(),
    const HadithScreen(),
    const SebhaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white), // Set back button color to white
        backgroundColor: Colors.purple[900],
        title: const Text('اختر خيارًا', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView.builder(
          itemCount: 5, // Reduced the number of buttons to 5
          itemBuilder: (context, index) {
            return Card(
              color: Colors.purple[900],
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              elevation: 4,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                title: Text(_getLabelForIndex(index), style: const TextStyle(fontSize: 18, color: Colors.white)),
                onTap: () => _onItemTapped(index),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onItemTapped(int index) async {
    if (index == 4) { // Bookmark option is now at index 4
      final prefs = await SharedPreferences.getInstance();
      final noSurat = prefs.getInt('markedSurat'); // Load the saved Surah number

      if (noSurat != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              noSurat: noSurat, // Pass the saved Surah number
            ),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا توجد آية محفوظة')),
        );
      }
    } else {
      setState(() {
        selectedIndex = index;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widgetPages[index]),
        );
      });
    }
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0: return "القرآن";
      case 1: return "قارئ";
      case 2: return "حديث";
      case 3: return "سبحة";
      case 4: return "علامة مرجعية"; // Bookmark text is now at index 4
      default: return "";
    }
  }
}