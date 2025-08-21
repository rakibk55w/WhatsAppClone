import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/features/authentication/controller/authentication_controller.dart';
import 'package:whats_app_clone/features/chat/repositories/chat_repository.dart';
import 'package:whats_app_clone/models/group_model.dart';
import 'package:whats_app_clone/models/message_model.dart';

import '../../../common/enums/message_enum.dart';
import '../../../common/providers/message_reply_provider.dart';
import '../../../models/chat_contact_model.dart';

final chatControllerProvider = Provider(
  (ref) => ChatController(
    chatRepository: ref.watch(chatRepositoryProvider),
    ref: ref,
  ),
);

class ChatController {
  ChatController({required this.chatRepository, required this.ref});

  final ChatRepository chatRepository;
  final Ref ref;

  void sendTextMessage(BuildContext context, String text, String receiverId, bool isGroupChat) {
    final messageReply = ref.read(messageReplyProvider);
    ref
        .read(userDataAuthProvider)
        .whenData(
          (value) => chatRepository.sendTextMessage(
            message: text,
            receiverId: receiverId,
            context: context,
            senderData: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messageReplyProvider.notifier).state = null;
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverId,
    MessageEnum messageEnum,
    bool isGroupChat
  ) {
    final messageReply = ref.read(messageReplyProvider);

    ref
        .read(userDataAuthProvider)
        .whenData(
          (value) => chatRepository.sendFileMessage(
            file: file,
            messageEnum: messageEnum,
            ref: ref,
            receiverId: receiverId,
            context: context,
            senderData: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messageReplyProvider.notifier).state = null;
  }

  void sendGIFMessage(BuildContext context, String url, String receiverId, bool isGroupChat) {
    int gifUrlIndex = url.lastIndexOf('-') + 1;
    String gifUrlPart = url.substring(gifUrlIndex);
    String newGifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    final messageReply = ref.read(messageReplyProvider);

    ref
        .read(userDataAuthProvider)
        .whenData(
          (value) => chatRepository.sendGIFMessage(
            gifUrl: newGifUrl,
            receiverId: receiverId,
            context: context,
            senderData: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messageReplyProvider.notifier).state = null;
  }

  Stream<List<ChatContactModel>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<GroupModel>> getChatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<MessageModel>> getChatMessages(String receiverId) {
    return chatRepository.getChatMessages(receiverId);
  }

  Stream<List<MessageModel>> getGroupChatMessages(String groupId) {
    return chatRepository.getGroupChatMessages(groupId);
  }

  void setMessageSeenStatus(BuildContext context, String messageId) {
    chatRepository.setMessageSeenStatus(context, messageId);
  }
}
