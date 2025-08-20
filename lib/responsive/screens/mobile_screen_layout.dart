import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/common/utils/colors.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/features/authentication/controller/authentication_controller.dart';
import 'package:whats_app_clone/features/group/screens/create_group_screen.dart';
import 'package:whats_app_clone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whats_app_clone/features/chat/widgets/contacts_list.dart';
import 'package:whats_app_clone/features/status/screens/confirm_status_screen.dart';
import 'package:whats_app_clone/features/status/screens/status_contacts_screen.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authenticationControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
        ref.read(authenticationControllerProvider).setUserState(false);
        break;
      case AppLifecycleState.detached:
        ref.read(authenticationControllerProvider).setUserState(false);
        break;
      case AppLifecycleState.paused:
        ref.read(authenticationControllerProvider).setUserState(false);
        break;
      case AppLifecycleState.hidden:
        ref.read(authenticationControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: AppColors.appBarColor,
          elevation: 0,
          title: const Text(
            'WhatsApp',
            style: TextStyle(
              color: AppColors.greyColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: AppColors.greyColor),
            ),
            PopupMenuButton(
              icon: Icon(Icons.more_vert, color: AppColors.greyColor),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: const Text('Create Group'),
                    onTap: () {
                      Future(
                        () => Navigator.pushNamed(
                          context,
                          CreateGroupScreen.routeName,
                        ),
                      );
                    },
                  ),
                ];
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: AppColors.tabColor,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 4,
            controller: tabController,
            labelColor: AppColors.tabColor,
            unselectedLabelColor: AppColors.greyColor,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [Tab(text: 'CHATS'), Tab(text: 'STATUS'), Tab(text: 'CALLS')],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            const ContactsList(),
            const StatusContactsScreen(),
            const Text('Calls'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () async {
            if (kDebugMode) {
              print(
                'Floating Action Button Pressed, index: ${tabController.index}',
              );
            }
            if (tabController.index == 0) {
              Navigator.pushNamed(context, SelectContactsScreen.routeName);
            } else {
              File? pickedImage = await AppDeviceUtils.pickImageFromGallery(
                context,
              );
              if (pickedImage != null) {
                Navigator.pushNamed(
                  context,
                  ConfirmStatusScreen.routeName,
                  arguments: pickedImage,
                );
              }
            }
          },
          backgroundColor: AppColors.tabColor,
          child: const Icon(Icons.comment, color: Colors.white),
        ),
      ),
    );
  }
}
