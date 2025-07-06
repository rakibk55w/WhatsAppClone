import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whats_app_clone/common/utils/colors.dart';
import 'package:whats_app_clone/common/widgets/loader.dart';
import 'package:whats_app_clone/features/authentication/controller/authentication_controller.dart';
import 'package:whats_app_clone/responsive/screens/mobile_screen_layout.dart';
import 'package:whats_app_clone/router.dart';

import 'common/env/env.dart';
import 'common/widgets/error.dart';
import 'features/landing/screens/landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zagbwjiburabqeydosma.supabase.co',
    anonKey: Env.apiKey,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.backgroundColor,
        appBarTheme: const AppBarTheme(color: AppColors.appBarColor),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref
          .watch(userDataAuthProvider)
          .when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileScreenLayout();
            },
            error: (err, trace) {
              return ErrorScreen(error: err.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
