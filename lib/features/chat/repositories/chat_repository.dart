import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/models/message_model.dart';

import '../../../common/enums/message_enum.dart';
import '../../../models/user_model.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(supabase: Supabase.instance.client));

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
      _saveDataToContactSubDatabase(
        senderData,
        receiverData,
        message,
        timeSent,
      );
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
    var response =
        await supabase
            .from('messages')
            .select('messageId')
            .or("""
              and(senderId.eq.${senderData.uid},receiverId.eq.${receiverData.uid}),
              and(senderId.eq.${receiverData.uid},receiverId.eq.${senderData.uid})
            """)
            .order('timeSent', ascending: false)
            .limit(1)
            .maybeSingle();

    final existingChat =
        await supabase.from('chats').select().or("""
        and(senderId.eq.${senderData.uid},receiverId.eq.${receiverData.uid}),
            and(senderId.eq.${receiverData.uid},receiverId.eq.${senderData.uid})
            """).maybeSingle();

    if (existingChat != null) {
      await supabase
          .from('chats')
          .update({
            'messageId': response?['messageId'],
            'receiverId': receiverData.uid,
            'senderId': senderData.uid,
            'last_message': text,
            'timeSent': time,
          })
          .or("""
          and(senderId.eq.${senderData.uid},receiverId.eq.${receiverData.uid}),
          and(senderId.eq.${receiverData.uid},receiverId.eq.${senderData.uid})
          """);
    } else {
      await supabase.from('chats').upsert({
        'messageId': response?['messageId'],
        'receiverId': receiverData.uid,
        'senderId': senderData.uid,
        'last_message': text,
        'timeSent': time,
      });
    }
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
