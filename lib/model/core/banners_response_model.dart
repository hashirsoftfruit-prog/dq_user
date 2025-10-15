class BannersList {
  bool? status;
  List<BannerList>? mainBanners;
  List<BannerList>? subBanners;

  BannersList({this.status, this.mainBanners, this.subBanners});

  BannersList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['main_banners'] != null) {
      mainBanners = <BannerList>[];
      json['main_banners'].forEach((v) {
        mainBanners!.add(BannerList.fromJson(v));
      });
    }
    if (json['sub_banners'] != null) {
      subBanners = <BannerList>[];
      json['sub_banners'].forEach((v) {
        subBanners!.add(BannerList.fromJson(v));
      });
    }
  }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.mainBanners != null) {
//       data['banner_list'] = this.mainBanners!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
}

class BannerList {
  int? id;
  String? image;
  String? title;
  String? subtitle;
  String? description;
  String? position;
  String? bookingType;
  String? redirectionType;
  String? redirectionModule;
  int? redirectionId;

  BannerList(
      {this.id,
      this.image,
      this.title,
      this.subtitle,
      this.description,
      this.position,
      this.bookingType,
      this.redirectionType,
      this.redirectionModule,
      this.redirectionId});

  BannerList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    title = json['title'];
    subtitle = json['subtitle'];
    description = json['description'];
    position = json['position'];
    bookingType = json['booking_type'];
    redirectionType = json['redirection_type'];
    redirectionModule = json['redirection_module'];
    redirectionId = json['redirection_id'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['image'] = this.image;
  //   data['title'] = this.title;
  //   data['subtitle'] = this.subtitle;
  //   return data;
  // }
}
