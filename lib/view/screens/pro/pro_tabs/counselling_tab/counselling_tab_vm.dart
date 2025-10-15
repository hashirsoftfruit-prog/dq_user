// import 'package:flutter/material.dart';

// class CounsellingTabVm extends ChangeNotifier {
//   Future<DailyWellnessDataModel> updateSleepQualityOrEmotions({
//     required int? sleepQualityValue,
//     required int? emotionValue,
//     required int? previousSleepQualityValue,
//     required int? previousEmotionValue,
//   }) async {
//     // listLoader = true;
//     if (emotionValue != null) {
//       dailyWellnessDataModel?.selectedEmotionCode = emotionValue;
//     } else {
//       dailyWellnessDataModel?.selectedSleepQualityId = sleepQualityValue;
//     }
//     // await Future.delayed(Duration(milliseconds: 50));
//     notifyListeners();
//     String endpoint = Endpoints.dailyWellnessUpdate;
//     String token = getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

//     Map<String, dynamic> data = {"sleep_quality_id": sleepQualityValue, "emotion_code": emotionValue};

//     dynamic responseData = await getIt<DioClient>().post(endpoint, data, token);

//     if (responseData != null) {
//       var res = DailyWellnessDataModel.fromJson(responseData);

//       if (emotionValue != null) {
//         dailyWellnessDataModel?.dailyEmotion = res.dailyEmotion;
//       } else {
//         dailyWellnessDataModel?.dailySleepQuality = res.dailySleepQuality;
//       }
//       notifyListeners();

//       return res;
//     } else {
//       return DailyWellnessDataModel(status: false, message: "Something went wrong");
//     }

//     // listLoader = false;
//   }

// }
