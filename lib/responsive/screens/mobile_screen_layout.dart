import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/utils/colors.dart';
import 'package:whats_app_clone/widgets/contacts_list.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({super.key});

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
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: AppColors.greyColor),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.tabColor,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 4,
            labelColor: AppColors.tabColor,
            unselectedLabelColor: AppColors.greyColor,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [Tab(text: 'CHATS'), Tab(text: 'STATUS'), Tab(text: 'CALLS')],
          ),
        ),
        body: ContactsList(),
      ),
    );
  }
}
