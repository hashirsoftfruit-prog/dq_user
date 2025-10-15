import 'package:dqapp/model/core/package_list_response_model.dart';

class BookingDetailsItem {
  // String? paidAmount;
  // int? couponId;
  int? patientId;
  String? consultationFor;
  int? specialityId;
  int? petId;
  int? subSpecialityId;
  int? psychologyType;
  int? selectedPriceCategory;
  SelectedPackageDetails? packageDetails;
  // String? consultationAmount;
  // String? platformFee;
  // String? tax;
  int? subcategoryId;
  String? gender;
  String? language;
  bool? seniorCitizenFreeConsultation;

  BookingDetailsItem({
    // this.paidAmount,
    // this.couponId,
    this.patientId,
    this.petId,
    this.subSpecialityId,
    this.selectedPriceCategory,
    this.psychologyType,
    this.seniorCitizenFreeConsultation,
    this.packageDetails,
    // this.consultationAmount,
    this.consultationFor,
    this.specialityId,
    // this.platformFee,
    // this.tax,
    this.subcategoryId,
    this.gender,
    this.language,
  });

  // BookingDetailsItem.fromJson(Map<String, dynamic> json) {
  //   paidAmount = json['paid_amount'];
  //   couponId = json['coupon_id'];
  //   consultationAmount = json['consultation_amount'];
  //   patientId = json['patient_id'];
  //   consultationFor = json['consultation_for'];
  //   specialityId = json['speciality_id'];
  //
  //
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['paid_amount'] = this.paidAmount;
  //   data['coupon_id'] = this.couponId;
  //   data['consultation_amount'] = this.consultationAmount;
  //   data['patient_id'] = this.patientId;
  //   data['consultation_for'] = this.consultationFor;
  //   data['speciality_id'] = this.specialityId;
  //   return data;
  // }
}

class SaveScheduledBookingModel {
  String? date;
  String? time;
  int? bookingType;
  int? doctorId;
  int? specialityId;
  // String? paidAmount;
  int? freeFollowupBooking;
  bool? isFreeFollowup;
  // String? consultationAmount;
  // String? platformFee;
  // String? tax;
  // int? couponId;
  int? petId;
  int? subSpecialityIdForPsychology;
  int? patientId;
  String? consultationFor;
  int? subcategoryId;
  int? clinicId;
  bool? seniorCitizenFreeConsultation;
  SelectedPackageDetails? packageDetails;
  String? gender;
  String? language;
  SaveScheduledBookingModel({
    this.date,
    this.time,
    this.bookingType,
    this.doctorId,
    this.specialityId,
    this.subSpecialityIdForPsychology,
    // this.paidAmount,
    this.clinicId,
    this.petId,
    this.freeFollowupBooking,
    this.isFreeFollowup,
    // this.consultationAmount,
    // this.platformFee,
    // this.tax,
    // this.couponId,
    this.patientId,
    this.consultationFor,
    this.subcategoryId,
    this.seniorCitizenFreeConsultation,
    this.packageDetails,
    this.gender,
    this.language,
  });

  SaveScheduledBookingModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
    clinicId = json['clinic_id'];
    petId = json['pet_id'];
    bookingType = json['booking_type'];
    doctorId = json['doctor_id'];
    specialityId = json['speciality_id'];
    // paidAmount = json['paid_amount'];
    freeFollowupBooking = json['free_followup_booking'];
    isFreeFollowup = json['is_free_followup'];
    // consultationAmount = json['consultation_amount'];
    // platformFee = json['platform_fee'];
    // tax = json['tax'];
    // couponId = json['coupon_id'];
    patientId = json['patient_id'];
    consultationFor = json['consultation_for'];
    subcategoryId = json['subcategory_id'];
    gender = json['gender'];
    language = json['language'];
    seniorCitizenFreeConsultation = json['senior_citizen_free_consultation'];
    packageDetails = json['package_details'] != null
        ? SelectedPackageDetails.fromJson(json['package_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['time'] = time;
    data['booking_type'] = bookingType;
    data['doctor_id'] = doctorId;
    data['speciality_id'] = specialityId;
    data['clinic_id'] = clinicId;
    data['pet_id'] = petId;
    // data['paid_amount'] = this.paidAmount;
    data['free_followup_booking'] = freeFollowupBooking;
    data['is_free_followup'] = isFreeFollowup;
    // data['consultation_amount'] = this.consultationAmount;
    // data['platform_fee'] = this.platformFee;
    // data['tax'] = this.tax;
    // data['coupon_id'] = this.couponId;
    data['patient_id'] = patientId;
    data['consultation_for'] = consultationFor;
    data['subcategory_id'] = subcategoryId;
    data['senior_citizen_free_consultation'] = seniorCitizenFreeConsultation;
    if (packageDetails != null) {
      data['package_details'] = packageDetails!.toJson();
    }
    data['gender'] = gender;
    data['language'] = language;
    return data;
  }
}

class PsychologyInstantBookingData {
  int? doctorId;
  // String? date;
  // String? time;
  // int? bookingType;
  int? specialityId;
  int? subSpecialityId;
  int? psychologyType;
  // String? paidAmount;
  // int? freeFollowupBooking;
  // bool? isFreeFollowup;
  // String? consultationAmount;
  // String? platformFee;
  // String? tax;
  // int? couponId;
  // int? petId;
  int? patientId;
  String? consultationFor;
  // int? subcategoryId;
  // int? clinicId;
  bool? seniorCitizenFreeConsultation;
  SelectedPackageDetails? packageDetails;
  String? gender;
  String? language;

  PsychologyInstantBookingData({
    // this.date,
    // this.time,
    // this.bookingType,
    this.doctorId,
    this.specialityId,
    this.subSpecialityId,
    this.psychologyType,
    // this.paidAmount,
    // this.clinicId,
    // this.petId,
    // this.freeFollowupBooking,
    // this.isFreeFollowup,
    // this.consultationAmount,
    // this.platformFee,
    // this.tax,
    // this.couponId,
    this.patientId,
    this.consultationFor,
    // this.subcategoryId,
    this.seniorCitizenFreeConsultation,
    this.packageDetails,
    this.gender,
    this.language,
  });

  PsychologyInstantBookingData.fromJson(Map<String, dynamic> json) {
    // date = json['date'];
    // time = json['time'];
    // clinicId = json['clinic_id'];
    // petId = json['pet_id'];
    // bookingType = json['booking_type'];
    doctorId = json['doctor_id'];
    specialityId = json['speciality_id'];
    // paidAmount = json['paid_amount'];
    // freeFollowupBooking = json['free_followup_booking'];
    // isFreeFollowup = json['is_free_followup'];
    // consultationAmount = json['consultation_amount'];
    // platformFee = json['platform_fee'];
    // tax = json['tax'];
    // couponId = json['coupon_id'];
    patientId = json['patient_id'];
    consultationFor = json['consultation_for'];
    // subcategoryId = json['subcategory_id'];
    seniorCitizenFreeConsultation = json['senior_citizen_free_consultation'];
    packageDetails = json['package_details'] != null
        ? SelectedPackageDetails.fromJson(json['package_details'])
        : null;
    gender = json['gender'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['date'] = this.date;
    // data['time'] = this.time;
    // data['booking_type'] = this.bookingType;
    data['doctor_id'] = doctorId;
    data['speciality_id'] = specialityId;
    // data['clinic_id'] = this.clinicId;
    // data['pet_id'] = this.petId;
    // data['paid_amount'] = this.paidAmount;
    // data['free_followup_booking'] = this.freeFollowupBooking;
    // data['is_free_followup'] = this.isFreeFollowup;
    // data['consultation_amount'] = this.consultationAmount;
    // data['platform_fee'] = this.platformFee;
    // data['tax'] = this.tax;
    // data['coupon_id'] = this.couponId;
    data['patient_id'] = patientId;
    data['consultation_for'] = consultationFor;
    // data['subcategory_id'] = this.subcategoryId;
    data['senior_citizen_free_consultation'] = seniorCitizenFreeConsultation;
    if (packageDetails != null) {
      data['package_details'] = packageDetails!.toJson();
    }
    data['gender'] = gender;
    data['language'] = language;
    return data;
  }
}

// class PackageDetails {
//   int? packageId;
//   List<int>? packageMembers;
//
//   PackageDetails({this.packageId, this.packageMembers});
//
//   PackageDetails.fromJson(Map<String, dynamic> json) {
//     packageId = json['package_id'];
//     packageMembers = json['package_members'].cast<int>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['package_id'] = this.packageId;
//     data['package_members'] = this.packageMembers;
//     return data;
//   }
// }
