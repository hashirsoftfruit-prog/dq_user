class DailyWellnessDataModel {
  bool? status;
  String? message;
  DailySleepQuality? dailySleepQuality;
  DailyEmotion? dailyEmotion;
  int? selectedSleepQualityId;
  int? selectedEmotionCode;

  DailyWellnessDataModel(
      {this.status, this.message, this.dailySleepQuality, this.dailyEmotion});

  DailyWellnessDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    dailySleepQuality = json['daily_sleep_quality'] != null
        ? DailySleepQuality.fromJson(json['daily_sleep_quality'])
        : null;
    dailyEmotion = json['daily_emotion'] != null
        ? DailyEmotion.fromJson(json['daily_emotion'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (dailySleepQuality != null) {
      data['daily_sleep_quality'] = dailySleepQuality!.toJson();
    }
    if (dailyEmotion != null) {
      data['daily_emotion'] = dailyEmotion!.toJson();
    }
    return data;
  }
}

class DailySleepQuality {
  // int? id;
  // String? date;
  // int? appUserId;
  int? sleepQualityId;
  // String? sleepQuality;

  DailySleepQuality({
    // this.id,
    // this.date,
    // this.appUserId,
    this.sleepQualityId,
    // this.sleepQuality
  });

  DailySleepQuality.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    // date = json['date'];
    // appUserId = json['app_user_id'];
    sleepQualityId = json['sleep_quality_id'];
    // sleepQuality = json['sleep_quality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['id'] = this.id;
    // data['date'] = this.date;
    // data['app_user_id'] = this.appUserId;
    data['sleep_quality_id'] = sleepQualityId;
    // data['sleep_quality'] = this.sleepQuality;
    return data;
  }
}

class DailyEmotion {
  // int? id;
  // String? date;
  // int? appUserId;
  // String? emotion;
  int? code;

  DailyEmotion(
      {
      // this.id, this.date, this.appUserId, this.emotion,
      this.code});

  DailyEmotion.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    // date = json['date'];
    // appUserId = json['app_user_id'];
    // emotion = json['emotion'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['id'] = this.id;
    // data['date'] = this.date;
    // data['app_user_id'] = this.appUserId;
    // data['emotion'] = this.emotion;
    data['code'] = code;
    return data;
  }
}
