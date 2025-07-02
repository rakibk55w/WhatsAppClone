import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/widgets/error.dart';
import 'package:whats_app_clone/features/authentication/screens/login_screen.dart';
import 'package:whats_app_clone/features/authentication/screens/otp_screen.dart';
import 'package:whats_app_clone/features/authentication/screens/user_information_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    case OtpScreen.routeName:
      final String phoneNumber = settings.arguments as String;
      return MaterialPageRoute(builder: (context) => OtpScreen(phoneNumber: phoneNumber));

    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (context) => const UserInformationScreen());

    default:
      return MaterialPageRoute(
        builder:
            (context) => const Scaffold(
              body: ErrorScreen(error: 'This page is currently unavailable!'),
            ),
      );
  }
}
