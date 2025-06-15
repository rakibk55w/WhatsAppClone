import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/widgets/error.dart';
import 'package:whats_app_clone/features/authentication/screens/login_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    default:
      return MaterialPageRoute(
        builder:
            (context) => const Scaffold(
              body: ErrorScreen(error: 'This page is currently unavailable!'),
            ),
      );
  }
}
