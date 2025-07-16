import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/features/authentication/controller/authentication_controller.dart';
import 'package:whats_app_clone/features/chat/repositories/chat_repository.dart';
import 'package:whats_app_clone/models/message_model.dart';

import '../../../common/enums/message_enum.dart';
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

  void sendTextMessage(BuildContext context, String text, String receiverId) {
    ref
        .read(userDataAuthProvider)
        .whenData(
          (value) => chatRepository.sendTextMessage(
            message: text,
            receiverId: receiverId,
            context: context,
            senderData: value!,
          ),
        );
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverId,
    MessageEnum messageEnum,
  ) {
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
          ),
        );
  }

  Stream<List<ChatContactModel>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<MessageModel>> getChatMessages(String receiverId) {
    return chatRepository.getChatMessages(receiverId);
  }
}
