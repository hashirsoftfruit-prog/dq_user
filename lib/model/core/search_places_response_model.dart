class SearchPlacesModel {
  List<Items>? items;

  SearchPlacesModel({this.items});

  SearchPlacesModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? title;
  String? id;
  String? language;
  String? resultType;
  Address? address;
  Positions? position;
  int? distance;
  List<Categories>? categories;
  List<References>? references;
  // List<Contacts>? contacts;
  List<OpeningHours>? openingHours;

  Items(
      {this.title,
      this.id,
      this.language,
      this.resultType,
      this.address,
      this.position,
      this.distance,
      this.categories,
      this.references,
      // this.contacts,
      this.openingHours});

  Items.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    language = json['language'];
    resultType = json['resultType'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    position =
        json['position'] != null ? Positions.fromJson(json['position']) : null;

    distance = json['distance'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['references'] != null) {
      references = <References>[];
      json['references'].forEach((v) {
        references!.add(References.fromJson(v));
      });
    }
    // if (json['contacts'] != null) {
    //   contacts = <Contacts>[];
    //   json['contacts'].forEach((v) {
    //     contacts!.add(new Contacts.fromJson(v));
    //   });
    // }

    if (json['openingHours'] != null) {
      openingHours = <OpeningHours>[];
      json['openingHours'].forEach((v) {
        openingHours!.add(OpeningHours.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['id'] = id;
    data['language'] = language;
    data['resultType'] = resultType;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (position != null) {
      data['position'] = position!.toJson();
    }

    data['distance'] = distance;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (references != null) {
      data['references'] = references!.map((v) => v.toJson()).toList();
    }
    // if (this.contacts != null) {
    //   data['contacts'] = this.contacts!.map((v) => v.toJson()).toList();
    // }

    if (openingHours != null) {
      data['openingHours'] = openingHours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Address {
  String? label;
  String? countryCode;
  String? countryName;
  String? stateCode;
  String? state;
  String? county;
  String? city;
  String? district;
  String? subdistrict;
  String? street;
  String? postalCode;

  Address(
      {this.label,
      this.countryCode,
      this.countryName,
      this.stateCode,
      this.state,
      this.county,
      this.city,
      this.district,
      this.subdistrict,
      this.street,
      this.postalCode});

  Address.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    countryCode = json['countryCode'];
    countryName = json['countryName'];
    stateCode = json['stateCode'];
    state = json['state'];
    county = json['county'];
    city = json['city'];
    district = json['district'];
    subdistrict = json['subdistrict'];
    street = json['street'];
    postalCode = json['postalCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['countryCode'] = countryCode;
    data['countryName'] = countryName;
    data['stateCode'] = stateCode;
    data['state'] = state;
    data['county'] = county;
    data['city'] = city;
    data['district'] = district;
    data['subdistrict'] = subdistrict;
    data['street'] = street;
    data['postalCode'] = postalCode;
    return data;
  }
}

class Positions {
  double? lat;
  double? lng;

  Positions({this.lat, this.lng});

  Positions.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Categories {
  String? id;
  String? name;
  bool? primary;

  Categories({this.id, this.name, this.primary});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    primary = json['primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['primary'] = primary;
    return data;
  }
}

class References {
  Supplier? supplier;
  String? id;

  References({this.supplier, this.id});

  References.fromJson(Map<String, dynamic> json) {
    supplier =
        json['supplier'] != null ? Supplier.fromJson(json['supplier']) : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (supplier != null) {
      data['supplier'] = supplier!.toJson();
    }
    data['id'] = id;
    return data;
  }
}

class Supplier {
  String? id;

  Supplier({this.id});

  Supplier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

// class Contacts {
//   List<Phone>? phone;
//
//   Contacts({this.phone, this.www});
//
//   Contacts.fromJson(Map<String, dynamic> json) {
//     if (json['phone'] != null) {
//       phone = <Phone>[];
//       json['phone'].forEach((v) {
//         phone!.add(new Phone.fromJson(v));
//       });
//     }
//     if (json['www'] != null) {
//       www = <Www>[];
//       json['www'].forEach((v) {
//         www!.add(new Www.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.phone != null) {
//       data['phone'] = this.phone!.map((v) => v.toJson()).toList();
//     }
//     if (this.www != null) {
//       data['www'] = this.www!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class Phone {
  String? value;

  Phone({this.value});

  Phone.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    return data;
  }
}

class OpeningHours {
  List<String>? text;
  bool? isOpen;
  List<Structured>? structured;

  OpeningHours({this.text, this.isOpen, this.structured});

  OpeningHours.fromJson(Map<String, dynamic> json) {
    text = json['text'].cast<String>();
    isOpen = json['isOpen'];
    if (json['structured'] != null) {
      structured = <Structured>[];
      json['structured'].forEach((v) {
        structured!.add(Structured.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['isOpen'] = isOpen;
    if (structured != null) {
      data['structured'] = structured!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Structured {
  String? start;
  String? duration;
  String? recurrence;

  Structured({this.start, this.duration, this.recurrence});

  Structured.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    duration = json['duration'];
    recurrence = json['recurrence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['duration'] = duration;
    data['recurrence'] = recurrence;
    return data;
  }
}
