import 'package:dqapp/controller/managers/psychology_manager.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../l10n/app_localizations.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../theme/text_styles.dart';
import '../booking_screens/redacted_loaders.dart';

class PsychologyCheckIfDoctorAvailabieScreen extends StatefulWidget {
  final int specialityId;
  final String specialityTitle;
  final int? typeOfPsychology;
  final int? subspecialityId;
  const PsychologyCheckIfDoctorAvailabieScreen({
    super.key,
    required this.specialityId,
    // this.categoryId,
    this.typeOfPsychology,
    required this.specialityTitle,
    this.subspecialityId,
  });

  @override
  State<PsychologyCheckIfDoctorAvailabieScreen> createState() =>
      PsychologyCheckIfDoctorAvailabieScreenState();
}

class PsychologyCheckIfDoctorAvailabieScreenState
    extends State<PsychologyCheckIfDoctorAvailabieScreen> {
  @override
  void initState() {
    super.initState();

    getIt<PsychologyManager>().onlineBookingRedirectionFn(
      specialityId: widget.specialityId,
      typeOfPsychology: widget.typeOfPsychology,
      subspecialityId: widget.subspecialityId,
      // categoryId: widget.categoryId,
      specialityTitle: widget.specialityTitle,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    // return LayoutBuilder(builder: (context, constraints) {
    //   double maxHeight = constraints.maxHeight;
    //   double maxWidth = constraints.maxWidth;
    //   // double h1p = maxHeight * 0.01;
    //   double h10p = maxHeight * 0.1;
    // double w10p = maxWidth * 0.1;
    // double w1p = maxWidth * 0.01;

    return TherapistBookingScreenLoader(
      psychologyType: widget.typeOfPsychology,
    );

    // return Scaffold(
    //     resizeToAvoidBottomInset: true,
    //     backgroundColor: Colors.white,
    //     body: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         SizedBox(height: h10p * 2, width: maxWidth, child: Lottie.asset('assets/images/doc-search.json')),
    //         // myLoader(visibility: true),
    //       ],
    //     ));
    // });
  }
}

class TherapistBookingScreenLoader extends StatelessWidget {
  final int? psychologyType;
  const TherapistBookingScreenLoader({super.key, this.psychologyType});

  @override
  Widget build(BuildContext context) {
    var scollCntr = ScrollController();
    var locale = AppLocalizations.of(context);

    gradientDivider(List<Color> colors) {
      return Expanded(
        child: Container(
          height: 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;
        return Scaffold(
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
                            padding: EdgeInsets.symmetric(horizontal: w1p * 4),
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
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              width: maxWidth,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color(0xffFFCB9F).withOpacity(0.5),
                                    const Color(0xffFFCB9F),
                                    const Color(0xffFFCB9F).withOpacity(0.5),
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // print(widget.psychologyType);
                                      // Navigator.push(context, MaterialPageRoute(builder: (_) => CheckIfDoctorAvailableScreen(categoryId: null, specialityId: widget.specialityId, typeOfPsychology: widget.psychologyType, subspecialityId: widget.subspecialityId, specialityTitle: widget.itemName)));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      height: 28,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(9),
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
                                    style: t400_14.copyWith(color: clr2D2D2D),
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
                            psychologyType == 2 ? "Therapist" : "Counsellor",
                            style: t500_20.copyWith(
                              color: const Color(0xff5E9CCD),
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(8),

                    Entry(
                      xOffset: 500,
                      // scale: 20,
                      delay: const Duration(milliseconds: 0),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.ease,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            verticalSpace(16),
                            Text(
                              locale?.preferredLanguage ?? 'Preferred Language',
                              style: t500_14.copyWith(color: clr2D2D2D),
                            ),
                            verticalSpace(h1p),
                            const Row(
                              children: [
                                SkeletonBox(width: 100, height: 30),
                                SizedBox(width: 8),
                                SkeletonBox(width: 100, height: 30),
                              ],
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
                              locale?.preferredDoc ?? 'Doctor Preference',
                              style: t500_14.copyWith(color: clr2D2D2D),
                            ),
                            verticalSpace(8),
                            const Row(
                              children: [
                                SkeletonBox(width: 100, height: 30),
                                SizedBox(width: 8),
                                SkeletonBox(width: 100, height: 30),
                                SizedBox(width: 8),
                                SkeletonBox(width: 100, height: 30),
                              ],
                            ),
                            verticalSpace(16),
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
                            // SizedBox(
                            //   height: 200,
                            //   child: GridView.builder(
                            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            //       crossAxisCount: 2,
                            //       mainAxisSpacing: 16,
                            //       crossAxisSpacing: 16,
                            //       childAspectRatio: 0.7,
                            //     ),
                            //     itemCount: 6,
                            //     itemBuilder: (context, index) {
                            //       return Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Container(
                            //             height: 80,
                            //             width: double.infinity,
                            //             decoration: BoxDecoration(
                            //               color: Colors.grey.shade300,
                            //               borderRadius: BorderRadius.circular(12),
                            //             ),
                            //           ),
                            //           const SizedBox(height: 8),
                            //           Container(
                            //             height: 12,
                            //             width: 100,
                            //             decoration: BoxDecoration(
                            //               color: Colors.grey.shade300,
                            //               borderRadius: BorderRadius.circular(8),
                            //             ),
                            //           ),
                            //           const SizedBox(height: 4),
                            //           Container(
                            //             height: 12,
                            //             width: 60,
                            //             decoration: BoxDecoration(
                            //               color: Colors.grey.shade300,
                            //               borderRadius: BorderRadius.circular(8),
                            //             ),
                            //           ),
                            //           const Spacer(),
                            //           Container(
                            //             height: 36,
                            //             width: double.infinity,
                            //             decoration: BoxDecoration(
                            //               color: Colors.orange.shade200,
                            //               borderRadius: BorderRadius.circular(8),
                            //             ),
                            //           ),
                            //         ],
                            //       );
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),

                    // verticalSpace(h1p),
                    verticalSpace(8),

                    verticalSpace(8),
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
