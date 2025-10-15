class ProfileModel {
  bool? status;
  String? message;
  PersonalDetails? personalDetails;
  HeatlthDetails? healthDetails;
  MedicalDetails? medicalDetails;

  ProfileModel(
      {this.status, this.message, this.personalDetails, this.healthDetails});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    personalDetails = json['personal_details'] != null
        ? PersonalDetails.fromJson(json['personal_details'])
        : null;
    healthDetails = json['health_details'] != null
        ? HeatlthDetails.fromJson(json['health_details'])
        : null;
    medicalDetails = json['medical_details'] != null
        ? MedicalDetails.fromJson(json['medical_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (personalDetails != null) {
      data['personal_details'] = personalDetails!.toJson();
    }
    if (healthDetails != null) {
      data['health_details'] = healthDetails!.toJson();
    }
    if (medicalDetails != null) {
      data['medical_details'] = medicalDetails!.toJson();
    }
    return data;
  }
}

class PersonalDetails {
  int? id;
  String? image;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? gender;
  String? maritalStatus;
  String? language;
  int? userId;
  String? age;
  String? phone;
  String? email;

  PersonalDetails(
      {this.id,
      this.image,
      this.firstName,
      this.lastName,
      this.dateOfBirth,
      this.gender,
      this.maritalStatus,
      this.language,
      this.userId,
      this.age,
      this.phone,
      this.email});

  PersonalDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    maritalStatus = json['marital_status'];
    language = json['language'];
    userId = json['user_id'];
    age = json['age'].toString();
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['marital_status'] = maritalStatus;
    data['language'] = language;
    data['user_id'] = userId;
    data['age'] = age;
    data['phone'] = phone;
    data['email'] = email;
    return data;
  }
}

class HeatlthDetails {
  String? height;
  String? weight;
  String? bloodGroup;
  String? bloodSugar;
  String? bloodPressure;
  String? serumCreatinine;

  HeatlthDetails(
      {this.height,
      this.weight,
      this.bloodGroup,
      this.bloodSugar,
      this.bloodPressure,
      this.serumCreatinine});

  HeatlthDetails.fromJson(Map<String, dynamic> json) {
    height = json['height']?.toString();
    weight = json['weight']?.toString();
    bloodSugar = json['blood_sugar']?.toString();
    bloodGroup = json['blood_group'];
    bloodPressure = json['blood_pressure'];
    serumCreatinine = json['serum_creatinine']?.toString();
    // print(height);
    // print("height");
    // print(weight);
    // print("weight");
    // print(bloodSugar);
    // print("bloodSugar");
    // print(bloodGroup);
    // print("bloodGroup");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['height'] = height;
    data['weight'] = weight;
    data['blood_group'] = bloodGroup;
    data['blood_sugar'] = bloodSugar;
    data['blood_pressure'] = bloodPressure;
    data['serum_creatinine'] = serumCreatinine;
    return data;
  }
}

class MedicalDetails {
  int? id;
  List<Allergy>? allergy;
  List<CurrentMedication>? currentMedication;
  List<PastMedication>? pastMedication;
  List<ChronicDisease>? chronicDisease;
  List<Injury>? injury;
  List<Surgery>? surgery;

  MedicalDetails(
      {this.id,
      this.allergy,
      this.currentMedication,
      this.pastMedication,
      this.chronicDisease,
      this.injury,
      this.surgery});

  MedicalDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['allergy'] != null) {
      allergy = <Allergy>[];
      json['allergy'].forEach((v) {
        allergy!.add(Allergy.fromJson(v));
      });
    }
    if (json['current_medication'] != null) {
      currentMedication = <CurrentMedication>[];
      json['current_medication'].forEach((v) {
        currentMedication!.add(CurrentMedication.fromJson(v));
      });
      // print('currentMedication!.join()');
      // print(currentMedication!.join(', '));
    }
    if (json['past_medication'] != null) {
      pastMedication = <PastMedication>[];
      json['past_medication'].forEach((v) {
        pastMedication!.add(PastMedication.fromJson(v));
      });
    }
    if (json['chronic_disease'] != null) {
      chronicDisease = <ChronicDisease>[];
      json['chronic_disease'].forEach((v) {
        chronicDisease!.add(ChronicDisease.fromJson(v));
      });
    }
    if (json['injury'] != null) {
      injury = <Injury>[];
      json['injury'].forEach((v) {
        injury!.add(Injury.fromJson(v));
      });
    }
    if (json['surgery'] != null) {
      surgery = <Surgery>[];
      json['surgery'].forEach((v) {
        surgery!.add(Surgery.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (allergy != null) {
      data['allergy'] = allergy!.map((v) => v.toJson()).toList();
    }
    if (currentMedication != null) {
      data['current_medication'] =
          currentMedication!.map((v) => v.toJson()).toList();
    }
    if (pastMedication != null) {
      data['past_medication'] = pastMedication!.map((v) => v.toJson()).toList();
    }
    if (chronicDisease != null) {
      data['chronic_disease'] = chronicDisease!.map((v) => v.toJson()).toList();
    }
    if (injury != null) {
      data['injury'] = injury!.map((v) => v.toJson()).toList();
    }
    if (surgery != null) {
      data['surgery'] = surgery!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Allergy {
  int? id;
  String? allergy;

  Allergy({this.id, this.allergy});

  Allergy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    allergy = json['allergy']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['allergy'] = allergy;
    return data;
  }
}

class CurrentMedication {
  int? id;
  String? currentMedication;

  CurrentMedication({this.id, this.currentMedication});

  CurrentMedication.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currentMedication = json['current_medication'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['current_medication'] = currentMedication;
    return data;
  }
}

class PastMedication {
  int? id;
  String? pastMedication;

  PastMedication({this.id, this.pastMedication});

  PastMedication.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pastMedication = json['past_medication'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['past_medication'] = pastMedication;
    return data;
  }
}

class ChronicDisease {
  int? id;
  String? chronicDisease;

  ChronicDisease({this.id, this.chronicDisease});

  ChronicDisease.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chronicDisease = json['chronic_disease']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chronic_disease'] = chronicDisease;
    return data;
  }
}

class Injury {
  int? id;
  String? injury;

  Injury({this.id, this.injury});

  Injury.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    injury = json['injury']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['injury'] = injury;
    return data;
  }
}

class Surgery {
  int? id;
  int? surgery;

  Surgery({this.id, this.surgery});

  Surgery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    surgery = json['surgery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['surgery'] = surgery;
    return data;
  }
}
