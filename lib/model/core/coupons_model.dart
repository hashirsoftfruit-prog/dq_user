class CouponsModel {
  bool? status;
  List<Coupons>? coupons;

  CouponsModel({this.status, this.coupons});

  CouponsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['coupons'] != null) {
      coupons = <Coupons>[];
      json['coupons'].forEach((v) {
        coupons!.add(Coupons.fromJson(v));
      });
    } else {
      coupons = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (coupons != null) {
      data['coupons'] = coupons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coupons {
  int? id;
  String? image;
  String? couponCode;
  String? title;
  String? subtitle;
  String? description;
  bool? applicable;

  Coupons(
      {this.id,
      this.image,
      this.couponCode,
      this.title,
      this.subtitle,
      this.description,
      this.applicable});

  Coupons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    couponCode = json['coupon_code'];
    title = json['title'];
    subtitle = json['subtitle'];
    description = json['description'];
    applicable = json['applicable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['coupon_code'] = couponCode;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['description'] = description;
    data['applicable'] = applicable;
    return data;
  }
}
