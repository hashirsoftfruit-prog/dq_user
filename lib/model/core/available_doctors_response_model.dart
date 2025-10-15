class BookingDataDetailsModel {
  bool? status;
  String? message;
  bool? packageAvailability;
  bool? seniorCitizen;
  bool? isAgeProofSubmitted;
  bool? isFreeDoctorAvailable;
  bool? femaleDoctorAvailability;
  bool? maleDoctorAvailability;
  List<Doctors>? doctors;
  DoctorCatogory? minDoctors;
  DoctorCatogory? midDoctors;
  DoctorCatogory? maxDoctors;
  bool? isAnyDoctorExist;
  DoctorCatogory? selectedPriceCategory;

  BookingDataDetailsModel({
    this.status,
    this.isAnyDoctorExist,
    this.minDoctors,
    this.midDoctors,
    this.maxDoctors,
    this.packageAvailability,
    this.femaleDoctorAvailability,
    this.maleDoctorAvailability,
    this.isFreeDoctorAvailable,
    this.message,
  });

  BookingDataDetailsModel.fromJson(Map<String, dynamic> json) {
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

    minDoctors = json['min_doctors'] != null
        ? DoctorCatogory.fromJson(json['min_doctors'])
        : null;
    midDoctors = json['mid_doctors'] != null
        ? DoctorCatogory.fromJson(json['mid_doctors'])
        : null;
    maxDoctors = json['max_doctors'] != null
        ? DoctorCatogory.fromJson(json['max_doctors'])
        : null;

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

class Doctors {
  int? id;
  String? image;
  String? firstName;
  String? lastName;
  String? gender;
  String? experience;
  String? description;
  String? mlFirstName;
  String? qualification;
  String? subSpecialityFee;
  int? completedBookingCount;
  List<Education>? education;
  List<Experiences>? experiences;
  List<Awards>? awards;
  List<Memberships>? memberships;
  List<Services>? services;
  List<Languages>? languages;
  List<Speciality>? specialities;

  Doctors({
    this.id,
    this.image,
    this.firstName,
    this.lastName,
    this.gender,
    this.experience,
    this.description,
    this.mlFirstName,
    this.qualification,
    this.subSpecialityFee,
    this.completedBookingCount,
    this.education,
    this.experiences,
    this.awards,
    this.memberships,
    this.services,
    this.languages,
    this.specialities,
  });

  Doctors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    description = json['description'];
    experience = json['experience']?.toString();
    mlFirstName = json['ml_first_name'];
    qualification = json['qualification'];
    subSpecialityFee = json['subspeciality_fees']?.toString();
    completedBookingCount = json['completed_booking_count'];

    if (json['education'] != null) {
      education = (json['education'] as List)
          .map((e) => Education.fromJson(e))
          .toList();
    }
    if (json['experiences'] != null) {
      experiences = (json['experiences'] as List)
          .map((e) => Experiences.fromJson(e))
          .toList();
    }
    if (json['awards'] != null) {
      awards = (json['awards'] as List).map((e) => Awards.fromJson(e)).toList();
    }
    if (json['memberships'] != null) {
      memberships = (json['memberships'] as List)
          .map((e) => Memberships.fromJson(e))
          .toList();
    }
    if (json['services'] != null) {
      services =
          (json['services'] as List).map((e) => Services.fromJson(e)).toList();
    }
    if (json['languages'] != null) {
      languages = (json['languages'] as List)
          .map((e) => Languages.fromJson(e))
          .toList();
    }
    if (json['speciality'] != null) {
      specialities = (json['speciality'] as List)
          .map((e) => Speciality.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['gender'] = gender;
    data['experience'] = experience;
    data['description'] = description;
    data['ml_first_name'] = mlFirstName;
    data['qualification'] = qualification;
    data['subspeciality_fees'] = subSpecialityFee;
    data['completed_booking_count'] = completedBookingCount;
    if (education != null) {
      data['education'] = education!.map((e) => e.toJson()).toList();
    }
    if (experiences != null) {
      data['experiences'] = experiences!.map((e) => e.toJson()).toList();
    }
    if (awards != null) {
      data['awards'] = awards!.map((e) => e.toJson()).toList();
    }
    if (memberships != null) {
      data['memberships'] = memberships!.map((e) => e.toJson()).toList();
    }
    if (services != null) {
      data['services'] = services!.map((e) => e.toJson()).toList();
    }
    if (languages != null) {
      data['languages'] = languages!.map((e) => e.toJson()).toList();
    }
    if (specialities != null) {
      data['speciality'] = specialities!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Awards {
  int? id;
  String? awardTitle;
  String? receivedDate;

  Awards({this.id, this.awardTitle, this.receivedDate});

  Awards.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    awardTitle = json['award_title'];
    receivedDate = json['received_date'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'award_title': awardTitle,
        'received_date': receivedDate,
      };
}

class Memberships {
  int? id;
  String? membershipId;
  String? membershipTitle;
  String? receivedDate;

  Memberships(
      {this.id, this.membershipId, this.membershipTitle, this.receivedDate});

  Memberships.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    membershipId = json['membership_id'];
    membershipTitle = json['membership_title'];
    receivedDate = json['received_date'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'membership_id': membershipId,
        'membership_title': membershipTitle,
        'received_date': receivedDate,
      };
}

class Services {
  int? id;
  int? serviceId;
  String? serviceTitle;

  Services({this.id, this.serviceId, this.serviceTitle});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    serviceTitle = json['service_title'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'service_id': serviceId,
        'service_title': serviceTitle,
      };
}

class Languages {
  int? id;
  int? languageId;
  String? languageTitle;

  Languages({this.id, this.languageId, this.languageTitle});

  Languages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageId = json['language_id'];
    languageTitle = json['language_title'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'language_id': languageId,
        'language_title': languageTitle,
      };
}

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

class Speciality {
  int? id;
  int? specialityId;
  String? specialityTitle;
  String? specialityImage;
  double? specialityOnlineFees;
  double? specialityOfflineFees;
  String? consultationCategory;

  Speciality({
    this.id,
    this.specialityId,
    this.specialityTitle,
    this.specialityImage,
    this.specialityOnlineFees,
    this.specialityOfflineFees,
    this.consultationCategory,
  });

  Speciality.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specialityId = json['speciality_id'];
    specialityTitle = json['speciality_title'];
    specialityImage = json['speciality_image'];
    specialityOnlineFees = (json['speciality_online_fees'] as num?)?.toDouble();
    specialityOfflineFees =
        (json['speciality_offline_fees'] as num?)?.toDouble();
    consultationCategory = json['consultation_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['speciality_id'] = specialityId;
    data['speciality_title'] = specialityTitle;
    data['speciality_image'] = specialityImage;
    data['speciality_online_fees'] = specialityOnlineFees;
    data['speciality_offline_fees'] = specialityOfflineFees;
    data['consultation_category'] = consultationCategory;
    return data;
  }
}

class DoctorCatogory {
  String? title;
  int? consultationCategory;
  List<Doctors>? doctors;

  DoctorCatogory({this.title, this.doctors, this.consultationCategory});

  DoctorCatogory.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    consultationCategory = json['consultation_category'];
    if (json['doctors'] != null) {
      doctors = <Doctors>[];
      json['doctors'].forEach((v) {
        doctors!.add(Doctors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (doctors != null) {
      data['doctors'] = doctors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
