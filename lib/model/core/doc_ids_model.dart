class DocIds {
  bool? status;
  String? message;
  List<IdTypes>? idTypes;

  DocIds({this.status, this.message, this.idTypes});

  DocIds.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['id_types'] != null) {
      idTypes = <IdTypes>[];
      json['id_types'].forEach((v) {
        idTypes!.add(IdTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (idTypes != null) {
      data['id_types'] = idTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IdTypes {
  int? id;
  String? name;

  IdTypes({this.id, this.name});

  IdTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
