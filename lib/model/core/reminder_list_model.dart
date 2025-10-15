class RemindersListModel {
  bool? status;
  String? message;
  List<ReminderItem>? activeReminders;
  List<ReminderItem>? pastReminders;

  RemindersListModel(
      {this.status, this.message, this.activeReminders, this.pastReminders});

  RemindersListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['active_reminders'] != null) {
      activeReminders = <ReminderItem>[];
      json['active_reminders'].forEach((v) {
        activeReminders!.add(ReminderItem.fromJson(v));
      });
    }
    if (json['past_reminders'] != null) {
      pastReminders = <ReminderItem>[];
      json['past_reminders'].forEach((v) {
        pastReminders!.add(ReminderItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (activeReminders != null) {
      data['active_reminders'] =
          activeReminders!.map((v) => v.toJson()).toList();
    }
    if (pastReminders != null) {
      data['past_reminders'] = pastReminders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReminderItem {
  int? id;
  int? prescriptionDrug;
  String? image;
  String? title;
  String? reminderType;
  String? medicineIntervalType;
  int? duration;
  String? status;
  List<DosageTime>? dosageTime;
  int? interval;

  ReminderItem(
      {this.id,
      this.prescriptionDrug,
      this.image,
      this.title,
      this.reminderType,
      this.medicineIntervalType,
      this.duration,
      this.status,
      this.dosageTime,
      this.interval});

  ReminderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prescriptionDrug = json['prescription_drug'];
    image = json['image'];
    title = json['title'];
    reminderType = json['reminder_type'];
    medicineIntervalType = json['medicine_interval_type'];
    duration = json['duration'];
    status = json['status'];
    if (json['dosage_time'] != null) {
      dosageTime = <DosageTime>[];
      json['dosage_time'].forEach((v) {
        dosageTime!.add(DosageTime.fromJson(v));
      });
    }
    interval = json['interval'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['prescription_drug'] = prescriptionDrug;
    data['image'] = image;
    data['title'] = title;
    data['reminder_type'] = reminderType;
    data['medicine_interval_type'] = medicineIntervalType;
    data['duration'] = duration;
    data['status'] = status;
    if (dosageTime != null) {
      data['dosage_time'] = dosageTime!.map((v) => v.toJson()).toList();
    }
    data['interval'] = interval;
    return data;
  }
}

class DosageTime {
  int? id;
  double? dosage;
  String? time;

  DosageTime({this.id, this.dosage, this.time});

  DosageTime.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dosage = json['dosage'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dosage'] = dosage;
    data['time'] = time;
    return data;
  }
}
