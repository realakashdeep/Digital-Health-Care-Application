class PatientHealthRecord {
  String? userId;
  String? fullName;
  String? dob;
  String? gender;
  String? address;
  String? phoneNumber;
  String? medicalConditions;
  String? surgicalHistory;
  String? familyHistory;
  String? allergies;
  String? height;
  String? weight;
  String? bloodPressure;
  String? heartRate;
  String? emergencyContactName;
  String? relationship;
  String? emergencyContactPhone;
  String? timeStamp;

  PatientHealthRecord({
    this.userId,
    this.fullName,
    this.dob,
    this.gender,
    this.address,
    this.phoneNumber,
    this.medicalConditions,
    this.surgicalHistory,
    this.familyHistory,
    this.allergies,
    this.height,
    this.weight,
    this.bloodPressure,
    this.heartRate,
    this.emergencyContactName,
    this.relationship,
    this.emergencyContactPhone,
    this.timeStamp
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'dob': dob,
      'gender': gender,
      'address': address,
      'phoneNumber': phoneNumber,
      'medicalConditions': medicalConditions,
      'surgicalHistory': surgicalHistory,
      'familyHistory': familyHistory,
      'allergies': allergies,
      'height': height,
      'weight': weight,
      'bloodPressure': bloodPressure,
      'heartRate': heartRate,
      'emergencyContactName': emergencyContactName,
      'relationship': relationship,
      'emergencyContactPhone': emergencyContactPhone,
      'timeStamp': timeStamp
    };
  }
  factory PatientHealthRecord.fromJson(Map<String, dynamic> json) {
    return PatientHealthRecord(
      userId: json['userId'],
      fullName: json['fullName'],
      dob: json['dob'],
      gender: json['gender'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      medicalConditions: json['medicalConditions'],
      surgicalHistory: json['surgicalHistory'],
      familyHistory: json['familyHistory'],
      allergies: json['allergies'],
      height: json['height'],
      weight: json['weight'],
      bloodPressure: json['bloodPressure'],
      heartRate: json['heartRate'],
      emergencyContactName: json['emergencyContactName'],
      relationship: json['relationship'],
      emergencyContactPhone: json['emergencyContactPhone'],
      timeStamp: json['timeStamp']
    );
  }
}
