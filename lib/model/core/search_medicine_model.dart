class MedicineListModel {
  bool? status;
  String? message;
  List<DrugItem>? drugSerializer;

  MedicineListModel({this.status, this.message, this.drugSerializer});

  MedicineListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['drug_serializer'] != null) {
      drugSerializer = <DrugItem>[];
      json['drug_serializer'].forEach((v) {
        drugSerializer!.add(DrugItem.fromJson(v));
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

class DrugItem {
  int? id;
  String? title;

  DrugItem({this.id, this.title});

  DrugItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}
