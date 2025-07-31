class StatusModel {
  StatusModel({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.photoUrl,
    required this.createdAt,
    required this.profilePic,
    required this.statusId,
    required this.whoCanSee,
  });

  final String uid;
  final String username;
  final String phoneNumber;
  final List<String> photoUrl;
  final DateTime createdAt;
  final String profilePic;
  final String statusId;
  final List<String> whoCanSee;

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      uid: json['uid'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      photoUrl: json['photoUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      profilePic: json['profilePic'],
      statusId: json['statusId'],
      whoCanSee: json['whoCanSee'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'profilePic': profilePic,
      'statusId': statusId,
      'whoCanSee': whoCanSee,
    };
  }
}
