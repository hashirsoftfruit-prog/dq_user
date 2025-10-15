class PetGroomersLIstModel {
  bool? status;
  String? message;
  List<PetGroomer>? petGroomers;

  PetGroomersLIstModel({this.status, this.message, this.petGroomers});

  PetGroomersLIstModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['pet_groomers'] != null) {
      petGroomers = <PetGroomer>[];
      json['pet_groomers'].forEach((v) {
        petGroomers!.add(PetGroomer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (petGroomers != null) {
      data['pet_groomers'] = petGroomers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PetGroomer {
  int? id;
  String? name;
  String? logo;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? pincode;
  String? primaryPhone;
  String? secondaryPhone;
  String? email;
  String? licenseNumber;
  String? gstNumber;
  double? latitude;
  double? longitude;
  String? openedDate;
  String? joinedOnAppDate;
  String? groomingTeamType;
  bool? hasHomeService;
  List<Timings>? timings;
  List<Images>? images;
  List<GroomingPets>? groomingPets;

  PetGroomer(
      {this.id,
      this.name,
      this.logo,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.country,
      this.pincode,
      this.primaryPhone,
      this.secondaryPhone,
      this.email,
      this.licenseNumber,
      this.gstNumber,
      this.latitude,
      this.longitude,
      this.openedDate,
      this.joinedOnAppDate,
      this.groomingTeamType,
      this.hasHomeService,
      this.timings,
      this.images,
      this.groomingPets});

  PetGroomer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pincode = json['pincode'];
    primaryPhone = json['primary_phone'];
    secondaryPhone = json['secondary_phone'];
    email = json['email'];
    licenseNumber = json['license_number'];
    gstNumber = json['gst_number'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    openedDate = json['opened_date'];
    joinedOnAppDate = json['joined_on_app_date'];
    groomingTeamType = json['grooming_team_type'];
    hasHomeService = json['has_home_service'];
    if (json['timings'] != null) {
      timings = <Timings>[];
      json['timings'].forEach((v) {
        timings!.add(Timings.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    if (json['grooming_pets'] != null) {
      groomingPets = <GroomingPets>[];
      json['grooming_pets'].forEach((v) {
        groomingPets!.add(GroomingPets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['pincode'] = pincode;
    data['primary_phone'] = primaryPhone;
    data['secondary_phone'] = secondaryPhone;
    data['email'] = email;
    data['license_number'] = licenseNumber;
    data['gst_number'] = gstNumber;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['opened_date'] = openedDate;
    data['joined_on_app_date'] = joinedOnAppDate;
    data['grooming_team_type'] = groomingTeamType;
    data['has_home_service'] = hasHomeService;
    if (timings != null) {
      data['timings'] = timings!.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (groomingPets != null) {
      data['grooming_pets'] = groomingPets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Timings {
  int? id;
  String? day;
  String? startHour;
  String? endHour;

  Timings({this.id, this.day, this.startHour, this.endHour});

  Timings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    day = json['day'];
    startHour = json['start_hour'];
    endHour = json['end_hour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['day'] = day;
    data['start_hour'] = startHour;
    data['end_hour'] = endHour;
    return data;
  }
}

class Images {
  int? id;
  String? image;

  Images({this.id, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    return data;
  }
}

class GroomingPets {
  int? id;
  String? pet;
  String? petIcon;
  List<ServiceDetails>? serviceDetails;

  GroomingPets({this.id, this.pet, this.petIcon, this.serviceDetails});

  GroomingPets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pet = json['pet'];
    petIcon = json['pet_icon'];
    if (json['service_details'] != null) {
      serviceDetails = <ServiceDetails>[];
      json['service_details'].forEach((v) {
        serviceDetails!.add(ServiceDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pet'] = pet;
    data['pet_icon'] = petIcon;
    if (serviceDetails != null) {
      data['service_details'] = serviceDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceDetails {
  int? id;
  String? service;
  String? defaultTime;
  String? amount;

  ServiceDetails({this.id, this.service, this.defaultTime, this.amount});

  ServiceDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    service = json['service'];
    defaultTime = json['default_time'];
    amount = json['amount']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service'] = service;
    data['default_time'] = defaultTime;
    data['amount'] = amount;
    return data;
  }
}
