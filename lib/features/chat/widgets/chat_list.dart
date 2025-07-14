import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whats_app_clone/common/widgets/loader.dart';
import 'package:whats_app_clone/features/chat/controller/chat_controller.dart';
import 'package:whats_app_clone/models/message_model.dart';
import 'package:whats_app_clone/widgets/my_message_card.dart';
import 'package:whats_app_clone/widgets/sender_message_card.dart';

class ChatList extends ConsumerWidget {
  const ChatList({super.key, required this.receiverId});

  final String receiverId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<MessageModel>>(
      stream: ref.watch(chatControllerProvider).getChatMessages(receiverId),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return ListView.builder(
          itemCount: asyncSnapshot.data!.length,
          itemBuilder: (context, index) {
            if (asyncSnapshot.data![index].senderId != receiverId) {
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
