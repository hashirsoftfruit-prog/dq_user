import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/managers/state_manager.dart';
import '../../../controller/services/api_endpoints.dart';
import '../../../controller/services/dio_service.dart';
import '../../../model/core/daily_wellness_data_model.dart';
import '../../../model/core/forum_list_model.dart';
import '../../../model/core/psychology_data.dart';
import '../../../model/core/specialities_response_model.dart';
import '../../../model/core/symptoms_and_issues_list_model.dart';
import '../../../model/core/top_doctors_response_model.dart';
import '../../../model/core/upcome_appoiments_response_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';

class ProHomeVm extends ChangeNotifier {
  SpecialitiesModel? specialities;
  SymptomsAndIssuesModel? symptomsAndIssues;
  TopDoctorsResponseModel? topDoctorsResponseModel;
  PsychologyData? psychologyData;
  DailyWellnessDataModel? dailyWellnessDataModel;
  UpcomingAppoinmentsModel? upcomingAppointmentsModel;
  PublicForumListModel? publicForumVeterinaryListModel;

  bool dashLoader = false;
  bool listLoader = false;
  bool appoinmentsLoader = false;
  bool forumLoader = false;

  proBeginFns() {
    getConsultationFns();
    getCounsellingFns();
    getVeterinaryFns();
  }

  getConsultationFns() async {
    await getSpecialities();
    await getSymptomsAndIssuesList();
    await getTopDoctors();
  }

  getCounsellingFns() async {
    await getPsychologyData();
    await fetchDailyWellnessByDate();
    await getPsychologyBookings();
  }

  getVeterinaryFns() async {
    await getVetinaryForumList(isRefresh: true);
  }

  getSpecialities() async {
    String endpoint = Endpoints.specialites;
    var data = {};
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      var result = SpecialitiesModel.fromJson(responseData);
      specialities = result;
    }
    notifyListeners();
  }

  getTopDoctors() async {
    String endpoint = Endpoints.topDoctors;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);

    if (responseData != null) {
      var result = TopDoctorsResponseModel.fromJson(responseData);
      topDoctorsResponseModel = result;
    }
    notifyListeners();
  }

  getSymptomsAndIssuesList() async {
    String endpoint = Endpoints.dashCatList;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);

    if (responseData != null) {
      symptomsAndIssues = SymptomsAndIssuesModel.fromJson(responseData);
      notifyListeners();
    } else {
      // return SymptomsAndIssuesModel(status: false);
    }
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

  fetchDailyWellnessByDate({DateTime? date}) async {
    listLoader = true;
    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.dailyWellnessDetails;
    String token =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "date": getIt<StateManager>()
          .convertDateTimeToDDMMYYY(date ?? DateTime.now()),
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, token);

    if (responseData != null) {
      var res = DailyWellnessDataModel.fromJson(responseData);
      dailyWellnessDataModel = res;
    }
    listLoader = false;
    notifyListeners();
  }

  getPsychologyBookings({
    bool? isRefresh,
  }) async {
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

        upcomingAppointmentsModel =
            UpcomingAppoinmentsModel(upcomingAppointments: []);
      }

      Map<String, dynamic> data = {
        "page": upcomingAppointmentsModel?.next ?? 1,
        "type": StringConstants
            .upcomingBookings // "Upcoming" || "Previous" || "Cancelled"
      };

      dynamic responseData =
          await getIt<DioClient>().post(endpoint, data, tokn);

      if (responseData != null) {
        var result = UpcomingAppoinmentsModel.fromJson(responseData);
        upcomingAppointmentsModel!.next = result.next;
        upcomingAppointmentsModel!.currentPage = result.currentPage;
        upcomingAppointmentsModel!.upcomingAppointments!
            .addAll(result.upcomingAppointments ?? []);
        notifyListeners();
      } else {
        // return SymptomsAndIssuesModel(status: false);
      }
      appoinmentsLoader = false;
      notifyListeners();
    }
  }

  Future<DailyWellnessDataModel> updateSleepQualityOrEmotions({
    required int? sleepQualityValue,
    required int? emotionValue,
    required int? previousSleepQualityValue,
    required int? previousEmotionValue,
  }) async {
    if (emotionValue != null) {
      dailyWellnessDataModel?.selectedEmotionCode = emotionValue;
    } else {
      dailyWellnessDataModel?.selectedSleepQualityId = sleepQualityValue;
    }
    notifyListeners();
    String endpoint = Endpoints.dailyWellnessUpdate;
    String token =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "sleep_quality_id": sleepQualityValue,
      "emotion_code": emotionValue
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
          status: false, message: "Something went wrong");
    }
  }

  getVetinaryForumList({
    bool? isRefresh,
  }) async {
    if (publicForumVeterinaryListModel == null ||
        (publicForumVeterinaryListModel!.currentPage != null &&
            publicForumVeterinaryListModel!.next != null) ||
        isRefresh == true) {
      String endpoint = Endpoints.forumList;
      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
      if (publicForumVeterinaryListModel?.currentPage == null ||
          isRefresh == true) {
        // docForumsList = [];
        publicForumVeterinaryListModel = PublicForumListModel(publicForums: []);
        await Future.delayed(const Duration(milliseconds: 50));
        forumLoader = true;
        notifyListeners();
      }

      Map<String, dynamic> data = {
        "page": publicForumVeterinaryListModel?.next ?? 1,
        "forum_type": 1
      };

      dynamic responseData =
          await getIt<DioClient>().post(endpoint, data, tokn);

      if (responseData != null) {
        var result = PublicForumListModel.fromJson(responseData);
        publicForumVeterinaryListModel!.next = result.next;
        publicForumVeterinaryListModel!.currentPage = result.currentPage;
        publicForumVeterinaryListModel!.publicForums!
            .addAll(result.publicForums ?? []);
        notifyListeners();
      } else {
        // return SymptomsAndIssuesModel(status: false);
      }
      forumLoader = false;
      notifyListeners();
    }
  }

  removeVetinaryForums() {
    publicForumVeterinaryListModel = null;
  }
}
