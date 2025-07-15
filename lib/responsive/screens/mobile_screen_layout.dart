import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/common/utils/colors.dart';
import 'package:whats_app_clone/features/authentication/controller/authentication_controller.dart';
import 'package:whats_app_clone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whats_app_clone/features/chat/widgets/contacts_list.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state) {
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
            IconButton(
              onPressed: () {
                ref.read(authenticationControllerProvider).logout(context);
              },
              icon: const Icon(Icons.more_vert, color: AppColors.greyColor),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.tabColor,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 4,
            labelColor: AppColors.tabColor,
            unselectedLabelColor: AppColors.greyColor,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [Tab(text: 'CHATS'), Tab(text: 'STATUS'), Tab(text: 'CALLS')],
          ),
        ),
        body: const ContactsList(),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          onPressed:
              () =>
                  Navigator.pushNamed(context, SelectContactsScreen.routeName),
          backgroundColor: AppColors.tabColor,
          child: const Icon(Icons.comment, color: Colors.white),
        ),
      ),
    );
  }
}
