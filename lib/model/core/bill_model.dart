class BillResponseModel {
  String? fee;
  String? tax;
  String? discount;
  String? amountAfterDiscount;
  String? packageAmt;
  String? platformFee;
  String? pkgAmount;
  String? couponDiscountValue;
  int? couponIdIfApplied;
  bool? status;
  String? message;

  BillResponseModel(
      {this.fee,
      this.tax,
      this.discount,
      this.couponIdIfApplied,
      this.couponDiscountValue,
      this.packageAmt,
      this.platformFee,
      this.amountAfterDiscount,
      this.pkgAmount,
      this.status,
      this.message});

  BillResponseModel.fromJson(Map<String, dynamic> json) {
    fee = json['fee'].toString();
    tax = json['tax'].toString();
    platformFee = json['platform_fee']?.toString();
    discount = json['discount']?.toString();
    amountAfterDiscount = json['amount_after_discount']?.toString();
    status = json['status'];
    message = json['message'];
    couponIdIfApplied = json['coupon_id'];
    couponDiscountValue = json['coupon_discount_value']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fee'] = fee;
    data['tax'] = tax;
    data['platform_fee'] = platformFee;
    data['discount'] = discount;
    data['amount_after_discount'] = amountAfterDiscount;
    data['status'] = status;
    data['coupon_id'] = couponIdIfApplied;
    return data;
  }
}
