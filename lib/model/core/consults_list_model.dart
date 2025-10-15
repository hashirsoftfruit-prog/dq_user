class ConsultsListModel {
  bool? status;
  String? message;
  List<Consultaions>? consultations;
  int? count;
  // Null? next;
  // Null? previous;
  int? currentPage;
  int? totalPages;
  int? pageSize;

  ConsultsListModel({
    this.status,
    this.message,
    this.consultations,
    this.count,
    // this.next,
    // this.previous,
    this.currentPage,
    this.totalPages,
    this.pageSize,
  });

  ConsultsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['consultations'] != null) {
      consultations = <Consultaions>[];
      json['consultations'].forEach((v) {
        consultations!.add(Consultaions.fromJson(v));
      });
    }
    count = json['count'];
    // next = json['next'];
    // previous = json['previous'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (consultations != null) {
      data['consultations'] = consultations!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    // data['next'] = this.next;
    // data['previous'] = this.previous;
    data['current_page'] = currentPage;
    data['total_pages'] = totalPages;
    data['page_size'] = pageSize;
    return data;
  }
}

class Consultaions {
  int? id;
  int? doctorId;
  bool? isFreeFollowupActive;
  String? doctorImage;
  String? doctorFirstName;
  String? doctorLastname;
  String? doctorQualification;
  String? date;
  String? time;
  String? appointmentId;
  int? specialityId;
  int? subSpecialityId;
  String? speciality;
  String? subspeciality;
  String? bookingType;
  int? patientId;
  String? patientFirstName;
  String? patientLastname;
  String? patientGender;
  String? patientAge;
  bool? isAlreadyFollowedUp;
  bool? isAFreeFollowupBooking;
  String? bookingStartTime;
  String? bookingEndTime;
  Consultaions({
    this.id,
    this.doctorId,
    this.isFreeFollowupActive,
    this.doctorImage,
    this.doctorFirstName,
    this.appointmentId,
    this.doctorLastname,
    this.doctorQualification,
    this.date,
    this.time,
    this.specialityId,
    this.speciality,
    this.bookingType,
    this.patientId,
    this.patientFirstName,
    this.patientLastname,
    this.patientGender,
    this.patientAge,
    this.isAlreadyFollowedUp,
    this.bookingStartTime,
    this.bookingEndTime,
    this.isAFreeFollowupBooking,
    this.subspeciality,
    this.subSpecialityId,
  });

  Consultaions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    isFreeFollowupActive = json['is_free_followup_active'];
    doctorImage = json['doctor_image'];
    doctorFirstName = json['doctor_first_name'];
    doctorLastname = json['doctor_lastname'];
    doctorQualification = json['doctor_qualification'];
    date = json['date'];
    time = json['time'];
    appointmentId = json['appointment_id'];
    specialityId = json['speciality_id'];
    subSpecialityId = json['subspeciality_id'];
    speciality = json['speciality'];
    subspeciality = json['subspeciality'];
    bookingType = json['booking_type'];
    patientId = json['patient_id'];
    patientFirstName = json['patient_first_name'];
    patientLastname = json['patient_lastname'];
    patientGender = json['patient_gender'];
    patientAge = json['patient_age'];
    isAlreadyFollowedUp = json['is_already_followed_up'];
    isAFreeFollowupBooking = json['is_a_free_followup_booking'];
    bookingStartTime = json['booking_start_time'];
    bookingEndTime = json['booking_end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor_id'] = doctorId;
    data['is_free_followup_active'] = isFreeFollowupActive;
    data['doctor_image'] = doctorImage;
    data['doctor_first_name'] = doctorFirstName;
    data['doctor_lastname'] = doctorLastname;
    data['doctor_qualification'] = doctorQualification;
    data['date'] = date;
    data['time'] = time;
    data['appointment_id'] = appointmentId;
    data['speciality_id'] = specialityId;
    data['subspeciality_id'] = subSpecialityId;
    data['speciality'] = speciality;
    data['subspeciality'] = subspeciality;
    data['booking_type'] = bookingType;
    data['patient_id'] = patientId;
    data['patient_first_name'] = patientFirstName;
    data['patient_lastname'] = patientLastname;
    data['patient_gender'] = patientGender;
    data['patient_age'] = patientAge;
    data['is_already_followed_up'] = isAlreadyFollowedUp;
    data['is_a_free_followup_booking'] = isAFreeFollowupBooking;
    data['booking_start_time'] = bookingStartTime;
    data['booking_end_time'] = bookingEndTime;
    return data;
  }
}
