import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/core/single_appoinment_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/images_open_widget.dart';
import 'drawer_menu_screens_widgets.dart';

class BookingDetailsScreen extends StatefulWidget {
  final int? bookingId;
  final bool? isConsulted;
  final Function()? goToChatFn;
  const BookingDetailsScreen({
    super.key,
    required this.bookingId,
    this.isConsulted,
    this.goToChatFn,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  void initState() {
    getIt<BookingManager>().getAppoinmentDetails(
      appoinmentId: widget.bookingId!,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var grad1 = LinearGradient(colors: [Color(0xff9E74F8), Color(0xff8F5BFE)]);
    // var grad2 = LinearGradient(colors: [Color(0xff4D51C7), Color(0xff2E3192)]);
    // var grad3 = RadialGradient(colors: [Color(0xffFFFFFF), Color(0xffCBCBCB)]);

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        Widget headtext(String txt) {
          return Container(
            width: maxWidth,
            margin: const EdgeInsets.only(bottom: 4, top: 6),
            decoration: BoxDecoration(
              // color: clrC4C4C4.withOpacity(0.1),
              gradient: LinearGradient(
                colors: [
                  // clrC4C4C4.withOpacity(0.5),
                  clr8467A6.withOpacity(0.05),
                  clr8467A6.withOpacity(0.05),
                  // Colors.transparent,
                  // Colors.transparent
                ],
                begin: Alignment.centerLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
              child: Text(txt, style: t500_12.copyWith(color: clr2D2D2D)),
            ),
          );
        }

        Widget valueText(String txt) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
            child: Text(txt, style: t400_14.copyWith(color: clr757575)),
          );
        }

        Widget paymentRow(String head, double value, {bool isBold = false}) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  head,
                  style: isBold
                      ? t500_14.copyWith(color: clr202020)
                      : t400_14.copyWith(color: clr757575),
                ),
                Text(
                  '₹${value.toString()}',
                  style: isBold
                      ? t700_14.copyWith(color: clr202020)
                      : t500_14.copyWith(color: clr757575),
                ),
              ],
            ),
          );
        }
        // detailsRow({
        //   required String icon,
        //   required String value,
        // }) {
        //   return Padding(
        //     padding: const EdgeInsets.only(bottom: 10.0),
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       // crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         SizedBox(
        //             height: 10,
        //             child: SvgPicture.asset(
        //               icon,
        //             )),
        //         SizedBox(
        //           width: w1p,
        //         ),
        //         SizedBox(
        //           width: w10p * 5,
        //           child: Text(
        //             value,
        //             style: TextStyles.textStyle72,
        //           ),
        //         )
        //       ],
        //     ),
        //   );
        // }

        // bookOnlineOnClick() async {}
        // bookClinicOnClick() async {}

        return Consumer<BookingManager>(
          builder: (context, mgr, child) {
            SingleAppoinmentModel? data = mgr.appointmentModel;

            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              appBar: getIt<SmallWidgets>().appBarWidget(
                title: AppLocalizations.of(context)!.appoinments,
                height: h10p,
                width: w10p,
                fn: () {
                  Navigator.pop(context);
                },
              ),
              body: mgr.profileLoader
                  ? myLoader(visibility: true)
                  : mgr.appointmentModel == null
                  ? Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.appoinmentDetailsNotAvail,
                          style: TextStyles.notAvailableTxtStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Builder(
                      builder: (context) {
                        String? appoinmentId = data?.bookings?.appointmentId;
                        String? typeOfConsult = data?.bookings?.bookingType;
                        String? docImg = data?.bookings?.doctorImage;
                        String? patientName =
                            '${data?.bookings?.patientFirstName ?? ""} ${data?.bookings?.patientLastname ?? ""}';
                        String? gender = data?.bookings?.patientGender;
                        String? docName = data?.bookings?.doctorFirstName;
                        String? docName2 = data?.bookings?.doctorLastname;
                        String? docType = data?.bookings?.doctorQualification;
                        bool? isPackageBooking =
                            data?.bookings?.isPackageBooking;
                        double consultationAmount =
                            data?.bookings?.consultationAmount ?? 0;
                        double discountAmount =
                            data?.bookings?.discountAmount ?? 0;
                        double couponAppliedAmount =
                            data?.bookings?.couponAppliedAmount ?? 0;
                        double platformFee = data?.bookings?.platformFee ?? 0;
                        double tax = data?.bookings?.tax ?? 0;
                        double paidAmount = data?.bookings?.paidAmount ?? 0;
                        String? clinicAddress = data?.bookings?.clinicName;
                        List<PrescriptionImg> priscriptions =
                            data?.bookings?.prescriptions ?? [];
                        String? appoinmentDate = getIt<StateManager>()
                            .convertStringDateToyMMMMd(data!.bookings!.date!);
                        String? appoinmentTime = getIt<StateManager>()
                            .convertTime(data.bookings!.time!);
                        String? appoinmentdatetime =
                            "$appoinmentTime, $appoinmentDate";
                        return Entry(
                          xOffset: 1000,
                          // scale: 20,
                          delay: const Duration(milliseconds: 0),
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.ease,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: w1p * 6,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          headtext(
                                            AppLocalizations.of(
                                              context,
                                            )!.bookingDetails,
                                          ),
                                          valueText(
                                            '${AppLocalizations.of(context)!.appointmentId} : $appoinmentId',
                                          ),

                                          // Divider(color: Colours.lightGrey,),
                                          headtext(
                                            AppLocalizations.of(context)!.time,
                                          ),
                                          valueText(appoinmentdatetime),
                                          // Divider(color: Colours.lightGrey,),
                                          headtext(
                                            AppLocalizations.of(
                                              context,
                                            )!.typeOfAppoinment,
                                          ),
                                          valueText(typeOfConsult ?? ""),
                                          // Divider(color: Colours.lightGrey,),
                                          data.bookings?.doctorId == null
                                              ? const SizedBox()
                                              : headtext(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.doctorDetails,
                                                ),
                                          verticalSpace(h1p * 1),
                                          data.bookings?.doctorId == null
                                              ? const SizedBox()
                                              : Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom: h1p * 2,
                                                  ),
                                                  child: DocItem(
                                                    img: docImg ?? "",
                                                    h1p: h1p,
                                                    w1p: w1p,
                                                    currentClinicAddress:
                                                        clinicAddress ?? "",
                                                    fname: docName ?? "",
                                                    lname: docName2 ?? "",
                                                    type: docType ?? "",
                                                  ),
                                                ),
                                          data.bookings?.clinicName == null
                                              ? const SizedBox()
                                              : headtext(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.clinicDetails,
                                                ),

                                          verticalSpace(h1p * 1),
                                          data.bookings?.clinicName == null
                                              ? const SizedBox()
                                              : Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom: h1p * 2,
                                                  ),
                                                  child: ClinicBox(
                                                    h1p: h1p,
                                                    w1p: w1p,
                                                    clinicName:
                                                        data
                                                            .bookings
                                                            ?.clinicName ??
                                                        "",
                                                    clinicAddress1: getIt<StateManager>()
                                                        .buildAddress([
                                                          data
                                                              .bookings
                                                              ?.clinicAddress1,
                                                          data
                                                              .bookings
                                                              ?.clinicAddress2,
                                                          data
                                                              .bookings
                                                              ?.clinicCity,
                                                          data
                                                              .bookings
                                                              ?.clinicCity,
                                                          data
                                                              .bookings
                                                              ?.clinicCountry,
                                                          data
                                                              .bookings
                                                              ?.clinicState,
                                                          data
                                                              .bookings
                                                              ?.clinicPincode,
                                                        ]),
                                                    lat: data
                                                        .bookings
                                                        ?.clinicLatitude,
                                                    long: data
                                                        .bookings
                                                        ?.clinicLongitude,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: w1p * 6,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          headtext(
                                            AppLocalizations.of(
                                              context,
                                            )!.patientName,
                                          ),
                                          valueText(patientName),

                                          // Divider(color: Colours.lightGrey,),
                                          headtext(
                                            AppLocalizations.of(
                                              context,
                                            )!.gender,
                                          ),

                                          valueText(gender ?? ""),
                                          headtext(
                                            AppLocalizations.of(
                                              context,
                                            )!.paymentDetails,
                                          ),
                                          isPackageBooking ?? false
                                              ? Container(
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                      ),
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.grey
                                                          .withOpacity(.3),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    "This appointment is covered by your current package.",
                                                    style: t400_14.copyWith(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: clrFE9297
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    border: Border.all(
                                                      color: clrD9D9D9,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      paymentRow(
                                                        'Consultation Amount',
                                                        consultationAmount,
                                                      ),
                                                      if (discountAmount != 0.0)
                                                        paymentRow(
                                                          'Discount Amount',
                                                          discountAmount,
                                                        ),
                                                      if (couponAppliedAmount !=
                                                          0.0)
                                                        paymentRow(
                                                          'Coupon Applied Amount',
                                                          couponAppliedAmount,
                                                        ),
                                                      paymentRow(
                                                        'Platform Fee',
                                                        platformFee,
                                                      ),
                                                      paymentRow('Tax', tax),
                                                      paymentRow(
                                                        'Paid Amount',
                                                        paidAmount,
                                                        isBold: true,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    data.bookings?.cancellationStatus == 0
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: w1p * 6.0,
                                              vertical: h1p * 5,
                                            ),
                                            child: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.bookingCancelled,
                                              style: TextStyles.textStyle11d,
                                            ),
                                          )
                                        : const SizedBox(), //cancelled booking

                                    priscriptions.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () {
                                              // showModalBottomSheet(context: context, builder: (context){
                                              //   return NetworkImageList(priscriptions.map((e)=>e.prescriptionImage!).toList());
                                              // });

                                              var urls = priscriptions
                                                  .map(
                                                    (e) =>
                                                        '${StringConstants.baseUrl}${e.prescriptionImage}',
                                                  )
                                                  .toList();

                                              showModalBottomSheet(
                                                backgroundColor: Colors.white,
                                                isScrollControlled: true,
                                                showDragHandle: true,
                                                barrierColor: Colors.white,
                                                useSafeArea: true,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                                // showDragHandle: true,
                                                context: context,
                                                builder: (context) =>
                                                    // PhotoViewContainer(w1p: w1p,h1p: h1p,url: url!)
                                                    GalleryImageViewWrapper(
                                                      paginationFn: () {
                                                        // print("jfdfahdjsfhsadjfasf");
                                                        // getIt<CordManager>().incrementPageIndex();
                                                        // getIt<CordManager>().getGalleryImages();
                                                      },
                                                      titleGallery: 'Gallery',
                                                      galleryItems: urls.map((
                                                        e,
                                                      ) {
                                                        // var indxx = urls.indexOf(e);

                                                        return GalleryItemModel(
                                                          id: getIt<StateManager>()
                                                              .generateRandomString(),
                                                          index: 0,
                                                          imageUrl: e,
                                                        );
                                                      }).toList(),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      initialIndex: 0,
                                                      loadingWidget: null,
                                                      errorWidget: null,
                                                      maxScale: 10,
                                                      minScale: 0.5,
                                                      reverse: false,
                                                      showListInGalley: false,
                                                      showAppBar: false,
                                                      closeWhenSwipeUp: false,
                                                      closeWhenSwipeDown: true,
                                                      radius: 5,
                                                      imageList: urls,
                                                    ),
                                              );
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(18),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                color: Colors.white,
                                                boxShadow: [boxShadow7],
                                              ),
                                              // height:100,
                                              width: 150,
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  18.0,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 50,
                                                      child: Image.asset(
                                                        "assets/images/medical-prescription.png",
                                                        color: Colors.blueGrey,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Prescriptions",
                                                          style: t700_14
                                                              .copyWith(
                                                                color:
                                                                    const Color(
                                                                      0xff474747,
                                                                    ),
                                                              ),
                                                        ),
                                                        const Icon(
                                                          Icons.arrow_forward,
                                                          color:
                                                              Colors.blueGrey,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),

                                    // Spacer(),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: h1p * 5,
                                ),
                                child: Row(
                                  children: [
                                    widget.isConsulted == true &&
                                            widget.goToChatFn != null
                                        ? Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                widget.goToChatFn!();
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: w1p * 6,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    // color: Colours.primaryblue.withOpacity(0.05),
                                                    border: Border.all(
                                                      color: const Color(
                                                        0xff2E3192,
                                                      ),
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          child: Image.asset(
                                                            "assets/images/chat-icon.png",
                                                            color: const Color(
                                                              0xff2E3192,
                                                            ),
                                                            height: 20,
                                                          ),
                                                        ),
                                                        horizontalSpace(
                                                          w1p * 2,
                                                        ),
                                                        Text(
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.goToChat,
                                                          style: TextStyles
                                                              .textStyle11c,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : data.bookings?.cancellationStatus == 1
                                        ? Expanded(
                                            child: GestureDetector(
                                              onTap: () async {
                                                bool? popRes = await showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return WarningPopUp(
                                                      msg: AppLocalizations.of(
                                                        context,
                                                      )!.areYouSureWantToCancelThisBooking,
                                                      proceedBtnText:
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.proceed,
                                                      cancelBtnText:
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.back,
                                                    );
                                                  },
                                                );

                                                if (popRes != null) {
                                                  var result =
                                                      await getIt<
                                                            BookingManager
                                                          >()
                                                          .cancelBooking(
                                                            bookingId: widget
                                                                .bookingId!,
                                                          );
                                                  if (result.status == true) {
                                                    getIt<BookingManager>()
                                                        .getAppoinmentDetails(
                                                          appoinmentId:
                                                              widget.bookingId!,
                                                        );

                                                    Fluttertoast.showToast(
                                                      msg: result.message ?? "",
                                                    );
                                                  } else {
                                                    Fluttertoast.showToast(
                                                      msg: result.message ?? "",
                                                    );
                                                  }
                                                }
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: w1p * 6,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: const Color(
                                                        0xffEB0000,
                                                      ),
                                                      width: 0.5,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    color: const Color(
                                                      0xffFFF9F9,
                                                    ),
                                                    boxShadow: [boxShadow9],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12.0,
                                                          vertical: 8,
                                                        ),
                                                    child: Center(
                                                      child: Text(
                                                        AppLocalizations.of(
                                                          context,
                                                        )!.cancelBooking,
                                                        style: TextStyles
                                                            .textStyle11d,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            );
          },
        );
      },
    );
  }
}
