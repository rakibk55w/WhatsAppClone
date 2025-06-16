import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';

import '../common/utils/colors.dart';

class TabletSearchBar extends StatelessWidget {
  const TabletSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDeviceUtils.getScreenHeight(context) * 0.075,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.dividerColor)),
      ),
      child: TextField(
        decoration: InputDecoration(
          fillColor: AppColors.searchBarColor,
          filled: true,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.search, size: 20),
          ),
          hintText: 'Search',
          hintStyle: const TextStyle(fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
    );
  }
}
