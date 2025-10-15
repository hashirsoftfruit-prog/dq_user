class BasicResponseModel {
  bool? status;
  String? message;
  String? token;
  int? userId;
  int? patientId;
  String? file;
  bool? isTimeLeft;
  // Map<String,dynamic>? data;

  BasicResponseModel({
    this.status,
    this.message,
    this.userId,
    this.file,
    this.isTimeLeft,
    this.patientId,
    // this.data
  });

  BasicResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    file = json['file'];
    userId = json['user_id'];
    message = json['message'].toString();
    token = json['token'].toString();
    isTimeLeft = json['is_time_left'];
    patientId = json['app_user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['file'] = file;
    data['is_time_left'] = isTimeLeft;
    data['user_id'] = userId;
    data['message'] = message;
    data['token'] = token;
    data['app_user_id'] = patientId;
    return data;
  }
}

class PatientsSaveResponseModel {
  bool? status;
  String? message;
  String? token;
  int? userId;

  PatientsSaveResponseModel({
    this.status,
    this.message,
    this.userId,
  });

  PatientsSaveResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userId = json['user_id'];
    message = json['message'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['user_id'] = userId;
    data['message'] = message;

    return data;
  }
}

class BasicListItem {
  int? id;
  String? item;

  // Map<String,dynamic>? data;

  BasicListItem({
    this.id,
    this.item,
  });

  BasicListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    item = json['item'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item'] = item;

    return data;
  }
}
