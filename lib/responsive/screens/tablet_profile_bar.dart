import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/utils/colors.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';

class TabletProfileBar extends StatelessWidget {
  const TabletProfileBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDeviceUtils.getScreenHeight(context) * 0.077,
      width: AppDeviceUtils.getScreenWidth(context) * 0.25,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: AppColors.dividerColor
          )
        ),
        color: AppColors.webAppBarColor
      ),
    );
  }
}
