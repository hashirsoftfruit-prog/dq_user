class PatientsDetailsModel {
  bool? status;
  UserDetails? userDetails;
  List<UserDetails>? userRelations;

  PatientsDetailsModel({this.status, this.userDetails, this.userRelations});

  PatientsDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userDetails = json['user_details'] != null
        ? UserDetails.fromJson(json['user_details'])
        : null;
    if (json['user_relations'] != null) {
      userRelations = <UserDetails>[];
      json['user_relations'].forEach((v) {
        userRelations!.add(UserDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (userDetails != null) {
      data['user_details'] = userDetails!.toJson();
    }
    if (userRelations != null) {
      data['user_relations'] = userRelations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Documents {
  int? id;
  String? file;

  Documents({this.id, this.file});

  Documents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['file'] = file;
    return data;
  }
}

class UserDetails {
  int? id;
  int? appUserId;
  int? userId;
  String? relation;
  String? firstName;
  String? lastName;
  String? gender;
  String? maritalStatus;
  String? dateOfBirth;
  String? age;
  bool? isPackageOptedUser;
  String? height;
  String? weight;
  String? bloodGroup;
  String? bloodSugar;
  String? bloodPressure;
  String? serumCreatinine;
  List<Documents>? documents;

  UserDetails(
      {this.id,
      this.userId,
      this.appUserId,
      this.relation,
      this.firstName,
      this.lastName,
      this.gender,
      this.maritalStatus,
      this.dateOfBirth,
      this.age,
      this.isPackageOptedUser,
      this.height,
      this.weight,
      this.bloodGroup,
      this.bloodSugar,
      this.bloodPressure,
      this.serumCreatinine,
      this.documents});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    appUserId = json['app_user_id'];
    relation = json['relation'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    maritalStatus = json['marital_status'];
    dateOfBirth = json['date_of_birth'];
    isPackageOptedUser = json['is_package_opted_user'];
    age = json['age']?.toString();
    height = json['height']?.toString();
    weight = json['weight']?.toString();
    bloodGroup = json['blood_group'];
    bloodSugar = json['blood_sugar']?.toString();
    bloodPressure = json['blood_pressure']?.toString();
    serumCreatinine = json['serum_creatinine']?.toString();
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['app_user_id'] = appUserId;
    data['relation'] = relation;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['gender'] = gender;
    data['marital_status'] = maritalStatus;
    data['date_of_birth'] = dateOfBirth;
    data['is_package_opted_user'] = isPackageOptedUser;
    data['age'] = age;
    data['height'] = height;
    data['weight'] = weight;
    data['blood_group'] = bloodGroup;
    data['blood_sugar'] = bloodSugar;
    data['blood_pressure'] = bloodPressure;
    data['serum_creatinine'] = serumCreatinine;
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
