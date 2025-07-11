import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/models/chat_contact_model.dart';
import 'package:whats_app_clone/models/message_model.dart';

import '../../../common/enums/message_enum.dart';
import '../../../models/user_model.dart';

class ChatRepository {
  ChatRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<void> sendTextMessage({
    required String message,
    required String receiverId,
    required BuildContext context,
    required UserModel senderData,
  }) async {
    try {
      var timeSent = DateTime.now();

      var userData =
          await supabase.from('users').select().eq('uid', receiverId).single();
      UserModel receiverData = UserModel.fromJson(userData);
      var messageId = const Uuid().v1();

      _saveMessageToMessageSubDatabase(
        receiverId: receiverId,
        text: message,
        timeSent: timeSent,
        messageId: messageId,
        senderName: senderData.name,
        receiverName: receiverData.name,
        messageType: MessageEnum.text,
      );
      _saveDataToContactSubDatabase(senderData, receiverData, message, timeSent);
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: e.toString());
    }
  }

  void _saveDataToContactSubDatabase(
    UserModel senderData,
    UserModel receiverData,
    String text,
    DateTime time,
  ) async {
    // var receiverChatContact = ChatContactModel(
    //   name: senderData.name,
    //   profilePic: senderData.profilePic,
    //   contactId: senderData.uid,
    //   timeSent: time,
    //   lastMessage: text,
    // );

    await supabase.from('chats').upsert({
      'receiver_id': receiverData.uid,
      'sender_id': supabase.auth.currentUser!.id,
      'last_message': text,
      'timestamp': time,
      //...receiverChatContact.toJson(),
    });

    // var senderChatContact = ChatContactModel(
    //   name: receiverData.name,
    //   profilePic: receiverData.profilePic,
    //   contactId: receiverData.uid,
    //   timeSent: time,
    //   lastMessage: text,
    // );
    //
    // await supabase.from('chats').upsert({
    //   'receiver_id': supabase.auth.currentUser!.id,
    //   'sender_id': receiverData.uid,
    //   ...senderChatContact.toJson(),
    // });
  }

  void _saveMessageToMessageSubDatabase({
    required String receiverId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String senderName,
    required String receiverName,
    required MessageEnum messageType,
  }) async {
    final message = MessageModel(
      senderId: supabase.auth.currentUser!.id,
      receiverId: receiverId,
      message: text,
      messageType: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );

    await supabase.from('messages').insert({
      'messageId': message.messageId,
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'message': message.message,
      'timeSent': message.timeSent,
      'isSeen': message.isSeen,
    });

  }
}
