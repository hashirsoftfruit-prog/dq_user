import 'dart:math';

import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

class Colours {
  static const primaryblue = Color(0xff003B6D);
  // static const primaryblue = const Color(0xff2E3192);
  static const appointBoxClr = Color(0xffFBFBFB);
  static const logoWhite = Color(0xffFFF0C7);
  // static const bluegrad = const Color(0xff5054E5);
  static const boxblue = Color(0xffD9D9D9);
  static const grad1 = Color(0xff4D51C7);
  static const lightBlu = Color(0xffF2F2F2);
  static const couponBgClr = Color(0xffF6F6F6);
  static const dimViolet = Color(0xff9A9CCF);
  static const toastRed = Color(0xffC0171E);
  static const toastBlue = Color(0xff252887);
  static const lightGrey = Color(0xffFAFAFA);
  static const listOfColors = [Colours.primaryblue, Color(0xffED1C24)];
}

Color get clr6C6EB8 => const Color(0xff6C6EB8);
Color get clrFE9297 => const Color(0xffFE9297);
Color get clr202020 => const Color(0xff202020);
Color get clr2D2D2D => const Color(0xff2D2D2D);
Color get clrEDEDED => const Color(0xffEDEDED);
Color get clrFFFFFF => const Color(0xffFFFFFF);
Color get clrF5F5F5 => const Color(0xffF5F5F5);
Color get clr717171 => const Color(0xff717171);
Color get clrEFEFEF => const Color(0xffEFEFEF);
Color get clr858585 => const Color(0xff858585);
Color get clr868686 => const Color(0xff868686);
Color get clrCE6F7D => const Color(0xffCE6F7D);
Color get clr5758AC => const Color(0xff5758AC);
Color get clr417FB1 => const Color(0xff417FB1);
Color get clrFA8E53 => const Color(0xffFA8E53);
Color get clrD1ECFF => const Color(0xffD1ECFF);
Color get clr5A6BE2 => const Color(0xff5A6BE2);
Color get clrFFEDEE => const Color(0xffFFEDEE);
Color get clrF8F8F8 => const Color(0xffF8F8F8);
Color get clrF3F3F3 => const Color(0xffF3F3F3);
Color get clr2E3192 => const Color(0xff2E3192);
Color get clr4346B5 => const Color(0xff4346B5);
Color get clrA8A8A8 => const Color(0xffA8A8A8);
Color get clrFF6A00 => const Color(0xffFF6A00);
Color get clr00C165 => const Color(0xff00C165);
Color get clr7261A8 => const Color(0xff7261A8);
Color get clr757575 => const Color(0xff757575);
Color get clr444444 => const Color(0xff444444);
Color get clrFF4444 => const Color(0xffFF4444);
Color get clr545454 => const Color(0xff545454);
Color get clr8467A6 => const Color(0xff8467A6);
Color get clr5D5AAB => const Color(0xff5D5AAB);
Color get clrF98E95 => const Color(0xffF98E95);
Color get clrBD6273 => const Color(0xffBD6273);
Color get clr606060 => const Color(0xff606060);
Color get clrC4C4C4 => const Color(0xffC4C4C4);
Color get clrEEEFFF => const Color(0xffEEEFFF);
Color get clrF68629 => const Color(0xffF68629);
Color get clrD9D9D9 => const Color(0xffD9D9D9);
Color get clrEAF9FF => const Color(0xffEAF9FF);
Color get clr7361A8 => const Color(0xff7361A8);
Color get clrF38F9A => const Color(0xffF38F9A);
Color get clr4138B8 => const Color(0xff4138B8);
Color get clrFF6623 => const Color(0xffFF6623);
Color get clr127700 => const Color(0xff127700);

Color getRandomColor(String seed) {
  final rand = Random(seed.hashCode);
  return Color.fromARGB(
    255,
    rand.nextInt(200),
    rand.nextInt(200),
    rand.nextInt(200),
  );
}

Widget petLoader = const Center(
  child: CircularProgressIndicator(
    backgroundColor: Color(0xffF8F9FA),
    color: Color(0xffF950B8),
  ),
);

Padding pad({double? horizontal, double? vertical, required Widget child}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: horizontal ?? 0,
      vertical: vertical ?? 0,
    ),
    child: child,
  );
}

double containerRadius = 24;

Widget subLoader = Padding(
  padding: const EdgeInsets.all(8.0),
  child: Center(
    child: CircularProgressIndicator(
      strokeWidth: 5,
      color: Colours.primaryblue.withOpacity(0.5),
    ),
  ),
);

var outLineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: const BorderSide(width: 1, color: Colours.lightBlu),
);

var outLineBorder1 = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: BorderSide(width: 1, color: clr2D2D2D.withAlpha(110)),
);

var outLineBorder3 = UnderlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: const BorderSide(width: 1, color: Colours.lightBlu),
);
var outLineBorder2 = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: const BorderSide(width: 1, color: Colours.grad1),
);

var outLineBorder4 = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: const BorderSide(width: 1, color: Colors.transparent),
);
var couponCodebrdr = const OutlineInputBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(10.0),
    bottomLeft: Radius.circular(10.0),
  ),
  borderSide: BorderSide(width: 1, color: Colours.lightBlu),
);

Widget myLoader({
  double? width,
  double? height,
  required bool visibility,
  Color? color,
}) {
  return Visibility(
    visible: visibility,
    child: InkWell(
      onTap: () {},
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: AppLoader(
            size: 40,
            color: color,

            // size: 200,
          ),
        ),
      ),
    ),
  );
}

InputDecoration lineDec({required String hnt}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(left: 10),
    border: outLineBorder3,
    enabledBorder: outLineBorder3,
    enabled: true,
    focusedBorder: outLineBorder3,
    filled: true,
    fillColor: Colors.transparent,
    errorStyle: const TextStyle(fontSize: 0),
    // hintText: hnt,
    // label: Text(hnt,style: TextStyles.textStyle4c,),
    hintStyle: t400_14.copyWith(color: Colors.white54),
  );
}

InputDecoration inputDec({required String hnt, required Widget prefix}) {
  return InputDecoration(
    prefixIcon: prefix,
    contentPadding: const EdgeInsets.only(left: 10),
    border: outLineBorder,
    enabledBorder: outLineBorder,
    focusedBorder: outLineBorder,
    filled: true,
    fillColor: Colors.transparent,
    errorStyle: const TextStyle(fontSize: 0),
    hintText: hnt,
    hintStyle: t400_14.copyWith(color: Colors.white54),
  );
}

InputDecoration inputDec2({required String hnt}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(left: 10),
    border: outLineBorder4,
    enabledBorder: outLineBorder4,
    focusedBorder: outLineBorder,
    filled: true,
    fillColor: Colours.boxblue.withOpacity(0.2),
    errorStyle: const TextStyle(fontSize: 0),
    hintText: hnt,
    hintStyle: t400_14.copyWith(color: Colors.white54),
  );
}

InputDecoration inputDecForRegistrationScreen({required String hnt}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(left: 10),
    border: outLineBorder2,
    enabledBorder: outLineBorder2,
    focusedBorder: outLineBorder,
    filled: true,
    fillColor: Colours.boxblue.withOpacity(0.2),
    errorStyle: const TextStyle(fontSize: 0),
    hintText: hnt,
    hintStyle: t400_14.copyWith(color: Colors.white54),
  );
}

InputDecoration inputDec3({required String hnt}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(left: 10),
    border: outLineBorder,
    enabledBorder: outLineBorder,
    filled: true,
    fillColor: Colours.boxblue.withOpacity(0.2),
    errorStyle: const TextStyle(fontSize: 0),
    hintText: hnt,
    hintStyle: t400_16.copyWith(color: clr444444),
  );
}

InputDecoration inputDec4({required String hnt, bool? isEmpty}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(left: 10),
    border: outLineBorder,
    enabledBorder: outLineBorder,
    focusedBorder: outLineBorder,
    filled: true,
    labelText: hnt,
    labelStyle: t400_13.copyWith(color: const Color(0xff868686)),
    // fillColor: Colours.lightBlu,
    fillColor: isEmpty == true ? Colours.lightBlu : Colors.transparent,

    errorStyle: const TextStyle(fontSize: 0),
  );
}

InputDecoration inputDec5({required String hnt, bool? isEmpty}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(left: 10),
    border: outLineBorder1,
    enabledBorder: outLineBorder1,
    focusedBorder: outLineBorder1,
    // filled: true,
    labelText: hnt,
    labelStyle: t400_13.copyWith(color: const Color(0xff868686)),
    // fillColor: isEmpty == true ? Colours.lightBlu : Colors.transparent,
    errorStyle: const TextStyle(fontSize: 0),
  );
}

InputDecoration applyCouponFieldDec({required String hnt, bool? isEmpty}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(left: 10),
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    // filled: true,
    // labelText: hnt, labelStyle: t400_13.copyWith(color: Color(0xff474747)),
    hintText: hnt,
    hintStyle: t400_14.copyWith(color: clrA8A8A8),

    // fillColor: Colours.lightBlu,
    // fillColor: isEmpty == true ? Colours.lightBlu : Colors.transparent,
    errorStyle: const TextStyle(fontSize: 0),
  );
}

class StringConstants {
  static const String type = "type";
  static const String token = "token";
  static const String userName = "userName";
  static const String proImage = "profileImage";
  // static const String baseUrl = "https://app.doctoronqueue.com/api/";
  static const String hereMapApiKey =
      "C8QRieU3MDS4EPIre9UcCfdIrqF2R1JhRwNfxjCDLN0";
  // static const String baseUrl = "https://dq.demosoftfruit.com/api/";//live
  // static const String baseUrlApi = "https://practice.doctoronqueue.com/api/";//live new
  // static const String baseUrl = "http://book.demosoftfruit.com/api/";
  // static const String baseUrl = "http://doc.demosoftfruit.com/api/";//MEDICO
  // static const String imgBaseUrl = "https://app.doctoronqueue.com";
  // static const String imgBaseUrl = "https://dq.demosoftfruit.com";//live
  // static const String baseUrl = "https://practice.doctoronqueue.com";//live
  // static const String baseUrl = "https://dqlive.demosoftfruit.com";//live
  static const String baseUrl = "https://dqapp.doctoronqueue.com"; //live

  // static const String imgBaseUrl = "http://book.demosoftfruit.com";
  // static const String imgBaseUrl = "http://doc.demosoftfruit.com";//MEDICO
  static const String userId = "userId";
  static const String patientId = "patientId";
  static const String language = "language";
  static const String currentLatAndLong = "currentLatAndLong";
  static const String selectedLocation = "selectedLocation";
  static const String qnTypeTxtArea = "Text Area";
  static const String qnTypeTxtBox = "Text Box";
  static const String qnTypeRadio = "Radio";
  static const String qnTypeSelect = "Select";
  static const String qnTypeCheckBx = "Check Box";
  static const String searchSuggestions = "searchSuggestions";
  static const String upcomingBookings = "Upcoming";
  static const String cancelledBookings = "Cancelled";
  static const String medicine = "Medicine";
  static const String other = "Other";

  // |||||||||||||||||||||||||||||||||||||||||||

  static const String dPrefNoPref = "No preference";
  static const String dPrefMale = "Male";
  static const String dPrefFemale = "Female";
  static const String english = "English";
  static const String malayalam = "Malayalam";
  static const bool tempIconViewStatus = true;
  static const int psychologyTypeforCouncelling = 3;
  static const int psychologyTypeforTherapy = 2;
}

var boxShadow1 = BoxShadow(
  color: Colours.boxblue.withOpacity(0.3),
  offset: const Offset(2, 2),
  blurRadius: 3,
  spreadRadius: 3,
);
var boxShadow2 = const BoxShadow(
  color: Colors.white54,
  blurRadius: 1,
  spreadRadius: 1,
);
var boxShadow3 = BoxShadow(
  color: Colours.grad1.withOpacity(0.2),
  offset: const Offset(2, 2),
  blurRadius: 2,
  spreadRadius: 2,
);
var boxShadow4 = const BoxShadow(
  color: Colors.black12,
  offset: Offset(4, 4),
  blurRadius: 5,
  spreadRadius: 4,
);
var boxShadow4b = const BoxShadow(
  color: Colors.black12,
  offset: Offset(-4, -4),
  blurRadius: 5,
  spreadRadius: 4,
);
var boxShadow5 = BoxShadow(
  color: Colors.black.withOpacity(0.05),
  offset: const Offset(2, 2),
  blurRadius: 2,
  spreadRadius: 2,
);
var boxShadow5b = BoxShadow(
  color: Colors.black.withOpacity(0.05),
  offset: const Offset(1, 1),
  blurRadius: 2,
  spreadRadius: 2,
);
var boxShadow6 = const BoxShadow(
  color: Colors.black12,
  offset: Offset(0, 4),
  blurRadius: 5,
  spreadRadius: 4,
);
var boxShadow7 = const BoxShadow(
  color: Colors.black12,
  offset: Offset(1, 1),
  blurRadius: 2,
  spreadRadius: 2,
);
var boxShadow7b = const BoxShadow(
  color: Colors.black12,
  offset: Offset(-0, -0),
  blurRadius: 5,
  spreadRadius: 2,
);
var boxShadow8 = BoxShadow(
  color: Colors.grey.withOpacity(0.2),
  offset: const Offset(1, 1),
  blurRadius: 2,
  spreadRadius: 2,
);
var boxShadow8b = BoxShadow(
  color: Colors.grey.withOpacity(0.2),
  offset: const Offset(-1, -1),
  blurRadius: 2,
  spreadRadius: 2,
);
var boxShadow9 = BoxShadow(
  color: Colors.grey.withOpacity(0.1),
  offset: const Offset(1, 1),
  blurRadius: 1.5,
  spreadRadius: 1.5,
);
var boxShadow9red = BoxShadow(
  color: Colors.red.withOpacity(0.1),
  offset: const Offset(1, 1),
  blurRadius: 1.5,
  spreadRadius: 1.5,
);
var boxShadow9b = BoxShadow(
  color: Colors.grey.withOpacity(0.1),
  offset: const Offset(-1, -1),
  blurRadius: 1.5,
  spreadRadius: 1.5,
);
var boxShadow10 = const BoxShadow(
  color: Colors.black12,
  spreadRadius: 0.5,
  offset: Offset(-0.75, 0.75),
  blurRadius: 10,
);
var boxShadow11 = const BoxShadow(
  color: Colors.black26,
  spreadRadius: 1,
  offset: Offset(1, 1),
);
var boxShadow12 = const BoxShadow(
  color: Colors.black12,
  offset: Offset(-1, 4),
  blurRadius: 1,
  spreadRadius: 1,
);
var boxShadow13 = BoxShadow(
  color: Colors.black.withOpacity(0.35),
  offset: const Offset(0, 4),
  blurRadius: 10,
  spreadRadius: 0,
);
// var boxShadow13 = const BoxShadow(color: Colors.black12, offset: Offset(1, 3), blurRadius: 2, spreadRadius: 5);

var radialGrad1 = const RadialGradient(
  colors: [Color(0xff4D51C7), Color(0xff2E3192)],
);
var linearGrad = const LinearGradient(
  colors: [
    Color(0xFF3D3F83), // Darker shade

    Colours.primaryblue,
  ],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

var linearGrad2 = const LinearGradient(
  colors: [Color(0xff4D51C7), Color(0xff2E3192)],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

var linearGrad3 = const LinearGradient(
  colors: [Color(0xffFBFBFB), Color(0xffE9E9E9)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

var linearGrad4 = const LinearGradient(
  colors: [Color(0xffD60000), Color(0xffA40000)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

verticalSpace(double size) {
  return SizedBox(height: size);
}

horizontalSpace(double size) {
  return SizedBox(width: size);
}

divider() {
  return Container(
    height: 1,
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [Color(0xffE3E3E3), Color(0xff959595)]),
    ),
  );
}

// EasyDayProps dayDropsStyle({required double height}) {
//   return EasyDayProps(dayStructure: DayStructure.monthDayNumDayStr,
//     height: height,activeDayNumStyle: TextStyles.textStyle,inactiveDayNumStyle:TextStyles.textStyle3,
//     inactiveDayStrStyle:TextStyles.textStyle3,
//     activeDayStrStyle: TextStyles.textStyle3,inactiveMothStrStyle:TextStyles.textStyle3,
//     activeMothStrStyle: TextStyles.textStyle3,
//     todayMonthStrStyle: TextStyles.textStyle3,todayStrStyle:TextStyles.textStyle3,
//   );
// }

class Borders {
  // static var outlineInputBorder1 = OutlineInputBorder(borderRadius: BorderRadius.circular(4),borderSide: BorderSide(color: Colours.hash,width: 0.8));
  //
}
