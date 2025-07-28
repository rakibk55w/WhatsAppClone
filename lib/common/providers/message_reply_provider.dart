import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/common/enums/message_enum.dart';

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);

class MessageReply{
  MessageReply(this.message, this.isMe, this.messageEnum);

  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

}