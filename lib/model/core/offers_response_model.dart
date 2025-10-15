class OffersModel {
  bool? status;
  String? message;
  List<CouponList>? couponList;
  List<DiscountList>? discountList;

  OffersModel({this.status, this.message, this.couponList, this.discountList});

  OffersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['coupon_list'] != null) {
      couponList = <CouponList>[];
      json['coupon_list'].forEach((v) {
        couponList!.add(CouponList.fromJson(v));
      });
    }
    if (json['discount_list'] != null) {
      discountList = <DiscountList>[];
      json['discount_list'].forEach((v) {
        discountList!.add(DiscountList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (couponList != null) {
      data['coupon_list'] = couponList!.map((v) => v.toJson()).toList();
    }
    if (discountList != null) {
      data['discount_list'] = discountList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CouponList {
  int? id;
  String? image;
  String? couponCode;
  String? title;
  String? subtitle;
  String? description;
  String? startDate;
  String? endDate;
  String? discountValue;
  String? maximumSpend;
  String? discountType;
  String? consultationType;
  bool? isApplicableToAll;

  CouponList(
      {this.id,
      this.image,
      this.couponCode,
      this.title,
      this.subtitle,
      this.description,
      this.startDate,
      this.endDate,
      this.discountValue,
      this.maximumSpend,
      this.discountType,
      this.consultationType,
      this.isApplicableToAll});

  CouponList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    couponCode = json['coupon_code'];
    title = json['title'];
    subtitle = json['subtitle'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    discountValue = json['discount_value']?.toString();
    maximumSpend = json['maximum_spend']?.toString();
    discountType = json['discount_type'];
    consultationType = json['consultation_type'];
    isApplicableToAll = json['is_applicable_to_all'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['coupon_code'] = couponCode;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['description'] = description;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['discount_value'] = discountValue;
    data['maximum_spend'] = maximumSpend;
    data['discount_type'] = discountType;
    data['consultation_type'] = consultationType;
    data['is_applicable_to_all'] = isApplicableToAll;
    return data;
  }
}

class DiscountList {
  int? id;
  String? image;
  String? title;
  String? subtitle;
  String? description;
  String? startDate;
  String? endDate;
  String? discountValue;
  String? maximumSpend;
  String? discountType;
  String? consultationType;

  DiscountList(
      {this.id,
      this.image,
      this.title,
      this.subtitle,
      this.description,
      this.startDate,
      this.endDate,
      this.discountValue,
      this.maximumSpend,
      this.discountType,
      this.consultationType});

  DiscountList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    title = json['title'];
    subtitle = json['subtitle'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    discountValue = json['discount_value']?.toString();
    maximumSpend = json['maximum_spend']?.toString();
    discountType = json['discount_type'];
    consultationType = json['consultation_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['description'] = description;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['discount_value'] = discountValue;
    data['maximum_spend'] = maximumSpend;
    data['discount_type'] = discountType;
    data['consultation_type'] = consultationType;
    return data;
  }
}
