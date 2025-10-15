class MyPetsListModel {
  bool? status;
  String? message;
  List<MyPetModel>? myPetsList;

  MyPetsListModel({this.status, this.message, this.myPetsList});

  MyPetsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['pet_details'] != null) {
      myPetsList = <MyPetModel>[];
      json['pet_details'].forEach((v) {
        myPetsList!.add(MyPetModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (myPetsList != null) {
      data['pet_details'] = myPetsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyPetModel {
  int? id;
  String? name;
  String? gender;
  String? pet;
  String? breed;
  String? dateOfBirth;
  int? petId;
  int? breedId;
  int? veterinarySpecialityId;

  MyPetModel(
      {this.id,
      this.name,
      this.gender,
      this.pet,
      this.breed,
      this.dateOfBirth,
      this.petId,
      this.veterinarySpecialityId,
      this.breedId});

  MyPetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    gender = json['gender'];
    pet = json['pet'];
    breed = json['breed'];
    dateOfBirth = json['date_of_birth'];
    petId = json['pet_id'];
    breedId = json['breed_id'];
    veterinarySpecialityId = json['veterinary_speciality_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['gender'] = gender;
    data['pet'] = pet;
    data['breed'] = breed;
    data['veterinary_speciality_id'] = veterinarySpecialityId;
    data['date_of_birth'] = dateOfBirth;
    data['pet_id'] = petId;
    data['breed_id'] = breedId;
    return data;
  }
}
