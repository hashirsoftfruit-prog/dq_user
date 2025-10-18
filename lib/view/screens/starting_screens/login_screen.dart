import 'package:dqapp/view/screens/home_screen.dart';
import 'package:dqapp/view/screens/starting_screens/login_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controller/managers/auth_manager.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import '../../widgets/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    // _controller = new AnimationController(
    //   duration: const Duration(seconds: 1),
    //   vsync: this,
    // )..forward();
  }

  @override
  void dispose() {
    // clears login data
    getIt<AuthManager>().disposeLogin();
    getIt<StateManager>().disposeLogin();
    super.dispose();
  }

  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarBrightness: Brightness.dark,
    //     statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark// Status bar color
    // ));
    int loadedWidget = Provider.of<AuthManager>(context).loadedWidget;
    bool loader = Provider.of<StateManager>(context).showLoader;
    List<String>? phNo = Provider.of<AuthManager>(context).phNo;

    // bool? showIcon = StringConstants.tempIconViewStatus;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        Widget btn(String title) {
          return pad(
            horizontal: w1p * 5.5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(h1p),
                  child: Text(
                    title,
                    style: t500_18.copyWith(color: const Color(0xff3F429A)),
                  ),
                ),
              ),
            ),
          );
        }

        // getIlustrator({required String txt1, required String txt2, required String img}) {
        //   return Container(
        //     width: maxWidth,
        //     child: Column(
        //       mainAxisSize: MainAxisSize.max,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(
        //           txt1,
        //           style: TextStyles.textStyle73,
        //         ),
        //         Text(
        //           txt2,
        //           style: TextStyles.textStyle73b,
        //         ),
        //         // Image.asset(img,height: h10p*1.5, )
        //       ],
        //     ),
        //   );
        // }
        // List<Container> cnts =[
        //   getIlustrator(txt1: 'Find & Book' ,txt2: 'Doctor’s Appointment',img:"assets/images/login-ilustr2.png" ),
        //   getIlustrator(txt1: "Instant Online",txt2:"Counselling" ,img:"assets/images/login-ilustr3.png" ),
        //   getIlustrator(txt1: "Live Video Consult",txt2:"With in 30 Sec" ,img:"assets/images/login-ilustr1.png" )
        // ];

        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: getIt<SmallWidgets>().logoAppBarWidget(),
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: Container(
            height: maxHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff6C6EB8), Color(0xffFE9297)],
                begin: Alignment.centerRight,
                end: Alignment.topLeft,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w10p * 0.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  verticalSpace(h1p),

                  // SizedBox(
                  //   child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //               Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //   borderRadius: BorderRadius.circular(10)
                  //
                  //                   ),
                  //
                  //
                  //                 height:68,
                  //                   width:68,
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.all(8.0),
                  //                     child: Image.asset("assets/images/dq-logo-1.5x.png"),
                  //                   )),
                  //               horizontalSpace(4),
                  //
                  //               Column(crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text("dq app",style:t700_30.copyWith(fontFamily: "Montserrat")),
                  //                   Text("Doctor on queue",style:t500_13.copyWith(fontFamily: "Montserrat",color: clrFFFFFF.withOpacity(0.8))),
                  //                 ],
                  //               ),
                  //     ],
                  //   ),
                  // ),
                  verticalSpace(h1p * 2),

                  Column(
                    children: [
                      Container(
                        width: maxWidth,
                        height: maxHeight * 0.27,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: const Color(0xffD9D9D9).withOpacity(0.1),
                            ),
                          ],
                          //
                          // color: Colors.white.withOpacity(0.05),
                          // color: Colours.primaryblue,
                          color: const Color(0xffD9D9D9).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(containerRadius),
                        ),
                        child: Stack(
                          children: [
                            loadedWidget == 0
                                ? LoginWidget(
                                    h1p: h1p,
                                    w1p: w1p,
                                    phNoCntroller: controller,
                                    btn: btn("Login"),
                                  )
                                : loadedWidget == 1
                                ? OtpScreen(
                                    h1p: h1p,
                                    phNo: phNo,
                                    w1p: w1p,
                                    btn: btn("Verify"),
                                  )
                                : const SizedBox(), // AddDetails(h1p: h1p, w1p: w1p, controller: controller, btn: btn("Go")),

                            Visibility(
                              visible: loader,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: null,
                                child: SizedBox(
                                  width: maxWidth,
                                  height: h10p * 3.6,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(21),
                                      color: Colors.transparent,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: AppLoader(
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  verticalSpace(34),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
