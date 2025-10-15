class FieldOfMedicineModel {
  bool? status;
  String? message;
  List<FieldOfMedicines>? fieldOfMedicines;

  FieldOfMedicineModel({this.status, this.message, this.fieldOfMedicines});

  FieldOfMedicineModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['field_of_medicines'] != null) {
      fieldOfMedicines = <FieldOfMedicines>[];
      json['field_of_medicines'].forEach((v) {
        fieldOfMedicines!.add(FieldOfMedicines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (fieldOfMedicines != null) {
      data['field_of_medicines'] =
          fieldOfMedicines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FieldOfMedicines {
  int? id;
  String? title;
  String? slug;

  FieldOfMedicines({this.id, this.title, this.slug});

  FieldOfMedicines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    return data;
  }
}
