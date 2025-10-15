class SingleAppoinmentModel {
  bool? status;
  String? message;
  Bookings? bookings;

  SingleAppoinmentModel({this.status, this.message, this.bookings});

  SingleAppoinmentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    bookings =
        json['bookings'] != null ? Bookings.fromJson(json['bookings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (bookings != null) {
      data['bookings'] = bookings!.toJson();
    }
    return data;
  }
}

class Bookings {
  int? id;
  int? doctorId;
  String? doctorImage;
  String? doctorFirstName;
  String? doctorLastname;
  String? doctorQualification;
  bool? isPackageBooking;
  double? consultationAmount;
  double? discountAmount;
  double? couponAppliedAmount;
  double? platformFee;
  double? tax;
  double? paidAmount;
  String? date;
  String? time;
  int? cancellationStatus;
  String? appointmentId;
  int? specialityId;
  String? speciality;
  String? bookingType;
  int? patientId;
  String? patientFirstName;
  String? patientLastname;
  String? patientGender;
  String? clinicName;
  String? clinicAddress1;
  String? clinicAddress2;
  String? clinicCity;
  String? clinicState;
  String? clinicCountry;
  String? clinicPincode;
  String? clinicLatitude;
  String? clinicLongitude;
  String? bookingStartTime;
  String? bookingEndTime;
  String? callStatus;
  String? patientAge;
  List<PrescriptionImg>? prescriptions;

  Bookings(
      {this.id,
      this.doctorId,
      this.doctorImage,
      this.doctorFirstName,
      this.cancellationStatus,
      this.doctorLastname,
      this.doctorQualification,
      this.isPackageBooking,
      this.consultationAmount,
      this.discountAmount,
      this.couponAppliedAmount,
      this.platformFee,
      this.tax,
      this.paidAmount,
      this.date,
      this.time,
      this.appointmentId,
      this.specialityId,
      this.speciality,
      this.bookingType,
      this.patientId,
      this.patientFirstName,
      this.patientLastname,
      this.patientGender,
      this.clinicName,
      this.clinicAddress1,
      this.clinicAddress2,
      this.clinicCity,
      this.clinicState,
      this.clinicCountry,
      this.clinicPincode,
      this.clinicLatitude,
      this.clinicLongitude,
      this.bookingStartTime,
      this.bookingEndTime,
      this.callStatus,
      this.prescriptions,
      this.patientAge});

  Bookings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    doctorImage = json['doctor_image'];
    doctorFirstName = json['doctor_first_name'];
    doctorLastname = json['doctor_lastname'];
    cancellationStatus = json['cancellation_status'];
    doctorQualification = json['doctor_qualification'];
    isPackageBooking = json['is_package_booking'];
    consultationAmount = json['consultation_amount'];
    discountAmount = json['discount_amount'];
    couponAppliedAmount = json['coupon_applied_amount'];
    platformFee = json['platform_fee'];
    tax = json['tax'];
    paidAmount = json['paid_amount'];
    date = json['date'];
    time = json['time'];
    appointmentId = json['appointment_id'];
    specialityId = json['speciality_id'];
    cancellationStatus = json['cancellation_status'];
    speciality = json['speciality'];
    bookingType = json['booking_type'];
    patientId = json['patient_id'];
    patientFirstName = json['patient_first_name'];
    patientLastname = json['patient_lastname'];
    patientGender = json['patient_gender'];
    clinicName = json['clinic_name'];
    clinicAddress1 = json['clinic_address1'];
    clinicAddress2 = json['clinic_address2'];
    clinicCity = json['clinic_city'];
    clinicState = json['clinic_state'];
    clinicCountry = json['clinic_country'];
    clinicPincode = json['clinic_pincode'];
    clinicLatitude = json['clinic_latitude']?.toString();
    clinicLongitude = json['clinic_longitude']?.toString();
    bookingStartTime = json['booking_start_time'];
    bookingEndTime = json['booking_end_time'];
    callStatus = json['call_status'];
    patientAge = json['patient_age'];
    if (json['prescriptions'] != null) {
      prescriptions = <PrescriptionImg>[];
      json['prescriptions'].forEach((v) {
        prescriptions!.add(PrescriptionImg.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor_id'] = doctorId;
    data['doctor_image'] = doctorImage;
    data['doctor_first_name'] = doctorFirstName;
    data['doctor_lastname'] = doctorLastname;
    data['doctor_qualification'] = doctorQualification;
    data['is_package_booking'] = isPackageBooking;
    data['consultation_amount'] = consultationAmount;
    data['discount_amount'] = discountAmount;
    data['coupon_applied_amount'] = couponAppliedAmount;
    data['platform_fee'] = platformFee;
    data['tax'] = tax;
    data['paid_amount'] = paidAmount;
    data['date'] = date;
    data['time'] = time;
    data['appointment_id'] = appointmentId;
    data['speciality_id'] = specialityId;
    data['speciality'] = speciality;
    data['booking_type'] = bookingType;
    data['patient_id'] = patientId;
    data['patient_first_name'] = patientFirstName;
    data['patient_lastname'] = patientLastname;
    data['patient_gender'] = patientGender;
    data['clinic_name'] = clinicName;
    data['clinic_address1'] = clinicAddress1;
    data['clinic_address2'] = clinicAddress2;
    data['clinic_city'] = clinicCity;
    data['clinic_state'] = clinicState;
    data['clinic_country'] = clinicCountry;
    data['clinic_pincode'] = clinicPincode;
    data['clinic_latitude'] = clinicLatitude;
    data['clinic_longitude'] = clinicLongitude;
    data['booking_start_time'] = bookingStartTime;
    data['booking_end_time'] = bookingEndTime;
    data['call_status'] = callStatus;
    data['patient_age'] = patientAge;
    if (prescriptions != null) {
      data['prescriptions'] = prescriptions!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class PrescriptionImg {
  int? id;
  String? prescriptionImage;

  PrescriptionImg({this.id, this.prescriptionImage});

  PrescriptionImg.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prescriptionImage = json['prescription_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['prescription_image'] = prescriptionImage;
    return data;
  }
}
