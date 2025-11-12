// ignore_for_file: use_build_context_synchronously

import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/model/core/doctor_list_response_model.dart';
import 'package:dqapp/view/screens/booking_screens/find_doctors_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'dart:math';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:dqapp/controller/managers/state_manager.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_svg/svg.dart';
import 'package:generic_expandable_text/expandable_text.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/core/available_doctors_response_model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../controller/managers/booking_manager.dart';
import '../../../model/core/bill_model.dart';
import '../../../model/core/doc_ids_model.dart';
import '../../../model/core/other_patients_response_model.dart';
import '../../../model/core/package_list_response_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../chat_screen.dart';
import '../../widgets/popup_with_scroll_list.dart';
import '../home_screen_widgets.dart';
import '../zoom_screens/call_screen.dart';

Widget scheduledTimeAndDate({
  required double h1p,
  required double w1p,
  required DateTime schedulDate,
  required String time,
}) {
  String dayInt = schedulDate.day.toString();
  String year = schedulDate.year.toString();
  String monthShort = DateFormat.MMMM().format(schedulDate);
  String dayShort = DateFormat.EEEE().format(schedulDate);
  String timeTxt = getIt<StateManager>().getFormattedTime(time)!;
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: clrF3F3F3,
    ),
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$monthShort $dayInt, $year',
                style: t500_16.copyWith(color: clr2D2D2D),
              ),
              Text(dayShort, style: t500_18.copyWith(color: clr858585)),
            ],
          ),
          horizontalSpace(w1p * 2),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  height: 15.72,
                  width: 15.72,
                  child: Image.asset(
                    "assets/images/appointment-clock.png",
                    color: clr4346B5,
                  ),
                ),
              ),
              Text(timeTxt, style: t400_20.copyWith(color: clr4346B5)),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget applyCouponButton({required String text, required double maxWidth}) {
  return Container(
    width: maxWidth,
    height: 43,
    decoration: const BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage("assets/images/dotted-border-for-coupon.png"),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: t400_16.copyWith(color: clr2D2D2D)),
          SizedBox(
            height: 43,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SvgPicture.asset("assets/images/forward-arrow.svg"),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget clinicAddress({
  required double h1p,
  required double w1p,
  required ClinicsDetails clinic,
}) {
  String? clinicName = clinic.name;
  String? clinicalAddress1 = clinic.address1;
  String? clinicalAddress2 = clinic.address2;

  String fullClinicAddress = [
    clinicalAddress1,
    clinicalAddress2,
  ].where((element) => element != null && element.isNotEmpty).join(", ");
  // print("fullClinicAddress booking screen");
  // print(fullClinicAddress);

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: w1p * 2, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: w1p * 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Location', style: t400_18.copyWith(color: clr2D2D2D)),
              Text('$clinicName ', style: t500_14.copyWith(color: clr2D2D2D)),
              Text(
                fullClinicAddress,
                style: t400_14.copyWith(color: clr2D2D2D),
                maxLines: 2,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            double? lat = double.tryParse(clinic.latitude!);
            double? long = double.tryParse(clinic.longitude!);

            if (lat != null && long != null) {
              openMap(lat, long);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: clr2E3192,
              ),
              height: 22,
              width: 22,
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Image.asset(
                  "assets/images/location-icon-doctor-list.png",
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget agreeTermsWidget({
  required Function ontap,
  required double h1p,
  required double w1p,
  required bool agreeTerms,
}) {
  String label = StringConstants.tempIconViewStatus == true ? 'DQ' : 'Medico';

  Future<void> launchInWebView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  checkBox(bool agreed) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: clr2D2D2D, spreadRadius: 5)],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: agreed
            ? Image.asset(
                color: Colors.black,
                fit: BoxFit.contain,
                "assets/images/home_icons/checkbox-done.png",
              )
            : Image.asset(
                color: Colors.black,
                fit: BoxFit.contain,
                "assets/images/home_icons/checkbox-undone.png",
              ),
      ),
    );
  }

  return Row(
    children: [
      InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          ontap();
        },
        child: SizedBox(
          // width: w1p*15,
          height: h1p * 3,
          child: checkBox(agreeTerms),
        ),
      ),
      horizontalSpace(w1p),
      Row(
        children: [
          Text(
            "I agree to $label’s ",
            style: t400_12.copyWith(color: clr444444),
          ),
          InkWell(
            onTap: () {
              Uri url = Uri.parse(
                '${StringConstants.baseUrl}/payment_privacy_policy',
              );
              launchInWebView(url);
            },
            child: Text(
              "terms and conditions",
              style: t400_14.copyWith(
                color: clr444444,
                backgroundColor: Colors.black12,
                decoration: TextDecoration.underline,
                decorationColor: clr444444,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

class CheckBoxItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String title;
  final bool selected;

  const CheckBoxItem({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.selected,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: clr757575.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 5, top: 5, bottom: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              // width: w1p*15,
              height: w1p * 5,
              child: SvgPicture.asset(
                fit: BoxFit.contain,
                selected
                    ? "assets/images/circle-selected.svg"
                    : "assets/images/circle-unselected.svg",
              ),
            ),
            horizontalSpace(3),
            SizedBox(
              child: Text(
                title.length > 16
                    ? "${title.substring(0, 10)}...${title.substring(title.length - 2, title.length)}"
                    : title,
                style: selected
                    ? t500_14.copyWith(color: clr4346B5)
                    : t500_14.copyWith(color: clr444444),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorDetailsContainer extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String name;
  final String img;
  final String experience;
  final String type;
  const DoctorDetailsContainer({
    super.key,
    required this.w1p,
    required this.h1p,
    required this.img,
    required this.name,
    required this.experience,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w1p * 4, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        // gradient: linearGrad3
        // color: Colours.lightGrey
        color: clrFFEDEE,
        // boxShadow: [boxShadow5b]
      ),
      child: pad(
        horizontal: w1p * 3,
        vertical: h1p,
        child: Column(
          children: [
            verticalSpace(h1p),

            Row(
              children: [
                // horizontal: w1p*2.5,
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: "${StringConstants.baseUrl}$img",
                            placeholder: (context, url) => Image.asset(
                              'assets/images/doctor-placeholder.png',
                              fit: BoxFit.fitHeight,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/doctor-placeholder.png',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                horizontalSpace(w1p * 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(name, style: t700_18.copyWith(color: clr2D2D2D)),
                      Text(type, style: t400_14.copyWith(color: clr2D2D2D)),
                      Text(
                        experience,
                        style: t400_14.copyWith(color: clr2D2D2D, height: 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Divider(),
            // Row(children: [
            //   SizedBox(height: 15,width: 15, child: Image.asset("assets/images/doc-list-icon1.png")),
            //   Text("time",style: TextStyles.textStyle65,),
            // ],),
            verticalSpace(h1p),
          ],
        ),
      ),
    );
  }
}

class BillBox extends StatelessWidget {
  final double w1p;
  final double h1p;
  // String totalAmt;
  // String? amtIfCouponApplied;
  // String? packagePriceIfAdded;
  final bool? isLoading;
  final BillResponseModel? bill;
  final bool? isSeniorCitizen;

  const BillBox({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.bill,
    // required this.totalAmt,
    // required this.amtIfCouponApplied,
    // required this.packagePriceIfAdded,
    required this.isLoading,
    this.isSeniorCitizen,
  });

  @override
  Widget build(BuildContext context) {
    String? cnsultFee = bill?.fee;
    String? discnt = bill?.discount;
    String? platformFee = bill?.platformFee;
    String? serviceFee = bill?.tax;
    String? amtIfCouponApplied = bill?.couponDiscountValue;
    String? packagePriceIfAdded = bill?.packageAmt;
    String? totalAmt = bill?.amountAfterDiscount;

    String label = StringConstants.tempIconViewStatus == true ? 'DQ' : 'Medico';

    return DottedBorder(
      options: const RectDottedBorderOptions(
        color: Colors.grey,
        strokeWidth: 1,
        dashPattern: [5, 5],
      ),
      child: Padding(
        padding: EdgeInsets.all(w1p * 3),
        child: isLoading == true
            ? Center(
                child: LoadingAnimationWidget.twoRotatingArc(
                  color: Colours.primaryblue,
                  size: 30,
                ),
              )
            : Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.billDetails,
                      style: t500_16.copyWith(color: clr444444),
                    ),
                  ),
                  cnsultFee != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.consultationFee,
                              style: t400_14.copyWith(color: clr444444),
                            ),
                            Text(
                              '₹$cnsultFee',
                              style: t500_16.copyWith(color: clr2D2D2D),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  platformFee != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.platformFee,
                              style: t400_14.copyWith(color: clr444444),
                            ),
                            Text(
                              '₹$platformFee',
                              style: t500_16.copyWith(color: clr2D2D2D),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  packagePriceIfAdded != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.packagePrice,
                              style: t400_14.copyWith(color: clr444444),
                            ),
                            Text(
                              '₹$packagePriceIfAdded',
                              style: t500_16.copyWith(color: clr2D2D2D),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  serviceFee != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.serviceFee,
                              style: t400_14.copyWith(color: clr444444),
                            ),
                            Text(
                              '₹$serviceFee',
                              style: t500_16.copyWith(color: clr2D2D2D),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  discnt != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$label ${AppLocalizations.of(context)!.discount}",
                              style: t400_14.copyWith(color: clr00C165),
                            ),
                            Text(
                              '-₹$discnt',
                              style: t500_16.copyWith(color: clr00C165),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  amtIfCouponApplied != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.couponDiscount,
                              style: t400_14.copyWith(color: clr00C165),
                            ),
                            Text(
                              '-₹$amtIfCouponApplied',
                              style: t500_16.copyWith(color: clr00C165),
                            ),
                          ],
                        )
                      : const SizedBox(),

                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.totalAmt,
                        style: t500_16.copyWith(color: clr444444),
                      ),
                      Text(
                        '₹$totalAmt',
                        style: t700_16.copyWith(color: const Color(0xff000000)),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: isSeniorCitizen == true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.withSixtyPlus,
                          style: t700_16.copyWith(color: clr444444),
                        ),
                        Text(
                          AppLocalizations.of(context)!.freeCapital,
                          style: t700_18.copyWith(
                            color: const Color(0xff00C165),
                          ),
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

class PackagesContainer extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String title;
  final String subtitle;
  final String salePrice;
  final String image;
  final String offerPrice;
  final String savedAmount;
  final String btnTxt;
  const PackagesContainer({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.subtitle,
    required this.title,
    required this.salePrice,
    required this.image,
    required this.offerPrice,
    required this.btnTxt,
    required this.savedAmount,
  });

  // bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: AspectRatio(
        aspectRatio: 2 / 1,
        child: SizedBox(
          child: HomeWidgets().cachedImg(image, noPlaceHolder: true),
        ),
      ),
    );
  }
}

class RefundPolicy extends StatelessWidget {
  const RefundPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> launchInWebView(Uri url) async {
      if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
        throw Exception('Could not launch $url');
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Refund policy", style: t500_16.copyWith(color: clr2D2D2D)),
        verticalSpace(8),
        RichText(
          text: TextSpan(
            text:
                "Refunds are available if a consultation is not completed due to technical issues or provider unavailability.",
            style: t400_14.copyWith(color: clr858585),
            children: [
              TextSpan(
                text: " Know more",
                style: t400_14.copyWith(color: const Color(0xff008BD0)),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Uri url = Uri.parse(
                      '${StringConstants.baseUrl}/payment_privacy_policy',
                    );
                    launchInWebView(url);
                  },
              ),
            ],
          ),
        ),
        // verticalSpace(80)
      ],
    );
  }
}

class FreeConsultContainer extends StatelessWidget {
  final double w1p;
  final double h1p;
  final int? userId;
  final Function() refreshBill;
  const FreeConsultContainer({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.userId,
    required this.refreshBill,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 2 / 1,
            child: SizedBox(
              // width: w1p*30,
              child: Hero(
                tag: "age-verification",
                child: SizedBox(
                  child: Image.asset(
                    "assets/images/age-verification-image.png",
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: InkWell(
              onTap: () {
                getIt<BookingManager>().selectDocTypeInitially();

                showModalBottomSheet(
                  isScrollControlled: true,
                  useSafeArea: true,
                  // isDismissible: true,
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (context) {
                    return AgeConfirmationDocumentUploadPop(
                      w1p: w1p,
                      appUserId: userId,
                      refreshBill: refreshBill,
                    );
                  },
                );
              },
              child: Container(
                width: 120,
                height: 30,
                decoration: BoxDecoration(
                  color: clr2E3192,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.verify,
                    style: t400_14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FreeConsultApplied extends StatelessWidget {
  final double w1p;
  final double h1p;
  const FreeConsultApplied({super.key, required this.h1p, required this.w1p});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,

      // decoration:BoxDecoration(
      //     gradient: LinearGradient(colors: [Colours.grad1,Colours.primaryblue]),
      //     borderRadius: BorderRadius.circular(containerRadius/2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              child: Image.asset("assets/images/age-verification-image.png"),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.nowYourConsultationIs,
            style: t700_14.copyWith(color: clr444444),
          ),
          Text(
            AppLocalizations.of(context)!.completelyFree,
            style: t700_14.copyWith(color: const Color(0xff383BA3)),
          ),
        ],
      ),
    );
  }
}

class SelectedPackage extends StatelessWidget {
  final double w1p;
  final double h1p;
  final SelectedPackageModel selectedPkg;
  final Function fn;
  const SelectedPackage({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.selectedPkg,
    required this.fn,
  });

  @override
  Widget build(BuildContext context) {
    String title = selectedPkg.packagename ?? '';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffDAF7FF),
        borderRadius: BorderRadius.circular(5),
        // border: Border.all(color: Colours.lightBlu,),
        //   gradient: LinearGradient(
        //       colors: [Colours.primaryblue,Colours.primaryblue.withOpacity(0.7)
        //       ]
        //   )
      ),
      width: double.infinity,
      child: pad(
        horizontal: w1p * 2,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: h1p, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(8),

              Container(
                decoration: BoxDecoration(
                  color: clr444444,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 3,
                  ),
                  child: Text('Selected Package', style: t400_10),
                ),
              ),
              verticalSpace(4),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: w1p * 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: t700_16.copyWith(color: clr2D2D2D),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      fn();
                      // getIt<BookingManager>().setSelectedCoupon(null);
                      // getIt<BookingManager>().setLoaderActive(true);
                      // await Future.delayed(Duration(milliseconds: 500),(){
                      //   getIt<BookingManager>().setLoaderActive(false);
                      // });
                    },
                    child: SizedBox(
                      child: Text(
                        'Remove',
                        style: t400_14.copyWith(color: const Color(0xffFF0000)),
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(8),
              // VerticalDivider(color: Colors.black,width: w1p),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectedCoupon extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String title;
  final String subTitle;
  final Function fn;
  const SelectedCoupon({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.subTitle,
    required this.title,
    required this.fn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffDAF7FF),
        borderRadius: BorderRadius.circular(5),
        // border: Border.all(color: Colours.lightBlu,),
        //   gradient: LinearGradient(
        //       colors: [Colours.primaryblue,Colours.primaryblue.withOpacity(0.7)
        //       ]
        //   )
      ),
      width: double.infinity,
      child: pad(
        horizontal: w1p * 2,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: h1p, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: t700_16.copyWith(color: clr2D2D2D)),
                    Text(subTitle, style: t400_14.copyWith(color: clr858585)),
                  ],
                ),
              ),
              // VerticalDivider(color: Colors.black,width: w1p),
              InkWell(
                onTap: () async {
                  fn();
                  // getIt<BookingManager>().setSelectedCoupon(null);
                  // getIt<BookingManager>().setLoaderActive(true);
                  // await Future.delayed(Duration(milliseconds: 500),(){
                  //   getIt<BookingManager>().setLoaderActive(false);
                  // });
                },
                child: SizedBox(
                  child: Text(
                    'Remove',
                    style: t400_14.copyWith(color: const Color(0xffFF0000)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AgeConfirmationDocumentUploadPop extends StatefulWidget {
  // double h1p;
  final double w1p;
  final int? appUserId;
  final Function() refreshBill;
  const AgeConfirmationDocumentUploadPop({
    super.key,
    // required this.h1p,
    required this.w1p,
    required this.appUserId,
    required this.refreshBill,
  });

  @override
  State<AgeConfirmationDocumentUploadPop> createState() =>
      _AgeConfirmationDocumentUploadPopState();
}

class _AgeConfirmationDocumentUploadPopState
    extends State<AgeConfirmationDocumentUploadPop> {
  @override
  void dispose() {
    getIt<BookingManager>().disposeAgeVerification();
    // getIt<BookingManager>().setAgeVerifyloader(false);

    super.dispose();
  }

  var cntrlr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double space1 = 12;
    double space2 = 12;
    return Consumer<BookingManager>(
      builder: (context, mgr, child) {
        return
        // Scaffold(resizeToAvoidBottomInset: false,backgroundColor: Colors.transparent,
        Scaffold(
          backgroundColor: clrFFFFFF,
          body: Container(
            // height:550,
            color: Colors.transparent,
            child: pad(
              vertical: 24,
              horizontal: widget.w1p * 4,
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: widget.w1p * 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Hero(
                        tag: "age-verification",
                        child: SizedBox(
                          child: Image.asset(
                            "assets/images/age-verification-image.png",
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: space1),
                    child: Text(
                      AppLocalizations.of(context)!.seniorCareOnDq,
                      style: t700_18.copyWith(color: const Color(0xff3B3EA8)),
                    ),
                  ),
                  // verticalSpace(space1),
                  Text(
                    "Exclusive free medical consultations for senior citizens because their health matters most!",
                    style: t400_14.copyWith(color: clr2D2D2D),
                  ),
                  verticalSpace(space1),

                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.completeVerification,
                        style: t400_16.copyWith(color: clr2D2D2D),
                      ),
                      horizontalSpace(8),
                      Expanded(
                        child: Container(
                          height: 0.5,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xffE3E3E3), Color(0xff959595)],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(space1),

                  Text(
                    AppLocalizations.of(context)!.chooseType,
                    style: t400_14.copyWith(color: clr2D2D2D),
                  ),
                  mgr.idTypes != null && mgr.idTypes!.isNotEmpty
                      ? SimpleDropdown(mgr.idTypes ?? [])
                      : const SizedBox(),
                  verticalSpace(space1),

                  Text(
                    AppLocalizations.of(context)!.enterIdNo,
                    style: t400_14.copyWith(color: clr2D2D2D),
                  ),

                  // verticalSpace(space1),
                  InkWell(
                    onTap: () {
                      showDialog(
                        // backgroundColor: Colors.white,
                        // isScrollControlled: false,
                        useSafeArea: true,
                        // showDragHandle: true,
                        context: context,
                        builder: (context) => TextFieldPop(
                          value: mgr.idNoForAgeVerification,
                          fn: (val) {
                            getIt<BookingManager>().setIdNoforAgeVerify(val);
                            // getIt<ProfileManager>().updatePersonalDetails({"first_name":val});
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colours.lightBlu),
                      ),
                      height: 40,
                      width: widget.w1p * 100,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            mgr.idNoForAgeVerification,
                            style: t500_14.copyWith(color: clr444444),
                          ),
                        ),
                      ),
                    ),
                  ),
                  verticalSpace(space1),

                  Text(
                    AppLocalizations.of(context)!.uploadSoftCopy,
                    style: t400_14.copyWith(color: clr2D2D2D),
                  ),
                  verticalSpace(space2),

                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                            allowMultiple: false,
                            type: FileType.custom,
                            allowedExtensions: [
                              'jpg',
                              'pdf',
                              'doc',
                              'png',
                              'docx',
                            ],
                          );

                      if (result != null) {
                        if (result.files.single.size > 5 * 1024 * 1024) {
                          showTopSnackBar(
                            Overlay.of(context),
                            const ErrorToast(
                              message: 'File size should not exceed 5MB',
                            ),
                          );
                          return;
                        }
                        String filepath = result.files.single.path!;

                        getIt<BookingManager>().addIdFile(filepath);
                      } else {
                        // User canceled the picker
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      // height: 70,
                      width: widget.w1p * 100,
                      // height: 200,
                      decoration: BoxDecoration(
                        color: mgr.identityFilePath != null
                            ? null
                            : Colours.lightBlu,
                        borderRadius: BorderRadius.circular(
                          mgr.identityFilePath == null ? 0 : 8,
                        ),
                        border: Border.all(color: Colours.lightBlu, width: 2),
                      ),
                      child: mgr.identityFilePath == null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   AppLocalizations.of(context)!.uploadFile,
                                  //   style: TextStyles.textStyle51,
                                  // ),
                                  Text(
                                    "Upload File",
                                    style: t700_16.copyWith(color: clr2E3192),
                                  ),
                                  Text(
                                    "( Upload soft copy of your id card)",
                                    style: t400_12.copyWith(color: clr545454),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Image.asset(
                                      "assets/images/uploadicon.png",
                                    ),
                                  ),
                                  Text(
                                    "Browse",
                                    style: t400_12.copyWith(color: clr444444),
                                  ),
                                ],
                              ),
                            )
                          : Entry(
                              xOffset: -200,
                              // scale: 20,
                              delay: const Duration(milliseconds: 100),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                              child: Padding(
                                padding: EdgeInsets.all(widget.w1p),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      // width: h1p*3,
                                      // color: Colors.redAccent,
                                      child: Image.asset(
                                        "assets/images/fileicon.png",
                                      ),
                                    ),
                                    horizontalSpace(widget.w1p),
                                    Expanded(
                                      child: Text(
                                        mgr.identityFilePath!.split('/').last,
                                        style: t500_12.copyWith(
                                          color: const Color(0xff707070),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        getIt<BookingManager>().addIdFile(null);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ),
                                    ),
                                    horizontalSpace(widget.w1p),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  verticalSpace(space2),

                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black26),
                            ),
                            height: 40,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.back,
                                style: t400_16.copyWith(color: clr2D2D2D),
                              ),
                            ),
                          ),
                        ),
                      ),
                      horizontalSpace(widget.w1p),
                      Expanded(
                        child: mgr.ageVerificationLoader == true
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  if (mgr.selectedDocItem != null &&
                                      mgr.identityFilePath != null) {
                                    var result = await getIt<BookingManager>()
                                        .uploadAgeProofDoc(
                                          idNo: mgr.idNoForAgeVerification,
                                          userId: widget.appUserId,
                                        );
                                    // var result = BasicResponseModel(status: true,message: "ssssdsdsd");
                                    if (result.status == true) {
                                      getIt<BookingManager>()
                                          .changeAgeProofSubmittedValue(true);
                                      widget.refreshBill();
                                      showTopSnackBar(
                                        Overlay.of(context),
                                        SuccessToast(
                                          message: result.message ?? "",
                                        ),
                                      );

                                      Navigator.pop(context);
                                    } else {
                                      showTopSnackBar(
                                        Overlay.of(context),
                                        ErrorToast(
                                          maxLines: 4,
                                          message: result.message ?? "",
                                        ),
                                      );
                                    }
                                  } else {
                                    showTopSnackBar(
                                      Overlay.of(context),
                                      ErrorToast(
                                        maxLines: 4,
                                        message:
                                            mgr.idNoForAgeVerification.isEmpty
                                            ? "Provide ID No"
                                            : mgr.selectedDocItem == null
                                            ? "Select a type"
                                            : mgr.identityFilePath == null
                                            ? "File not selected"
                                            : "",
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colours.primaryblue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.submit,
                                      style: t400_16,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SimpleDropdown extends StatelessWidget {
  final List<IdTypes> list;
  const SimpleDropdown(this.list, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      decoration: CustomDropdownDecoration(
        listItemStyle: t400_14.copyWith(color: clr2D2D2D),
        headerStyle: t400_14.copyWith(color: clr2E3192),
        closedBorder: Border.all(color: Colours.lightBlu),
      ),
      hintText: 'Select Id',
      closedHeaderPadding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      items: list.map((e) => e.name!).toList(),
      initialItem: list[0].name,
      onChanged: (value) {
        getIt<BookingManager>().selectDocType(value);
      },
    );
  }
}

class DocContainer extends StatefulWidget {
  final double w1p;
  final double h1p;
  final Doctors data;

  const DocContainer({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.data,
  });

  @override
  State<DocContainer> createState() => _DocContainerState();
}

class _DocContainerState extends State<DocContainer> {
  bool isExpand = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.white,
          // isScrollControlled: false,
          useSafeArea: true,
          showDragHandle: true,
          context: context,
          builder: (context) => DoctorsDetailsPopUp(
            maxWidth: widget.w1p * 100,
            maxHeight: widget.h1p * 100,
            data: widget.data,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(200),
        ),
        height: widget.w1p * 15,
        width: isExpand ? 200 : widget.w1p * 15,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: SizedBox(
                height: widget.w1p * 15,
                width: widget.w1p * 15,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  // fit: widget.fit,
                  imageUrl: '${StringConstants.baseUrl}${widget.data.image}',
                  placeholder: (context, url) =>
                      Image.asset("assets/images/doctor-placeholder.png"),
                  errorWidget: (context, url, error) =>
                      Image.asset("assets/images/doctor-placeholder.png"),
                ),
              ),
            ),
            Visibility(
              visible: isExpand,
              child: pad(
                horizontal: widget.w1p,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.data.firstName ?? "",
                      style: t500_12.copyWith(color: const Color(0xffffffff)),
                    ),
                    Text(
                      widget.data.qualification ?? "",
                      style: t400_10.copyWith(color: const Color(0xff545454)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GenderBox extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String txt;
  final bool selected;
  final bool? isReadOnly;
  const GenderBox({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.txt,
    required this.selected,
    this.isReadOnly,
  });

  @override
  Widget build(BuildContext context) {
    bool readOnly = isReadOnly ?? false;
    return Container(
      margin: EdgeInsets.only(right: w1p),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(containerRadius / 2),
        border: Border.all(
          color: readOnly
              ? Colors.grey.withOpacity(0.5)
              : selected
              ? Colours.primaryblue
              : Colors.grey,
          width: selected ? 2.5 : 1,
        ),
      ),
      child: pad(
        horizontal: w1p * 3,
        vertical: h1p * 0.5,
        child: Center(
          child: Text(
            txt,
            style: t500_14.copyWith(
              color: readOnly
                  ? Colors.grey.withOpacity(.5)
                  : selected
                  ? Colours.primaryblue
                  : clr444444,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class DoctorsItemInBookingScreen extends StatelessWidget {
  final double maxHeight;
  final double maxWidth;
  final Doctors data;

  // double ma
  const DoctorsItemInBookingScreen({
    super.key,
    required this.maxHeight,
    required this.maxWidth,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    String name = data.firstName != null
        ? getIt<StateManager>().capitalizeFirstLetter(data.firstName!)
        : "";
    String qualification = data.qualification ?? "";
    String experience = data.experience ?? "0";

    // List<Experiences> exper = data.experiences ?? [];

    // List<Education> eduList = data.education ?? [];
    // List<String> edu = eduList.map((e) => '${e.specialization} - ${e.qualificationLevel}\n').toList();
    // String education = edu.join();

    return Container(
      margin: const EdgeInsets.all(5),
      width: 177,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: clrFFFFFF,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withOpacity(0.16),
            offset: const Offset(0, 2),
            spreadRadius: 0,
            blurRadius: 4.7,
          ),
        ],
      ),
      // extendBody: true,
      // backgroundColor: Colors.r=tr,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                      height: 89,
                      width: 89,
                      child: HomeWidgets().cachedImg(
                        data.image ?? "",
                        placeholderImage:
                            "assets/images/doctor-placeholder.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              Text('Dr.$name', style: t500_16.copyWith(color: clr2D2D2D)),
              Expanded(
                child: Text(
                  qualification,
                  style: t400_14.copyWith(color: clr858585),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              verticalSpace(4),
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xffECE6FF),
                ),
                child: Center(
                  child: Text(
                    '$experience Exp',
                    style: t400_14.copyWith(color: clr2D2D2D),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            child: SizedBox(
              width: 19,
              height: 19,
              child: Image.asset("assets/images/video-call-icon.png"),
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorsItemWithFeeInBookingScreen extends StatelessWidget {
  final double maxHeight;
  final double maxWidth;
  final Doctors data;

  // double ma
  const DoctorsItemWithFeeInBookingScreen({
    super.key,
    required this.maxHeight,
    required this.maxWidth,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    String name = data.firstName != null
        ? getIt<StateManager>().capitalizeFirstLetter(data.firstName!)
        : "";
    String qualification = data.qualification ?? "";
    String experience = data.experience ?? "0";
    String fee = data.subSpecialityFee ?? "0";

    // List<Experiences> exper = data.experiences ?? [];

    // List<Education> eduList = data.education ?? [];
    // List<String> edu = eduList.map((e) => '${e.specialization} - ${e.qualificationLevel}\n').toList();
    // String education = edu.join();

    return SizedBox(
      height: 250,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: clrFFFFFF,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff000000).withOpacity(0.16),
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                    blurRadius: 4.7,
                  ),
                ],
              ),
              // extendBody: true,
              // backgroundColor: Colors.r=tr,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  verticalSpace(10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(
                          height: 88,
                          width: 88,
                          child: HomeWidgets().cachedImg(
                            data.image ?? "",
                            placeholderImage:
                                "assets/images/doctor-placeholder.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Dr.$name',
                    style: t500_16.copyWith(color: clr2D2D2D),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    qualification,
                    style: t400_14.copyWith(color: clr858585, height: 1.17),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    experience,
                    style: t400_12.copyWith(color: clr858585, height: 1.17),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // SizedBox(
                  //     width:19,height:19,
                  //     child: Image.asset("assets/images/video-call-icon.png")),
                  verticalSpace(10),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                      color: Color(0xffFFF9E3),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Text(
                            'Fee : ₹$fee',
                            style: t400_12.copyWith(color: clr2D2D2D),
                          ),
                        ),
                        // SizedBox(child: Text('${experience}', style: t400_12.copyWith(color: clr2D2D2D))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 32,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff000000).withOpacity(0.16),
                  blurRadius: 4.7,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xffF68629),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Text(
                    'Book Now',
                    style: t500_14.copyWith(color: clrFFFFFF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorsDetailsPopUp extends StatelessWidget {
  final double maxHeight;
  final double maxWidth;
  final Doctors data;

  // double ma
  const DoctorsDetailsPopUp({
    super.key,
    required this.maxHeight,
    required this.maxWidth,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    double h1p = maxHeight * 0.01;
    double h10p = maxHeight * 0.1;
    // double w10p = maxWidth * 0.1;
    double w1p = maxWidth * 0.01;

    String name = data.firstName ?? "";
    String qualification = data.qualification ?? "";
    String experience = data.experience ?? "0";

    // List<Experiences> exper = data.experiences ?? [];

    List<Education> eduList = data.education ?? [];
    List<String> edu = eduList
        .map((e) => '${e.specialization} - ${e.qualificationLevel}\n')
        .toList();
    String education = edu.join();

    // columnWidget(String title, String subtitle) {
    //   return Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Text(
    //             title,
    //             style: t700_14.copyWith(color: clr444444, height: 1),
    //           ),
    //           Text(
    //             subtitle,
    //             style: t500_12.copyWith(color: clr444444, height: 1),
    //           ),
    //         ],
    //       ),
    //     ],
    //   );
    // }

    expandColumnWidget(String title, String subtitle) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: t700_14.copyWith(color: clr444444, height: 1)),
          verticalSpace(h1p * 0.5),
          GenericExpandableText(
            textAlign: TextAlign.start,
            subtitle,
            style: t500_12.copyWith(color: const Color(0x7C313131)),
            readlessColor: Colours.primaryblue,
            readmoreColor: Colours.primaryblue,
            hasReadMore: true,
            maxLines: 2,
          ),
        ],
      );
    }

    // Widget divider = SizedBox(height: h1p * 5, child: const VerticalDivider());

    return SizedBox(
      width: maxWidth,
      child: pad(
        horizontal: w1p * 4,
        child: SizedBox(
          height: h10p * 4,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(
                          height: w1p * 20,
                          width: w1p * 20,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: '${StringConstants.baseUrl}${data.image}',
                            placeholder: (context, url) => Image.asset(
                              "assets/images/doctor-placeholder.png",
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/doctor-placeholder.png",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(h1p * 2),
                  Text(
                    name,
                    style: t700_14.copyWith(color: clr444444, height: 1),
                  ),
                  verticalSpace(h1p * 0.5),
                  Text(
                    qualification,
                    style: t500_12.copyWith(color: clr444444, height: 1),
                  ),
                  verticalSpace(h1p * 2),
                ],
              ),
              verticalSpace(h1p * 2),
              expandColumnWidget("Experience", '$experience Years'),
              verticalSpace(h1p),
              expandColumnWidget("Education", education),
            ],
          ),
        ),
      ),
    );
  }
}

class CallRequestPopup extends StatefulWidget {
  final String name;
  final String img;
  final String qualification;
  final int bookingId;
  final int docId;
  final int tempBookingId;
  final String appoinmentId;
  final bool inChatStatus;

  // double ma
  const CallRequestPopup({
    super.key,
    required this.name,
    required this.qualification,
    required this.img,
    required this.docId,
    required this.appoinmentId,
    required this.bookingId,
    required this.inChatStatus,
    required this.tempBookingId,
  });

  @override
  State<CallRequestPopup> createState() => _CallRequestPopupState();
}

class _CallRequestPopupState extends State<CallRequestPopup> {
  @override
  void initState() {
    super.initState();
    FlutterRingtonePlayer().playRingtone();
  }

  @override
  void dispose() {
    FlutterRingtonePlayer().stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double h1p = maxHeight * 0.01;
    // double h10p = maxHeight * 0.1;
    // double w10p = maxWidth * 0.1;
    // double w1p = maxWidth * 0.01;

    Widget btn({required bool isAcceptBtn}) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isAcceptBtn == true
              ? const Color(0xff00b94d)
              : const Color(0xfff03a14),
        ),
        child: pad(
          horizontal: 18,
          vertical: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
                child: Image.asset(
                  isAcceptBtn == true
                      ? "assets/images/accept_call.png"
                      : "assets/images/decline_call.png",
                  color: Colors.white,
                ),
              ),
              horizontalSpace(4),
              Text(
                isAcceptBtn == true ? "Accept" : "Decline",
                style: t700_16.copyWith(color: const Color(0xffffffff)),
              ),
            ],
          ),
        ),
      );
    }

    return Material(
      child: Container(
        color: Colors.white,
        // extendBody: true,
        // backgroundColor: Colors.r=tr,
        child: SizedBox(
          child: pad(
            horizontal: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: '${StringConstants.baseUrl}${widget.img}',
                          placeholder: (context, url) => Image.asset(
                            "assets/images/doctor-placeholder.png",
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/doctor-placeholder.png",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(8),
                Text(
                  widget.name,
                  style: t700_14.copyWith(color: clr444444, height: 1),
                ),
                verticalSpace(8),
                Text(
                  widget.qualification,
                  style: t500_12.copyWith(color: clr444444, height: 1),
                ),
                verticalSpace(8),
                Text(
                  'is calling you...',
                  style: t500_18.copyWith(
                    color: const Color(0xff818181),
                    height: 1.5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          getIt<BookingManager>().cancelInitiatedBooking(
                            bookingId: widget.tempBookingId,
                          );
                        },
                        child: btn(isAcceptBtn: false),
                      ),
                    ),
                    horizontalSpace(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                      child: InkWell(
                        onTap: () {
                          if (widget.inChatStatus == true) {
                            getIt<BookingManager>().sendConsultedStatus(
                              widget.bookingId,
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CallScreen(
                                  bookingId: widget.bookingId,
                                  displayName:
                                      getIt<SharedPreferences>().getString(
                                        StringConstants.userName,
                                      ) ??
                                      "Unknown",
                                  role: "0",
                                  isJoin: true,
                                  sessionIdleTimeoutMins: "40",
                                  sessionName: widget.appoinmentId,
                                  sessionPwd: 'Qwerty123',
                                ),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatPage(
                                  docId: widget.docId,
                                  appId: widget.appoinmentId,
                                  isCallAvailable: true,
                                  bookId: widget.bookingId,
                                  isDirectToCall: true,
                                ),
                              ),
                            );
                          }

                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ChatSc()));
                        },
                        child: btn(isAcceptBtn: true),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> areYouSureDialog(BuildContext context) async {
  bool isActive = false;
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      child: Container(
        color: Colors.white,
        height: 140,
        width: 150,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure?'),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    isActive = true;
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes'),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    isActive = false;
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  return isActive;
}

class CouponAppliedWidget extends StatefulWidget {
  final double w1p;
  final double h1p;
  final String txt;
  final String cCode;
  final String amtSaved;
  final bool selected;
  const CouponAppliedWidget({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.amtSaved,
    required this.cCode,
    required this.txt,
    required this.selected,
  });

  @override
  State<CouponAppliedWidget> createState() => _CouponAppliedWidgetState();
}

class _CouponAppliedWidgetState extends State<CouponAppliedWidget> {
  @override
  void initState() {
    super.initState();
    confCntrlr.play();
  }

  @override
  void dispose() {
    super.dispose();
    confCntrlr.dispose();
  }

  var confCntrlr = ConfettiController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            pad(
              horizontal: 12,
              child: Center(
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: pad(
                    horizontal: 12,
                    vertical: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/coupon.png"),
                        verticalSpace(12),
                        // Text("Coupon ${widget.cCode.toUpperCase()} is Successfully Applied",style: TextStyles.coupnTxt2,textAlign:TextAlign.center),
                        Text(
                          "Coupon Applied Successfully",
                          style: t500_16.copyWith(color: clr417FB1),
                          textAlign: TextAlign.center,
                        ),
                        // Text("₹${widget.amtSaved}",style: TextStyles.coupnTxt1,textAlign: TextAlign.center),
                        // Text("Saved with this coupon",style: TextStyles.coupnTxt2,textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        ConfettiWidget(
          confettiController: confCntrlr,
          shouldLoop: false,
          minimumSize: const Size(5, 5),
          blastDirection: pi * 2,
          colors: const [Colours.primaryblue, Colors.amber],
          numberOfParticles: 3,
        ),
      ],
    );
  }
}

class PatientBox extends StatelessWidget {
  final double w1p;
  final double h1p;
  final UserDetails user;
  final bool selected;
  const PatientBox({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.user,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    String fname = getIt<StateManager>().capitalizeFirstLetter(
      user.firstName ?? '',
    );
    String lname = getIt<StateManager>().capitalizeFirstLetter(
      user.lastName ?? '',
    );
    String fullName = '$fname $lname';
    int age = getIt<StateManager>().calculateAge(user.dateOfBirth!);

    return AnimatedContainer(
      width: w1p * 60,
      duration: const Duration(milliseconds: 100),
      decoration: BoxDecoration(
        border: Border.all(
          color: selected ? const Color(0xffF4A9AE) : Colors.transparent,
          width: selected ? 1 : 0,
        ),
        color: selected ? clrFFEDEE : clrF3F3F3,
        borderRadius: BorderRadius.circular(containerRadius / 3),
      ),
      child: pad(
        horizontal: w1p * 3,
        vertical: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fullName.length > 16
                  ? "${fullName.substring(0, 12)}...${fullName.substring(fullName.length - 2, fullName.length)}"
                  : fullName,
              style: t400_16.copyWith(color: clr2D2D2D),
            ),
            Text(
              '${user.relation}, $age',
              style: t400_14.copyWith(color: clr717171),
            ),
          ],
        ),
      ),
    );
  }
}

class OtherBox extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String name;
  const OtherBox({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        border: Border.all(color: clrF8F8F8),
        color: Colors.white,
        borderRadius: BorderRadius.circular(containerRadius / 3),
      ),
      child: pad(
        horizontal: 8,
        vertical: 2,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: clr2E3192,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset("assets/images/add-icon.svg"),
              ),
            ),
            horizontalSpace(4),
            Text(name, style: t400_14.copyWith(color: clr444444)),
          ],
        ),
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  // double w1p;
  // double h1p;
  final String hnt;
  final bool isClinic;
  final TextEditingController cntrolr;
  final Function(String val) searchFn;
  final Function() locationFn;
  const SearchBarWidget({
    super.key,
    // required this.h1p,
    // required this.w1p,
    required this.hnt,
    required this.cntrolr,
    required this.searchFn,
    required this.isClinic,
    required this.locationFn,
  });

  @override
  Widget build(BuildContext context) {
    InputDecoration inputDec4({required String hnt, bool? isEmpty}) {
      return InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            height: 12.5,
            width: 12.5,
            child: SvgPicture.asset(
              "assets/images/icon-search.svg",
              alignment: Alignment.center,
            ),
          ),
        ),
        suffixIcon: isClinic
            ? InkWell(
                onTap: () {
                  locationFn();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 12.5,
                    width: 12.5,
                    child: SvgPicture.asset(
                      "assets/images/home_icons/location.svg",
                      colorFilter: const ColorFilter.mode(
                        Colors.black54,
                        BlendMode.srcIn,
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              )
            : null,
        contentPadding: const EdgeInsets.only(left: 10),
        border: outLineBorder,
        enabledBorder: outLineBorder,
        focusedBorder: outLineBorder,
        filled: true,
        hintStyle: t400_13.copyWith(color: const Color(0xff474747)),
        hintText: hnt,
        // labelText: hnt, labelStyle: t400_13.copyWith(color: Color(0xff474747)),
        // fillColor: Colours.lightBlu,
        fillColor: isEmpty == true ? Colours.lightBlu : Colors.transparent,

        errorStyle: const TextStyle(fontSize: 0),
      );
    }

    return TextFormField(
      textCapitalization: TextCapitalization.sentences,

      controller: cntrolr,
      onChanged: (val) {
        searchFn(val);
      },
      autofocus: true,
      decoration: inputDec4(isEmpty: cntrolr.text.isEmpty, hnt: hnt),
      style: t500_14.copyWith(color: const Color(0xFF1E1E1E), height: 1),
      // validator: (v) => v!.trim().isEmpty?null:getIt<StateManager>().validateFieldValues(v,type),
    );
  }
}

class AddPersonTextField extends StatelessWidget {
  // double w1p;
  // double h1p;
  final String hnt;
  final TextEditingController cntrolr;
  final bool? isNumber;
  final bool? readOnly;
  final String type;
  final Function()? ontap;
  const AddPersonTextField({
    super.key,
    // required this.h1p,
    // required this.w1p,
    required this.hnt,
    required this.cntrolr,
    this.isNumber,
    required this.type,
    this.readOnly,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        if (ontap != null) {
          ontap!();
        }
      },
      textCapitalization: TextCapitalization.sentences,
      readOnly: readOnly == true,
      controller: cntrolr,
      keyboardType: isNumber == true ? TextInputType.number : null,
      decoration: readOnly == true && ontap == null
          ? inputDec4(isEmpty: cntrolr.text.isEmpty, hnt: hnt)
          : inputDec5(isEmpty: cntrolr.text.isEmpty, hnt: hnt),
      style: t500_14.copyWith(
        color: readOnly == true && ontap == null
            ? Colors.grey.withOpacity(0.5)
            : const Color(0xFF1E1E1E),
      ),
      validator: (v) => v!.trim().isEmpty
          ? null
          : getIt<StateManager>().validateFieldValues(v, type),
    );
  }
}

class EditProfileTextFeild extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String hnt;
  final String? value;
  final TextEditingController cntrolr;
  final bool? isNumber;
  final bool readOnly;
  final String type;
  final Widget? child;
  final Function fn;
  const EditProfileTextFeild({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.hnt,
    required this.value,
    required this.cntrolr,
    this.isNumber,
    this.child,
    required this.type,
    required this.readOnly,
    required this.fn,
  });

  @override
  Widget build(BuildContext context) {
    var line = const UnderlineInputBorder(
      borderSide: BorderSide(color: Colours.lightBlu),
    );

    return Padding(
      padding: EdgeInsets.only(left: w1p * 2, right: w1p * 2, top: h1p),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hnt, style: t500_12.copyWith(color: clr444444, height: 1)),
          SizedBox(
            height: 40,
            child:
                child ??
                TextFormField(
                  textAlign: TextAlign.start,
                  textCapitalization: TextCapitalization.sentences,

                  onTap: () {
                    fn();
                  },
                  // controller:cntrolr,
                  keyboardType: isNumber == true ? TextInputType.number : null,
                  readOnly: readOnly,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 0, bottom: 8),
                    border: readOnly ? line : outLineBorder,
                    enabledBorder: readOnly ? line : outLineBorder,
                    focusedBorder: readOnly ? line : outLineBorder,
                    filled: readOnly,
                    hintText: value ?? AppLocalizations.of(context)!.add,
                    hintStyle: value == null
                        ? t500_13.copyWith(color: const Color(0xff797979))
                        : t500_14.copyWith(
                            height: 1,
                            color: const Color(0xff28318C),
                          ),
                    // fillColor: Colours.lightBlu,
                    fillColor: readOnly == true
                        ? Colors.white
                        : Colours.lightBlu,
                    errorStyle: const TextStyle(fontSize: 0),
                  ),
                  style: t500_14.copyWith(color: const Color(0xFF1E1E1E)),
                  // validator: (v) => v!.trim().isEmpty?null:getIt<StateManager>().validateFieldValues(v,type),
                ),
          ),
        ],
      ),
    );
  }
}

class EditProfileTextFeild2 extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String hnt;
  final String? value;
  final TextEditingController cntrolr;
  final bool? isNumber;
  final bool readOnly;
  final String type;
  final Widget? child;
  final Function fn;
  const EditProfileTextFeild2({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.hnt,
    required this.value,
    required this.cntrolr,
    this.isNumber,
    this.child,
    required this.type,
    required this.readOnly,
    required this.fn,
  });

  @override
  Widget build(BuildContext context) {
    // var line = const UnderlineInputBorder(borderSide: BorderSide(color: Colours.lightBlu));

    return Padding(
      padding: EdgeInsets.only(left: w1p * 2, right: w1p * 2, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hnt, style: t400_12.copyWith(color: clrFFFFFF)),
          verticalSpace(8),
          SizedBox(
            height: h1p * 5,
            child:
                child ??
                TextFormField(
                  onTap: () {
                    fn();
                  },
                  controller: cntrolr,
                  keyboardType: isNumber == true ? TextInputType.number : null,
                  readOnly: readOnly,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 8, bottom: 8),
                    border: outLineBorder,
                    enabledBorder: outLineBorder,
                    focusedBorder: outLineBorder,
                    filled: readOnly,
                    hintText: value ?? AppLocalizations.of(context)!.add,
                    hintStyle: value == null
                        ? t400_16.copyWith(color: Colors.white)
                        : t400_16.copyWith(color: Colors.white),
                    // fillColor: Colours.lightBlu,
                    fillColor: readOnly == true
                        ? Colors.transparent
                        : Colours.lightBlu,
                    errorStyle: const TextStyle(fontSize: 0),
                  ),
                  style: t500_14.copyWith(color: const Color(0xFF1E1E1E)),
                  // validator: (v) => v!.trim().isEmpty?null:getIt<StateManager>().validateFieldValues(v,type),
                ),
          ),
        ],
      ),
    );
  }
}

class CloseAlert extends StatelessWidget {
  // double w1p;
  // double h1p;
  final String? msg; // String type;
  final bool? isJustMsg;
  // String currentClinicAddress;
  // Function bookOnlineOnClick;
  // Function bookClinicOnClick;
  const CloseAlert({
    super.key,
    required this.msg,
    this.isJustMsg,
    // required this.w1p,
    // required this.h1p,
    // required this.experience,
    // required this.onlineTimeSlot,
    // required this.type,
    // required this.offlineTimeSlot,
    // required this.currentClinicAddress,
    // required this.bookOnlineOnClick,
    // required this.bookClinicOnClick,
  });

  @override
  Widget build(BuildContext context) {
    String msgss = msg ?? "";

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        AppLocalizations.of(context)!.warning,
        style: TextStyles.textStyle3c,
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(msgss),

              // verticalSpace(h1p),
              // Text(msg),
            ],
          ),

          // height: h1p*80,
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colours.toastBlue),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 5,
              ),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: t500_16.copyWith(color: clr444444),
              ),
            ),
          ),
        ),
        isJustMsg == true
            ? const SizedBox()
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // gradient: linearGrad
                  color: Colours.toastRed,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28.0,
                      vertical: 5,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.proceed,
                      style: t500_16,
                    ),
                  ),
                ),
              ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 18.0),
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

class TermsAndConditions extends StatelessWidget {
  final Function onTap;
  final bool isAgreed;

  const TermsAndConditions({
    super.key,
    required this.onTap,
    required this.isAgreed,
  });

  @override
  Widget build(BuildContext context) {
    // checkBox(bool agreed) {
    //   return SizedBox(
    //       height: 20,
    //       width: 20,
    //       child: Stack(
    //         alignment: Alignment.center,
    //         children: [
    //           if (!agreed)
    //             SizedBox(
    //               height: 20,
    //               width: 20,
    //               child: Image.asset(
    //                 fit: BoxFit.contain,
    //                 "assets/images/checkterms-layer.png",
    //                 color: clrA8A8A8,
    //               ),
    //             ),
    //           agreed
    //               ? SizedBox(
    //                   height: 20,
    //                   width: 20,
    //                   child: Image.asset(
    //                     fit: BoxFit.contain,
    //                     "assets/images/checkterms-check.png",
    //                   ),
    //                 )
    //               : const SizedBox(),
    //         ],
    //       ));
    // }

    Future<void> launchInWebView(Uri url) async {
      if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
        throw Exception('Could not launch $url');
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   children: [
        //     InkWell(
        //       splashColor: Colors.transparent,
        //       highlightColor: Colors.transparent,
        //       onTap: () {
        //         onTap();
        //       },
        //       child: SizedBox(
        //           // width: w1p*15,

        //           child: checkBox(isAgreed)),
        //     ),
        //     horizontalSpace(4),
        //     Text(
        //       "Data and Privacy",
        //       style: t400_14.copyWith(color: const Color(0xff000000)),
        //     ),
        //   ],
        // ),
        // verticalSpace(12),
        // Text("Your consultations are private and confidential. To enhance service quality, dq's medical team may conduct regular anonymous reviews.", style: t400_14.copyWith(color: clr858585)),
        verticalSpace(4),
        RichText(
          text: TextSpan(
            text: "By proceeding with a consultation, you agree to ",
            style: t400_11.copyWith(color: clr858585, height: 1.5),
            children: [
              TextSpan(
                text: "dq app's Terms of Use.",
                style: t400_11.copyWith(
                  color: const Color(0xff008BD0),
                  height: 1.5,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Uri url = Uri.parse(
                      '${StringConstants.baseUrl}/terms_and_conditions',
                    );
                    launchInWebView(url);
                  },
              ),
            ],
          ),
        ),
        // verticalSpace(4),
      ],
    );
  }
}

class FollowUpFeatureMessage extends StatelessWidget {
  final String txt;

  const FollowUpFeatureMessage(this.txt, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: clrEAF9FF,
        borderRadius: BorderRadius.circular(13),
      ),
      height: 60,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 34,
              height: 34,
              child: Image.asset("assets/images/schedule-calender-icon.png"),
            ),
          ),
          // horizontalSpace(8),
          Expanded(
            child: SizedBox(
              child: Text(
                txt,
                style: t400_14.copyWith(color: clr2D2D2D, height: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedPopup extends StatefulWidget {
  final Widget child;

  const AnimatedPopup({super.key, required this.child});

  @override
  State<AnimatedPopup> createState() => _AnimatedPopupState();
}

class _AnimatedPopupState extends State<AnimatedPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}

class DoctorDetailsCard extends StatelessWidget {
  final Doctors? instantDocData;
  final DocDetailsModel? scheduledDocData;
  final String? primaryAchievement;
  final String? secondaryAchievement;
  final double? rating;
  final double w1p;
  final double h1p;

  const DoctorDetailsCard({
    super.key,
    this.instantDocData,
    this.scheduledDocData,
    required this.w1p,
    required this.h1p,
    this.primaryAchievement,
    this.secondaryAchievement,
    this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    dynamic data = instantDocData ?? scheduledDocData!;
    final fullName = '${data.firstName ?? ''} ${data.lastName ?? ''}';
    final imageUrl = data.image;
    final qualification = data.qualification ?? "N/A";
    final experience = data.experience ?? "N/A";
    final bookingCount = data.completedBookingCount ?? 0;
    final education = data.education ?? [];
    final experiences = data.experiences ?? [];
    final awards = data.awards ?? [];
    final memberships = data.memberships ?? [];
    final services = data.services ?? [];
    final languages = data.languages ?? [];
    final about = data.description ?? "";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: Colors.red),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Doctor Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: h1p * 20,
                      width: w1p * 40,
                      child: HomeWidgets().cachedImg(
                        imageUrl ?? '',
                        placeholderImage:
                            'assets/images/doctor-placeholder.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name and Title
                  Text(fullName, style: t700_22.copyWith(color: clr202020)),

                  const SizedBox(height: 8),
                  Text(
                    qualification,
                    style: t400_14.copyWith(color: clrA8A8A8),
                    textAlign: TextAlign.center,
                  ),
                  if (primaryAchievement != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            clrFFFFFF,
                            const Color(0xFFFFB60C).withOpacity(.2),
                            clrFFFFFF,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            size: 14,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              primaryAchievement ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: t500_13.copyWith(
                                color: const Color(0xFF2E3192),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (secondaryAchievement != null) ...[
                    // const SizedBox(height: 8),
                    Container(
                      // margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1EFFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        secondaryAchievement ?? '',
                        style: t500_14.copyWith(color: clr2D2D2D),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  _buildInfoCards(
                    experience,
                    bookingCount.toString(),
                    rating?.toString() ?? '0',
                  ),

                  // const SizedBox(height: 20),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: clr00C165.withOpacity(.3)),
                  //   child: Text('Experience: $experience', style: t400_16.copyWith(color: clr202020)),
                  // ),
                  // const SizedBox(height: 8),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     Expanded(
                  //       child: Container(
                  //         padding: const EdgeInsets.all(12),
                  //         decoration: BoxDecoration(
                  //           color: clrF98E95.withOpacity(0.3),
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //         child: Row(
                  //           children: [
                  //             Icon(Icons.person, color: clr6C6EB8),
                  //             const SizedBox(width: 8),
                  //             Expanded(
                  //               child: Text(
                  //                 gender,
                  //                 style: t500_14.copyWith(color: clr202020),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 12),
                  //     Expanded(
                  //       child: Container(
                  //         padding: const EdgeInsets.all(12),
                  //         decoration: BoxDecoration(
                  //           color: clr6C6EB8.withOpacity(0.3),
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //         child: Row(
                  //           children: [
                  //             Icon(Icons.check_circle, color: clrF98E95),
                  //             const SizedBox(width: 8),
                  //             Expanded(
                  //               child: Text(
                  //                 '$bookingCount Patients',
                  //                 style: t500_14.copyWith(color: clr202020),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  verticalSpace(16),

                  // About
                  if (about != '') ...[
                    _buildSectionTitle("About"),
                    GenericExpandableText(
                      textAlign: TextAlign.justify,
                      about,
                      style: t400_14.copyWith(color: clr2D2D2D),
                      readlessColor: Colours.primaryblue,
                      readmoreColor: Colours.primaryblue,
                      hasReadMore: true,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Languages
                  if (languages.isNotEmpty) ...[
                    _buildSectionTitle("Languages Spoken"),
                    verticalSpace(2),
                    // ...languages.map((l) => _buildLanguageTile(l)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (var i = 0; i < languages.length; i++)
                            Chip(
                              label: Text(languages[i].languageTitle ?? ''),
                              side: BorderSide(color: clr2D2D2D.withAlpha(40)),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Education
                  if (education.isNotEmpty) ...[
                    _buildSectionTitle("Education"),
                    ...education.map((edu) => _buildEducationTile(edu)),
                    const SizedBox(height: 16),
                  ],

                  // Experience
                  if (experiences.isNotEmpty) ...[
                    _buildSectionTitle("Experience"),
                    ...experiences.map((exp) => _buildExperienceTile(exp)),
                    const SizedBox(height: 16),
                  ],

                  // Awards
                  if (awards.isNotEmpty) ...[
                    _buildSectionTitle("Awards"),
                    ...awards.map(
                      (a) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                        ),
                        title: Text(
                          a.awardTitle ?? '',
                          style: t500_16.copyWith(color: clr2D2D2D),
                        ),
                        subtitle: Text(
                          a.receivedDate ?? '',
                          style: t400_14.copyWith(color: clrA8A8A8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Memberships
                  if (memberships.isNotEmpty) ...[
                    _buildSectionTitle("Memberships"),
                    ...memberships.map(
                      (m) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.verified, color: Colors.teal),
                        title: Text(
                          m.membershipTitle ?? '',
                          style: t500_16.copyWith(color: clr2D2D2D),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#${m.membershipId ?? ''}',
                              style: t500_14.copyWith(color: clrA8A8A8),
                            ),
                            Text(
                              m.receivedDate ?? '',
                              style: t400_14.copyWith(color: clrA8A8A8),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Services
                  if (services.isNotEmpty) ...[
                    _buildSectionTitle("Services"),
                    verticalSpace(2),
                    ...services.map((s) => _buildServiceTile(s)),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: t700_18.copyWith(color: clr202020)),
    );
  }

  Widget _buildEducationTile(Education edu) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.school, color: clr6C6EB8),
      title: Text(
        edu.specialization ?? '',
        style: t500_16.copyWith(color: clr2D2D2D),
      ),
      subtitle: Text(
        '${edu.college ?? ''} • ${edu.monthYearOfCompletion ?? ''}',
        style: t400_14.copyWith(color: clrA8A8A8),
      ),
    );
  }

  Widget _buildServiceTile(Services s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.circle_rounded, color: clrA8A8A8, size: 8),
          horizontalSpace(8),
          Text(s.serviceTitle ?? '', style: t500_14.copyWith(color: clr2D2D2D)),
        ],
      ),
    );
  }

  Widget _buildExperienceTile(Experiences exp) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.local_hospital, color: clrF98E95),
      title: Text(
        exp.designation ?? '',
        style: t500_16.copyWith(color: clr2D2D2D),
      ),
      subtitle: Text(
        '${exp.hospitalName ?? ''}\n${exp.location ?? ''}',
        style: t400_14.copyWith(color: clrA8A8A8),
      ),
    );
  }

  Widget _buildInfoCards(
    String experience,
    String bookingCount,
    String rating,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoCard(
          icon: Icons.psychology_rounded,
          value: experience,
          label: 'Experience',
          iconColor: const Color(0xFF4A90E2),
        ),
        _buildInfoCard(
          icon: Icons.groups,
          value: bookingCount,
          label: 'Patients',
          iconColor: const Color(0xFF00B894),
        ),
        _buildInfoCard(
          icon: Icons.star,
          value: rating,
          label: 'Ratings',
          iconColor: const Color(0xFFFFC107),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: clrF98E95.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(value, style: t500_14.copyWith(color: clr202020)),
            Text(label, style: t400_12.copyWith(color: clrA8A8A8)),
          ],
        ),
      ),
    );
  }
}
