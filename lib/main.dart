import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/utils/colors.dart';
import 'package:whats_app_clone/responsive/screens/mobile_screen_layout.dart';
import 'package:whats_app_clone/router.dart';

import 'features/landing/screens/landing_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.backgroundColor
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const MobileScreenLayout(),
    );
  }
}



