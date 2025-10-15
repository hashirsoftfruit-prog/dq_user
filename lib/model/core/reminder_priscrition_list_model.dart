import 'package:dqapp/model/core/reminder_binding_data_model.dart';

class ReminderPriscriptionList {
  bool? status;
  String? message;
  List<PriscriptionData>? drugSerializer;

  ReminderPriscriptionList({this.status, this.message, this.drugSerializer});

  ReminderPriscriptionList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['drug_serializer'] != null) {
      drugSerializer = <PriscriptionData>[];
      json['drug_serializer'].forEach((v) {
        drugSerializer!.add(PriscriptionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (drugSerializer != null) {
      data['drug_serializer'] = drugSerializer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PriscriptionData {
  int? id;
  String? patientName;
  String? patientAge;
  String? gender;
  String? address;
  String? complaints;
  String? observations;
  String? instructions;
  String? doctorFirstName;
  String? doctorLastName;
  String? doctorProfessionalQualifications;
  String? doctorCity;
  String? doctorState;
  String? doctorCountry;
  List<DrugSerializer>? drugs;

  PriscriptionData({
    this.id,
    this.patientName,
    this.patientAge,
    this.gender,
    this.address,
    this.complaints,
    this.observations,
    this.instructions,
    this.doctorFirstName,
    this.doctorLastName,
    this.doctorProfessionalQualifications,
    this.doctorCity,
    this.doctorState,
    this.doctorCountry,
    this.drugs,
  });

  PriscriptionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientName = json['patient_name'];
    patientAge = json['patient_age'];
    gender = json['gender'];
    address = json['address'];
    complaints = json['complaints'];
    observations = json['observations'];
    instructions = json['instructions'];
    doctorFirstName = json['doctor_first_name'];
    doctorLastName = json['doctor_last_name'];
    doctorProfessionalQualifications =
        json['doctor_professional_qualifications'];
    doctorCity = json['doctor_city'];
    doctorState = json['doctor_state'];
    doctorCountry = json['doctor_country'];

    if (json['drugs'] != null) {
      drugs = <DrugSerializer>[];
      json['drugs'].forEach((v) {
        drugs!.add(DrugSerializer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['patient_name'] = patientName;
    data['patient_age'] = patientAge;
    data['gender'] = gender;
    data['address'] = address;
    data['complaints'] = complaints;
    data['observations'] = observations;
    data['instructions'] = instructions;
    data['doctor_first_name'] = doctorFirstName;
    data['doctor_last_name'] = doctorLastName;
    data['doctor_professional_qualifications'] =
        doctorProfessionalQualifications;
    data['doctor_city'] = doctorCity;
    data['doctor_state'] = doctorState;
    data['doctor_country'] = doctorCountry;

    if (drugs != null) {
      data['drugs'] = drugs!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

// class Drugs {
//   int? id;
//   int? drug;
//   String? drugType;
//   String? drugUnit;
//   bool? dailyMedication;
//   Null? interval;
//   int? duration;
//   String? medicineInstruction;
//   String? drugName;
//   List<DosageList>? dosageList;
//
//   Drugs(
//       {this.id,
//         this.drug,
//         this.drugType,
//         this.drugUnit,
//         this.dailyMedication,
//         this.interval,
//         this.duration,
//         this.medicineInstruction,
//         this.drugName,
//         this.dosageList});
//
//   Drugs.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     drug = json['drug'];
//     drugType = json['drug_type'];
//     drugUnit = json['drug_unit'];
//     dailyMedication = json['daily_medication'];
//     interval = json['interval'];
//     duration = json['duration'];
//     medicineInstruction = json['medicine_instruction'];
//     drugName = json['drug_name'];
//     if (json['dosage_list'] != null) {
//       dosageList = <DosageList>[];
//       json['dosage_list'].forEach((v) {
//         dosageList!.add(new DosageList.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['drug'] = this.drug;
//     data['drug_type'] = this.drugType;
//     data['drug_unit'] = this.drugUnit;
//     data['daily_medication'] = this.dailyMedication;
//     data['interval'] = this.interval;
//     data['duration'] = this.duration;
//     data['medicine_instruction'] = this.medicineInstruction;
//     data['drug_name'] = this.drugName;
//     if (this.dosageList != null) {
//       data['dosage_list'] = this.dosageList!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class DosageList {
//   String? time;
//   int? dosage;
//
//   DosageList({this.time, this.dosage});
//
//   DosageList.fromJson(Map<String, dynamic> json) {
//     time = json['time'];
//     dosage = json['dosage'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['time'] = this.time;
//     data['dosage'] = this.dosage;
//     return data;
//   }
// }
