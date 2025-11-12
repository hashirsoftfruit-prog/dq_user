// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:dqapp/controller/managers/psychology_manager.dart';
import 'package:dqapp/controller/services/payment_service.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/councelling_therapy_screens/psychology_instant_doctors_screen.dart';
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
import '../../../model/core/doctors_slotpick_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/common_widgets.dart';
import '../booking_screens/booking_screen_widgets.dart';
import '../booking_screens/confirm_patient_details_popup.dart';

import '../home_screen.dart';
//BOOKING SCREENS ARE CODED AS 2 SECTIONS ONE FOR SHOWING THE PATIENT DETAILS,DOCTORS AND PACKAGES. ON THE SECOND SECTION THE BILL DETAILS AND PAYMENT SETUP ARE DONE
//THE SECOND SECTION IS SAME FOR ALL KIND OF BOOKING WHICH IS CODED ON FILE ConfirmPatientDetails() (confirm_patient_details_popup.dart)
class PsychologyInstantBookingScreen extends StatefulWidget {
  final int specialityId;
  final int? subSpecialityId;
  final int? psychologyType;
  final String? itemName;
  final DoctorDetails? doctorDetails;

  const PsychologyInstantBookingScreen({
    super.key,
    required this.specialityId,
    this.subSpecialityId,
    this.itemName,
    this.psychologyType,
    this.doctorDetails,
  });

  @override
  State<PsychologyInstantBookingScreen> createState() =>
      _PsychologyInstantBookingScreenState();
}

class _PsychologyInstantBookingScreenState
    extends State<PsychologyInstantBookingScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  dynamic billResponse;

  bool agreeTerms = true;
  bool backFromButton = false;
  var scollCntr = ScrollController();
  @override
  void initState() {
    super.initState();
    backFromButton = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<BookingManager>().getPatientsDetailsList();
      getIt<BookingManager>().setBackCalled(false);
      getIt<BookingManager>().setPaymentInitiated(false);
      // getIt<BookingManager>().getBillDetails(spID:widget.specialityId ,type:widget.isScheduledOnline==true?1:2,doctorId: widget.doctorDetails?.id );
      // if(widget.docsData.packageAvailability!=true){}
      getIt<BookingManager>().getPackages(
        widget.specialityId,
        widget.subSpecialityId,
      );
    });
    Future.delayed(Duration.zero, () async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getIt<BookingManager>().setPrefferedLanguage("English");
        getIt<BookingManager>().setPrefferedDocGender(
          StringConstants.dPrefNoPref,
        );
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBillDetails();
    });
    // scollCntr.addListener(_scrollListener);
  }

  getBillDetails() async {
    int patientId =
        getIt<SharedPreferences>().getInt(StringConstants.patientId) ?? 0;
    final patientDetails = getIt<BookingManager>().selectedPatientDetails;
    if (patientDetails != null) {
      patientId = patientDetails.id!;
    }
    billResponse = await getIt<BookingManager>().getBillDetails(
      spID: widget.specialityId,
      type: null,
      doctorId: widget.doctorDetails!.id,
      consultationCategoryForInstantCall: null,
      couponCode: getIt<BookingManager>().selectedCoupon?.couponCode,
      isSeniorCitizenConsultation:
          getIt<PsychologyManager>()
                  .psychologyInstantDoctorsModel
                  .seniorCitizen ==
              true &&
          getIt<PsychologyManager>()
                  .psychologyInstantDoctorsModel
                  .isAgeProofSubmitted ==
              true &&
          getIt<PsychologyManager>()
                  .psychologyInstantDoctorsModel
                  .isFreeDoctorAvailable ==
              true,
      packageDetails: getIt<BookingManager>().selectedPkg?.packageDetails,
      subSpecialityID: widget.subSpecialityId,
      patientId:
          patientId, //getIt<BookingManager>().selectedPatientDetails!.id,
    );
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
        // getIt<BookingManager>().setLoaderActive(false);
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
        final isBackCalled = bookingManager.isBackCalled;
        final isPaymentInitiated = bookingManager.isPaymentFlowInitiated;

        // If a payment is in progress
        if (paymentStatus && !isBackCalled) {
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
        } else {
          log("message is no payment is on process or loading");
          // If no payment is in progress → normal back navigation
          bookingManager.disposeBillScreen();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            log("message is called back from here");
            if (context.mounted &&
                !isPaymentInitiated &&
                !Platform.isIOS &&
                !isBackCalled &&
                !backFromButton) {
              getIt<BookingManager>().setBackCalled(true);
              Navigator.of(context).pop();
            }
          });
          return; // Don't pop automatically
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxHeight = constraints.maxHeight;
          double maxWidth = constraints.maxWidth;
          double h1p = maxHeight * 0.01;
          double h10p = maxHeight * 0.1;
          double w10p = maxWidth * 0.1;
          double w1p = maxWidth * 0.01;

          refreshDocData({
            required int? userId,
            required String? slotPref,
          }) async {
            var result = await getIt<PsychologyManager>()
                .getInstantDoctorsForPsychology(
                  PsychologyInstantDoctorScreenData(
                    genderPref: null,
                    language: null,
                    specialityId: widget.specialityId,
                    userId: userId,
                    psycologyType: widget.psychologyType,
                    subSpecialityId: widget.subSpecialityId,
                  ),
                );
            if (result.status == true) {
              getIt<PsychologyManager>().setPsycologyInstantDoctorsListModel(
                result,
              );
            } else {
              showTopSnackBar(
                snackBarPosition: SnackBarPosition.bottom,
                padding: const EdgeInsets.all(30),
                Overlay.of(context),
                ErrorToast(maxLines: 3, message: result.message ?? ""),
              );
            }
          }

          // payBtn({
          //   UserDetails? usrD,
          //   required bool loader,
          //   // required String amt,
          //   // required BillResponseModel bill,
          //   required PsychologyInstantBookingData bDetails,
          //   required SelectedPackageModel? selectedPackage,
          // }) {
          //   return ButtonWidget(
          //       isLoading: loader,
          //       ontap: () async {
          //         var billResponse = await getIt<BookingManager>().getBillDetails(spID: bDetails.specialityId!, type: null, doctorId: widget.doctorDetails!.id, consultationCategoryForInstantCall: null, couponCode: null, isSeniorCitizenConsultation: bDetails.seniorCitizenFreeConsultation, packageDetails: selectedPackage?.packageDetails, subSpecialityID: widget.subSpecialityId);
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
          //                     dataForInstantBooking: null,
          //                     dataForPsychologyInstantBooking: bDetails,
          //                     dataForScheduledBooking: null,
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
          //       btnText: "Continue"
          //       // amt=="0"||packageAvailability==true?locale!.bookNow:locale!.localeName=='en'?"Pay Now ":"അടക്കുക",
          //       // amount: amt,
          //       );
          // }

          return Consumer<BookingManager>(
            builder: (context, mgr, child) {
              return Scaffold(
                backgroundColor: Colors.white,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                appBar: getIt<SmallWidgets>().appBarWidget(
                  height: h10p * 0.9,
                  width: w10p,
                  title: widget.itemName ?? locale!.bookAppoinment,
                  fn: () {
                    setState(() {
                      backFromButton = true;
                    });
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
                                      '${widget.doctorDetails?.firstName ?? ""} ${widget.doctorDetails?.lastName ?? ""}',
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
                                          await refreshDocData(
                                            userId: null,
                                            slotPref:
                                                getIt<PsychologyManager>()
                                                        .psychologyInstantDoctorsModel
                                                        .isFreeDoctorAvailable ==
                                                    true
                                                ? "Free"
                                                : null,
                                          );
                                          await removePkgFn();
                                          getBillDetails();
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
                                                              await refreshDocData(
                                                                userId: mgr
                                                                    .selectedPatientDetails
                                                                    ?.appUserId,
                                                                slotPref: null,
                                                              );
                                                              getBillDetails();
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
                                                          getIt<
                                                                BookingManager
                                                              >()
                                                              .setOtherperson(
                                                                e,
                                                              );
                                                          // String? genderPref = ["Male","Female"].contains(mgr.preferredDoctorGender)==true?mgr.preferredDoctorGender:null;

                                                          await refreshDocData(
                                                            userId: e.appUserId,
                                                            slotPref:
                                                                getIt<PsychologyManager>()
                                                                        .psychologyInstantDoctorsModel
                                                                        .isFreeDoctorAvailable ==
                                                                    true
                                                                ? "Free"
                                                                : null,
                                                          );
                                                          getBillDetails();
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

                                  // Text(locale!.scheduledTime,style: t400_18.copyWith(color: clr2D2D2D),),
                                  // verticalSpace(h1p*1),

                                  // scheduledTimeAndDate(w1p: w1p,h1p: h1p,schedulDate: widget.date,time: widget.time),
                                  // if(widget.clinicInfo!=null) clinicAddress(w1p: w1p,h1p: h1p,clinic: widget.clinicInfo!),
                                  getIt<PsychologyManager>()
                                              .bookingScreenLoader ==
                                          true
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
                          getIt<PsychologyManager>()
                                          .psychologyInstantDoctorsModel
                                          .packageAvailability !=
                                      true &&
                                  mgr.selectedPkg == null &&
                                  mgr.allPackages.isNotEmpty &&
                                  (getIt<PsychologyManager>()
                                              .psychologyInstantDoctorsModel
                                              .isFreeDoctorAvailable ==
                                          false ||
                                      getIt<PsychologyManager>()
                                              .psychologyInstantDoctorsModel
                                              .seniorCitizen ==
                                          false)
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
                                                        alreadySelectedUser: mgr
                                                            .selectedPatientDetails
                                                            ?.id,
                                                        maxWidth: maxWidth,
                                                        maxHeight: maxHeight,
                                                        pkg: e,
                                                      ),
                                                );
                                                if (res != null) {
                                                  getBillDetails();
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
                                            getBillDetails();
                                          },
                                        )
                                      : const SizedBox(),

                                  verticalSpace(h1p * 1),
                                  Visibility(
                                    visible:
                                        getIt<PsychologyManager>()
                                                .psychologyInstantDoctorsModel
                                                .seniorCitizen ==
                                            true &&
                                        getIt<PsychologyManager>()
                                                .psychologyInstantDoctorsModel
                                                .isAgeProofSubmitted ==
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
                                        getIt<PsychologyManager>()
                                                .psychologyInstantDoctorsModel
                                                .seniorCitizen ==
                                            true &&
                                        getIt<PsychologyManager>()
                                                .psychologyInstantDoctorsModel
                                                .isAgeProofSubmitted ==
                                            true &&
                                        getIt<PsychologyManager>()
                                                .psychologyInstantDoctorsModel
                                                .isFreeDoctorAvailable ==
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
                                  verticalSpace(h1p * 4),

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
                                        dataForPsychologyInstantBooking:
                                            PsychologyInstantBookingData(
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
                                              packageDetails: mgr
                                                  .selectedPkg
                                                  ?.packageDetails,
                                              specialityId: widget.specialityId,
                                              subSpecialityId:
                                                  widget.subSpecialityId,
                                              psychologyType:
                                                  widget.psychologyType,
                                              consultationFor:
                                                  mgr.consultingForOther == true
                                                  ? "Relative"
                                                  : "Self",
                                              doctorId:
                                                  widget.doctorDetails!.id,
                                              seniorCitizenFreeConsultation:
                                                  getIt<PsychologyManager>()
                                                          .psychologyInstantDoctorsModel
                                                          .seniorCitizen ==
                                                      true &&
                                                  getIt<PsychologyManager>()
                                                          .psychologyInstantDoctorsModel
                                                          .isAgeProofSubmitted ==
                                                      true &&
                                                  getIt<PsychologyManager>()
                                                          .psychologyInstantDoctorsModel
                                                          .isFreeDoctorAvailable ==
                                                      true,
                                              patientId: mgr
                                                  .selectedPatientDetails
                                                  ?.appUserId,
                                            ),
                                        dataForScheduledBooking: null,
                                        isScheduledBooking: false,
                                      ),
                                    ),
                                  if (mgr.selectedPatientDetails != null &&
                                      billResponse?.status != true)
                                    SizedBox(
                                      height: h1p * 30,
                                      child: const Center(child: LogoLoader()),
                                    ),

                                  verticalSpace(16),

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
                                  //   usrD: mgr.selectedPatientDetails,
                                  //   loader: mgr.billLoader,
                                  //   selectedPackage: mgr.selectedPkg,
                                  //   bDetails: PsychologyInstantBookingData(
                                  //     packageDetails: mgr.selectedPkg?.packageDetails,
                                  //     specialityId: widget.specialityId,
                                  //     subSpecialityId: widget.subSpecialityId,
                                  //     psychologyType: widget.psychologyType,
                                  //     consultationFor: mgr.consultingForOther == true ? "Relative" : "Self",
                                  //     doctorId: widget.doctorDetails!.id,
                                  //     seniorCitizenFreeConsultation: getIt<PsychologyManager>().psychologyInstantDoctorsModel.seniorCitizen == true && getIt<PsychologyManager>().psychologyInstantDoctorsModel.isAgeProofSubmitted == true && getIt<PsychologyManager>().psychologyInstantDoctorsModel.isFreeDoctorAvailable == true,
                                  //     patientId: mgr.selectedPatientDetails?.appUserId,
                                  //   ),
                                  // ),
                                  // verticalSpace(h1p * 1),
                                ],
                              ),
                            ),
                          ),
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
