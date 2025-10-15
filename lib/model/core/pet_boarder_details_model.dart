class PetBoarderDetailsModel {
  bool? status;
  String? message;
  BoardingDetails? boardingDetails;

  PetBoarderDetailsModel({this.status, this.message, this.boardingDetails});

  PetBoarderDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    boardingDetails = json['boarding_details'] != null
        ? BoardingDetails.fromJson(json['boarding_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (boardingDetails != null) {
      data['boarding_details'] = boardingDetails!.toJson();
    }
    return data;
  }
}

class BoardingDetails {
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
  double? ratePerHour;
  double? ratePerDay;
  double? ratePerWeek;
  String? openedDate;
  String? joinedOnAppDate;
  String? boardingTeamType;
  List<Timings>? timings;
  List<Images>? images;
  List<Facilities>? facilities;

  BoardingDetails(
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
      this.ratePerHour,
      this.ratePerDay,
      this.ratePerWeek,
      this.openedDate,
      this.joinedOnAppDate,
      this.boardingTeamType,
      this.timings,
      this.images,
      this.facilities});

  BoardingDetails.fromJson(Map<String, dynamic> json) {
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
    ratePerHour = json['rate_per_hour'];
    ratePerDay = json['rate_per_day'];
    ratePerWeek = json['rate_per_week'];
    openedDate = json['opened_date'];
    joinedOnAppDate = json['joined_on_app_date'];
    boardingTeamType = json['boarding_team_type'];
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
    if (json['facilities'] != null) {
      facilities = <Facilities>[];
      json['facilities'].forEach((v) {
        facilities!.add(Facilities.fromJson(v));
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
    data['rate_per_hour'] = ratePerHour;
    data['rate_per_day'] = ratePerDay;
    data['rate_per_week'] = ratePerWeek;
    data['opened_date'] = openedDate;
    data['joined_on_app_date'] = joinedOnAppDate;
    data['boarding_team_type'] = boardingTeamType;
    if (timings != null) {
      data['timings'] = timings!.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (facilities != null) {
      data['facilities'] = facilities!.map((v) => v.toJson()).toList();
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

class Facilities {
  int? id;
  String? facility;

  Facilities({this.id, this.facility});

  Facilities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    facility = json['facility'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['facility'] = facility;
    return data;
  }
}
