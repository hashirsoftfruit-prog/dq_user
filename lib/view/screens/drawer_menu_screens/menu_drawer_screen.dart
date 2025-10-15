// ignore_for_file: use_build_context_synchronously

import 'package:dqapp/controller/managers/auth_manager.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/fcm.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/offers_screen.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/packages_screen.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/patients_screen.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/profile_screen.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/consultations_screen.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/medical_records_screen.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/my_doctors_screen.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/purchased_packages_screen.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/reminder_screens/reminder_screen.dart';
import 'package:dqapp/view/screens/starting_screens/splash_scren.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/upcoming_appoinments_screen.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../controller/managers/profile_manager.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';

class MenuDrawerScreen extends StatefulWidget {
  final double w1p;
  final double h1p;
  // String img;
  const MenuDrawerScreen({
    super.key,
    required this.h1p,
    required this.w1p,
    // required this.img,
  });

  @override
  State<MenuDrawerScreen> createState() => _MenuDrawerScreenState();
}

class _MenuDrawerScreenState extends State<MenuDrawerScreen> {
  @override
  void initState() {
    getIt<ProfileManager>().getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool loader = Provider.of<HomeManager>(context).logoutLoader;

    Widget menuRowItem(String txt, {String? scndTxt, required String icon}) {
      return Padding(
        padding: EdgeInsets.only(
          left: 10,
          top: widget.h1p * 0.5,
          bottom: widget.h1p * 0.4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20, child: Image.asset(icon, color: clr2D2D2D)),
                horizontalSpace(8),
                Text(txt, style: t400_14.copyWith(color: clr2D2D2D)),
                // Container(
                //     decoration: BoxDecoration(border: Border.all(color: scndTxt==null?Colors.transparent:Colours.lightBlu)),
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 18),
                //       child: Text(scndTxt??"",style: TextStyles.menuDrawItemStyle2,),
                //     )),
              ],
            ),
            Container(
              height: 0.5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [clr2D2D2D.withOpacity(0.5), Colors.transparent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(txt, style: t500_14),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget menuRowItem2(String txt, {bool? hideDivider, String? icon}) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 10,
          // top: widget.h1p*0.5,bottom: widget.h1p*0.4
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 4.0,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: Image.asset(
                      icon ?? "assets/images/drawer-icon-appoinments.png",
                      color: clr2D2D2D,
                    ),
                  ),
                  horizontalSpace(8),
                  Text(txt, style: t400_14.copyWith(color: clr2D2D2D)),
                ],
              ),
            ),
            hideDivider == true
                ? const SizedBox()
                : Container(
                    height: 0.5,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          clr2D2D2D.withOpacity(0.5),
                          Colors.transparent,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(txt, style: t500_14),
                      ),
                    ),
                  ),
          ],
        ),
      );
    }

    return Consumer<ProfileManager>(
      builder: (context, mgr, child) {
        return Container(
          height: widget.h1p * 100,
          width: widget.w1p * 90,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.w1p * 4,
              vertical: widget.h1p * 2,
            ),
            child: ListView(
              children: [
                mgr.profileModel.personalDetails?.firstName != null
                    ? Entry(
                        yOffset: -100,
                        visible: mgr.profileModel.personalDetails != null,
                        // scale: 20,
                        delay: const Duration(milliseconds: 3),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.ease,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfileScreen(),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colours.lightGrey,
                              boxShadow: [boxShadow5],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: widget.h1p * 3,
                              horizontal: widget.w1p * 4,
                            ),
                            child:
                                mgr.profileModel.personalDetails?.firstName !=
                                    null
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: widget.w1p * 5,
                                        child: Center(
                                          child: Image.asset(
                                            "assets/images/arrow-right.png",
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                            child: Container(
                                              height: widget.h1p * 8,
                                              width: widget.h1p * 8,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colours.primaryblue,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  mgr
                                                              .profileModel
                                                              .personalDetails
                                                              ?.image !=
                                                          null
                                                      ? 0
                                                      : 8.0,
                                                ),
                                                child:
                                                    mgr
                                                            .profileModel
                                                            .personalDetails
                                                            ?.image !=
                                                        null
                                                    ? Image.network(
                                                        '${StringConstants.baseUrl}${mgr.profileModel.personalDetails?.image}',
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.asset(
                                                        "Male" == "Male"
                                                            ? "assets/images/person-man.png"
                                                            : "assets/images/person-women.png",
                                                        color: Colors.white,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          verticalSpace(widget.h1p),
                                          SizedBox(
                                            width: widget.w1p * 60 - 8,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                1.0,
                                              ),
                                              child: Text(
                                                getIt<StateManager>().capitalizeFirstLetter(
                                                  mgr
                                                                  .profileModel
                                                                  .personalDetails
                                                                  ?.firstName !=
                                                              null &&
                                                          (mgr
                                                                      .profileModel
                                                                      .personalDetails
                                                                      ?.firstName
                                                                      ?.length ??
                                                                  0) >
                                                              16
                                                      ? '${mgr.profileModel.personalDetails?.firstName?.substring(0, 13)}..${mgr.profileModel.personalDetails?.firstName?.substring((mgr.profileModel.personalDetails?.firstName?.length ?? 2) - 3, mgr.profileModel.personalDetails?.firstName?.length)}' //
                                                      : mgr
                                                                .profileModel
                                                                .personalDetails
                                                                ?.firstName ??
                                                            '', //
                                                ),
                                                // getIt<StateManager>().capitalizeFirstLetter(mgr.profileModel.personalDetails?.firstName ?? ""),
                                                style: t500_16.copyWith(
                                                  color: clr444444,
                                                  height: 1,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${mgr.profileModel.personalDetails?.gender} | ${mgr.profileModel.personalDetails?.age}",
                                            style: t500_14.copyWith(
                                              color: const Color(0xff838383),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: widget.w1p * 5,
                                        child: Center(
                                          child: Image.asset(
                                            "assets/images/arrow-right.png",
                                            color: const Color(0xff838383),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      )
                    : const SizedBox(),
                verticalSpace(widget.h1p * 0.5),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [boxShadow8],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () async {
                          // Navigator.pop(context);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const UpcomingAppointmentsScreen(),
                            ),
                          );
                          getIt<HomeManager>().setAppointmentsTabTitle(
                            null,
                            isDispose: true,
                          );

                          getIt<HomeManager>().getUpcomingAppointments(
                            isRefresh: true,
                          );
                        },
                        child: menuRowItem2(
                          AppLocalizations.of(context)!.appoinments,
                          icon: "assets/images/drawer-icon-appoinments.png",
                          hideDivider: false,
                        ),
                      ),
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ConsultationsScreen(),
                            ),
                          );
                        },
                        child: menuRowItem2(
                          AppLocalizations.of(context)!.consultations,
                          icon: "assets/images/drawer-icon-consultations.png",
                          hideDivider: false,
                        ),
                      ),
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ReminderScreen(),
                            ),
                          );
                        },
                        child: menuRowItem2(
                          AppLocalizations.of(context)!.reminder,
                          icon: "assets/images/drawer-icon-reminder.png",
                          hideDivider: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PatientsScreen(),
                            ),
                          );
                        },
                        child: menuRowItem(
                          AppLocalizations.of(context)!.myPatients,
                          icon: "assets/images/drawer-icon-familymembers.png",
                        ),
                      ),
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MyDoctorsScreen(),
                            ),
                          );
                        },
                        child: menuRowItem(
                          AppLocalizations.of(context)!.myDoctors,
                          icon: "assets/images/drawer-icon-mydoctors.png",
                        ),
                      ),
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MedicalRecordsScreen(),
                            ),
                          );
                        },
                        child: menuRowItem(
                          AppLocalizations.of(context)!.medicalRecords,
                          icon: "assets/images/drawer-icon-medicalrecords.png",
                        ),
                      ),
                      // InkWell(highlightColor: Colors.transparent,splashColor: Colors.transparent,
                      //     onTap: (){
                      //
                      //     },
                      //     child: menuRowItem(AppLocalizations.of(context)!.payments)),
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OffersScreen(),
                            ),
                          );
                        },
                        child: menuRowItem(
                          AppLocalizations.of(context)!.offers,
                          icon: "assets/images/drawer-icon-offers.png",
                        ),
                      ),

                      // InkWell(highlightColor: Colors.transparent,splashColor: Colors.transparent,
                      //     onTap: (){
                      //
                      //     },
                      //     child: menuRowItem(AppLocalizations.of(context)!.settings)),
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PurchasedPackagesScreen(),
                            ),
                          );
                        },
                        child: menuRowItem(
                          AppLocalizations.of(context)!.purchasedPackages,
                          icon:
                              "assets/images/drawer-icon-purchasedpackages.png",
                        ),
                      ),
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PackagesScreen(),
                            ),
                          );
                        },
                        child: menuRowItem(
                          AppLocalizations.of(context)!.packages,
                          icon: "assets/images/drawer-icon-packages.png",
                        ),
                      ),
                      // InkWell(highlightColor: Colors.transparent,splashColor: Colors.transparent,
                      //     onTap: (){
                      //
                      //     },
                      //     child: menuRowItem(AppLocalizations.of(context)!.helpCenter)),
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);

                          // getIt<StateManager>().changeLocale(getIt<SharedPreferences>().getString(StringConstants.language) == 'ml' ? 'en' : 'ml');
                          getIt<ProfileManager>().changeLocale(
                            getIt<SharedPreferences>().getString(
                                      StringConstants.language,
                                    ) ==
                                    'ml'
                                ? 'en'
                                : 'ml',
                          );

                          getIt<HomeManager>().homeBeginFns();
                          Fluttertoast.showToast(msg: "Language Switched");
                        },
                        child: menuRowItem(
                          AppLocalizations.of(context)!.language,
                          icon: "assets/images/drawer-icon-language.png",
                          // scndTxt: getIt<SharedPreferences>().getString(StringConstants.language)=="ml"?AppLocalizations.of(context)!.malayalam:AppLocalizations.of(context)!.english)),
                          scndTxt: "English",
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          bool? result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return LogoutWarningPopUp(
                                w1p: widget.w1p,
                                h1p: widget.h1p,
                              );
                            },
                          );

                          if (result != null) {
                            await getIt<HomeManager>().logoutFn();
                            showTopSnackBar(
                              Overlay.of(context),
                              const SuccessToast(message: "Logged out"),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SplashScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        child: menuRowItem(
                          loader
                              ? 'Logging out...'
                              : AppLocalizations.of(context)!.logout,
                          icon: "assets/images/drawer-icon-logout.png",
                        ),
                      ),
                      // InkWell(highlightColor: Colors.transparent,splashColor: Colors.transparent,
                      //     onTap: (){
                      //
                      //       Navigator.push(context, MaterialPageRoute(builder: (_)=>QuestionnaireScreen(bookingId: 123,appoinmentId: "sdsd",)));
                      //     },
                      //     child: Container(width: w1p*50,decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),border: Border.all()),
                      //       child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Center(child: Text("QUESTIONNAIRE"))
                      //       ),
                      //     ),),

                      // verticalSpace(h1p*1),
                      // InkWell(highlightColor: Colors.transparent,splashColor: Colors.transparent,
                      //     onTap: (){
                      //
                      //       Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatPage("232")));
                      //     },
                      //     child: Container(width: w1p*50,decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),border: Border.all()),
                      //       child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Center(child: Text("CHAT"))
                      //       ),
                      //     ),), verticalSpace(h1p*1),
                      // // InkWell(highlightColor: Colors.transparent,splashColor: Colors.transparent,
                      // //     onTap: (){
                      // //
                      // //       Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen(
                      // //
                      // //       )));
                      // //     },
                      // //     child: Container(width: w1p*50,decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),border: Border.all()),
                      // //       child: Padding(
                      // //           padding: const EdgeInsets.all(8.0),
                      // //           child: Center(child: Text("ANIMATION"))
                      // //       ),
                      // //     ),),
                      // // verticalSpace(h1p*1),
                      //
                      //
                      // InkWell(highlightColor: Colors.transparent,splashColor: Colors.transparent,
                      //     onTap: (){
                      //
                      //
                      //       Navigator.push(context, MaterialPageRoute(builder: (_)=>LoadingScreen(bookingId: 1234,appoinmentId: "dfdf")));
                      //     },
                      //     child: Container(width: w1p*50,decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),border: Border.all()),
                      //       child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Center(child: Text("websocket"))
                      //       ),
                      //     ),),

                      // verticalSpace(h1p*3),
                      // InkWell(
                      //   onTap: (){
                      //     showModalBottomSheet(enableDrag: true,
                      //         backgroundColor: Colors.blueGrey,
                      //         isScrollControlled: true,useSafeArea: true,
                      //         context: context, builder: (context)=>PackageDetailsScreen(maxWidth: w1p*100,maxHeight:h1p*100,
                      //       pkg: Packages(title: "15 consultations across all specialities for 1 month",amount: "10000", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua",
                      //           subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt"), ));
                      //
                      //
                      //   },
                      //   child: Text("packagesheet"),
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
          //   ),
          // ),
        );
      },
    );
  }
}

class LogoutWarningPopUp extends StatelessWidget {
  final double w1p;
  final double h1p;
  // String msg;  // String type;
  // String? offlineTimeSlot;
  // String currentClinicAddress;
  // Function bookOnlineOnClick;
  // Function bookClinicOnClick;
  const LogoutWarningPopUp({
    super.key,
    required this.w1p,
    required this.h1p,
    // required this.msg,
    // required this.experience,
    // required this.onlineTimeSlot,
    // required this.type,
    // required this.offlineTimeSlot,
    // required this.currentClinicAddress,
    // required this.bookOnlineOnClick,
    // required this.bookClinicOnClick,
  });

  @override
  Widget build(BuildContext context) {
    String msg = 'Are you sure you want to logout?';

    return AlertDialog(
      backgroundColor: Colors.white,

      // title: Text('Logout',style: TextStyles.textStyle3d,),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SizedBox(
          width: w1p * 90,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text(msg, style: t500_14.copyWith(color: clr444444))],
          ),

          // height: h1p*80,
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colours.primaryblue),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 5,
              ),
              child: Text(
                "Cancel",
                style: t500_12.copyWith(color: const Color(0xff707070)),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: linearGrad,
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 5,
              ),
              child: Text(
                "Logout",
                style: t500_12.copyWith(color: const Color(0xffffffff)),
              ),
            ),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 18.0),
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
