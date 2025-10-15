class ForumDetailsModel {
  bool? status;
  String? message;
  ForumDetails? forumDetails;

  ForumDetailsModel({this.status, this.message, this.forumDetails});

  ForumDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    forumDetails = json['forum_details'] != null
        ? ForumDetails.fromJson(json['forum_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (forumDetails != null) {
      data['forum_details'] = forumDetails!.toJson();
    }
    return data;
  }
}

class ForumDetails {
  int? id;
  String? title;
  String? description;
  String? file;
  String? treatmentType;
  String? userType;
  int? forumUser;
  String? forumStatus;
  int? viewCount;
  bool? selfForum;
  bool? isAlreadyResponded;
  bool? editable;

  int? alreadyRespondedId;
  String? fullName;
  String? userImage;
  String? forumCreatedDate;
  List<ForumResponseModel>? response;
  List<Files>? files;

  ForumDetails(
      {this.id,
      this.title,
      this.description,
      this.selfForum,
      this.alreadyRespondedId,
      this.editable,
      this.file,
      this.treatmentType,
      this.userType,
      this.forumUser,
      this.isAlreadyResponded,
      this.forumStatus,
      this.viewCount,
      this.fullName,
      this.files,
      this.userImage,
      this.forumCreatedDate,
      this.response});

  ForumDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    selfForum = json['self_forum'];
    isAlreadyResponded = json['is_already_responded'];
    editable = false;
    description = json['description'];
    file = json['file'];
    treatmentType = json['treatment_type'];
    userType = json['user_type'];
    forumUser = json['forum_user'];
    forumUser = json['forum_user'];
    forumStatus = json['forum_status'];
    viewCount = json['view_count'];
    fullName = json['full_name'];
    userImage = json['user_image'];
    forumCreatedDate = json['forum_created_date'];
    if (json['response'] != null) {
      response = <ForumResponseModel>[];
      json['response'].forEach((v) {
        response!.add(ForumResponseModel.fromJson(v));
      });
    }
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(Files.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['file'] = file;
    data['self_forum'] = selfForum;
    data['is_already_responded'] = isAlreadyResponded;
    data['treatment_type'] = treatmentType;
    data['user_type'] = userType;
    data['forum_user'] = forumUser;
    data['forum_status'] = forumStatus;
    data['view_count'] = viewCount;
    data['full_name'] = fullName;
    data['user_image'] = userImage;
    data['forum_created_date'] = forumCreatedDate;
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Files {
  int? id;
  String? file;

  Files({this.id, this.file});

  Files.fromJson(Map<String, dynamic> json) {
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

class ForumResponseModel {
  int? id;
  String? response;
  String? respondedUserType;
  String? file;
  int? likeCount;
  int? dislikeCount;
  int? isLiked;
  bool? isAlreadyFlagged;
  bool? selfResponse;
  int? appUser;
  String? appUserName;
  String? appUserimage;
  int? doctor;
  String? doctorName;
  String? doctorImage;

  ForumResponseModel(
      {this.id,
      this.response,
      this.respondedUserType,
      this.isLiked,
      this.file,
      this.isAlreadyFlagged,
      this.selfResponse,
      this.appUserimage,
      this.likeCount,
      this.dislikeCount,
      this.appUser,
      this.appUserName,
      this.doctor,
      this.doctorImage,
      this.doctorName});

  ForumResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    response = json['response'];
    respondedUserType = json['responded_user_type'];
    file = json['file'];
    likeCount = json['like_count'];
    selfResponse = json['self_response'];
    isLiked = json['is_liked'];
    appUserimage = json['app_user_image'];
    dislikeCount = json['dislike_count'];
    appUser = json['app_user'];
    appUserName = json['app_user_name'];
    doctor = json['doctor'];
    doctorName = json['doctor_name'];
    isAlreadyFlagged = json['is_already_flagged'];
    doctorImage = json['doctor_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['response'] = response;
    data['responded_user_type'] = respondedUserType;
    data['file'] = file;
    data['is_liked'] = isLiked;
    data['self_response'] = selfResponse;
    data['app_user_image'] = appUserimage;
    data['like_count'] = likeCount;
    data['dislike_count'] = dislikeCount;
    data['app_user'] = appUser;
    data['app_user_name'] = appUserName;
    data['doctor'] = doctor;
    data['doctor_name'] = doctorName;
    data['doctor_image'] = doctorImage;
    data['is_already_flagged'] = isAlreadyFlagged;
    return data;
  }
}
