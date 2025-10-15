// ignore_for_file: use_build_context_synchronously

import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/controller/managers/pets_manager.dart';
import 'package:dqapp/model/core/other_patients_response_model.dart';
import 'package:dqapp/model/core/booking_request_data_model.dart';
import 'package:dqapp/view/screens/booking_screens/apply_coupons_screen.dart';
import 'package:dqapp/view/screens/booking_screens/package_details_screen.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/core/booking_validation_models.dart';
import '../../../model/core/doctors_slotpick_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/common_widgets.dart';
import '../booking_screens/booking_screen_widgets.dart';
import '../booking_screens/booking_success_screen.dart';
import '../home_screen.dart';

class PetScheduledBookingScreen extends StatefulWidget {
  final int specialityId;
  final int? subCatId;
  final int? clinicId;
  final int? petId;
  final String itemName;
  // bool? pkgAvailability;
  final DoctorDetails? doctorDetails;
  final DateTime date;
  final String time;
  final bool isScheduledOnline;

  const PetScheduledBookingScreen({
    super.key,
    required this.specialityId,
    required this.petId,
    this.clinicId,
    required this.itemName,
    required this.isScheduledOnline,
    required this.date,
    required this.time,
    required this.subCatId,
    this.doctorDetails,
  });

  @override
  State<PetScheduledBookingScreen> createState() =>
      _PetScheduledBookingScreenState();
}

class _PetScheduledBookingScreenState extends State<PetScheduledBookingScreen> {
  bool agreeTerms = false;
  var scollCntr = ScrollController();

  @override
  void initState() {
    // getIt<BookingManager>().getBillDetails(spID:widget.specialityId ,type:widget.isScheduledOnline==true?1:2,doctorId: widget.doctorDetails?.id );
    getIt<PetsManager>().getPetDetails(widget.petId);
    getIt<PetsManager>().getSchefuledPetBookingInfo(id: widget.petId!);
    Future.delayed(Duration.zero, () async {
      getIt<BookingManager>().setPrefferedLanguage("English");
      // getIt<BookingManager>().setPrefferedDocGender(StringConstants.dPrefNoPref);
    });
    // scollCntr.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    // scollCntr.removeListener(_scrollListener);
    scollCntr.dispose();
    getIt<PetsManager>().disposeBooking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var selectedPet = Provider.of<PetsManager>(context).selectedPet;
    var packagesList = Provider.of<BookingManager>(context).allPackages;
    var packageBillModel = Provider.of<BookingManager>(
      context,
    ).packageBillModel;
    // var couponAppliedBillModel = Provider.of<BookingManager>(context).couponAppliedBillModel;
    var billModel = Provider.of<BookingManager>(context).billModel;

    removePkgFn() async {
      getIt<BookingManager>().setSelectedPackage(null);
      getIt<BookingManager>().setLoaderActive(true);
      await Future.delayed(const Duration(milliseconds: 500), () {
        getIt<BookingManager>().setLoaderActive(false);
      });
    }

    // String username = getIt<SharedPreferences>().getString(StringConstants.userName)??"";
    // int? userId = getIt<SharedPreferences>().getInt(StringConstants.userId);
    var locale = AppLocalizations.of(context);

    // List<String> langs = ["English","Malayalam"];
    // List<String> genderPrefs = [StringConstants.dPrefNoPref,  StringConstants.dPrefMale,  StringConstants.dPrefFemale,];

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxHeight = constraints.maxHeight;
          double maxWidth = constraints.maxWidth;
          double h1p = maxHeight * 0.01;
          double h10p = maxHeight * 0.1;
          double w10p = maxWidth * 0.1;
          double w1p = maxWidth * 0.01;

          payBtn({
            UserDetails? usrD,
            required String amt,
            required SaveScheduledBookingModel bookingDetails,
            required bool? packageAvailability,
          }) {
            return GestureDetector(
              onTap: () async {
                var scheduledBookValidationResult = await getIt<PetsManager>()
                    .petScheduledBookingValidation(bookingDetails);
                if (scheduledBookValidationResult.status == true) {
                  BookingSaveResponseModel scheduledBookSaveResult =
                      await getIt<PetsManager>().petScheduledBookingSave(
                        sd: bookingDetails,
                        tempBookingID:
                            scheduledBookValidationResult.temperoryBookingId!,
                      );
                  if (scheduledBookSaveResult.status == true) {
                    // showTopSnackBar(
                    //   Overlay.of(context),
                    //   SuccessToast(
                    //     message:
                    //     scheduledBookSaveResult.message??"",
                    //   ),
                    // );
                    String? bres = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingSuccessScreen(
                          bookingSuccessData: scheduledBookSaveResult,
                        ),
                      ),
                    );

                    if (bres != null) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (ff) => false,
                      );
                    }
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      ErrorToast(
                        maxLines: 4,
                        message: scheduledBookSaveResult.message ?? "",
                      ),
                    );
                  }
                } else {
                  showTopSnackBar(
                    Overlay.of(context),
                    ErrorToast(
                      maxLines: 4,
                      message: scheduledBookValidationResult.message ?? "",
                    ),
                  );
                }

                // if(agreeTerms==true && usrD!=null) {
                //   showModalBottomSheet(
                //       backgroundColor: Colors.white,
                //       isScrollControlled: false,
                //       useSafeArea: true,
                //       showDragHandle: true,
                //       context: context,
                //       builder: (context) =>
                //           ConfirmPatientDetails(
                //               maxWidth: maxWidth,
                //               maxHeight: maxHeight,
                //               data: usrD,dataForInstantBooking: null,
                //               dataForScheduledBooking: bookingDetails,isScheduledBooking: true,
                //
                //           ));
                // }else{
                //   showTopSnackBar(
                //       Overlay.of(context),
                //       SuccessToast(
                //         message:
                //         agreeTerms!=true? locale!.youMustAgreeTermsAndConditions : locale!.selectPatientToContinue));
                // }
              },
              child: pad(
                horizontal: w1p * 6,
                child: Container(
                  width: maxWidth,
                  height: h10p * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    color: Colours.primaryblue,
                  ),
                  child: pad(
                    horizontal: 0,
                    vertical: h1p,
                    child: Center(
                      child: Text(
                        amt == "0" || packageAvailability == true
                            ? locale!.bookNow
                            : locale!.localeName == 'en'
                            ? "Pay ₹$amt Now "
                            : "₹$amt അടക്കുക",
                        style: t700_16.copyWith(color: const Color(0xffffffff)),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return Consumer<PetsManager>(
            builder: (context, mgr, child) {
              return Scaffold(
                //     floatingActionButton: Entry(yOffset: 200,
                //   // scale: 20,
                //   delay: const Duration(milliseconds: 1000),
                //   duration: const Duration(milliseconds: 500),
                //   curve: Curves.ease,
                //   // visible: mgr.showFAB,
                //   visible: false,
                //   child:billModel!=null||mgr.packageBillModel!=null?payBtn(mgr.selectedPatientDetails,mgr.packageBillModel!=null?mgr.packageBillModel!.amountAfterDiscount??"":billModel?.amountAfterDiscount??"",BookingDetailsItem(specialityId: widget.specialityId,consultationFor: mgr.consultingForOther==true?"Relative":"Self",couponId: billModel!.couponIdIfApplied,
                //       paidAmount:mgr.packageBillModel!=null?mgr.packageBillModel!.amountAfterDiscount??"":billModel?.amountAfterDiscount??"",patientId: mgr.selectedPatientDetails?.id )):SizedBox() ,
                // ),
                // extendBody: true,
                backgroundColor: Colors.white,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                // backgroundColor: Colors.white,
                appBar: getIt<SmallWidgets>().appBarWidget(
                  height: h10p * 0.9,
                  width: w10p,
                  title: widget.itemName,
                  fn: () {
                    Navigator.pop(context);
                  },
                ),
                body: ListView(
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
                                '${widget.doctorDetails?.firstName ?? ""}${widget.doctorDetails?.lastName ?? ""}',
                            type:
                                widget
                                    .doctorDetails
                                    ?.professionalQualifications ??
                                "",
                            experience: widget.doctorDetails?.experience ?? "",
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
                            selectedPet != null
                                ? Column(
                                    children: [
                                      Text(
                                        locale!.consultingFor,
                                        style: t500_16.copyWith(
                                          color: clr444444,
                                        ),
                                      ),
                                      Text(
                                        'Name : ${selectedPet.name}',
                                        style: t500_16.copyWith(
                                          color: clr444444,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            verticalSpace(h1p * 1),
                            Text(
                              locale!.scheduledTime,
                              style: t500_16.copyWith(color: clr444444),
                            ),
                            verticalSpace(h1p * 1),
                            scheduledTimeAndDate(
                              w1p: w1p,
                              h1p: h1p,
                              schedulDate: widget.date,
                              time: widget.time,
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
                            mgr.bookingInfoModel?.packageAvailability != true &&
                                    mgr.selectedPkg == null
                                ? Column(
                                    children: [
                                      const Divider(color: Colours.lightBlu),
                                      mgr.selectedCoupon != null
                                          ? SelectedCoupon(
                                              w1p: w1p,
                                              h1p: h1p,
                                              title:
                                                  mgr.selectedCoupon!.title ??
                                                  "",
                                              subTitle: "Coupon Applied",
                                              fn: () {
                                                getIt<BookingManager>()
                                                    .setSelectedCoupon(null);

                                                // getIt<BookingManager>().getBillDetails(spID:widget.specialityId ,type:widget.isScheduledOnline==true?1:2,doctorId: widget.doctorDetails?.id );
                                              },
                                            )
                                          : InkWell(
                                              highlightColor:
                                                  Colors.transparent,
                                              splashColor: Colors.transparent,
                                              onTap: () async {
                                                List<String>?
                                                result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        ApplyCouponScreen(
                                                          speciality: widget
                                                              .specialityId,
                                                          typeofBooking:
                                                              widget
                                                                  .isScheduledOnline
                                                              ? 1
                                                              : 2,
                                                          docId: widget
                                                              .doctorDetails!
                                                              .id!,
                                                        ),
                                                  ),
                                                );

                                                if (result != null) {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                          Future.delayed(
                                                            const Duration(
                                                              seconds: 3,
                                                            ),
                                                            () {
                                                              Navigator.of(
                                                                context,
                                                              ).pop(true);
                                                            },
                                                          );
                                                          return CouponAppliedWidget(
                                                            cCode: result[0],
                                                            amtSaved: result[1],
                                                            h1p: h1p,
                                                            w1p: w1p,
                                                            selected: false,
                                                            txt: "",
                                                          );
                                                        },
                                                  );
                                                }
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    locale.applyCoupon,
                                                    style: t500_14.copyWith(
                                                      color: clr444444,
                                                      height: 1,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: h1p * 5,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                        h1p,
                                                      ),
                                                      child: SvgPicture.asset(
                                                        "assets/images/forward-arrow.svg",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      const Divider(color: Colours.lightBlu),
                                      verticalSpace(h1p * 1),
                                    ],
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    mgr.bookingInfoModel?.packageAvailability != true &&
                            mgr.selectedPkg == null &&
                            packagesList.isNotEmpty
                        ? CarouselSlider(
                            options: CarouselOptions(
                              enableInfiniteScroll: packagesList.length > 1
                                  ? true
                                  : false,
                              height: 150,
                              viewportFraction: 1,
                              enlargeCenterPage: true,

                              //  height: MediaQuery.of(context).size.height*0.3,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 4),
                              // aspectRatio: 16 / 9,
                              onPageChanged: (val, ds) {
                                // print(val);
                                // getIt<StateManager>().updateScrollIndex(val);
                              },
                              // enlargeCenterPage: true
                            ),
                            items: packagesList
                                .map(
                                  (e) => InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        backgroundColor: Colors.blueGrey,
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) =>
                                            PackageDetailsScreen(
                                              maxWidth: maxWidth,
                                              maxHeight: maxHeight,
                                              pkg: e,
                                              alreadySelectedUser: null,
                                            ),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: w1p * 5,
                                      ),
                                      child: PackagesContainer(
                                        h1p: h1p,
                                        w1p: w1p,
                                        title: e.title ?? "",
                                        image: e.image ?? "",
                                        subtitle: e.subtitle ?? "",
                                        salePrice: e.cuttingAmount != null
                                            ? "₹${e.cuttingAmount!}"
                                            : "",
                                        offerPrice: "₹${e.amount ?? ""}",
                                        savedAmount: " Save ₹${e.amount ?? ""}",
                                        btnTxt: "Choose Package",
                                      ),
                                    ),
                                  ),
                                )
                                // as List<BannerList>
                                .map((item) => item)
                                .toList(),
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
                                    },
                                  )
                                : const SizedBox(),

                            verticalSpace(h1p * 2),
                            // Builder(
                            //     builder: (context) {
                            //       var bill = packageBillModel ?? couponAppliedBillModel ?? billModel;
                            //       if((bill!=null&&bill.status==true&&mgr.bookingInfoModel?.packageAvailability!=true)||(mgr.billLoader||mgr.bookingScreenLoader)){
                            //         return BillBox(isLoading:mgr.billLoader||mgr.bookingScreenLoader,h1p: h1p, w1p: w1p, cnsultFee:bill?.fee , serviceFee:bill?.tax, discnt:bill?.discount ,packagePriceIfAdded:bill?.pkgAmount , totalAmt: bill?.amountAfterDiscount??"",amtIfCouponApplied :mgr.selectedCoupon!=null?bill?.couponAppliedAmt:null,platformFee: bill?.platformFee,);
                            //       }else if(mgr.bookingInfoModel?.packageAvailability==true){
                            //         return SizedBox(child:Center(child: Text(locale.thisBookingIsComingUnderThePackage,style: TextStyles.textStyle17,)));
                            //       }else{
                            //         return SizedBox();
                            //
                            //       }
                            //     }
                            // ),
                            verticalSpace(h1p * 2),

                            //agree terms and conditions widget
                            agreeTermsWidget(
                              h1p: h1p,
                              w1p: w1p,
                              agreeTerms: agreeTerms,
                              ontap: () {
                                setState(() {
                                  agreeTerms = !agreeTerms;
                                });
                              },
                            ),

                            verticalSpace(h1p * 2),

                            billModel != null || packageBillModel != null
                                ? payBtn(
                                    amt: packageBillModel != null
                                        ? packageBillModel
                                                  .amountAfterDiscount ??
                                              ""
                                        : billModel?.amountAfterDiscount ?? "",
                                    bookingDetails: SaveScheduledBookingModel(
                                      clinicId: widget.clinicId,
                                      petId: widget.petId,
                                      // gender:["Male","Female"].contains(mgr.prefrrdDocGender)?mgr.prefrrdDocGender:null,
                                      packageDetails:
                                          mgr.selectedPkg?.packageDetails,
                                      specialityId: widget.specialityId,
                                      subcategoryId: widget.subCatId,
                                      time: widget.time,
                                      date: getIt<StateManager>()
                                          .convertDateTimeToDDMMYYY(
                                            widget.date,
                                          ),
                                      doctorId: widget.doctorDetails?.id,
                                      bookingType:
                                          widget.isScheduledOnline == true
                                          ? 1
                                          : 2,
                                      freeFollowupBooking: null,
                                      isFreeFollowup: false,
                                      seniorCitizenFreeConsultation: false,
                                    ),
                                    packageAvailability: mgr
                                        .bookingInfoModel
                                        ?.packageAvailability,
                                  )
                                : const SizedBox(),
                            verticalSpace(h1p * 1),
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
