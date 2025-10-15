import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/core/search_results_model.dart';
import '../../model/helper/service_locator.dart';
import '../../view/theme/constants.dart';
import '../services/api_endpoints.dart';
import '../services/dio_service.dart';

class SearchManager extends ChangeNotifier {
  SearchResultsModel? searchResultsModel;
  List<String> searchSuggestions = [];

  disposeSearch() {
    searchResultsModel = null;
    searchSuggestions = [];
  }

  searchApi({required String searchKey, required int consultType}) async {
    List<String>? latLongList = consultType == 1
        ? getIt<SharedPreferences>()
            .getStringList(StringConstants.currentLatAndLong)
        : null;

    String endpoint = Endpoints.generalSearch;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    final data = {
      "search_keyword": searchKey,
      "type": consultType,
      "latitude": latLongList != null ? latLongList[0] : null,
      "longitude": latLongList != null ? latLongList[1] : null,
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      // searchResultsModel =
      var res = SearchResultsModel.fromJson(responseData);
      if (res.status == true) {
        searchResultsModel = res;
      } else {
        searchResultsModel = null;
      }
      notifyListeners();
      // return resp;
    } else {
      // return BasicResponseModel(status:true,message: "Failed");
      // return SymptomsAndIssuesModel(status: false);
    }
  }

  clearRecentSearches() {
    getIt<SharedPreferences>().remove(StringConstants.searchSuggestions);
    searchSuggestions = [];
    notifyListeners();
  }

  refreshRecentSearches(String? searchKey) async {
    await Future.delayed(const Duration(milliseconds: 50));
    List<String> lst = getIt<SharedPreferences>()
            .getStringList(StringConstants.searchSuggestions) ??
        [];

    if (searchKey != null && !lst.contains(searchKey)) {
      lst.add(searchKey);
      getIt<SharedPreferences>()
          .setStringList(StringConstants.searchSuggestions, lst);
    }

    searchSuggestions = lst;
    notifyListeners();
  }
}
