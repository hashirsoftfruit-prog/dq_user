class FreeFollowUpsModel {
  bool? status;
  String? message;
  List<Bookings>? bookings;

  FreeFollowUpsModel({this.status, this.message, this.bookings});

  FreeFollowUpsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['bookings'] != null) {
      bookings = <Bookings>[];
      json['bookings'].forEach((v) {
        bookings!.add(Bookings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (bookings != null) {
      data['bookings'] = bookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bookings {
  int? id;
  int? doctorId;

  String? appointmentId;
  String? doctorFirstName;
  String? doctorLastname;
  String? doctorImage;
  String? date;
  String? time;
  String? speciality;
  int? specialityId;
  String? bookingType;
  int? patientId;
  String? patientFirstName;
  String? patientLastname;
  String? patientGender;

  String? bookingStartTime;
  String? bookingEndTime;
  // int? patientAge;

  Bookings({
    this.id,
    this.doctorId,
    this.doctorFirstName,
    this.appointmentId,
    this.doctorLastname,
    this.doctorImage,
    this.specialityId,
    this.date,
    this.time,
    this.speciality,
    this.bookingType,
    this.patientId,
    this.patientFirstName,
    this.patientLastname,
    this.patientGender,
    this.bookingStartTime,
    this.bookingEndTime,
    // this.patientAge
  });

  Bookings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    doctorFirstName = json['doctor_first_name'];
    doctorLastname = json['doctor_lastname'];
    appointmentId = json['appointment_id'];
    doctorImage = json['doctor_image'];
    specialityId = json['speciality_id'];
    date = json['date'];
    time = json['time'];
    speciality = json['speciality'];
    bookingType = json['booking_type'];
    patientId = json['patient_id'];
    patientFirstName = json['patient_first_name'];
    patientLastname = json['patient_lastname'];
    patientGender = json['patient_gender'];
    bookingStartTime = json['booking_start_time'];
    bookingEndTime = json['booking_end_time'];
    // patientAge = json['patient_age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor_id'] = doctorId;
    data['doctor_first_name'] = doctorFirstName;
    data['doctor_image'] = doctorImage;
    data['doctor_lastname'] = doctorLastname;
    data['appointment_id'] = appointmentId;
    data['date'] = date;
    data['speciality_id'] = specialityId;
    data['time'] = time;
    data['speciality'] = speciality;
    data['booking_type'] = bookingType;
    data['patient_id'] = patientId;
    data['patient_first_name'] = patientFirstName;
    data['patient_lastname'] = patientLastname;
    data['patient_gender'] = patientGender;

    data['booking_start_time'] = bookingStartTime;
    data['booking_end_time'] = bookingEndTime;
    // data['patient_age'] = this.patientAge;
    return data;
  }
}
