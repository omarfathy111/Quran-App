import 'package:flutter/material.dart';
import '../widgets/aya_of_the_day_widget.dart';

class AyaOfTheDayPage extends StatelessWidget {
  const AyaOfTheDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("آية اليوم")),
      body: const AyaOfTheDayWidget(),
    );
  }
}