import 'package:intl/intl.dart';

class DoctorSlotPickModel {
  bool? status;
  String? message;
  DoctorDetails? doctorDetails;
  String? bookingType;
  List<AllTimeSlots>? allTimeSlots;
  AllTimeSlots? selectedDate;
  String? selectedTimeSlot;

  DoctorSlotPickModel(
      {this.status,
      this.message,
      this.selectedDate,
      this.doctorDetails,
      this.selectedTimeSlot,
      this.bookingType,
      this.allTimeSlots});

  DoctorSlotPickModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    doctorDetails = json['doctor_details'] != null
        ? DoctorDetails.fromJson(json['doctor_details'])
        : null;
    bookingType = json['booking_type'];
    if (json['all_time_slots'] != null) {
      allTimeSlots = <AllTimeSlots>[];
      json['all_time_slots'].forEach((v) {
        allTimeSlots!.add(AllTimeSlots.fromJson(v));
      });
      selectedDate = allTimeSlots!.isNotEmpty ? allTimeSlots?.first : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (doctorDetails != null) {
      data['doctor_details'] = doctorDetails!.toJson();
    }
    data['booking_type'] = bookingType;
    if (allTimeSlots != null) {
      data['all_time_slots'] = allTimeSlots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DoctorDetails {
  int? id;
  String? image;
  String? firstName;
  String? lastName;
  String? experience;
  String? professionalQualifications;

  DoctorDetails(
      {this.id,
      this.image,
      this.firstName,
      this.lastName,
      this.experience,
      this.professionalQualifications});

  DoctorDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    experience = json['experience'];
    professionalQualifications = json['professional_qualifications'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['first_name'] = firstName;
    data['experience'] = experience;
    data['last_name'] = lastName;
    data['professional_qualifications'] = professionalQualifications;
    return data;
  }
}

class AllTimeSlots {
  String? date;
  List<String>? timeList;
  List<String>? morningSlots = [];
  List<String>? afternoonSlots = [];
  List<String>? eveningSlots = [];

  AllTimeSlots(
      {this.date,
      this.timeList,
      this.morningSlots,
      this.afternoonSlots,
      this.eveningSlots});

  AllTimeSlots.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    timeList = json['time_list'].cast<String>();

    if (timeList != null) {
      morningSlots = [];
      afternoonSlots = [];
      eveningSlots = [];
      for (var time in timeList!) {
        DateTime parsedTime = DateFormat("HH:mm:ss").parse(time);
        int hour = parsedTime.hour;

        if (hour >= 0 && hour < 12) {
          morningSlots!.add(time);
        } else if (hour >= 12 && hour < 17) {
          afternoonSlots!.add(time);
        } else {
          eveningSlots!.add(time);
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['time_list'] = timeList;
    return data;
  }
}
