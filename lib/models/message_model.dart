import '../common/enums/message_enum.dart';

class MessageModel {
  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.messageType,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
  });

  final String senderId;
  final String receiverId;
  final String text;
  final MessageEnum messageType;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      text: json['text'] ?? '',
      messageType: (json['messageType'] as String).toEnum(),
      timeSent: json['timeSent'] ?? '',
      messageId: json['messageId'] ?? '',
      isSeen: json['isSeen'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'messageType': messageType.type,
      'timeSent': timeSent,
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }
}
