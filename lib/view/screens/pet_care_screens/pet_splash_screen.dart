// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:dqapp/view/screens/pet_care_screens/pet_landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';

class PetSplashScreen extends StatefulWidget {
  const PetSplashScreen({Key? key}) : super(key: key);

  @override
  State<PetSplashScreen> createState() => _PetSplashScreenState();
}

class _PetSplashScreenState extends State<PetSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _navigateHome();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _navigateHome() async {
    await Future.delayed(const Duration(seconds: 1), () async {
      var tkn = getIt<SharedPreferences>().getString(StringConstants.token);

      if (tkn == null) {
        Navigator.of(context).pushReplacement(navigateLogin());
      } else {
        Navigator.of(context).pushReplacement(navigateLogin());
      }
    });
  }
  // Future<void> _checkPermission() async {
  //   var status = await Permission.notification.status;
  //   if (status.isGranted) {
  //     // If permission is granted, navigate to the main screen
  //     _navigateToHome();
  //   } else {
  //     // If permission is not granted, show the permission screen
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => PermissionScreen()),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() {
      // DateTime now = DateTime.now();
      return Future.value(false);
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        // double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        // double w1p = maxWidth * 0.01;
        return WillPopScope(
          onWillPop: onWillPop,
          child: Scaffold(
            // extendBody: true,
            backgroundColor: Colors.white,
            body: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // double size = h10p*1.5;
                // double size2 = _controller.value* w1p*2+w1p*2;
                return Center(
                  child: Container(
                    width: maxWidth,
                    height: maxHeight,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/pet-splash-image.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Container(width: 100,height: 100,color: Color(0xff4CB5AE),),
                        // Container(width: 100,height: 100,color: Color(0xffF5EEDC),),
                        // Container(width: 100,height: 100,color: Color(0xffFF6F61),),
                        // Container(width: 100,height: 100,color: Color(0xffFFD166),),
                        // Container(width: 100,height: 100,color: Color(0xff37474F),),
                        // Container(width: 100,height: 100,color: Color(0xffF8F9FA),),
                        CircularProgressIndicator(
                          backgroundColor: Color(0xffF8F9FA),
                          color: Color(0xffFFD166),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// Route NavigateHome() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(1.0, 0.0);
//       const end = Offset.zero;
//       final tween = Tween(begin: begin, end: end);
//       final offsetAnimation = animation.drive(tween);
//       return SlideTransition(
//         position: offsetAnimation,
//         child: child,
//       );
//     },
//   );
// }

Route navigateLogin() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const PetLandingScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
