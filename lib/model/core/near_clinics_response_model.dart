class NearClinicsModel {
  bool? status;
  List<Clinics>? clinics;

  NearClinicsModel({this.status, this.clinics});

  NearClinicsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    if (clinics != null) {
      data['clinics'] = clinics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Clinics {
  int? id;
  String? doctorFirstName;
  String? doctorLastName;
  int? doctor;
  String? qualification;
  String? clinic;
  String? img;

  Clinics(
      {this.id,
      this.doctor,
      this.qualification,
      this.clinic,
      this.doctorFirstName,
      this.doctorLastName});

  Clinics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorFirstName = json['doctor_first_name'];
    doctorLastName = json['doctor_last_name'];
    doctor = json['doctor'];
    qualification = json['qualification'];
    clinic = json['clinic'];
    img = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor'] = doctor;
    data['qualification'] = qualification;
    data['clinic'] = clinic;
    data['img'] = img;
    return data;
  }
}
