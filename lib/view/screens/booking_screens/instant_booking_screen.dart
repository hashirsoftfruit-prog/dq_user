// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/controller/services/payment_service.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/model/core/other_patients_response_model.dart';
import 'package:dqapp/view/screens/booking_screens/package_details_screen.dart';
import 'package:dqapp/view/screens/booking_screens/patient_details_form_screen.dart';
import 'package:dqapp/view/screens/home_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../controller/managers/state_manager.dart';
import '../../../model/core/available_doctors_response_model.dart';
import '../../../model/core/booking_request_data_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/common_widgets.dart';
import 'booking_screen_widgets.dart';
import 'confirm_patient_details_popup.dart';

//BOOKING SCREENS ARE CODED AS 2 SECTIONS ONE FOR SHOWING THE PATIENT DETAILS,DOCTORS AND PACKAGES. ON THE SECOND SECTION THE BILL DETAILS AND PAYMENT SETUP ARE DONE
//THE SECOND SECTION IS SAME FOR ALL KIND OF BOOKING WHICH IS CODED ON FILE ConfirmPatientDetails() (confirm_patient_details_popup.dart)

class BookingScreen extends StatefulWidget {
  final int specialityId;
  final int? subCatId;
  final int? subspecialityId;
  final int? psychologyType;
  final String itemName;
  // bool? pkgAvailability;

  const BookingScreen({
    super.key,
    required this.specialityId,
    required this.itemName,
    required this.subCatId,
    this.subspecialityId,
    this.psychologyType,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with TickerProviderStateMixin {
  bool agreeTerms = true;
  var scollCntr = ScrollController();
  final _scrollController = ScrollController();
  dynamic billResponse;
  bool backFromButton = false;
  // void scrollToSelectedItem(int index) {
  //   // Calculate the offset
  //   double offset = index * 80.0; // Approximate height of each item
  //   _scrollController.animateTo(
  //     offset,
  //     duration: Duration(milliseconds: 500),
  //     curve: Curves.easeInOut,
  //   );
  // }
  @override
  void initState() {
    initFns();
    backFromButton = false;
    Future.delayed(Duration.zero, () async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getIt<BookingManager>().setPrefferedLanguage(
          StringConstants.dPrefNoPref,
        );
        getIt<BookingManager>().setBackCalled(false);
        getIt<BookingManager>().setPaymentInitiated(false);
        getIt<BookingManager>().setPrefferedDocGender(
          StringConstants.dPrefNoPref,
        );
      });
      // getIt<BookingManager>().selectPriceCategory(DoctorCatogory(title: StringConstants.dPrefNoPref, consultationCategory: 0, doctors: getIt<BookingManager>().docsData?.doctors));
    });
    // scollCntr.addListener(_scrollListener);
    super.initState();
  }

  initFns() async {
    log("message bill details called 1111");
    await getIt<BookingManager>().getPatientsDetailsList();
    // await getIt<BookingManager>().getBillDetails(spID:widget.specialityId,doctorId: null,type: null );
    // if(widget.docsData.packageAvailability!=true){}
    log("message bill details called 22222");
    getBillDetails();
    log("message bill details called 3333");
    await getIt<BookingManager>().getPackages(
      widget.specialityId,
      widget.subspecialityId,
    );

    log("message bill details called 4444");
  }

  getBillDetails() async {
    int patientId =
        getIt<SharedPreferences>().getInt(StringConstants.patientId) ?? 0;

    final patientDetails = getIt<BookingManager>().selectedPatientDetails;
    if (patientDetails != null) {
      patientId = patientDetails.appUserId!;
    }
    billResponse = await getIt<BookingManager>().getBillDetails(
      spID: widget.specialityId,
      type: null,
      doctorId: null,
      consultationCategoryForInstantCall: getIt<BookingManager>()
          .docsData
          ?.selectedPriceCategory
          ?.consultationCategory,
      couponCode: getIt<BookingManager>().selectedCoupon?.couponCode,
      isSeniorCitizenConsultation:
          getIt<BookingManager>().docsData!.seniorCitizen == true &&
          getIt<BookingManager>().docsData!.isAgeProofSubmitted == true &&
          getIt<BookingManager>().docsData!.isFreeDoctorAvailable == true,
      packageDetails: getIt<BookingManager>().selectedPkg?.packageDetails,
      subSpecialityID: widget.subspecialityId,
      patientId: patientId,
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    scollCntr.dispose();
    getIt<BookingManager>().disposeBooking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String label = StringConstants.tempIconViewStatus == true ? 'DQ' : 'Medico';

    List<Color> colors = widget.psychologyType != null
        ? [clrF98E95, clrBD6273]
        : [clr8467A6, clr5D5AAB];

    int? userId = getIt<SharedPreferences>().getInt(StringConstants.userId);
    var locale = AppLocalizations.of(context);

    List<String> langs = [StringConstants.dPrefNoPref, "English", "Malayalam"];
    List<String> genderPrefs = [
      StringConstants.dPrefNoPref,
      StringConstants.dPrefMale,
      StringConstants.dPrefFemale,
    ];
    List<String> consultOthers = ["Father", "Mother", "Spouse", "Other"];

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        Widget doctorCategory({
          required DoctorCatogory? category,
          required DoctorCatogory? selectedCategory,
        }) {
          String? title = category?.title;
          bool isFreeConsultation =
              getIt<BookingManager>().docsData!.seniorCitizen == true &&
              getIt<BookingManager>().docsData!.isAgeProofSubmitted == true &&
              getIt<BookingManager>().docsData!.isFreeDoctorAvailable == true;
          bool isDoctorExist =
              category?.doctors != null &&
              category!.doctors!.isNotEmpty &&
              isFreeConsultation != true;
          bool isSeleccted = !isFreeConsultation
              ? selectedCategory?.consultationCategory ==
                    category?.consultationCategory
              : false;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (isDoctorExist) {
                  getIt<BookingManager>().selectPriceCategory(category);
                  getBillDetails();
                }
              },
              child: Opacity(
                opacity: isDoctorExist ? 1 : 0.6,
                child: Container(
                  height: 28,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: isSeleccted ? clrEEEFFF : clrFFFFFF,
                    border: Border.all(
                      color: isSeleccted ? clr2E3192 : clrC4C4C4,
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2.0,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 21,
                          height: 21,
                          child: Image.asset("assets/images/rupees-sign.png"),
                        ),
                        horizontalSpace(6),
                        Text(
                          title ?? '',
                          style: t400_14.copyWith(
                            color: isSeleccted ? clr2E3192 : clr858585,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        removepkgFn() async {
          getIt<BookingManager>().setSelectedPackage(null);
          getIt<BookingManager>().setLoaderActive(true);
          await Future.delayed(const Duration(milliseconds: 500), () {
            getIt<BookingManager>().setLoaderActive(false);
          });
        }

        selectionBox(String e, bool selected) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: selected
                ? BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 1,
                        blurRadius: 1,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(containerRadius / 3),
                  )
                : BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(containerRadius / 2),
                  ),
            child: pad(
              horizontal: w1p * 2,
              vertical: h1p,
              child: Text(
                getIt<StateManager>().capitalizeFirstLetter(e),
                style: selected
                    ? t500_15.copyWith(
                        color: const Color(0xff5054e5),
                        height: 1,
                      )
                    : t500_14.copyWith(color: clr444444, height: 1),
              ),
            ),
          );
        }

        Future<bool?> refreshDocData({
          required int? userId,
          required String? genderPref,
          required String? slotPref,
        }) async {
          var result = await getIt<BookingManager>().getDocsList(
            specialityId: widget.specialityId,
            userId: userId,
            genderPref: genderPref,
            slotPref: slotPref,
            typeOfPsychology: widget.psychologyType,
            subSpecialityId: widget.subspecialityId,
          );

          if (result.status == true && result.isAnyDoctorExist == true) {
            getIt<BookingManager>().setDocsData(result);

            return true;
          } else {
            showTopSnackBar(
              snackBarPosition: SnackBarPosition.bottom,
              padding: const EdgeInsets.all(30),
              Overlay.of(context),
              ErrorToast(maxLines: 3, message: result.message ?? ""),
            );
            return false;
          }
        }

        // payBtn({
        //   UserDetails? usrD,
        //   required bool loader,
        //   // required String amt,
        //   // required BillResponseModel bill,
        //   required BookingDetailsItem bDetails,
        //   required SelectedPackageModel? selectedPackage,
        // }) {
        //   return ButtonWidget(
        //       isLoading: loader,
        //       ontap: () async {
        //         var billResponse = await getIt<BookingManager>().getBillDetails(
        //           spID: bDetails.specialityId!,
        //           type: null,
        //           doctorId: null,
        //           consultationCategoryForInstantCall: bDetails.selectedPriceCategory,
        //           couponCode: null,
        //           isSeniorCitizenConsultation: bDetails.seniorCitizenFreeConsultation,
        //           packageDetails: selectedPackage?.packageDetails,
        //           subSpecialityID: bDetails.subSpecialityId,
        //         );
        //         if (agreeTerms == true && usrD != null && billResponse.status == true) {
        //           showModalBottomSheet(
        //               backgroundColor: Colors.white,
        //               isScrollControlled: true,
        //               useSafeArea: true,
        //               showDragHandle: true,
        //               context: context,
        //               builder: (context) => ConfirmPatientDetails(
        //                     maxWidth: maxWidth,
        //                     maxHeight: maxHeight,
        //                     userData: usrD,
        //                     dataForInstantBooking: bDetails,
        //                     dataForScheduledBooking: null,
        //                     dataForPsychologyInstantBooking: null,
        //                     isScheduledBooking: false,
        //                   ));
        //         } else {
        //           showTopSnackBar(
        //               Overlay.of(context),
        //               SuccessToast(
        //                   message: billResponse.status == false
        //                       ? billResponse.message ?? ""
        //                       : agreeTerms != true
        //                           ? locale!.youMustAgreeTermsAndConditions
        //                           : locale!.selectPatientToContinue));
        //         }
        //       },
        //       btnText: "Continue");
        // }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            final bookingManager = getIt<BookingManager>();

            final bool isPaymentInProgress =
                bookingManager.isPaymentOnProcess ||
                bookingManager.proceedLoader;
            final bool isBackCalled = bookingManager.isBackCalled;
            final bool isPaymentInitiated =
                bookingManager.isPaymentFlowInitiated;

            // 🧾 Handle payment in progress
            if (isPaymentInProgress && !isBackCalled) {
              if (Platform.isAndroid) {
                final backPressResult = await PaymentService.instance.hyperSDK
                    .onBackPress();

                log("🔙 HyperSDK back press result: $backPressResult");

                if (backPressResult.toLowerCase() == "true") {
                  log("✅ Back press allowed — disposing bill screen");
                  bookingManager.disposeBillScreen();
                  if (context.mounted) Navigator.of(context).pop();
                } else {
                  log("🚫 Back press blocked — payment still in progress");
                }
              }
              return; // Don’t auto-pop
            }

            // 🧾 No payment in progress — normal back navigation
            log("↩️ No active payment, proceeding with back navigation");
            bookingManager.disposeBillScreen();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted &&
                  !isPaymentInitiated &&
                  !Platform.isIOS &&
                  !isBackCalled &&
                  !backFromButton) {
                bookingManager.setBackCalled(true);
                log("🔙 Navigating back from bill screen");
                Navigator.of(context).pop();
              }
            });
          },

          child: Consumer<BookingManager>(
            builder: (context, mgr, child) {
              // DoctorCatogory feeRangeNoPrefDoctors = DoctorCatogory(title: StringConstants.dPrefNoPref, consultationCategory: 0, doctors: mgr.docsData?.doctors);

              return Scaffold(
                extendBody: true,
                extendBodyBehindAppBar: true,
                backgroundColor: Colors.white,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                body: mgr.isPaymentOnProcess || mgr.proceedLoader
                    ? const Center(child: LogoLoader())
                    : CustomScrollView(
                        controller: scollCntr,
                        slivers: [
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            expandedHeight: 100,
                            collapsedHeight: 90,
                            pinned: true,
                            flexibleSpace: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: colors),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w1p * 4,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          backFromButton = true;
                                        });
                                        Navigator.pop(context);
                                        // Navigator.popUntil(context, ModalRoute.withName(RouteNames.home));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                              child: Image.asset(
                                                "assets/images/back-cupertino.png",
                                                color: Colors.white,
                                                // colorFilter: ColorFilter.mode(
                                                //     clrFFFFFF, BlendMode.srcIn),
                                              ),
                                            ),
                                            horizontalSpace(12),
                                            Text(
                                              "Instant Consultations",
                                              style: t500_20,
                                            ),
                                            // Text(
                                            //       "Consultations",
                                            //       style: t500_20,
                                            //     ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // const Spacer(),
                                    verticalSpace(12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(widget.itemName, style: t400_18),
                                      ],
                                    ),
                                    verticalSpace(16),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate([
                              Entry(
                                // xOffset: 500,
                                // // scale: 20,
                                // delay: const Duration(milliseconds: 0),
                                // duration: const Duration(milliseconds: 1000),
                                // curve: Curves.ease,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 4,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      verticalSpace(16),
                                      Text(
                                        locale!.preferredLanguage,
                                        style: t500_14.copyWith(
                                          color: clr2D2D2D,
                                        ),
                                      ),
                                      verticalSpace(h1p),
                                      Wrap(
                                        children: langs
                                            .map(
                                              (e) => InkWell(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onTap: () async {
                                                  getIt<BookingManager>()
                                                      .setPrefferedLanguage(e);
                                                  String? genderPref =
                                                      [
                                                            "Male",
                                                            "Female",
                                                          ].contains(
                                                            mgr.preferredDoctorGender,
                                                          ) ==
                                                          true
                                                      ? mgr.preferredDoctorGender
                                                      : null;

                                                  await refreshDocData(
                                                    userId: null,
                                                    genderPref: genderPref,
                                                    slotPref:
                                                        mgr
                                                                .docsData!
                                                                .isFreeDoctorAvailable ==
                                                            true
                                                        ? "Free"
                                                        : null,
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 8,
                                                        left: 2,
                                                      ),
                                                  child: selectionBox(
                                                    getIt<StateManager>()
                                                            .getLocaleTxt(
                                                              e,
                                                              context,
                                                            ) ??
                                                        "",
                                                    e == mgr.preferredLanguage,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        // Text("Malayalam",style: TextStyles.textStyle35,),
                                      ),
                                      verticalSpace(h1p),
                                      Text(
                                        locale.preferredDoc,
                                        style: t500_14.copyWith(
                                          color: clr2D2D2D,
                                        ),
                                      ),
                                      verticalSpace(h1p),
                                      Wrap(
                                        runSpacing: h1p,
                                        children: genderPrefs
                                            .map(
                                              (e) => InkWell(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onTap: () async {
                                                  String? genderPref =
                                                      [
                                                            "Male",
                                                            "Female",
                                                          ].contains(e) ==
                                                          true
                                                      ? e
                                                      : null;

                                                  var res = await refreshDocData(
                                                    userId: mgr
                                                        .selectedPatientDetails
                                                        ?.appUserId,
                                                    genderPref: genderPref,
                                                    slotPref: null,
                                                  );
                                                  if (res == true) {
                                                    getIt<BookingManager>()
                                                        .setPrefferedDocGender(
                                                          e,
                                                        );
                                                    getBillDetails();
                                                  }
                                                },
                                                child: CheckBoxItem(
                                                  h1p: h1p,
                                                  w1p: w1p,
                                                  selected:
                                                      e ==
                                                      mgr.preferredDoctorGender,
                                                  title:
                                                      getIt<StateManager>()
                                                          .getLocaleTxt(
                                                            e,
                                                            context,
                                                          ) ??
                                                      "",
                                                ),
                                              ),
                                            )
                                            .toList(),

                                        // Text("Malayalam",style: TextStyles.textStyle35,),
                                      ),
                                      verticalSpace(h1p),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w1p * 4,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    verticalSpace(h1p),
                                    Text(
                                      locale.feeRange,
                                      style: t500_14.copyWith(color: clr2D2D2D),
                                    ),
                                    verticalSpace(h1p),
                                    Row(
                                      children: [
                                        // doctorCategory(selectedCategory: mgr.docsData?.selectedPriceCategory, category: feeRangeNoPrefDoctors),
                                        doctorCategory(
                                          selectedCategory: mgr
                                              .docsData
                                              ?.selectedPriceCategory,
                                          category: mgr.docsData?.minDoctors,
                                        ),
                                        doctorCategory(
                                          selectedCategory: mgr
                                              .docsData
                                              ?.selectedPriceCategory,
                                          category: mgr.docsData?.midDoctors,
                                        ),
                                        doctorCategory(
                                          selectedCategory: mgr
                                              .docsData
                                              ?.selectedPriceCategory,
                                          category: mgr.docsData?.maxDoctors,
                                        ),
                                      ],
                                    ),
                                    verticalSpace(12),
                                    Entry(
                                      // xOffset: 400,
                                      // // scale: 20,
                                      // delay: const Duration(milliseconds: 0),
                                      // duration: const Duration(milliseconds: 1000),
                                      // curve: Curves.ease,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            locale.weWillAssignYou,
                                            style: t400_18.copyWith(
                                              color: clr2D2D2D,
                                            ),
                                          ),
                                          Text(
                                            locale.theBestDoctor,
                                            style: t700_20.copyWith(
                                              color: const Color(0xff625CAB),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              verticalSpace(8),
                              mgr.bookingScreenLoader
                                  ? SizedBox(
                                      height: 200,
                                      width: w1p * 80,
                                      child: Padding(
                                        padding: const EdgeInsets.all(28.0),
                                        child: Lottie.asset(
                                          'assets/images/doc-search.json',
                                        ),
                                      ),
                                    )
                                  : mgr.docsData!.status == true
                                  ? Builder(
                                      builder: (context) {
                                        List<Doctors> doctors =
                                            mgr
                                                .docsData
                                                ?.selectedPriceCategory
                                                ?.doctors ??
                                            [];

                                        return SizedBox(
                                          height: 200,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: doctors.map((e) {
                                                var indx = doctors.indexOf(e);
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                    left: indx == 0
                                                        ? w1p * 4
                                                        : 0,
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            true,
                                                        builder: (BuildContext context) {
                                                          return AnimatedPopup(
                                                            child:
                                                                DoctorDetailsCard(
                                                                  instantDocData:
                                                                      e,
                                                                  h1p: h1p,
                                                                  w1p: w1p,
                                                                ),
                                                          ); // Animated dialog
                                                        },
                                                      );
                                                    },
                                                    child:
                                                        DoctorsItemInBookingScreen(
                                                          maxHeight: maxHeight,
                                                          maxWidth: maxWidth,
                                                          data: e,
                                                        ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : const SizedBox(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w1p * 4,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    verticalSpace(8),
                                    Entry(
                                      // yOffset: 500,
                                      // // scale: 20,
                                      // delay: const Duration(milliseconds: 0),
                                      // duration: const Duration(milliseconds: 1000),
                                      // curve: Curves.ease,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            locale.consultingFor,
                                            style: t500_16.copyWith(
                                              color: clr444444,
                                            ),
                                          ),
                                          // locale.selectPatientFillDetails.isNotEmpty?Text(locale.selectPatientFillDetails,style: TextStyles.textStyle38,):SizedBox(),
                                          verticalSpace(h1p),

                                          verticalSpace(h1p),
                                          Row(
                                            children: [
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                onTap: () async {
                                                  getIt<BookingManager>()
                                                      .setConsultforOther(
                                                        false,
                                                      );
                                                  getIt<BookingManager>()
                                                      .setOtherperson(
                                                        mgr
                                                            .otherPatientsDetails
                                                            .userDetails,
                                                      );
                                                  String? genderPref =
                                                      [
                                                            "Male",
                                                            "Female",
                                                          ].contains(
                                                            mgr.preferredDoctorGender,
                                                          ) ==
                                                          true
                                                      ? mgr.preferredDoctorGender
                                                      : null;
                                                  mgr.setDocsData(
                                                    BookingDataDetailsModel(),
                                                  );
                                                  await refreshDocData(
                                                    userId: null,
                                                    genderPref: genderPref,
                                                    slotPref:
                                                        mgr
                                                                .docsData!
                                                                .isFreeDoctorAvailable ==
                                                            true
                                                        ? "Free"
                                                        : null,
                                                  );
                                                  await removepkgFn();
                                                  await getBillDetails();
                                                },
                                                child: CheckBoxItem(
                                                  h1p: h1p,
                                                  w1p: w1p,
                                                  selected:
                                                      mgr.consultingForOther ==
                                                      false,
                                                  title: getIt<StateManager>()
                                                      .capitalize(
                                                        mgr
                                                                .otherPatientsDetails
                                                                .userDetails
                                                                ?.firstName ??
                                                            "",
                                                      ),
                                                ),
                                              ),
                                              InkWell(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onTap: () {
                                                  getIt<BookingManager>()
                                                      .setConsultforOther(true);
                                                  getIt<BookingManager>()
                                                      .setOtherperson(null);
                                                },
                                                child: CheckBoxItem(
                                                  h1p: h1p,
                                                  w1p: w1p,
                                                  selected:
                                                      mgr.consultingForOther ==
                                                      true,
                                                  title: locale.forFamily,
                                                ),
                                              ),
                                            ],
                                          ),
                                          verticalSpace(16),

                                          Container(
                                            child:
                                                mgr.consultingForOther ==
                                                        true &&
                                                    (mgr
                                                                .otherPatientsDetails
                                                                .userRelations ==
                                                            null ||
                                                        mgr
                                                            .otherPatientsDetails
                                                            .userRelations!
                                                            .isEmpty)
                                                ? Entry(
                                                    // xOffset: -200,
                                                    // // scale: 20,
                                                    // delay: const Duration(milliseconds: 0),
                                                    // duration: const Duration(milliseconds: 500),
                                                    // curve: Curves.ease,
                                                    child: SizedBox(
                                                      height: 30,
                                                      child: SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          children: consultOthers
                                                              .map(
                                                                (e) => InkWell(
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap: () async {
                                                                    // getIt<BookingManager>().setOtherperson(e);
                                                                    var res = await showModalBottomSheet(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .blueGrey,
                                                                      isScrollControlled:
                                                                          true,
                                                                      useSafeArea:
                                                                          true,
                                                                      context:
                                                                          context,
                                                                      builder: (context) => PatientForm(
                                                                        appBarTitle:
                                                                            locale.addMember,
                                                                        maxWidth:
                                                                            maxWidth,
                                                                        maxHeight:
                                                                            maxHeight,
                                                                        relation:
                                                                            e !=
                                                                                "Other"
                                                                            ? e
                                                                            : null,
                                                                        user:
                                                                            UserDetails(),
                                                                      ),
                                                                    );
                                                                    if (res !=
                                                                        null) {
                                                                      String?
                                                                      genderPref =
                                                                          [
                                                                                "Male",
                                                                                "Female",
                                                                              ].contains(
                                                                                mgr.preferredDoctorGender,
                                                                              ) ==
                                                                              true
                                                                          ? mgr.preferredDoctorGender
                                                                          : null;

                                                                      await refreshDocData(
                                                                        userId: mgr
                                                                            .selectedPatientDetails
                                                                            ?.id,
                                                                        genderPref:
                                                                            genderPref,
                                                                        slotPref:
                                                                            mgr.docsData!.isFreeDoctorAvailable ==
                                                                                true
                                                                            ? "Free"
                                                                            : null,
                                                                      );
                                                                      // getIt<
                                                                      //       BookingManager
                                                                      //     >()
                                                                      //     .setOtherperson(
                                                                      //       mgr.selectedPatientDetails,
                                                                      //     );
                                                                      log(
                                                                        "calling bill details after saving",
                                                                      );
                                                                      getBillDetails();
                                                                      log(
                                                                        "called bill details after saving",
                                                                      );
                                                                    }
                                                                  },
                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets.only(
                                                                          right:
                                                                              8,
                                                                        ),
                                                                    child: OtherBox(
                                                                      h1p: h1p,
                                                                      w1p: w1p,
                                                                      name: e,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                              .toList(),

                                                          // Text("Malayalam",style: TextStyles.textStyle35,),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : mgr.consultingForOther ==
                                                          true &&
                                                      (mgr
                                                                  .otherPatientsDetails
                                                                  .userRelations !=
                                                              null ||
                                                          mgr
                                                              .otherPatientsDetails
                                                              .userRelations!
                                                              .isNotEmpty)
                                                ? SingleChildScrollView(
                                                    controller:
                                                        _scrollController,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: mgr.otherPatientsDetails.userRelations!.map((
                                                        e,
                                                      ) {
                                                        // var i = mgr.otherPatientsDetails.userRelations!.indexOf(e);
                                                        return userId ==
                                                                e.userId
                                                            ? const SizedBox()
                                                            : InkWell(
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                splashColor: Colors
                                                                    .transparent,
                                                                onTap: () async {
                                                                  getIt<
                                                                        BookingManager
                                                                      >()
                                                                      .setOtherperson(
                                                                        e,
                                                                      );
                                                                  String?
                                                                  genderPref =
                                                                      [
                                                                            "Male",
                                                                            "Female",
                                                                          ].contains(
                                                                            mgr.preferredDoctorGender,
                                                                          ) ==
                                                                          true
                                                                      ? mgr.preferredDoctorGender
                                                                      : null;
                                                                  mgr.setDocsData(
                                                                    BookingDataDetailsModel(),
                                                                  );
                                                                  await refreshDocData(
                                                                    userId: e
                                                                        .appUserId,
                                                                    genderPref:
                                                                        genderPref,
                                                                    slotPref:
                                                                        mgr.docsData!.isFreeDoctorAvailable ==
                                                                            true
                                                                        ? "Free"
                                                                        : null,
                                                                  );
                                                                  await removepkgFn();
                                                                  getBillDetails();
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets.only(
                                                                        right:
                                                                            8,
                                                                        top: 8,
                                                                      ),
                                                                  child: SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    child: Row(
                                                                      children: [
                                                                        PatientBox(
                                                                          h1p:
                                                                              h1p,
                                                                          w1p:
                                                                              w1p,
                                                                          user:
                                                                              e,
                                                                          selected:
                                                                              mgr.selectedPatientDetails !=
                                                                                  null &&
                                                                              e.firstName ==
                                                                                  mgr.selectedPatientDetails!.firstName,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                      }).toList(),
                                                    ),
                                                  )
                                                // )
                                                : const SizedBox(),
                                          ),

                                          mgr
                                                          .otherPatientsDetails
                                                          .userRelations!
                                                          .length <
                                                      3 &&
                                                  mgr.consultingForOther ==
                                                      true &&
                                                  (mgr
                                                              .otherPatientsDetails
                                                              .userRelations !=
                                                          null &&
                                                      mgr
                                                          .otherPatientsDetails
                                                          .userRelations!
                                                          .isNotEmpty)
                                              ? InkWell(
                                                  highlightColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    var res =
                                                        await showModalBottomSheet(
                                                          backgroundColor:
                                                              Colors.blueGrey,
                                                          isScrollControlled:
                                                              true,
                                                          useSafeArea: true,
                                                          context: context,
                                                          builder: (context) =>
                                                              PatientForm(
                                                                maxWidth:
                                                                    maxWidth,
                                                                appBarTitle: locale
                                                                    .addMember,
                                                                maxHeight:
                                                                    maxHeight,
                                                                user:
                                                                    UserDetails(),
                                                              ),
                                                        );

                                                    if (res != null) {
                                                      String? genderPref =
                                                          [
                                                                "Male",
                                                                "Female",
                                                              ].contains(
                                                                mgr.preferredDoctorGender,
                                                              ) ==
                                                              true
                                                          ? mgr.preferredDoctorGender
                                                          : null;

                                                      await refreshDocData(
                                                        userId: res,
                                                        genderPref: genderPref,
                                                        slotPref:
                                                            mgr
                                                                    .docsData!
                                                                    .isFreeDoctorAvailable ==
                                                                true
                                                            ? "Free"
                                                            : null,
                                                      );
                                                      // getBillDetails();
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 8.0,
                                                        ),
                                                    child: OtherBox(
                                                      h1p: h1p,
                                                      w1p: w1p,
                                                      name: "Add Member",
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),

                                          mgr.docsData?.seniorCitizen == true &&
                                                  mgr
                                                          .docsData
                                                          ?.isAgeProofSubmitted ==
                                                      true &&
                                                  mgr
                                                          .docsData
                                                          ?.isFreeDoctorAvailable ==
                                                      false
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                    top: h1p * 1.5,
                                                  ),
                                                  child: Text(
                                                    '*${mgr.docsData!.message}',
                                                    style: t400_14.copyWith(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),

                                          verticalSpace(8),
                                          mgr.docsData?.packageAvailability !=
                                                      true &&
                                                  mgr.selectedPkg == null &&
                                                  (mgr
                                                              .docsData
                                                              ?.isFreeDoctorAvailable ==
                                                          false ||
                                                      mgr
                                                              .docsData
                                                              ?.seniorCitizen ==
                                                          false)
                                              ? Column(
                                                  children: [
                                                    verticalSpace(8),
                                                    mgr.allPackages.isNotEmpty
                                                        ? CarouselSlider(
                                                            options: CarouselOptions(
                                                              enableInfiniteScroll:
                                                                  mgr
                                                                          .allPackages
                                                                          .length >
                                                                      1
                                                                  ? true
                                                                  : false,
                                                              viewportFraction:
                                                                  1,
                                                              enlargeCenterPage:
                                                                  true,
                                                              autoPlay: true,
                                                              autoPlayInterval:
                                                                  const Duration(
                                                                    seconds: 4,
                                                                  ),
                                                              aspectRatio:
                                                                  2 / 1,
                                                              onPageChanged:
                                                                  (val, ds) {},
                                                            ),
                                                            items: mgr
                                                                .allPackages
                                                                .map(
                                                                  (
                                                                    e,
                                                                  ) => InkWell(
                                                                    onTap: () async {
                                                                      if (mgr.selectedPatientDetails !=
                                                                          null) {
                                                                        // if (mgr.consultingForOther) {
                                                                        getIt<
                                                                              BookingManager
                                                                            >()
                                                                            .setPatientsUnderPackage(
                                                                              user: mgr.selectedPatientDetails!,
                                                                              isAdd: true,
                                                                            );
                                                                        // }
                                                                        dynamic
                                                                        res = await showModalBottomSheet(
                                                                          backgroundColor:
                                                                              Colors.blueGrey,
                                                                          isScrollControlled:
                                                                              true,
                                                                          useSafeArea:
                                                                              true,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (
                                                                                context,
                                                                              ) => PackageDetailsScreen(
                                                                                alreadySelectedUser: mgr.selectedPatientDetails?.id,
                                                                                // alreadySelectedUser: mgr.consultingForOther ? mgr.selectedPatientDetails?.id : null,
                                                                                maxWidth: maxWidth,
                                                                                maxHeight: maxHeight,
                                                                                pkg: e,
                                                                              ),
                                                                        );

                                                                        if (res !=
                                                                            null) {
                                                                          getBillDetails();
                                                                        }
                                                                      } else {
                                                                        showTopSnackBar(
                                                                          Overlay.of(
                                                                            context,
                                                                          ),
                                                                          ErrorToast(
                                                                            message:
                                                                                locale.selectPatientToContinue,
                                                                          ),
                                                                        );
                                                                      }
                                                                    },
                                                                    child: PackagesContainer(
                                                                      h1p: h1p,
                                                                      w1p: w1p,
                                                                      title:
                                                                          e.title ??
                                                                          "",
                                                                      subtitle:
                                                                          e.subtitle ??
                                                                          "",
                                                                      image:
                                                                          e.image ??
                                                                          "",
                                                                      salePrice:
                                                                          e.cuttingAmount !=
                                                                              null
                                                                          ? "₹${e.cuttingAmount!}"
                                                                          : "",
                                                                      offerPrice:
                                                                          "₹${e.amount ?? ""}",
                                                                      savedAmount:
                                                                          " Save ₹${e.amount ?? ""}",
                                                                      btnTxt:
                                                                          "Choose Package",
                                                                    ),
                                                                  ),
                                                                )
                                                                .map(
                                                                  (item) =>
                                                                      item,
                                                                )
                                                                .toList(),
                                                          )
                                                        : const SizedBox(),
                                                    verticalSpace(8),
                                                  ],
                                                )
                                              : const SizedBox(),

                                          mgr.selectedPkg != null
                                              ? SelectedPackage(
                                                  w1p: w1p,
                                                  h1p: h1p,
                                                  selectedPkg: mgr.selectedPkg!,
                                                  fn: () async {
                                                    await removepkgFn();
                                                    getBillDetails();
                                                  },
                                                )
                                              : const SizedBox(),

                                          verticalSpace(8),
                                          Visibility(
                                            visible:
                                                mgr.selectedPatientDetails !=
                                                    null &&
                                                mgr.docsData!.seniorCitizen ==
                                                    true &&
                                                mgr
                                                        .docsData!
                                                        .isAgeProofSubmitted ==
                                                    false,
                                            child: FreeConsultContainer(
                                              w1p: w1p,
                                              h1p: h1p,
                                              userId: mgr
                                                  .selectedPatientDetails
                                                  ?.appUserId,
                                              refreshBill: getBillDetails,
                                            ),
                                          ),
                                          Visibility(
                                            visible:
                                                mgr.selectedPatientDetails !=
                                                    null &&
                                                mgr.docsData!.seniorCitizen ==
                                                    true &&
                                                mgr
                                                        .docsData!
                                                        .isAgeProofSubmitted ==
                                                    true &&
                                                mgr
                                                        .docsData!
                                                        .isFreeDoctorAvailable ==
                                                    true,
                                            child: Entry(
                                              duration: const Duration(
                                                milliseconds: 700,
                                              ),
                                              delay: const Duration(
                                                milliseconds: 1000,
                                              ),
                                              xOffset: 200,
                                              child: FreeConsultApplied(
                                                w1p: w1p,
                                                h1p: h1p,
                                              ),
                                            ),
                                          ),
                                          verticalSpace(2),
                                          const FollowUpFeatureMessage(
                                            "You'll also receive a FREE 7-day follow-up with every consultation",
                                          ),
                                          verticalSpace(8),
                                          if (mgr.selectedPatientDetails !=
                                                  null &&
                                              billResponse?.status == true)
                                            Entry(
                                              duration: const Duration(
                                                milliseconds: 800,
                                              ),
                                              delay: const Duration(
                                                milliseconds: 0,
                                              ),
                                              xOffset: 200,
                                              curve: Curves.ease,
                                              child: ConfirmPatientDetails(
                                                maxWidth: maxWidth,
                                                maxHeight: maxHeight,
                                                userData:
                                                    mgr.selectedPatientDetails!,
                                                dataForInstantBooking: BookingDetailsItem(
                                                  language:
                                                      [
                                                        "English",
                                                        "Malayalam",
                                                      ].contains(
                                                        mgr.preferredLanguage,
                                                      )
                                                      ? mgr.preferredLanguage
                                                      : null,
                                                  gender:
                                                      [
                                                        "Male",
                                                        "Female",
                                                      ].contains(
                                                        mgr.preferredDoctorGender,
                                                      )
                                                      ? mgr.preferredDoctorGender
                                                      : null,
                                                  packageDetails: mgr
                                                      .selectedPkg
                                                      ?.packageDetails,
                                                  specialityId:
                                                      widget.specialityId,
                                                  subSpecialityId:
                                                      widget.subspecialityId,
                                                  psychologyType:
                                                      widget.psychologyType,
                                                  consultationFor:
                                                      mgr.consultingForOther ==
                                                          true
                                                      ? "Relative"
                                                      : "Self",
                                                  selectedPriceCategory: mgr
                                                      .docsData
                                                      ?.selectedPriceCategory
                                                      ?.consultationCategory,
                                                  subcategoryId:
                                                      widget.subCatId,
                                                  seniorCitizenFreeConsultation:
                                                      mgr
                                                              .docsData!
                                                              .seniorCitizen ==
                                                          true &&
                                                      mgr
                                                              .docsData!
                                                              .isAgeProofSubmitted ==
                                                          true &&
                                                      mgr
                                                              .docsData!
                                                              .isFreeDoctorAvailable ==
                                                          true,
                                                  patientId: mgr
                                                      .selectedPatientDetails
                                                      ?.appUserId,
                                                ),
                                                dataForScheduledBooking: null,
                                                dataForPsychologyInstantBooking:
                                                    null,
                                                isScheduledBooking: false,
                                              ),
                                            ),
                                          if (mgr.selectedPatientDetails !=
                                                  null &&
                                              billResponse?.status != true)
                                            SizedBox(
                                              height: h1p * 30,
                                              child: const Center(
                                                child: LogoLoader(size: 40),
                                              ),
                                            ),

                                          // verticalSpace(16),
                                          // TermsAndConditions(
                                          //     onTap: () {
                                          //       setState(() {
                                          //         agreeTerms = !agreeTerms;
                                          //       });
                                          //     },
                                          //     isAgreed: agreeTerms),
                                          // verticalSpace(8),
                                          // const RefundPolicy(),

                                          // verticalSpace(16),

                                          // payBtn(
                                          //   usrD: mgr.selectedPatientDetails, loader: mgr.billLoader, selectedPackage: mgr.selectedPkg,
                                          //   // bill: bill,
                                          //   bDetails: BookingDetailsItem(
                                          //     gender: ["Male", "Female"].contains(mgr.preferredDoctorGender) ? mgr.preferredDoctorGender : null,
                                          //     packageDetails: mgr.selectedPkg?.packageDetails,
                                          //     specialityId: widget.specialityId,
                                          //     subSpecialityId: widget.subspecialityId,
                                          //     psychologyType: widget.psychologyType,
                                          //     consultationFor: mgr.consultingForOther == true ? "Relative" : "Self",
                                          //     selectedPriceCategory: mgr.docsData?.selectedPriceCategory?.consultationCategory,
                                          //     subcategoryId: widget.subCatId,
                                          //     seniorCitizenFreeConsultation: mgr.docsData!.seniorCitizen == true && mgr.docsData!.isAgeProofSubmitted == true && mgr.docsData!.isFreeDoctorAvailable == true,
                                          //     patientId: mgr.selectedPatientDetails?.appUserId,
                                          //   ),
                                          // ),

                                          // verticalSpace(800),
                                          verticalSpace(16),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
              );
            },
          ),
        );
      },
    );
  }
}
