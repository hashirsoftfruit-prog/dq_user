class QuestionnaireModel {
  bool? status;
  List<Questionnaires>? questionnaires;

  QuestionnaireModel({this.status, this.questionnaires});

  QuestionnaireModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['questionnaires'] != null) {
      questionnaires = <Questionnaires>[];
      json['questionnaires'].forEach((v) {
        questionnaires!.add(Questionnaires.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (questionnaires != null) {
      data['questionnaires'] = questionnaires!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questionnaires {
  int? id;
  String? questionType;
  String? question;
  bool? isMandatory;
  bool? isMultipleAnswers;
  List<Options>? options;
  List<int> optionIdList = [];
  String descriptiveAnswer = '';

  Questionnaires(
      {this.id,
      this.questionType,
      this.isMandatory,
      this.question,
      this.options});

  Questionnaires.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionType = json['question_type'];
    isMandatory = json['is_mandatory'];
    isMultipleAnswers = json['is_multiple_answers'];
    question = json['question'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question_type'] = questionType;
    data['question'] = question;
    data['is_mandatory'] = isMandatory;
    data['is_multiple_answers'] = isMultipleAnswers;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  int? id;
  String? option;

  Options({this.id, this.option});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    option = json['option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['option'] = option;
    return data;
  }
}

class QuestionareAnswers {
  int? bookingId;
  List<Answers>? answers;

  QuestionareAnswers({this.bookingId, this.answers});

  QuestionareAnswers.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    if (answers != null) {
      data['answers'] = answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answers {
  int? questionnaireId;
  String? questionType;
  List<int>? optionIdList;
  String? descriptiveAnswer;

  Answers(
      {this.questionnaireId,
      this.questionType,
      this.optionIdList,
      this.descriptiveAnswer});

  Answers.fromJson(Map<String, dynamic> json) {
    questionnaireId = json['questionnaire_id'];
    questionType = json['question_type'];
    optionIdList = json['option_id_list'].cast<int>();
    descriptiveAnswer = json['descriptive_answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['questionnaire_id'] = questionnaireId;
    data['question_type'] = questionType;
    data['option_id_list'] = optionIdList;
    data['descriptive_answer'] = descriptiveAnswer;
    return data;
  }
}
