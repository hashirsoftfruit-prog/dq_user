class AppliedCouponResponseModel {
  String? fee;
  int? couponId;
  String? tax;
  String? discount;
  String? couponDiscountValue;
  String? amountAfterDiscount;
  bool? status;
  String? message;

  AppliedCouponResponseModel(
      {this.fee,
      this.tax,
      this.discount,
      this.couponId,
      this.amountAfterDiscount,
      this.message,
      this.couponDiscountValue,
      this.status});

  AppliedCouponResponseModel.fromJson(Map<String, dynamic> json) {
    couponId = json['coupon_id'];
    fee = json['fee'].toString();
    tax = json['tax'].toString();
    discount = json['discount'].toString();
    couponDiscountValue = json['coupon_discount_value'].toString();
    amountAfterDiscount = json['amount_after_discount'].toString();
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coupon_id'] = couponId;
    data['fee'] = fee;
    data['tax'] = tax;
    data['message'] = message;
    data['discount'] = discount;
    data['amount_after_discount'] = amountAfterDiscount;
    data['coupon_discount_value'] = couponDiscountValue;
    data['status'] = status;
    return data;
  }
}
