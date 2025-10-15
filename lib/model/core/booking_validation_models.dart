class BookingValidationResponseData {
  bool? status;
  String? message;
  String? appointmentId;
  int? temperoryBookingId;
  int? bookingId;
  String? paymentUrl;
  dynamic sdkPayload;

  BookingValidationResponseData(
      {this.status,
      this.message,
      this.appointmentId,
      this.temperoryBookingId,
      this.bookingId,
      this.sdkPayload});

  BookingValidationResponseData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    appointmentId = json['appointment_id'];
    temperoryBookingId = json['temperory_booking_id'];
    bookingId = json['booking_id'];
    paymentUrl = json['payment_url'];
    sdkPayload = json['sdk_payload'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['appointment_id'] = appointmentId;
    data['temperory_booking_id'] = temperoryBookingId;
    data['booking_id'] = bookingId;
    data['payment_url'] = paymentUrl;
    data['sdk_payload'] = sdkPayload;

    return data;
  }
}

class BookingSaveResponseModel {
  bool? status;
  String? message;
  String? appointmentId;
  int? bookingId;
  String? dateTime;
  String? bookingType;
  String? doctorName;
  String? doctorImage;
  String? doctorProfessionalQualifications;
  String? clinicAddress;
  dynamic paymentDetails;

  BookingSaveResponseModel({
    this.status,
    this.message,
    this.appointmentId,
    this.bookingId,
    this.dateTime,
    this.doctorImage,
    this.bookingType,
    this.doctorName,
    this.doctorProfessionalQualifications,
    this.clinicAddress,
    this.paymentDetails,
  });

  BookingSaveResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    appointmentId = json['appointment_id'];
    bookingId = json['booking_id'];
    doctorImage = json['doctor_image'];
    dateTime = json['date_time'];
    bookingType = json['booking_type'];
    doctorName = json['doctor_name'];
    doctorProfessionalQualifications =
        json['doctor_professional_qualifications'];
    clinicAddress = json['clinic_address'];
    paymentDetails = json['status_check_api_response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['appointment_id'] = appointmentId;
    data['booking_id'] = bookingId;
    data['doctor_image'] = doctorImage;
    data['date_time'] = dateTime;
    data['booking_type'] = bookingType;
    data['doctor_name'] = doctorName;
    data['doctor_professional_qualifications'] =
        doctorProfessionalQualifications;
    data['clinic_address'] = clinicAddress;
    data['status_check_api_response'] = paymentDetails;
    return data;
  }
}
