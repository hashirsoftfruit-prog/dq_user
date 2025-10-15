// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:dqapp/controller/managers/auth_manager.dart';
import 'package:dqapp/view/screens/starting_screens/registration_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
// import 'package:otp_text_field/otp_field.dart';
// import 'package:otp_text_field/otp_field_style.dart';
// import 'package:otp_text_field/style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/managers/state_manager.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/common_widgets.dart';
import '../home_screen.dart';

class LoginWidget extends StatefulWidget {
  final double w1p;
  final double h1p;
  final TextEditingController phNoCntroller;
  final Widget btn;
  const LoginWidget({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.phNoCntroller,
    required this.btn,
  });

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool agreeTerms = false;
  void _showCountryPicker() async {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      favorite: ["IN", "AE"],
      onSelect: (Country country) {
        log(country.countryCode);
        getIt<AuthManager>().changeCountryCode("+${country.phoneCode}");
      },
    );
    // if (country != null) {

    // }
  }

  @override
  Widget build(BuildContext context) {
    String cCode = Provider.of<AuthManager>(context).countryCode;

    // var phNoCntroller = TextEditingController();
    Future<void> launchInWebView(Uri url) async {
      if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
        throw Exception('Could not launch $url');
      }
    }

    return ProgressHUD(
      child: Builder(
        builder: (context) {
          // final progress = ProgressHUD.of(context);

          return pad(
            horizontal: widget.w1p * 4,
            vertical: widget.h1p * 5,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Let's Get Started!!", style: t700_20),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Enter your mobile number", style: t400_16),
                ),
                verticalSpace(8),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    style: t400_16.copyWith(color: Colors.white),
                    scrollPadding: EdgeInsets.zero,
                    keyboardType: TextInputType.number,
                    decoration: inputDec(
                      prefix: SizedBox(
                        width: widget.w1p * 9,
                        child: InkWell(
                          onTap: () {
                            _showCountryPicker();
                          },
                          child: pad(
                            horizontal: widget.w1p * 2,
                            child: FittedBox(
                              fit: BoxFit.none,
                              child: Text(
                                cCode,
                                style: t400_16.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      hnt: "Enter mobile number",
                    ),
                    controller: widget.phNoCntroller,
                  ),
                ),
                verticalSpace(8),
                Row(
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          agreeTerms = !agreeTerms;
                        });
                      },
                      child: SizedBox(
                        // width: w1p*15,
                        height: widget.h1p * 3,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: agreeTerms
                              ? Image.asset(
                                  color: Colors.white,
                                  fit: BoxFit.contain,
                                  "assets/images/home_icons/checkbox-done.png",
                                )
                              : Image.asset(
                                  color: Colors.white,
                                  fit: BoxFit.contain,
                                  "assets/images/home_icons/checkbox-undone.png",
                                ),
                        ),
                      ),
                    ),
                    horizontalSpace(widget.w1p),
                    Row(
                      children: [
                        Text(
                          "I agree to DQ’s ",
                          style: t400_14.copyWith(
                            color: const Color(0xffffffff),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Uri url = Uri.parse(
                              '${StringConstants.baseUrl}/login_privacy_policy',
                            );
                            launchInWebView(url);
                          },
                          child: Text(
                            "privacy policy",
                            style: t400_14.copyWith(
                              color: const Color(0xffffffff),
                              backgroundColor: Colors.black12,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () async {
                    if (widget.phNoCntroller.text.isNotEmpty &&
                        agreeTerms == true &&
                        getIt<AuthManager>().isValidIndianPhoneNumber(
                          widget.phNoCntroller.text,
                        )) {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      getIt<StateManager>().getLoader(true);

                      var phNo = widget.phNoCntroller.text;
                      getIt<AuthManager>().setPhoneNo([cCode, phNo]);

                      var result = await getIt<AuthManager>().sendOtp(phNo);
                      if (result.status == true) {
                        showTopSnackBar(
                          Overlay.of(context),
                          SuccessToast(message: "OTP sent to $cCode$phNo"),
                        );
                        getIt<AuthManager>().setOTP(1234);

                        // getIt<AuthManager>().saveOtpModel(result);
                        // getIt<AuthManager>().saveToken(result.token ?? "");
                        // getIt<AuthManager>().saveUserName(result.firstName ?? "");
                        // getIt<AuthManager>().saveUserId(result.userId);

                        getIt<AuthManager>().changeWidget(
                          1,
                        ); //THIS NAVIGATES TO  OtpScreen()
                      } else {
                        showTopSnackBar(
                          Overlay.of(context),
                          ErrorToast(
                            maxLines: 4,
                            message: result.message ?? "",
                          ),
                        );
                      }

                      getIt<StateManager>().getLoader(false);
                    } else {
                      showTopSnackBar(
                        Overlay.of(context),
                        ErrorToast(
                          maxLines: 4,
                          message: widget.phNoCntroller.text.isEmpty
                              ? "Please provide valid phone number"
                              : agreeTerms != true
                              ? "You must agree terms and conditions to continue"
                              : "Invalid phone number",
                        ),
                      );
                    }
                  },
                  child: widget.btn,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ResendOTPTxt extends StatefulWidget {
  final Function fn;
  const ResendOTPTxt(this.fn, {super.key});

  @override
  State<ResendOTPTxt> createState() => _ResendOTPTxtState();
}

class _ResendOTPTxtState extends State<ResendOTPTxt> {
  int secondsRemaining = 30;
  bool enableResend = false;
  late Timer timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return enableResend == true
        ? InkWell(
            onTap: () async {
              await widget.fn();
              setState(() {
                enableResend = false;
                secondsRemaining = 30;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4,
                ),
                child: Text(
                  "Resend",
                  style: t500_12.copyWith(
                    height: 1,
                    // shadows: [Shadow(
                    //   color: Colors.black26,offset: Offset(1,1),
                    // )]
                  ),
                ),
              ),
            ),
          )
        : Text(
            "$secondsRemaining s",
            style: t500_12.copyWith(color: clrFFFFFF.withOpacity(0.7)),
          );
  }
}

class OtpScreen extends StatefulWidget {
  final double w1p;
  final double h1p;
  // bool? isExist;
  final List<String>? phNo;
  // PageController controller;
  final Widget btn;
  const OtpScreen({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.phNo,
    // required this.isExist,
    // required this.controller,
    required this.btn,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // int? generetedOtp = Provider.of<AuthManager>(context).otp;

    return Consumer<AuthManager>(
      builder: (context, mgr, child) {
        verifyOtp(pin) async {
          getIt<StateManager>().getLoader(true);

          List<String> cCodeAndPhNo = widget.phNo!;

          var result = await getIt<AuthManager>().verifyOtp(mgr.phNo![1], pin);
          if (result.status == true) {
            // if (pin == generetedOtp.toString())
            // {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            // await  Future.delayed(Duration(milliseconds: 500));
            showTopSnackBar(
              animationDuration: const Duration(milliseconds: 1000),
              displayDuration: const Duration(milliseconds: 1000),
              Overlay.of(context),
              SuccessToast(message: result.message ?? ""),
            );

            if (result.existingUser == true) {
              log("logged user ${result.toJson()}");
              getIt<AuthManager>().saveToken(result.token ?? "");
              await getIt<AuthManager>().saveFcmApi();
              getIt<AuthManager>().saveUserName(result.firstName ?? "");
              getIt<AuthManager>().saveUserId(result.userId);
              getIt<AuthManager>().savePatientId(result.patientId);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            } else {
              await Future.delayed(const Duration(milliseconds: 500));

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      RegistrationScreen(cCodeAndphNo: cCodeAndPhNo),
                ),
              );
            }
          } else {
            showTopSnackBar(
              padding: const EdgeInsets.all(8),
              animationDuration: const Duration(milliseconds: 1000),
              displayDuration: const Duration(milliseconds: 1000),
              Overlay.of(context),
              ErrorToast(
                maxLines: 3,
                message: result.message ?? "",

                // "Incorrect OTP",
              ),
            );
          }
          getIt<StateManager>().getLoader(false);
        }

        return pad(
          horizontal: widget.w1p * 4,
          vertical: 20,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text("OTP Verification", style: t700_20),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      "Sent OTP to ${widget.phNo![0]} ${widget.phNo![1]}",
                      style: t400_14,
                    ),
                    horizontalSpace(4),
                    GestureDetector(
                      onTap: () {
                        getIt<AuthManager>().changeWidget(0);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: clrFFFFFF.withOpacity(0.1),
                        ),
                        child: Text(
                          "Change",
                          style: t400_14.copyWith(color: clrFFFFFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PinCodeTextField(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                textStyle: t500_24,
                controller: otpController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                length: 4,
                obscureText: false,
                animationType: AnimationType.fade,
                animationDuration: const Duration(milliseconds: 300),
                pinTheme: PinTheme.defaults(
                  fieldHeight: 50,
                  fieldWidth: 50,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  selectedColor: clrFFFFFF,
                  activeColor: clrEDEDED,
                  inactiveColor: clrEDEDED,
                  activeBorderWidth: 1,
                  selectedBorderWidth: 2,
                  inactiveBorderWidth: 1,
                ),
                // errorAnimationController: errorController, // Pass it here
                onChanged: (value) {
                  // print(otpController.text);
                },
                appContext: context,
              ),

              //               SizedBox(
              //                 height: 50,
              //                 child: OTPTextField(
              //                     controller: otpController,
              //                     length: 4,
              //                     width: w1p * 90,
              //                     textFieldAlignment: MainAxisAlignment.spaceEvenly,
              //                     fieldWidth: 50,
              //                     spaceBetween: 4,
              //                     fieldStyle: FieldStyle.box,
              //                     otpFieldStyle: OtpFieldStyle(
              //                       borderColor: Colors.red,disabledBorderColor: Colors.white,errorBorderColor: Colors.red,
              //                       enabledBorderColor: Colors.white54,
              //                       focusBorderColor:clrFFFFFF,
              //
              //                       backgroundColor: Colors.transparent,
              //                     ),
              //                     outlineBorderRadius: 15,
              //                     style: TextStyles.textStyle49b,
              //                     onChanged: (pin) {
              // getIt<AuthManager>().setUserInputOTP(pin);                    },
              //                     onCompleted: (pin) async{
              //                       // verifyOtp(pin);
              //                       otpController.setFocus(5);
              //
              //                     }),
              //               ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  // otpController.clear();
                  // otpController.set(otpIntValues);
                  verifyOtp(otpController.text);

                  // otpController.setValue('3', 0);
                  // otpController.setFocus(1);
                },
                child: widget.btn,
              ),
              verticalSpace(18),
              SizedBox(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't Receive the OTP?", style: t500_12),
                      horizontalSpace(widget.w1p),
                      ResendOTPTxt(() async {
                        getIt<StateManager>().getLoader(true);

                        List<String>? phNo = mgr.phNo;
                        // getIt<AuthManager>().setPhoneNo('$cCode$phNo');

                        var result = await getIt<AuthManager>().sendOtp(
                          phNo![1],
                        );
                        if (result.status == true) {
                          showTopSnackBar(
                            Overlay.of(context),
                            SuccessToast(
                              message: "OTP sent to ${phNo[0]}${phNo[1]}",
                            ),
                          );
                          getIt<AuthManager>().setOTP(1234);

                          // getIt<AuthManager>().saveOtpModel(result);

                          // getIt<AuthManager>().saveToken(result.token ?? "");
                          // getIt<AuthManager>().saveUserName(result.firstName ?? "");
                          // getIt<AuthManager>().saveUserId(result.userId);

                          //THIS NAVIGATES TO  OtpScreen()
                        } else {
                          showTopSnackBar(
                            Overlay.of(context),
                            ErrorToast(message: result.message ?? ""),
                          );
                        }
                        getIt<StateManager>().getLoader(false);
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// class AddDetails extends StatefulWidget {
//   double w1p;
//   double h1p;
//   PageController controller;
//   Widget btn;
//   AddDetails({
//     required this.h1p,
//     required this.w1p,
//     required this.controller,
//     required this.btn,
//   });
//
//   @override
//   State<AddDetails> createState() => _AddDetailsState();
// }

// class _AddDetailsState extends State<AddDetails> {
//   @override
//   Widget build(BuildContext context) {
//
//   }
// }
