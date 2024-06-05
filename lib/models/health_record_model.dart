class PatientHealthRecord {
  String? userId;
  String? fullName;
  String? gender;
  String? dob;
  String? phoneNumber;
  String? medicalConditions;
  String? surgicalHistory;
  String? familyHistory;
  String? allergies;
  String? height;
  String? weight;
  String? emergencyContactName;
  String? relationship;
  String? emergencyContactPhone;
  String? lastUpdated;

  PatientHealthRecord({
    this.userId,
    this.fullName,
    this.gender,
    this.dob,
    this.phoneNumber,
    this.medicalConditions,
    this.surgicalHistory,
    this.familyHistory,
    this.allergies,
    this.height,
    this.weight,
    this.emergencyContactName,
    this.relationship,
    this.emergencyContactPhone,
    this.lastUpdated
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'gender' : gender,
      'dob' : dob,
      'phoneNumber' : phoneNumber,
      'medicalConditions': medicalConditions,
      'surgicalHistory': surgicalHistory,
      'familyHistory': familyHistory,
      'allergies': allergies,
      'height': height,
      'weight': weight,
      'emergencyContactName': emergencyContactName,
      'relationship': relationship,
      'emergencyContactPhone': emergencyContactPhone,
      'timeStamp': lastUpdated
    };
  }
  factory PatientHealthRecord.fromJson(Map<String, dynamic> json) {
    return PatientHealthRecord(
      userId: json['userId'],
      fullName: json['fullName'],
      gender: json['gender'],
      dob: json['dob'],
      phoneNumber: json['phoneNumber'],
      medicalConditions: json['medicalConditions'],
      surgicalHistory: json['surgicalHistory'],
      familyHistory: json['familyHistory'],
      allergies: json['allergies'],
      height: json['height'],
      weight: json['weight'],
      emergencyContactName: json['emergencyContactName'],
      relationship: json['relationship'],
      emergencyContactPhone: json['emergencyContactPhone'],
      lastUpdated: json['lastUpdated']
    );
  }
}
