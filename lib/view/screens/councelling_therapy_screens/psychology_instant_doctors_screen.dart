// ignore_for_file: use_build_context_synchronously

import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/controller/managers/psychology_manager.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/model/core/doctors_slotpick_model.dart';
import 'package:dqapp/view/screens/councelling_therapy_screens/psychology_instant_booking_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../controller/managers/state_manager.dart';
import '../../../model/core/available_doctors_response_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/common_widgets.dart';
import '../booking_screens/booking_loading_screen.dart';
import '../booking_screens/booking_screen_widgets.dart';
import '../booking_screens/redacted_loaders.dart';

class PsychologyInstantDoctorsScreen extends StatefulWidget {
  final int specialityId;
  final int? subspecialityId;
  final int? psychologyType;
  final String itemName;

  const PsychologyInstantDoctorsScreen({
    super.key,
    required this.specialityId,
    required this.itemName,
    this.subspecialityId,
    this.psychologyType,
  });

  @override
  State<PsychologyInstantDoctorsScreen> createState() =>
      _PsychologyInstantDoctorsScreenState();
}

class _PsychologyInstantDoctorsScreenState
    extends State<PsychologyInstantDoctorsScreen>
    with TickerProviderStateMixin {
  bool agreeTerms = false;
  var scollCntr = ScrollController();

  @override
  void initState() {
    super.initState();

    initFns();

    // scollCntr.addListener(_scrollListener);
  }

  initFns() async {
    await getIt<PsychologyManager>().setPsycologyInstantRequestData(
      PsychologyInstantDoctorScreenData(
        genderPref: StringConstants.dPrefNoPref,
        language: "English",
        specialityId: widget.specialityId,
        psycologyType: widget.psychologyType,
        subSpecialityId: widget.subspecialityId,
      ),
    );
  }

  @override
  void dispose() {
    scollCntr.dispose();
    getIt<BookingManager>().disposeBooking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    gradientDivider(List<Color> colors) {
      return Expanded(
        child: Container(
          height: 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
        ),
      );
    }

    // String label = StringConstants.tempIconViewStatus == true ? 'DQ' : 'Medico';
    // int? userId = getIt<SharedPreferences>().getInt(StringConstants.userId);
    var locale = AppLocalizations.of(context);

    List<String> langs = ["English", "Malayalam"];
    List<String> genderPrefs = [
      StringConstants.dPrefNoPref,
      StringConstants.dPrefMale,
      StringConstants.dPrefFemale,
    ];
    // List<String> consultOthers = ["Father", "Mother", "Spouse", "Other"];

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        // Widget doctorCategory({required DoctorCatogory? category, required DoctorCatogory? selectedCategory, bool? isMid}) {
        //   String? title = category?.title;
        //   bool isDoctorExist = category?.doctors != null && category!.doctors!.isNotEmpty;
        //   bool isSeleccted = selectedCategory?.consultationCategory == category?.consultationCategory;
        //   return Expanded(
        //     child: GestureDetector(
        //       onTap: () {
        //         if (isDoctorExist) {
        //           getIt<BookingManager>().selectPriceCategory(category);
        //         }
        //       },
        //       child: Opacity(
        //         opacity: isDoctorExist ? 1 : 0.6,
        //         child: Container(
        //           height: 28,
        //           margin: const EdgeInsets.only(right: 2),
        //           decoration: BoxDecoration(color: isSeleccted ? clrEEEFFF : clrFFFFFF, border: Border.all(color: isSeleccted ? clr2E3192 : clrC4C4C4), borderRadius: BorderRadius.circular(9)),
        //           child: Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2.0),
        //             child: Row(
        //               children: [
        //                 SizedBox(width: 21, height: 21, child: Image.asset("assets/images/rupees-sign.png")),
        //                 horizontalSpace(6),
        //                 Text(
        //                   title ?? '',
        //                   style: t400_14.copyWith(color: isSeleccted ? clr2E3192 : clr858585),
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   );
        // }

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

        return Consumer<PsychologyManager>(
          builder: (context, mgr, child) {
            return Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.white,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              body: SafeArea(
                child: CustomScrollView(
                  controller: scollCntr,
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      expandedHeight: 200,
                      collapsedHeight: 128,
                      flexibleSpace: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Spacer(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w1p * 4,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    // Navigator.popUntil(context, ModalRoute.withName(RouteNames.home));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 0,
                                      bottom: 8,
                                      top: 8,
                                    ),
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: SvgPicture.asset(
                                        "assets/images/back-arrow-cupertino.svg",
                                        colorFilter: ColorFilter.mode(
                                          clr2D2D2D,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              verticalSpace(4),

                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  width: maxWidth,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        const Color(
                                          0xffFFCB9F,
                                        ).withOpacity(0.5),
                                        const Color(0xffFFCB9F),
                                        const Color(
                                          0xffFFCB9F,
                                        ).withOpacity(0.5),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // print(widget.psychologyType);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  CheckIfDoctorAvailableScreen(
                                                    categoryId: null,
                                                    specialityId:
                                                        -1, //widget.specialityId,
                                                    typeOfPsychology:
                                                        widget.psychologyType,
                                                    subspecialityId:
                                                        widget.subspecialityId,
                                                    specialityTitle:
                                                        widget.itemName,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          height: 28,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              9,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(0, 1),
                                                blurRadius: 4,
                                                spreadRadius: 0,
                                                color: Colors.black.withOpacity(
                                                  0.25,
                                                ),
                                              ),
                                            ],
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Consult Available Counsellor",
                                                style: t500_14.copyWith(
                                                  color: clr2D2D2D,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      verticalSpace(2),
                                      Text(
                                        "We will assign you  the best doctors",
                                        style: t400_14.copyWith(
                                          color: clr2D2D2D,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Row(
                          children: [
                            gradientDivider([
                              const Color(0xff9A9A9A).withOpacity(0.2),
                              const Color(0xff626262),
                            ]),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "or",
                                style: t400_14.copyWith(color: clr2D2D2D),
                              ),
                            ),
                            gradientDivider([
                              const Color(0xff626262),
                              const Color(0xff9A9A9A).withOpacity(0.2),
                            ]),
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: w1p * 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Choose your",
                                style: t400_18.copyWith(
                                  color: const Color(0xff5E9CCD),
                                ),
                              ),
                              Text(
                                widget.psychologyType == 2
                                    ? "Therapist"
                                    : "Counsellor",
                                style: t500_20.copyWith(
                                  color: const Color(0xff5E9CCD),
                                ),
                              ),
                            ],
                          ),
                        ),
                        verticalSpace(8),

                        Entry(
                          // xOffset: 500,
                          // // scale: 20,
                          // delay: const Duration(milliseconds: 0),
                          // duration: const Duration(milliseconds: 1000),
                          // curve: Curves.ease,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                verticalSpace(16),
                                Text(
                                  locale!.preferredLanguage,
                                  style: t500_14.copyWith(color: clr2D2D2D),
                                ),
                                verticalSpace(h1p),
                                Wrap(
                                  children: langs
                                      .map(
                                        (e) => InkWell(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () async {
                                            await getIt<PsychologyManager>()
                                                .setLanguageForInstantPsychology(
                                                  e,
                                                );
                                            var result = await getIt<PsychologyManager>()
                                                .getInstantDoctorsForPsychology(
                                                  PsychologyInstantDoctorScreenData(
                                                    genderPref:
                                                        mgr
                                                                .psychologyInstantRequestData
                                                                .genderPref ==
                                                            "No preference"
                                                        ? null
                                                        : mgr
                                                              .psychologyInstantRequestData
                                                              .genderPref,
                                                    language: e,
                                                    specialityId:
                                                        widget.specialityId,
                                                    psycologyType:
                                                        widget.psychologyType,
                                                    subSpecialityId:
                                                        widget.subspecialityId,
                                                  ),
                                                );
                                            if (result.status == true &&
                                                result.doctors != null &&
                                                result.doctors!.isNotEmpty) {
                                              await getIt<PsychologyManager>()
                                                  .setPsycologyInstantDoctorsListModel(
                                                    result,
                                                  );
                                            } else {
                                              showTopSnackBar(
                                                snackBarPosition:
                                                    SnackBarPosition.top,
                                                padding: const EdgeInsets.all(
                                                  30,
                                                ),
                                                Overlay.of(context),
                                                ErrorToast(
                                                  maxLines: 3,
                                                  message: result.message ?? "",
                                                ),
                                              );
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
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
                                              e ==
                                                  mgr
                                                      .psychologyInstantRequestData
                                                      .language,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  // Text("Malayalam",style: TextStyles.textStyle35,),
                                ),
                                verticalSpace(15),
                                Row(
                                  children: [
                                    gradientDivider([
                                      const Color(0xffE3E3E3).withOpacity(0.5),
                                      const Color(0xff959595),
                                      const Color(0xffE3E3E3).withOpacity(0.5),
                                    ]),
                                  ],
                                ),
                                verticalSpace(15),
                                Text(
                                  locale.preferredDoc,
                                  style: t500_14.copyWith(color: clr2D2D2D),
                                ),
                                verticalSpace(h1p),
                                Wrap(
                                  children: genderPrefs
                                      .map(
                                        (gender) => InkWell(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () async {
                                            var result = await getIt<PsychologyManager>()
                                                .getInstantDoctorsForPsychology(
                                                  PsychologyInstantDoctorScreenData(
                                                    genderPref:
                                                        gender ==
                                                            "No preference"
                                                        ? null
                                                        : gender,
                                                    language: mgr
                                                        .psychologyInstantRequestData
                                                        .language,
                                                    specialityId:
                                                        widget.specialityId,
                                                    psycologyType:
                                                        widget.psychologyType,
                                                    subSpecialityId:
                                                        widget.subspecialityId,
                                                  ),
                                                );
                                            if (result.status == true &&
                                                result.doctors != null &&
                                                result.doctors!.isNotEmpty) {
                                              getIt<PsychologyManager>()
                                                  .setGenderPreference(gender);

                                              await getIt<PsychologyManager>()
                                                  .setPsycologyInstantDoctorsListModel(
                                                    result,
                                                  );
                                            } else {
                                              showTopSnackBar(
                                                snackBarPosition:
                                                    SnackBarPosition.top,
                                                padding: const EdgeInsets.all(
                                                  30,
                                                ),
                                                Overlay.of(context),
                                                ErrorToast(
                                                  maxLines: 3,
                                                  message: result.message ?? "",
                                                ),
                                              );
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8,
                                              left: 2,
                                            ),
                                            child: selectionBox(
                                              getIt<StateManager>()
                                                      .getLocaleTxt(
                                                        gender,
                                                        context,
                                                      ) ??
                                                  "",
                                              gender ==
                                                  mgr
                                                      .psychologyInstantRequestData
                                                      .genderPref,
                                            ),
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

                        // verticalSpace(h1p),
                        verticalSpace(8),

                        verticalSpace(8),
                      ]),
                    ),
                    if (mgr.bookingScreenLoader)
                      SliverList(
                        delegate: SliverChildListDelegate([
                          for (var i = 0; i < 3; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  for (var i = 0; i < 2; i++)
                                    Column(
                                      children: [
                                        SkeletonBox(
                                          width: maxWidth / 2.2,
                                          height: 140,
                                        ),
                                        verticalSpace(4),
                                        SkeletonBox(
                                          width: maxWidth / 2.2,
                                          height: 32,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                        ]),
                      ),
                    // if (mgr.bookingScreenLoader) SliverList(delegate: SliverChildListDelegate([const Center(child: CircularProgressIndicator())])),
                    if (mgr.psychologyInstantDoctorsModel.status == true &&
                        mgr.psychologyInstantDoctorsModel.doctors != null &&
                        mgr.bookingScreenLoader != true)
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: w1p * 2,
                        ), // Optional spacing
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              var doc = mgr
                                  .psychologyInstantDoctorsModel
                                  .doctors![index];
                              return GestureDetector(
                                onTap: () async {
                                  getIt<BookingManager>().setDocsData(
                                    BookingDataDetailsModel.fromJson(
                                      mgr.psychologyInstantDoctorsModel
                                          .toJson(),
                                    ),
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PsychologyInstantBookingScreen(
                                            itemName: widget.itemName,
                                            psychologyType:
                                                widget.psychologyType,
                                            subSpecialityId:
                                                widget.subspecialityId,
                                            specialityId: widget.specialityId,
                                            doctorDetails: DoctorDetails(
                                              image: doc.image,
                                              id: doc.id,
                                              firstName: doc.firstName,
                                              lastName: doc.lastName,
                                              experience: doc.experience,
                                              professionalQualifications:
                                                  doc.qualification,
                                            ),
                                          ),
                                    ),
                                  );
                                },
                                child: DoctorsItemWithFeeInBookingScreen(
                                  maxHeight: maxHeight,
                                  maxWidth: maxWidth,
                                  data: doc,
                                ),
                              );
                            },
                            childCount: mgr
                                .psychologyInstantDoctorsModel
                                .doctors!
                                .length,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 items per row
                                crossAxisSpacing: 4,
                                mainAxisExtent: 250,
                                mainAxisSpacing: 4,
                                // childAspectRatio: 1, // Adjust as needed to prevent overflow
                              ),
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

class PsychologyInstantDoctorScreenData {
  String? language;
  String? genderPref;
  int? userId;
  int? psycologyType;
  int? subSpecialityId;
  int? specialityId;

  PsychologyInstantDoctorScreenData({
    this.language,
    this.userId,
    this.psycologyType,
    this.genderPref,
    this.specialityId,
    this.subSpecialityId,
  });
}
