class OnlineCategoriesModel {
  bool? status;
  CategoryModel? popularSpecialities;
  CategoryModel? healthIssues;
  CategoryModel? commonSymptoms;

  OnlineCategoriesModel(
      {this.status,
      this.popularSpecialities,
      this.healthIssues,
      this.commonSymptoms});

  OnlineCategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    popularSpecialities = json['popular_specialities'] != null
        ? CategoryModel.fromJson(json['popular_specialities'])
        : null;
    healthIssues = json['health_issues'] != null
        ? CategoryModel.fromJson(json['health_issues'])
        : null;
    commonSymptoms = json['common_symptoms'] != null
        ? CategoryModel.fromJson(json['common_symptoms'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (popularSpecialities != null) {
      data['popular_specialities'] = popularSpecialities!.toJson();
    }
    if (healthIssues != null) {
      data['health_issues'] = healthIssues!.toJson();
    }
    if (commonSymptoms != null) {
      data['common_symptoms'] = commonSymptoms!.toJson();
    }
    return data;
  }
}

class CategoryModel {
  int? id;
  String? icon;
  String? title;
  String? subtitle;
  List<Subcategory>? subcategory;

  CategoryModel(
      {this.id, this.icon, this.title, this.subtitle, this.subcategory});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icon = json['icon'];
    title = json['title'];
    subtitle = json['subtitle'];
    if (json['subcategory'] != null) {
      subcategory = <Subcategory>[];
      json['subcategory'].forEach((v) {
        subcategory!.add(Subcategory.fromJson(v));
      });
    } else {
      subcategory = <Subcategory>[];
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
  int? speciality;
  String? subtitle;

  Subcategory({this.id, this.icon, this.title, this.speciality, this.subtitle});

  Subcategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icon = json['icon'];
    speciality = json['speciality'];
    title = json['title'];
    subtitle = json['subtitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['icon'] = icon;
    data['speciality'] = speciality;
    data['title'] = title;
    data['subtitle'] = subtitle;
    return data;
  }
}
