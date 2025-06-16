import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/utils/colors.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';

class TabletProfileBar extends StatelessWidget {
  const TabletProfileBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDeviceUtils.getScreenHeight(context) * 0.077,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: AppColors.dividerColor
          )
        ),
        color: AppColors.webAppBarColor
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/8/85/Elon_Musk_Royal_Society_%28crop1%29.jpg'),
          ),
          Row(
            children: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.comment, color: AppColors.greyColor,)),
              IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert, color: AppColors.greyColor,)),
            ],
          ),
        ],
      ),
    );
  }
}
