class UserBasicInfo {
  String? userId;
  String? fullName;
  String? gender;
  String? dob;
  String? phoneNumber;
  String? lastUpdated;

  UserBasicInfo({
    this.userId,
    this.fullName,
    this.gender,
    this.dob,
    this.phoneNumber,
    this.lastUpdated
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'gender' : gender,
      'dob' : dob,
      'phoneNumber' : phoneNumber,
      'timeStamp': lastUpdated
    };
  }
  factory UserBasicInfo.fromJson(Map<String, dynamic> json) {
    return UserBasicInfo(
        userId: json['userId'],
        fullName: json['fullName'],
        gender: json['gender'],
        dob: json['dob'],
        phoneNumber: json['phoneNumber'],
        lastUpdated: json['lastUpdated']
    );
  }
}
