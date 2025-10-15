import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/councelling_therapy_screens/choose_consultation_type_screen.dart';
import 'package:dqapp/view/screens/councelling_therapy_screens/psychology_check_doctor_availability_screen.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controller/managers/psychology_manager.dart';
import '../../../model/core/therapy_councelling_list_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../theme/text_styles.dart';
import '../booking_screens/find_doctors_screen.dart';
import '../booking_screens/redacted_loaders.dart';
import '../home_screen_widgets.dart';

class TharapiesListScreen extends StatefulWidget {
  const TharapiesListScreen({super.key});

  @override
  State<TharapiesListScreen> createState() => _TharapiesListScreenState();
}

class _TharapiesListScreenState extends State<TharapiesListScreen> {
  ScrollController scCntrol = ScrollController();

  @override
  void initState() {
    super.initState();

    getIt<PsychologyManager>().getTharapiesOrCoucellingList(typeId: 2);

    // scCntrol.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    fn({
      required int specialityId,
      required int? subSpecialityId,
      required String specialityTitle,
    }) async {
      var res = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChooseConsultationTypeScreen()),
      );

      if (res == "Instant") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PsychologyCheckIfDoctorAvailabieScreen(
              // categoryId:categoryId,
              specialityId: -1, //specialityId,
              specialityTitle: specialityTitle,
              typeOfPsychology: StringConstants.psychologyTypeforTherapy,
              subspecialityId: subSpecialityId,
            ),
          ),
        );
      } else if (res == "Scheduled") {
        getIt<BookingManager>().setPsychologyBookingType(
          StringConstants.psychologyTypeforTherapy,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FindDoctorsListScreen(
              specialityId: -1, //specialityId,
              subSpecialityIdForPsychology: subSpecialityId,
            ),
          ),
        );
      }
    }

    var get = getIt<SmallWidgets>();
    bool availableDocsLoader = Provider.of<BookingManager>(
      context,
    ).bookingScreenLoader;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        // double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        // SliverGridDelegateWithFixedCrossAxisCount params =    SliverGridDelegateWithFixedCrossAxisCount(
        //   mainAxisExtent: 100,
        //     // maxCrossAxisExtent: 100,
        //     // childAspectRatio: 1/1,
        //     crossAxisSpacing: 2,mainAxisSpacing: 2,
        //     crossAxisCount: 2
        // );

        return Consumer<PsychologyManager>(
          builder: (context, mgr, child) {
            // OnlineCategoriesModel? model = mgr.onlineCats;
            List<TherapyOrCouncellingItem>? therapies =
                mgr.therapyCouncellingListModel?.therapy ?? [];

            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              extendBody: true,

              // appBar: get.appBarWidget(
              //     title: widget.forScheduledBooking == true
              //         ? AppLocalizations.of(context)!.findDoctorsClinic
              //         :AppLocalizations.of(context)!.liveVideoConsult2,
              //     height: h10p,
              //     width: w10p,
              //     fn: () {
              //       Navigator.pop(context);
              //     })
              // ,
              body: Stack(
                children: [
                  Entry(
                    xOffset: 1000,
                    // scale: 20,
                    delay: const Duration(milliseconds: 0),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.ease,
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          foregroundColor: Colors.white,
                          // backgroundColor:clrFFEDEE,
                          floating: true,
                          pinned: true,
                          // toolbarHeight: 136,
                          toolbarHeight: 60,

                          flexibleSpace: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20),
                              ),
                            ),
                            child: SafeArea(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w1p * 4,
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: SizedBox(
                                            height: 25,
                                            child: Image.asset(
                                              "assets/images/back-cupertino.png",
                                            ),
                                          ),
                                        ),

                                        const Spacer(),
                                        Text(
                                          "Therapies",
                                          style: t700_16.copyWith(
                                            color: clr2D2D2D,
                                          ),
                                        ),

                                        const Spacer(),
                                        const SizedBox(width: 40),
                                        // SizedBox(
                                        //     height: 25,
                                        //     child: Image.asset("assets/images/location-icon.png")),
                                        // horizontalSpace(2),
                                        // Text("Kozhikode",style: t700_14.copyWith(color: clr2D2D2D),)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        mgr.listLoader
                            ? SliverPadding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w1p * 4,
                                ),
                                sliver: SliverList(
                                  delegate: SliverChildListDelegate([
                                    const TherapySelectionSkeleton(),
                                  ]),
                                ),
                              )
                            : SliverPadding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w1p * 4,
                                ),
                                sliver: SliverList(
                                  delegate: SliverChildListDelegate([
                                    get.searchBarBox(
                                      title: AppLocalizations.of(
                                        context,
                                      )!.searchSpecialitesSymptoms,
                                      height: h10p,
                                      width: w10p,
                                    ),
                                  ]),

                                  //    pad(horizontal: w1p*6,
                                  //   child:   mgr.onlineCatLoader?CircularProgressIndicator():ListView(
                                  //
                                  //     children: [
                                  //
                                  //
                                  //     ],
                                  //
                                  //   ),
                                  // ),
                                ),
                              ),
                        SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: w1p * 4,
                            vertical: h10p / 10,
                          ), // Optional spacing
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              var title = therapies[index].title;
                              var img = therapies[index].image ?? "";
                              var subSpecialityId = therapies[index].id;
                              var speciality = therapies[index].speciality;

                              return TherapiesContainer(
                                itemHeight: 140,

                                alignment: Alignment.center,

                                image: img,
                                title2: title ?? "",
                                onClick: () async {
                                  await fn(
                                    specialityTitle: title ?? '',
                                    specialityId: -1, //speciality!,
                                    subSpecialityId: subSpecialityId!,
                                  );
                                },
                                maxWidth: maxWidth,
                                // color: Colors.amber,
                              );
                            }, childCount: therapies.length),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisExtent: maxWidth * 0.4,
                              mainAxisSpacing: 8,
                              // childAspectRatio: 1, // Adjust as needed to prevent overflow
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  myLoader(
                    width: maxWidth,
                    height: maxHeight,
                    color: clrFA8E53,
                    visibility: availableDocsLoader,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
