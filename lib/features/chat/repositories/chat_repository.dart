import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_app_clone/common/repositories/supabase_storage_repository.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/models/chat_contact_model.dart';
import 'package:whats_app_clone/models/group_model.dart';
import 'package:whats_app_clone/models/message_model.dart';

import '../../../common/enums/message_enum.dart';
import '../../../common/providers/message_reply_provider.dart';
import '../../../models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(supabase: Supabase.instance.client),
);

class ChatRepository {
  ChatRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<void> sendTextMessage({
    required String message,
    required String receiverId,
    required BuildContext context,
    required UserModel senderData,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiverData;

      if (!isGroupChat) {
        var userData =
            await supabase
                .from('users')
                .select()
                .eq('uid', receiverId)
                .single();
        receiverData = UserModel.fromJson(userData);
      } else {
        var groupData =
            await supabase
                .from('group')
                .select()
                .eq('groupId', receiverId)
                .single();
        receiverData = UserModel(
          name: groupData['groupName'],
          uid: groupData['groupId'],
          profilePic: groupData['groupPic'] ?? '',
          isOnline: false,
          phoneNumber: '',
          groupId: [],
        );
      }
      var messageId = const Uuid().v1();

      _saveMessageToMessageSubDatabase(
        receiverId: receiverId,
        text: message,
        timeSent: timeSent.toIso8601String(),
        messageId: messageId,
        senderName: senderData.name,
        receiverName: receiverData.name,
        messageType: MessageEnum.text,
        messageReply: messageReply,
      );
      _saveDataToContactSubDatabase(
        senderData,
        receiverData,
        message,
        timeSent.toIso8601String(),
        isGroupChat,
      );
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> _saveDataToContactSubDatabase(
    UserModel senderData,
    UserModel? receiverData,
    String text,
    String time,
    bool isGroupChat,
  ) async {
    if (kDebugMode) {
      print('Group CHat Status: $isGroupChat');
      print('Receiver Data: $receiverData');
    }
    if (isGroupChat) {
      await supabase
          .from('group')
          .update({
            'lastMessage': text,
            'timeSent': time,
            'lastSenderId': supabase.auth.currentUser!.id,
          })
          .eq('groupId', receiverData!.uid);
    } else {
      var response =
          await supabase
              .from('messages')
              .select('messageId,messageType')
              .or(
                """and(senderId.eq.${senderData.uid},receiverId.eq.${receiverData!.uid}),and(senderId.eq.${receiverData.uid},receiverId.eq.${senderData.uid})""",
              )
              .order('timeSent', ascending: false)
              .limit(1)
              .single();

      final existingChat =
          await supabase.from('chats').select().or(
            """and(senderId.eq.${senderData.uid},receiverId.eq.${receiverData.uid}),and(senderId.eq.${receiverData.uid},receiverId.eq.${senderData.uid})""",
          ).maybeSingle();

      if (existingChat != null) {
        await supabase
            .from('chats')
            .update({
              'messageId': response['messageId'],
              'receiverId': receiverData.uid,
              'senderId': senderData.uid,
              'last_message': text,
              'timeSent': time,
              'messageType': response['messageType'],
            })
            .or(
              """and(senderId.eq.${senderData.uid},receiverId.eq.${receiverData.uid}),and(senderId.eq.${receiverData.uid},receiverId.eq.${senderData.uid})""",
            );
      } else {
        await supabase.from('chats').upsert({
          'messageId': response['messageId'],
          'receiverId': receiverData.uid,
          'senderId': senderData.uid,
          'last_message': text,
          'timeSent': time,
          'messageType': response['messageType'],
        });
      }
    }
  }

  Future<void> _saveMessageToMessageSubDatabase({
    required String receiverId,
    required String text,
    required String timeSent,
    required String messageId,
    required String senderName,
    required String? receiverName,
    required MessageEnum messageType,
    required MessageReply? messageReply,
  }) async {
    await supabase.from('messages').insert({
      'messageId': messageId,
      'senderId': supabase.auth.currentUser!.id,
      'receiverId': receiverId,
      'message': text,
      'timeSent': timeSent,
      'isSeen': false,
      'messageType': messageType.type,
      'repliedMessage': messageReply == null ? '' : messageReply.message,
      'repliedTo':
          messageReply == null
              ? ''
              : messageReply.isMe
              ? senderName
              : receiverName ?? '',
      'repliedMessageType':
          messageReply == null ? '' : messageReply.messageEnum.type,
    });
  }

  Stream<List<ChatContactModel>> getChatContacts() {
    final currentUserId = supabase.auth.currentUser!.id;
    return supabase
        .from('chats')
        .stream(primaryKey: ['receiverId', 'senderId'])
        .order('timeSent', ascending: false)
        .asyncMap((rows) async {
          List<ChatContactModel> contacts = [];
          for (var row in rows) {
            if (row['senderId'] != currentUserId &&
                row['receiverId'] != currentUserId) {
              continue;
            }

            final contactId =
                row['senderId'] == currentUserId
                    ? row['receiverId']
                    : row['senderId'];

            final contactData =
                await supabase
                    .from('users')
                    .select('name, profilePic')
                    .eq('uid', contactId)
                    .single();

            contacts.add(
              ChatContactModel(
                name: contactData['name'],
                profilePic: contactData['profilePic'],
                contactId: contactId,
                timeSent: DateTime.parse(row['timeSent']),
                lastMessage: row['last_message'],
              ),
            );
          }
          return contacts;
        });
  }

  Stream<List<GroupModel>> getChatGroups() {
    return supabase.from('group').stream(primaryKey: ['groupId']).map((rows) {
      return rows.map((data) => GroupModel.fromJson(data)).toList();
    });
  }

  Stream<List<MessageModel>> getChatMessages(String receiverId) {
    final currentUserId = supabase.auth.currentUser!.id;
    return supabase
        .from('messages')
        .stream(primaryKey: ['messageId'])
        .order('timeSent', ascending: true)
        .asyncMap((rows) async {
          List<MessageModel> filteredMessages = [];

          for (var row in rows) {
            final isBetweenTwoUsers =
                (row['senderId'] == currentUserId &&
                    row['receiverId'] == receiverId) ||
                (row['senderId'] == receiverId &&
                    row['receiverId'] == currentUserId);

            if (isBetweenTwoUsers) {
              filteredMessages.add(MessageModel.fromJson(row));
            }
          }

          return filteredMessages;
        });
  }

  Stream<List<MessageModel>> getGroupChatMessages(String groupId) {
    return supabase
        .from('messages')
        .stream(primaryKey: ['messageId'])
        .order('timeSent', ascending: true)
        .asyncMap((rows) async {
          List<MessageModel> filteredMessages = [];

          for (var row in rows) {
            final isGroupChatMessage = row['receiverId'] == groupId;

            if (isGroupChatMessage) {
              filteredMessages.add(MessageModel.fromJson(row));
            }
          }

          return filteredMessages;
        });
  }

  Future<void> sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverId,
    required UserModel senderData,
    required Ref ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      UserModel? receiverData;

      if (!isGroupChat) {
        var userData =
            await supabase
                .from('users')
                .select()
                .eq('uid', receiverId)
                .single();
        receiverData = UserModel.fromJson(userData);
      }
      else {
        var groupData =
            await supabase
                .from('group')
                .select()
                .eq('groupId', receiverId)
                .single();
        receiverData = UserModel(
          name: groupData['groupName'],
          uid: groupData['groupId'],
          profilePic: groupData['groupPic'] ?? '',
          isOnline: false,
          phoneNumber: '',
          groupId: [],
        );
      }

      String fileUrl = await ref
          .read(commonSupabaseStorageRepositoryProvider)
          .storeFileToSupabase(
            bucket: 'media',
            path:
                '${messageEnum.type}/${senderData.uid}/$receiverId/$messageId',
            file: file,
          );

      String contactMsg;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '🎥 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
        case MessageEnum.text:
          contactMsg = 'Text';
          break;
      }

      _saveMessageToMessageSubDatabase(
        receiverId: receiverId,
        text: fileUrl,
        timeSent: timeSent.toIso8601String(),
        messageId: messageId,
        senderName: senderData.name,
        receiverName: receiverData.name,
        messageType: messageEnum,
        messageReply: messageReply,
      );

      _saveDataToContactSubDatabase(
        senderData,
        receiverData,
        contactMsg,
        timeSent.toIso8601String(),
        isGroupChat,
      );
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> sendGIFMessage({
    required String gifUrl,
    required String receiverId,
    required BuildContext context,
    required UserModel senderData,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiverData;

      if (!isGroupChat) {
        var userData =
            await supabase
                .from('users')
                .select()
                .eq('uid', receiverId)
                .single();
        receiverData = UserModel.fromJson(userData);
      }
      else {
        var groupData =
            await supabase
                .from('group')
                .select()
                .eq('groupId', receiverId)
                .single();
        receiverData = UserModel(
          name: groupData['groupName'],
          uid: groupData['groupId'],
          profilePic: groupData['groupPic'] ?? '',
          isOnline: false,
          phoneNumber: '',
          groupId: [],
        );
      }
      var messageId = const Uuid().v1();

      _saveMessageToMessageSubDatabase(
        receiverId: receiverId,
        text: gifUrl,
        timeSent: timeSent.toIso8601String(),
        messageId: messageId,
        senderName: senderData.name,
        receiverName: receiverData.name,
        messageType: MessageEnum.gif,
        messageReply: messageReply,
      );
      _saveDataToContactSubDatabase(
        senderData,
        receiverData,
        'GIF',
        timeSent.toIso8601String(),
        isGroupChat,
      );
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> setMessageSeenStatus(
    BuildContext context,
    String messageId,
  ) async {
    try {
      await supabase
          .from('messages')
          .update({'isSeen': true})
          .eq('messageId', messageId);
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: e.toString());
    }
  }
}
