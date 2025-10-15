class CouncellingListModel {
  bool? status;
  String? message;
  PsychologySymptoms? psychologySymptoms;
  List<PsychologyItem>? therapy;
  List<PsychologyItem>? counselling;

  CouncellingListModel(
      {this.status, this.message, this.psychologySymptoms, this.therapy});

  CouncellingListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    psychologySymptoms = json['psychology_symptoms'] != null
        ? PsychologySymptoms.fromJson(json['psychology_symptoms'])
        : null;
    if (json['therapy'] != null) {
      therapy = <PsychologyItem>[];
      json['therapy'].forEach((v) {
        therapy!.add(PsychologyItem.fromJson(v));
      });
    }
    if (json['counselling'] != null) {
      counselling = <PsychologyItem>[];
      json['counselling'].forEach((v) {
        counselling!.add(PsychologyItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (psychologySymptoms != null) {
      data['psychology_symptoms'] = psychologySymptoms!.toJson();
    }
    if (therapy != null) {
      data['therapy'] = therapy!.map((v) => v.toJson()).toList();
    }
    if (counselling != null) {
      data['counselling'] = counselling!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PsychologySymptoms {
  int? id;
  String? icon;
  String? title;
  String? subtitle;
  List<Subcategory>? subcategory;

  PsychologySymptoms(
      {this.id, this.icon, this.title, this.subtitle, this.subcategory});

  PsychologySymptoms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icon = json['icon'];
    title = json['title'];
    subtitle = json['subtitle'];
    if (json['subcategory'] != null) {
      subcategory = <Subcategory>[];
      json['subcategory'].forEach((v) {
        subcategory!.add(Subcategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['icon'] = icon;
    data['title'] = title;
    data['subtitle'] = subtitle;
    if (subcategory != null) {
      data['subcategory'] = subcategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subcategory {
  int? id;
  String? icon;
  String? title;
  String? subtitle;
  int? speciality;

  Subcategory({this.id, this.icon, this.title, this.subtitle, this.speciality});

  Subcategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icon = json['icon'];
    title = json['title'];
    subtitle = json['subtitle'];
    speciality = json['speciality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['icon'] = icon;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['speciality'] = speciality;
    return data;
  }
}

class PsychologyItem {
  int? id;
  int? speciality;
  String? title;
  String? subtitle;
  String? image;

  PsychologyItem(
      {this.id, this.title, this.subtitle, this.speciality, this.image});

  PsychologyItem.fromJson(Map<String, dynamic> json) {
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
    data['speciality'] = speciality;
    data['subtitle'] = subtitle;
    data['image'] = image;
    return data;
  }
}
