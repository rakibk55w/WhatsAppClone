import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whats_app_clone/common/utils/colors.dart';
import 'package:whats_app_clone/features/call/controller/call_controller.dart';
import 'package:whats_app_clone/features/call/screens/call_pickup_screen.dart';
import 'package:whats_app_clone/features/chat/widgets/chat_list.dart';

import '../../../common/providers/message_reply_provider.dart';
import '../../authentication/controller/authentication_controller.dart';
import '../widgets/bottom_chat_field.dart';
import '../widgets/message_reply_preview.dart';

class MobileChatScreen extends ConsumerWidget {
  const MobileChatScreen({super.key, 
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
  });

  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallPickupScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title:
              isGroupChat
                  ? Text(name)
                  : StreamBuilder(
                    stream: ref
                        .read(authenticationControllerProvider)
                        .userData(uid),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Text(name);
                      }
                      if (asyncSnapshot.hasError) {
                        return Center(
                          child: Text('Error: ${asyncSnapshot.error}'),
                        );
                      }
      
                      if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
                        return const Center(child: Text('No data found'));
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(name),
                          if (asyncSnapshot.data!.isOnline)
                            const Text(
                              'online',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
          backgroundColor: AppColors.appBarColor,
          actions: [
            IconButton(onPressed: () => makeCall(context, ref), icon: const Icon(Icons.video_call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        body: Column(
          children: [
            /// Chat list
            Expanded(child: ChatList(receiverId: uid, isGroupChat: isGroupChat)),
      
            Consumer(
              builder: (context, ref, _) {
                final messageReply = ref.watch(messageReplyProvider);
                if (messageReply != null) {
                  return const MessageReplyPreview();
                }
                return const SizedBox.shrink();
              },
            ),
      
            /// Text input box
            BottomChatField(receiverId: uid, isGroupChat: isGroupChat),
          ],
        ),
      ),
    );
  }

  void makeCall(BuildContext context, WidgetRef ref) {
    ref.read(callControllerProvider).createCall(
          context,
          uid,
          name,
          profilePic,
          isGroupChat,
        );
  }
}
