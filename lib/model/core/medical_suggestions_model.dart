class MedicalInfoSuggestionsModel {
  bool? status;
  String? message;
  List<Suggestions>? suggestions;
  List<Drugs>? drugs;

  MedicalInfoSuggestionsModel(
      {this.status, this.message, this.suggestions, this.drugs});

  MedicalInfoSuggestionsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['suggestions'] != null) {
      suggestions = <Suggestions>[];
      json['suggestions'].forEach((v) {
        suggestions!.add(Suggestions.fromJson(v));
      });
    }
    if (json['drugs'] != null) {
      drugs = <Drugs>[];
      json['drugs'].forEach((v) {
        drugs!.add(Drugs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (suggestions != null) {
      data['suggestions'] = suggestions!.map((v) => v.toJson()).toList();
    }
    if (drugs != null) {
      data['drugs'] = drugs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Suggestions {
  int? id;
  String? type;
  String? suggestion;

  Suggestions({this.id, this.type, this.suggestion});

  Suggestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    suggestion = json['suggestion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['suggestion'] = suggestion;
    return data;
  }
}

class Drugs {
  int? id;
  String? title;

  Drugs({this.id, this.title});

  Drugs.fromJson(Map<String, dynamic> json) {
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
