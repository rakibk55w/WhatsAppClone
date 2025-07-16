import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whats_app_clone/common/widgets/loader.dart';
import 'package:whats_app_clone/features/chat/controller/chat_controller.dart';
import 'package:whats_app_clone/models/message_model.dart';
import 'package:whats_app_clone/features/chat/widgets/my_message_card.dart';
import 'package:whats_app_clone/features/chat/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({super.key, required this.receiverId,});

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
        stream: ref.watch(chatControllerProvider).getChatMessages(widget.receiverId),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) => messageController.jumpTo(messageController.position.maxScrollExtent));
          return ListView.builder(
            controller: messageController,
            itemCount: asyncSnapshot.data!.length,
            itemBuilder: (context, index) {
              if (asyncSnapshot.data![index].senderId != widget.receiverId) {
                return MyMessageCard(
                  message: asyncSnapshot.data![index].message,
                  date: DateFormat.jm().format(asyncSnapshot.data![index].timeSent).toString(),
                );
              }
              return SenderMessageCard(
                message: asyncSnapshot.data![index].message,
                date: DateFormat.jm().format(asyncSnapshot.data![index].timeSent).toString(),
              );
            },
          );
        }
    );
  }
}