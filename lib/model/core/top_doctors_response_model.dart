import 'available_doctors_response_model.dart';

class TopDoctorsResponseModel {
  bool? status;
  String? message;
  List<TopDoctors>? allopathyDoctors;
  List<TopDoctors>? homeopathyDoctors;
  List<TopDoctors>? veterinaryDoctors;
  List<TopDoctors>? ayurvedaDoctors;

  TopDoctorsResponseModel({
    this.status,
    this.allopathyDoctors,
    this.homeopathyDoctors,
    this.veterinaryDoctors,
    this.ayurvedaDoctors,
    this.message,
  });

  TopDoctorsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    if (json['allopathy_doctors'] != null) {
      allopathyDoctors = <TopDoctors>[];
      json['allopathy_doctors'].forEach((v) {
        allopathyDoctors!.add(TopDoctors.fromJson(v));
      });
    }
    if (json['homeopathy_doctors'] != null) {
      homeopathyDoctors = <TopDoctors>[];
      json['homeopathy_doctors'].forEach((v) {
        homeopathyDoctors!.add(TopDoctors.fromJson(v));
      });
    }
    if (json['veterinary_doctors'] != null) {
      veterinaryDoctors = <TopDoctors>[];
      json['veterinary_doctors'].forEach((v) {
        veterinaryDoctors!.add(TopDoctors.fromJson(v));
      });
    }
    if (json['ayurveda_doctors'] != null) {
      ayurvedaDoctors = <TopDoctors>[];
      json['ayurveda_doctors'].forEach((v) {
        ayurvedaDoctors!.add(TopDoctors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    // if (topDoctors != null) data['doctors'] = topDoctors!.map((e) => e.toJson()).toList();
    return data;
  }
}

class TopDoctors {
  int? id;
  String? primaryAchievement;
  String? secondaryAchievement;
  double? rating;
  Doctors? doctor;

  TopDoctors(
      {this.id,
      this.doctor,
      this.primaryAchievement,
      this.secondaryAchievement,
      this.rating});

  TopDoctors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    primaryAchievement = json['primary_achievement'];
    secondaryAchievement = json['secondary_achievement'];
    rating = json['rating'];
    if (json['doctor'] != null) {
      doctor = Doctors.fromJson(json['doctor']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['primary_achievement'] = primaryAchievement;
    data['secondary_achievement'] = secondaryAchievement;
    data['rating'] = rating;
    if (doctor != null) data['doctors'] = doctor!.toJson();

    return data;
  }
}
