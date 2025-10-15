import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dqapp/model/helper/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view/theme/constants.dart';
import '../../view/screens/starting_screens/splash_scren.dart';
import '../managers/home_manager.dart';
import 'api_endpoints.dart';

class DioClient {
  // String baseUrl = kDebugMode
  //     ? "http://188.166.190.177:8000/api/"
  //     : '${StringConstants.baseUrl}/api/';

  String baseUrl = '${StringConstants.baseUrl}/api/';

  post(String endpoint, var data, String? token) async {
    String url = "$baseUrl$endpoint";
    if (kDebugMode) {
      print('url: $url');
      print('data: $data');
      print('token: $token');
    }
    var dio = Dio();
    if (kDebugMode) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient(context: SecurityContext());
        // Allow self-signed / proxy certs only in debug builds
        if (kDebugMode) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
        }
        return client;
      };
    } else {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
    }
    try {
      if (token == null) {
        Response response = await dio.post(url, data: data);

        if (response.statusCode == 200) {
          return response.data;
        } else if (response.statusCode == 401) {
          await getIt<HomeManager>().logoutFn(isForceLogout: true);
          Fluttertoast.showToast(msg: "Unauthorized User");
          Navigator.pushAndRemoveUntil(
            getIt<NavigationService>().navigatorkey.currentContext!,
            MaterialPageRoute(builder: (_) => const SplashScreen()),
            (route) => false,
          );
          return null;
        } else {
          return null;
        }
      }
      Response response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Accept-Language':
                getIt<SharedPreferences>().getString(
                  StringConstants.language,
                ) ??
                'en',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 401) {
        await getIt<HomeManager>().logoutFn(isForceLogout: true);
        Fluttertoast.showToast(msg: "Unauthorized User");
        Navigator.pushAndRemoveUntil(
          getIt<NavigationService>().navigatorkey.currentContext!,
          MaterialPageRoute(builder: (_) => const SplashScreen()),
          (route) => false,
        );
      } else {
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        // Access the response's status code
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 && endpoint == Endpoints.appointments) {
          await getIt<HomeManager>().logoutFn(isForceLogout: true);
          Fluttertoast.showToast(msg: "Unauthorized User");
          Navigator.pushAndRemoveUntil(
            getIt<NavigationService>().navigatorkey.currentContext!,
            MaterialPageRoute(builder: (_) => const SplashScreen()),
            (route) => false,
          );
        }
      } else {
        // Handle other exceptions
        // print('Error: $e');
      }
    }
  }

  get(String endpoint, String? token) async {
    String url = "$baseUrl$endpoint";
    if (kDebugMode) {
      print('url: $url');
    }
    var dio = Dio();
    // (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
    //     HttpClient()
    //       ..badCertificateCallback =
    //           (X509Certificate cert, String host, int port) => true;

    if (kDebugMode) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient(context: SecurityContext());
        // Allow self-signed / proxy certs only in debug builds
        if (kDebugMode) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
        }
        return client;
      };
    } else {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
    }

    try {
      if (token == null) {
        Response response = await dio.get(url);

        if (response.statusCode == 200) {
          return response.data;
        } else if (response.statusCode == 401) {
          await getIt<HomeManager>().logoutFn(isForceLogout: true);
          Fluttertoast.showToast(msg: "Unauthorized User");
          Navigator.pushAndRemoveUntil(
            getIt<NavigationService>().navigatorkey.currentContext!,
            MaterialPageRoute(builder: (_) => const SplashScreen()),
            (route) => false,
          );
        } else {
          return null;
        }
      }
      if (token != null) {
        Response response = await dio.get(
          url,
          options: Options(
            headers: {
              'Authorization': 'Token $token',
              'Accept-Language':
                  getIt<SharedPreferences>().getString(
                    StringConstants.language,
                  ) ??
                  'en',
            },
          ),
        );

        if (response.statusCode == 200) {
          return response.data;
        } else {
          return null;
        }
      }
    } catch (e) {
      if (e is DioException) {
        // Access the response's status code
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 && endpoint == Endpoints.appointments) {
          await getIt<HomeManager>().logoutFn(isForceLogout: true);
          Fluttertoast.showToast(msg: "Unauthorized User");
          Navigator.pushAndRemoveUntil(
            getIt<NavigationService>().navigatorkey.currentContext!,
            MaterialPageRoute(builder: (_) => const SplashScreen()),
            (route) => false,
          );
        }
      } else {
        // Handle other exceptions
        // print('Error: $e');
      }
    }
  }

  // Future <List<Map<String,dynamic>>> get(url)async{
  // Future <dynamic> get( String url)async{
  //   var dio = Dio();
  //   try{
  //     Response response = await dio.get(
  //      url,
  //
  //     );
  //     return response.data;
  //   }
  //   catch(e){
  //     print(e);
  //   }
  //
  // }
}

//
//
// import 'package:dio/dio.dart';
// import 'package:finprov/models/core/auth_model.dart';
// import 'package:finprov/models/core/posts_model.dart';
//
//
// class DioClient{
//   final String baseUrl="http://staging.finprov.com/wp-json";
//
//
//   Future<User?> authUser({required String email,required String password}) async{
//     User? retrievedUser;
//
//     try{
//       var dio = Dio();
//       final _baseUrl = baseUrl;
//        Response response = await dio.post(
//         _baseUrl + "/jwt-auth/v1/token/",
//         data: {"username":email ,"password":password},
//       );
//       // data: {"username":"finprov_admin","password":"Finprov_admin@2022"}
//       print(response.data);
//
//       Map<String,dynamic> jsonData = response.data;//jsonDecode(response.data);
//
//       retrievedUser = User.fromJson(jsonData);
//
//       return retrievedUser;
//       // if(retrievedUser!=null) {
//       //
//       //
//       //   print('User created: ${response.data}');
//       // }
//
//
//     }
//     catch(e){
//       print('Error creating user: $e');
//     }
//   }
//
//
//   registerUser({required String email,required String username,required String password})async{
//
//     try{
//       var dio = Dio();
//       final _baseUrl = baseUrl;
//       String token ="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9zdGFnaW5nLmZpbnByb3YuY29tIiwiaWF0IjoxNjUwNDQzOTgyLCJuYmYiOjE2NTA0NDM5ODIsImV4cCI6MTY1MTA0ODc4MiwiZGF0YSI6eyJ1c2VyIjp7ImlkIjoiMSJ9fX0.vu0-A5AODc6OM6P58H1i25zXLLKlQAXNQtYhRQUXVFw";
//       Response response = await dio.post(
//         _baseUrl + "/wp/v2/users",
//         data: {"username":username ,"password":password,"email":email},
//         options:Options(headers: {'Authorization': 'Bearer $token'})
//       );
//
//       print(response.data);
//
//       Map<String,dynamic> jsonData = response.data;//jsonDecode(response.data);
//
//
//
//
//
//     }
//     catch(e){
//       print('Error creating user: $e');
//     }
//   }
//
//
//
//
//
//
//   Future <List<Posts>?> getPosts() async{
//     try{
//       var dio = Dio();
//       final _baseUrl = baseUrl;
//       Response response = await dio.get(
//         _baseUrl + "/wp/v2/posts?_fields=author,id,excerpt,title,link",
//       );
//
//       List<Posts> record = [];
//       for (var element in response.data) {
//         record.add(Posts.fromJson(element));
//       }
//
//       return record;
//     }
//     catch(e){
//       print('error $e');
//     }
//
//
//   }
//
//
// }
//
