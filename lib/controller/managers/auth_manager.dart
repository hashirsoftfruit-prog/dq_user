import 'dart:developer';
import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dqapp/controller/managers/state_manager.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/core/basic_response_model.dart';
import '../../model/core/getotp_response_model.dart';
import '../../model/helper/service_locator.dart';
import '../services/api_endpoints.dart';
import '../services/dio_service.dart';
import 'dart:io';

class AuthManager extends ChangeNotifier {
  int loadedWidget = 0; //Index of login screen widget
  String selectedGender = ""; //Selected Gender in registration screen
  String selectedLang = ""; //Selected language in registration screen
  String countryCode = "+91"; //selected countrycode in login screeen
  GetOtpModel? getOtpModel; //
  int? otp = 1234;
  String? tempOtp = "";
  List<String>? phNo;

  // registration with phone number, first name,last name and date of birth, language and gender.all fields are mandatory

  Future<BasicResponseModel> registration({
    required List<String> phoneNo,
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String gender,
    required String lang,
  }) async {
    String endpoint = Endpoints.registrataion;
    Map<String, dynamic> data = {
      "country_code": phoneNo[0],
      "phone": phoneNo[1],
      "first_name": firstName,
      "last_name": lastName,
      "date_of_birth": dateOfBirth,
      "gender": gender,
      "language": lang,
    };
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, null);
    if (responseData != null) {
      var result = BasicResponseModel.fromJson(responseData);
      return result;
    } else {
      return BasicResponseModel(status: false, message: "Server error");
    }
  }

  // initiates SMS OTP to user's given phone no
  Future<GetOtpModel> sendOtp(String phNO) async {
    String endpoint = Endpoints.otpGeneration;
    Map<String, dynamic> data = {"phone": phNO, "country_code": countryCode};
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, null);
    if (responseData != null) {
      var result = GetOtpModel.fromJson(responseData);
      return result;
    } else {
      return GetOtpModel(status: false, message: "Something went wrong");
    }
  }

  // verifies otp
  Future<GetOtpModel> verifyOtp(String phNO, String otp) async {
    String endpoint = Endpoints.otpVerification;
    Map<String, dynamic> data = {
      "phone": phNO,
      "country_code": countryCode,
      "otp": int.tryParse(otp) ?? '',
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, null);
    if (responseData != null) {
      log(responseData.toString());
      var result = GetOtpModel.fromJson(responseData);
      getIt<StateManager>().changeLocale(
        result.language == "English" ? "en" : "ml",
      );
      return result;
    } else {
      return GetOtpModel(status: false, message: "Something went wrong");
    }
  }

  // clears all data in login screen while leaving the screen
  disposeLogin() {
    loadedWidget = 0;
    phNo = null;

    // notifyListeners();
  }

  // clears all data in registration screen while leaving the screen
  disposeRegistration() {
    selectedGender = "";
    selectedLang = "";
    // notifyListeners();
  }

  changeWidget(int val) {
    loadedWidget = val;
    notifyListeners();
  }

  setPhoneNo(List<String> val) {
    phNo = val;
    notifyListeners();
  }

  saveOtpModel(GetOtpModel val) {
    getOtpModel = val;
    notifyListeners();
  }

  setOTP(int? val) {
    otp = val;
    notifyListeners();
  }

  setUserInputOTP(String? val) {
    tempOtp = val;
    notifyListeners();
  }

  updateGender(String val) {
    selectedGender = val;
    notifyListeners();
  }

  updateLanguage(String val) {
    // print("btmNavIndex changd to $val");
    selectedLang = val;
    notifyListeners();
  }

  changeCountryCode(String val) {
    // print("btmNavIndex changd to $val");
    countryCode = val;
    notifyListeners();
  }

  saveToken(String val) {
    getIt<SharedPreferences>().setString(StringConstants.token, val);
  }

  saveUserName(String val) {
    getIt<SharedPreferences>().setString(StringConstants.userName, val);
  }

  saveUserId(int? val) {
    getIt<SharedPreferences>().setInt(StringConstants.userId, val ?? 0);
  }

  savePatientId(int? val) {
    getIt<SharedPreferences>().setInt(StringConstants.patientId, val ?? 0);
  }

  // Check if the phone number is valid
  bool isValidIndianPhoneNumber(String phoneNumber) {
    final RegExp regex = RegExp(r'^[6-9]\d{9}$');

    return regex.hasMatch(phoneNumber);
  }

  Future<BasicResponseModel?> saveFcmApi() async {
    try {
      String endpoint = Endpoints.saveFcm;
      var fcmTokn = await getfcmToken();
      var deviceTkn = await getDeviceIdentifier();

      Map<String, dynamic> data = {
        "fcm": fcmTokn,
        "device_id": deviceTkn,
        "type": Platform.isAndroid
            ? "android"
            : Platform.isIOS
            ? "ios"
            : "web",
      };
      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

      dynamic responseData = await getIt<DioClient>().post(
        endpoint,
        data,
        tokn,
      );
      if (responseData != null) {
        var result = BasicResponseModel.fromJson(responseData);
        return result;
      } else {
        return BasicResponseModel(status: false, message: "Server error");
      }
    } catch (e, s) {
      log("error on saving fcm $e , $s");
      ;
    }
    return null;
  }

  Future<String?> getfcmToken() async {
    FirebaseMessaging messaging;

    String? token;

    messaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      await messaging.getAPNSToken();
    }
    token = await messaging.getToken();

    log(token!);

    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString("fcm_id", value);
    return token;
  }

  Future<String> getDeviceIdentifier() async {
    String deviceIdentifier = "unknown";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceIdentifier = androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceIdentifier = iosInfo.identifierForVendor!;
    }
    return deviceIdentifier;
  }
}
