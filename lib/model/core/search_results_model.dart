class SearchResultsModel {
  bool? status;
  String? response;
  List<Speciality>? speciality;
  List<Symptom>? symptom;
  List<Symptom>? service;
  List<Doctors>? doctors;
  List<Clinics>? clinics;

  SearchResultsModel(
      {this.status,
      this.response,
      this.speciality,
      this.symptom,
      this.service,
      this.doctors,
      this.clinics});

  SearchResultsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'];
    if (json['speciality'] != null) {
      speciality = <Speciality>[];
      json['speciality'].forEach((v) {
        speciality!.add(Speciality.fromJson(v));
      });
    }
    if (json['symptom'] != null) {
      symptom = <Symptom>[];
      json['symptom'].forEach((v) {
        symptom!.add(Symptom.fromJson(v));
      });
    }
    if (json['service'] != null) {
      service = <Symptom>[];
      json['service'].forEach((v) {
        service!.add(Symptom.fromJson(v));
      });
    }
    if (json['doctors'] != null) {
      doctors = <Doctors>[];
      json['doctors'].forEach((v) {
        doctors!.add(Doctors.fromJson(v));
      });
    }
    if (json['clinics'] != null) {
      clinics = <Clinics>[];
      json['clinics'].forEach((v) {
        clinics!.add(Clinics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['response'] = response;
    if (speciality != null) {
      data['speciality'] = speciality!.map((v) => v.toJson()).toList();
    }
    if (symptom != null) {
      data['symptom'] = symptom!.map((v) => v.toJson()).toList();
    }
    if (service != null) {
      data['service'] = service!.map((v) => v.toJson()).toList();
    }
    if (doctors != null) {
      data['doctors'] = doctors!.map((v) => v.toJson()).toList();
    }
    if (clinics != null) {
      data['clinics'] = clinics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Speciality {
  int? id;
  String? title;
  String? subtitle;
  String? image;

  Speciality({this.id, this.title, this.subtitle, this.image});

  Speciality.fromJson(Map<String, dynamic> json) {
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

class Symptom {
  int? id;
  String? title;
  String? image;

  Symptom({this.id, this.title, this.image});

  Symptom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    return data;
  }
}

class Doctors {
  int? id;
  String? image;
  String? firstName;
  String? lastName;
  String? gender;
  String? experience;
  String? qualification;

  Doctors(
      {this.id,
      this.image,
      this.firstName,
      this.lastName,
      this.gender,
      this.experience,
      this.qualification});

  Doctors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    experience = json['experience'];
    qualification = json['qualification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['gender'] = gender;
    data['experience'] = experience;
    data['qualification'] = qualification;
    return data;
  }
}

class Clinics {
  int? id;
  String? name;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? pincode;
  double? latitude;
  double? longitude;
  String? logo;

  Clinics(
      {this.id,
      this.name,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.country,
      this.pincode,
      this.latitude,
      this.longitude,
      this.logo});

  Clinics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pincode = json['pincode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['pincode'] = pincode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['logo'] = logo;
    return data;
  }
}
