import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/common/utils/colors.dart';
import 'package:whats_app_clone/info.dart';
import 'package:whats_app_clone/widgets/chat_list.dart';

import '../features/authentication/controller/authentication_controller.dart';

class MobileChatScreen extends ConsumerWidget {
  const MobileChatScreen({super.key, required this.name, required this.uid});

  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: StreamBuilder(
          stream: ref.read(authenticationControllerProvider).userData(uid),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return Text(name);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              //mainAxisSize: MainAxisSize.min,
              children: [
                Text(name),
                if (asyncSnapshot.data!.isOnline)
                  Text('online', style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),),
              ],
            );
          },
        ),
        backgroundColor: AppColors.appBarColor,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          /// Chat list
          Expanded(child: ChatList()),

          /// Text input box
          TextField(
            decoration: InputDecoration(
              fillColor: AppColors.mobileChatBoxColor,
              filled: true,
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.emoji_emotions, color: Colors.grey),
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.attach_file, color: Colors.grey),
                    Icon(Icons.camera_alt, color: Colors.grey),
                  ],
                ),
              ),
              hintText: 'Type a messsage',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              ),
              contentPadding: EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }
}
