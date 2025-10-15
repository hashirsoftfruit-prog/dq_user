class PopularCitiesModel {
  bool? status;
  String? message;
  DefaultLocation? defaultLocation;
  List<PopularCities> popularCities = [];

  PopularCitiesModel(
      {this.status,
      this.message,
      this.defaultLocation,
      required this.popularCities});

  PopularCitiesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    defaultLocation = json['default_location'] != null
        ? DefaultLocation.fromJson(json['default_location'])
        : null;
    if (json['popular_cities'] != null) {
      popularCities = <PopularCities>[];
      json['popular_cities'].forEach((v) {
        popularCities.add(PopularCities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (defaultLocation != null) {
      data['default_location'] = defaultLocation!.toJson();
    }
    data['popular_cities'] = popularCities.map((v) => v.toJson()).toList();
    return data;
  }
}

class DefaultLocation {
  int? id;
  String? location;
  String? latitude;
  String? longitude;

  DefaultLocation({this.id, this.location, this.latitude, this.longitude});

  DefaultLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    location = json['location'];
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location'] = location;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class PopularCities {
  int? id;
  String? city;
  String? latitude;
  String? longitude;

  PopularCities({this.id, this.city, this.latitude, this.longitude});

  PopularCities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['city'] = city;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
