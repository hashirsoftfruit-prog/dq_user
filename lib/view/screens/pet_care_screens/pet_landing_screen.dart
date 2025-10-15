// ignore_for_file: deprecated_member_use

import 'package:dqapp/view/screens/pet_care_screens/pet_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:provider/provider.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/coming_soon_dialog.dart';
import 'groomers_list_screen.dart';
import 'my_pets_list_screen.dart';

class PetLandingScreen extends StatefulWidget {
  const PetLandingScreen({Key? key}) : super(key: key);

  @override
  State<PetLandingScreen> createState() => _PetLandingScreenState();
}

class _PetLandingScreenState extends State<PetLandingScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    getIt<StateManager>().changePetHomeIndex(1, isDispose: true);

    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // The app has come to the foreground
      // print("App is in the foreground");

      // You can perform actions here when the app is resumed
    }
  }

  @override
  Widget build(BuildContext context) {
    int btNavIndex = Provider.of<StateManager>(context).petBtNavIndex;
    // StudentDashBoard? stDash = Provider.of<StudentManager>(context).stDash;

    // int selectedIndex = 0;
    DateTime? currentBackPressTime;

    Future<bool> onWillPop() {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        try {
          if (btNavIndex == 1) {
            Fluttertoast.showToast(msg: "Press back again to exit");
          } else {
            getIt<StateManager>().changePetHomeIndex(1);
          }
        } catch (e) {
          // debugPrint(e.toString());
        }

        return Future.value(false);
      } else {
        return Future.value(true);
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        // double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        // double w1p = maxWidth * 0.01;

        // Widget navBarItem({required String img, required String title,required TextStyle txtstyle,required Color iconColor}){
        //   return SizedBox(
        //     height:h10p*1,
        //     child: Column(mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         SizedBox(height: h10p*0.4,
        //           child: SvgPicture.asset(
        //             img,
        //             color: iconColor,
        //           ),
        //         ),
        //         Text(title,style: txtstyle,)
        //       ],
        //     ),
        //   );
        // }

        Widget navBarIcon({
          required String img,
          required String title,
          required TextStyle txtstyle,
          required Color iconColor,
        }) {
          return SizedBox(
            height: h10p * 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: h1p * 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Image.asset(img, color: iconColor),
                  ),
                ),
                Text(title, style: txtstyle),
              ],
            ),
          );
        }

        // Widget bNavIcon(String loc){
        //   return SizedBox(
        //       height: h1p*4,
        //       child: SvgPicture.asset(loc,color: Colours.primaryblue,));
        // }

        // double floatButtonwidth = w1p*17;

        List<Widget> screens = [
          Container(),
          const PetHomeScreen(),
          Container(),
          const MyPetsListScreen(),
          const GroomersListScreen(),

          // Container(color:Colors.white,child: Center(child: Text("Coming soon")),),
          // HomeScreen(),
          // ScannedReciepts(),
          // ExpenseGroups(),
          // Profile()
        ];

        return SafeArea(
          bottom: false,
          child: WillPopScope(
            onWillPop: onWillPop,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              body: SafeArea(bottom: false, child: screens[btNavIndex]),
              bottomNavigationBar: BottomAppBar(
                color: Colors.white,
                elevation: 1,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                height: h10p * 1.1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 3,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        btNavIndex == 0
                            ? navBarIcon(
                                img: "assets/images/pet-btnav-back.png",
                                title: "Back",
                                txtstyle: t500_11.copyWith(color: clr444444),
                                iconColor: const Color(0xffFFAE00),
                              )
                            : InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: navBarIcon(
                                  img: "assets/images/pet-btnav-back.png",
                                  title: "Back",
                                  txtstyle: t500_11.copyWith(color: clr444444),
                                  iconColor: const Color(0xff878787),
                                ),
                              ),
                        btNavIndex == 1
                            ? navBarIcon(
                                img: "assets/images/pet-btnav-home.png",
                                title: "Home",
                                txtstyle: t500_11.copyWith(color: clr444444),
                                iconColor: const Color(0xffFFAE00),
                              )
                            : InkWell(
                                onTap: () {
                                  getIt<StateManager>().changePetHomeIndex(1);
                                },
                                child: navBarIcon(
                                  img: "assets/images/pet-btnav-home.png",
                                  title: "Home",
                                  txtstyle: t500_11.copyWith(color: clr444444),
                                  iconColor: const Color(0xff878787),
                                ),
                              ),
                        btNavIndex == 2
                            ? navBarIcon(
                                img: "assets/images/pet-btnav-bookings.png",
                                title: "Bookings",
                                txtstyle: t500_11.copyWith(color: clr444444),
                                iconColor: const Color(0xffFFAE00),
                              )
                            : InkWell(
                                onTap: () {
                                  showComingSoonDialog(context);
                                  // getIt<StateManager>().changePetHomeIndex(2);
                                },
                                child: navBarIcon(
                                  img: "assets/images/pet-btnav-bookings.png",
                                  title: "Bookings",
                                  txtstyle: t500_11.copyWith(color: clr444444),
                                  iconColor: const Color(0xff878787),
                                ),
                              ),
                        btNavIndex == 3
                            ? navBarIcon(
                                img: "assets/images/pet-btnav-mypet.png",
                                title: "My Pet",
                                txtstyle: t500_11.copyWith(color: clr444444),
                                iconColor: const Color(0xffFFAE00),
                              )
                            : InkWell(
                                onTap: () {
                                  getIt<StateManager>().changePetHomeIndex(3);
                                },
                                child: navBarIcon(
                                  img: "assets/images/pet-btnav-mypet.png",
                                  title: "My Pet",
                                  txtstyle: t500_11.copyWith(color: clr444444),
                                  iconColor: const Color(0xff878787),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
        // resizeToAvoidBottomInset: false,
        // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        ;
      },
    );
  }
}
