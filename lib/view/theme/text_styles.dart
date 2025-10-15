import 'package:dqapp/view/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/helper/service_locator.dart';

TextStyle get t400_14 => getstyle(weight: FontWeight.w400, size: 14.0);
TextStyle get t400_16 => getstyle(weight: FontWeight.w400, size: 16.0);
TextStyle get t400_18 => getstyle(weight: FontWeight.w400, size: 18.0);
TextStyle get t400_12 => getstyle(weight: FontWeight.w400, size: 12.0);
TextStyle get t400_11 => getstyle(weight: FontWeight.w400, size: 11.0);
TextStyle get t400_13 => getstyle(weight: FontWeight.w400, size: 13.0);
TextStyle get t400_10 => getstyle(weight: FontWeight.w400, size: 10.0);
TextStyle get t400_8 => getstyle(weight: FontWeight.w400, size: 8.0);
TextStyle get t400_20 => getstyle(weight: FontWeight.w400, size: 20.0);
TextStyle get t400_22 => getstyle(weight: FontWeight.w400, size: 22.0);

TextStyle get t700_14 => getstyle(weight: FontWeight.w700, size: 14.0);
TextStyle get t700_13 => getstyle(weight: FontWeight.w700, size: 13.0);
TextStyle get t700_16 => getstyle(weight: FontWeight.w700, size: 16.0);
TextStyle get t700_18 => getstyle(weight: FontWeight.w700, size: 18.0);
TextStyle get t700_12 => getstyle(weight: FontWeight.w700, size: 12.0);
TextStyle get t700_10 => getstyle(weight: FontWeight.w700, size: 10.0);
TextStyle get t700_22 => getstyle(weight: FontWeight.w700, size: 22.0);
TextStyle get t700_30 => getstyle(weight: FontWeight.w700, size: 30.0);
TextStyle get t700_20 => getstyle(weight: FontWeight.w700, size: 20.0);
TextStyle get t700_24 => getstyle(weight: FontWeight.w700, size: 24.0);
TextStyle get t700_42 => getstyle(weight: FontWeight.w700, size: 42.0);

TextStyle get t500_13 => getstyle(
  weight: FontWeight.w500,
  size: 12.5,
  fontFamily: "Product Sans Medium",
);
TextStyle get t500_14 => getstyle(
  weight: FontWeight.w500,
  size: 14.0,
  fontFamily: "Product Sans Medium",
);
TextStyle get t500_15 => getstyle(
  weight: FontWeight.w500,
  size: 15.0,
  fontFamily: "Product Sans Medium",
);
TextStyle get t500_16 => getstyle(
  weight: FontWeight.w500,
  size: 16.0,
  fontFamily: "Product Sans Medium",
);
TextStyle get t500_18 => getstyle(
  weight: FontWeight.w500,
  size: 18.0,
  fontFamily: "Product Sans Medium",
);
TextStyle get t500_12 => getstyle(
  weight: FontWeight.w500,
  size: 12.0,
  fontFamily: "Product Sans Medium",
);
TextStyle get t500_11 => getstyle(
  weight: FontWeight.w500,
  size: 11.0,
  fontFamily: "Product Sans Medium",
);
TextStyle get t500_10 => getstyle(
  weight: FontWeight.w500,
  size: 10.0,
  fontFamily: "Product Sans Medium",
);
TextStyle get t500_20 => getstyle(
  weight: FontWeight.w500,
  size: 20.0,
  fontFamily: "Product Sans Medium",
);
TextStyle get t500_22 => getstyle(
  weight: FontWeight.w500,
  size: 22.0,
  fontFamily: "Product Sans Medium",
);
TextStyle get t500_24 => getstyle(
  weight: FontWeight.w500,
  size: 24.0,
  fontFamily: "Product Sans Medium",
);

TextStyle get t600_14 => getstyle(
  weight: FontWeight.w600,
  size: 14.0,
  fontFamily: "Product Sans Medium",
);
TextStyle get t900_20 => getstyle(
  weight: FontWeight.w900,
  size: 20.0,
  fontFamily: "Product Sans Medium",
);

TextStyle get t800_16 => getstyle(
  weight: FontWeight.w800,
  size: 16.0,
  fontFamily: "Product Sans Medium",
);

class TextStyles {
  static String fontFam =
      getIt<SharedPreferences>().getString(StringConstants.language) == "ml"
      ? "Product Sans"
      : "Product Sans";

  static final textStyle3b = TextStyle(
    color: const Color(0xffffffff),
    fontWeight: FontWeight.w700,
    fontFamily: fontFam,
    fontStyle: FontStyle.normal,
    fontSize: 16.0,
    height: 1,
  );
  static final textStyle3c = TextStyle(
    color: clr444444,
    fontWeight: FontWeight.w700,
    fontFamily: fontFam,
    fontStyle: FontStyle.normal,
    fontSize: 16.0,
  );

  static final textStyleAnatomy1 = TextStyle(
    color: const Color(0xffffffff),
    fontWeight: FontWeight.w700,
    fontFamily: fontFam,
    fontStyle: FontStyle.normal,
    fontSize: 2.5,
  );

  static final notAvailableTxtStyle = t500_12.copyWith(
    color: const Color(0xb8444444),
  );

  static final patientPopupTxt3 = t500_16.copyWith(color: clr444444, height: 1);

  static final textStyle66 = t500_14.copyWith(color: const Color(0xff00C165));

  static final textStyle72 = t500_12.copyWith(
    color: const Color(0xff000000),
    height: 1,
  );

  static const textStyle73 = TextStyle(
    color: Color(0xffE7E7E7),
    fontWeight: FontWeight.w300,
    fontFamily: 'Montserrat',
    fontStyle: FontStyle.normal,
    fontSize: 16,
  );
  static final textStyle73b = t500_16.copyWith(
    color: const Color(0xffE7E7E7),
    fontFamily: 'Montserrat',
  );

  static final textStyle11c = t500_14.copyWith(
    color: const Color(0xff2E3192),
    fontFamily: 'Montserrat',
  );
  static final textStyle11d = t500_14.copyWith(
    color: const Color(0xffEB0000),
    fontFamily: 'Montserrat',
  );

  static final textStyleAnatomy2 = t500_12.copyWith(
    color: const Color(0xffEB0000),
    fontFamily: 'Montserrat',
  );

  static final notif1 = t500_14.copyWith(color: clr444444);

  static final textStyle75 = t500_14.copyWith(color: clr444444);
  static final textStyle75b = t400_12.copyWith(color: clr444444);
  static final textStyle76 = t500_14.copyWith(color: const Color(0xff363997));
  static final textStyle77 = t500_14.copyWith(color: clr444444);
  static final textStyle77e = t500_14.copyWith(color: const Color(0xffffffff));
  static final textStyle78b = t500_12.copyWith(color: const Color(0xff868686));
  static final textStyle78c = t500_12.copyWith(color: const Color(0xe7ffffff));
  static final textStyle79 = t500_14.copyWith(color: clr444444);
  static final textStyle79b = t500_14.copyWith(color: const Color(0xffffffff));
  static final textStyle80 = t400_13.copyWith(color: clr444444);
  static final textStyle80b = t400_13.copyWith(color: const Color(0xffffffff));
  static final textStyle81 = t500_14.copyWith(color: clr444444);
  static final textStyle81c = t500_14.copyWith(color: const Color(0xffffffff));
  static final textStyle81b = t500_14.copyWith(color: const Color(0xff00FF85));

  static final textStyle83 = t500_14.copyWith(color: clr444444);
  static final textStyle83b = t400_14.copyWith(color: clr444444);
  static final textStyle84 = t400_14.copyWith(color: const Color(0xff2E2E2E));
  static final textStyle84b = t400_12.copyWith(color: const Color(0xff868686));
  static final textStyle85 = t700_12.copyWith(color: const Color(0xff4447B7));
  static final reminder8b = t500_10.copyWith(color: const Color(0xff474747));

  static final petTxt17 = t700_13.copyWith(color: clr444444);
  static final petTxt18 = t500_16.copyWith(color: clr444444);
  static final petTxt19 = t400_12.copyWith(color: clr444444);
  static final petTxt20 = t500_14.copyWith(color: clr444444);
  static final petTxt21 = t500_12.copyWith(color: clr444444, height: 1);
  static final petTxt22 = t700_16.copyWith(color: clr444444);
}

getstyle({
  Color? color,
  required FontWeight weight,
  String? fontFamily,
  required double size,
  double? height,
}) {
  return TextStyle(
    color: color ?? const Color(0xffffffff),
    fontWeight: weight,
    fontFamily: fontFamily ?? "Product Sans",
    fontStyle: FontStyle.normal,
    fontSize: size,
    height: height,
  );
}
