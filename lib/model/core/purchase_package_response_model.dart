class PackagePurchaseResponseModel {
  bool? status;
  String? message;
  int? temperoryUserPackageId;
  String? orderId;
  dynamic sdkPayload;

  PackagePurchaseResponseModel({
    this.status,
    this.message,
    this.temperoryUserPackageId,
    this.orderId,
    this.sdkPayload,
  });

  // From JSON
  factory PackagePurchaseResponseModel.fromJson(Map<String, dynamic> json) {
    return PackagePurchaseResponseModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      temperoryUserPackageId: json['temperory_user_package_id'] as int?,
      orderId: json['order_id'] as String?,
      sdkPayload: json['sdk_payload'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'temperory_user_package_id': temperoryUserPackageId,
      'order_id': orderId,
      'sdk_payload': sdkPayload,
    };
  }
}
