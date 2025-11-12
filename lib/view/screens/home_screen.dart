// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/controller/managers/category_manager.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/controller/managers/location_manager.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/model/core/banners_response_model.dart';
import 'package:dqapp/model/core/basic_response_model.dart';
import 'package:dqapp/model/core/news_and_tips/news_and_tips.dart';
import 'package:dqapp/view/screens/booking_screens/doctor_slot_pick_screen.dart';
import 'package:dqapp/view/screens/councelling_therapy_screens/psychology_screen.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/my_doctors_screen.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/upcoming_appoinments_screen.dart';
import 'package:dqapp/view/screens/forum_screens/ask_question_form_screen.dart';
import 'package:dqapp/view/screens/forum_screens/forum_details_screen.dart';
import 'package:dqapp/view/screens/search_results_screen.dart';
import 'package:dqapp/view/screens/view_all_specialities_categories_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../controller/managers/state_manager.dart';
import '../../controller/routes/routnames.dart';
import '../../model/core/specialities_response_model.dart';
import '../../model/core/symptoms_and_issues_list_model.dart';
import '../../model/core/upcome_appoiments_response_model.dart';
import '../../model/helper/service_locator.dart';
import '../../controller/services/speech.dart';
import '../theme/constants.dart';
import '../widgets/animate_arrow.dart';
import '../widgets/coming_soon_dialog.dart';
import 'booking_screens/booking_loading_screen.dart';
import 'drawer_menu_screens/drawer_menu_screens_widgets.dart';
import 'drawer_menu_screens/menu_drawer_screen.dart';
import 'drawer_menu_screens/notifications_screen.dart';
import 'drawer_menu_screens/reminder_screens/reminder_screen.dart';
import 'forum_screens/forum_list_screens.dart';
import 'home_screen_widgets.dart';
import 'location_drawer_screen.dart';
import 'online_catogories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  int scrollIndicatorIndex = 0;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // The app has come to the foreground
      // print("App is in the foreground");
      getIt<HomeManager>().homeBeginFns();

      // You can perform actions here when the app is resumed
    }
  }

  ScrollController scCntrol = ScrollController();
  // int hhht = 4;
  late double ht;
  bool lastStatus = true;
  double height = 20;
  double scrlPosition = 0;
  bool atTop = true;
  bool searchFixed = false;
  bool isExpanded = false;
  AnimationController? _controller;

  //managing the header sections's gradient on the basis of scrolling
  bool showGradient = true;

  bool get _isShrink {
    return scCntrol.hasClients && scCntrol.offset > (height - kToolbarHeight);
  }

  void _scrollListener() async {
    setState(() {
      scrlPosition = scCntrol.position.pixels;
    });
    // print('position changing : ${scCntrol.position.pixels}');

    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }

    setState(() {
      //managing the gradient on the basis of pixel
      showGradient = scCntrol.position.pixels <= 270;
    });

    //handling search bar position
    if (scCntrol.position.pixels > 10) {
      setState(() => searchFixed = true);
    } else {
      setState(() => searchFixed = false);
    }

    if (scCntrol.position.pixels <= 50) {
      setState(() => atTop = true);
    } else {
      setState(() {
        atTop = false;
        isExpanded = false;
      });
    }
  }

  //speech to text button click
  Future<void> _toggleButton() async {
    if (isExpanded) {
      // Button was expanded, now trigger function
      var res = await showModalBottomSheet(
        elevation: 0,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return const SpeechToTextWidget();
        },
      );
      if (res != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchResultScreen(
              title: AppLocalizations.of(context)!.onlineConsultations,
              type: 2,
              searchquery: res,
            ),
          ),
        );
      }
      // Place your action here
    } else {
      // Expand sub-buttons
      _controller?.forward();
    }

    setState(() => isExpanded = !isExpanded);
    if (!isExpanded) _controller?.reverse();
  }

  // Widget _buildSubButton(double angle, IconData icon, VoidCallback onPressed) {
  //   final radius = 100.0;
  //   return AnimatedBuilder(
  //     animation: _controller!,
  //     builder: (_, child) {
  //       final offset = Offset(
  //         radius * cos(angle) * _controller!.value,
  //         radius * sin(angle) * _controller!.value,
  //       );
  //       return Transform.translate(
  //         offset: offset,
  //         child: child,
  //       );
  //     },
  //     child: FloatingActionButton(
  //       heroTag: null,
  //       mini: true,
  //       onPressed: onPressed,
  //       child: Icon(icon),
  //     ),
  //   );
  // }

  // void initDeepLinkListener() async {
  //   // For cold start
  //   final initialLink = await getInitialLink();
  //   if (initialLink != null) handleLink(Uri.parse(initialLink));

  //   // For resumed app
  //   uriLinkStream.listen((Uri? uri) {
  //     if (uri != null) handleLink(uri);
  //   });
  // }

  // Future<void> handleLink(Uri uri) async {
  //   final sessionName = uri.queryParameters['sessionName'] ?? 'Unknown';
  //   // final userId = uri.queryParameters['userId'];
  //   // final role = uri.queryParameters['role'];

  //   // print('Join session: $sessionName, userId: $userId, role: $role');

  //   await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (_) => CallScreen(
  //                 displayName: getIt<SharedPreferences>()
  //                         .getString(StringConstants.userName) ??
  //                     "Unknown",
  //                 role: "0",
  //                 isJoin: true,
  //                 sessionIdleTimeoutMins: "40",
  //                 sessionName: sessionName,
  //                 sessionPwd: 'Qwerty123',
  //                 bookingId: 123,
  //               )));
  // }

  DateTime? currentBackPressTime;

  // managing the backpress
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press back again to exit");
      // try {
      //   if (btNavIndex == 1) {O
      //     Fluttertoast.showToast(msg: "Press back again to exit");
      //   } else {
      //     getIt<StateManager>().changePetHomeIndex(1);
      //   }
      // } catch (e) {
      //   // debugPrint(e.toString());
      // }
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  void initState() {
    super.initState();
    // initDeepLinkListener();

    _setupFirebaseMessaging();
    scCntrol.addListener(_scrollListener);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    //home functions
    getIt<HomeManager>().homeBeginFns();
    getIt<BookingManager>().disposeBooking();
    WidgetsBinding.instance.addObserver(this);
  }

  //formating the appointment date and time
  DateTime? getValidStartTime(UpcomingAppointments? todaysAppointment) {
    DateTime? startTime = todaysAppointment != null
        ? DateTime.tryParse(todaysAppointment.bookingStartTime ?? "")
        : null;

    DateTime now = DateTime.now();
    if (startTime != null &&
        now.year == startTime.year &&
        now.month == startTime.month &&
        now.day == startTime.day &&
        now.isBefore(startTime)) {
      return startTime; // Valid start time
    }

    return null; // Not valid
  }

  void _setupFirebaseMessaging() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request notification permissions
    messaging.requestPermission();

    // Handle notification clicks
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //redirecting to appointment screen
      if (message.data['type'] == 'booking_alert_on_time') {
        Navigator.pushNamed(context, RouteNames.appoinments);
      }
      //add the remaining if required
    });
  }

  @override
  void didChangeDependencies() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark, // Status bar color
      ),
    );
    super.didChangeDependencies();
  }

  final GlobalKey<ScaffoldState> _key =
      GlobalKey<ScaffoldState>(); // Create a key

  final TextEditingController forumTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print('index : ${tabController.index}');

    String username =
        getIt<SharedPreferences>().getString(StringConstants.userName) ?? "";

    //nav item widget
    Widget btNavIcon({
      required String icon,
      required Function onTap,
      required String title,
      required bool isSelected,
      bool? isCenter,
    }) {
      return Expanded(
        child: SizedBox(
          child: InkWell(
            onTap: () {
              onTap();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  icon,
                  height: isCenter == true ? 30 : 23,
                  width: 35,
                  fit: BoxFit.fitHeight,
                ),
                Text(
                  title,
                  style: isSelected
                      ? t400_10.copyWith(color: clr2E3192)
                      : t400_10.copyWith(color: clr858585),
                ),
              ],
            ),
          ),
        ),
      );
    }

    var hW = HomeWidgets();
    // bool? showIcon = StringConstants.tempIconViewStatus;
    // double hMgr.heightF =   Provider.of<StateManager> (context).heightF;
    // DateTime? _lastClicked;

    //search bar placeholde text
    List<TyperAnimatedText> lst =
        [
              (AppLocalizations.of(context)!.symptoms),
              AppLocalizations.of(context)!.specialities,
              AppLocalizations.of(context)!.doctors,
              AppLocalizations.of(context)!.clinics,
            ]
            .map(
              (item) => TyperAnimatedText(
                item,
                textStyle: t400_14,
                speed: const Duration(milliseconds: 100),
              ),
            )
            .toList();

    //using layout builder for responsivness
    return LayoutBuilder(
      builder: (context, constraints) {
        //below items are using for widgets
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;
        double padw2 = w1p * 4;

        // divider() {
        //   return Container(
        //     height: 1,
        //     decoration: const BoxDecoration(
        //         gradient: LinearGradient(colors: [
        //       Color(0xffE3E3E3),
        //       Color(0xff959595),
        //     ])),
        //   );
        // }

        //common function to redirect on the basis of parameters
        fn({
          required int specialityId,
          required int? categoryId,
          required String specialityTitle,
        }) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CheckIfDoctorAvailableScreen(
                categoryId: categoryId,
                specialityId: specialityId,
                specialityTitle: specialityTitle,
              ),
            ),
          );
        }

        notificationIcon(int? count) {
          return SizedBox(
            height: 40,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.notifications_none_sharp,
                    color: Colors.white,
                    size: searchFixed ? 16 : 24,
                  ),
                ),
                count != null && count != 0
                    ? Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colours.toastRed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(" $count ", style: t400_8),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          );
        }

        return Consumer<HomeManager>(
          builder: (context, hMgr, child) {
            //mic button for FloatingAactionButton
            final micButton = AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: atTop || isExpanded ? 12 : -12,
              bottom: 60,
              child: GestureDetector(
                onTap: _toggleButton,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // if (isExpanded) ...[
                    //   _buildSubButton(pi / 3, Icons.volume_up, () => print("Volume")),
                    //   _buildSubButton(2 * pi / 3, Icons.record_voice_over, () => print("Record")),
                    //   _buildSubButton(pi, Icons.settings_voice, () => print("Settings")),
                    // ],
                    GestureDetector(
                      // backgroundColor: isExpanded || atTop ? Colors.white : clrBD6273,
                      // backgroundColor: Colors.white,
                      // heroTag: 'mic',
                      onTap: _toggleButton,
                      child: !isExpanded && !atTop
                          ? const AnimatedArrow()
                          // Align(
                          //     alignment: Alignment.centerLeft,
                          //     child: Card(
                          //       // width: w1p * 26,
                          //       color: Colors.blue[200],
                          //       child: const Padding(
                          //         padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                          //         child: Icon(Icons.keyboard_double_arrow_left_rounded),
                          //       ),
                          //     ))
                          : Lottie.asset(
                              'assets/images/recording-lottie.json',
                              width: 100,
                              height: 90,
                            ),
                      // GestureDetector(
                      //     onTap: () async {
                      //       var res = await showModalBottomSheet(
                      //           elevation: 0,
                      //           isDismissible: true,
                      //           backgroundColor: Colors.transparent,
                      //           context: context,
                      //           builder: (context) {
                      //             return const SpeechToTextWidget();
                      //           });
                      //       if (res != null) {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (_) => SearchResultScreen(
                      //                       title: AppLocalizations.of(context)!.onlineConsultations,
                      //                       type: 2,
                      //                       searchquery: res,
                      //                     )));
                      //       }
                      //     },
                      //     child: Lottie.asset('assets/images/recording-lottie.json', width: 100, height: 90),
                      //   ),
                    ),
                  ],
                ),
              ),
            );

            // const proButton = Align(
            //   alignment: Alignment.bottomRight,
            //   child: CustomFabMenu(),
            //   // child: SpeedDial(
            //   //   overlayColor: Colors.black,
            //   //   animationDuration: const Duration(milliseconds: 700),
            //   //   overlayOpacity: 0.5,
            //   //   spacing: 10,
            //   //   spaceBetweenChildren: 12,

            //   //   // 🔹 Important: make button use its natural size
            //   //   buttonSize:
            //   //       const Size(60, 60), // adjust to your widget’s width & height
            //   //   childrenButtonSize: const Size(60, 60), // size of children
            //   //   shape: const StadiumBorder(),
            //   //   children: [
            //   //     SpeedDialChild(
            //   //       child: const Icon(Icons.checkroom),
            //   //       label: "My Stylist",
            //   //       backgroundColor: Colors.blue,
            //   //       onTap: () => debugPrint("My Stylist tapped"),
            //   //     ),
            //   //     SpeedDialChild(
            //   //       child: const Icon(Icons.face_retouching_natural),
            //   //       label: "Skin Analyser",
            //   //       backgroundColor: Colors.orange,
            //   //       onTap: () => debugPrint("Skin Analyser tapped"),
            //   //     ),
            //   //     SpeedDialChild(
            //   //       child: const Icon(Icons.star),
            //   //       label: "Myntra Suggests",
            //   //       backgroundColor: Colors.green,
            //   //       onTap: () => debugPrint("Myntra Suggests tapped"),
            //   //     ),
            //   //   ],

            //   //   // 🔹 Custom widget
            //   //   child: Container(
            //   //     alignment: Alignment.center,
            //   //     padding: const EdgeInsets.all(4),
            //   //     decoration: BoxDecoration(
            //   //       borderRadius: BorderRadius.circular(32),
            //   //       boxShadow: [boxShadow12],
            //   //       gradient: const LinearGradient(
            //   //         colors: [
            //   //           Color(0xfff59099),
            //   //           Color(0xff8467a6),
            //   //           Color(0xff007bff),
            //   //           Color(0xff00d4ff),
            //   //           Color(0xffff5600),
            //   //           Color(0xffffbb00),
            //   //         ],
            //   //       ),
            //   //     ),
            //   //     child: Container(
            //   //       height: 40,
            //   //       width: 80,
            //   //       decoration: BoxDecoration(
            //   //         borderRadius: BorderRadius.circular(32),
            //   //         color: Colors.white,
            //   //       ),
            //   //       child: Center(
            //   //         child: Row(
            //   //           mainAxisAlignment: MainAxisAlignment.center,
            //   //           children: [
            //   //             Padding(
            //   //               padding: const EdgeInsets.symmetric(horizontal: 4),
            //   //               child: Image.asset(
            //   //                 'assets/images/dq-logo-1.5x.png',
            //   //                 height: 24,
            //   //                 width: 24,
            //   //               ),
            //   //             ),
            //   //             Text(
            //   //               'Pro',
            //   //               style: t700_16.copyWith(color: Colors.black),
            //   //             ),
            //   //           ],
            //   //         ),
            //   //       ),
            //   //     ),
            //   //   ),
            //   // ),
            // );

            // final proButton = Align(
            //   alignment: Alignment.bottomRight,
            //   child: InkWell(
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         PageRouteBuilder(
            //           pageBuilder: (context, animation, secondaryAnimation) =>
            //               const ProHomeTab(),
            //           transitionsBuilder:
            //               (context, animation, secondaryAnimation, child) {
            //             const begin = Offset(1.0, 0.0); // start from right
            //             const end = Offset.zero; // end at normal position
            //             const curve = Curves.easeInOut;

            //             final tween = Tween(begin: begin, end: end)
            //                 .chain(CurveTween(curve: curve));
            //             final offsetAnimation = animation.drive(tween);

            //             return SlideTransition(
            //               position: offsetAnimation,
            //               child: child,
            //             );
            //           },
            //         ),
            //       );
            //     },
            //     child: Container(
            //       padding: const EdgeInsets.all(4),
            //       margin: const EdgeInsets.only(bottom: 10, right: 2),
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(32),
            //           boxShadow: [boxShadow12],
            //           gradient: const LinearGradient(colors: [
            //             Color(0xfff59099),
            //             Color(0xff8467a6),
            //             Color(0xff007bff),
            //             Color(0xff00d4ff),
            //             Color(0xffff5600),
            //             Color(0xffffbb00),
            //           ])),
            //       child: Container(
            //         // color: clrA8A8A8,
            //         height: 40,
            //         width: 80,
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(32),
            //             color: Colors.white),
            //         child: Center(
            //             child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             pad(
            //                 horizontal: 4,
            //                 child: Image.asset('assets/images/dq-logo-1.5x.png',
            //                     height: 24, width: 24)),
            //             Text(
            //               'Pro',
            //               style: t700_16.copyWith(color: Colors.black),
            //             ),
            //           ],
            //         )),
            //       ),
            //     ),
            //   ),
            // );

            List<BannerList> mainBanners = hMgr.mainBanners;
            List<BannerList> subBanners = hMgr.subBanners;

            return WillPopScope(
              onWillPop: onWillPop,
              // onPopInvoked: (didpop) async {},
              child: Scaffold(
                extendBody: false,
                key: _key,
                drawer: LocationDrawerScreen(w1p: w1p, h1p: h1p),
                endDrawer: MenuDrawerScreen(w1p: w1p, h1p: h1p),
                endDrawerEnableOpenDragGesture: false,
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.white,
                floatingActionButton: Stack(
                  children: [
                    //left side
                    micButton,
                    //right side
                    Container(
                      margin: const EdgeInsets.only(bottom: 60),
                      child: const CustomFabMenu(),
                    ),
                  ],
                ),
                // floatingActionButton: IconButton(
                //   onPressed: () {
                //     log("message");
                //     TextToSpeech.instance.playSound(
                //         '[{"name": "Paracetamol", "count": 0.5},{"name": "Aspirin", "count": 1}]',
                //         "ml");
                //   },
                //   icon: const Icon(Icons.speaker),
                // ),
                //aligning the FAB as center docked
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                // floatingActionButton:
                // GestureDetector(
                //   onTap: () async {
                //     var res = await showModalBottomSheet(
                //         elevation: 0,
                //         isDismissible: true,
                //         backgroundColor: Colors.transparent,
                //         context: context,
                //         builder: (context) {
                //           return const SpeechToTextWidget();
                //         });
                //     if (res != null) {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (_) => SearchResultScreen(
                //                     title: AppLocalizations.of(context)!.onlineConsultations,
                //                     type: 2,
                //                     searchquery: res,
                //                   )));
                //     }
                //   },
                //   child: Lottie.asset('assets/images/recording-lottie.json', width: 100, height: 90),
                // ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    await getIt<HomeManager>().homeBeginFns();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    height: maxHeight,
                    width: maxWidth,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          clr6C6EB8,
                          clrFE9297,
                          clrFFFFFF,
                          clrFFFFFF,
                          clrFFFFFF,

                          if (!showGradient) ...List.filled(9, clrFFFFFF),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Stack(
                      children: [
                        ListView(
                          controller: scCntrol,
                          children: [
                            Column(
                              children: [
                                AnimatedContainer(
                                  // height:h10p*hMgr.heightF,
                                  decoration: BoxDecoration(
                                    // gradient: LinearGradient(
                                    //   colors: [clr6C6EB8, clrFE9297],
                                    //   begin: Alignment.bottomRight,
                                    //   end: Alignment.centerLeft,
                                    // ),
                                    // color: Colours.toastRed,
                                    boxShadow: [boxShadow5],
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                        hMgr.heightF == 4 ? 15 : 0,
                                      ),
                                      bottomRight: Radius.circular(
                                        hMgr.heightF == 4 ? 15 : 0,
                                      ),
                                    ),
                                  ),

                                  duration: const Duration(milliseconds: 500),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: hMgr.heightF == 4
                                            ? h10p * 0.7
                                            : 0,
                                      ),
                                      // verticalSpace(8),
                                      verticalSpace(h10p * 0.7),
                                      mainBanners.isNotEmpty
                                          ? CarouselSlider(
                                              options: CarouselOptions(
                                                onPageChanged: (a, b) {
                                                  setState(
                                                    () => scrollIndicatorIndex =
                                                        a,
                                                  );
                                                },
                                                viewportFraction: 1,
                                                enableInfiniteScroll:
                                                    mainBanners.length > 1
                                                    ? true
                                                    : false,
                                                autoPlay: mainBanners.length > 1
                                                    ? true
                                                    : false,
                                                aspectRatio: 2 / 1,
                                              ),
                                              items: mainBanners
                                                  .map(
                                                    (mainBanner) => pad(
                                                      vertical: 0,
                                                      horizontal: padw2,
                                                      child: GestureDetector(
                                                        onTap: () {},
                                                        child: OffersCard(
                                                          w1p: w1p,
                                                          h1p: h1p,
                                                          banner: mainBanner,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            )
                                          : const SizedBox(),

                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: mainBanners.map((e) {
                                            var index = mainBanners.indexOf(e);
                                            return AnimatedContainer(
                                              decoration: BoxDecoration(
                                                color: const Color(0xffD6D6D6),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              margin: const EdgeInsets.all(2),
                                              duration: const Duration(
                                                milliseconds: 400,
                                              ),
                                              height: 3,
                                              width:
                                                  scrollIndicatorIndex == index
                                                  ? 40
                                                  : 8,
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // verticalSpace(8),
                            //   verticalSpace(h1p*3),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: w1p * 5,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    child: Text(
                                      "Hi ${username.length > 10 ? "${username.substring(0, 6)}..${username.substring(username.length - 2, username.length)}" : username}, how can we make your day better?",
                                      style: t400_12.copyWith(color: clr2D2D2D),
                                    ),
                                  ),
                                  horizontalSpace(8),
                                  Expanded(child: Container(child: divider())),
                                ],
                              ),
                            ),

                            // hMgr.spcialities == null
                            //     ? Center(
                            //         child: pad(vertical: h1p * 3, child: Center(child: LoadingAnimationWidget.twoRotatingArc(color: clr2D2D2D, size: 30))),
                            //       )
                            //     :

                            //using entry widget for better entry with animation
                            Entry(
                              yOffset: -20,
                              duration: const Duration(milliseconds: 700),
                              delay: const Duration(milliseconds: 50),
                              curve: Curves.ease,
                              child: Builder(
                                builder: (context) {
                                  List<SpecialityList> sList =
                                      hMgr.spcialities?.specialityList ?? [];
                                  int noOfSpecialites =
                                      hMgr.spcialities?.specialityCount ?? 0;
                                  double specialitySize = 90;
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: w1p * 0,
                                    ),
                                    child: SizedBox(
                                      height: specialitySize + 35,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: sList.isNotEmpty
                                              ? sList.map((e) {
                                                  var i = sList.indexOf(e);

                                                  return // pad(horizontal: w1p*0.1,
                                                  i <= 6
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                left: i == 0
                                                                    ? w1p * 4
                                                                    : w1p * 2,
                                                                right: i == 6
                                                                    ? w1p * 4
                                                                    : 0,
                                                              ),
                                                          child: hW.specialityBox(
                                                            context: context,
                                                            isRedacted: false,
                                                            size:
                                                                specialitySize,
                                                            count:
                                                                noOfSpecialites,
                                                            index: i,
                                                            w1p: w1p,
                                                            title:
                                                                sList[i]
                                                                    .title ??
                                                                "",
                                                            img:
                                                                sList[i]
                                                                    .image ??
                                                                "",
                                                            onClick: () async {
                                                              if (i != 6) {
                                                                int id =
                                                                    sList[i]
                                                                        .id!;
                                                                String title =
                                                                    sList[i]
                                                                        .title!;

                                                                fn(
                                                                  specialityTitle:
                                                                      title,
                                                                  specialityId:
                                                                      id,
                                                                  categoryId:
                                                                      null,
                                                                );
                                                              } else {
                                                                getIt<
                                                                      CategoryMgr
                                                                    >()
                                                                    .setViewAllScreenitems(
                                                                      hMgr
                                                                          .spcialities!
                                                                          .specialityList,
                                                                    );
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (_) => ViewAllScreen(
                                                                      title: AppLocalizations.of(
                                                                        context,
                                                                      )!.specialities,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        )
                                                      : const SizedBox();
                                                }).toList()
                                              : [
                                                  for (int i = 0; i < 6; i++)
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: i == 0
                                                            ? w1p * 4
                                                            : w1p * 2,
                                                        right: i == 6
                                                            ? w1p * 4
                                                            : 0,
                                                      ),
                                                      child: hW.specialityBox(
                                                        context: context,
                                                        isRedacted: true,
                                                        size: specialitySize,
                                                        count: 6,
                                                        index: i,
                                                        w1p: w1p,
                                                        title: "Redacted",
                                                        img: "Redacted",
                                                        onClick: () async {},
                                                      ),
                                                    ),
                                                ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         // Container(),
                            //         ConsultContainer(
                            //             title1: "Book Your",
                            //             title2: "Appointment",
                            //             color: clrCE6F7D,
                            //             bgColor: const Color(0xffF88D94),
                            //             subtitle: "More Than\n2500+\nDoctors",
                            //             maxWidth: maxWidth,
                            //             maxHeight: maxHeight,
                            //             image:
                            //                 "assets/images/consultC-img-appoinment.png",
                            //             bg: "assets/images/consultC-bg-appointment.png",
                            //             alignment: Alignment.center,
                            //             onClick: () async {
                            //               await Navigator.of(context)
                            //                   .push(navigateOnlineCategories(true));

                            //               // getIt<HomeManager>().getUpcomingAppointments(isRefresh: true);
                            //             }),
                            //         horizontalSpace(8),
                            //         ConsultContainer(
                            //             title1: "Consult",
                            //             title2: "Now",
                            //             color: clr5758AC,
                            //             bgColor: const Color(0xff8467A6),
                            //             subtitle: "Connect\nwith in\n30 sec",
                            //             maxWidth: maxWidth,
                            //             maxHeight: maxHeight,
                            //             image: "assets/images/consultC-img-live.png",
                            //             bg: "assets/images/consultC-bg-live.png",
                            //             alignment: Alignment.center,
                            //             onClick: () {
                            //               Navigator.of(context)
                            //                   .push(navigateOnlineCategories(false));
                            //             }),
                            //       ]),
                            // ),

                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         ConsultContainer(
                            //             title1: "Online",
                            //             title2: "Counselling",
                            //             color: clrFA8E53,
                            //             bgColor: const Color(0xffFC8551),
                            //             subtitle: "Available\n24x7",
                            //             maxWidth: maxWidth,
                            //             maxHeight: maxHeight,
                            //             image:
                            //                 "assets/images/consultC-img-councelling.png",
                            //             bg: "assets/images/consultC-bg-councelling.png",
                            //             alignment: Alignment.center,
                            //             onClick: () {
                            //               Navigator.of(context)
                            //                   .push(navigateOnlineCouncelling());
                            //             }),
                            //         horizontalSpace(8),
                            //         ConsultContainer(
                            //             title1: "Online Vet",
                            //             title2: "Consulting",
                            //             color: clr417FB1,
                            //             bgColor: const Color(0xff7EB8E8),
                            //             subtitle: "Exclusive\nOffers",
                            //             maxWidth: maxWidth,
                            //             maxHeight: maxHeight,
                            //             image: "assets/images/consultC-img-pet.png",
                            //             bg: "assets/images/consultC-bg-pet.png",
                            //             alignment: Alignment.center,
                            //             onClick: () {
                            //               showComingSoonDialog(context);
                            //               // Navigator.push(context, MaterialPageRoute(builder: (_) => const PetSplashScreen()));
                            //             }),
                            //       ]),
                            // ),
                            DashboardWidgets(
                              maxHeight: maxHeight,
                              maxWidth: maxWidth,
                            ),

                            hMgr
                                            .upcomingAppointmentsModel
                                            ?.upcomingAppointments !=
                                        null &&
                                    hMgr
                                        .upcomingAppointmentsModel!
                                        .upcomingAppointments!
                                        .isNotEmpty
                                ? pad(
                                    horizontal: padw2,
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.upcomingAppoinments,
                                      style: t700_16.copyWith(color: clr2D2D2D),
                                    ),
                                  )
                                : const SizedBox(),
                            hMgr
                                            .upcomingAppointmentsModel
                                            ?.upcomingAppointments !=
                                        null &&
                                    hMgr
                                        .upcomingAppointmentsModel!
                                        .upcomingAppointments!
                                        .isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CarouselSlider(
                                      options: CarouselOptions(
                                        height: 200,
                                        // height: h10p*2.7,
                                        viewportFraction: 1,
                                        enableInfiniteScroll:
                                            hMgr
                                                    .upcomingAppointmentsModel!
                                                    .upcomingAppointments!
                                                    .length >
                                                1
                                            ? true
                                            : false,
                                        //  height: MediaQuery.of(context).size.height*0.3,
                                        autoPlay: false,
                                        aspectRatio: 1,
                                        enlargeCenterPage: true,
                                      ),
                                      items: hMgr
                                          .upcomingAppointmentsModel!
                                          .upcomingAppointments!
                                          // .where((item) => item.doctorId != null).toList()
                                          // .where((item) => item.doctorId != null).toList()
                                          .map(
                                            (e) => GestureDetector(
                                              onTap: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const UpcomingAppointmentsScreen(),
                                                  ),
                                                );
                                                getIt<HomeManager>()
                                                    .setAppointmentsTabTitle(
                                                      null,
                                                      isDispose: true,
                                                    );

                                                getIt<HomeManager>()
                                                    .getUpcomingAppointments(
                                                      isRefresh: true,
                                                    );
                                              },
                                              child: AppoinmentItemBox(
                                                appoinment: e,
                                                bookingType: e.bookingType,
                                                appoinmentId: e.appointmentId,
                                                bookingId: e.id!,
                                                docId: e.doctorId,
                                                startTime: DateTime.tryParse(
                                                  e.bookingStartTime ?? "",
                                                ),
                                                endTime: DateTime.tryParse(
                                                  e.bookingEndTime ?? "",
                                                ),
                                                img: e.docImg ?? "",
                                                h1p: h1p,
                                                w1p: w1p,
                                                date: e.date != null
                                                    ? getIt<StateManager>()
                                                          .convertStringDateToyMMMMd(
                                                            e.date!,
                                                          )
                                                    : "",
                                                name: e.doctorFirstName,
                                                type: e.speciality,
                                                sheduledTime:
                                                    getIt<StateManager>()
                                                        .convertTime(e.time!),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  )
                                : const SizedBox(),

                            Padding(
                              padding: EdgeInsets.only(top: h1p),
                              child: Builder(
                                builder: (context) {
                                  // MentalWellness? mwell;
                                  Symptoms? symptoms;
                                  AyurvedicOrHomeo? ayurvedic;
                                  AyurvedicOrHomeo? homioPathic;
                                  // List<Subcategory>? mwellList;
                                  List<Subcategory> symptomsList = [];

                                  if (hMgr.symptomsAndIssues != null) {
                                    SymptomsAndIssuesModel data =
                                        hMgr.symptomsAndIssues!;
                                    // mwell = data.mentalWellness;
                                    symptoms = data.symptoms;
                                    ayurvedic = data.ayurvedic;
                                    homioPathic = data.homeopathy;
                                    // mwellList = mwell?.subcategory ?? [];
                                    symptomsList = symptoms?.subcategory ?? [];
                                  }

                                  // NOT FEELING WELL SECTION
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      hMgr.symptomsAndIssues != null &&
                                              symptoms != null
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: w1p * 5,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: w10p * 7,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            FittedBox(
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                              child: Text(
                                                                symptoms.title ??
                                                                    '',
                                                                style: t700_16
                                                                    .copyWith(
                                                                      color:
                                                                          clr2D2D2D,
                                                                      height:
                                                                          1.1,
                                                                    ),
                                                                maxLines: 3,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            verticalSpace(4),
                                                            Text(
                                                              symptoms.subtitle ??
                                                                  '',
                                                              style: t400_12
                                                                  .copyWith(
                                                                    color:
                                                                        clr2D2D2D,
                                                                    height: 1.1,
                                                                  ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      horizontalSpace(8),
                                                      Expanded(
                                                        child: Container(
                                                          child: divider(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Entry(
                                                  xOffset: 50,
                                                  // scale: 20,
                                                  delay: const Duration(
                                                    milliseconds: 500,
                                                  ),
                                                  duration: const Duration(
                                                    milliseconds: 700,
                                                  ),
                                                  curve: Curves.ease,
                                                  child: SizedBox(
                                                    width: maxWidth,
                                                    height: 118,
                                                    child: ListView(
                                                      physics:
                                                          const BouncingScrollPhysics(),

                                                      // controller:scCntrol ,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      children: symptomsList.map((
                                                        symptom,
                                                      ) {
                                                        var i = symptomsList
                                                            .indexOf(symptom);
                                                        // print('symptoms : ${symptomsList.map((e) => e.toJson()).toList()}');

                                                        return hW.symptomsItem(
                                                          index: i,
                                                          img:
                                                              symptom.icon ??
                                                              '',
                                                          title:
                                                              symptom.title ??
                                                              '',
                                                          w1p: w1p,
                                                          onClick: () async {
                                                            int specialityId =
                                                                symptom
                                                                    .speciality!;
                                                            int
                                                            subcatId = symptom
                                                                .speciality!;

                                                            fn(
                                                              specialityId:
                                                                  specialityId,
                                                              specialityTitle:
                                                                  symptom
                                                                      .title ??
                                                                  "",
                                                              categoryId:
                                                                  subcatId,
                                                            );
                                                          },
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                                // verticalSpace(4),
                                                // Center(
                                                //   child: GestureDetector(
                                                //     onTap: () async {
                                                //       var res = await showModalBottomSheet(
                                                //           elevation: 0,
                                                //           isDismissible: true,
                                                //           backgroundColor: Colors.transparent,
                                                //           context: context,
                                                //           builder: (context) {
                                                //             return const SpeechToTextWidget();
                                                //           });

                                                //       if (res != null) {
                                                //         Navigator.push(
                                                //             context,
                                                //             MaterialPageRoute(
                                                //                 builder: (_) => SearchResultScreen(
                                                //                       title: AppLocalizations.of(context)!.onlineConsultations,
                                                //                       type: 2,
                                                //                       searchquery: res,
                                                //                     )));
                                                //       }
                                                //     },
                                                //     child: Lottie.asset('assets/images/recording-lottie.json', width: 150, height: 115),
                                                //   ),
                                                // ),
                                                verticalSpace(12),
                                              ],
                                            )
                                          : const SizedBox(),

                                      //ayurverdi and homeo section
                                      ayurvedic != null && homioPathic != null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                  ),
                                              child: Row(
                                                children: [
                                                  hW.ayurvedicNHomioBox(
                                                    maxWidth: maxWidth,
                                                    title1: "Ayurvedic",
                                                    title2: "Treatments",
                                                    img:
                                                        "assets/images/ayurvedic-img.png",
                                                    onClick: () {
                                                      if (ayurvedic!
                                                                  .subcategory !=
                                                              null &&
                                                          ayurvedic
                                                              .subcategory!
                                                              .isNotEmpty) {
                                                        List<SpecialityList>?
                                                        lst = ayurvedic
                                                            .subcategory!
                                                            .map(
                                                              (
                                                                e,
                                                              ) => SpecialityList(
                                                                id: e
                                                                    .speciality,
                                                                title: e.title,
                                                                subtitle:
                                                                    e.subtitle,
                                                                image: e.icon,
                                                              ),
                                                            )
                                                            .toList();
                                                        getIt<CategoryMgr>()
                                                            .setViewAllScreenitems(
                                                              lst,
                                                            );
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                ViewAllScreen(
                                                                  title:
                                                                      ayurvedic!
                                                                          .title ??
                                                                      "",
                                                                ),
                                                          ),
                                                        );
                                                      } else {
                                                        showTopSnackBar(
                                                          Overlay.of(context),
                                                          const ErrorToast(
                                                            message:
                                                                "No data found",
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    alignment:
                                                        Alignment.topRight,
                                                  ),
                                                  horizontalSpace(4),
                                                  hW.ayurvedicNHomioBox(
                                                    maxWidth: maxWidth,
                                                    title1: "Homeopathic",
                                                    title2: "Treatments",
                                                    img:
                                                        "assets/images/homiopathic-img.png",
                                                    onClick: () {
                                                      if (homioPathic!
                                                                  .subcategory !=
                                                              null &&
                                                          homioPathic
                                                              .subcategory!
                                                              .isNotEmpty) {
                                                        List<SpecialityList>?
                                                        lst = homioPathic
                                                            .subcategory!
                                                            .map(
                                                              (
                                                                e,
                                                              ) => SpecialityList(
                                                                id: e.id,
                                                                title: e.title,
                                                                subtitle:
                                                                    e.subtitle,
                                                                image: e.icon,
                                                              ),
                                                            )
                                                            .toList();
                                                        getIt<CategoryMgr>()
                                                            .setViewAllScreenitems(
                                                              lst,
                                                            );
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                ViewAllScreen(
                                                                  title:
                                                                      homioPathic!
                                                                          .title ??
                                                                      "",
                                                                ),
                                                          ),
                                                        );
                                                      } else {
                                                        showTopSnackBar(
                                                          Overlay.of(context),
                                                          const ErrorToast(
                                                            message:
                                                                "No data found",
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
                                      verticalSpace(8),
                                      verticalSpace(h1p),

                                      //MEDICINE REMINDER
                                      hW.reminderBox(
                                        w1p: w1p,
                                        title: AppLocalizations.of(
                                          context,
                                        )!.neverMissADose,
                                        subtitle: AppLocalizations.of(
                                          context,
                                        )!.getSmartNotificationsForYour,
                                        ontap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const ReminderScreen(),
                                            ),
                                          );
                                        },
                                      ),

                                      if (subBanners.isNotEmpty) ...[
                                        verticalSpace(h1p),
                                        CarouselSlider(
                                          options: CarouselOptions(
                                            onPageChanged: (a, b) {
                                              setState(
                                                () => scrollIndicatorIndex = a,
                                              );
                                            },
                                            viewportFraction: 1,
                                            enableInfiniteScroll:
                                                subBanners.length > 1
                                                ? true
                                                : false,
                                            autoPlay: subBanners.length > 1
                                                ? true
                                                : false,
                                            aspectRatio: 2 / 1,
                                          ),
                                          items: subBanners
                                              .map(
                                                (subBanner) => pad(
                                                  vertical: 0,
                                                  horizontal: padw2,
                                                  child: GestureDetector(
                                                    onTap: () {},
                                                    child: OffersCard(
                                                      w1p: w1p,
                                                      h1p: h1p,
                                                      banner: subBanner,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
                            ),

                            //FOLLOW UP SECTION
                            if (hMgr.bookingsFollowUps.isNotEmpty) ...[
                              verticalSpace(8),
                              pad(
                                horizontal: padw2,
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.physiciansYouConsulted,
                                  style: t500_14.copyWith(color: clr2D2D2D),
                                ),
                              ),
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: 120,
                                  // height: h10p*2.7,
                                  viewportFraction: 1,
                                  enableInfiniteScroll:
                                      hMgr.bookingsFollowUps.length > 1
                                      ? true
                                      : false,
                                  //  height: MediaQuery.of(context).size.height*0.3,
                                  autoPlay: hMgr.bookingsFollowUps.length > 1
                                      ? true
                                      : false,
                                  aspectRatio: 16 / 9,
                                ),
                                items: hMgr.bookingsFollowUps
                                    .map(
                                      (e) => pad(
                                        vertical: h1p,
                                        horizontal: 0,
                                        child: RecentConsultItem(
                                          docId: e.doctorId!,
                                          bookingStartTime: DateTime.tryParse(
                                            e.bookingStartTime ?? "",
                                          ),
                                          bookingEndTime: DateTime.tryParse(
                                            e.bookingEndTime ?? "",
                                          ),
                                          bookingId: e.id!,
                                          fn: () async {
                                            BasicResponseModel?
                                            result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    DoctorSlotPickScreen(
                                                      date: null,
                                                      followUpBookId: e.id,
                                                      isScheduledOnline:
                                                          e.bookingType ==
                                                          'Online',
                                                      isFreeFollowUp: true,
                                                      docId: e.doctorId,
                                                      freeFollowUpId: e.id,
                                                      specialityId:
                                                          e.specialityId!,
                                                      subSpecialityIdForPsychology:
                                                          null,
                                                    ),
                                              ),
                                            );

                                            if (result != null) {
                                              await getIt<HomeManager>()
                                                  .getFreeFollowUp();
                                              await getIt<HomeManager>()
                                                  .getUpcomingAppointments(
                                                    isRefresh: true,
                                                  );
                                            }
                                          },
                                          appoinmentId: e.appointmentId!,
                                          showsInHome: true,
                                          patientname: e.patientFirstName ?? "",
                                          h1p: h1p,
                                          w1p: w1p,
                                          date: e.date != null
                                              ? getIt<StateManager>()
                                                    .convertStringDateToyMMMMd(
                                                      e.date!,
                                                    )
                                              : "",
                                          name: e.doctorFirstName ?? "",
                                          type: e.speciality ?? "",
                                          sheduledTime: getIt<StateManager>()
                                              .convertTime(e.time!),
                                          doctorImg: e.doctorImage ?? "",
                                          isFreeFollowUp: true,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],

                            //MEDICAL FORUM SECTION
                            Container(
                              // height: 250,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color((0xffC4DEEB)),
                                    Color(0xffEFF5F8),
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.medicalExpertsAnswersToYourQuestion,
                                    style: t700_18.copyWith(
                                      color: Colors.black,
                                    ),
                                    maxLines: 2,
                                  ),
                                  verticalSpace(10),
                                  SizedBox(
                                    height: 40,
                                    child: TextFormField(
                                      controller: forumTitleController,
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(
                                          context,
                                        )!.askYourDoubts,
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 2,
                                              horizontal: 10,
                                            ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(
                                            7,
                                          ),
                                        ),
                                        hintStyle: t400_14.copyWith(
                                          color: Colors.grey,
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap: () async {
                                            var res = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    AskFreeQuestionScreen(
                                                      titleController:
                                                          forumTitleController,
                                                    ),
                                              ),
                                            );
                                            if (res != null) {
                                              getIt<HomeManager>().getForumList(
                                                isRefresh: true,
                                              );
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff5440DC),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  hMgr.publicForumListModel?.publicForums !=
                                          null
                                      ? SizedBox(
                                          // height: 80,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              // children: [1,1,1,1,1,1,1,1,]
                                              children: hMgr
                                                  .publicForumListModel!
                                                  .publicForums!
                                                  .map((e) {
                                                    var indx = hMgr
                                                        .publicForumListModel!
                                                        .publicForums!
                                                        .indexOf(e);

                                                    return Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (_) =>
                                                                    ForumDetailsScreen(
                                                                      forumId:
                                                                          e.id!,
                                                                    ),
                                                              ),
                                                            );
                                                          },
                                                          child:
                                                              ForumHomeListItem2(
                                                                w1p: w1p,
                                                                h1p: h1p,
                                                                index: indx,
                                                                pf: e,
                                                              ),
                                                        ),
                                                      ],
                                                    );
                                                  })
                                                  .toList(),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  SizedBox(
                                    width: double
                                        .infinity, // Ensure it spans full width
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        // margin: const EdgeInsets.all(10),
                                        alignment: Alignment
                                            .centerRight, // No need for topRight here
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (ctx) =>
                                                    const ForumListScreen(),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize
                                                .min, // Shrink to fit content
                                            children: [
                                              Text(
                                                "View All",
                                                style: t500_16.copyWith(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              horizontalSpace(8),
                                              const Icon(
                                                CupertinoIcons.forward,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //Daily Wellness Tips
                            if (hMgr.newsAndTips != null &&
                                hMgr.newsAndTips!.tips!.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Daily Wellness Tips",
                                            style: t700_18.copyWith(
                                              color: Colors.black,
                                            ),
                                          ),
                                          horizontalSpace(20),
                                          Expanded(child: divider()),
                                          horizontalSpace(5),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                  RouteNames.newsAndTipsList,
                                                  arguments:
                                                      NewsAndTipsListScreenArguments(
                                                        type: "Tip",
                                                        tips: hMgr
                                                            .newsAndTips!
                                                            .tips,
                                                      ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "View All",
                                                    style: t500_16.copyWith(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  horizontalSpace(8),
                                                  const Icon(
                                                    CupertinoIcons.forward,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    verticalSpace(10),
                                    CarouselSlider(
                                      options: CarouselOptions(height: 150.0),
                                      items: hMgr.newsAndTips!.tips!.map((tip) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            final tipItem = tip;
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  RouteNames.newsAndTips,
                                                  arguments:
                                                      NewsAndTipsScreenArguments(
                                                        type: "Tip",
                                                        tip: tipItem,
                                                      ),
                                                );
                                              },
                                              child: Hero(
                                                tag: tipItem.id!.toString(),
                                                child: Container(
                                                  width: MediaQuery.of(
                                                    context,
                                                  ).size.width,
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 5.0,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        "${StringConstants.baseUrl}${tipItem.image!}",
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black54,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          tipItem.title!,
                                                          style: t400_18,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),

                            //NEWS SECTION
                            if (hMgr.newsAndTips != null &&
                                hMgr.newsAndTips!.news!.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 30),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Latest in Healthcare",
                                            style: t700_18.copyWith(
                                              color: Colors.black,
                                            ),
                                          ),
                                          horizontalSpace(20),
                                          Expanded(child: divider()),
                                          horizontalSpace(5),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                  RouteNames.newsAndTipsList,
                                                  arguments:
                                                      NewsAndTipsListScreenArguments(
                                                        type: "News",
                                                        news: hMgr
                                                            .newsAndTips!
                                                            .news,
                                                      ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "View All",
                                                    style: t500_16.copyWith(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  horizontalSpace(8),
                                                  const Icon(
                                                    CupertinoIcons.forward,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    verticalSpace(10),
                                    HealthNewsCarousel(
                                      items: hMgr.newsAndTips!.news!,
                                    ),
                                    verticalSpace(30),
                                  ],
                                ),
                              ),

                            //forum old model
                            // Container(
                            //   decoration: BoxDecoration(
                            //       gradient: LinearGradient(
                            //           colors: [clrFE9297, clr6C6EB8],
                            //           begin: Alignment.topLeft,
                            //           end: Alignment.bottomRight)),
                            //   child: Stack(
                            //     children: [
                            //       Positioned(
                            //           bottom: 0,
                            //           right: 0,
                            //           child: Image.asset(
                            //               "assets/images/forum_layer-image.png")),
                            //       Column(
                            //         children: [
                            //           verticalSpace(24),
                            //           Row(
                            //             children: [
                            //               Padding(
                            //                 padding: EdgeInsets.symmetric(
                            //                   horizontal: w1p * 5,
                            //                 ),
                            //                 child: SizedBox(
                            //                   width: w10p * 6,
                            //                   child: Text(
                            //                     AppLocalizations.of(context)!
                            //                         .medicalExpertsAnswersToYourQuestion,
                            //                     style: t400_18,
                            //                     maxLines: 2,
                            //                   ),
                            //                 ),
                            //               ),
                            //               Expanded(
                            //                 child: Padding(
                            //                   padding: const EdgeInsets.all(8.0),
                            //                   child: GestureDetector(
                            //                     onTap: () {
                            //                       getIt<HomeManager>().removeForums();

                            //                       Navigator.push(
                            //                           context,
                            //                           MaterialPageRoute(
                            //                               builder: (_) =>
                            //                                   const ForumListScreen()));
                            //                     },
                            //                     child: Row(
                            //                       mainAxisAlignment:
                            //                           MainAxisAlignment.end,
                            //                       children: [
                            //                         Text(
                            //                           "See All",
                            //                           style: t500_14,
                            //                         ),
                            //                         horizontalSpace(8),
                            //                         Container(
                            //                           height: 30,
                            //                           width: 30,
                            //                           decoration: const BoxDecoration(
                            //                               color: Colours.lightBlu,
                            //                               shape: BoxShape.circle),
                            //                           child: const Center(
                            //                             child: Icon(
                            //                               Icons.arrow_forward_ios,
                            //                               color: Colours.toastBlue,
                            //                               size: 15,
                            //                             ),
                            //                           ),
                            //                         ),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //           Container(
                            //               margin: EdgeInsets.symmetric(
                            //                   horizontal: w1p * 5, vertical: 8),
                            //               decoration: BoxDecoration(
                            //                   boxShadow: [boxShadow5],
                            //                   color: Colors.white,
                            //                   borderRadius:
                            //                       BorderRadius.circular(10)),
                            //               child: GestureDetector(
                            //                 onTap: () async {
                            //                   var res = await Navigator.push(
                            //                       context,
                            //                       MaterialPageRoute(
                            //                           builder: (_) =>
                            //                               const AskFreeQuestionScreen()));
                            //                   if (res != null) {
                            //                     getIt<HomeManager>()
                            //                         .getForumList(isRefresh: true);
                            //                   }
                            //                 },
                            //                 child: Padding(
                            //                   padding: const EdgeInsets.symmetric(
                            //                       horizontal: 18.0, vertical: 19),
                            //                   child: Center(
                            //                       child: Text(
                            //                     AppLocalizations.of(context)!
                            //                         .askYourDoubts,
                            //                     style: t500_16.copyWith(
                            //                         color: clr2D2D2D),
                            //                   )),
                            //                 ),
                            //               )),
                            //           // verticalSpace(h1p),

                            //           hMgr.publicForumListModel?.publicForums != null
                            //               ? SizedBox(
                            //                   // height: 80,
                            //                   child: SingleChildScrollView(
                            //                     scrollDirection: Axis.horizontal,
                            //                     child: Row(
                            //                       // children: [1,1,1,1,1,1,1,1,]
                            //                       children: hMgr.publicForumListModel!
                            //                           .publicForums!
                            //                           .map((e) {
                            //                         var indx = hMgr
                            //                             .publicForumListModel!
                            //                             .publicForums!
                            //                             .indexOf(e);

                            //                         return Row(
                            //                           children: [
                            //                             GestureDetector(
                            //                                 onTap: () {
                            //                                   Navigator.push(
                            //                                       context,
                            //                                       MaterialPageRoute(
                            //                                           builder: (_) =>
                            //                                               ForumDetailsScreen(
                            //                                                   forumId:
                            //                                                       e.id!)));
                            //                                 },
                            //                                 child: ForumHomeListItem2(
                            //                                   w1p: w1p,
                            //                                   h1p: h1p,
                            //                                   index: indx,
                            //                                   pf: e,
                            //                                 )),
                            //                           ],
                            //                         );
                            //                       }).toList(),
                            //                     ),
                            //                   ),
                            //                 )
                            //               : const SizedBox(),
                            //           verticalSpace(12),

                            //           // verticalSpace(12),
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),

                        //SEARCH AREA

                        // search background
                        if (searchFixed)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            width: maxWidth,
                            // height: MediaQuery.of(context).padding.top + h10p * 1.85 - (searchFixed ? h1p * 2 : 0),
                            height: h10p * 1.85,
                            padding: EdgeInsets.only(bottom: h1p * 1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                containerRadius / 2,
                              ),
                              color: searchFixed ? null : Colors.transparent,
                              boxShadow: !searchFixed ? null : [boxShadow6],
                              gradient: LinearGradient(
                                colors: [clr6C6EB8, clrFE9297],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              // gradient: LinearGradient(colors: appBarGradient(tabIndex), begin: Alignment.topCenter, end: Alignment.bottomCenter),
                            ),
                          ),

                        // location and notification
                        pad(
                          horizontal: w1p * 4,
                          vertical:
                              MediaQuery.of(context).padding.top +
                              (searchFixed ? h1p : 0),
                          // vertical: MediaQuery.of(context).padding.top + h10p * 1.85 - (searchFixed ? h1p * 2 : 0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 00),
                            height: searchFixed ? h1p * 3 : h1p * 6,
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                _key.currentState!.openDrawer();
                              },
                              child: Row(
                                children: [
                                  AnimatedRotation(
                                    duration: const Duration(milliseconds: 400),
                                    turns: hMgr.heightF == 4 ? 0 : -1 / 4,
                                    child: SmallWidgets().locationIcon(
                                      size: 30,
                                      iconClr: Colors.black,
                                    ),
                                  ),
                                  horizontalSpace(padw2),
                                  Consumer<LocationManager>(
                                    builder: (context, mgr, child) {
                                      return SizedBox(
                                        width: w10p * 4,
                                        child: hMgr.locLoader == true
                                            ? LoadingAnimationWidget.twoRotatingArc(
                                                color: Colors.white,
                                                size: 20,
                                              )
                                            : mgr.selectedLocation != null
                                            ? Text(
                                                mgr.selectedLocation!,
                                                style: t700_14.copyWith(
                                                  color: clrFFFFFF,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            : getIt<SharedPreferences>()
                                                      .getString(
                                                        StringConstants
                                                            .selectedLocation,
                                                      ) !=
                                                  null
                                            ? Text(
                                                getIt<SharedPreferences>()
                                                        .getString(
                                                          StringConstants
                                                              .selectedLocation,
                                                        ) ??
                                                    "",
                                                style: t700_14.copyWith(
                                                  color: clrFFFFFF,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            : Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.chooseLocation,
                                                style: t400_14.copyWith(
                                                  color: const Color(
                                                    0xffffffff,
                                                  ),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                      );
                                    },
                                  ),
                                  const Expanded(child: SizedBox()),
                                  GestureDetector(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const NotificationsScreen(),
                                        ),
                                      );
                                      // getIt<HomeManager>().getSpecialities();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                        horizontal: 2,
                                      ),
                                      child: notificationIcon(
                                        hMgr
                                            .spcialities
                                            ?.unreadNotificationCount,
                                      ),
                                    ),
                                  ),
                                  // GestureDetector(
                                  //     onTap: (){
                                  //       _key.currentState!.openEndDrawer();
                                  //
                                  //     },
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.only(top:0.0 ,bottom:0.0 ,left:8.0 ),
                                  //       child: SvgPicture.asset("assets/images/home_icons/menu.svg",height: 28,),
                                  //     )),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // SEARCH BAR
                        Entry(
                          yOffset: -20,
                          // scale: 20,
                          duration: const Duration(milliseconds: 500),
                          delay: const Duration(milliseconds: 50),
                          curve: Curves.ease,
                          visible: hMgr.heightF == 4,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: hMgr.heightF == 4 ? 1 : 0,
                            child: pad(
                              horizontal: w1p * 5,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/searchScreen');
                                },
                                child: AnimatedContainer(
                                  margin: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).padding.top +
                                        h1p * 6 -
                                        (searchFixed ? h1p * 1 : 0),
                                    // (!searchFixed
                                    //     ? scrlPosition > 40
                                    //         ? scrlPosition
                                    //         : h10p * 0.7 - scrlPosition
                                    //     : h1p * 6)
                                  ),
                                  duration: const Duration(milliseconds: 500),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      containerRadius / 2,
                                    ),
                                    color: clr202020.withOpacity(0.4),
                                    // border: searchFixed ? Border.all(color: clr202020.withOpacity(0.4), width: 0.5) : null,
                                  ),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    width: maxWidth - w10p,
                                    height: hMgr.heightF == 4 ? h10p * 0.6 : 0,
                                    decoration: BoxDecoration(
                                      color: Colours.boxblue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(
                                        containerRadius / 2,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: w1p * 4,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 12,
                                            height: 12,
                                            child: SvgPicture.asset(
                                              "assets/images/icon-search.svg",
                                              color: clrFFFFFF,
                                            ),
                                          ),
                                          horizontalSpace(8),
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.searchFor,
                                            style: t400_14,
                                            // textAlign: TextAlign.start,
                                          ),
                                          AnimatedTextKit(
                                            repeatForever: true,
                                            animatedTexts: lst,
                                            onTap: () {},
                                          ),
                                          const Spacer(),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12.0,
                                            ),
                                            child: VerticalDivider(),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              var res = await showModalBottomSheet(
                                                elevation: 0,
                                                isDismissible: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (context) {
                                                  return const SpeechToTextWidget();
                                                },
                                              );

                                              if (res != null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        SearchResultScreen(
                                                          title: AppLocalizations.of(
                                                            context,
                                                          )!.onlineConsultations,
                                                          type: 2,
                                                          searchquery: res,
                                                        ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 2,
                                                    vertical: 12,
                                                  ),
                                              // color: Colors.red,
                                              child: SizedBox(
                                                width: 18,
                                                height: 18,
                                                child: SvgPicture.asset(
                                                  "assets/images/home_icons/icon-mic.svg",
                                                  color: clrFFFFFF,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //tab bar container

                        // if (!hMgr.showPetTab)
                        //   GestureDetector(
                        //     onHorizontalDragEnd: (details) {
                        //       // if (details.velocity.pixelsPerSecond.dx < 0) {
                        //       //   hMgr.setShowPetTab(true);
                        //       // }
                        //     },
                        //     child: Container(
                        //       margin: EdgeInsets.only(
                        //           right: MediaQuery.of(context).padding.right),
                        //       // alignment: Alignment.centerRight,
                        //       height: maxHeight,
                        //       width: maxWidth,
                        //       decoration: BoxDecoration(
                        //         color: clr606060.withOpacity(.7),
                        //         // borderRadius: BorderRadius.circular(300),
                        //       ),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           // Center(child: SizedBox(width: maxWidth / 4, child: const AnimatedArrow())),
                        //           Lottie.asset(
                        //             'assets/images/home_icons/finger_swipe.json',
                        //             width: maxWidth / 2,
                        //             height: maxWidth / 2,
                        //             fit: BoxFit.contain,
                        //           ),
                        //           Text(
                        //             'Swipe left to see the \npet consultation tab',
                        //             style: t700_22.copyWith(color: clrFFFFFF),
                        //           ),
                        //           verticalSpace(32),
                        //           ElevatedButton(
                        //               onPressed: () {
                        //                 hMgr.setShowPetTab(true);
                        //               },
                        //               style: ButtonStyle(
                        //                   backgroundColor:
                        //                       MaterialStateProperty.all(clr2E3192)),
                        //               child: Text(
                        //                 'Got it',
                        //                 style: t700_18.copyWith(color: clrFFFFFF),
                        //               ))
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: BottomAppBar(
                  padding: EdgeInsets.zero,
                  height:
                      hMgr.upcomingAppointmentsModel?.upcomingAppointments !=
                              null &&
                          hMgr
                              .upcomingAppointmentsModel!
                              .upcomingAppointments!
                              .isNotEmpty &&
                          (getValidStartTime(
                                    hMgr
                                        .upcomingAppointmentsModel!
                                        .upcomingAppointments!
                                        .first,
                                  ) !=
                                  null ||
                              getIt<HomeManager>().isConsultationOngoing(
                                hMgr
                                    .upcomingAppointmentsModel!
                                    .upcomingAppointments!
                                    .first,
                              ))
                      ? 64 + 43
                      : 64,
                  // iconSize: 30,showSelectedLabels: true,
                  // showUnselectedLabels: true,
                  color: Colors.transparent,
                  // unselectedLabelStyle:t400_10.copyWith(color: clr2D2D2D),
                  // selectedLabelStyle:t400_10.copyWith(color: clr2D2D2D),
                  // selectedFontSize: 10,
                  // unselectedFontSize: 10,

                  // currentIndex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      hMgr.upcomingAppointmentsModel?.upcomingAppointments !=
                                  null &&
                              hMgr
                                  .upcomingAppointmentsModel!
                                  .upcomingAppointments!
                                  .isNotEmpty &&
                              (getValidStartTime(
                                        hMgr
                                            .upcomingAppointmentsModel!
                                            .upcomingAppointments!
                                            .first,
                                      ) !=
                                      null ||
                                  getIt<HomeManager>().isConsultationOngoing(
                                    hMgr
                                        .upcomingAppointmentsModel!
                                        .upcomingAppointments!
                                        .first,
                                  ))
                          ? Container(
                              height: 43,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors:
                                      getIt<HomeManager>()
                                              .isConsultationOngoing(
                                                hMgr
                                                    .upcomingAppointmentsModel!
                                                    .upcomingAppointments!
                                                    .first,
                                              ) ==
                                          true
                                      ? [clr00C165, clr00C165]
                                      : [
                                          const Color(0xff7A64A7),
                                          const Color(0xff4E8DBF),
                                        ],
                                ),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              child: Builder(
                                builder: (context) {
                                  DateTime? validStartTime = getValidStartTime(
                                    hMgr
                                        .upcomingAppointmentsModel!
                                        .upcomingAppointments!
                                        .first,
                                  );
                                  bool? isConsultaitonOngoind =
                                      getIt<HomeManager>()
                                          .isConsultationOngoing(
                                            hMgr
                                                .upcomingAppointmentsModel!
                                                .upcomingAppointments!
                                                .first,
                                          );

                                  if (validStartTime != null) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const UpcomingAppointmentsScreen(),
                                          ),
                                        );
                                      },
                                      child: TodaysAppoinmentBoxwithTimer(
                                        hMgr
                                            .upcomingAppointmentsModel!
                                            .upcomingAppointments!
                                            .first,
                                      ),
                                    );
                                  } else if (isConsultaitonOngoind) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const UpcomingAppointmentsScreen(),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Start Consultation",
                                            style: t400_14,
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            )
                          : const SizedBox(),
                      Container(
                        height: 64,
                        color: Colors.white,
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              btNavIcon(
                                onTap: () {},
                                icon: "assets/images/bt-nav-btn-home.png",
                                title: "Home",
                                isSelected: true,
                              ),
                              btNavIcon(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MyDoctorsScreen(),
                                    ),
                                  );
                                },
                                icon: "assets/images/bt-nav-btn-mydocs.png",
                                title: "My Dr.s",
                                isSelected: false,
                              ),
                              btNavIcon(
                                onTap: () {
                                  Navigator.of(
                                    context,
                                  ).push(navigateOnlineCategories(false));
                                },
                                icon: "assets/images/dq-logo-1.5x.png",
                                title: "Consult Now",
                                isSelected: false,
                                isCenter: true,
                              ),
                              btNavIcon(
                                onTap: () {
                                  showComingSoonDialog(context);
                                  // Navigator.push(context, MaterialPageRoute(builder: (_) => const PetSplashScreen()));
                                },
                                icon: "assets/images/bt-nav-btn-pet.png",
                                title: "Pet Care",
                                isSelected: false,
                              ),
                              btNavIcon(
                                onTap: () {
                                  _key.currentState!.openEndDrawer();
                                },
                                icon: "assets/images/bt-nav-btn-menu.png",
                                title: "Menu",
                                isSelected: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
// class LeftCornerClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(size.width, 0.0);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0.0, size.height);
//     path.lineTo(0.0, size.height - 50.0); // Adjust the curve position
//     path.quadraticBezierTo(0.0, size.height - 50.0, 50.0, size.height - 100.0); // Adjust control points to modify curve
//     path.lineTo(0.0, 0.0); // Returning back to initial point closes the path
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }

Route navigateOnlineCategories(bool schedule) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        OnlineCategoriesScreen(forScheduledBooking: schedule),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

Route navigateOnlineCouncelling() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        CounsellingScreen(title: AppLocalizations.of(context)!.therapyProblems),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

class TodaysAppoinmentBoxwithTimer extends StatelessWidget {
  final UpcomingAppointments appoinment;
  const TodaysAppoinmentBoxwithTimer(this.appoinment, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/images/appointment-clock-yellow.svg"),
        horizontalSpace(4),
        Row(
          children: [
            Text("Your Appointment  ", style: t400_14),
            AppoinmentTimerText(
              fn: () {
                getIt<HomeManager>().getUpcomingAppointments(isRefresh: true);
              },
              consultStartTime: DateTime.parse(appoinment.bookingStartTime!),
              type: 2,
              tstyle: t400_14,
            ),
          ],
        ),
      ],
    );
  }
}

//LOADING WIDGET WITH LOGO
class LogoLoader extends StatefulWidget {
  final double? size;
  final Color? color;

  const LogoLoader({super.key, this.size = 100, this.color});

  @override
  State<LogoLoader> createState() => _LogoLoaderState();
}

class _LogoLoaderState extends State<LogoLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                "assets/images/appicon.svg",
                color: widget.color,
              ),
            ),
          );
        },
      ),
    );
  }
}

//LOADING WIDGET WITHOUT LOGO
class AppLoader extends StatelessWidget {
  final double? size;
  final Color? color;
  const AppLoader({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: clr2D2D2D.withOpacity(0.1))],
      ),
      width: 100,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LoadingAnimationWidget.threeArchedCircle(
          color: color ?? clr5A6BE2,
          size: size ?? 40,
        ),
      ),
    );
  }
}
