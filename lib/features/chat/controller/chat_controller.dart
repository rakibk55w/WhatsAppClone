import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/features/authentication/controller/authentication_controller.dart';
import 'package:whats_app_clone/features/chat/repositories/chat_repository.dart';

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
}
