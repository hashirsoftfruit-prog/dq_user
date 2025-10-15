class GetOtpModel {
  bool? status;
  int? otp;
  bool? existingUser;
  String? token;
  String? message;
  int? userId;
  int? patientId;
  String? firstName;
  String? lastName;
  String? language;

  GetOtpModel(
      {this.status,
      this.otp,
      this.message,
      this.existingUser,
      this.token,
      this.userId,
      this.firstName,
      this.lastName,
      this.language,
      this.patientId});

  GetOtpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    otp = json['otp'];
    message = json['message'];
    existingUser = json['existing_user'];
    token = json['token'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    language = json['language'];
    patientId = json['app_user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['otp'] = otp;
    data['message'] = message;
    data['existing_user'] = existingUser;
    data['token'] = token;
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['language'] = language;
    data['app_user_id'] = patientId;
    return data;
  }
}
