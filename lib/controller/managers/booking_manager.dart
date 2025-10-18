// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dqapp/controller/services/payment_service.dart';
import 'package:dqapp/model/core/basic_response_model.dart';
import 'package:dqapp/model/core/bill_model.dart';
import 'package:dqapp/model/core/booking_validation_models.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../model/core/available_doctors_response_model.dart';
import '../../model/core/call_cred_model.dart';
import '../../model/core/coupons_model.dart';
import '../../model/core/doc_ids_model.dart';
import '../../model/core/doctor_list_response_model.dart';
import '../../model/core/doctors_slotpick_model.dart';
import '../../model/core/other_patients_response_model.dart';
import '../../model/core/package_list_response_model.dart';
import '../../model/core/booking_request_data_model.dart';
import '../../model/core/single_appoinment_model.dart';
import '../../model/helper/service_locator.dart';
import '../../view/screens/booking_screens/instant_booking_screen.dart';
import '../../view/widgets/common_widgets.dart';
import '../services/api_endpoints.dart';
import '../services/dio_service.dart';

class BookingManager extends ChangeNotifier {
  // User preferences and booking-related data
  String? preferredLanguage;
  String? preferredDoctorGender = "";
  bool consultingForOther = false;
  String selectedGender = "";
  List<String> medicReportFilesPaths = [];
  String? identityFilePath;
  String idNoForAgeVerification = '';
  int? searchSymptomId;

  // Models used for managing data
  CouponsModel? couponModel;
  DoctorSlotPickModel? doctorSlotPickModel;
  BillResponseModel? billModel;
  BillResponseModel? packageBillModel;
  // BillResponseModel? couponAppliedBillModel;
  PatientsDetailsModel otherPatientsDetails = PatientsDetailsModel(
    userRelations: [],
  );
  List<Packages> allPackages = [];
  UserDetails? selectedPatientDetails;
  SelectedPackageModel? selectedPkg;
  List<UserDetails> patientsUnderPackage = [];
  DoctorListModel? doctorsList;
  DocDetailsModel? docProfile;
  SingleAppoinmentModel? appointmentModel;
  SaveScheduledBookingModel? saveScheduledBookingModel;

  // Flags and loaders for UI updates
  // bool showFAB = true;
  bool bookingScreenLoader = false;
  bool billLoader = false;
  bool proceedLoader = false;
  bool listLoader = false;
  bool profileLoader = false;
  bool slotPickLoader = false;
  bool futureSlotLoader = false;

  bool callingLoader = false;
  bool ageVerificationLoader = false;
  bool buttonLoader = false;

  // Dropdown and selection items
  List<IdTypes>? idTypes;
  IdTypes? selectedDocItem;
  Coupons? selectedCoupon;
  BookingDataDetailsModel? docsData;

  // Zoom SDK-related properties
  ZoomVideoSdkUser? usersmallUser;
  bool? showSmallPoints;
  String? selectedPositionId;

  CallCred? callCredentials;
  var zoom = ZoomVideoSdk();

  bool isPaymentOnProcess = false;
  String paymentMessage = "";
  int? currentTempBookingId;
  Future<BookingSaveResponseModel> Function(int)? currentSaveBookingCallback;

  bool saveBookingCalled = false;

  //[isBackCalled] and [isPaymentFlowInitiated] is
  //used for smooth back button from payment page
  bool isBackCalled = false;
  bool isPaymentFlowInitiated = false;

  setBackCalled(val) {
    isBackCalled = val;
    notifyListeners();
  }

  setPaymentInitiated(val) {
    isPaymentFlowInitiated = val;
    notifyListeners();
  }

  //for passing to psychology schedule booking
  int? psychologyBookingType;

  setPsychologyBookingType(val) {
    psychologyBookingType = val;
    notifyListeners();
  }

  setSearchSymptomId(val) {
    searchSymptomId = val;
    notifyListeners();
  }

  setSaveBookingCalled(val) {
    saveBookingCalled = val;
    notifyListeners();
  }

  bool isFree = false;

  String currentOrderId = "";

  // void initiatePayment(
  //   dynamic sdkPayload,
  //   // {required int tempBookingId,
  //   // required Future<BookingSaveResponseModel> Function(int) saveBooking,
  //   // required bool isFree}
  // ) {
  //   isPaymentOnProcess = true;
  //   paymentMessage = "";
  //   // currentTempBookingId = tempBookingId;
  //   // currentSaveBookingCallback = saveBooking;
  //   // this.isFree = isFree;
  //   notifyListeners();

  //   PaymentService.instance.hyperSDK.openPaymentPage(
  //     sdkPayload,
  //     PaymentService.instance.hyperSDKCallbackHandler,
  //   );
  // }

  void initiatePayment(
    dynamic sdkPayload, {
    required int tempBookingId,
    required Future<BookingSaveResponseModel> Function(int) saveBooking,
    required bool isFree,
  }) {
    try {
      isPaymentOnProcess = true;
      paymentMessage = "";
      saveBookingCalled = false;
      currentTempBookingId = tempBookingId;
      currentSaveBookingCallback = saveBooking; // 🔥 store callback here
      this.isFree = isFree;
      currentOrderId = sdkPayload["payload"]["orderId"].toString();

      notifyListeners();

      PaymentService.instance.hyperSDK.openPaymentPage(
        sdkPayload,
        PaymentService.instance.hyperSDKCallbackHandler,
      );
    } catch (e, s) {
      log("message is $e $s");
    }
  }

  void changePaymentProcessAndMessage(bool status, String message) {
    log("message is status top change $status $message");
    isPaymentOnProcess = status;
    paymentMessage = message;
    notifyListeners();
    log("message is status bottom change $isPaymentOnProcess $paymentMessage");
  }

  void resetPaymentState() {
    log("message is reset payment called");
    saveBookingCalled = false;
    setPaymentInitiated(false);
    isPaymentOnProcess = false;
    paymentMessage = "";
    currentTempBookingId = null;
    currentOrderId = "";
    currentSaveBookingCallback = null;
    setSaveBookingCalled(false);
    notifyListeners();
  }

  //Function for leaving from zoom call from out side of call screen
  void onLeaveSession(bool isEndSession, {bool? fromCall}) async {
    if (usersmallUser != null || fromCall == true) {
      await zoom.leaveSession(isEndSession);
      // setSmallUser(user: null,cred: null);
      // Navigator.pop(context);
    }
  }

  /// Updates the state of small points visibility in ANATOMY
  setShowSmallPoints(bool value) {
    showSmallPoints = value;
    notifyListeners();
  }

  setSelectedSmallPoints(String? value) {
    // print("sdsd");
    // print("sdsd");
    // print("sdsd");
    // print("sdsd");
    selectedPositionId = value;
    notifyListeners();
  }

  /// Clears the list of patients under the package.
  disposePatientsUnderPackage() {
    patientsUnderPackage = [];
  }

  /// Adds or removes a user from the package list.
  setPatientsUnderPackage({required bool isAdd, required UserDetails user}) {
    if (isAdd) {
      patientsUnderPackage.add(user);
    } else {
      patientsUnderPackage.remove(user);
    }
    notifyListeners();
  }

  /// Updates the ID number for age verification.
  setIdNoforAgeVerify(val) {
    idNoForAgeVerification = val;
    notifyListeners();
  }

  /// Clears the doctor's profile data.
  disposeDoctorProfile() {
    docProfile = null;
  }

  /// Clears the selected doctor's slots.
  disposePickSlots() {
    doctorSlotPickModel = null;
  }

  ///stores available doctors data
  setDocsData(BookingDataDetailsModel val) {
    docsData = val;
  }

  ///Clears the appointments details data
  disposeAppoinmentDetail() {
    appointmentModel = null;
  }

  ///stores selected date from doctors slots screen
  setSelectedDate(String date) {
    for (var i in doctorSlotPickModel?.allTimeSlots ?? []) {
      if (date == i.date) {
        doctorSlotPickModel!.selectedDate = i;
        setSelectedTimeSlot(null);
        // notifyListeners();
      }
    }
  }

  ///stores selected slot
  setSelectedTimeSlot(String? time) {
    doctorSlotPickModel!.selectedTimeSlot = time;
    notifyListeners();
  }

  ///carries the value which denote whether age proof is submitted or not
  changeAgeProofSubmittedValue(bool val) {
    docsData!.isAgeProofSubmitted = val;
    notifyListeners();
  }

  setLoaderActive(bool val) {
    billLoader = val;
    notifyListeners();
  }

  ///Schedule Booking API call
  Future<BasicResponseModel> scheduleOnlineBooking({
    required String? date,
    required String? time,
    required int? docId,
    required int? specialtyId,
    required String? paidAmount,
    required String? consultationFor,
    int? freeFollowUpId,
    isFreeFollowUp,
  }) async {
    String endpoint = Endpoints.freeFollowUpBooking;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {
      "date": date,
      "time": time,
      "doctor_id": docId,
      "speciality_id": specialtyId == -1 ? null : specialtyId,
      "paid_amount": paidAmount,
      "consultation_for": consultationFor,
      "free_followup_booking": freeFollowUpId,
      "is_free_followup": isFreeFollowUp,
    };
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log("response data of freefollowup booking $responseData");
    if (responseData != null) {
      var res = BasicResponseModel.fromJson(responseData);
      return res;
    } else {
      return BasicResponseModel(status: false, message: "");
    }
  }

  Future<BasicResponseModel> shareAnatomyPoint({
    required int? bookingId,
    required String? point,
  }) async {
    String endpoint = Endpoints.identifyAnatomyPoints;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {
      "point": point,
      "image": "sss",
      "booking_id": bookingId,
    };
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      var res = BasicResponseModel.fromJson(responseData);
      return res;
    } else {
      return BasicResponseModel(status: false, message: "");
    }
  }

  ///Sending consulted status by calling API
  Future<BasicResponseModel> sendConsultedStatus(int bookingId) async {
    String endpoint = Endpoints.connectScheduleBooking;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {
      "booking_id": bookingId,
      "connection_type": 1,
      "connected_user_type": 1,
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      var res = BasicResponseModel.fromJson(responseData);
      return res;
    } else {
      return BasicResponseModel(status: false, message: "");
    }
  }

  // function for checking that is there doctor connected to the request that send by patient
  Future<BasicResponseModel> getConnectionStatus(int bookingId) async {
    String endpoint = Endpoints.bookingReqStatus;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {"booking_id": bookingId};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log("payload is connection status $responseData");
    if (responseData != null) {
      var res = BasicResponseModel.fromJson(responseData);
      return res;
    } else {
      return BasicResponseModel(status: false, message: "");
    }
  }

  setPackageBillModel(BillResponseModel val) {
    packageBillModel = val;
    notifyListeners();
  }

  setSelectedPackage(SelectedPackageModel? val) {
    selectedPkg = val;
    if (val == null) {
      packageBillModel = null;
    }
    notifyListeners();
  }

  setSelectedCoupon(Coupons? val) {
    selectedCoupon = val;
    if (val == null) {
      // couponAppliedBillModel = null;
    }
    notifyListeners();
  }

  disposePatientForm() {
    medicReportFilesPaths = [];
    selectedGender = "";
    bookingScreenLoader = false;
  }

  disposeBooking() {
    preferredLanguage = null;
    consultingForOther = false;
    selectedGender = "";
    couponModel = null;
    billModel = null;
    // couponAppliedBillModel = null;
    packageBillModel = null;
    selectedPkg = null;
    selectedCoupon = null;
    otherPatientsDetails = PatientsDetailsModel(userRelations: []);
    medicReportFilesPaths = [];
    allPackages = [];
    selectedPatientDetails = null;
    bookingScreenLoader = false;
  }

  // applycouponChangeBill({
  //   required String discnt,
  //   required String amtAftrDiscnt,
  //   required int? couponId,
  // }){
  //   couponAppliedBillModel = billModel;
  //   couponAppliedBillModel!.couponAppliedAmt = discnt;
  //   couponAppliedBillModel!.amountAfterDiscount = amtAftrDiscnt;
  //   couponAppliedBillModel!.couponIdIfApplied = couponId;
  //   notifyListeners();
  //
  // }

  selectDocType(String? val) {
    if (val != null) {
      for (var i in idTypes!) {
        if (i.name == val) {
          selectedDocItem = i;
        }
      }
    } else {
      selectedDocItem = null;
    }
  }

  disposeAgeVerification() {
    idNoForAgeVerification = "";
    selectedDocItem = null;
    identityFilePath = null;
    ageVerificationLoader = false;
  }

  selectDocTypeInitially() {
    if (idTypes != null && idTypes!.isNotEmpty) {
      selectedDocItem = idTypes!.first;
    }
  }

  setOtherperson(UserDetails? val) {
    selectedPatientDetails = val;
    notifyListeners();
  }
  // showFABfn( bool val) {
  //   showFAB = val;
  //   notifyListeners();
  // }

  deleteFile(val) {
    for (var i in medicReportFilesPaths) {
      if (val == i) {
        medicReportFilesPaths.remove(val);
        notifyListeners();
      }
    }
  }

  addFiles(List<String> val) {
    medicReportFilesPaths.addAll(val);
    notifyListeners();
  }

  addIdFile(String? val) {
    identityFilePath = val;
    notifyListeners();
  }

  setAgeVerifyloader(bool val) {
    ageVerificationLoader = val;
    notifyListeners();
  }

  getDocIds() async {
    String endpoint = Endpoints.docIds;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);

    if (responseData != null) {
      idTypes = DocIds.fromJson(responseData).idTypes;
      notifyListeners();
    } else {
      // return SymptomsAndIssuesModel(status: false);
    }
  }

  getPackages(int specialityId, int? subSpecialityId) async {
    log("message is getPakcages called");
    try {
      String endpoint = Endpoints.getPackages;

      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
      Map<String, dynamic> data = {
        "speciality_id": specialityId == -1 ? null : specialityId,
        "subspeciality_id": subSpecialityId,
      };
      dynamic responseData = await getIt<DioClient>().post(
        endpoint,
        data,
        tokn,
      );
      log("response of getpackages $responseData");
      if (responseData != null) {
        var result = PackagesListModel.fromJson(responseData);
        allPackages = result.packages ?? [];
        notifyListeners();
      } else {
        // return PackagesListModel(status: false,message: "Something went wrong");
      }
    } on Exception catch (e, s) {
      log("message: error on getPackages $e \n$s");
    }
  }

  //   Future<AppliedCouponResponseModel> applyCoupon({required int speciality,required int? docId,required String couponCode,required int typeOfBooking,
  // })async{
  //
  //     String endpoint = Endpoints.applyCoupon;
  //
  //     Map<String, dynamic> data = {
  //       "speciality":speciality,
  //       "coupon_code":couponCode,
  //       "type":typeOfBooking,
  //       "doctor_id":docId
  //
  //     };
  //
  //     String tokn = getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
  //
  //     dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
  //     if (responseData != null) {
  //       var result = AppliedCouponResponseModel.fromJson(responseData);
  //       return result;
  //     }else{
  //       return AppliedCouponResponseModel(status: false,message: "Something went wrong");
  //     }
  //   }

  onlineBookingRedirectionFn({
    required int specialityId,
    int? symptomId,
    required int? categoryId,
    required String specialityTitle,
    required BuildContext context,
    int? typeOfPsychology,
    int? subspecialityId,
  }) async {
    var result = await getIt<BookingManager>().getDocsList(
      specialityId: specialityId,
      symptomId: symptomId,
      typeOfPsychology: typeOfPsychology,
      subSpecialityId: subspecialityId,
    );

    log("doctors data ${result.toJson()}");
    if (result.status == true && result.isAnyDoctorExist == true) {
      getIt<BookingManager>().setDocsData(result);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BookingScreen(
            subCatId: categoryId,
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

  Future<PatientsSaveResponseModel?> addNewPatient({
    required int? userId,
    required String firstName,
    required String lastName,
    required String dob,
    required String gender,
    required String relation,
    // required String maritalStatus,
    required String height,
    required String weight,
    required String bGroup,
    required String bSugar,
    required String bPressure,
    required String serumCre,
    required List<String> files,
    required bool isUserIsPatient,
  }) async {
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    String endpoint = Endpoints.otherPatientsDetailsSave;
    bookingScreenLoader = true;
    notifyListeners();
    // Dio dio = Dio();
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
      "user_relation_id": userId ?? "",
      "consultation_for": isUserIsPatient ? "Self" : "Relative",
      "first_name": firstName,
      "last_name": lastName,
      "date_of_birth": dob,
      "gender": gender,
      "relation": relation,
      // "marital_status":maritalStatus,
      "height": height.isNotEmpty ? double.parse(height) : null,
      "weight": weight.isNotEmpty ? double.parse(weight) : null,
      "blood_group": bGroup.isNotEmpty ? bGroup : null,
      "blood_sugar": bSugar.isNotEmpty ? double.parse(bSugar) : null,
      "blood_pressure": bPressure.isNotEmpty ? bPressure : null,
      "serum_creatinine": serumCre.isNotEmpty ? double.parse(serumCre) : null,
      "files": fls,
    });

    // Map<String, dynamic> userdetails = {
    //   "user_relation_id": userId ?? "",
    //   "consultation_for": isUserIsPatient ? "Self" : "Relative",
    //   "first_name": firstName,
    //   "last_name": lastName,
    //   "date_of_birth": dob,
    //   "gender": gender,
    //   "relation": relation,
    //   // "marital_status":maritalStatus,
    //   "height": height.isNotEmpty ? double.parse(height) : null,
    //   "weight": weight.isNotEmpty ? double.parse(weight) : null,
    //   "blood_group": bGroup.isNotEmpty ? bGroup : null,
    //   "blood_sugar": bSugar.isNotEmpty ? double.parse(bSugar) : null,
    //   "blood_pressure": bPressure.isNotEmpty ? bPressure : null,
    //   "serum_creatinine": serumCre.isNotEmpty ? double.parse(serumCre) : null,
    // };

    // print(userdetails);

    var response = await getIt<DioClient>().post(endpoint, formData, tokn);

    // print("file upload $response");

    if (response != null) {
      var result = PatientsSaveResponseModel.fromJson(response);

      if (result.status == true) {
        await getIt<BookingManager>().getPatientsDetailsList(
          userId: result.userId!,
          isRegisteredUser: isUserIsPatient,
        );

        bookingScreenLoader = false;
        notifyListeners();
        return result;
      } else {
        bookingScreenLoader = false;
        notifyListeners();
        return PatientsSaveResponseModel(
          status: false,
          message: result.message,
        );
      }
    } else {
      bookingScreenLoader = false;
      notifyListeners();
      return PatientsSaveResponseModel(
        status: false,
        message: "Something went wrong",
      );
    }
  }

  Future<BasicResponseModel> uploadAgeProofDoc({
    required String idNo,
    required int? userId,
  }) async {
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    // await Future.delayed
    ageVerificationLoader = true;
    notifyListeners();

    String endpoint = Endpoints.idDocUpload;
    MultipartFile? fls = MultipartFile.fromFileSync(
      identityFilePath!,
      filename: identityFilePath!.split('/').last,
    );

    final formData = FormData.fromMap({
      "app_user_id": userId,
      "document_type_id": selectedDocItem!.id,
      "document_id": idNo,
      "document": fls,
    });

    // print({"document_type_id": selectedDocItem!.id, "document_id": idNo, "document": fls});

    var response = await getIt<DioClient>().post(endpoint, formData, tokn);
    ageVerificationLoader = false;
    notifyListeners();
    if (response != null) {
      var result = BasicResponseModel.fromJson(response);
      return result;
    } else {
      return BasicResponseModel(message: "Server error", status: false);
    }
  }

  Future<BillResponseModel> getBillDetails({
    required int spID,
    required int? subSpecialityID,
    required int? type,
    required int? doctorId,
    String? couponCode,
    required SelectedPackageDetails? packageDetails,
    required bool? isSeniorCitizenConsultation,
    int? consultationCategoryForInstantCall,
    int? patientId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 50));

    billLoader = true;
    notifyListeners();

    String endpoint = Endpoints.billDetails;

    // Map<String, dynamic> data = {
    //   "speciality_id":spID,
    //   "bill_type":type,
    //   "doctor_id":doctorId
    // };
    Map<String, dynamic> data = {
      "speciality_id": spID < 1 ? null : spID,
      "subspeciality_id": subSpecialityID,
      // "symptom_id": searchSymptomId,
      "bill_type": type, //#If null - Instant booking, 1 - Online , 2 - Offline
      "doctor_id": doctorId,
      "consultation_category": consultationCategoryForInstantCall,
      "coupon_code": couponCode,
      "senior_citizen_free_consultation": isSeniorCitizenConsultation,
      "patient_id": patientId,
      "package_details": packageDetails?.packageId != null
          ? {
              "package_id": packageDetails?.packageId,
              "package_members": packageDetails?.packageMembers,
            }
          : null,
    };

    log("message from bill details req data $data");

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log("message from bill details $responseData");
    billLoader = false;
    notifyListeners();
    if (responseData != null) {
      var result = BillResponseModel.fromJson(responseData);
      if (result.status == true) {
        billModel = result;
      }
      return result;
    } else {
      return BillResponseModel(status: false, message: "Server Error");
    }
    // billLoader=false;
    // notifyListeners();
  }

  setPrefferedLanguage(val) {
    preferredLanguage = val;
    notifyListeners();
  }

  setPrefferedDocGender(val) {
    preferredDoctorGender = val;
    notifyListeners();
  }

  setConsultforOther(val) {
    consultingForOther = val;
    notifyListeners();
  }

  updateGnder(String val) {
    // print("btmNavIndex changd to $val");
    selectedGender = val;
    notifyListeners();
  }

  selectPriceCategory(DoctorCatogory? priceCat) {
    docsData!.selectedPriceCategory = priceCat;
    notifyListeners();
  }

  Future<BookingDataDetailsModel> getDocsList({
    int? specialityId,
    int? symptomId,
    int? userId,
    String? genderPref,
    String? slotPref,
    int? typeOfPsychology,
    int? subSpecialityId,
  }) async {
    bookingScreenLoader = true;
    await Future.delayed(const Duration(milliseconds: 500));
    notifyListeners();

    String? langPref =
        ["English", "Malayalam"].contains(preferredLanguage) == true
        ? preferredLanguage
        : null;

    Map<String, dynamic> data = {
      "speciality": (specialityId == -1 || specialityId == 0)
          ? null
          : specialityId,
      "symptom_id": symptomId,
      "app_user_id": userId,
      "gender": genderPref,
      "language": langPref,
      "slot_preference": slotPref,
      "psychology_type": typeOfPsychology,
      "subspeciality_id": subSpecialityId,
    };

    String endpoint = Endpoints.availDocs;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log('request of getdocs list $data');
    log('response of getdocs list $responseData');

    if (responseData != null) {
      bookingScreenLoader = false;
      notifyListeners();
      var result = BookingDataDetailsModel.fromJson(responseData);
      result.selectedPriceCategory = docsData?.selectedPriceCategory == null
          ?
            //     ? DoctorCatogory(title: StringConstants.dPrefNoPref, consultationCategory: 0, doctors: result.doctors)
            result.minDoctors?.doctors != null &&
                    result.minDoctors!.doctors!.isNotEmpty
                ? result.minDoctors!
                : result.midDoctors?.doctors != null &&
                      result.midDoctors!.doctors!.isNotEmpty
                ? result.midDoctors!
                : result.maxDoctors?.doctors != null &&
                      result.maxDoctors!.doctors!.isNotEmpty
                ? result.maxDoctors!
                : null
          : docsData?.selectedPriceCategory?.consultationCategory == 1 &&
                result.minDoctors?.doctors != null &&
                result.minDoctors!.doctors!.isNotEmpty
          ? result.minDoctors
          : docsData?.selectedPriceCategory?.consultationCategory == 2 &&
                result.midDoctors?.doctors != null &&
                result.midDoctors!.doctors!.isNotEmpty
          ? result.midDoctors
          : docsData?.selectedPriceCategory?.consultationCategory == 3 &&
                result.maxDoctors?.doctors != null &&
                result.maxDoctors!.doctors!.isNotEmpty
          ? result.maxDoctors
          : result.minDoctors?.doctors != null &&
                result.minDoctors!.doctors!.isNotEmpty
          ? result.minDoctors!
          : result.midDoctors?.doctors != null &&
                result.midDoctors!.doctors!.isNotEmpty
          ? result.midDoctors!
          : result.maxDoctors?.doctors != null &&
                result.maxDoctors!.doctors!.isNotEmpty
          ? result.maxDoctors!
          : null;

      // print(result.selectedPriceCategory?.consultationCategory);
      return result;
    } else {
      bookingScreenLoader = false;
      notifyListeners();
      return BookingDataDetailsModel(
        status: false,
        message: "Something went wrong",
      );
    }
  }

  Future<BookingDataDetailsModel> getScheduledBookingData({
    required int specialityId,
    required int? doctorId,
    int? userId,
    // int? typeOfPsychology,
    int? subSpecialityId,
  }) async {
    bookingScreenLoader = true;
    await Future.delayed(const Duration(milliseconds: 500));
    notifyListeners();
    String endpoint = Endpoints.scheduledBookDetails;

    Map<String, dynamic> data = {
      "speciality_id": specialityId == -1 ? null : specialityId,
      "app_user_id": userId,
      "doctor_id": doctorId,
      "subspeciality_id": subSpecialityId,
    };

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      bookingScreenLoader = false;
      notifyListeners();
      var result = BookingDataDetailsModel.fromJson(responseData);
      return result;
    } else {
      bookingScreenLoader = false;
      notifyListeners();
      return BookingDataDetailsModel(
        status: false,
        message: "Something went wrong",
      );
    }
  }

  getCouponList({
    required int specialityId,
    required int type,
    int? subSpecialityId,
  }) async {
    String endpoint = Endpoints.couponCodes;

    Map<String, dynamic> data = {
      "speciality_id": specialityId == -1 ? null : specialityId,
      "subspeciality_id": subSpecialityId,
      "type": type == 2
          ? 2
          : 1, //if offline clinic booking is going then type will be 2 otherwise 1(instant or online scheduled booking)
    };

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log("response of getCouponList $responseData");
    if (responseData != null) {
      couponModel = CouponsModel.fromJson(responseData);
      notifyListeners();
    } else {}
  }

  getDoctorSlots({
    required bool isFreeFollowUp,
    int? clinicId,
    required bool isScheduledOnline,
    required bool isFutureSlotsRequired,
    required String? date,
    required int? docId,
    required int? bookId,
  }) async {
    if (!isFutureSlotsRequired) {
      slotPickLoader = true;
    } else {
      futureSlotLoader = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    // await Future.delayed(const Duration(milliseconds: 100));
    String endpoint = Endpoints.doctorSlots;

    Map<String, dynamic> data = {
      "booking_type": isFreeFollowUp == true
          ? "Free followup"
          : isScheduledOnline == true
          ? "Scheduled online"
          : "Scheduled offline",
      "date": date ?? '',
      "clinic_id": clinicId,
      "doctor_id": docId,
      "booking_id": bookId,
      "is_future_slots_required": isFutureSlotsRequired,
    };

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      if (doctorSlotPickModel != null) {
        AllTimeSlots? tempDate = doctorSlotPickModel?.selectedDate;
        String? tempSlot = doctorSlotPickModel?.selectedTimeSlot;
        doctorSlotPickModel = DoctorSlotPickModel.fromJson(responseData);
        for (var i in doctorSlotPickModel?.allTimeSlots ?? []) {
          if (tempDate?.date == i.date) {
            doctorSlotPickModel!.selectedDate = i;
            doctorSlotPickModel?.selectedTimeSlot = tempSlot;
          }
        }
      } else {
        doctorSlotPickModel = DoctorSlotPickModel.fromJson(responseData);
      }
    }
    slotPickLoader = false;
    futureSlotLoader = false;
    notifyListeners();
    return true;
  }

  getPatientsDetailsList({int? userId, bool? isRegisteredUser}) async {
    String endpoint = Endpoints.otherPatientsDetails;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);
    log("response data of getPatientsDetailsList $responseData ");
    if (responseData != null) {
      otherPatientsDetails = PatientsDetailsModel.fromJson(responseData);
      if (userId != null &&
          otherPatientsDetails.userRelations != null &&
          otherPatientsDetails.userRelations!.isNotEmpty &&
          isRegisteredUser != true) {
        for (var i in otherPatientsDetails.userRelations!) {
          if (i.appUserId == userId) {
            selectedPatientDetails = i;
          }
        }
      } else {
        selectedPatientDetails = otherPatientsDetails.userDetails;
      }
      notifyListeners();
    } else {
      // return CouponsModel(status: false);
    }
  }

  Future<BasicResponseModel> initiateCall({
    required int bookingId,
    bool? forStatusCheck,
  }) async {
    // await Future.delayed(Duration(milliseconds: 50));
    callingLoader = true;
    notifyListeners();
    String endpoint = Endpoints.callConnection;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {
      "booking_id": bookingId,
      "user_type": 2,
      "call_status_checking": forStatusCheck == true ? true : false,
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    // if (responseData != null) {
    //   var result = PatientsRequestsModel.fromJson(responseData);
    //   patientsReqList  = result.patientDetails ?? [];
    // }
    callingLoader = false;
    notifyListeners();
    if (responseData != null) {
      var result = BasicResponseModel.fromJson(responseData);
      return result;
      //   patientsReqList  = result.patientDetails ?? [];
    } else {
      return BasicResponseModel(status: false, message: "Something went wrong");
    }
  }

  setProceedLoader(bool val) {
    proceedLoader = val;
    notifyListeners();
  }

  setButtonLoader(bool val) {
    buttonLoader = val;
    notifyListeners();
  }

  setListLoader(bool val) {
    listLoader = val;
    notifyListeners();
  }

  setProfileLoader(bool val) {
    profileLoader = val;
    notifyListeners();
  }

  Future<BookingValidationResponseData> instantBookingValidation(
    BookingDetailsItem item,
    BillResponseModel bill,
  ) async {
    setProceedLoader(true);
    String endpoint = Endpoints.instantBookingValidation;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "consultation_amount": double.tryParse(bill.fee!),
      "platform_fee": double.tryParse(bill.platformFee!),
      "tax": double.tryParse(bill.tax!),
      "subcategory_id": item.subcategoryId,
      "gender": item.gender,
      "language": item.language,
      "consultation_category": item.seniorCitizenFreeConsultation == true
          ? null
          : item.selectedPriceCategory,
      "subspeciality_id": item.subSpecialityId,
      "psychology_type": item.psychologyType,
      "senior_citizen_free_consultation": item.seniorCitizenFreeConsultation,
      "package_details": {
        "package_id": item.packageDetails?.packageId,
        "package_members": item.packageDetails?.packageMembers,
      },
      "paid_amount": double.parse(bill.amountAfterDiscount!),
      "coupon_id": bill.couponIdIfApplied,
      "patient_id": item.patientId,
      "consultation_for": item.consultationFor,
      "speciality_id": item.specialityId == -1 ? null : item.specialityId,
      // "subspeciality_id":item.subSpecialityId
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      var resp = BookingValidationResponseData.fromJson(responseData);

      setProceedLoader(false);
      log("instant booking validation response is ${resp.toJson()}");
      return resp;
    } else {
      log("message is response data is null");
      setProceedLoader(false);

      return BookingValidationResponseData(
        message: "Something went wrong",
        status: false,
      );
    }
  }

  Future<BookingValidationResponseData> scheduledBookingValidation({
    required BillResponseModel bill,
    required SaveScheduledBookingModel dt,
  }) async {
    setProceedLoader(true);
    String endpoint = Endpoints.scheduledBookingValidation;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "date": dt.date,
      "time": dt.time,
      "booking_type": dt.bookingType,
      "doctor_id": dt.doctorId,
      "speciality_id": dt.specialityId == -1 ? null : dt.specialityId,
      "subspeciality_id": dt.subSpecialityIdForPsychology,
      "psychology_type": psychologyBookingType,
      "free_followup_booking": dt.freeFollowupBooking,
      "is_free_followup": dt.isFreeFollowup,
      "paid_amount": double.tryParse(bill.amountAfterDiscount ?? '0'),
      "consultation_amount": double.tryParse(bill.fee ?? '0'),
      "platform_fee": double.tryParse(bill.platformFee ?? '0'),
      "tax": double.tryParse(bill.tax ?? '0'),
      "coupon_id": bill.couponIdIfApplied,
      "clinic_id": dt.clinicId,
      "patient_id": dt.patientId,
      "consultation_for": dt.consultationFor,
      "subcategory_id": dt.subcategoryId,
      "senior_citizen_free_consultation": dt.seniorCitizenFreeConsultation,
      "package_details": {
        "package_id": dt.packageDetails?.packageId,
        "package_members": dt.packageDetails?.packageMembers,
      },
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log("scheduledBookingValidation response $responseData");
    if (responseData != null) {
      var resp = BookingValidationResponseData.fromJson(responseData);
      setProceedLoader(false);

      return resp;
    } else {
      setProceedLoader(false);

      return BookingValidationResponseData(
        message: "Something went wrong",
        status: false,
      );
    }
  }

  Future<BookingValidationResponseData> psychologyInstantBookingValidation({
    required BillResponseModel bill,
    required PsychologyInstantBookingData dt,
  }) async {
    setProceedLoader(true);
    String endpoint = Endpoints.psychologyInstantBookingValidation;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "consultation_amount": double.tryParse(bill.fee ?? '0'),
      "platform_fee": double.tryParse(bill.platformFee ?? '0'),
      "tax": double.tryParse(bill.tax ?? '0'),
      "doctor_id": dt.doctorId,
      "subcategory_id": null,
      "gender": null,
      "consultation_category": null,
      "subspeciality_id": dt.subSpecialityId,
      "psychology_type": dt.psychologyType,
      "senior_citizen_free_consultation": dt.seniorCitizenFreeConsultation,
      "package_details": {
        "package_id": dt.packageDetails?.packageId,
        "package_members": dt.packageDetails?.packageMembers,
      },
      "paid_amount": double.tryParse(bill.amountAfterDiscount ?? '0'),
      "coupon_id": bill.couponIdIfApplied,
      "patient_id": dt.patientId,
      "consultation_for": dt.consultationFor,
      "speciality_id": dt.specialityId == -1 ? null : dt.specialityId,

      // "date":dt.date,
      //   "time" : dt.time,
      //   "booking_type":dt.bookingType,
      //   "free_followup_booking":dt.freeFollowupBooking,
      //   "is_free_followup":dt.isFreeFollowup,
      //
      //   "clinic_id":dt.clinicId,
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log("psychologyInstantBookingValidation response $responseData");
    if (responseData != null) {
      var resp = BookingValidationResponseData.fromJson(responseData);
      setProceedLoader(false);

      return resp;
    } else {
      setProceedLoader(false);

      return BookingValidationResponseData(
        message: "Something went wrong",
        status: false,
      );
    }
  }

  Future<BookingSaveResponseModel> instantBookingSave({
    required BookingDetailsItem item,
    required BillResponseModel bill,
    required int tempBookingID,
    required String currentOrderID,
  }) async {
    saveBookingCalled = true;
    setProceedLoader(true);

    log("message is instant booking save called");

    String endpoint = Endpoints.saveInstantBooking;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "temperory_booking_id": tempBookingID,
      "payment_order_id": currentOrderID == "" ? null : currentOrderID,
      // "consultation_amount": double.parse(bill.fee!),
      // "consultation_category": item.seniorCitizenFreeConsultation == true
      //     ? null
      //     : item.selectedPriceCategory,
      // "platform_fee": double.parse(bill.platformFee!),
      // "tax": double.parse(bill.tax!),
      // "subcategory_id": item.subcategoryId,
      // "gender": item.gender,
      // "senior_citizen_free_consultation": item.seniorCitizenFreeConsultation,
      // "subspeciality_id": item.subSpecialityId,
      // "psychology_type": item.psychologyType,
      // "package_details": {
      //   "package_id": item.packageDetails?.packageId,
      //   "package_members": item.packageDetails?.packageMembers,
      // },
      // "paid_amount": double.tryParse(bill.amountAfterDiscount ?? ""),
      // "coupon_id": bill.couponIdIfApplied,
      // "patient_id": item.patientId,
      // "consultation_for": item.consultationFor,
      // "speciality_id": item.specialityId,
    };

    log("Save req data is $data");

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log("Save response data is $responseData");

    setProceedLoader(false);

    if (responseData != null) {
      // ignore: prefer_typing_uninitialized_variables
      var resp;
      try {
        log("current ordder id $currentOrderID");
        resp = BookingSaveResponseModel.fromJson(responseData);
        resp.paymentDetails ??= {}; // Initialize if null
        resp.paymentDetails["id"] = currentOrderID;
        resp.paymentDetails["amount"] = double.tryParse(
          bill.amountAfterDiscount ?? "",
        );
      } catch (e, s) {
        log("errr $e $s");
      }

      // debugPrint('paymentDetails : ${resp.paymentDetails}', wrapWidth: 1024);

      return resp;
    } else {
      setProceedLoader(false);

      return BookingSaveResponseModel(
        message: "Something went wrong",
        status: false,
      );
    }
  }

  Future<BookingSaveResponseModel> scheduledBookingSave({
    required SaveScheduledBookingModel sd,
    required BillResponseModel bill,
    required int tempBookingID,
    required String currentOrderID,
  }) async {
    saveBookingCalled = true;
    setProceedLoader(true);

    String endpoint = Endpoints.scheduledBookingsave;
    saveBookingCalled = true;
    notifyListeners();
    log("message is save booking called");

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "temperory_booking_id": tempBookingID,
      "payment_order_id": currentOrderID == "" ? null : currentOrderID,
      "date": sd.date,
      "time": sd.time,
      "booking_type": sd.bookingType,
      "doctor_id": sd.doctorId,
      "speciality_id": sd.specialityId == -1 ? null : sd.specialityId,
      "psychology_type": psychologyBookingType,
      // "subspeciality_id": sd.subSpecialityId,
      "free_followup_booking": sd.freeFollowupBooking,
      "is_free_followup": sd.isFreeFollowup,
      "paid_amount": double.tryParse(bill.amountAfterDiscount ?? '0'),
      "consultation_amount": double.tryParse(bill.fee ?? '0'),
      "platform_fee": double.tryParse(bill.platformFee ?? '0'),
      "tax": double.tryParse(bill.tax ?? '0'),
      "coupon_id": bill.couponIdIfApplied,
      "clinic_id": sd.clinicId,
      "patient_id": sd.patientId,
      "consultation_for": sd.consultationFor,
      "subcategory_id": sd.subcategoryId,
      "senior_citizen_free_consultation": sd.seniorCitizenFreeConsultation,
      "package_details": {
        "package_id": sd.packageDetails?.packageId,
        "package_members": sd.packageDetails?.packageMembers,
      },
    };
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log("response data from scheduledBookingSave $responseData");
    if (responseData != null) {
      var resp = BookingSaveResponseModel.fromJson(responseData);
      resp.paymentDetails ??= {}; // Initialize if null

      resp.paymentDetails["id"] = currentOrderID;
      resp.paymentDetails["amount"] = double.tryParse(
        bill.amountAfterDiscount ?? "",
      );
      setProceedLoader(false);

      return resp;
    } else {
      setProceedLoader(false);

      return BookingSaveResponseModel(
        message: "Something went wrong",
        status: false,
      );
    }
  }

  Future<BookingSaveResponseModel> psychologyInstantBookingSave({
    required PsychologyInstantBookingData sd,
    required BillResponseModel bill,
    required int tempBookingID,
    required String currentOrderID,
  }) async {
    saveBookingCalled = true;
    setProceedLoader(true);

    String endpoint = Endpoints.psychologyInstantBookingSave;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "temperory_booking_id": tempBookingID,
      "payment_order_id": currentOrderID == "" ? null : currentOrderID,
      "consultation_amount": double.tryParse(bill.fee ?? '0'),
      "platform_fee": double.tryParse(bill.platformFee ?? '0'),
      "tax": double.tryParse(bill.tax ?? '0'),
      "doctor_id": sd.doctorId,
      "subcategory_id": null,
      "gender": null,
      "consultation_category": null,
      "subspeciality_id": sd.subSpecialityId,
      "psychology_type": sd.psychologyType,
      "senior_citizen_free_consultation": sd.seniorCitizenFreeConsultation,
      "package_details": {
        "package_id": sd.packageDetails?.packageId,
        "package_members": sd.packageDetails?.packageMembers,
      },
      "paid_amount": double.tryParse(bill.amountAfterDiscount ?? '0'),
      "coupon_id": bill.couponIdIfApplied,
      "patient_id": sd.patientId,
      "consultation_for": sd.consultationFor,
      "speciality_id": sd.specialityId,
    };
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log("response of psychologyInstantBookingSave $responseData");
    if (responseData != null) {
      var resp = BookingSaveResponseModel.fromJson(responseData);
      resp.paymentDetails ??= {}; // Initialize if null
      resp.paymentDetails["id"] = currentOrderID;
      resp.paymentDetails["amount"] = double.tryParse(
        bill.amountAfterDiscount ?? "",
      );
      setProceedLoader(false);

      return resp;
    } else {
      setProceedLoader(false);

      return BookingSaveResponseModel(
        message: "Something went wrong",
        status: false,
      );
    }
  }

  getDoctorList({
    required int specialityId,
    int? symptomId,
    String? latitude,
    String? longitude,
    int? subSpecialityId,
    // required int tempBookingID
  }) async {
    double? lat = latitude == null ? null : double.tryParse(latitude);
    double? long = longitude == null ? null : double.tryParse(longitude);
    await Future.delayed(const Duration(milliseconds: 50));
    setListLoader(true);

    String endpoint = Endpoints.doctorsList;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {
      "speciality": (specialityId == -1 || specialityId == 0)
          ? null
          : specialityId,
      "symptom_id": symptomId,
      "latitude": lat,
      "longitude": long,
      "subspeciality_id": subSpecialityId,
    };
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      var resp = DoctorListModel.fromJson(responseData);
      setListLoader(false);

      doctorsList = resp;
    } else {
      setListLoader(false);

      return DoctorListModel(message: "Something went wrong", status: false);
    }
    notifyListeners();
  }

  getDocProfile({
    required int docId,
    // required int tempBookingID
  }) async {
    await Future.delayed(const Duration(milliseconds: 50));
    setProfileLoader(true);

    String endpoint = Endpoints.doctorProfile;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {"doctor": docId};
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      var resp = DocDetailsModel.fromJson(responseData['doctors']);
      setProfileLoader(false);

      docProfile = resp;
    } else {
      docProfile = DocDetailsModel();
      setProfileLoader(false);

      // return DoctorListModel(message: "Something went wrong",status: false);
    }
    notifyListeners();
  }

  getAppoinmentDetails({
    required int appoinmentId,
    // required int tempBookingID
  }) async {
    await Future.delayed(const Duration(milliseconds: 50));
    setProfileLoader(true);

    String endpoint = Endpoints.appointmentDetails;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {"booking_id": appoinmentId};
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      var resp = SingleAppoinmentModel.fromJson(responseData);
      setProfileLoader(false);

      appointmentModel = resp;
    } else {
      setProfileLoader(false);

      return DoctorListModel(message: "Something went wrong", status: false);
    }
    notifyListeners();
  }

  Future<BasicResponseModel> cancelBooking({required int bookingId}) async {
    await Future.delayed(const Duration(milliseconds: 50));
    setProfileLoader(true);

    String endpoint = Endpoints.cancelBooking;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {"booking_id": bookingId};
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    setProfileLoader(false);
    notifyListeners();
    if (responseData != null) {
      return BasicResponseModel.fromJson(responseData);
    } else {
      return BasicResponseModel(message: "Something went wrong", status: false);
    }
  }

  disposeBillScreen() {
    selectedCoupon = null;
    billModel = null;
  }

  // Future<String> initiatePayment(dynamic sdkPayoad) async {
  //   isPaymentOnProcess = true;
  //   paymentMessage = "";
  //   notifyListeners();
  //   return await PaymentService.instance.hyperSDK.openPaymentPage(
  //       sdkPayoad, PaymentService.instance.hyperSDKCallbackHandler);
  // }
}
