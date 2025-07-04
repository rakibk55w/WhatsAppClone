class UserModel {
  UserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
  });

  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final String phoneNumber;
  final List<String> groupId;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      uid: json['uid'] ?? '',
      profilePic: json['profilePic'] ?? '',
      isOnline: json['isOnline'] ?? false,
      phoneNumber: json['phoneNumber'] ?? '',
      groupId: List<String>.from(json['groupId']),
    );
  }
}
