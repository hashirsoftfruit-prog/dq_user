import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dqapp/controller/managers/state_manager.dart';
import 'package:dqapp/model/core/profile_model.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/core/basic_response_model.dart';
import '../../model/core/medical_suggestions_model.dart';
import '../../model/helper/service_locator.dart';
import '../services/api_endpoints.dart';
import '../services/dio_service.dart';

class ProfileManager extends ChangeNotifier {
  bool profileReadonly = true;
  int tabIndex = 0;
  bool profileEditable = false;
  ProfileModel profileModel = ProfileModel(
    healthDetails: HeatlthDetails(),
    personalDetails: PersonalDetails(),
  );
  MedicalInfoSuggestionsModel? medicalSuggestions;

  setProfileEditable(bool val) {
    profileEditable = val;
    notifyListeners();
  }

  disposeProfile() {
    profileEditable = false;
  }

  Future<BasicResponseModel> updatePersonalDetails(
    Map<String, dynamic> data,
  ) async {
    String endpoint = Endpoints.userProfilePersonalDetails;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    // = profileModel.personalDetails!.toJson();
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      var resp = BasicResponseModel.fromJson(responseData);
      return resp;
    } else {
      return BasicResponseModel(status: false, message: "Failed");
    }
  }

  Future<BasicResponseModel> updateMedicalInfo({
    required String type,
    required List<BasicListItem> items,
    required List<BasicListItem> previousList,
    // required List<int> createdIds,
    // required List<int> deletedIds,
  }) async {
    // print('items');
    // for (var z in items) {
    //   print(z.toJson());
    // }
    // print('previuosList');
    // for (var z in previousList) {
    //   print(z.toJson());
    // }

    // List<String> newlyAddedItems = items.map((e) => e.item).whereType<String>().toList();
    // print('newlyAddedItems');
    // for (var z in newlyAddedItems) {
    //   print(z);
    // }

    // List<int> createdIds = previousList.where((item) => !items.contains(item)).toList()
    // List<String> addedFromList = items.where((item) => previousList.contains(item)).toList()
    //     .map((e) => e.item )
    //     .whereType<String>()
    //     .toList();
    //
    List<String> addedFromList = <dynamic>{
      ...items.map((e) => e.item).toList(),
      ...previousList.map((e) => e.item).toList(),
    }.toList().whereType<String>().toList();

    List<String> finall = addedFromList
        .where(
          (item) => !previousList.map((e) => e.item).toList().contains(item),
        )
        .toList();

    // print('addedFromList');
    // for (var z in addedFromList) {
    //   print(z);
    // }

    List<int> existingIds = previousList
        .where((item) => items.map((e) => e.item).contains(item.item))
        .toList()
        .map((e) => e.id)
        .whereType<int>()
        .toList();
    // List<int> existingIds = items.where((item) => item.id != null).toList().map((e) => e.id).whereType<int>().toList();
    // List<String> newlyCreatedItems = items.where((item) => item.id == null).toList().map((e) => e.item).whereType<String>().toList();

    // print('existing_ids $existingIds');

    // for (var i in previousList.where((item) => items.map((e) => e.item).contains(item.item)).toList()) {
    //   print(i.toJson());
    // }

    Map<String, dynamic> data = {
      "type":
          type, //type : "allergies" ,"current_medications", "past_medications","chronic_diseases","injuries","surgeries"
      type: finall,
      // type: finall,
      // "current_medications":[...addedFromList,],
      // "created_ids":createdIds,
      "existing_ids": existingIds,
      // "deleted_ids":deletedIds
    };

    // print('datas $data');

    String endpoint = Endpoints.userMedicalInfoUpdate;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    // = profileModel.personalDetails!.toJson();
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      var resp = BasicResponseModel.fromJson(responseData);
      // print('resp ${resp.toJson()}');
      return resp;
    } else {
      return BasicResponseModel(status: false, message: "Failed");
    }
  }

  Future<BasicResponseModel> updateHealthDetails(
    Map<String, dynamic> data,
  ) async {
    String endpoint = Endpoints.userProfileHealthDetails;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    // = profileModel.personalDetails!.toJson();
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      var resp = BasicResponseModel.fromJson(responseData);
      return resp;
    } else {
      return BasicResponseModel(status: false, message: "Failed");
    }
  }

  changeIndex(int val) {
    tabIndex = val;
    notifyListeners();
  }

  initProfile() async {
    await Future.delayed(const Duration(milliseconds: 50));
    changeIndex(0);
    getMedicalSuggestions();
  }

  updateFirstname(val) {
    profileModel.personalDetails!.firstName = val;
    notifyListeners();
  }

  updateProPicname(val) {
    profileModel.personalDetails!.image = val;
    notifyListeners();
  }

  updateLastName(val) {
    profileModel.personalDetails!.lastName = val;
    notifyListeners();
  }

  updateEmail(val) {
    profileModel.personalDetails!.email = val;
    notifyListeners();
  }

  updateGenderInProfileModel(val) {
    profileModel.personalDetails!.gender = val;
    notifyListeners();
  }

  updateMaritalStatusInProfileModel(val) {
    profileModel.personalDetails!.maritalStatus = val;
    notifyListeners();
  }

  updateMaritalStatus(val) {
    profileModel.personalDetails!.maritalStatus = val;
    notifyListeners();
  }

  updateHeight(val) {
    profileModel.healthDetails!.height = val;
    notifyListeners();
  }

  updateWeight(val) {
    profileModel.healthDetails!.weight = val;
    notifyListeners();
  }

  updateBloodGroup(val) {
    profileModel.healthDetails!.bloodGroup = val;
    notifyListeners();
  }

  updateBloodP(val) {
    profileModel.healthDetails!.bloodPressure = val;
    notifyListeners();
  }

  getProfileData() async {
    String endpoint = Endpoints.userProfile;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);
    // print(responseData['medical_details']);

    if (responseData != null) {
      profileModel = ProfileModel.fromJson(responseData);

      getIt<SharedPreferences>().setString(
        StringConstants.proImage,
        profileModel.personalDetails?.image ?? "",
      );

      notifyListeners();
      // print(profileModel.medicalDetails!.height);
    } else {
      // return SymptomsAndIssuesModel(status: false);
    }
  }

  getMedicalSuggestions() async {
    String endpoint = Endpoints.medicalSuggestions;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);
    // print('getMedicalSuggestions ${responseData['suggestions'].where((e) => e['type'] == "Chronic Disease").toList()}');

    if (responseData != null) {
      medicalSuggestions = MedicalInfoSuggestionsModel.fromJson(responseData);
      notifyListeners();
    } else {}
  }

  int? findIndexFromList({
    required List<String> lst,
    required String selectedValue,
  }) {
    int? returnIndex;
    for (int i = 0; i < lst.length; i++) {
      if (lst[i] == selectedValue) {
        returnIndex = i;
      }
    }
    return returnIndex;
  }

  Future<BasicResponseModel> changeProPic(XFile file) async {
    String filePath = file.path;
    MultipartFile.fromFileSync(
      file.path,
      filename: filePath.split('/').last,
      // contentType:MediaType.,
    );

    String endpoint = Endpoints.userProfileImageUpdate;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    final formData = FormData.fromMap({
      "image": MultipartFile.fromFileSync(
        file.path,
        filename: filePath.split('/').last,
        // contentType:MediaType.,
      ),
    });

    dynamic responseData = await getIt<DioClient>().post(
      endpoint,
      formData,
      tokn,
    );

    if (responseData != null) {
      var resp = BasicResponseModel.fromJson(responseData);
      return resp;
    } else {
      return BasicResponseModel(status: true, message: "Failed");
      // return SymptomsAndIssuesModel(status: false);
    }
  }

  Future<BasicResponseModel> changeLocale(String newLocale) async {
    String endpoint = Endpoints.updateLanguage;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    final data = {"languages": newLocale == "ml" ? "Malayalam" : "English"};
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log(responseData.toString());
    if (responseData != null) {
      var resp = BasicResponseModel.fromJson(responseData);
      getIt<StateManager>().changeLocale(newLocale);

      return resp;
    } else {
      return BasicResponseModel(status: true, message: "Failed");
      // return SymptomsAndIssuesModel(status: false);
    }
  }
}

// getToken()
