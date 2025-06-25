import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/widgets/chat_list.dart';
import 'package:whats_app_clone/widgets/tablet_profile_bar.dart';
import 'package:whats_app_clone/widgets/contacts_list.dart';
import 'package:whats_app_clone/widgets/tablet_search_bar.dart';

import '../../widgets/tablet_chat_appbar.dart';

class TabletScreenLayout extends StatelessWidget {
  const TabletScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 400,
              maxWidth: max(400, AppDeviceUtils.getScreenWidth(context) * 0.25),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// Tab profile
                  TabletProfileBar(),

                  /// Tab search
                  TabletSearchBar(),

                  /// Chat list
                  ContactsList(),
                ],
              ),
            ),
          ),

          /// Message screen
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/backgroundImage.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  /// Chat appbar
                  TabletChatAppbar(),

                  /// Chat list
                  Expanded(child: ChatList()),
                  /// Message input box
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
