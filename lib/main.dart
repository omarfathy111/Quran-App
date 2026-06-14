import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'features/splach/screens/splash_screen.dart';
import 'features/splach/widgets/audio_provider.dart'; // تأكد من استيراد ملف AudioProvider

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioProvider()), // توفير AudioProvider
      ],
      child: DevicePreview(
        enabled: !kReleaseMode, // تفعيل DevicePreview في وضع التطوير فقط
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light); // تخصيص لون واجهة النظام

    return ScreenUtilInit(
      designSize: const Size(360, 690), // ضبط حجم التصميم
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          locale: DevicePreview.locale(context), // استخدام اللغة المحددة في DevicePreview
          builder: DevicePreview.appBuilder, // استخدام بنية DevicePreview
          title: 'Quran App', // تغيير عنوان التطبيق
          theme: ThemeData(
            primarySwatch: Colors.blue, // تخصيص لون الثيم
          ),
          debugShowCheckedModeBanner: false, // إخفاء علامة وضع التصحيح
          home: const SplashScreen(), // شاشة البداية
        );
      },
    );
  }
}
