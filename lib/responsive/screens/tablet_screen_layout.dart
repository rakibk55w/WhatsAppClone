import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/features/chat/widgets/chat_list.dart';
import 'package:whats_app_clone/widgets/tablet_profile_bar.dart';
import 'package:whats_app_clone/features/chat/widgets/contacts_list.dart';
import 'package:whats_app_clone/widgets/tablet_search_bar.dart';

import '../../common/utils/colors.dart';
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
                  Expanded(child: ChatList(receiverId: '',)),

                  /// Message input box
                  Container(
                    height: AppDeviceUtils.getScreenHeight(context) * 0.08,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.dividerColor),
                      ),
                      color: AppColors.chatBarMessage,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 15),
                            child: TextField(
                              decoration: InputDecoration(
                                fillColor: AppColors.searchBarColor,
                                filled: true,
                                hintText: 'Type a message',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(left: 20),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.mic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
