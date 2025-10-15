import 'available_doctors_response_model.dart';

class PsychologyInstantResponseModel {
  bool? status;
  String? message;
  bool? packageAvailability;
  bool? seniorCitizen;
  bool? isAgeProofSubmitted;
  bool? isFreeDoctorAvailable;
  bool? femaleDoctorAvailability;
  bool? maleDoctorAvailability;
  List<Doctors>? doctors;
  bool? isAnyDoctorExist;

  PsychologyInstantResponseModel({
    this.status,
    this.isAnyDoctorExist,
    this.doctors,
    this.packageAvailability,
    this.femaleDoctorAvailability,
    this.maleDoctorAvailability,
    this.isFreeDoctorAvailable,
    this.message,
  });

  PsychologyInstantResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    isFreeDoctorAvailable = json['is_free_doctor_available'];
    packageAvailability = json['package_availability'];
    femaleDoctorAvailability = json['female_doctor_availability'];
    maleDoctorAvailability = json['male_doctor_availability'];
    seniorCitizen = json['senior_citizen'];
    isAgeProofSubmitted = json['is_age_proof_submitted'];
    isAnyDoctorExist = json['is_any_doctors_exist'];

    if (json['doctors'] != null) {
      doctors = <Doctors>[];
      json['doctors'].forEach((v) {
        doctors!.add(Doctors.fromJson(v));
      });
    }

    // doctorsSubList1 = [];
    // doctorsSubList2 = [];
    // doctorsSubList3 = [];
    //  Random random = Random();
    //
    // for (var i in doctors!) {
    //   int index = random.nextInt(3); // Generate random index between 0 and 2
    //
    //   // Add the number to the corresponding list based on the generated index
    //   switch (index) {
    //     case 0:
    //       doctorsSubList1!.add(i);
    //       break;
    //     case 1:
    //       doctorsSubList2!.add(i);
    //       break;
    //     case 2:
    //       doctorsSubList3!.add(i);
    //       break;
    //   }
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    data['package_availability'] = packageAvailability;
    data['is_free_doctor_available'] = isFreeDoctorAvailable;
    data['female_doctor_availability'] = femaleDoctorAvailability;
    data['male_doctor_availability'] = maleDoctorAvailability;
    data['senior_citizen'] = seniorCitizen;
    data['is_age_proof_submitted'] = isAgeProofSubmitted;

    return data;
  }
}

// class Doctors {
//   int? id;
//   String? image;
//   String? firstName;
//   String? experience;
//   String? mlFirstName;
//   String? qualification;
//   List<Education>? education;
//   List<Experiences>? experiences;
//
//   Doctors(
//       {this.id, this.image, this.firstName,this.experience, this.mlFirstName, this.education,
//         this.experiences});
//
//   Doctors.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     experience = json['experience'] !=null? json['experience'].toString() : null;
//     image = json['image'];
//     firstName = json['first_name'];
//     qualification = json['qualification'];
//     mlFirstName = json['ml_first_name'];
//     if (json['education'] != null) {
//       education = <Education>[];
//       json['education'].forEach((v) {
//         education!.add(new Education.fromJson(v));
//       });
//     }
//     if (json['experiences'] != null) {
//       experiences = <Experiences>[];
//       json['experiences'].forEach((v) {
//         experiences!.add(new Experiences.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['image'] = this.image;
//     data['experience'] = this.experience;
//     data['first_name'] = this.firstName;
//     data['qualification'] = this.qualification;
//     data['ml_first_name'] = this.mlFirstName;
//     if (this.education != null) {
//       data['education'] = this.education!.map((v) => v.toJson()).toList();
//     }
//     if (this.experiences != null) {
//       data['experiences'] = this.experiences!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
class Education {
  int? id;
  String? specialization;
  String? college;
  String? monthYearOfCompletion;
  String? description;
  String? qualificationLevel;

  Education(
      {this.id,
      this.specialization,
      this.college,
      this.monthYearOfCompletion,
      this.description,
      this.qualificationLevel});

  Education.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specialization = json['specialization'];
    college = json['college'];
    monthYearOfCompletion = json['month_year_of_completion'];
    description = json['description'];
    qualificationLevel = json['qualification_level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['specialization'] = specialization;
    data['college'] = college;
    data['month_year_of_completion'] = monthYearOfCompletion;
    data['description'] = description;
    data['qualification_level'] = qualificationLevel;
    return data;
  }
}

class Experiences {
  int? id;
  String? designation;
  String? hospitalName;
  String? location;
  String? locationType;

  Experiences({
    this.id,
    this.designation,
    this.hospitalName,
    this.location,
    this.locationType,
  });

  Experiences.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    designation = json['designation'];
    hospitalName = json['hospital_name'];
    location = json['location'];
    locationType = json['location_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['designation'] = designation;
    data['hospital_name'] = hospitalName;
    data['location'] = location;
    data['location_type'] = locationType;
    return data;
  }
}
