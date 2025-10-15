class PetTypesListModel {
  bool? status;
  String? message;
  List<PetList>? petList;

  PetTypesListModel({this.status, this.message, this.petList});

  PetTypesListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['pet_list'] != null) {
      petList = <PetList>[];
      json['pet_list'].forEach((v) {
        petList!.add(PetList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (petList != null) {
      data['pet_list'] = petList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PetList {
  int? id;
  String? name;
  String? image;
  String? description;
  List<Breed>? breeds;

  PetList({this.id, this.name, this.image, this.description, this.breeds});

  PetList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    if (json['breeds'] != null) {
      breeds = <Breed>[];
      json['breeds'].forEach((v) {
        breeds!.add(Breed.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['description'] = description;
    if (breeds != null) {
      data['breeds'] = breeds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Breed {
  int? id;
  String? title;

  Breed({this.id, this.title});

  Breed.fromJson(Map<String, dynamic> json) {
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
