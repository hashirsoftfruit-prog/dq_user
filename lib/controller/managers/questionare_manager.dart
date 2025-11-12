import 'dart:developer';

import 'package:dqapp/view/theme/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/core/basic_response_model.dart';
import '../../model/core/questionare_response_model.dart';
import '../../model/helper/service_locator.dart';
import '../services/api_endpoints.dart';
import '../services/dio_service.dart';

class QuestionnaireManager extends ChangeNotifier {
  bool questionareLoader = false;
  QuestionnaireModel? questionnaireModel;
  String? questionareTextAnswer;

  disposeQuestionare() {
    questionnaireModel = null;
  }

  getQuestionnare(String appointmentID) async {
    String endpoint = Endpoints.questionnareDetails;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    final data = {"appointment_id": appointmentID};
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log("response of getQuestionnare $responseData");
    if (responseData != null) {
      var resp = QuestionnaireModel.fromJson(responseData);

      questionnaireModel = resp;
      notifyListeners();
    } else {
      // return CouponsModel(status: false);
    }
  }

  setQuestionareLoader(bool val) {
    questionareLoader = val;
    notifyListeners();
  }

  Future<BasicResponseModel> submitQuestionnare(int bookingId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    setQuestionareLoader(true);
    String endpoint = Endpoints.questionareSave;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    var qnAnswers = QuestionareAnswers.fromJson({
      "booking_id": bookingId,
      "answers": questionnaireModel!.questionnaires!.map(
        (e) => {
          "questionnaire_id": e.id,
          "question_type": e.questionType,
          "option_id_list": e.optionIdList,
          "descriptive_answer": e.descriptiveAnswer,
        },
      ),
    });

    Map<String, dynamic> data = qnAnswers.toJson();

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      setQuestionareLoader(false);

      var resp = BasicResponseModel.fromJson(responseData);
      return resp;
    } else {
      setQuestionareLoader(false);

      return BasicResponseModel(message: "Something went wrong", status: false);
    }
  }

  saveUserAnswer(int qnId, String qnType, String? txtAnswer, int? optionId) {
    int? index;
    var lst = questionnaireModel!.questionnaires!;
    for (var i in lst) {
      if (i.id == qnId) {
        index = lst.indexOf(i);
      }
    }

    if (lst[index!].questionType == StringConstants.qnTypeTxtBox) {
      lst[index].descriptiveAnswer = txtAnswer ?? "";
    } else if (optionId != null) {
      lst[index].optionIdList.add(optionId);
    }
  }

  saveTextAnswer({
    required int qnId,
    required String qnType,
    required String txtAnswer,
  }) {
    int? index;
    // var lst = questionnaireModel!.questionnaires!;
    for (var i in questionnaireModel!.questionnaires!) {
      if (i.id == qnId) {
        index = questionnaireModel!.questionnaires!.indexOf(i);
      }
    }

    questionnaireModel!.questionnaires![index!].descriptiveAnswer = txtAnswer;

    setQuestionareText(null);
  }

  saveOptionAnswer({
    required int qnId,
    bool? allowMultiple,
    String? qnType,
    required int optionId,
  }) {
    int? index;

    for (var i in questionnaireModel!.questionnaires!) {
      if (i.id == qnId) {
        index = questionnaireModel!.questionnaires!.indexOf(i);
      }
    }

    if (questionnaireModel!.questionnaires![index!].optionIdList.contains(
      optionId,
    )) {
      questionnaireModel!.questionnaires![index].optionIdList.remove(optionId);
    } else {
      if (allowMultiple != true) {
        questionnaireModel!.questionnaires![index].optionIdList = [];
      }
      questionnaireModel!.questionnaires![index].optionIdList.add(optionId);
    }

    notifyListeners();
  }

  /// Sets the answer for a text-based questionnaire.
  setQuestionareText(String? val) {
    //  setQuestionareText(String? val){
    questionareTextAnswer = val;
    notifyListeners();
    //  }
  }
}
