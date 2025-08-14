class GroupModel {
  GroupModel({
    required this.groupName,
    required this.groupId,
    required this.groupCoverPic,
    required this.members,
    required this.lastSenderId,
    required this.lastMessage,
  });

  final String groupName;
  final String groupId;
  final String groupCoverPic;
  final List<String> members;
  final String lastSenderId;
  final String lastMessage;

  Map<String, dynamic> toJson() {
    return {
      'groupName': groupName,
      'groupId': groupId,
      'groupCoverPic': groupCoverPic,
      'members': members,
      'lastSenderId': lastSenderId,
      'lastMessage': lastMessage,
    };
  }

  factory GroupModel.fromJson(Map<String, dynamic> map) {
    return GroupModel(
      groupName: map['groupName'] ?? '',
      groupId: map['groupId'] ?? '',
      groupCoverPic: map['groupCoverPic'] ?? '',
      members: List<String>.from(map['members']),
      lastSenderId: map['lastSenderId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
    );
  }
}
