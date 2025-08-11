import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/widgets/error.dart';
import 'package:whats_app_clone/features/authentication/screens/login_screen.dart';
import 'package:whats_app_clone/features/authentication/screens/otp_screen.dart';
import 'package:whats_app_clone/features/authentication/screens/user_information_screen.dart';
import 'package:whats_app_clone/features/group/screens/create_group_screen.dart';
import 'package:whats_app_clone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whats_app_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whats_app_clone/features/status/screens/status_screen.dart';
import 'package:whats_app_clone/models/status_model.dart';

import 'features/status/screens/confirm_status_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    case OtpScreen.routeName:
      final String phoneNumber = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OtpScreen(phoneNumber: phoneNumber),
      );

    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );

    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );

    case MobileChatScreen.routeName:
      final Map<String, dynamic> args =
          settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder:
            (context) => MobileChatScreen(name: args['name'], uid: args['uid']),
      );

    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(file: file),
      );

    case StatusScreen.routeName:
      final StatusModel status = settings.arguments as StatusModel;
      return MaterialPageRoute(
        builder: (context) => StatusScreen(status: status),
      );

    case CreateGroupScreen.routeName:
      return MaterialPageRoute(builder: (context) => const CreateGroupScreen());

    default:
      return MaterialPageRoute(
        builder:
            (context) => const Scaffold(
              body: ErrorScreen(error: 'This page is currently unavailable!'),
            ),
      );
  }
}
