import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:generic_expandable_text/expandable_text.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';

class ApplyCouponScreen extends StatefulWidget {
  final int? subSpecialityID;
  final int speciality;
  final int? docId;
  final int typeofBooking; //online//offline
  const ApplyCouponScreen({
    super.key,
    required this.speciality,
    required this.typeofBooking,
    this.subSpecialityID,
    this.docId,
  });

  @override
  State<ApplyCouponScreen> createState() => _ApplyCouponScreenState();
}

class _ApplyCouponScreenState extends State<ApplyCouponScreen> {
  // AvailableDocsModel docsData;
  @override
  void initState() {
    super.initState();

    getIt<BookingManager>().getCouponList(
      specialityId: widget.speciality,
      type: widget.typeofBooking,
      subSpecialityId: widget.subSpecialityID,
    );
  }

  var coupC = TextEditingController();
  unFocusFn() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                    Text(
                      AppLocalizations.of(context)!.yourCouponCode,
                      style: t400_14.copyWith(color: clr2D2D2D),
                    ),
                    verticalSpace(4),

                    Container(
                      width: maxWidth,
                      height: 43,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                            "assets/images/dotted-border-for-coupon.png",
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: h1p * 6,
                                child: TextFormField(
                                  onTapOutside: (f) {
                                    unFocusFn();
                                  },
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  controller: coupC,
                                  decoration: applyCouponFieldDec(
                                    hnt: AppLocalizations.of(
                                      context,
                                    )!.yourCouponCode,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () async {
                                if (coupC.text.trim().isNotEmpty) {
                                  Navigator.pop(context, coupC.text);
                                }
                              },
                              child: SizedBox(
                                height: h1p * 6,
                                width: w1p * 15,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.apply,
                                    style: t500_14.copyWith(color: clrFF6A00),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalSpace(h1p),
                    // mgr.couponModel!=null?Text(mgr.couponModel!.status.toString()):CircularProgressIndicator(),
                    verticalSpace(h1p * 4),
                    mgr.couponModel != null && mgr.couponModel!.coupons != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.availableCoupons,
                                style: t400_14.copyWith(color: clr2D2D2D),
                              ),
                              verticalSpace(4),
                              mgr.couponModel!.coupons!.isNotEmpty
                                  ? Entry(
                                      xOffset: -1000,
                                      // scale: 20,
                                      delay: const Duration(milliseconds: 0),
                                      duration: const Duration(
                                        milliseconds: 700,
                                      ),
                                      curve: Curves.ease,
                                      child: Entry(
                                        opacity: .5,
                                        // angle: 3.1415,
                                        delay: const Duration(milliseconds: 0),
                                        duration: const Duration(
                                          milliseconds: 1500,
                                        ),
                                        curve: Curves.decelerate,
                                        child: Column(
                                          children: mgr.couponModel!.coupons!
                                              .map(
                                                (coupon) => Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom: h1p * 2,
                                                  ),
                                                  child: InkWell(
                                                    highlightColor:
                                                        Colors.transparent,
                                                    splashColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      if (coupon.applicable ==
                                                          true) {
                                                        Navigator.pop(
                                                          context,
                                                          coupon.couponCode,
                                                        );
                                                      } else {
                                                        showTopSnackBar(
                                                          Overlay.of(context),
                                                          ErrorToast(
                                                            maxLines: 4,
                                                            message:
                                                                AppLocalizations.of(
                                                                  context,
                                                                )!.thisCouponisNotApplic,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Coupon(
                                                      w1p: w1p,
                                                      h1p: h1p,
                                                      isApplicable:
                                                          coupon.applicable !=
                                                          false,
                                                      title: coupon.title ?? "",
                                                      couponCode:
                                                          coupon.couponCode ??
                                                          "",
                                                      subtitle:
                                                          coupon.subtitle ?? "",
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 38.0,
                                      ),
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.couponNotAvailable,
                                          style:
                                              TextStyles.notAvailableTxtStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                            ],
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
    );
  }
}

class Coupon extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String couponCode;
  final String subtitle;
  final bool isApplicable;
  final String title;
  const Coupon({
    super.key,
    required this.w1p,
    required this.h1p,
    required this.title,
    required this.couponCode,
    required this.isApplicable,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: clrF3F3F3,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: w1p * 4,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isApplicable ? Colours.primaryblue : Colors.grey,
                  ),
                  child: Text(couponCode, style: t400_16),
                ),
                Text(
                  isApplicable
                      ? AppLocalizations.of(context)!.apply.toUpperCase()
                      : AppLocalizations.of(
                          context,
                        )!.notApplicable.toUpperCase(),
                  style: isApplicable
                      ? t500_14.copyWith(color: clrFF6A00)
                      : t500_14.copyWith(color: clrFA8E53),
                ),
              ],
            ),
            pad(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(h1p * 1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: w1p * 60,
                        child: Text(
                          title,
                          style: t500_14.copyWith(color: clr2D2D2D),
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(4),
                  GenericExpandableText(
                    textAlign: TextAlign.start,
                    subtitle,
                    style: t400_14.copyWith(color: clr2D2D2D),
                    readlessColor: Colours.primaryblue,
                    readmoreColor: Colours.primaryblue,
                    hasReadMore: true,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
