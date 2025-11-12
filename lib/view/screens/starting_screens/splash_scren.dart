// ignore_for_file: use_build_context_synchronously

import 'package:dqapp/view/screens/starting_screens/onboarding_screen.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    _navigateHome();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateHome() async {
    await Future.delayed(const Duration(seconds: 3), () async {
      var tkn = getIt<SharedPreferences>().getString(StringConstants.token);
      //checking user is logged in or not and redirecting
      if (tkn == null) {
        Navigator.of(
          context,
        ).pushAndRemoveUntil(navigateOnboarding(), (route) => false);
      } else {
        Navigator.of(
          context,
        ).pushAndRemoveUntil(navigateHome(), (route) => false);
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
    bool? showIcon = StringConstants.tempIconViewStatus;
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarBrightness: Brightness.dark,
    //     statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark// Status bar color
    // ));
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        // double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;
        return Scaffold(
          extendBody: true,
          // backgroundColor:Colors.white,
          body: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // double size = h10p*1.5;
              // double size2 = _controller.value* w1p*2+w1p*2;
              return Center(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff6C6EB8), Color(0xffFE9297)],
                      begin: Alignment.centerRight,
                      end: Alignment.topLeft,
                    ),
                  ),
                  // color: Colours.primaryblue.withOpacity(_controller.value),
                  width: maxWidth,
                  // height:maxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          double size = h10p * 1.7;
                          double size2 = _controller.value * w1p * 2 + w1p * 2;
                          return SizedBox(
                            width: size,
                            height: size,
                            child: Stack(
                              children: [
                                Entry.scale(
                                  scale: 10,
                                  // scale: 20,
                                  delay: const Duration(milliseconds: 2000),
                                  duration: const Duration(milliseconds: 1000),
                                  curve: Curves.easeIn,

                                  child: Opacity(
                                    opacity: _controller.value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        // boxShadow: [boxShadow4],
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      width: size,
                                      height: size,
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: _controller.value,
                                  child: SizedBox(
                                    width: size,
                                    height: size,
                                    child: Padding(
                                      padding: EdgeInsets.all(size2),
                                      child: showIcon == true
                                          ? SvgPicture.asset(
                                              "assets/images/appicon.svg",
                                            )
                                          : Image.asset(
                                              "assets/images/temp-app-icon.png",
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Route navigateHome() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

Route navigateLogin() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const LoginScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

Route navigateOnboarding() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const OnBoardingScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  Future<void> _requestPermission(BuildContext context) async {
    var status = await Permission.notification.request();
    if (status.isGranted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    } else {
      // Handle permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification permission is required to proceed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permission Required')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _requestPermission(context),
          child: const Text('Allow Notification Permission'),
        ),
      ),
    );
  }
}
