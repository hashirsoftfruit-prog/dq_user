// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:dqapp/controller/managers/state_manager.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../model/core/councelling_list_model.dart';
import '../../model/core/daily_wellness_data_model.dart';
import '../../model/core/meditation_videos_list_model.dart';
import '../../model/core/psychology_data.dart';
import '../../model/core/psychology_instant_doctors_response_model.dart';
import '../../model/core/therapy_councelling_list_model.dart';
import '../../model/core/upcome_appoiments_response_model.dart';
import '../../model/helper/service_locator.dart';
import '../../view/screens/councelling_therapy_screens/psychology_instant_doctors_screen.dart';
import '../../view/widgets/common_widgets.dart';
import '../services/api_endpoints.dart';
import '../services/dio_service.dart';

//this sepcifically handles the psychology related areas

class PsychologyManager extends ChangeNotifier {
  PsychologyData? psychologyData;
  DailyWellnessDataModel? dailyWellnessDataModel;
  MeditationVideosModel? meditationVideosModel;
  MeditationAudiosModel? meditationAudiosModel;
  TharapyCouncellingListModel? therapyCouncellingListModel;
  CouncellingListModel? counsellingListModel;
  bool psychologyTherapyListLoader = false;
  bool dashLoader = false;
  bool listLoader = false;
  bool bookingScreenLoader = false;
  PsychologyInstantDoctorScreenData psychologyInstantRequestData =
      PsychologyInstantDoctorScreenData();
  PsychologyInstantResponseModel psychologyInstantDoctorsModel =
      PsychologyInstantResponseModel();
  UpcomingAppoinmentsModel? upcomingAppointmentsModel;
  bool appoinmentsLoader = false;
  

  getPsychologyBookings({bool? isRefresh}) async {
    // print(upcomingAppointmentsModel?.toJson());
    if (upcomingAppointmentsModel == null ||
        (upcomingAppointmentsModel!.currentPage != null &&
            upcomingAppointmentsModel!.next != null) ||
        isRefresh == true) {
      String endpoint = Endpoints.psychologyAppointments;
      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
      if (upcomingAppointmentsModel?.currentPage == null || isRefresh == true) {
        // docForumsList = [];
        await Future.delayed(const Duration(milliseconds: 50));
        appoinmentsLoader = true;
        upcomingAppointmentsModel = null;
        notifyListeners();

        upcomingAppointmentsModel = UpcomingAppoinmentsModel(
          upcomingAppointments: [],
        );
      }

      Map<String, dynamic> data = {
        "page": upcomingAppointmentsModel?.next ?? 1,
        "type": StringConstants
            .upcomingBookings, // "Upcoming" || "Previous" || "Cancelled"
      };

      dynamic responseData = await getIt<DioClient>().post(
        endpoint,
        data,
        tokn,
      );

      if (responseData != null) {
        var result = UpcomingAppoinmentsModel.fromJson(responseData);
        upcomingAppointmentsModel!.next = result.next;
        upcomingAppointmentsModel!.currentPage = result.currentPage;
        upcomingAppointmentsModel!.upcomingAppointments!.addAll(
          result.upcomingAppointments ?? [],
        );
        notifyListeners();
      } else {
        // return SymptomsAndIssuesModel(status: false);
      }
      appoinmentsLoader = false;
      notifyListeners();
    }
  }

  onlineBookingRedirectionFn({
    required int specialityId,
    required String specialityTitle,
    required BuildContext context,
    int? typeOfPsychology,
    int? subspecialityId,
  }) async {
    // await  getIt<PsychologyManager>().setPsycologyInstantRequestData(PsychologyInstantDoctorScreenData(
    //         genderPref: StringConstants.dPrefNoPref,language: "English",
    //         psycologyType: typeOfPsychology,subSpecialityId:subspecialityId
    //     ));

    var result = await getInstantDoctorsForPsychology(
      PsychologyInstantDoctorScreenData(
        genderPref: null,
        language: null,
        specialityId: specialityId,
        psycologyType: typeOfPsychology,
        subSpecialityId: subspecialityId,
      ),
    );
    if (result.status == true &&
        result.doctors != null &&
        result.doctors!.isNotEmpty) {
      setPsycologyInstantDoctorsListModel(result);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PsychologyInstantDoctorsScreen(
            specialityId: specialityId,
            itemName: specialityTitle,
            psychologyType: typeOfPsychology,
            subspecialityId: subspecialityId,
          ),
        ),
      );
    } else {
      if (ModalRoute.of(context)?.isCurrent ?? false) {
        Future.delayed(const Duration(milliseconds: 50), () {
          Navigator.pop(context);
        });
      }
      showTopSnackBar(
        snackBarPosition: SnackBarPosition.bottom,
        padding: const EdgeInsets.all(30),
        Overlay.of(context),
        ErrorToast(maxLines: 3, message: result.message ?? ""),
      );
    }
  }

  setLanguageForInstantPsychology(String val) {
    psychologyInstantRequestData.language = val;
    notifyListeners();
  }

  setPsycologyInstantRequestData(PsychologyInstantDoctorScreenData val) async {
    await Future.delayed(const Duration(milliseconds: 50));
    psychologyInstantRequestData = val;
    notifyListeners();
  }

  setPsycologyInstantDoctorsListModel(PsychologyInstantResponseModel val) {
    psychologyInstantDoctorsModel = val;
    notifyListeners();
  }

  setPsycologyInstantDoctorsAgeProofUpdatedModel(bool val) {
    psychologyInstantDoctorsModel.isAgeProofSubmitted = val;
    notifyListeners();
  }

  setGenderPreference(String val) {
    psychologyInstantRequestData.genderPref = val;
    notifyListeners();
  }

  getPsychologyTherapy() async {
    psychologyTherapyListLoader = true;
    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.psychologyTherapyList;
    String token =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().get(endpoint, token);

    if (responseData != null) {
      counsellingListModel = CouncellingListModel.fromJson(responseData);
    }
    psychologyTherapyListLoader = false;
    notifyListeners();
  }

  getPsychologyData() async {
    dashLoader = true;
    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.psychologyData;
    String token =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().get(endpoint, token);

    if (responseData != null) {
      psychologyData = PsychologyData.fromJson(responseData);
    }
    dashLoader = false;
    notifyListeners();
  }

  Future<DailyWellnessDataModel> updateSleepQualityOrEmotions({
    required int? sleepQualityValue,
    required int? emotionValue,
    required int? previousSleepQualityValue,
    required int? previousEmotionValue,
  }) async {
    // listLoader = true;
    if (emotionValue != null) {
      dailyWellnessDataModel?.selectedEmotionCode = emotionValue;
    } else {
      dailyWellnessDataModel?.selectedSleepQualityId = sleepQualityValue;
    }
    // await Future.delayed(Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.dailyWellnessUpdate;
    String token =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "sleep_quality_id": sleepQualityValue,
      "emotion_code": emotionValue,
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, token);

    if (responseData != null) {
      var res = DailyWellnessDataModel.fromJson(responseData);

      if (emotionValue != null) {
        dailyWellnessDataModel?.dailyEmotion = res.dailyEmotion;
      } else {
        dailyWellnessDataModel?.dailySleepQuality = res.dailySleepQuality;
      }
      notifyListeners();

      return res;
    } else {
      return DailyWellnessDataModel(
        status: false,
        message: "Something went wrong",
      );
    }

    // listLoader = false;
  }

  getMeditationVideoFiles() async {
    listLoader = true;

    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.meditationVideoFiles;
    String token =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {"page": 1};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, token);

    if (responseData != null) {
      var res = MeditationVideosModel.fromJson(responseData);

      meditationVideosModel = res;
    }
    listLoader = false;
    notifyListeners();
  }

  getMeditationAudioFiles() async {
    listLoader = true;

    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.meditationAudioFiles;
    String token =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {"page": 1};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, token);

    if (responseData != null) {
      var res = MeditationAudiosModel.fromJson(responseData);

      meditationAudiosModel = res;
    }
    listLoader = false;
    notifyListeners();
  }

  fetchDailyWellnessByDate({DateTime? date}) async {
    // listLoader = true;

    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.dailyWellnessDetails;
    String token =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "date": getIt<StateManager>().convertDateTimeToDDMMYYY(
        date ?? DateTime.now(),
      ),
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, token);

    if (responseData != null) {
      var res = DailyWellnessDataModel.fromJson(responseData);

      dailyWellnessDataModel = res;
    }

    listLoader = false;
    notifyListeners();
  }

  getTharapiesOrCoucellingList({
    required int typeId, //councelling list  or therapy list
  }) async {
    listLoader = true;

    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.therapyCounsellingDetails;
    String token =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {"type": typeId};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, token);
    log(responseData.toString());
    if (responseData != null) {
      var res = TharapyCouncellingListModel.fromJson(responseData);

      therapyCouncellingListModel = res;
    }

    listLoader = false;
    notifyListeners();
  }

  getDailyWellnessDetails({DateTime? date}) async {
    listLoader = true;

    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.psychologyData;
    String token =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "date": getIt<StateManager>().convertDateTimeToDDMMYYY(
        date ?? DateTime.now(),
      ),
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, token);

    if (responseData != null) {
      dailyWellnessDataModel = DailyWellnessDataModel.fromJson(responseData);
    }
    listLoader = false;
    notifyListeners();
  }

  Future<PsychologyInstantResponseModel> getInstantDoctorsForPsychology(
    PsychologyInstantDoctorScreenData pData,
  ) async {
    bookingScreenLoader = true;
    await Future.delayed(const Duration(milliseconds: 500));
    notifyListeners();
    String endpoint = Endpoints.psychologyOnlineAvailableDoctors;

    Map<String, dynamic> data = {
      "speciality": pData.specialityId == -1 ? null : pData.specialityId,
      "app_user_id": pData.userId,
      "gender": pData.genderPref,
      // "language":genderPref,
      "slot_preference": null,
      "psychology_type": pData.psycologyType,
      "subspeciality_id": pData.subSpecialityId,
    };

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log("response of getInstantDoctorsForPsychology $responseData");
    if (responseData != null) {
      bookingScreenLoader = false;
      notifyListeners();
      var result = PsychologyInstantResponseModel.fromJson(responseData);

      return result;
    } else {
      bookingScreenLoader = false;
      notifyListeners();
      return PsychologyInstantResponseModel(
        status: false,
        message: "Something went wrong",
      );
    }
  }

  String changeHourValueToSigleLine(int from, int to) {
    return '$from-$to hrs';
  }
}
