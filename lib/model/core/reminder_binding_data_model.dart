class ReminderBindingDataModel {
  bool? status;
  String? message;
  List<String>? reminderType;
  List<String>? medicineIntervalType;
  List<String>? intervalTypes;
  String? startTime;
  String? endTime;
  String? reminderStartDate;
  List<DrugSerializer>? drugSerializer;

  ReminderBindingDataModel(
      {this.status,
      this.message,
      this.reminderType,
      this.medicineIntervalType,
      this.intervalTypes,
      this.startTime,
      this.endTime,
      this.reminderStartDate,
      this.drugSerializer});

  ReminderBindingDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    reminderType = json['reminder_type'].cast<String>();
    medicineIntervalType = json['medicine_interval_type'].cast<String>();
    intervalTypes = json['interval_types'].cast<String>();
    startTime = json['start_time'];
    endTime = json['end_time'];
    reminderStartDate = json['reminder_start_date'];
    if (json['drug_serializer'] != null) {
      drugSerializer = <DrugSerializer>[];
      json['drug_serializer'].forEach((v) {
        drugSerializer!.add(DrugSerializer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['reminder_type'] = reminderType;
    data['medicine_interval_type'] = medicineIntervalType;
    data['interval_types'] = intervalTypes;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['reminder_start_date'] = reminderStartDate;
    if (drugSerializer != null) {
      data['drug_serializer'] = drugSerializer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DrugSerializer {
  int? id;
  int? drug;
  String? drugType;
  String? drugUnit;
  bool? dailyMedication;
  int? interval;
  int? duration;
  String? medicineInstruction;
  String? drugName;
  List<DosageList>? dosageList;

  DrugSerializer(
      {this.id,
      this.drug,
      this.drugType,
      this.drugUnit,
      this.dailyMedication,
      this.interval,
      this.duration,
      this.medicineInstruction,
      this.drugName,
      this.dosageList});

  DrugSerializer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    drug = json['drug'];
    drugType = json['drug_type'];
    drugUnit = json['drug_unit'];
    dailyMedication = json['daily_medication'];
    interval = json['interval'];
    duration = json['duration'];
    medicineInstruction = json['medicine_instruction'];
    drugName = json['drug_name'];
    if (json['dosage_list'] != null) {
      dosageList = <DosageList>[];
      json['dosage_list'].forEach((v) {
        dosageList!.add(DosageList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['drug'] = drug;
    data['drug_type'] = drugType;
    data['drug_unit'] = drugUnit;
    data['daily_medication'] = dailyMedication;
    data['interval'] = interval;
    data['duration'] = duration;
    data['medicine_instruction'] = medicineInstruction;
    data['drug_name'] = drugName;
    if (dosageList != null) {
      data['dosage_list'] = dosageList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DosageList {
  String? time;
  double? dosage;

  DosageList({this.time, this.dosage});

  DosageList.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    dosage = double.tryParse(json['dosage'].toString()) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['dosage'] = dosage;
    return data;
  }
}
