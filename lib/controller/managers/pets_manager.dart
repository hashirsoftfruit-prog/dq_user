import 'package:dqapp/model/core/basic_response_model.dart';
import 'package:dqapp/model/core/pet_boarder_details_model.dart';
import 'package:dqapp/model/core/pet_boarders_list_model.dart';
import 'package:dqapp/model/core/pet_groomer_details_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/core/available_doctors_response_model.dart';
import '../../model/core/booking_validation_models.dart';
import '../../model/core/coupons_model.dart';
import '../../model/core/my_pets_list_model.dart';
import '../../model/core/package_list_response_model.dart';
import '../../model/core/pet_groomers_list_model.dart';
import '../../model/core/pets__types_list_model.dart';
import '../../model/core/booking_request_data_model.dart';
import '../../model/helper/service_locator.dart';
import '../../view/theme/constants.dart';
import '../../view/screens/pet_care_screens/create_pet_screen.dart';
import '../services/api_endpoints.dart';
import '../services/dio_service.dart';

class PetsManager extends ChangeNotifier {
  List<PetList>? petList;
  List<PetGroomer>? petGroomers;
  List<PetBoarder>? petBoarders;
  GroomerDetails? petGroomerDetails;
  BoardingDetails? petBoarderDetails;
  MyPetsListModel? myPetsListModel;
  MyPetModel? selectedPet;
  BookingDataDetailsModel? bookingInfoModel;
  Coupons? selectedCoupon;
  SelectedPackageModel? selectedPkg;
  bool bookingScreenLoader = false;
  bool billLoader = false;
  bool petListLoader = false;

  bool listLoader = false;

  disposeBooking() {
    // couponModel = null;
    // billModel = null;
    // couponAppliedBillModel = null;
    // packageBillModel = null;
    selectedPkg = null;
    selectedCoupon = null;
    bookingScreenLoader = false;
  }

  getPetTypesList() async {
    String endpoint = Endpoints.petsTypesList;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {"type": 2};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      petList = PetTypesListModel.fromJson(responseData).petList ?? [];
      notifyListeners();
    } else {}
  }

  getPetDetails(id) async {
    String endpoint = Endpoints.userPetDetail;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {"user_pet_id": id};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null && responseData["pet_details"] != null) {
      selectedPet = MyPetModel.fromJson(responseData["pet_details"]);
      notifyListeners();
    } else {}
  }

  getInstantPetBookingDetails({required int id}) async {
    bookingScreenLoader = true;
    await Future.delayed(const Duration(milliseconds: 500));
    notifyListeners();
    String endpoint = Endpoints.petCareInstantDoctors;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {"user_pet_id": id};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      bookingInfoModel = BookingDataDetailsModel.fromJson(responseData);
    } else {}

    bookingScreenLoader = false;
    notifyListeners();
  }

  getSchefuledPetBookingInfo({required int id}) async {
    bookingScreenLoader = true;
    await Future.delayed(const Duration(milliseconds: 500));
    notifyListeners();
    String endpoint = Endpoints.scheduledPetBookingDetails;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {"user_pet_id": id};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      bookingInfoModel = BookingDataDetailsModel.fromJson(responseData);
    } else {}

    bookingScreenLoader = false;
    notifyListeners();
  }

  Future<bool?> getMyPetList() async {
    await Future.delayed(const Duration(milliseconds: 200));

    petListLoader = true;
    notifyListeners();
    String endpoint = Endpoints.userPets;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);

    if (responseData != null) {
      myPetsListModel = MyPetsListModel.fromJson(responseData);
      petListLoader = false;
      notifyListeners();
      if (myPetsListModel!.myPetsList != null &&
          myPetsListModel!.myPetsList!.isEmpty) {
        Future.delayed(const Duration(milliseconds: 50));
      }
      return false; //checking the condition for navigating to pet creation screen
    } else {}
    return null;
  }

  myPetListDispose() {
    myPetsListModel = null;
  }

  groomersListDispose() {
    petGroomers = null;
  }

  boardersDispose() {
    petBoarders = null;
  }

  groomerDetailsDispose() {
    petGroomerDetails = null;
  }

  boarderDetailsDispose() {
    petBoarderDetails = null;
  }

  getPetGroomersList() async {
    await Future.delayed(const Duration(milliseconds: 50));
    listLoader = true;
    notifyListeners();

    String endpoint = Endpoints.petGroomersList;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    List<String> latLongList =
        getIt<SharedPreferences>().getStringList(
          StringConstants.currentLatAndLong,
        ) ??
        [];

    double? lat;
    double? long;

    if (latLongList.isNotEmpty) {
      lat = double.parse(latLongList[0]);
      long = double.parse(latLongList[1]);

      Map<String, dynamic> data = {"latitude": lat, "longitude": long};

      dynamic responseData = await getIt<DioClient>().post(
        endpoint,
        data,
        tokn,
      );

      if (responseData != null) {
        petGroomers =
            PetGroomersLIstModel.fromJson(responseData).petGroomers ?? [];
      } else {}
    } else {
      petGroomers = null;
    }
    listLoader = false;

    notifyListeners();
  }

  getPetGroomerDetails(int groomerId) async {
    String endpoint = Endpoints.petGroomersDetails;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {"groomer_id": groomerId};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      petGroomerDetails = PetGroomersDetailsModel.fromJson(
        responseData,
      ).groomerDetails;
      notifyListeners();
    } else {}
  }

  Future<BasicResponseModel> createPet(PetCreateData dt) async {
    String endpoint = Endpoints.petCreate;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "name": dt.name,
      "pet_id": dt.speciesId,
      "breed_id": dt.breedId,
      "gender": dt.gender,
      "date_of_birth": dt.dateOfBirth,
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      var res = BasicResponseModel.fromJson(responseData);
      return res;
    } else {
      return BasicResponseModel(status: false, message: "Something went wrong");
    }
  }

  getPetBoardersList() async {
    await Future.delayed(const Duration(milliseconds: 50));
    listLoader = true;
    notifyListeners();
    String endpoint = Endpoints.petBoardersList;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    List<String> latLongList =
        getIt<SharedPreferences>().getStringList(
          StringConstants.currentLatAndLong,
        ) ??
        [];

    double? lat;
    double? long;

    if (latLongList.isNotEmpty) {
      lat = double.parse(latLongList[0]);
      long = double.parse(latLongList[1]);
    }

    Map<String, dynamic> data = {"latitude": lat, "longitude": long};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      petBoarders =
          PetBoardersListModel.fromJson(responseData).petBoarders ?? [];
    } else {}

    listLoader = false;

    notifyListeners();
  }

  getPetBoarderDetails(int boarderId) async {
    String endpoint = Endpoints.petBoardersDetails;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {"boarding_id": boarderId};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      petBoarderDetails = PetBoarderDetailsModel.fromJson(
        responseData,
      ).boardingDetails;
      notifyListeners();
    } else {}
  }

  Future<BookingValidationResponseData> petInstantBookingValidation(
    BookingDetailsItem item,
  ) async {
    // setProceedLoader(true);
    String endpoint = Endpoints.petInstantBookingValidation;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      //   "consultation_amount":double.tryParse(item.consultationAmount!),
      //   "platform_fee":double.tryParse(item.platformFee!),
      //   "tax":double.tryParse(item.tax!),
      //   "paid_amount":double.parse(item.paidAmount!),
      //   "coupon_id":item.couponId,
      //   "user_pet_id":0,
      //   "speciality_id":item.specialityId,
      //   "subspeciality_id":item.subSpecialityId
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      var resp = BookingValidationResponseData.fromJson(responseData);
      // setProceedLoader(false);

      return resp;
    } else {
      // setProceedLoader(false);

      return BookingValidationResponseData(
        message: "Something went wrong",
        status: false,
      );
    }
  }

  Future<BookingValidationResponseData> petScheduledBookingValidation(
    SaveScheduledBookingModel dt,
  ) async {
    // setProceedLoader(true);
    String endpoint = Endpoints.petScheduledBookingValidation;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "date": dt.date,
      "time": dt.time,
      "booking_type": dt.bookingType,
      "doctor_id": dt.doctorId,
      "speciality_id": dt.specialityId,
      // "paid_amount":double.tryParse(dt.paidAmount??'0'),
      "free_followup_booking": dt.freeFollowupBooking,
      "is_free_followup": dt.isFreeFollowup,
      // "consultation_amount":double.tryParse(dt.consultationAmount??'0'),
      // "platform_fee":double.tryParse(dt.platformFee??'0'),
      // "tax":double.tryParse(dt.tax??'0'),
      // "coupon_id":dt.petId,
      "user_pet_id": dt.petId,
      "subcategory_id": dt.subcategoryId,
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      var resp = BookingValidationResponseData.fromJson(responseData);
      // setProceedLoader(false);

      return resp;
    } else {
      // setProceedLoader(false);

      return BookingValidationResponseData(
        message: "Something went wrong",
        status: false,
      );
    }
  }

  Future<BookingSaveResponseModel> petInstantBookingSave({
    required BookingDetailsItem item,
    required int tempBookingID,
  }) async {
    // setProceedLoader(true);

    String endpoint = Endpoints.petInstantBookingSave;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      // "temperory_booking_id":tempBookingID,
      // "consultation_amount":double.parse(item.consultationAmount!),
      // "platform_fee":double.parse(item.platformFee!),
      // "tax":double.parse(item.tax!),
      // "paid_amount":double.parse(item.paidAmount!),
      // "coupon_id":item.couponId,
      // "user_pet_id":0,
      // "speciality_id":item.specialityId,
      // "subcategory_id":item.subcategoryId,
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    // setProceedLoader(false);

    if (responseData != null) {
      var resp = BookingSaveResponseModel.fromJson(responseData);

      return resp;
    } else {
      // setProceedLoader(false);

      return BookingSaveResponseModel(
        message: "Something went wrong",
        status: false,
      );
    }
  }

  Future<BookingSaveResponseModel> petScheduledBookingSave({
    required SaveScheduledBookingModel sd,
    required int tempBookingID,
  }) async {
    // setProceedLoader(true);

    String endpoint = Endpoints.petScheduledBookingSave;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "temperory_booking_id": tempBookingID,
      "date": sd.date,
      "time": sd.time,
      "booking_type": sd.bookingType,
      "doctor_id": sd.doctorId,
      "speciality_id": sd.specialityId,
      // "paid_amount":double.tryParse(sd.paidAmount??'0'),
      "free_followup_booking": sd.freeFollowupBooking,
      "is_free_followup": sd.isFreeFollowup,
      // "consultation_amount":double.tryParse(sd.consultationAmount??'0'),
      // "platform_fee":double.tryParse(sd.platformFee??'0'),
      // "tax":double.tryParse(sd.tax??'0'),
      // "coupon_id":sd.couponId,
      "user_pet_id": sd.petId,
      "subcategory_id": sd.subcategoryId,
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      var resp = BookingSaveResponseModel.fromJson(responseData);
      // setProceedLoader(false);

      return resp;
    } else {
      // setProceedLoader(false);

      return BookingSaveResponseModel(
        message: "Something went wrong",
        status: false,
      );
    }
  }
}
