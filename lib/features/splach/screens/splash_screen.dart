import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/colors/colors.dart';
import '../widgets/button_splach.dart';
import '../widgets/splach_image.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              Center(
                child: Text(
                  'تطبيق نور الايمان',
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Center(
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      'إِنَّا نَحْنُ نَزَّلْنَا ٱلذِّكْرَ وَإِنَّا لَهُ لَحَافِظُونَ',
                      textStyle: TextStyle(fontSize: 18.sp, color: text),
                    ),
                  ],
                  isRepeatingAnimation: false, // بدون تكرار
                ),
              ),
              SizedBox(height: 48.h),
              const SplachImage(),
              SizedBox(height: 20.h),
             const ButtonSplach(), // Space before the button
            ],
          ),
        ),
      ),
    );
  }
}
