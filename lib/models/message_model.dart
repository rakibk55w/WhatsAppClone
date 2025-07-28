import '../common/enums/message_enum.dart';

class MessageModel {
  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.messageType,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  final String senderId;
  final String receiverId;
  final String message;
  final MessageEnum messageType;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      message: json['message'] ?? '',
      messageType: (json['messageType'] as String).toEnum(),
      timeSent: DateTime.parse(json['timeSent']),
      messageId: json['messageId'] ?? '',
      isSeen: json['isSeen'] ?? false,
      repliedMessage: json['repliedMessage'] ?? '',
      repliedTo: json['repliedTo'] ?? '',
      repliedMessageType: (json['repliedMessageType'] as String).toEnum(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': message,
      'messageType': messageType.type,
      'timeSent': timeSent.toIso8601String(),
      'messageId': messageId,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.type
    };
  }
}
