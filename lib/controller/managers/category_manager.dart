import 'package:dqapp/model/core/online_cat_response_model.dart';
import 'package:dqapp/model/core/specialities_response_model.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/helper/service_locator.dart';
import '../services/api_endpoints.dart';
import '../services/dio_service.dart';

class CategoryMgr extends ChangeNotifier {
  OnlineCategoriesModel? onlineCats;
  bool onlineCatLoader = false;
  List<SpecialityList>? specialityViewAllModel;
  List<SpecialityList>? specialityViewList;

  setViewAllScreenitems(val) {
    specialityViewAllModel = val;
    specialityViewList = val;
  }

  searchSpeciality(val) {
    if (val == null || val == "") specialityViewList = specialityViewAllModel;
    specialityViewList = specialityViewAllModel
        ?.where((e) => e.title!.toLowerCase().contains(val.toLowerCase()))
        .toList();
    notifyListeners();
  }

  getCategories() async {
    if (onlineCats == null) {
      onlineCatLoader = true;
    }
    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.onlineCatList;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);
    if (responseData != null) {
      var result = OnlineCategoriesModel.fromJson(responseData);
      onlineCats = result;
    }
    onlineCatLoader = false;
    notifyListeners();
  }
}
