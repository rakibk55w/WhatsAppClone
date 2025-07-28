import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whats_app_clone/common/enums/message_enum.dart';
import 'package:whats_app_clone/common/widgets/loader.dart';
import 'package:whats_app_clone/features/chat/controller/chat_controller.dart';
import 'package:whats_app_clone/models/message_model.dart';
import 'package:whats_app_clone/features/chat/widgets/my_message_card.dart';
import 'package:whats_app_clone/features/chat/widgets/sender_message_card.dart';

import '../../../common/providers/message_reply_provider.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({super.key, required this.receiverId});

  final String receiverId;

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(String message, bool isMe, MessageEnum messageEnum) {
    ref
        .read(messageReplyProvider.notifier)
        .state = MessageReply(message, isMe, messageEnum);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream: ref
          .watch(chatControllerProvider)
          .getChatMessages(widget.receiverId),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        if (asyncSnapshot.hasError) {
          return Center(child: Text('Error: ${asyncSnapshot.error}'));
        }

        if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
          return const Center(child: Text('No data found'));
        }

        SchedulerBinding.instance.addPostFrameCallback(
          (_) => messageController.jumpTo(
            messageController.position.maxScrollExtent,
          ),
        );
        return ListView.builder(
          controller: messageController,
          itemCount: asyncSnapshot.data!.length,
          itemBuilder: (context, index) {
            var messageData = asyncSnapshot.data![index];
            if (messageData.senderId != widget.receiverId) {
              return MyMessageCard(
                message: messageData.message,
                date: DateFormat.jm().format(messageData.timeSent).toString(),
                type: messageData.messageType,
                repliedText: messageData.repliedMessage,
                username: messageData.repliedTo,
                repliedType: messageData.repliedMessageType,
                onSwipe: () => onMessageSwipe(messageData.message, true, messageData.messageType),
              );
            }
            return SenderMessageCard(
              message: messageData.message,
              date: DateFormat.jm().format(messageData.timeSent).toString(),
              type: messageData.messageType,
              repliedText: messageData.repliedMessage,
              username: messageData.repliedTo,
              repliedType: messageData.repliedMessageType,
              onSwipe: () => onMessageSwipe(messageData.message, false, messageData.messageType),
            );
          },
        );
      },
    );
  }
}
