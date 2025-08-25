class CallModel {
  final String callerId;
  final String callerName;
  final String callerImage;
  final String receiverId;
  final String receiverName;
  final String receiverImage;
  final String callId;
  final bool callOngoing;

  CallModel({
    required this.callerId,
    required this.callerName,
    required this.callerImage,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
    required this.callId,
    required this.callOngoing,
  });

  Map<String, dynamic> toMap() {
    return {
      'callerId': callerId,
      'callerName': callerName,
      'callerImage': callerImage,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverImage': receiverImage,
      'callId': callId,
      'callOngoing': callOngoing,
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      callerId: map['callerId'] ?? '',
      callerName: map['callerName'] ?? '',
      callerImage: map['callerImage'] ?? '',
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverImage: map['receiverImage'] ?? '',
      callId: map['callId'] ?? '',
      callOngoing: map['callOngoing'] ?? true,
    );
  }
}
