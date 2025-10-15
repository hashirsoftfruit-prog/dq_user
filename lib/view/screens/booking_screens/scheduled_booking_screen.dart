// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:dqapp/controller/services/payment_service.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/model/core/other_patients_response_model.dart';
import 'package:dqapp/model/core/booking_request_data_model.dart';
import 'package:dqapp/view/screens/booking_screens/package_details_screen.dart';
import 'package:dqapp/view/screens/booking_screens/patient_details_form_screen.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/core/doctor_list_response_model.dart';
import '../../../model/core/doctors_slotpick_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/common_widgets.dart';
import '../home_screen.dart';
import 'booking_screen_widgets.dart';
import 'confirm_patient_details_popup.dart';

class ScheduledBookingScreen extends StatefulWidget {
  final int specialityId;
  final int? subCatId;
  final int? subSpecialityIdForPsychology;
  final ClinicsDetails? clinicInfo;
  final String? itemName;
  final DoctorDetails? doctorDetails;
  final DateTime date;
  final String time;
  final bool isScheduledOnline;

  const ScheduledBookingScreen({
    super.key,
    required this.specialityId,
    required this.subSpecialityIdForPsychology,
    this.clinicInfo,
    this.itemName,
    required this.isScheduledOnline,
    required this.date,
    required this.time,
    required this.subCatId,
    this.doctorDetails,
  });

  @override
  State<ScheduledBookingScreen> createState() => _ScheduledBookingScreenState();
}

class _ScheduledBookingScreenState extends State<ScheduledBookingScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  dynamic billResponse;

  void scrollToSelectedItem(int index) {
    // Calculate the offset
    double offset = index * 80.0; // Approximate height of each item
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  bool agreeTerms = true;
  var scollCntr = ScrollController();
  @override
  void initState() {
    getIt<BookingManager>().getPatientsDetailsList();
    // getIt<BookingManager>().getBillDetails(spID:widget.specialityId ,type:widget.isScheduledOnline==true?1:2,doctorId: widget.doctorDetails?.id );
    // if(widget.docsData.packageAvailability!=true){}
    getIt<BookingManager>().getPackages(
      widget.specialityId,
      widget.subSpecialityIdForPsychology,
    );
    Future.delayed(Duration.zero, () async {
      getIt<BookingManager>().setPrefferedLanguage("English");
      getIt<BookingManager>().setPrefferedDocGender(
        StringConstants.dPrefNoPref,
      );
    });
    try {
      getBillDetails();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getIt<BookingManager>().resetPaymentState();
      });
    } on Exception catch (e) {
      log("message from bill details error 86 $e");
    }
    // scollCntr.addListener(_scrollListener);
    super.initState();
  }

  getBillDetails() async {
    try {
      int patientId =
          getIt<SharedPreferences>().getInt(StringConstants.patientId) ?? 0;
      final patientDetails = getIt<BookingManager>().selectedPatientDetails;
      if (patientDetails != null) {
        patientId = patientDetails.id!;
      }
      log(getIt<BookingManager>().docsData!.toJson().toString());
      billResponse = await getIt<BookingManager>().getBillDetails(
        packageDetails: getIt<BookingManager>().selectedPkg?.packageDetails,
        isSeniorCitizenConsultation:
            getIt<BookingManager>().docsData!.seniorCitizen == true &&
            getIt<BookingManager>().docsData!.isAgeProofSubmitted == true &&
            getIt<BookingManager>().docsData!.isFreeDoctorAvailable == true,
        spID: widget.specialityId,
        type: widget.isScheduledOnline == true ? 1 : 2,
        doctorId: widget.doctorDetails?.id,
        subSpecialityID: widget.subSpecialityIdForPsychology,
        patientId:
            patientId, //getIt<BookingManager>().selectedPatientDetails!.id ?? 0,
      );
    } catch (e) {
      log(" message from bill details error $e");
    }
  }

  @override
  void dispose() {
    // scollCntr.removeListener(_scrollListener);
    scollCntr.dispose();
    getIt<BookingManager>().disposeBooking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    removePkgFn() async {
      getIt<BookingManager>().setSelectedPackage(null);
      getIt<BookingManager>().setLoaderActive(true);
      await Future.delayed(const Duration(milliseconds: 500), () {
        getIt<BookingManager>().setLoaderActive(false);
      });
    }

    String username =
        getIt<SharedPreferences>().getString(StringConstants.userName) ?? "";

    int? userId = getIt<SharedPreferences>().getInt(StringConstants.userId);
    var locale = AppLocalizations.of(context);

    // List<String> langs = ["English","Malayalam"];
    // List<String> genderPrefs = [StringConstants.dPrefNoPref,  StringConstants.dPrefMale,  StringConstants.dPrefFemale,];
    List<String> consultOthers = ["Father", "Mother", "Spouse", "Other"];

    return PopScope(
      canPop: false, // We'll handle the logic manually
      onPopInvokedWithResult: (didPop, result) async {
        final bookingManager = getIt<BookingManager>();
        final paymentStatus =
            bookingManager.isPaymentOnProcess || bookingManager.proceedLoader;

        // If a payment is in progress
        if (paymentStatus) {
          if (Platform.isAndroid) {
            final backPressResult = await PaymentService.instance.hyperSDK
                .onBackPress();
            log("message is Back press status from HyperSDK: $backPressResult");

            // If SDK allows back navigation
            if (backPressResult.toLowerCase() == "true") {
              bookingManager.disposeBillScreen();
              // if (context.mounted) Navigator.of(context).pop();
              Navigator.of(context).pop();
            } else {
              // Block back press while payment in progress
              log(
                "message is Back press blocked due to ongoing payment or loading",
              );
            }
          }
          return; // Don't pop automatically
        }
        log("message is no payment is on process or loading");
        // If no payment is in progress → normal back navigation
        bookingManager.disposeBillScreen();
        if (context.mounted) Navigator.of(context).pop();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxHeight = constraints.maxHeight;
          double maxWidth = constraints.maxWidth;
          double h1p = maxHeight * 0.01;
          double h10p = maxHeight * 0.1;
          double w10p = maxWidth * 0.1;
          double w1p = maxWidth * 0.01;

          Future<void> refreshDocData({
            required int? userId,
            required String? slotPref,
          }) async {
            var result = await getIt<BookingManager>().getScheduledBookingData(
              specialityId: widget.specialityId,
              subSpecialityId: widget.subSpecialityIdForPsychology,
              userId: userId,
              doctorId: widget.doctorDetails?.id,
            );
            if (result.status == true) {
              getIt<BookingManager>().setDocsData(result);
            } else {
              showTopSnackBar(
                snackBarPosition: SnackBarPosition.bottom,
                padding: const EdgeInsets.all(30),
                Overlay.of(context),
                ErrorToast(maxLines: 3, message: result.message ?? ""),
              );
            }
          }

          // payBtn({UserDetails? usrDetails, required bool loader, required SelectedPackageModel? selectedPackage, required SaveScheduledBookingModel bDetails}) {
          //   return ButtonWidget(
          //     isLoading: loader,
          //     ontap: () async {
          //       var billResponse = await getIt<BookingManager>().getBillDetails(
          //         packageDetails: selectedPackage?.packageDetails,
          //         isSeniorCitizenConsultation: bDetails.seniorCitizenFreeConsultation,
          //         spID: bDetails.specialityId!,
          //         type: bDetails.bookingType,
          //         doctorId: bDetails.doctorId,
          //         subSpecialityID: bDetails.subSpecialityIdForPsychology,
          //       );
          //       if (agreeTerms == true && usrDetails != null && billResponse.status == true) {
          //         showModalBottomSheet(
          //             backgroundColor: Colors.white,
          //             isScrollControlled: true,
          //             useSafeArea: true,
          //             showDragHandle: true,
          //             context: context,
          //             builder: (context) => ConfirmPatientDetails(
          //                   maxWidth: maxWidth,
          //                   maxHeight: maxHeight,
          //                   userData: usrDetails,
          //                   dataForInstantBooking: null,
          //                   dataForPsychologyInstantBooking: null,
          //                   dataForScheduledBooking: bDetails,
          //                   isScheduledBooking: true,
          //                 ));
          //       } else {
          //         showTopSnackBar(
          //             Overlay.of(context),
          //             SuccessToast(
          //                 message: agreeTerms != true
          //                     ? locale!.youMustAgreeTermsAndConditions
          //                     : usrDetails == null
          //                         ? locale!.selectPatientToContinue
          //                         : billResponse.message ?? ""));
          //       }
          //     },
          //     btnText: "Continue",
          //     // pad(horizontal: w1p*6,
          //     //   child: Container(width: maxWidth,height:h10p*0.6,decoration:BoxDecoration(borderRadius: BorderRadius.circular(21),color: Colours.primaryblue),
          //     //     child: pad(horizontal: 0,vertical: h1p,child: Center(child: Text(amt=="0"||packageAvailability==true?locale!.bookNow:locale!.localeName=='en'?"Pay ₹$amt Now ":"₹$amt അടക്കുക",style: t700_16.copyWith(color: Color(0xffffffff)),)),),),
          //     // )
          //   );
          // }

          return Consumer<BookingManager>(
            builder: (context, mgr, child) {
              // BillResponseModel? bill = mgr.packageBillModel??mgr.couponAppliedBillModel??mgr.billModel;
              log(
                "status check ${mgr.docsData!.seniorCitizen} - ${mgr.docsData!.isAgeProofSubmitted}",
              );
              return Scaffold(
                //     floatingActionButton: Entry(yOffset: 200,
                //   // scale: 20,
                //   delay: const Duration(milliseconds: 1000),
                //   duration: const Duration(milliseconds: 500),
                //   curve: Curves.ease,
                //   // visible: mgr.showFAB,
                //   visible: false,
                //   child:mgr.billModel!=null||mgr.packageBillModel!=null?payBtn(mgr.selectedPatientDetails,mgr.packageBillModel!=null?mgr.packageBillModel!.amountAfterDiscount??"":mgr.billModel?.amountAfterDiscount??"",BookingDetailsItem(specialityId: widget.specialityId,consultationFor: mgr.consultingForOther==true?"Relative":"Self",couponId: mgr.billModel!.couponIdIfApplied,
                //       paidAmount:mgr.packageBillModel!=null?mgr.packageBillModel!.amountAfterDiscount??"":mgr.billModel?.amountAfterDiscount??"",patientId: mgr.selectedPatientDetails?.id )):SizedBox() ,
                // ),
                // extendBody: true,
                backgroundColor: Colors.white,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                // backgroundColor: Colors.white,
                appBar: getIt<SmallWidgets>().appBarWidget(
                  height: h10p * 0.9,
                  width: w10p,
                  title: widget.itemName ?? locale!.bookAppoinment,
                  fn: () {
                    Navigator.pop(context);
                  },
                ),
                body: mgr.isPaymentOnProcess || mgr.proceedLoader
                    ? const Center(child: LogoLoader())
                    : ListView(
                        controller: scollCntr,
                        children: [
                          Entry(
                            yOffset: -500,
                            // scale: 20,
                            delay: const Duration(milliseconds: 0),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.ease,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DoctorDetailsContainer(
                                  img: widget.doctorDetails?.image ?? "",
                                  w1p: w1p,
                                  h1p: h1p,
                                  name:
                                      '${getIt<StateManager>().capitalizeFirstLetter(widget.doctorDetails?.firstName ?? "")} ${getIt<StateManager>().capitalizeFirstLetter(widget.doctorDetails?.lastName ?? "")}',
                                  type:
                                      widget
                                          .doctorDetails
                                          ?.professionalQualifications ??
                                      "",
                                  experience:
                                      widget.doctorDetails?.experience ?? "",
                                ),
                                verticalSpace(h1p),
                              ],
                            ),
                          ),
                          Entry(
                            yOffset: -500,
                            // scale: 20,
                            delay: const Duration(milliseconds: 0),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.ease,
                            child: pad(
                              horizontal: w1p * 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    locale!.consultingFor,
                                    style: t500_18.copyWith(color: clr2D2D2D),
                                  ),
                                  // locale!.selectPatientFillDetails.isNotEmpty?Text(locale!.selectPatientFillDetails,style: t400_14.copyWith(color: clr858585),):SizedBox(),
                                  // verticalSpace(h1p),
                                  verticalSpace(h1p),

                                  Row(
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () async {
                                          getIt<BookingManager>()
                                              .setConsultforOther(false);

                                          getIt<BookingManager>()
                                              .setOtherperson(
                                                mgr
                                                    .otherPatientsDetails
                                                    .userDetails,
                                              );
                                          // String? genderPref = ["Male","Female"].contains(mgr.preferredDoctorGender)==true?mgr.preferredDoctorGender:null;
                                          await refreshDocData(
                                            userId: null,
                                            slotPref:
                                                mgr
                                                        .docsData!
                                                        .isFreeDoctorAvailable ==
                                                    true
                                                ? "Free"
                                                : null,
                                          );
                                          await removePkgFn();
                                          try {
                                            getBillDetails();
                                          } on Exception catch (e) {
                                            log(
                                              "message from bill details error 310 $e",
                                            );
                                          }
                                        },
                                        child: CheckBoxItem(
                                          h1p: h1p,
                                          w1p: w1p,
                                          selected:
                                              mgr.consultingForOther == false,
                                          title: getIt<StateManager>()
                                              .capitalize(username),
                                        ),
                                      ),
                                      horizontalSpace(w1p * 2),
                                      InkWell(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          billResponse = null;
                                          getIt<BookingManager>()
                                              .setConsultforOther(true);
                                          getIt<BookingManager>()
                                              .setOtherperson(null);
                                          removePkgFn();
                                        },
                                        child: CheckBoxItem(
                                          h1p: h1p,
                                          w1p: w1p,
                                          selected:
                                              mgr.consultingForOther == true,
                                          title: locale.forFamily,
                                        ),
                                      ),
                                    ],
                                  ),
                                  verticalSpace(h1p * 1),

                                  Container(
                                    child:
                                        mgr.consultingForOther == true &&
                                            (mgr
                                                        .otherPatientsDetails
                                                        .userRelations ==
                                                    null ||
                                                mgr
                                                    .otherPatientsDetails
                                                    .userRelations!
                                                    .isEmpty)
                                        ? Entry(
                                            xOffset: 200,
                                            // scale: 20,
                                            delay: const Duration(
                                              milliseconds: 0,
                                            ),
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            curve: Curves.ease,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                    ),
                                                child: Row(
                                                  children: consultOthers
                                                      .map(
                                                        (e) => InkWell(
                                                          highlightColor: Colors
                                                              .transparent,
                                                          splashColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            // getIt<BookingManager>().setOtherperson(e);
                                                            var res = await showModalBottomSheet(
                                                              backgroundColor:
                                                                  Colors
                                                                      .blueGrey,
                                                              isScrollControlled:
                                                                  true,
                                                              useSafeArea: true,
                                                              context: context,
                                                              builder: (context) => PatientForm(
                                                                appBarTitle: locale
                                                                    .addMember,
                                                                maxWidth:
                                                                    maxWidth,
                                                                maxHeight:
                                                                    maxHeight,
                                                                relation:
                                                                    e != "Other"
                                                                    ? e
                                                                    : null,
                                                                user:
                                                                    UserDetails(),
                                                              ),
                                                            );

                                                            if (res != null) {
                                                              refreshDocData(
                                                                userId: mgr
                                                                    .selectedPatientDetails
                                                                    ?.appUserId,
                                                                slotPref: null,
                                                              );
                                                              try {
                                                                getBillDetails();
                                                              } on Exception catch (
                                                                e
                                                              ) {
                                                                log(
                                                                  "message from bill details error 401 $e",
                                                                );
                                                              }
                                                            }
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  right: 8,
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
                                                ),
                                              ),
                                            ),
                                          )
                                        : mgr.consultingForOther == true &&
                                              (mgr
                                                          .otherPatientsDetails
                                                          .userRelations !=
                                                      null ||
                                                  mgr
                                                      .otherPatientsDetails
                                                      .userRelations!
                                                      .isNotEmpty)
                                        ? SingleChildScrollView(
                                            controller: _scrollController,
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              // direction: Axis.horizontal,
                                              children: mgr.otherPatientsDetails.userRelations!.map((
                                                e,
                                              ) {
                                                // var i = mgr.otherPatientsDetails.userRelations!.indexOf(e);

                                                return userId == e.userId
                                                    ? const SizedBox()
                                                    : InkWell(
                                                        highlightColor:
                                                            Colors.transparent,
                                                        splashColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          await getIt<
                                                                BookingManager
                                                              >()
                                                              .setOtherperson(
                                                                e,
                                                              );
                                                          // String? genderPref = ["Male","Female"].contains(mgr.preferredDoctorGender)==true?mgr.preferredDoctorGender:null;
                                                          await refreshDocData(
                                                            userId: e.appUserId,
                                                            slotPref:
                                                                mgr
                                                                        .docsData!
                                                                        .isFreeDoctorAvailable ==
                                                                    true
                                                                ? "Free"
                                                                : null,
                                                          );
                                                          try {
                                                            getBillDetails();
                                                          } on Exception catch (
                                                            e
                                                          ) {
                                                            log(
                                                              "message from bill details error 464 $e",
                                                            );
                                                          }
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                right: 8,
                                                                top: 8,
                                                              ),
                                                          child: PatientBox(
                                                            h1p: h1p,
                                                            w1p: w1p,
                                                            user: e,
                                                            selected:
                                                                mgr.selectedPatientDetails !=
                                                                    null &&
                                                                e.firstName ==
                                                                    mgr
                                                                        .selectedPatientDetails!
                                                                        .firstName,
                                                          ),
                                                        ),
                                                      );
                                              }).toList(),

                                              // Text("Malayalam",style: TextStyles.textStyle35,),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ),
                                  mgr
                                                  .otherPatientsDetails
                                                  .userRelations!
                                                  .length <
                                              3 &&
                                          mgr.consultingForOther == true &&
                                          (mgr
                                                      .otherPatientsDetails
                                                      .userRelations !=
                                                  null &&
                                              mgr
                                                  .otherPatientsDetails
                                                  .userRelations!
                                                  .isNotEmpty)
                                      ? InkWell(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            showModalBottomSheet(
                                              backgroundColor: Colors.blueGrey,
                                              isScrollControlled: true,
                                              useSafeArea: true,
                                              context: context,
                                              builder: (context) => PatientForm(
                                                appBarTitle: locale.addMember,
                                                maxWidth: maxWidth,
                                                maxHeight: maxHeight,
                                                user: UserDetails(),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
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
                                  verticalSpace(h1p * 1),

                                  Text(
                                    locale.scheduledTime,
                                    style: t400_18.copyWith(color: clr2D2D2D),
                                  ),
                                  verticalSpace(h1p * 1),

                                  scheduledTimeAndDate(
                                    w1p: w1p,
                                    h1p: h1p,
                                    schedulDate: widget.date,
                                    time: widget.time,
                                  ),
                                  if (widget.clinicInfo != null)
                                    clinicAddress(
                                      w1p: w1p,
                                      h1p: h1p,
                                      clinic: widget.clinicInfo!,
                                    ),

                                  mgr.bookingScreenLoader == true
                                      ? const Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colours.primaryblue,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  verticalSpace(h1p * 1),
                                ],
                              ),
                            ),
                          ),
                          mgr.docsData?.packageAvailability != true &&
                                  mgr.selectedPkg == null &&
                                  mgr.allPackages.isNotEmpty &&
                                  (mgr.docsData?.isFreeDoctorAvailable ==
                                          false ||
                                      mgr.docsData?.seniorCitizen == false)
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 4,
                                  ),
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      enableInfiniteScroll:
                                          mgr.allPackages.length > 1
                                          ? true
                                          : false,
                                      viewportFraction: 1,
                                      enlargeCenterPage: true,
                                      autoPlay: true,
                                      autoPlayInterval: const Duration(
                                        seconds: 4,
                                      ),
                                      aspectRatio: 2 / 1,
                                      onPageChanged: (val, ds) {},
                                    ),
                                    items: mgr.allPackages
                                        .map(
                                          (e) => InkWell(
                                            onTap: () async {
                                              if (mgr.selectedPatientDetails !=
                                                  null) {
                                                if (mgr.consultingForOther) {
                                                  getIt<BookingManager>()
                                                      .setPatientsUnderPackage(
                                                        user: mgr
                                                            .selectedPatientDetails!,
                                                        isAdd: true,
                                                      );
                                                }
                                                dynamic
                                                res = await showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.blueGrey,
                                                  isScrollControlled: true,
                                                  useSafeArea: true,
                                                  context: context,
                                                  builder: (context) =>
                                                      PackageDetailsScreen(
                                                        // alreadySelectedUser:
                                                        //     mgr.consultingForOther
                                                        //     ? mgr
                                                        //           .selectedPatientDetails
                                                        //           ?.id
                                                        //     : null,
                                                        alreadySelectedUser: mgr
                                                            .selectedPatientDetails!
                                                            .id,
                                                        maxWidth: maxWidth,
                                                        maxHeight: maxHeight,
                                                        pkg: e,
                                                      ),
                                                );
                                                if (res != null) {
                                                  try {
                                                    getBillDetails();
                                                  } on Exception catch (e) {
                                                    log(
                                                      "message from bill details error 615 $e",
                                                    );
                                                  }
                                                }
                                              } else {
                                                showTopSnackBar(
                                                  Overlay.of(context),
                                                  SuccessToast(
                                                    message: locale
                                                        .selectPatientToContinue,
                                                  ),
                                                );
                                              }
                                            },
                                            child: PackagesContainer(
                                              h1p: h1p,
                                              w1p: w1p,
                                              title: e.title ?? "",
                                              subtitle: e.subtitle ?? "",
                                              image: e.image ?? "",
                                              salePrice: e.cuttingAmount != null
                                                  ? "₹${e.cuttingAmount!}"
                                                  : "",
                                              offerPrice: "₹${e.amount ?? ""}",
                                              savedAmount:
                                                  " Save ₹${e.amount ?? ""}",
                                              btnTxt: "Choose Package",
                                            ),
                                          ),
                                        )
                                        // as List<BannerList>
                                        .map((item) => item)
                                        .toList(),
                                  ),
                                )
                              : const SizedBox(),
                          Entry(
                            yOffset: -500,
                            // scale: 20,
                            delay: const Duration(milliseconds: 0),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.ease,
                            child: pad(
                              horizontal: w1p * 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  mgr.selectedPkg != null
                                      ? SelectedPackage(
                                          w1p: w1p,
                                          h1p: h1p,
                                          selectedPkg: mgr.selectedPkg!,
                                          fn: () async {
                                            await removePkgFn();
                                            try {
                                              getBillDetails();
                                            } on Exception catch (e) {
                                              log(
                                                "message from bill details error 672 $e",
                                              );
                                            }
                                          },
                                        )
                                      : const SizedBox(),

                                  verticalSpace(h1p * 1),
                                  Visibility(
                                    visible:
                                        mgr.docsData!.seniorCitizen == true &&
                                        mgr.docsData!.isAgeProofSubmitted ==
                                            false,
                                    child: FreeConsultContainer(
                                      w1p: w1p,
                                      h1p: h1p,
                                      userId:
                                          mgr.selectedPatientDetails?.appUserId,
                                      refreshBill: getBillDetails,
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        mgr.docsData!.seniorCitizen == true &&
                                        mgr.docsData!.isAgeProofSubmitted ==
                                            true &&
                                        mgr.docsData!.isFreeDoctorAvailable ==
                                            true,
                                    child: Entry(
                                      xOffset: 200,
                                      duration: const Duration(
                                        milliseconds: 700,
                                      ),
                                      delay: const Duration(milliseconds: 1000),
                                      child: FreeConsultApplied(
                                        w1p: w1p,
                                        h1p: h1p,
                                      ),
                                    ),
                                  ),
                                  verticalSpace(8),
                                  const FollowUpFeatureMessage(
                                    "You'll also receive a FREE 7-day follow-up with every consultation",
                                  ),

                                  verticalSpace(8),

                                  if (mgr.selectedPatientDetails != null &&
                                      billResponse?.status == true)
                                    Entry(
                                      duration: const Duration(
                                        milliseconds: 800,
                                      ),
                                      delay: const Duration(milliseconds: 0),
                                      xOffset: 200,
                                      curve: Curves.ease,
                                      child: ConfirmPatientDetails(
                                        maxWidth: maxWidth,
                                        maxHeight: maxHeight,
                                        userData: mgr.selectedPatientDetails!,
                                        dataForInstantBooking: null,
                                        dataForPsychologyInstantBooking: null,
                                        dataForScheduledBooking:
                                            SaveScheduledBookingModel(
                                              clinicId: widget.clinicInfo?.id,
                                              subSpecialityIdForPsychology: widget
                                                  .subSpecialityIdForPsychology,
                                              packageDetails: mgr
                                                  .selectedPkg
                                                  ?.packageDetails,
                                              specialityId: widget.specialityId,
                                              consultationFor:
                                                  mgr.consultingForOther == true
                                                  ? "Relative"
                                                  : "Self",
                                              subcategoryId: widget.subCatId,
                                              patientId: mgr
                                                  .selectedPatientDetails
                                                  ?.appUserId,
                                              time: widget.time,
                                              date: getIt<StateManager>()
                                                  .convertDateTimeToDDMMYYY(
                                                    widget.date,
                                                  ),
                                              doctorId:
                                                  widget.doctorDetails?.id,
                                              bookingType:
                                                  widget.isScheduledOnline ==
                                                      true
                                                  ? 1
                                                  : 2,
                                              freeFollowupBooking: null,
                                              isFreeFollowup: false,
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
                                                  ["Male", "Female"].contains(
                                                    mgr.preferredDoctorGender,
                                                  )
                                                  ? mgr.preferredDoctorGender
                                                  : null,
                                              seniorCitizenFreeConsultation:
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
                                            ),
                                        isScheduledBooking: true,
                                      ),
                                    ),
                                  if (mgr.selectedPatientDetails != null &&
                                      billResponse?.status != true)
                                    SizedBox(
                                      height: h1p * 30,
                                      child: const Center(child: LogoLoader()),
                                    ),

                                  //agree terms and conditions widget
                                  // TermsAndConditions(
                                  //     onTap: () {
                                  //       setState(() {
                                  //         agreeTerms = !agreeTerms;
                                  //       });
                                  //     },
                                  //     isAgreed: agreeTerms),

                                  // verticalSpace(h1p * 2),

                                  // payBtn(
                                  //     loader: mgr.billLoader,
                                  //     selectedPackage: mgr.selectedPkg,
                                  //     usrDetails: mgr.selectedPatientDetails,
                                  //     bDetails: SaveScheduledBookingModel(
                                  //       clinicId: widget.clinicInfo?.id,
                                  //       subSpecialityIdForPsychology: widget.subSpecialityIdForPsychology,
                                  //       packageDetails: mgr.selectedPkg?.packageDetails,
                                  //       specialityId: widget.specialityId,
                                  //       consultationFor: mgr.consultingForOther == true ? "Relative" : "Self",
                                  //       subcategoryId: widget.subCatId,
                                  //       patientId: mgr.selectedPatientDetails?.appUserId,
                                  //       time: widget.time,
                                  //       date: getIt<StateManager>().convertDateTimeToDDMMYYY(widget.date),
                                  //       doctorId: widget.doctorDetails?.id,
                                  //       bookingType: widget.isScheduledOnline == true ? 1 : 2,
                                  //       freeFollowupBooking: null,
                                  //       isFreeFollowup: false,
                                  //       seniorCitizenFreeConsultation: mgr.docsData!.seniorCitizen == true && mgr.docsData!.isAgeProofSubmitted == true,
                                  //     )),
                                  verticalSpace(16),
                                ],
                              ),
                            ),
                          ),
                          if (mgr.selectedPatientDetails == null &&
                              mgr.billLoader != true &&
                              billResponse == null) ...[
                            verticalSpace(h10p * .7),
                            Center(
                              child: Container(
                                height: h1p * 4,
                                width: maxWidth,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xffffffff),
                                      Color(0xfff3c1c1),
                                      Color(0xffffffff),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '*Please select a member',
                                    style: t500_14.copyWith(color: clrFF4444),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
