class AddReminderModel {
  int? prescriptionDrugId;
  String? reminderType;
  bool? isDailyMedication;
  String? title;
  String? startTime;
  int? dayDuration;
  String? endTime;
  int? interval;
  String? intervalStartDate;
  String? reminderStartingDate;
  List<TimeAndDoses>? timeAndDoses;

  AddReminderModel({
    this.timeAndDoses,
    reminderStartingDate,
    this.reminderType,
    this.intervalStartDate,
    this.isDailyMedication,
    this.interval,
    this.dayDuration,
    this.prescriptionDrugId,
    this.title,
    this.startTime,
    this.endTime,
  });

  AddReminderModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    prescriptionDrugId = json['prescription_drug_id'];

    if (json['time_and_doses'] != null) {
      timeAndDoses = <TimeAndDoses>[];
      json['time_and_doses'].forEach((v) {
        timeAndDoses!.add(TimeAndDoses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (timeAndDoses != null) {
      data['time_and_doses'] = timeAndDoses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeAndDoses {
  double scrollValue = 0;
  String? time;
  double? dose;

  TimeAndDoses({required this.scrollValue, this.time, this.dose});

  TimeAndDoses.fromJson(Map<String, dynamic> json) {
    scrollValue = json['scroll_value'];
    time = json['time'];
    dose = json['dose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scroll_value'] = scrollValue;
    data['time'] = time;
    data['dose'] = dose;
    return data;
  }
}
