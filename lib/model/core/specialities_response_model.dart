class SpecialitiesModel {
  bool? status;
  int? specialityCount;
  int? unreadNotificationCount;
  List<SpecialityList>? specialityList;

  SpecialitiesModel(
      {this.status, this.specialityList, this.unreadNotificationCount});

  SpecialitiesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    specialityCount = json['speciality_count'];
    unreadNotificationCount = json['unread_notification_count'];
    if (json['speciality_list'] != null) {
      specialityList = <SpecialityList>[];
      json['speciality_list'].forEach((v) {
        specialityList!.add(SpecialityList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['speciality_count'] = specialityCount;
    data['unread_notification_count'] = unreadNotificationCount;
    if (specialityList != null) {
      data['speciality_list'] = specialityList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SpecialityList {
  int? id;
  String? title;
  String? subtitle;
  String? image;

  SpecialityList({this.id, this.title, this.subtitle, this.image});

  SpecialityList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['image'] = image;
    return data;
  }
}
