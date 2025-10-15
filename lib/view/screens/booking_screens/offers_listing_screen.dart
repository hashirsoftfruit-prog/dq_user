import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';

import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../model/core/offers_response_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../drawer_menu_screens/offers_screen.dart';

class OffersListScreen extends StatelessWidget {
  final bool isCoupon;
  final List<CouponList> couponList;
  final List<DiscountList> discountList;
  const OffersListScreen({
    super.key,
    required this.couponList,
    required this.discountList,
    required this.isCoupon,
  });

  // AvailableDocsModel docsData;
  @override
  Widget build(BuildContext context) {
    // List<String> langs = ["English","Malayalam"];
    // List<String> consultOthers = ["Father","Mother","Wife","Other"];
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxHeight = constraints.maxHeight;
          double maxWidth = constraints.maxWidth;
          double h1p = maxHeight * 0.01;
          double h10p = maxHeight * 0.1;
          double w10p = maxWidth * 0.1;
          double w1p = maxWidth * 0.01;

          return Consumer<BookingManager>(
            builder: (context, mgr, child) {
              return Scaffold(
                // extendBody: true,
                backgroundColor: Colors.white,
                appBar: getIt<SmallWidgets>().appBarWidget(
                  title: AppLocalizations.of(context)!.applyCoupon,
                  height: h10p,
                  width: w10p,
                  fn: () {
                    Navigator.pop(context);
                  },
                ),
                body: pad(
                  horizontal: w1p * 5,
                  child: ListView(
                    children: [
                      verticalSpace(h1p),

                      // mgr.couponModel!=null?Text(mgr.couponModel!.status.toString()):CircularProgressIndicator(),
                      isCoupon == true && couponList.isNotEmpty
                          ? Entry(
                              xOffset: -1000,
                              // scale: 20,
                              delay: const Duration(milliseconds: 0),
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.ease,
                              child: Entry(
                                opacity: .5,
                                // angle: 3.1415,
                                delay: const Duration(milliseconds: 0),
                                duration: const Duration(milliseconds: 1500),
                                curve: Curves.decelerate,
                                child: Column(
                                  children: couponList
                                      .map(
                                        (coupon) => Padding(
                                          padding: EdgeInsets.only(
                                            bottom: h1p * 2,
                                          ),
                                          child: InkWell(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            onTap: () async {
                                              // if(coupon.applicable==true){
                                              //   await applyCoupnFn(coupon.couponCode??"",);
                                              //
                                              // }else{
                                              //
                                              //   showTopSnackBar(
                                              //       Overlay.of(context),
                                              //       ErrorToast(
                                              //         message:
                                              //         "This coupon is not applicable",
                                              //       ));
                                              // }
                                            },
                                            // child: CouponContainer(isShowInListScreen: true, w1p: w1p, h1p: h1p, title: coupon.title ?? "", couponCode: coupon.couponCode ?? "", subtitle: coupon.subtitle ?? "",)
                                            child: CouponContainer(
                                              w1p: w1p,
                                              h1p: h1p,
                                              title: coupon.title ?? "",
                                              subtitle: coupon.subtitle ?? "",
                                              couponCode:
                                                  coupon.couponCode ?? "",
                                              description:
                                                  coupon.description ?? "",
                                              discountType:
                                                  coupon.discountType ?? "",
                                              discountValue:
                                                  coupon.discountValue ?? "0",
                                              consultationType:
                                                  coupon.consultationType ?? "",
                                              startDate: coupon.startDate ?? "",
                                              endDate: coupon.endDate ?? "",
                                              isApplicableToAll:
                                                  coupon.isApplicableToAll,
                                              isShowInListScreen: true,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            )
                          : isCoupon == false && discountList.isNotEmpty
                          ? Entry(
                              xOffset: -1000,
                              // scale: 20,
                              delay: const Duration(milliseconds: 0),
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.ease,
                              child: Entry(
                                opacity: .5,
                                // angle: 3.1415,
                                delay: const Duration(milliseconds: 0),
                                duration: const Duration(milliseconds: 1500),
                                curve: Curves.decelerate,
                                child: Column(
                                  children: discountList
                                      .map(
                                        (discount) => Padding(
                                          padding: EdgeInsets.only(
                                            bottom: h1p * 2,
                                          ),
                                          child: InkWell(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            onTap: () async {
                                              // if(coupon.applicable==true){
                                              //   await applyCoupnFn(coupon.couponCode??"",);
                                              //
                                              // }else{
                                              //
                                              //   showTopSnackBar(
                                              //       Overlay.of(context),
                                              //       ErrorToast(
                                              //         message:
                                              //         "This coupon is not applicable",
                                              //       ));
                                              // }
                                            },
                                            child: CouponContainer(
                                              w1p: w1p,
                                              h1p: h1p,
                                              title: discount.title ?? "",
                                              subtitle: discount.subtitle ?? "",
                                              description:
                                                  discount.description ?? "",
                                              discountType:
                                                  discount.discountType ?? "",
                                              discountValue:
                                                  discount.discountValue ?? "0",
                                              consultationType:
                                                  discount.consultationType ??
                                                  "",
                                              startDate:
                                                  discount.startDate ?? "",
                                              endDate: discount.endDate ?? "",
                                              isShowInListScreen: true,
                                            ),
                                            // child: DiscountContainer(
                                            //   isShowInListScreen: true,
                                            //   title: discount.title ?? "",
                                            //   subtitle: discount.subtitle ?? "",
                                            //   h1p: h1p,
                                            //   w1p: w1p,
                                            //   offerPrice: "200",
                                            //   savedAmount: "100",
                                            // ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            )
                          : mgr.couponModel != null &&
                                mgr.couponModel!.coupons != null &&
                                mgr.couponModel!.coupons!.isEmpty
                          ? Center(
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.couponNotAvailable,
                                style: TextStyles.notAvailableTxtStyle,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Center(
                              child: LoadingAnimationWidget.fallingDot(
                                color: Colours.primaryblue,
                                size: 50,
                              ),
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
