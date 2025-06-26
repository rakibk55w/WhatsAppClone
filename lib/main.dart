import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whats_app_clone/common/utils/colors.dart';
import 'package:whats_app_clone/responsive/responsive_layout.dart';
import 'package:whats_app_clone/responsive/screens/mobile_screen_layout.dart';
import 'package:whats_app_clone/responsive/screens/tablet_screen_layout.dart';
import 'package:whats_app_clone/router.dart';

import 'common/env/env.dart';
import 'features/landing/screens/landing_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: 'https://zagbwjiburabqeydosma.supabase.co', anonKey: Env.apiKey);
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
      home: const LandingScreen(),
    );
  }
}



