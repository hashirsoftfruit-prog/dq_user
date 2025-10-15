import 'package:dio/dio.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/core/popular_cities_model.dart';
import '../../model/core/search_places_response_model.dart';
import '../../model/helper/service_locator.dart';
import '../services/api_endpoints.dart';
import '../services/dio_service.dart';

class LocationManager extends ChangeNotifier {
  List<Items> items = [];
  bool searchLoader = false;
  bool locLoader = false;
  String? selectedLocation;
  List<PopularCities>? popularCitiesList;

  String hereApiKey = StringConstants.hereMapApiKey;

  getPopularCities() async {
    String endpoint = Endpoints.popularCities;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);
    if (responseData != null) {
      var result = PopularCitiesModel.fromJson(responseData);
      if (result.defaultLocation != null &&
          result.popularCities.isNotEmpty &&
          getIt<SharedPreferences>().getString(
                StringConstants.selectedLocation,
              ) ==
              null) {
        var city = result.defaultLocation;
        setSelectedLocation(
          placeName: city!.location ?? "",
          latitude: double.parse(city.latitude!),
          longitude: double.parse(city.longitude!),
        );
      }

      popularCitiesList = result.popularCities;
      notifyListeners();
    }
  }

  changeLoc(val) {
    selectedLocation = val;
    notifyListeners();
  }

  clearSearches() {
    items = [];
  }

  setSelectedLocation({
    required double latitude,
    required double longitude,
    required String placeName,
  }) {
    getIt<SharedPreferences>().setStringList(
      StringConstants.currentLatAndLong,
      [latitude.toString(), longitude.toString()],
    );
    getIt<SharedPreferences>().setString(
      StringConstants.selectedLocation,
      placeName,
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  // Future<Position> determinePosition() async {
  //   print("1");
  //
  //
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     return Future.error('Location services are disabled.');
  //   }
  //   print("1");
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       print("denied");
  //
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     print("denied");
  //
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //
  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   var pos =   await Geolocator.getCurrentPosition();
  //   print("pos.altitude");
  //   return pos;
  // }

  Future<bool?> getLocation() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      try {
        locLoader = true;
        notifyListeners();
        Position position = await getCurrentLocation();
        double latitude = position.latitude;
        double longitude = position.longitude;
        // print('Latitude: $latitude, Longitude: $longitude');
        List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude,
          longitude,
        );

        if (placemarks.isNotEmpty) {
          // var  output = placemarks[0].toString();
          getIt<LocationManager>().setSelectedLocation(
            placeName: placemarks[0].locality ?? "",
            latitude: latitude,
            longitude: longitude,
          );
          getIt<LocationManager>().changeLoc(placemarks[0].locality ?? "");

          // selectedLocation = placemarks[0].locality??"";
          // notifyListeners();
          // getIt<HomeManager>().getNearClinics(lat: latitude, long: longitude, locality: placemarks[0].locality ?? "");
          locLoader = false;
          notifyListeners();
          return true;
        }
      } catch (e) {
        // print('Error: $e');
      }
    } else {
      // Permission Denied
    }
    return null;
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  getLocationByName(String place) async {
    SearchPlacesModel? data;
    items = [];
    searchLoader = true;
    notifyListeners();

    String url =
        "https://discover.search.hereapi.com/v1/discover?at=10.850516,76.271080&limit=5&q=$place&apiKey=$hereApiKey";
    var dio = Dio();
    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      data = SearchPlacesModel.fromJson(response.data);

      notifyListeners();
    }
    items = data?.items ?? [];

    searchLoader = false;
  }

  Future<Items?> getAddressByLatLong({
    required double lat,
    required double long,
  }) async {
    SearchPlacesModel? data;
    items = [];
    notifyListeners();
    String url =
        "https://discover.search.hereapi.com/v1/revgeocode?at=$lat,$long&limit=5&apiKey=$hereApiKey";
    var dio = Dio();
    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      data = SearchPlacesModel.fromJson(response.data);
    }
    if (data?.items != null && data!.items!.isNotEmpty) {
      return data.items!.first;
    }
    return null;
  }
}
