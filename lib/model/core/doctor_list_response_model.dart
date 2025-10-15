import 'available_doctors_response_model.dart';

class DoctorListModel {
  bool? status;
  String? message;
  List<DocDetailsModel>? doctors;

  DoctorListModel({this.status, this.message, this.doctors});

  DoctorListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['doctors'] != null) {
      doctors = <DocDetailsModel>[];
      json['doctors'].forEach((v) {
        doctors!.add(DocDetailsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (doctors != null) {
      data['doctors'] = doctors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DocDetailsModel {
  int? id;
  String? image;
  String? professionalQualifications;
  String? firstName;
  String? lastName;
  String? gender;
  String? clinicName;
  String? address1;
  String? address2;
  String? email;
  String? clinicLatitude;
  String? clinicLongitude;
  String? experience;
  String? qualification;
  String? onlineStartTime;
  String? onlineEndTime;
  String? offlineStartTime;
  String? offlineEndTime;
  String? doctorOnlineFee;
  String? doctorOfflineFee;
  int? completedBookingCount;
  bool? isMultipleClinics;
  bool? isMultipleSpecialities;
  String? description;
  List<String>? timeList;

  List<DoctorSpecialities>? doctorSpecialities;
  List<ClinicsDetails>? clinics;
  List<Education>? education;
  List<Experiences>? experiences;
  List<Awards>? awards;
  List<Memberships>? memberships;
  List<Services>? services;
  List<Languages>? languages;

  DocDetailsModel({
    this.id,
    this.image,
    this.professionalQualifications,
    this.firstName,
    this.lastName,
    this.gender,
    this.clinicName,
    this.address1,
    this.address2,
    this.email,
    this.clinicLatitude,
    this.clinicLongitude,
    this.experience,
    this.qualification,
    this.onlineStartTime,
    this.onlineEndTime,
    this.offlineStartTime,
    this.offlineEndTime,
    this.doctorOnlineFee,
    this.doctorOfflineFee,
    this.completedBookingCount,
    this.isMultipleClinics,
    this.isMultipleSpecialities,
    this.description,
    this.timeList,
    this.doctorSpecialities,
    this.clinics,
    this.education,
    this.experiences,
    this.awards,
    this.memberships,
    this.services,
    this.languages,
  });

  DocDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    professionalQualifications = json['professional_qualifications'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    clinicName = json['clinic_name'];
    address1 = json['address1'];
    address2 = json['address2'];
    email = json['email'];
    clinicLatitude = json['clinic_latitude']?.toString();
    clinicLongitude = json['clinic_longitude']?.toString();
    experience = json['experience'];
    qualification = json['qualification'];
    onlineStartTime = json['online_start_time'];
    onlineEndTime = json['online_end_time'];
    offlineStartTime = json['offline_start_time'];
    offlineEndTime = json['offline_end_time'];
    doctorOnlineFee = json['doctor_online_fee']?.toString();
    doctorOfflineFee = json['doctor_offline_fee']?.toString();
    completedBookingCount = json['completed_booking_count'];
    isMultipleClinics = json['is_multiple_clinics'];
    isMultipleSpecialities = json['is_multiple_specialities'];
    description = json['description'];

    if (json['time_list'] != null) {
      timeList = List<String>.from(json['time_list']);
    }

    if (json['doctor_specialities'] != null) {
      doctorSpecialities = List<DoctorSpecialities>.from(
        json['doctor_specialities'].map((x) => DoctorSpecialities.fromJson(x)),
      );
    }

    if (json['clinics'] != null) {
      clinics = List<ClinicsDetails>.from(
        json['clinics'].map((x) => ClinicsDetails.fromJson(x)),
      );
    }

    if (json['education'] != null) {
      education = List<Education>.from(
        json['education'].map((x) => Education.fromJson(x)),
      );
    }

    if (json['experiences'] != null) {
      experiences = List<Experiences>.from(
        json['experiences'].map((x) => Experiences.fromJson(x)),
      );
    }

    if (json['awards'] != null) {
      awards = List<Awards>.from(
        json['awards'].map((x) => Awards.fromJson(x)),
      );
    }

    if (json['memberships'] != null) {
      memberships = List<Memberships>.from(
        json['memberships'].map((x) => Memberships.fromJson(x)),
      );
    }

    if (json['services'] != null) {
      services = List<Services>.from(
        json['services'].map((x) => Services.fromJson(x)),
      );
    }

    if (json['languages'] != null) {
      languages = List<Languages>.from(
        json['languages'].map((x) => Languages.fromJson(x)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['image'] = image;
    data['professional_qualifications'] = professionalQualifications;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['gender'] = gender;
    data['clinic_name'] = clinicName;
    data['address1'] = address1;
    data['address2'] = address2;
    data['email'] = email;
    data['clinic_latitude'] = clinicLatitude;
    data['clinic_longitude'] = clinicLongitude;
    data['experience'] = experience;
    data['qualification'] = qualification;
    data['online_start_time'] = onlineStartTime;
    data['online_end_time'] = onlineEndTime;
    data['offline_start_time'] = offlineStartTime;
    data['offline_end_time'] = offlineEndTime;
    data['doctor_online_fee'] = doctorOnlineFee;
    data['doctor_offline_fee'] = doctorOfflineFee;
    data['completed_booking_count'] = completedBookingCount;
    data['is_multiple_clinics'] = isMultipleClinics;
    data['is_multiple_specialities'] = isMultipleSpecialities;
    data['description'] = description;
    if (timeList != null) data['time_list'] = timeList;

    if (doctorSpecialities != null) {
      data['doctor_specialities'] =
          doctorSpecialities!.map((v) => v.toJson()).toList();
    }
    if (clinics != null) {
      data['clinics'] = clinics!.map((v) => v.toJson()).toList();
    }
    if (education != null) {
      data['education'] = education!.map((v) => v.toJson()).toList();
    }
    if (experiences != null) {
      data['experiences'] = experiences!.map((v) => v.toJson()).toList();
    }
    if (awards != null) {
      data['awards'] = awards!.map((v) => v.toJson()).toList();
    }
    if (memberships != null) {
      data['memberships'] = memberships!.map((v) => v.toJson()).toList();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (languages != null) {
      data['languages'] = languages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClinicsDetails {
  int? id;
  String? name;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? latitude;
  String? longitude;

  ClinicsDetails(
      {this.id,
      this.name,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.country,
      this.latitude,
      this.longitude});

  ClinicsDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
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
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class DoctorSpecialities {
  int? id;
  String? title;
  String? subtitle;
  String? image;

  DoctorSpecialities({this.id, this.title, this.subtitle, this.image});

  DoctorSpecialities.fromJson(Map<String, dynamic> json) {
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
