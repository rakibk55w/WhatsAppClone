import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/utils/colors.dart';
import 'package:whats_app_clone/info.dart';

import '../common/utils/device_utility.dart';

class TabletChatAppbar extends StatelessWidget {
  const TabletChatAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDeviceUtils.getScreenHeight(context) * 0.077,
      width: AppDeviceUtils.getScreenWidth(context) * 0.75,
      padding: const EdgeInsets.all(10),
      color: AppColors.webAppBarColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/8/85/Elon_Musk_Royal_Society_%28crop1%29.jpg',
                ),
              ),
              SizedBox(width: AppDeviceUtils.getScreenWidth(context) * 0.01,),
              Text(info[0]['name'].toString(), style: const TextStyle(fontSize: 18),)
            ],
          ),
          Row(
            children: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.search, color: Colors.grey,)),
              IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert, color: Colors.grey,)),
            ],
          )
        ],
      ),
    );
  }
}
