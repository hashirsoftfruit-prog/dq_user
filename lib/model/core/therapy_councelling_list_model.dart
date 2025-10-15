class TharapyCouncellingListModel {
  bool? status;
  String? message;
  List<TherapyOrCouncellingItem>? therapy;
  List<TherapyOrCouncellingItem>? counselling;

  TharapyCouncellingListModel(
      {this.status, this.message, this.therapy, this.counselling});

  TharapyCouncellingListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['therapy'] != null) {
      therapy = <TherapyOrCouncellingItem>[];
      json['therapy'].forEach((v) {
        therapy!.add(TherapyOrCouncellingItem.fromJson(v));
      });
    }
    if (json['counselling'] != null) {
      counselling = <TherapyOrCouncellingItem>[];
      json['counselling'].forEach((v) {
        counselling!.add(TherapyOrCouncellingItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (therapy != null) {
      data['therapy'] = therapy!.map((v) => v.toJson()).toList();
    }
    if (counselling != null) {
      data['counselling'] = counselling!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TherapyOrCouncellingItem {
  int? id;
  String? title;
  String? subtitle;
  String? image;
  int? speciality;

  TherapyOrCouncellingItem({
    this.id,
    this.title,
    this.subtitle,
    this.image,
    this.speciality,
  });

  TherapyOrCouncellingItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    image = json['image'];
    speciality = json['speciality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['image'] = image;
    data['speciality'] = speciality;
    return data;
  }
}
