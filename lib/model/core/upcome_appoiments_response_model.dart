class UpcomingAppoinmentsModel {
  bool? status;
  String? message;
  List<UpcomingAppointments>? upcomingAppointments;
  int? count;
  int? next;
  int? previous;
  int? currentPage;
  int? totalPages;
  int? pageSize;
  UpcomingAppoinmentsModel({
    this.status,
    this.message,
    this.upcomingAppointments,
    this.count,
    this.next,
    this.previous,
    this.currentPage,
    this.totalPages,
    this.pageSize,
  });

  UpcomingAppoinmentsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['appointments'] != null) {
      upcomingAppointments = <UpcomingAppointments>[];
      json['appointments'].forEach((v) {
        upcomingAppointments!.add(UpcomingAppointments.fromJson(v));
      });
    }
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (upcomingAppointments != null) {
      data['appointments'] = upcomingAppointments!
          .map((v) => v.toJson())
          .toList();
    }
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    data['current_page'] = currentPage;
    data['total_pages'] = totalPages;
    data['page_size'] = pageSize;
    return data;
  }
}

class UpcomingAppointments {
  int? id;
  int? doctorId;
  String? doctorFirstName;
  String? doctorLastname;
  String? date;
  String? time;
  String? speciality;
  String? subspeciality;
  String? bookingType;
  String? patientFirstName;
  String? docImg;
  String? stime;
  String? bookingStartTime;
  String? bookingEndTime;
  String? appointmentId;

  bool? isFollowUp;

  UpcomingAppointments({
    this.id,
    this.doctorId,
    this.doctorFirstName,
    this.doctorLastname,
    this.patientFirstName,
    this.docImg,
    this.appointmentId,
    this.date,
    this.time,
    this.bookingStartTime,
    this.bookingEndTime,
    this.speciality,
    this.subspeciality,
    this.isFollowUp,
    this.bookingType,
  });

  UpcomingAppointments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    docImg = json['doctor_image'];
    bookingStartTime = json['booking_start_time'];
    bookingEndTime = json['booking_end_time'];
    doctorFirstName = json['doctor_first_name'];
    patientFirstName = json['patient_first_name'];
    doctorLastname = json['doctor_lastname'];
    date = json['date'];
    appointmentId = json['appointment_id'];
    time = json['time'];
    isFollowUp = json['isFollowUp'];
    speciality = json['speciality'];
    subspeciality = json['subspeciality'];
    bookingType = json['booking_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor_id'] = doctorId;
    data['doctor_image'] = docImg;
    data['doctor_first_name'] = doctorFirstName;
    data['patient_first_name'] = patientFirstName;
    data['doctor_lastname'] = doctorLastname;
    data['appointment_id'] = appointmentId;
    data['date'] = date;
    data['booking_start_time'] = bookingStartTime;
    data['booking_end_time'] = bookingEndTime;
    data['time'] = time;
    data['isFollowUp'] = isFollowUp;
    data['speciality'] = speciality;
    data['subspeciality'] = subspeciality;
    data['booking_type'] = bookingType;
    return data;
  }
}
