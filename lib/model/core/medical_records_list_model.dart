class MedicalRecordsUsersModel {
  bool? status;
  String? message;
  List<UserItem>? userDetails;

  MedicalRecordsUsersModel({this.status, this.message, this.userDetails});

  MedicalRecordsUsersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['user_details'] != null) {
      userDetails = <UserItem>[];
      json['user_details'].forEach((v) {
        userDetails!.add(UserItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (userDetails != null) {
      data['user_details'] = userDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserItem {
  int? id;
  String? firstName;
  String? lastName;
  String? image;
  int? medicalRecordsCount;

  UserItem(
      {this.id,
      this.firstName,
      this.lastName,
      this.image,
      this.medicalRecordsCount});

  UserItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    image = json['image'];
    medicalRecordsCount = json['medical_records_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['image'] = image;
    data['medical_records_count'] = medicalRecordsCount;
    return data;
  }
}

// \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

class MedicalRecordsModel {
  bool? status;
  String? message;
  int? appUserId;
  String? appUserName;
  List<MedicalRecordDetails>? medicalRecordDetails;

  MedicalRecordsModel(
      {this.status,
      this.message,
      this.appUserId,
      this.appUserName,
      this.medicalRecordDetails});

  MedicalRecordsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    appUserId = json['app_user_id'];
    appUserName = json['app_user_name'];
    if (json['medical_record_details'] != null) {
      medicalRecordDetails = <MedicalRecordDetails>[];
      json['medical_record_details'].forEach((v) {
        medicalRecordDetails!.add(MedicalRecordDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['app_user_id'] = appUserId;
    data['app_user_name'] = appUserName;
    if (medicalRecordDetails != null) {
      data['medical_record_details'] =
          medicalRecordDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicalRecordDetails {
  int? id;
  String? file;
  String? createdDate;
  String? typeOfRecord;

  MedicalRecordDetails(
      {this.id, this.file, this.createdDate, this.typeOfRecord});

  MedicalRecordDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    file = json['file'];
    createdDate = json['created_date'];
    typeOfRecord = json['type_of_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['file'] = file;
    data['created_date'] = createdDate;
    data['type_of_file'] = typeOfRecord;
    return data;
  }
}
