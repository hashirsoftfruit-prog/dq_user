class PackagesListModel {
  bool? status;
  String? message;
  List<Packages>? packages;

  PackagesListModel({this.status, this.packages, this.message});

  PackagesListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    if (json['packages'] != null) {
      packages = <Packages>[];
      json['packages'].forEach((v) {
        packages!.add(Packages.fromJson(v));
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

class Packages {
  int? id;
  String? title;
  String? subtitle;
  String? description;
  String? amount;
  int? noOfDays;
  int? noOfConsultation;
  String? cuttingAmount;
  String? image;
  double? tax;

  Packages({
    this.id,
    this.title,
    this.subtitle,
    this.noOfDays,
    this.noOfConsultation,
    this.description,
    this.amount,
    this.image,
    this.cuttingAmount,
    this.tax,
  });

  Packages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    image = json['image'];
    noOfDays = json['no_of_days'];
    noOfConsultation = json['no_of_consultation'];
    description = json['description'];
    tax = json['tax'];
    amount = json['amount'].toString();
    cuttingAmount = json['discount_price']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['description'] = description;
    data['amount'] = amount;
    data['tax'] = tax;
    data['discount_price'] = cuttingAmount;
    return data;
  }
}

class SelectedPackageModel {
  String? packagename;
  String? amount;
  double? tax;
  SelectedPackageDetails? packageDetails;

  SelectedPackageModel({
    this.packagename,
    this.packageDetails,
    this.amount,
    this.tax,
  });

  SelectedPackageModel.fromJson(Map<String, dynamic> json) {
    packagename = json['packagename'];
    amount = json['amount'];
    tax = json['taxs'];
    packageDetails = json['package_details'] != null
        ? SelectedPackageDetails.fromJson(json['package_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['packagename'] = packagename;
    data['amount'] = amount;
    data['tax'] = tax;
    if (packageDetails != null) {
      data['package_details'] = packageDetails!.toJson();
    }
    return data;
  }
}

class SelectedPackageDetails {
  int? packageId;
  List<int>? packageMembers;

  SelectedPackageDetails({this.packageId, this.packageMembers});

  SelectedPackageDetails.fromJson(Map<String, dynamic> json) {
    packageId = json['package_id'];
    packageMembers = json['package_members'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['package_id'] = packageId;
    data['package_members'] = packageMembers;
    return data;
  }
}
