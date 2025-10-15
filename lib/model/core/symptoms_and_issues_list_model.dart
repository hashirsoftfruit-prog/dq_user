class SymptomsAndIssuesModel {
  bool? status;
  MentalWellness? mentalWellness;
  Symptoms? symptoms;
  AyurvedicOrHomeo? ayurvedic;
  AyurvedicOrHomeo? homeopathy;

  SymptomsAndIssuesModel(
      {this.status, this.mentalWellness, this.symptoms, this.ayurvedic});

  SymptomsAndIssuesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    mentalWellness = json['mental_wellness'] != null
        ? MentalWellness.fromJson(json['mental_wellness'])
        : null;
    symptoms =
        json['symptoms'] != null ? Symptoms.fromJson(json['symptoms']) : null;
    ayurvedic = json['ayurvedic'] != null
        ? AyurvedicOrHomeo.fromJson(json['ayurvedic'])
        : null;
    homeopathy = json['homeopathy'] != null
        ? AyurvedicOrHomeo.fromJson(json['homeopathy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (mentalWellness != null) {
      data['mental_wellness'] = mentalWellness!.toJson();
    }
    if (symptoms != null) {
      data['symptoms'] = symptoms!.toJson();
    }
    return data;
  }
}

class MentalWellness {
  int? id;
  String? icon;
  String? title;
  String? subtitle;
  List<Subcategory>? subcategory;

  MentalWellness(
      {this.id, this.icon, this.title, this.subtitle, this.subcategory});

  MentalWellness.fromJson(Map<String, dynamic> json) {
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

class AyurvedicOrHomeo {
  int? id;
  String? icon;
  String? title;
  String? subtitle;
  List<Subcategory>? subcategory;

  AyurvedicOrHomeo(
      {this.id, this.icon, this.title, this.subtitle, this.subcategory});

  AyurvedicOrHomeo.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? icon;
  String? subtitle;
  int? speciality;

  Subcategory({this.id, this.title, this.subtitle, this.speciality});

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

class Symptoms {
  int? id;
  String? icon;
  String? title;
  String? subtitle;
  List<Subcategory>? subcategory;

  Symptoms({this.id, this.icon, this.title, this.subtitle, this.subcategory});

  Symptoms.fromJson(Map<String, dynamic> json) {
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
