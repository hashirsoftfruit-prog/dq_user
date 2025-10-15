import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:dqapp/controller/managers/auth_manager.dart';
import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/controller/managers/state_manager.dart';
import 'package:dqapp/controller/services/payment_service.dart';
import 'package:dqapp/model/core/basic_response_model.dart';
import 'package:dqapp/model/core/news_and_tips/news_and_tips.dart';
import 'package:dqapp/model/core/purchase_package_response_model.dart';
import 'package:dqapp/model/core/reminder_priscrition_list_model.dart';
import 'package:dqapp/model/core/specialities_response_model.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/core/banners_response_model.dart';
import '../../model/core/consults_list_model.dart';
import '../../model/core/doctor_list_response_model.dart';
import '../../model/core/field_of_medicine_model.dart';
import '../../model/core/forum_detail_model.dart';
import '../../model/core/forum_general_detail_model.dart';
import '../../model/core/forum_list_model.dart';
import '../../model/core/free_followups_model.dart';
import '../../model/core/medical_records_list_model.dart';
import '../../model/core/near_clinics_response_model.dart';
import '../../model/core/notification_model.dart';
import '../../model/core/offers_response_model.dart';
import '../../model/core/other_patients_response_model.dart';
import '../../model/core/package_list_response_model.dart';
import '../../model/core/purchased_pkgs_list_model.dart';
import '../../model/core/reminder_binding_data_model.dart';
import '../../model/core/reminder_list_model.dart';
import '../../model/core/reminder_model.dart';
import '../../model/core/search_medicine_model.dart';
import '../../model/core/search_places_response_model.dart';
import '../../model/core/symptoms_and_issues_list_model.dart';
import '../../model/core/upcome_appoiments_response_model.dart';
import '../../model/helper/service_locator.dart';
import '../../view/screens/drawer_menu_screens/reminder_screens/days_interval_screen.dart';
import '../services/api_endpoints.dart';
import '../services/dio_service.dart';
import 'location_manager.dart';

class HomeManager extends ChangeNotifier {
  double heightF = 4;
  SpecialitiesModel? spcialities;
  SymptomsAndIssuesModel? symptomsAndIssues;
  List<Clinics>? nearestClinics;
  UpcomingAppoinmentsModel? cancelledAppointmentsModel;
  UpcomingAppoinmentsModel? upcomingAppointmentsModel;
  List<Consultaions> consultaions = [];
  bool locLoader = false;
  bool? appoinmentsLoader;
  List<FieldOfMedicines>? fieldOfMedicines;
  List<Bookings> bookingsFollowUps = [];
  String? selectedAppointTabTitle;
  List<String> selectedMedicRecordsPaths = [];
  List<UserItem> medicalRecordUsers = [];
  List<MedicalRecordDetails> medicalRecords = [];
  bool medicalRecsLoader = false;
  bool listLoader = false;
  bool forumLoader = false;
  bool searchLoader = false;
  bool forumDetailsLoader = false;
  List<BannerList> subBanners = [];
  List<BannerList> mainBanners = [];
  List<DocDetailsModel> myDoctorsModel = [];

  PublicForumListModel? publicForumListModel;
  PublicForumListModel? publicForumVeterinaryListModel;
  PublicForumListModel? publicForumSearchResultsModel;
  ForumDetailsModel? forumDetailsModel;
  ForumGeneralDatamodel? forumGeneralDatamodel;
  List<UserDetails> myPatientList = [];
  bool logoutLoader = false;
  bool notificationLoader = false;
  List<Packages>? allPackages;
  List<PurchasedPackage>? purchasedPackages;
  NotificationsModel? notificationsModel;
  Treatments? selectedForumTreatmentItem;
  OffersModel? offersModel;
  List<String> forumImages = [];
  ReminderPriscriptionList? reminderPrescriptionList;
  bool enableMark = false;
  bool btnLoader = false;
  List<ReminderItem>? activeReminders;
  bool reminderLoader = false;
  List<DrugItem>? searchMedResults;
  AddReminderModel addReminderModel = AddReminderModel(
    timeAndDoses: [],
    isDailyMedication: true,
  );
  List<int> markedReminderList = [];
  NewsAndTips? newsAndTips;

  bool isPaymentOnProcess = false;
  String paymentMessage = "";
  String? packageOrderId;
  int? tempPackageId;

  setPaymentMessage(val) {
    paymentMessage = val;
    notifyListeners();
  }

  resetSearchResults() {
    publicForumSearchResultsModel = null;
    notifyListeners();
  }

  searchForum({
    required String keyword,
    required int type,
    bool? isRefresh,
  }) async {
    if (publicForumSearchResultsModel == null ||
        (publicForumSearchResultsModel!.currentPage != null &&
            publicForumSearchResultsModel!.next != null) ||
        isRefresh == true) {
      String endpoint = Endpoints.publicForumSearch;
      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
      if (publicForumSearchResultsModel?.currentPage == null ||
          isRefresh == true) {
        // docForumsList = [];
        publicForumSearchResultsModel = PublicForumListModel(publicForums: []);
        await Future.delayed(const Duration(milliseconds: 50));
        forumLoader = true;
        notifyListeners();
      }

      Map<String, dynamic> data = {
        "search": keyword,
        "page": publicForumSearchResultsModel?.next ?? 1,
        "forum_type": type,
      };

      dynamic responseData = await getIt<DioClient>().post(
        endpoint,
        data,
        tokn,
      );

      if (responseData != null) {
        var result = PublicForumListModel.fromJson(responseData);
        publicForumSearchResultsModel!.next = result.next;
        publicForumSearchResultsModel!.currentPage = result.currentPage;
        publicForumSearchResultsModel!.publicForums!.addAll(
          result.publicForums ?? [],
        );
        notifyListeners();
      } else {}
      forumLoader = false;
      notifyListeners();
    }
  }

  changeReminderType(String? val) {
    addReminderModel.reminderType = val;
    notifyListeners();
  }

  changeHeight(double f) {
    if (heightF != f) {
      heightF = f;
      notifyListeners();
    }
  }

  setEditableVariable({required bool val, required int? responseId}) {
    if (forumDetailsModel?.forumDetails != null) {
      forumDetailsModel!.forumDetails!.editable = val;
      forumDetailsModel!.forumDetails!.alreadyRespondedId = responseId;
      notifyListeners();
    }
  }

  disposeReminderScreen() {
    activeReminders = null;
    markedReminderList = [];
    reminderLoader = false;
    enableMark = false;
  }

  markReminder(int val) {
    if (markedReminderList.contains(val)) {
      markedReminderList.remove(val);
    } else {
      markedReminderList.add(val);
    }
    notifyListeners();
  }

  reminderListMarkValueChange({bool? val}) {
    enableMark = val ?? !enableMark;

    if (enableMark == false) {
      markedReminderList = [];
    }
    notifyListeners();
  }

  removeForums() {
    publicForumListModel = null;
  }

  removeVetinaryForums() {
    publicForumVeterinaryListModel = null;
  }

  disposeForumSearch() {
    publicForumSearchResultsModel = null;
  }

  setDaysIntervalData(DaysIntervalModel d) {
    addReminderModel.isDailyMedication = d.isDaily == true ? true : false;
    addReminderModel.interval = d.noOfDays;
    addReminderModel.intervalStartDate = d.date;

    notifyListeners();
  }

  disposeSetReminder() {
    addReminderModel = AddReminderModel(timeAndDoses: []);
  }

  setDurationCount(int val) {
    addReminderModel.dayDuration = val;
    notifyListeners();
  }

  changeStartTimeOrEndTime({
    required bool isStartTime,
    required DateTime date,
  }) {
    if (isStartTime) {
      addReminderModel.startTime = date.toString();
    } else {
      addReminderModel.endTime = date.toString();
    }

    List<String> times = getIt<StateManager>().getEqualIntervals(
      DateTime.parse(addReminderModel.startTime ?? DateTime.now().toString()),
      DateTime.parse(addReminderModel.endTime ?? DateTime.now().toString()),
      addReminderModel.timeAndDoses!.length,
    );

    for (int i = 0; i < addReminderModel.timeAndDoses!.length; i++) {
      addReminderModel.timeAndDoses![i].time = times[i];
    }
    notifyListeners();
  }

  setReminderModelFromReminders(ReminderItem reminder) {
    List<double> dosages = reminder.dosageTime!
        .map((e) => e.dosage)
        .where((dose) => dose != 0.0 && dose != 0)
        .cast<double>()
        .toList();
    List<String> times = reminder.dosageTime!
        .map((e) => getIt<StateManager>().getFormattedTime(e.time))
        .where((time) => time != null && time != "")
        .cast<String>()
        .toList();
    addReminderModel.title = reminder.title;
    addReminderModel.prescriptionDrugId = reminder.id;
    addReminderModel.isDailyMedication =
        reminder.medicineIntervalType == "Everyday";
    addReminderModel.dayDuration = reminder.duration;
    addReminderModel.interval = reminder.interval;
    addReminderModel.reminderType = reminder.reminderType;
    addReminderModel.timeAndDoses = [];
    addReminderModel.timeAndDoses!.addAll(
      dosages.map((e) => TimeAndDoses(dose: e, scrollValue: 0)).toList(),
    );
    // List<double> dd = getIt<StateManager>().generateEqualIntervals(addReminderModel.timeAndDoses!.length);

    for (int i = 0; i < addReminderModel.timeAndDoses!.length; i++) {
      var sclValue = getIt<StateManager>().convertTimeToSliderValue(times[i]);
      addReminderModel.timeAndDoses![i].scrollValue = sclValue;
      addReminderModel.timeAndDoses![i].time = times[i];
    }

    // for (int i = 0; i < addReminderModel.timeAndDoses!.length; i++) {
    //   addReminderModel.timeAndDoses![i].scrollValue = dd[i];
    //   addReminderModel.timeAndDoses![i].time = times[i];
    // }
    notifyListeners();
  }

  setReminderModelFromPriscription(DrugSerializer drug) {
    List<double> dosages = drug.dosageList!
        .map((e) => e.dosage)
        .where((dose) => dose != 0.0 && dose != 0)
        .cast<double>()
        .toList();
    addReminderModel.title = drug.drugName;
    addReminderModel.prescriptionDrugId = drug.id;
    addReminderModel.isDailyMedication = drug.dailyMedication;
    addReminderModel.dayDuration = drug.duration;
    addReminderModel.interval = drug.interval;
    addReminderModel.reminderType = StringConstants.medicine;
    addReminderModel.timeAndDoses = [];
    addReminderModel.timeAndDoses!.addAll(
      dosages.map((e) => TimeAndDoses(dose: e, scrollValue: 0)).toList(),
    );
    List<double> dd = getIt<StateManager>().generateEqualIntervals(
      addReminderModel.timeAndDoses!.length,
    );

    for (int i = 0; i < addReminderModel.timeAndDoses!.length; i++) {
      addReminderModel.timeAndDoses![i].scrollValue = dd[i];
      addReminderModel.timeAndDoses![i].time = getIt<StateManager>()
          .convertSliderValueToTime(dd[i]);
    }
    notifyListeners();
  }

  setTitle(String val) {
    addReminderModel.title = val;
  }

  addOrSubtractTime({required bool isAdd}) {
    if (isAdd == true || addReminderModel.timeAndDoses!.length > 1) {
      if (isAdd == true) {
        addReminderModel.timeAndDoses!.add(
          TimeAndDoses(time: "11:59 PM", dose: 1, scrollValue: 1.0),
        );
      } else {
        addReminderModel.timeAndDoses!.removeAt(0);
      }

      if ((addReminderModel.timeAndDoses?.length ?? 0) > 4) {
        List<double> dd = getIt<StateManager>().generateEqualIntervals(
          addReminderModel.timeAndDoses!.length,
        );

        for (int i = 0; i < addReminderModel.timeAndDoses!.length; i++) {
          addReminderModel.timeAndDoses![i].scrollValue = dd[i];
          addReminderModel.timeAndDoses![i].time = getIt<StateManager>()
              .convertSliderValueToTime(dd[i]);
        }
      }

      notifyListeners();
    }
  }

  addDosage({required bool isAdd, required int index}) {
    if (addReminderModel.timeAndDoses![index].dose! > 0.25 || isAdd == true) {
      // if(addReminderModel.timeAndDoses![index].dose!>0.25){
      if (isAdd == true) {
        addReminderModel.timeAndDoses![index].dose =
            addReminderModel.timeAndDoses![index].dose! + 0.25;
      } else {
        addReminderModel.timeAndDoses![index].dose =
            addReminderModel.timeAndDoses![index].dose! - 0.25;
      }
    }

    notifyListeners();
  }

  changeTime({required int index, required String time}) {
    addReminderModel.timeAndDoses![index].time = time;
    addReminderModel.timeAndDoses![index].scrollValue = getIt<StateManager>()
        .convertTimeToSliderValue(time);
    sortTime(addReminderModel.timeAndDoses!);
    // notifyListeners();
  }

  setAddReminderModel({String? val, List<double>? scrollValues}) {
    if (val == null) {
      addReminderModel.timeAndDoses!.add(
        TimeAndDoses(time: "12:00 AM", dose: 1, scrollValue: 0.0),
      );
    }

    if (scrollValues != null) {
      for (int i = 0; i < addReminderModel.timeAndDoses!.length; i++) {
        addReminderModel.timeAndDoses![i].time = getIt<StateManager>()
            .convertSliderValueToTime(scrollValues[i]);
        addReminderModel.timeAndDoses![i].scrollValue = scrollValues[i];
      }
    }
    sortTime(addReminderModel.timeAndDoses!);

    // notifyListeners();
  }

  sortTime(List<TimeAndDoses> list) {
    list.sort((a, b) => a.scrollValue.compareTo(b.scrollValue));
    addReminderModel.timeAndDoses = list;
    notifyListeners();
  }

  disposeForumDetails() {
    forumDetailsModel = null;
  }

  selectForumTreatmentItem(Treatments val) {
    selectedForumTreatmentItem = val;
    notifyListeners();
  }

  disposeForumAsk() {
    selectedForumTreatmentItem = null;
    forumImages = [];
  }

  disposeSearchMedicine() {
    // searchResultsModel  = null;
    // searchSuggestions=[];
  }

  searchMedicine({required String searchKey}) async {
    String endpoint = Endpoints.drugSearch;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    final data = {"keyword": searchKey};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      // searchResultsModel =
      var res = MedicineListModel.fromJson(responseData);
      if (res.status == true) {
        searchMedResults = res.drugSerializer ?? [];
      } else {
        searchMedResults = [];
      }
      notifyListeners();
      // return resp;
    } else {
      // return BasicResponseModel(status:true,message: "Failed");
      // return SymptomsAndIssuesModel(status: false);
    }
  }

  removeImage(String path) {
    forumImages.remove(path);
    notifyListeners();
  }

  addImages(String path) {
    forumImages.add(path);
    notifyListeners();
  }

  notificationStatusChange() async {
    String endpoint = Endpoints.updateNotificationStatus;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    var res = await getIt<DioClient>().get(endpoint, tokn);
    if (res != null) {
      spcialities?.unreadNotificationCount = 0;
      notifyListeners();
    }
  }

  Future<BasicResponseModel> updateReminder(int reminderID) async {
    await Future.delayed(const Duration(milliseconds: 50));
    String endpoint = Endpoints.updateReminder;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    AddReminderModel dd = addReminderModel;

    Map<String, dynamic> data = {
      "reminder_id": dd.prescriptionDrugId,
      "reminder_type": dd.reminderType ?? StringConstants.medicine,
      "medicine_interval_type": dd.isDailyMedication == true
          ? "Everyday"
          : "Intervals",
      "duration": dd.dayDuration,
      "dosage_time_list": dd.timeAndDoses!
          .map(
            (e) => {
              "time": getIt<StateManager>().convertTo24HFormat(e.time!),
              "dosage": e.dose,
            },
          )
          .toList(),
      "interval": dd.interval,
      "image": null,
      "reminder_start_date": dd.intervalStartDate == null
          ? getIt<StateManager>().convertDateTimeToDDMMYYY(DateTime.now())
          : getIt<StateManager>().convertDateTimeToDDMMYYY(
              DateTime.parse(dd.intervalStartDate!),
            ),
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      log(responseData.toString());
      return BasicResponseModel.fromJson(responseData);
    } else {
      return BasicResponseModel(status: false, message: "Server Error");
    }
  }

  Future<BasicResponseModel> savePrescriptionReminder() async {
    // await Future.delayed(Duration(milliseconds: 50));

    reminderLoader = true;
    notifyListeners();
    String endpoint = Endpoints.savePrescriptionReminder;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    AddReminderModel dd = addReminderModel;

    Map<String, dynamic> data = {
      "prescription_drug_id": dd.prescriptionDrugId,
      "reminder_type": dd.reminderType ?? StringConstants.medicine,
      "medicine_interval_type": dd.isDailyMedication == false
          ? "Intervals"
          : "Everyday",
      "drug_name": dd.title,
      "duration": dd.dayDuration,
      "dosage_time_list": dd.timeAndDoses!
          .map(
            (e) => {
              "time": getIt<StateManager>().convertTo24HFormat(e.time!),
              "dosage": e.dose,
            },
          )
          .toList(),
      "interval": dd.interval,
      "image": null,
      "reminder_start_date": dd.intervalStartDate == null
          ? getIt<StateManager>().convertDateTimeToDDMMYYY(DateTime.now())
          : getIt<StateManager>().convertDateTimeToDDMMYYY(
              DateTime.parse(dd.intervalStartDate!),
            ),
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    reminderLoader = false;
    notifyListeners();
    if (responseData != null) {
      return BasicResponseModel.fromJson(responseData);
    } else {
      return BasicResponseModel(status: false, message: "Server Error");
    }
  }

  Future<BasicResponseModel> deleteReminder(List<int> reminderIds) async {
    await Future.delayed(const Duration(milliseconds: 50));
    String endpoint = Endpoints.deleteReminder;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {"reminder_id_list": reminderIds};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      return BasicResponseModel.fromJson(responseData);
    } else {
      return BasicResponseModel(status: false, message: "Server Error");
    }
  }

  Future<BasicResponseModel> changeReminderStatus(int reminderId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    btnLoader = true;
    notifyListeners();
    String endpoint = Endpoints.changeReminderStatus;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "reminder_id_list": [reminderId],
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    btnLoader = false;
    notifyListeners();
    if (responseData != null) {
      return BasicResponseModel.fromJson(responseData);
    } else {
      return BasicResponseModel(status: false, message: "Server Error");
    }
  }

  getNotifications({bool? isRefresh}) async {
    if (notificationsModel == null ||
        (notificationsModel!.currentPage != null &&
            notificationsModel!.next != null) ||
        isRefresh == true) {
      String endpoint = Endpoints.notificationsLst;

      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

      if (notificationsModel?.currentPage == null || isRefresh == true) {
        // docForumsList = [];
        await Future.delayed(const Duration(milliseconds: 50));
        notificationLoader = true;
        notifyListeners();
        notificationsModel = NotificationsModel(notifications: []);
      }

      Map<String, dynamic> data = {"page": notificationsModel?.next ?? 1};
      dynamic responseData = await getIt<DioClient>().post(
        endpoint,
        data,
        tokn,
      );
      if (responseData != null) {
        var result = NotificationsModel.fromJson(responseData);
        notificationsModel!.notifications!.addAll(result.notifications ?? []);
        notificationsModel!.next = result.next;
        notificationsModel!.currentPage = result.currentPage;
      }

      notificationLoader = false;

      notifyListeners();
    }
  }

  disposeFileUpload() {
    selectedMedicRecordsPaths = [];
  }

  disposeMedicalRecords() {
    medicalRecords = [];
  }

  getForumList({bool? isRefresh}) async {
    if (publicForumListModel == null ||
        (publicForumListModel!.currentPage != null &&
            publicForumListModel!.next != null) ||
        isRefresh == true) {
      String endpoint = Endpoints.forumList;
      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
      if (publicForumListModel?.currentPage == null || isRefresh == true) {
        // docForumsList = [];
        publicForumListModel = PublicForumListModel(publicForums: []);
        await Future.delayed(const Duration(milliseconds: 50));
        forumLoader = true;
        notifyListeners();
      }

      Map<String, dynamic> data = {
        "page": publicForumListModel?.next ?? 1,
        "forum_type": 2,
      };

      dynamic responseData = await getIt<DioClient>().post(
        endpoint,
        data,
        tokn,
      );

      if (responseData != null) {
        var result = PublicForumListModel.fromJson(responseData);
        publicForumListModel!.next = result.next;
        publicForumListModel!.currentPage = result.currentPage;
        publicForumListModel!.publicForums!.addAll(result.publicForums ?? []);
        notifyListeners();
      } else {
        // return SymptomsAndIssuesModel(status: false);
      }
      forumLoader = false;
      notifyListeners();
    }
  }

  //   getForumList({bool? isRefresh})async{
  //
  //     forumLoader = true;
  //
  //     await Future.delayed(Duration(milliseconds: 50));
  //     notifyListeners();
  //     String endpoint = Endpoints.forumList;
  //     String tokn = getIt<SharedPreferences>().getString(StringConstants.token)??"";
  // Map<String,dynamic> data ={
  //   "page":pageIndex??1,
  //   "forum_type" : 2
  //
  // };
  //     dynamic responseData = await getIt<DioClient>().post(endpoint,data, tokn);
  //
  //     if (responseData != null) {
  //       publicForumListModel = PublicForumListModel.fromJson(responseData);
  //
  //
  //     }
  //     forumLoader = false;
  //     notifyListeners();
  //   }

  getVetinaryForumList({bool? isRefresh}) async {
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
        "forum_type": 1,
      };

      dynamic responseData = await getIt<DioClient>().post(
        endpoint,
        data,
        tokn,
      );

      if (responseData != null) {
        var result = PublicForumListModel.fromJson(responseData);
        publicForumVeterinaryListModel!.next = result.next;
        publicForumVeterinaryListModel!.currentPage = result.currentPage;
        publicForumVeterinaryListModel!.publicForums!.addAll(
          result.publicForums ?? [],
        );
        notifyListeners();
      } else {
        // return SymptomsAndIssuesModel(status: false);
      }
      forumLoader = false;
      notifyListeners();
    }
  }

  getUpcomingAppointments({bool? isRefresh}) async {
    if (upcomingAppointmentsModel == null ||
        (upcomingAppointmentsModel!.currentPage != null &&
            upcomingAppointmentsModel!.next != null) ||
        isRefresh == true) {
      String endpoint = Endpoints.appointments;
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

      log("response of upcomingappointments $responseData");

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

  getCancelledAppointments({bool? isRefresh}) async {
    if (cancelledAppointmentsModel == null ||
        (cancelledAppointmentsModel!.currentPage != null &&
            cancelledAppointmentsModel!.next != null) ||
        isRefresh == true) {
      String endpoint = Endpoints.appointments;
      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
      if (cancelledAppointmentsModel?.currentPage == null ||
          isRefresh == true) {
        // docForumsList = [];
        cancelledAppointmentsModel = UpcomingAppoinmentsModel(
          upcomingAppointments: [],
        );
        await Future.delayed(const Duration(milliseconds: 50));
        appoinmentsLoader = true;
        notifyListeners();
      }

      Map<String, dynamic> data = {
        "page": cancelledAppointmentsModel?.next ?? 1,
        "type": StringConstants
            .cancelledBookings, // "Upcoming" || "Previous" || "Cancelled"
      };

      dynamic responseData = await getIt<DioClient>().post(
        endpoint,
        data,
        tokn,
      );

      if (responseData != null) {
        var result = UpcomingAppoinmentsModel.fromJson(responseData);
        cancelledAppointmentsModel!.next = result.next;
        cancelledAppointmentsModel!.currentPage = result.currentPage;
        cancelledAppointmentsModel!.upcomingAppointments!.addAll(
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

  //   getVetinaryForumList(int? pageIndex)async{
  //
  //     forumLoader = true;
  //
  //     await Future.delayed(Duration(milliseconds: 50));
  //     notifyListeners();
  //     String endpoint = Endpoints.forumList;
  //     String tokn = getIt<SharedPreferences>().getString(StringConstants.token)??"";
  // Map<String,dynamic> data ={
  //   "page":pageIndex??1,
  //   "forum_type" : 1
  //
  // };
  //     dynamic responseData = await getIt<DioClient>().post(endpoint,data, tokn);
  //
  //     if (responseData != null) {
  //       publicForumVetinaryListModel = PublicForumListModel.fromJson(responseData);
  //
  //
  //     }
  //     forumLoader = false;
  //     notifyListeners();
  //   }

  getForumDetails(int? forumId) async {
    forumDetailsLoader = true;

    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.forumDetails;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {"public_forum_id": forumId};
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      forumDetailsModel = ForumDetailsModel.fromJson(responseData);
    }
    forumDetailsLoader = false;
    notifyListeners();
  }

  getForumGeneralTerms({bool? isVetenary}) async {
    forumLoader = true;

    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.forumGeneralDetails;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);

    if (responseData != null) {
      forumGeneralDatamodel = ForumGeneralDatamodel.fromJson(responseData);
      if (isVetenary == true) {
        getIt<HomeManager>().selectForumTreatmentItem(
          Treatments(
            id: forumGeneralDatamodel!.veterinaryTreatmentId,
            title: "Veterinary",
          ),
        );
      }
    }
    forumLoader = false;
    notifyListeners();
  }

  Future<BasicResponseModel> publicForumResponse(
    int forumId,
    String response,
  ) async {
    forumLoader = true;

    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.publicForumResponse;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "public_forum_id": forumId,
      "response": response,
    };
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    forumLoader = false;
    notifyListeners();
    if (responseData != null) {
      var resp = BasicResponseModel.fromJson(responseData);
      return resp;
    } else {
      return BasicResponseModel(status: true, message: "server Error");
    }
    // forumLoader = false;
    // notifyListeners();
  }

  Future<BasicResponseModel> editForumResponse(
    int? forumResponseId,
    String response,
  ) async {
    forumLoader = true;

    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.updatePublicForumResponse;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "public_forum_response_id": forumResponseId,
      "response": response,
      "file": null,
    };
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    forumLoader = false;
    notifyListeners();
    if (responseData != null) {
      var resp = BasicResponseModel.fromJson(responseData);
      return resp;
    } else {
      return BasicResponseModel(status: true, message: "server Error");
    }
    // forumLoader = false;
    // notifyListeners();
  }

  Future<BasicResponseModel> forumResponseReactionSave({
    required int forumRespId,
    required int reaction,
  }) async {
    forumLoader = true;

    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.forumResponseReactionSave;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "forum_response_id": forumRespId,
      "reaction_type": reaction,
      "flag": null,
    };
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    forumLoader = false;
    notifyListeners();
    if (responseData != null) {
      var resp = BasicResponseModel.fromJson(responseData);
      return resp;
    } else {
      return BasicResponseModel(status: true, message: "server Error");
    }
  }

  submitNewForum({
    required String title,
    required String description,
    required int? treatmentId,
    required List<String> imgs,
  }) async {
    forumLoader = true;

    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    String endpoint = Endpoints.publicForumSave;
    List<MultipartFile> imageFilesData = [];
    for (var i in imgs) {
      imageFilesData.add(
        await MultipartFile.fromFile(i, filename: i.split('/').last),
      );
    }

    final formData = FormData.fromMap({
      "title": title,
      "description": description,
      "treatment_id": treatmentId,
      "files": imageFilesData,
    });

    // Map<String,dynamic> data = {
    //
    // "title":title,
    // "description":description,
    // "treatment_id":treatmentId,
    // "location":"Banglore",
    // "file": null ,
    //
    // };
    dynamic responseData = await getIt<DioClient>().post(
      endpoint,
      formData,
      tokn,
    );

    if (responseData != null) {
      var res = BasicResponseModel.fromJson(responseData);
      return res;
    } else {
      return BasicResponseModel(status: false, message: "No Data ");
    }

    // forumLoader = false;
    // notifyListeners();
  }

  logoutFn({bool? isForceLogout}) async {
    if (isForceLogout == null) {
      logoutLoader = true;
      // await Future.delayed(Duration(milliseconds: 50));
      notifyListeners();
      String endpoint = Endpoints.logoutFn;
      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

      var fcmTokn = await getIt<AuthManager>().getfcmToken();

      Map<String, dynamic> data = {"user_type": 2, "fcm": fcmTokn};

      await getIt<DioClient>().post(endpoint, data, tokn);
    }

    // if (responseData != null) {
    getIt<SharedPreferences>().clear();
    spcialities = null;
    symptomsAndIssues = null;
    nearestClinics = [];
    upcomingAppointmentsModel = null;
    cancelledAppointmentsModel = null;
    consultaions = [];
    fieldOfMedicines = null;
    bookingsFollowUps = [];
    selectedAppointTabTitle = null;
    selectedMedicRecordsPaths = [];
    medicalRecordUsers = [];
    medicalRecords = [];
    medicalRecsLoader = false;
    listLoader = false;
    subBanners = [];
    myDoctorsModel = [];
    myPatientList = [];
    logoutLoader = false;
    notificationLoader = false;

    // }
    logoutLoader = false;
    notifyListeners();
  }

  getMyDoctorsList() async {
    listLoader = true;
    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.myDoctorsList;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);

    if (responseData != null) {
      myDoctorsModel = DoctorListModel.fromJson(responseData).doctors ?? [];
    }

    listLoader = false;
    notifyListeners();
  }

  getMyPatientsList() async {
    listLoader = true;
    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.otherPatientsDetails;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);

    if (responseData != null) {
      myPatientList =
          PatientsDetailsModel.fromJson(responseData).userRelations ?? [];
      // myPatientList = [DocDetailsModel(firstName: "Ramees",lastName: 'dfd',clinicName: "sfsdjfhsdfsf",gender: "male",experience: 5,)];
    }
    listLoader = false;
    notifyListeners();
  }

  addFiles(List<String> val) {
    selectedMedicRecordsPaths.addAll(val);
    notifyListeners();
  }

  setAppointmentsTabTitle(String? title, {bool? isDispose}) {
    selectedAppointTabTitle = title;
    if (isDispose != true) {
      notifyListeners();
    }
  }

  deleteFile(val) {
    for (var i in selectedMedicRecordsPaths) {
      if (val == i) {
        selectedMedicRecordsPaths.remove(val);
        notifyListeners();
      }
    }
  }

  homeBeginFns() async {
    await getIt<LocationManager>().getPopularCities();
    await getSpecialities();
    await getUpcomingAppointments(isRefresh: true);

    await getSymptomsAndIssuesList();
    // await getFeildofMedicines();
    await getBannersList();
    await getFreeFollowUp();
    await getForumList(isRefresh: true);
    await getNewsAndTips();
    getIt<BookingManager>().getDocIds();

    // List<String> latLongList = getIt<SharedPreferences>().getStringList(StringConstants.currentLatAndLong) ?? [];
    // if (latLongList.isNotEmpty) {
    //   await getIt<HomeManager>().getNearClinics(lat: double.parse(latLongList[0]), long: double.parse(latLongList[1]));
    // }
    // await getForumList();
    await getVetinaryForumList();
    // await getSpecialities();
  }

  getFieldOfMedicines() async {
    // await Future.delayed(Duration(seconds: 2));
    String endpoint = Endpoints.fieldsOfMedicine;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);
    if (responseData != null) {
      fieldOfMedicines =
          FieldOfMedicineModel.fromJson(responseData).fieldOfMedicines ?? [];
    }
    notifyListeners();
  }

  getSpecialities() async {
    String endpoint = Endpoints.specialites;
    var data = {
      // "count": 6
    };
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      var result = SpecialitiesModel.fromJson(responseData);

      spcialities = result;
    }
    notifyListeners();
  }

  getFreeFollowUp() async {
    // await Future.delayed(Duration(seconds: 2));
    String endpoint = Endpoints.freefollowup;

    try {
      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
      dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);

      var result = FreeFollowUpsModel.fromJson(responseData);

      bookingsFollowUps = result.bookings ?? [];
      notifyListeners();
    } catch (e) {
      // print(e);
    }
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

  //   getUpcomingAppointments({required int index,}) async {
  //     String endpoint = Endpoints.appoinments;
  //     String tokn = getIt<SharedPreferences>().getString(StringConstants.token)??"";
  // if(index==1){
  //   upcomingAppointments = [];
  // }
  // await Future.delayed(Duration(milliseconds: 50));
  //     appoinmentsLoader = true;
  //     notifyListeners();
  //
  //     Map<String,dynamic> data={
  //       "page" : index,
  //       "type" :selectedAppointTabTitle ?? StringConstants.upcomingBookings   // "Upcoming" || "Previous" || "Cancelled"
  //     };
  //
  //     dynamic responseData = await getIt<DioClient>().post(endpoint,data, tokn);
  //
  //     if (responseData != null) {
  //         var result = UpcomingAppoinmentsModel.fromJson(responseData);
  //         upcomingAppointments.addAll(result.upcomingAppointments ?? []);
  //       notifyListeners();
  //
  //     } else {
  //       // return SymptomsAndIssuesModel(status: false);
  //     }
  //     appoinmentsLoader = false;
  //     notifyListeners();
  //   }

  getConsultaions({required int index}) async {
    String endpoint = Endpoints.consultationList;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    if (index == 1) {
      consultaions = [];
    }
    await Future.delayed(const Duration(milliseconds: 100));

    appoinmentsLoader = true;
    notifyListeners();

    Map<String, dynamic> data = {
      "page": index,
      // "type" :"Previous"
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log("response of getConsultation $responseData");
    if (responseData != null) {
      var result = ConsultsListModel.fromJson(responseData);
      consultaions.addAll(
        result.consultations ??
            [
              // UpcomingAppointments(time: '14:30:46',date: '2024-06-10',doctorFirstName: "dfdf",doctorLastname: "derer",speciality: 'Dermatology',),
              // UpcomingAppointments(time: '14:30:46',date: '2024-06-10',doctorFirstName: "dfdf",doctorLastname: "derer",speciality: 'Dermatology',),
            ],
      );
      notifyListeners();
    } else {
      // return SymptomsAndIssuesModel(status: false);
    }
    appoinmentsLoader = false;
    notifyListeners();
  }

  getOffersList() async {
    String endpoint = Endpoints.offersList;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    // if(index==1){
    //   consultaions = [];
    // }
    appoinmentsLoader = true;
    notifyListeners();

    // Map<String,dynamic> data={
    //   "page" : index,
    //   // "type" :"Previous"
    // };

    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);

    if (responseData != null) {
      var result = OffersModel.fromJson(responseData);
      offersModel = result;
    } else {
      // return SymptomsAndIssuesModel(status: false);
    }
    appoinmentsLoader = false;
    notifyListeners();
  }

  getReminderList() async {
    String endpoint = Endpoints.reminderList;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    // Map<String,dynamic> data={
    //   "prescription_id" : 157
    //   // "type" :"Previous"
    // };

    await Future.delayed(const Duration(milliseconds: 50));
    reminderLoader = true;
    notifyListeners();
    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);

    if (responseData != null) {
      activeReminders =
          RemindersListModel.fromJson(responseData).activeReminders ?? [];
      // offersModel =result;
    } else {
      // return SymptomsAndIssuesModel(status: false);
    }

    reminderLoader = false;
    notifyListeners();
  }

  getReminderPriscriptionList() async {
    await Future.delayed(const Duration(milliseconds: 50));
    reminderLoader = true;
    notifyListeners();

    String endpoint = Endpoints.reminderPrescriptionList;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);

    if (responseData != null) {
      reminderPrescriptionList = ReminderPriscriptionList.fromJson(
        responseData,
      );

      // offersModel =result;
    } else {
      // return SymptomsAndIssuesModel(status: false);
    }
    reminderLoader = false;
    notifyListeners();
  }

  getPurchasedPackages() async {
    await Future.delayed(const Duration(milliseconds: 100));
    appoinmentsLoader = true;
    notifyListeners();
    String endpoint = Endpoints.purchasedPakages;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);
    if (responseData != null) {
      var result = PurchasedPackagesModel.fromJson(responseData);
      purchasedPackages = result.packages ?? [];
      //   ?? [
      // PurchasedPackage(packageTitle: "sdssds dsaf  af af a fas ffsdfsdf s af asdfs a ",startDate: "2024-08-09",endDate: "2024-08-10",remainingNoOfConsultation: 0,totalNoOfConsultation: 18,
      // packageMember: [PackageMember(),PackageMember(),PackageMember(),])];
    } else {
      // return PackagesListModel(status: false,message: "Something went wrong");
    }

    appoinmentsLoader = true;
    notifyListeners();
  }

  getPackages() async {
    await Future.delayed(const Duration(milliseconds: 100));
    appoinmentsLoader = true;
    notifyListeners();
    String endpoint = Endpoints.allPackages;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);
    log("response data of allPackages $responseData");
    if (responseData != null) {
      var result = PackagesListModel.fromJson(responseData);

      allPackages = result.packages ?? [];
    } else {
      // return PackagesListModel(status: false,message: "Something went wrong");
    }

    appoinmentsLoader = true;
    notifyListeners();
  }

  Future<void> purchasePkgApi(Map<String, dynamic> dt) async {
    String endpoint = Endpoints.initiatePurchasePackage;
    isPaymentOnProcess = true;
    paymentMessage = "";
    notifyListeners();

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = dt;
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log("response data of initiate purchase packahe $responseData");
    if (responseData != null) {
      var result = PackagePurchaseResponseModel.fromJson(responseData);

      if (!result.status!) {
        setPaymentStatus(false, result.message!);
      } else if (result.sdkPayload != null) {
        //initiate payment
        tempPackageId = result.temperoryUserPackageId!;
        packageOrderId = result.orderId!;
        notifyListeners();
        try {
          PaymentService.instance.hyperSDK.openPaymentPage(
            result.sdkPayload,
            hyperSDKCallbackHandler,
          );
        } on Exception catch (e, s) {
          log("message is error on package $e $s");
        }
      } else {
        log("Sdk payload is null");
        setPaymentStatus(false, "Something went wrong");
      }
    } else {
      setPaymentStatus(false, "Something went wrong");
    }
  }

  Future<bool> confirmPurchasePkgApi() async {
    log("message is confirm package cllaed");
    String endpoint = Endpoints.confirmPurchasePackage;
    isPaymentOnProcess = true;

    notifyListeners();

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {
      "temperory_user_package_id": tempPackageId,
      "package_order_id": packageOrderId,
    };
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log("response data of confirm purchase packahe $responseData");
    if (responseData != null) {
      var result = BasicResponseModel.fromJson(responseData);

      if (result.status!) {
        return true;
      } else {
        paymentMessage = result.message!;

        notifyListeners();
        return false;
      }
    } else {
      paymentMessage = "Something went wrong";
      notifyListeners();
      return false;
    }
  }

  setPaymentStatus(bool status, String message) async {
    if (!status && message == "charged") {
      final result = await confirmPurchasePkgApi();
      if (result) {
        paymentMessage = "charged";
        isPaymentOnProcess = false;
        notifyListeners();
      } else {
        isPaymentOnProcess = false;
        paymentMessage = "";
        notifyListeners();
      }
    } else {
      isPaymentOnProcess = status;
      paymentMessage = message;
      notifyListeners();
    }
  }

  getMedicalRecords(int userid) async {
    String endpoint = Endpoints.medicalRecords;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    await Future.delayed(const Duration(milliseconds: 500));
    medicalRecsLoader = true;
    notifyListeners();

    Map<String, dynamic> data = {"app_user_id": userid};
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      var result = MedicalRecordsModel.fromJson(responseData);
      medicalRecords = result.medicalRecordDetails ?? [];
    } else {
      // return SymptomsAndIssuesModel(status: false);
    }
    medicalRecsLoader = false;
    notifyListeners();
  }

  Future<BasicResponseModel> uploadMedicalRecord({
    required int userid,
    required String typeOfRecord,
    required List<String> files,
  }) async {
    String endpoint = Endpoints.medicalRecordUpload;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    await Future.delayed(const Duration(milliseconds: 50));
    medicalRecsLoader = true;
    notifyListeners();

    List<MultipartFile> fls = [];
    fls = files
        .map(
          (e) => MultipartFile.fromFileSync(
            e,
            filename: e.split('/').last,
            // contentType:MediaType.,
          ),
        )
        .toList();

    final formData = FormData.fromMap({
      "app_user_id": userid,
      "type_of_record": typeOfRecord,
      "files": fls,
    });

    dynamic responseData = await getIt<DioClient>().post(
      endpoint,
      formData,
      tokn,
    );
    if (responseData != null) {
      var result = BasicResponseModel.fromJson(responseData);
      return result;
    } else {
      return BasicResponseModel(status: false, message: "server error");
    }
  }

  getMedicalRecordsUsers() async {
    String endpoint = Endpoints.medicalRecordsUserList;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    medicalRecsLoader = true;
    notifyListeners();
    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);

    if (responseData != null) {
      var result = MedicalRecordsUsersModel.fromJson(responseData);
      medicalRecordUsers = result.userDetails ?? [];
    } else {
      // return SymptomsAndIssuesModel(status: false);
    }
    medicalRecsLoader = false;
    notifyListeners();
  }

  getBannersList() async {
    try {
      String endpoint = Endpoints.banners;
      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
      dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);

      if (responseData != null) {
        var result = BannersList.fromJson(responseData);
        mainBanners = result.mainBanners ?? [];
        subBanners = result.subBanners ?? [];
      }
    } catch (e) {
      // print(e);
    }
    notifyListeners();
  }

  getNearClinics({
    required double lat,
    required double long,
    String? country,
    String? state,
    String? locality,
  }) async {
    Items? res;
    if (country == null || state == null || locality == null) {
      res = await getIt<LocationManager>().getAddressByLatLong(
        lat: lat,
        long: long,
      );
    }

    String endpoint = Endpoints.nearClinics;
    Map<String, dynamic> data = {
      "city": locality ?? res?.address?.city,
      "page": 1,
      "latitude": lat,
      "longitude": long,
      "state": state ?? res?.address?.state,
      "country": country ?? res?.address?.countryName,
    };
    locLoader = true;
    notifyListeners();

    try {
      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

      dynamic responseData = await getIt<DioClient>().post(
        endpoint,
        data,
        tokn,
      );
      if (responseData != null) {
        var result = NearClinicsModel.fromJson(responseData);
        nearestClinics = result.clinics;
        // nearestClinics = [Clinics(clinic: 'Mothercare',id: 2,doctor: "Usman",qualification: "Plus two")];

        // print("nearestClinics");
        // print(nearestClinics);
        // notifyListeners();
      } else {
        // return NearClinicsModel(status: false);
      }
      locLoader = false;
      notifyListeners();
    } catch (e) {
      locLoader = false;
      notifyListeners();
    }
  }

  locationLoaderCntrl() {
    locLoader = !locLoader;
    notifyListeners();
  }

  bool isConsultationOngoing(UpcomingAppointments? todaysAppointment) {
    if (todaysAppointment == null) return false;

    // Parse bookingStartTime and bookingEndTime into DateTime objects
    DateTime? startTime = DateTime.tryParse(
      todaysAppointment.bookingStartTime ?? "",
    );
    DateTime? endTime = DateTime.tryParse(
      todaysAppointment.bookingEndTime ?? "",
    );

    if (startTime == null || endTime == null) return false;

    // Get the current time
    DateTime now = DateTime.now();

    // Check if now is between start and end times
    if (now.isAfter(startTime) && now.isBefore(endTime)) {
      return true; // Consultation is ongoing
    }

    return false; // Consultation not ongoing
  }

  Future<void> getNewsAndTips() async {
    try {
      String endpoint = Endpoints.newsAndTips;
      String token =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
      medicalRecsLoader = true;
      notifyListeners();
      dynamic responseData = await getIt<DioClient>().get(endpoint, token);
      if (responseData != null) {
        newsAndTips = NewsAndTips.fromJson(responseData);
      } else {}
      notifyListeners();
    } catch (e) {
      log("error message $e");
    }
  }

  void hyperSDKCallbackHandler(MethodCall methodCall) {
    switch (methodCall.method) {
      case "hide_loader":
        break;
      case "process_result":
        var args = {};

        try {
          args = json.decode(methodCall.arguments);
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
        var innerPayload = args["payload"] ?? {};
        var status = innerPayload["status"] ?? " ";
        // var orderId = args['orderId'];

        switch (status) {
          case "backpressed":
            setPaymentStatus(false, "User cancelled the payment");
            break;

          case "charged":
            setPaymentStatus(false, "charged");
            break;

          case "user_aborted":
            setPaymentStatus(false, "User cancelled the payment");
            break;

          default:
            setPaymentStatus(false, "Something went wrong");
            break;
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const ResponseScreen(),
          //         settings: RouteSettings(arguments: orderId)));
        }
    }
  }

  void resetPaymentStatus() {
    paymentMessage = "";
    isPaymentOnProcess = false;
  }
}
