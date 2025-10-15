// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/booking_screens/find_doctors_screen.dart';
import 'package:dqapp/view/screens/councelling_therapy_screens/psychology_check_doctor_availability_screen.dart';
import 'package:dqapp/view/screens/councelling_therapy_screens/psychology_screen_widgets.dart';
import 'package:dqapp/view/screens/councelling_therapy_screens/tharapies_list_screen.dart';
import 'package:dqapp/view/screens/councelling_therapy_screens/videos_list_screen.dart';
import 'package:dqapp/view/screens/home_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../controller/managers/psychology_manager.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/core/psychology_data.dart';
import '../../../model/core/therapy_councelling_list_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../drawer_menu_screens/upcoming_appoinments_screen.dart';
import '../home_screen_widgets.dart';
import 'choose_consultation_type_screen.dart';
import 'councelling_list_screen.dart';
import 'music_list_screen.dart';

class CounsellingScreen extends StatefulWidget {
  final String title;
  const CounsellingScreen({super.key, required this.title});

  @override
  State<CounsellingScreen> createState() => CounsellingScreenState();
}

class CounsellingScreenState extends State<CounsellingScreen> {
  DateTime selectedDate = DateTime.now();
  late PageController _controller;

  @override
  void initState() {
    // getIt<HomeManager>().getPsychologyTherapy();
    getIt<PsychologyManager>().getPsychologyData();
    getIt<PsychologyManager>().fetchDailyWellnessByDate();
    getIt<PsychologyManager>().getPsychologyBookings();
    _controller = PageController(viewportFraction: 0.7);
    super.initState();
  }

  // final double _sliderValue = 0;

  List<Color> therapyColors = [
    const Color(0xffBD9F92),
    const Color(0xffFF8C5B),
    const Color(0xff9BB261),
    const Color(0xffFFCC10),
  ];

  List<TherapyTutorial> therapyTutorial = [
    TherapyTutorial(
      stepNo: "1",
      image: "assets/images/therapy-tutorial-1.png",
      title: "Find a Mental Health Professional",
    ),
    TherapyTutorial(
      stepNo: "2",
      image: "assets/images/therapy-tutorial-2.png",
      title: "Develop a treatment plan with your therapist",
    ),
    TherapyTutorial(
      stepNo: "3",
      image: "assets/images/therapy-tutorial-3.png",
      title:
          "Receive support, guidance & develop new coping skills to stay on track",
    ),
  ];

  fn({
    required int specialityId,
    required String specialityTitle,
    required int type,
    required int? subSpecialityId,
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
            typeOfPsychology: type,
            subspecialityId: subSpecialityId,
          ),
        ),
      );
    } else if (res == "Scheduled") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FindDoctorsListScreen(
            specialityId: -1, // specialityId,
            subSpecialityIdForPsychology: subSpecialityId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String username =
        getIt<SharedPreferences>().getString(StringConstants.userName) ?? "";
    var locale = AppLocalizations.of(context);

    gradientDivider() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Container(
          height: 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xff9A9A9A).withOpacity(0.2),
                const Color(0xff626262),
                const Color(0xff9A9A9A).withOpacity(0.2),
              ],
            ),
          ),
        ),
      );
    }

    getMainShapeWidget({
      required String mainImage,
      required Function onTap,
      required String title,
      required String subImage,
      required TextStyle titleStyle,
    }) {
      return Expanded(
        child: GestureDetector(
          onTap: () => onTap(),
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(mainImage),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 16),
                  child: Text(title, style: titleStyle),
                ),
                Expanded(
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset(subImage),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // fn({
    //   required int specialityId,
    //   required String specialityTitle,
    // })async{
    //   var result = await getIt<BookingManager>().getDocsList(specialityId: specialityId);
    //   if(result.status==true&&result.doctors!.isNotEmpty) {
    //     getIt<BookingManager>().setDocsData(result);
    //
    //     Navigator.push(context, MaterialPageRoute(builder: (_)=>BookingScreen(subCatId:null,specialityId: specialityId,itemName: specialityTitle,pkgAvailability:result.packageAvailability, )));
    //
    //   }else{
    //
    //     showTopSnackBar(
    //         Overlay.of(context),
    //         ErrorToast(
    //           message:
    //           result.message??"",
    //         ));
    //   }
    // }

    // int typeOfSymtoms = 1;
    // int typeOfTherapy = 2;
    // int typeOfcounselling = 3;
    var get = getIt<SmallWidgets>();
    // double heightf =   Provider.of<StateManager>(context).heightF;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return Consumer<PsychologyManager>(
          builder: (context, mgr, child) {
            // var counsellingListModel = mgr.counsellingListModel;
            PsychologyData? psychologyData = mgr.psychologyData;
            List<String> labels = psychologyData?.sleepQuality != null
                ? psychologyData!.sleepQuality!.map((e) => e.title!).toList()
                : [];
            List<String> hours = psychologyData?.sleepQuality != null
                ? psychologyData!.sleepQuality!
                      .map(
                        (e) => getIt<PsychologyManager>()
                            .changeHourValueToSigleLine(e.fromTime!, e.toTime!),
                      )
                      .toList()
                : [];
            int? selectedEmotion = mgr.dailyWellnessDataModel != null
                ? mgr.dailyWellnessDataModel!.selectedEmotionCode ??
                      mgr.dailyWellnessDataModel!.dailyEmotion?.code
                : null;
            int? selectedSleepQuality = mgr.dailyWellnessDataModel != null
                ? mgr.dailyWellnessDataModel!.selectedSleepQualityId ??
                      mgr
                          .dailyWellnessDataModel!
                          .dailySleepQuality
                          ?.sleepQualityId
                : 0;
            List<TherapyOrCouncellingItem> dashboardTherapies =
                psychologyData?.dashboardTherapy ?? [];

            // var popSpecialites ;

            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              extendBody: true,
              // appBar: get.appBarWidget(title: widget.title, height: h10p, width: w10p,fn: (){
              //   Navigator.pop(context);
              // }),
              body: Container(
                height: maxHeight,
                width: maxWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xffFFCB9F),
                      clrFFFFFF,
                      clrFFFFFF,
                      clrFFFFFF,
                      // clrFFFFFF,
                    ],
                    end: Alignment.bottomCenter,
                    begin: Alignment.topCenter,
                  ),
                ),
                child: Entry(
                  // xOffset: 800,
                  // // scale: 20,
                  // delay: const Duration(milliseconds: 100),
                  // duration: const Duration(milliseconds: 900),
                  // curve: Curves.ease,
                  child: mgr.listLoader == true
                      ? myLoader(visibility: true)
                      : SafeArea(
                          child: CustomScrollView(
                            slivers: [
                              SliverPersistentHeader(
                                delegate: AppBarForCouncelling(
                                  title1: "Hi $username",
                                  title2: "Good Morning",
                                  w1p: w1p,
                                  minHeight: 60,
                                  maxHeight: 120,
                                  // slotCount: "${mgr.doctorSlotPickModel?.selectedDate?.timeList?.length??0} ${AppLocalizations.of(context)!.slotsAvailable}", // Replace with your asset path
                                ),
                                pinned:
                                    false, // Keeps it at the top while scrolling
                              ),
                              SliverPadding(
                                padding: const EdgeInsets.only(top: 12.0),
                                sliver: SliverList(
                                  delegate: SliverChildListDelegate([
                                    get.searchBarBox(
                                      title:
                                          "${AppLocalizations.of(context)!.search} ${widget.title}",
                                      height: h10p,
                                      width: w10p,
                                    ),
                                    verticalSpace(h1p),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: w1p * 4,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  getMainShapeWidget(
                                                    title: "Counselling",
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              const CouncellingListScreen(),
                                                        ),
                                                      );
                                                    },
                                                    mainImage:
                                                        "assets/images/councelling-main-shape-1.png",
                                                    subImage:
                                                        "assets/images/councelling-sub-image-1.png",
                                                    titleStyle: t500_14
                                                        .copyWith(
                                                          color: clrFFFFFF,
                                                        ),
                                                  ),
                                                  horizontalSpace(4),
                                                  getMainShapeWidget(
                                                    title: "Therapy",
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              const TharapiesListScreen(),
                                                        ),
                                                      );
                                                    },
                                                    mainImage:
                                                        "assets/images/councelling-main-shape-2.png",
                                                    subImage:
                                                        "assets/images/councelling-sub-image-2.png",
                                                    titleStyle: t500_14
                                                        .copyWith(
                                                          color: const Color(
                                                            0xffF68629,
                                                          ),
                                                        ),
                                                  ),
                                                ],
                                              ),

                                              gradientDivider(),

                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    locale!.yourSleepQuality,
                                                    style: t500_16.copyWith(
                                                      color: clr2D2D2D,
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      color: clrFFFFFF
                                                          .withOpacity(0.7),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8.0,
                                                            vertical: 4,
                                                          ),
                                                      child: TimePickerSpinnerPopUp(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        paddingHorizontalOverlay:
                                                            100,
                                                        // pa
                                                        mode:
                                                            CupertinoDatePickerMode
                                                                .date,
                                                        maxTime: DateTime.now(),
                                                        initTime: selectedDate,
                                                        iconSize: 10,
                                                        timeWidgetBuilder: (dd) {
                                                          return Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 15,
                                                                child: Image.asset(
                                                                  "assets/images/success-screen-calender.png",
                                                                ),
                                                              ),
                                                              horizontalSpace(
                                                                4,
                                                              ),
                                                              Text(
                                                                getIt<
                                                                      StateManager
                                                                    >()
                                                                    .convertStringDateToddmmyy(
                                                                      selectedDate
                                                                          .toString(),
                                                                    ),
                                                                style: t500_14
                                                                    .copyWith(
                                                                      color:
                                                                          clr2D2D2D,
                                                                    ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                        onChange: (dateTime) {
                                                          setState(
                                                            () => selectedDate =
                                                                dateTime,
                                                          );

                                                          getIt<
                                                                PsychologyManager
                                                              >()
                                                              .fetchDailyWellnessByDate(
                                                                date: dateTime,
                                                              );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              verticalSpace(20),
                                              labels.isNotEmpty
                                                  ? Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 0,
                                                              ),
                                                          child: Row(
                                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: labels
                                                                .map(
                                                                  (
                                                                    label,
                                                                  ) => Expanded(
                                                                    child: SizedBox(
                                                                      child: Center(
                                                                        child: Text(
                                                                          label,
                                                                          style: t400_16.copyWith(
                                                                            color:
                                                                                clr2D2D2D,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                                .toList(),
                                                          ),
                                                        ),

                                                        // Slider with Custom Styling
                                                        SliderTheme(
                                                          data: SliderTheme.of(context).copyWith(
                                                            activeTrackColor:
                                                                clrF68629,
                                                            inactiveTrackColor:
                                                                Colors
                                                                    .grey
                                                                    .shade300,
                                                            trackHeight: 6.0,
                                                            thumbShape:
                                                                const RoundSliderThumbShape(
                                                                  enabledThumbRadius:
                                                                      14.0,
                                                                ),
                                                            thumbColor:
                                                                clrF68629,
                                                            overlayColor:
                                                                clrF68629
                                                                    .withOpacity(
                                                                      0.3,
                                                                    ),
                                                          ),
                                                          child: Slider(
                                                            min: 1,
                                                            max: labels.length
                                                                .toDouble(),
                                                            divisions:
                                                                labels.length -
                                                                1,
                                                            value: double.parse(
                                                              '${selectedSleepQuality ?? 2}',
                                                            ),
                                                            onChanged: (value) async {
                                                              var res =
                                                                  await getIt<
                                                                        PsychologyManager
                                                                      >()
                                                                      .updateSleepQualityOrEmotions(
                                                                        sleepQualityValue:
                                                                            value.toInt(),
                                                                        emotionValue:
                                                                            null,
                                                                        previousEmotionValue:
                                                                            selectedEmotion,
                                                                        previousSleepQualityValue:
                                                                            selectedSleepQuality,
                                                                      );

                                                              showTopSnackBar(
                                                                snackBarPosition:
                                                                    SnackBarPosition
                                                                        .bottom,
                                                                Overlay.of(
                                                                  context,
                                                                ),
                                                                SuccessToast(
                                                                  maxLines: 4,
                                                                  message:
                                                                      res.message ??
                                                                      "",
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox(),

                                              // Bottom Hour Labels
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                    ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: hours
                                                      .map(
                                                        (hour) => Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.access_time,
                                                              size: 10,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            const SizedBox(
                                                              width: 1,
                                                            ),
                                                            Text(
                                                              hour,
                                                              style: t400_10
                                                                  .copyWith(
                                                                    color:
                                                                        clr858585,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              ),

                                              verticalSpace(6),
                                              psychologyData?.emotions != null
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          locale
                                                              .howDoYouFeelToday,
                                                          style: t500_18
                                                              .copyWith(
                                                                color:
                                                                    clr2D2D2D,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 4.0,
                                                              ),
                                                          child: Row(
                                                            children: psychologyData!.emotions!.map((
                                                              e,
                                                            ) {
                                                              return FeelingsIconWidget(
                                                                emotionValue:
                                                                    e.code!,
                                                                title: e.title!,
                                                                selectedEmotionCode:
                                                                    selectedEmotion,
                                                                onTap: () async {
                                                                  var res =
                                                                      await getIt<
                                                                            PsychologyManager
                                                                          >()
                                                                          .updateSleepQualityOrEmotions(
                                                                            emotionValue:
                                                                                e.code!,
                                                                            sleepQualityValue:
                                                                                null,
                                                                            previousEmotionValue:
                                                                                selectedEmotion,
                                                                            previousSleepQualityValue:
                                                                                selectedSleepQuality,
                                                                          );

                                                                  showTopSnackBar(
                                                                    snackBarPosition:
                                                                        SnackBarPosition
                                                                            .bottom,
                                                                    Overlay.of(
                                                                      context,
                                                                    ),
                                                                    SuccessToast(
                                                                      maxLines:
                                                                          4,
                                                                      message:
                                                                          res.message ??
                                                                          "",
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox(),

                                              verticalSpace(4),
                                            ],
                                          ),
                                        ),
                                        if (mgr
                                                    .upcomingAppointmentsModel
                                                    ?.upcomingAppointments !=
                                                null &&
                                            mgr
                                                .upcomingAppointmentsModel!
                                                .upcomingAppointments!
                                                .isNotEmpty)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              verticalSpace(6),
                                              mgr
                                                              .upcomingAppointmentsModel
                                                              ?.upcomingAppointments !=
                                                          null &&
                                                      mgr
                                                          .upcomingAppointmentsModel!
                                                          .upcomingAppointments!
                                                          .isNotEmpty
                                                  ? pad(
                                                      horizontal: w1p * 4,
                                                      vertical: 4,
                                                      child: Text(
                                                        AppLocalizations.of(
                                                          context,
                                                        )!.upcomingAppoinments,
                                                        style: t500_16.copyWith(
                                                          color: clr2D2D2D,
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              mgr
                                                              .upcomingAppointmentsModel
                                                              ?.upcomingAppointments !=
                                                          null &&
                                                      mgr
                                                          .upcomingAppointmentsModel!
                                                          .upcomingAppointments!
                                                          .isNotEmpty
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      child: CarouselSlider(
                                                        options: CarouselOptions(
                                                          height: 200,
                                                          viewportFraction: 1,
                                                          enableInfiniteScroll:
                                                              mgr
                                                                      .upcomingAppointmentsModel!
                                                                      .upcomingAppointments!
                                                                      .length >
                                                                  1
                                                              ? true
                                                              : false,
                                                          autoPlay: true,
                                                          aspectRatio: 1,
                                                          enlargeCenterPage:
                                                              false,
                                                        ),
                                                        items: mgr
                                                            .upcomingAppointmentsModel!
                                                            .upcomingAppointments!
                                                            // .where((item) => item.doctorId != null).toList()
                                                            // .where((item) => item.doctorId != null).toList()
                                                            .map(
                                                              (
                                                                e,
                                                              ) => GestureDetector(
                                                                onTap: () async {
                                                                  await Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (_) =>
                                                                              const UpcomingAppointmentsScreen(),
                                                                    ),
                                                                  );
                                                                  getIt<
                                                                        HomeManager
                                                                      >()
                                                                      .setAppointmentsTabTitle(
                                                                        null,
                                                                        isDispose:
                                                                            true,
                                                                      );

                                                                  getIt<
                                                                        HomeManager
                                                                      >()
                                                                      .getUpcomingAppointments(
                                                                        isRefresh:
                                                                            true,
                                                                      );
                                                                },
                                                                child: AppoinmentItemBox(
                                                                  isPsychology:
                                                                      true,
                                                                  appoinment: e,
                                                                  bookingType: e
                                                                      .bookingType,
                                                                  appoinmentId:
                                                                      e.appointmentId,
                                                                  bookingId:
                                                                      e.id!,
                                                                  docId: e
                                                                      .doctorId,
                                                                  startTime:
                                                                      DateTime.tryParse(
                                                                        e.bookingStartTime ??
                                                                            "",
                                                                      ),
                                                                  endTime:
                                                                      DateTime.tryParse(
                                                                        e.bookingEndTime ??
                                                                            "",
                                                                      ),
                                                                  img:
                                                                      e.docImg ??
                                                                      "",
                                                                  h1p: h1p,
                                                                  w1p: w1p,
                                                                  date:
                                                                      e.date !=
                                                                          null
                                                                      ? getIt<
                                                                              StateManager
                                                                            >()
                                                                            .convertStringDateToyMMMMd(
                                                                              e.date!,
                                                                            )
                                                                      : "",
                                                                  name: e
                                                                      .doctorFirstName,
                                                                  type: e
                                                                      .speciality,
                                                                  sheduledTime:
                                                                      getIt<
                                                                            StateManager
                                                                          >()
                                                                          .convertTime(
                                                                            e.time!,
                                                                          ),
                                                                ),
                                                              ),
                                                            )
                                                            .toList(),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              verticalSpace(6),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                              if (mgr.dashLoader)
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 4,
                                    vertical: 30,
                                  ),
                                  sliver: SliverToBoxAdapter(
                                    child: AppLoader(color: clrFA8E53),
                                  ),
                                ),
                              if (dashboardTherapies.isNotEmpty) ...[
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 4,
                                  ),
                                  sliver: SliverToBoxAdapter(
                                    child: Row(
                                      children: [
                                        Text(
                                          locale.therapies,
                                          style: t500_18.copyWith(
                                            color: clr2D2D2D,
                                          ),
                                        ),
                                        horizontalSpace(8),
                                        const GradientDivider(),
                                      ],
                                    ),
                                  ),
                                ),
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 4,
                                  ), // Optional spacing
                                  sliver: SliverGrid(
                                    delegate: SliverChildBuilderDelegate((
                                      context,
                                      index,
                                    ) {
                                      var title =
                                          dashboardTherapies[index].title;
                                      var img =
                                          dashboardTherapies[index].image ?? "";
                                      var specialityId =
                                          dashboardTherapies[index].speciality;
                                      var subSpeciality =
                                          dashboardTherapies[index].id;
                                      Color color = therapyColors[index];

                                      return TherapiesContainer(
                                        itemHeight: 130,
                                        alignment: Alignment.center,
                                        image: img,
                                        title2: title ?? "",
                                        onClick: () async {
                                          fn(
                                            specialityId: -1, //specialityId!,
                                            specialityTitle: title ?? "",
                                            subSpecialityId: subSpeciality,
                                            type: 2,
                                          ); //therapyId-2,councelling-3
                                          // Navigator.push(context, MaterialPageRoute(builder: (_)=>PsychologyInstantDoctorsScreen(
                                          //   specialityId: specialityId!,
                                          //   itemName:title ?? "",psychologyType: 2,subCatId: null,subspecialityId: null,
                                          //
                                          // )));
                                        },
                                        maxWidth: maxWidth,
                                        color: color,
                                      );
                                    }, childCount: dashboardTherapies.length),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2, // 3 items per row
                                          crossAxisSpacing: 8,
                                          mainAxisExtent: maxWidth * 0.4,
                                          mainAxisSpacing: 8,
                                          // childAspectRatio: 1, // Adjust as needed to prevent overflow
                                        ),
                                  ),
                                ),
                              ],
                              SliverList(
                                delegate: SliverChildListDelegate([
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18.0,
                                    ),
                                    child: Row(
                                      children: [
                                        const GradientDivider(
                                          colors: [
                                            Color(0xff959595),
                                            Color(0xffE3E3E3),
                                          ],
                                        ),
                                        horizontalSpace(8),
                                        Text(
                                          "How Therapy Works",
                                          style: t500_18.copyWith(
                                            color: clr2D2D2D,
                                          ),
                                        ),
                                        horizontalSpace(8),
                                        const GradientDivider(),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 250,
                                    child: PageView.builder(
                                      controller: _controller,
                                      itemCount: therapyTutorial.length,
                                      itemBuilder: (context, index) {
                                        return AnimatedBuilder(
                                          animation: _controller,
                                          builder: (context, child) {
                                            double currentPage = 0;
                                            if (_controller.hasClients &&
                                                _controller
                                                    .position
                                                    .haveDimensions) {
                                              currentPage =
                                                  _controller.page ??
                                                  _controller.initialPage
                                                      .toDouble();
                                            }

                                            double delta = index - currentPage;
                                            double rotateY =
                                                delta *
                                                0.2; // radians, for visible lean
                                            double scale =
                                                1 -
                                                (delta.abs() *
                                                    0.2); // optional scale effect

                                            // Clamp rotation
                                            rotateY = rotateY.clamp(-1.0, 1.0);

                                            return Transform(
                                              alignment: Alignment.center,
                                              transform: Matrix4.identity()
                                                ..setEntry(
                                                  3,
                                                  2,
                                                  0.001,
                                                ) // perspective
                                                ..rotateZ(rotateY)
                                                ..scale(scale),
                                              child: StepCard(
                                                therapyTutorialData:
                                                    therapyTutorial[index],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),

                                  //  CarouselSlider(
                                  //    options: CarouselOptions(height: 250,autoPlayInterval:Duration(seconds: 5),
                                  //      // height: h10p*2.7,
                                  //      viewportFraction: 0.65,
                                  //      enableInfiniteScroll: true,
                                  //      //  height: MediaQuery.of(context).size.height*0.3,
                                  //      autoPlay: false,
                                  //      aspectRatio: 1,
                                  //    ),
                                  //    items: therapyTutorial.map((e)=>Padding(
                                  //      padding: const EdgeInsets.all(4.0),
                                  //      child: Container(
                                  //        margin: EdgeInsets.all(4),
                                  //        height:250,
                                  //        decoration: BoxDecoration(
                                  //            boxShadow: [
                                  //              BoxShadow(
                                  //                color: clr717171.withOpacity(0.1),offset: Offset(0,0),spreadRadius: 4,blurRadius: 4
                                  //              )
                                  //            ],
                                  //            color:Color(0xffFFDCC0),borderRadius: BorderRadius.circular(13) ),
                                  //        // height:144,
                                  //        width: 200,
                                  //        child: Stack(alignment: Alignment.topCenter,
                                  //          // fit: StackFit.expand,
                                  //          children: [
                                  //          Padding(
                                  //            padding: const EdgeInsets.only(top:30.0),
                                  //            child: Column(
                                  //              children: [
                                  //                Container(
                                  //                  // color: Colors.amber,
                                  //                  // width: 150,
                                  //                    height: 140,
                                  //                    child:Image.asset(e.image)),
                                  //                SizedBox(height: 60,
                                  //                  child: Padding(
                                  //                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  //                    child: Text(e.title,
                                  //                      style: t400_14.copyWith(color:clr2D2D2D ,height: 1.1),textAlign: TextAlign.center,),
                                  //                  ),
                                  //                ),
                                  //              ],
                                  //            ),
                                  //          ),
                                  //            Align(alignment: Alignment.topCenter,
                                  //              child: Padding(
                                  //                padding: const EdgeInsets.all(8.0),
                                  //                child: Text(e.stepNo,style: t700_42.copyWith(color: Color(0xff9C6A42),height: 1),),
                                  //              ),
                                  //            ),
                                  //        ],),
                                  //      ),
                                  //    )).toList()
                                  //  ),
                                  verticalSpace(10),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: w1p * 4,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const VideosListScreen(),
                                          ),
                                        );
                                      },
                                      child: MeeditationWidget(w1p),
                                    ),
                                  ),

                                  verticalSpace(10),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: w1p * 4,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const MusicListScreen(),
                                          ),
                                        );
                                      },
                                      child: RelaxModeWidget(w1p),
                                    ),
                                  ),

                                  verticalSpace(20),
                                ]),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class StepCard extends StatelessWidget {
  final TherapyTutorial therapyTutorialData;

  const StepCard({super.key, required this.therapyTutorialData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        margin: const EdgeInsets.all(4),
        height: 250,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: clr717171.withOpacity(0.1),
              offset: const Offset(0, 0),
              spreadRadius: 4,
              blurRadius: 4,
            ),
          ],
          color: const Color(0xffFFDCC0),
          borderRadius: BorderRadius.circular(13),
        ),
        // height:144,
        width: 200,
        child: Stack(
          alignment: Alignment.topCenter,
          // fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                children: [
                  SizedBox(
                    // color: Colors.amber,
                    // width: 150,
                    height: 140,
                    child: Image.asset(therapyTutorialData.image),
                  ),
                  SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        therapyTutorialData.title,
                        style: t400_14.copyWith(color: clr2D2D2D, height: 1.1),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  therapyTutorialData.stepNo,
                  style: t700_42.copyWith(
                    color: const Color(0xff9C6A42),
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
