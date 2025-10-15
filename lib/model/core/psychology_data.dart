import 'package:dqapp/model/core/therapy_councelling_list_model.dart';

class PsychologyData {
  bool? status;
  String? message;
  List<Emotions>? emotions;
  List<SleepQuality>? sleepQuality;
  List<TherapyOrCouncellingItem>? dashboardTherapy;

  PsychologyData({
    this.status,
    this.message,
    this.emotions,
    this.sleepQuality,
    this.dashboardTherapy,
  });

  PsychologyData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['emotions'] != null) {
      emotions = <Emotions>[];
      json['emotions'].forEach((v) {
        emotions!.add(Emotions.fromJson(v));
      });
    }
    if (json['sleep_quality'] != null) {
      sleepQuality = <SleepQuality>[];
      json['sleep_quality'].forEach((v) {
        sleepQuality!.add(SleepQuality.fromJson(v));
      });
    }
    if (json['dashboard_therapy'] != null) {
      dashboardTherapy = <TherapyOrCouncellingItem>[];
      json['dashboard_therapy'].forEach((v) {
        dashboardTherapy!.add(TherapyOrCouncellingItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (emotions != null) {
      data['emotions'] = emotions!.map((v) => v.toJson()).toList();
    }
    if (sleepQuality != null) {
      data['sleep_quality'] = sleepQuality!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Emotions {
  String? title;
  int? code;

  Emotions({this.title, this.code});

  Emotions.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['code'] = code;
    return data;
  }
}

class SleepQuality {
  int? id;
  String? title;
  int? fromTime;
  int? toTime;

  SleepQuality({this.id, this.title, this.fromTime, this.toTime});

  SleepQuality.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['from_time'] = fromTime;
    data['to_time'] = toTime;
    return data;
  }
}
