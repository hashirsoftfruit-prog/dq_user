class PurchasedPackagesModel {
  bool? status;
  String? message;
  List<PurchasedPackage>? packages;

  PurchasedPackagesModel({this.status, this.message, this.packages});

  PurchasedPackagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['packages'] != null) {
      packages = <PurchasedPackage>[];
      json['packages'].forEach((v) {
        packages!.add(PurchasedPackage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (packages != null) {
      data['packages'] = packages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PurchasedPackage {
  int? id;
  int? package;
  String? startDate;
  String? endDate;
  double? amount;
  int? totalNoOfConsultation;
  int? remainingNoOfConsultation;
  int? packageId;
  String? packageTitle;
  List<PackageMember>? packageMember;

  PurchasedPackage(
      {this.id,
      this.package,
      this.startDate,
      this.endDate,
      this.packageMember,
      this.amount,
      this.totalNoOfConsultation,
      this.remainingNoOfConsultation,
      this.packageId,
      this.packageTitle});

  PurchasedPackage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    package = json['package'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    amount = double.tryParse(json['amount'].toString());
    totalNoOfConsultation = json['total_no_of_consultation'];
    remainingNoOfConsultation = json['remaining_no_of_consultation'];
    packageId = json['package_id'];
    packageTitle = json['package_title'];
    if (json['package_member'] != null) {
      packageMember = <PackageMember>[];
      json['package_member'].forEach((v) {
        packageMember!.add(PackageMember.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['package'] = package;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['amount'] = amount;
    data['total_no_of_consultation'] = totalNoOfConsultation;
    data['remaining_no_of_consultation'] = remainingNoOfConsultation;
    data['package_id'] = packageId;
    if (packageMember != null) {
      data['package_member'] = packageMember!.map((v) => v.toJson()).toList();
    }
    data['package_title'] = packageTitle;
    return data;
  }
}

class PackageMember {
  int? id;
  int? appUser;
  String? appUserFirstName;
  String? appUserLastName;

  PackageMember(
      {this.id, this.appUser, this.appUserFirstName, this.appUserLastName});

  PackageMember.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appUser = json['app_user'];
    appUserFirstName = json['app_user_first_name'];
    appUserLastName = json['app_user_last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['app_user'] = appUser;
    data['app_user_first_name'] = appUserFirstName;
    data['app_user_last_name'] = appUserLastName;
    return data;
  }
}
