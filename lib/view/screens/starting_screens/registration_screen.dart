// ignore_for_file: use_build_context_synchronously

import 'package:entry/entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../controller/managers/auth_manager.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/common_widgets.dart';
import '../home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  final List<String>? cCodeAndphNo;
  const RegistrationScreen({super.key, required this.cCodeAndphNo});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // bool animate=false;

  var fnameCntrlr = TextEditingController();
  var lnameCntrlr = TextEditingController();
  var ageCntrlr = TextEditingController();

  // asynccc()async{
  //   await Future.delayed(Duration(milliseconds: 500));
  //   setState(() {
  //     animate =true;
  //   });
  // }

  @override
  void dispose() {
    getIt<AuthManager>().disposeRegistration();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // asynccc();

    bool loader = Provider.of<StateManager>(context).showLoader;

    unFocusFn() {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
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

        String selectedGender = Provider.of<AuthManager>(
          context,
        ).selectedGender;
        String selectedLang = Provider.of<AuthManager>(context).selectedLang;
        // bool? showIcon = StringConstants.tempIconViewStatus;
        // var _formKey = GlobalKey<FormState>();

        Widget genderContainer({required bool selected, required String txt}) {
          return Container(
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(containerRadius / 2),
              border: Border.all(color: Colors.white, width: 0.5),
            ),
            child: pad(
              horizontal: w1p * 3,
              vertical: h1p * 0.8,
              child: Text(
                txt,
                style: selected
                    ? t400_16.copyWith(color: const Color(0xff3F429A))
                    : t400_16,
              ),
            ),
          );
        }

        List<String> genders = ["Male", "Female", "Other"];
        List<String> langs = ["English", "Malayalam"];
        // OtpFieldController otpController = OtpFieldController();

        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: getIt<SmallWidgets>().logoAppBarWidget(),

          resizeToAvoidBottomInset: true,
          // backgroundColor: Colours.primaryblue,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff6C6EB8), Color(0xffFE9297)],
                begin: Alignment.centerRight,
                end: Alignment.topLeft,
              ),
            ),
            child: pad(
              horizontal: w1p * 4,
              vertical: h1p * 3,
              child: Stack(
                children: [
                  ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      verticalSpace(50),

                      // pad(horizontal: 0,vertical:  h1p*2,
                      //   child: Align(alignment: Alignment.centerRight,
                      //     child: Entry(
                      //       xOffset: -100,
                      //       // scale: 20,
                      //       delay: const Duration(milliseconds: 10),
                      //       duration: const Duration(milliseconds: 700),
                      //       curve: Curves.ease,
                      //       child: SizedBox(width: w10p*2.5,height: w10p*2.5,
                      //
                      //
                      //
                      //           child:showIcon? Image.asset("assets/images/home_icons/logo-login.png"):Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: Image.asset("assets/images/temp-app-icon.png"),
                      //           )),
                      //     ),
                      //   ),
                      // ),
                      Entry(
                        yOffset: 100,
                        // scale: 20,
                        delay: const Duration(milliseconds: 10),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.ease,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Hi,", style: t700_18),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Fill the form for better experience",
                                style: t700_18,
                              ),
                            ),
                            verticalSpace(h1p * 1.5),
                            SizedBox(
                              height: h1p * 6,
                              child: TextFormField(
                                onTapOutside: (s) {
                                  unFocusFn();
                                },
                                textCapitalization: TextCapitalization
                                    .sentences, // Automatically capitalizes the first letter of each sentence
                                scrollPadding: EdgeInsets.zero,

                                style: t400_16.copyWith(color: Colors.white),
                                decoration: inputDec2(hnt: "Enter First Name"),

                                controller: fnameCntrlr,
                              ),
                            ),
                            verticalSpace(h1p),
                            SizedBox(
                              height: h1p * 6,
                              child: TextFormField(
                                onTapOutside: (s) {
                                  unFocusFn();
                                },
                                textCapitalization: TextCapitalization
                                    .sentences, // Automatically capitalizes the first letter of each sentence
                                scrollPadding: EdgeInsets.zero,
                                style: t400_16.copyWith(color: Colors.white),

                                decoration: inputDec2(hnt: "Last Name"),

                                controller: lnameCntrlr,
                              ),
                            ),
                            verticalSpace(h1p),
                            SizedBox(
                              height: h1p * 6,
                              child: TextFormField(
                                readOnly: true,
                                onTap: () async {
                                  var tday = DateTime.now();
                                  ageCntrlr.text = ageCntrlr.text.isNotEmpty
                                      ? ageCntrlr.text
                                      : DateFormat('dd/MM/yyyy').format(
                                          DateTime(
                                            tday.year - 16,
                                            tday.month,
                                            tday.day,
                                          ),
                                        );

                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Material(
                                        color: Colors.white,
                                        child: SizedBox(
                                          height: 255,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: Text(
                                                      "Done",
                                                      style: t700_16.copyWith(
                                                        color: clr444444,
                                                        height: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 220,
                                                margin: EdgeInsets.only(
                                                  bottom: MediaQuery.of(
                                                    context,
                                                  ).viewInsets.bottom,
                                                ),
                                                padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                ),
                                                color: Colors.white,
                                                child: CupertinoDatePicker(
                                                  initialDateTime:
                                                      getIt<StateManager>()
                                                          .convertStringToDDMMYYY(
                                                            ageCntrlr.text,
                                                          ),
                                                  maximumDate: DateTime(
                                                    tday.year - 16,
                                                    tday.month,
                                                    tday.day,
                                                  ),
                                                  minimumDate: DateTime(
                                                    tday.year - 100,
                                                  ),
                                                  mode: CupertinoDatePickerMode
                                                      .date,
                                                  use24hFormat: true,
                                                  // This is called when the user changes the time.
                                                  onDateTimeChanged:
                                                      (DateTime newTime) {
                                                        String formattedDate =
                                                            DateFormat(
                                                              'dd/MM/yyyy',
                                                            ).format(newTime);
                                                        // print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                                        setState(() {
                                                          ageCntrlr.text =
                                                              formattedDate; //set output date to TextField value.
                                                        });
                                                      },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );

                                  // var tday = DateTime.now();
                                  // DateTime? pickedDate = await showDatePicker(barrierColor: Colours.primaryblue,
                                  //     initialEntryMode: DatePickerEntryMode.calendarOnly,
                                  //     context: context,
                                  //     initialDate: DateTime(tday.year-20),
                                  //     firstDate: DateTime(tday.year-120),
                                  //     //DateTime.now() - not to allow to choose before today.
                                  //     lastDate: DateTime(tday.year-10));
                                  //
                                  // if (pickedDate != null) {
                                  //   print(
                                  //       pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  //   String formattedDate =
                                  //   DateFormat('dd/MM/yyyy').format(pickedDate);
                                  //   print(
                                  //       formattedDate); //formatted date output using intl package =>  2021-03-16
                                  //   setState(() {
                                  //     ageCntrlr.text =
                                  //         formattedDate; //set output date to TextField value.
                                  //   });
                                  //   FocusScopeNode currentFocus = FocusScope.of(context);
                                  //   if (!currentFocus.hasPrimaryFocus) {
                                  //     currentFocus.unfocus();
                                  //   }
                                  // } else {}
                                },
                                style: t400_16.copyWith(color: Colors.white),

                                decoration: inputDec2(hnt: "Date of Birth"),

                                controller: ageCntrlr,
                                // keyboardType: TextInputType.number,
                              ),
                            ),
                            verticalSpace(h1p * 2),
                            SizedBox(
                              height: h1p * 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: genders.map((e) {
                                  // var i = cnts.indexOf(e);
                                  return pad(
                                    horizontal: w1p,
                                    child: GestureDetector(
                                      onTap: () {
                                        getIt<AuthManager>().updateGender(e);
                                      },
                                      child: genderContainer(
                                        selected: e == selectedGender,
                                        txt: e,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            verticalSpace(h1p * 3),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Select Your Language",
                                style: t500_18,
                              ),
                            ),
                            verticalSpace(h1p * 2),
                            SizedBox(
                              height: h1p * 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: langs.map((e) {
                                  // var i = cnts.indexOf(e);
                                  return pad(
                                    horizontal: w1p,
                                    child: GestureDetector(
                                      onTap: () {
                                        getIt<AuthManager>().updateLanguage(e);
                                      },
                                      child: genderContainer(
                                        selected: e == selectedLang,
                                        txt: e,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            verticalSpace(h10p),
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () async {
                                getIt<StateManager>().getLoader(true);
                                // final isValid = _formKey.currentState!.validate();
                                await Future.delayed(
                                  const Duration(seconds: 1),
                                );
                                const isValid = true;
                                if (isValid) {
                                  String fname = fnameCntrlr.text;
                                  String lname = lnameCntrlr.text;
                                  String gender = selectedGender;
                                  String language = selectedLang;
                                  List<String> phnumber = widget.cCodeAndphNo!;

                                  if (fname.isNotEmpty &&
                                      lname.isNotEmpty &&
                                      ageCntrlr.text.isNotEmpty &&
                                      gender.isNotEmpty) {
                                    // int age = int.parse(ageCntrlr.text);

                                    FocusScopeNode currentFocus = FocusScope.of(
                                      context,
                                    );
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    var result = await getIt<AuthManager>()
                                        .registration(
                                          firstName: fname,
                                          lastName: lname,
                                          dateOfBirth: ageCntrlr.text,
                                          gender: gender,
                                          phoneNo: phnumber,
                                          lang: language,
                                        );

                                    if (result.status == true) {
                                      showTopSnackBar(
                                        Overlay.of(context),
                                        SuccessToast(
                                          message: result.message ?? "",
                                        ),
                                      );
                                      getIt<AuthManager>().saveToken(
                                        result.token ?? "",
                                      );
                                      getIt<AuthManager>().saveUserName(fname);
                                      getIt<AuthManager>().saveUserId(
                                        result.userId ?? 0,
                                      );
                                      getIt<AuthManager>().savePatientId(
                                        result.patientId ?? 0,
                                      );
                                      getIt<StateManager>().changeLocale(
                                        selectedLang == "Malayalam"
                                            ? 'ml'
                                            : 'en',
                                      );
                                      await getIt<AuthManager>().saveFcmApi();

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const HomeScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    } else {
                                      showTopSnackBar(
                                        Overlay.of(context),
                                        ErrorToast(
                                          message: result.message ?? "",
                                        ),
                                      );
                                    }
                                  } else {
                                    showTopSnackBar(
                                      Overlay.of(context),
                                      ErrorToast(
                                        message: fname.isEmpty
                                            ? "Invalid First Name"
                                            : lname.isEmpty
                                            ? "Invalid Last Name"
                                            : ageCntrlr.text.isEmpty
                                            ? "Invalid Date of Birth"
                                            : gender.isEmpty
                                            ? "Please choose a Gender"
                                            : "",
                                      ),
                                    );
                                  }
                                }

                                getIt<StateManager>().getLoader(false);
                              },
                              child: btn("Let's Go"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  myLoader(
                    width: maxWidth,
                    height: maxHeight,
                    visibility: loader,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
