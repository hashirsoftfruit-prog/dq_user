class ForumGeneralDatamodel {
  bool? status;
  String? message;
  int? veterinaryTreatmentId;
  List<Treatments>? professions;
  List<Treatments>? treatments;
  List<ForumUsers>? forumUsers;

  ForumGeneralDatamodel(
      {this.status,
      this.message,
      this.professions,
      this.veterinaryTreatmentId,
      this.treatments,
      this.forumUsers});

  ForumGeneralDatamodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    veterinaryTreatmentId = json['veterinary_treatment_id'];
    if (json['professions'] != null) {
      professions = <Treatments>[];
      json['professions'].forEach((v) {
        professions!.add(Treatments.fromJson(v));
      });
    }
    if (json['treatments'] != null) {
      treatments = <Treatments>[];
      json['treatments'].forEach((v) {
        treatments!.add(Treatments.fromJson(v));
      });
    }
    if (json['forum_users'] != null) {
      forumUsers = <ForumUsers>[];
      json['forum_users'].forEach((v) {
        forumUsers!.add(ForumUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['veterinary_treatment_id'] = veterinaryTreatmentId;
    if (professions != null) {
      data['professions'] = professions!.map((v) => v.toJson()).toList();
    }
    if (treatments != null) {
      data['treatments'] = treatments!.map((v) => v.toJson()).toList();
    }
    if (forumUsers != null) {
      data['forum_users'] = forumUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Treatments {
  int? id;
  String? title;

  Treatments({this.id, this.title});

  Treatments.fromJson(Map<String, dynamic> json) {
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

class ForumUsers {
  int? id;
  String? relation;
  String? gender;
  String? dateOfBirth;
  String? email;

  ForumUsers(
      {this.id, this.relation, this.gender, this.dateOfBirth, this.email});

  ForumUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    relation = json['relation'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['relation'] = relation;
    data['gender'] = gender;
    data['date_of_birth'] = dateOfBirth;
    data['email'] = email;
    return data;
  }
}
