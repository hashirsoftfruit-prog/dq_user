class PublicForumListModel {
  bool? status;
  String? message;
  List<PublicForums>? publicForums;
  int? count;
  int? next;
  int? previous;
  int? currentPage;
  int? totalPages;
  int? pageSize;

  PublicForumListModel(
      {this.status,
      this.message,
      this.publicForums,
      this.count,
      this.next,
      this.previous,
      this.currentPage,
      this.totalPages,
      this.pageSize});

  PublicForumListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['public_forums'] != null) {
      publicForums = <PublicForums>[];
      json['public_forums'].forEach((v) {
        publicForums!.add(PublicForums.fromJson(v));
      });
    }
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    // if (this.publicForums != null) {
    //   data['public_forums'] =
    //       this.publicForums!.map((v) => v.toJson()).toList();
    // }
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    data['current_page'] = currentPage;
    data['total_pages'] = totalPages;
    data['page_size'] = pageSize;
    return data;
  }
}

class PublicForums {
  int? id;
  String? title;
  String? fullName;
  String? userImage;
  String? forumCreatedDate;
  String? description;
  String? file;
  String? treatmentType;
  String? userType;
  int? forumUser;
  String? forumStatus;
  int? viewCount;
  int? responsesCount;

  PublicForums(
      {this.id,
      this.title,
      this.description,
      this.fullName,
      this.userImage,
      this.forumCreatedDate,
      this.file,
      this.treatmentType,
      this.userType,
      this.forumUser,
      this.forumStatus,
      this.viewCount,
      this.responsesCount});

  PublicForums.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    userImage = json['user_image'];
    file = json['file'];
    treatmentType = json['treatment_type'];
    fullName = json['full_name'];
    forumCreatedDate = json['forum_created_date'];
    userType = json['user_type'];
    forumUser = json['forum_user'];
    forumStatus = json['forum_status'];
    viewCount = json['view_count'];
    responsesCount = json['responses_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['file'] = file;
    data['forum_created_date'] = forumCreatedDate;
    data['full_name'] = fullName;
    data['treatment_type'] = treatmentType;
    data['user_type'] = userType;
    data['user_image'] = userImage;
    data['forum_user'] = forumUser;
    data['forum_status'] = forumStatus;
    data['view_count'] = viewCount;
    data['responses_count'] = responsesCount;

    return data;
  }
}
