import 'dart:math' as math;
import 'dart:math';

import 'package:blinking_text/blinking_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqapp/controller/routes/routnames.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/model/core/news_and_tips/news_and_tips.dart';
import 'package:dqapp/view/screens/booking_screens/banner_details_screen.dart';
import 'package:dqapp/view/screens/chat_screen.dart';
import 'package:dqapp/view/screens/home_screen.dart';
import 'package:dqapp/view/screens/pro/pro_home_tab.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/view/widgets/coming_soon_dialog.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redacted/redacted.dart';

import '../../controller/managers/booking_manager.dart';
import '../../controller/managers/home_manager.dart';
import '../../controller/managers/state_manager.dart';
import '../../model/core/banners_response_model.dart';
import '../../model/core/forum_list_model.dart';
import '../../model/core/upcome_appoiments_response_model.dart';
import '../../model/helper/service_locator.dart';
import '../theme/constants.dart';
import 'booking_screens/booking_loading_screen.dart';
import 'booking_screens/find_doctors_screen.dart';
import 'booking_screens/loading_screen.dart';
import 'drawer_menu_screens/upcoming_appoinments_screen.dart';

class HomeWidgets {
  reminderBox({
    required double w1p,
    required String title,
    required String subtitle,
    required Function ontap,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xff5F9CCE), Color((0xff7DB7E7))],
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xffD8E8F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Left Text Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: t700_18.copyWith(height: 1.2, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: t400_14.copyWith(height: 1.1, color: Colors.black),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        ontap();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff000000).withOpacity(0.15),
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              color: const Color(0xff000000).withOpacity(0.30),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                              spreadRadius: 0,
                            ),
                          ],
                          color: const Color(0xff4C85B3),
                          borderRadius: BorderRadius.circular(19),
                        ),
                        height: 29,
                        width: 130,
                        // padding: EdgeInsets.all(18),
                        child: Center(
                          child: Text(
                            "Set Reminder",
                            style: t500_14.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    verticalSpace(5),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Right Image Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/reminder_medicine.png', // Replace with your image asset path
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // return Stack(
    //   alignment: Alignment.center,
    //   children: [
    //     Container(
    //       color: const Color(0xff3983F9),
    //       width: w1p * 100,
    //       height: 180,
    //     ),
    //     SizedBox(
    //         width: w1p * 100,
    //         height: 180,
    //         child: Image.asset(
    //           "assets/images/raminder-bg-image.png",
    //           fit: BoxFit.cover,
    //         )),
    //     Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           // CircleAvatar(radius: 30, backgroundColor: clrFFFFFF),
    //           Stack(
    //             alignment: Alignment.center,
    //             children: [
    //               Container(
    //                   decoration: BoxDecoration(
    //                       color: Colors.transparent,
    //                       borderRadius: BorderRadius.circular(60),
    //                       border:
    //                           Border.all(color: Colors.white38, width: 0.8)),
    //                   height: 60,
    //                   width: 60),
    //               Container(
    //                   decoration: BoxDecoration(
    //                       color: Colors.transparent,
    //                       borderRadius: BorderRadius.circular(60),
    //                       border:
    //                           Border.all(color: Colors.white24, width: 0.9)),
    //                   height: 90,
    //                   width: 90),
    //               Container(
    //                   decoration: BoxDecoration(
    //                       color: Colors.transparent,
    //                       borderRadius: BorderRadius.circular(90),
    //                       border: Border.all(color: Colors.white12, width: 1)),
    //                   height: 140,
    //                   width: 140),
    //               SizedBox(
    //                 height: 70,
    //                 child: Padding(
    //                     padding: const EdgeInsets.only(bottom: 8.0, left: 4),
    //                     child: Transform.rotate(
    //                         angle: pi / 12,
    //                         child: Center(
    //                             child: Image.asset(
    //                                 "assets/images/reminder-clock.png")))),
    //               )
    //             ],
    //           ),
    //           horizontalSpace(32),
    //           Expanded(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Text(title, style: t700_18.copyWith(height: 1.2)),
    //                 Text(
    //                   subtitle,
    //                   style: t400_14.copyWith(height: 1.1),
    //                   maxLines: 3,
    //                 ),
    //                 verticalSpace(w1p * 4),
    //                 GestureDetector(
    //                   onTap: () {
    //                     ontap();
    //                   },
    //                   child: Container(
    //                       decoration: BoxDecoration(
    //                           boxShadow: [
    //                             BoxShadow(
    //                                 color: const Color(0xff000000)
    //                                     .withOpacity(0.15),
    //                                 offset: const Offset(0, 1),
    //                                 blurRadius: 3,
    //                                 spreadRadius: 1),
    //                             BoxShadow(
    //                                 color: const Color(0xff000000)
    //                                     .withOpacity(0.30),
    //                                 offset: const Offset(0, 1),
    //                                 blurRadius: 2,
    //                                 spreadRadius: 0),
    //                           ],
    //                           color: Colors.white,
    //                           borderRadius: BorderRadius.circular(19)),
    //                       height: 29,
    //                       width: 130,
    //                       // padding: EdgeInsets.all(18),
    //                       child: Center(
    //                           child: Text("Set Reminder",
    //                               style: t500_14.copyWith(
    //                                   color: Colours.primaryblue)))),
    //                 ),
    //                 // verticalSpace(18),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget cachedImg(
    String img, {
    String? placeholderImage,
    BoxFit? fit,
    bool? noPlaceHolder,
  }) {
    return CachedNetworkImage(
      fit: fit ?? BoxFit.cover,

      // fit: widget.fit,
      imageUrl: StringConstants.baseUrl + img,
      placeholder: (context, url) => noPlaceHolder == true
          ? const SizedBox()
          : Opacity(
              opacity: 0.5,
              child: Image.asset(
                placeholderImage ?? "assets/images/doctor-placeholder.png",
              ),
            ),
      errorWidget: (context, url, error) =>
          noPlaceHolder == true && placeholderImage == null
          ? const SizedBox()
          : Image.asset(
              placeholderImage ?? "assets/images/doctor-placeholder.png",
              fit: BoxFit.cover,
            ),
    );
  }

  Widget specialityBox({
    // required double h1p,
    required BuildContext context,
    required double w1p,
    required String img,
    required int index,
    required double size,
    required String title,
    required int count,
    required Function onClick,
    required bool isRedacted,
  }) {
    // double size = 90;
    return SizedBox(
      height: size + 35,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(containerRadius / 2),
            child: Container(
              height: size,
              width: size,
              // height: h1p*9,
              decoration: BoxDecoration(
                // color: Colours.boxblue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(containerRadius / 2),
              ),
              child: InkWell(
                onTap: () async {
                  onClick();
                },
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerRadius / 2,
                          ),
                          color: clrEFEFEF,
                        ),
                        height: index == 6 ? 50 : 50,
                        width: 100,
                      ),
                    ).redacted(context: context, redact: isRedacted),
                    if (!isRedacted)
                      SizedBox(
                        child: index == 6
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      '${count - 6}+',
                                      style: t500_22.copyWith(color: clr2D2D2D),
                                    ),
                                  ),
                                ),
                              )
                            : cachedImg(
                                img,
                                placeholderImage:
                                    "assets/images/home_icons/general-physician-temp.png",
                              ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          verticalSpace(4),
          SizedBox(
            width: size,
            child: Text(
              index == 6 ? "View All" : title,
              style: t400_12.copyWith(color: clr858585, height: 1.0),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ).redacted(context: context, redact: isRedacted);
  }

  Widget symptomsItem({
    // required double h1p,
    required double w1p,
    required String img,
    required int index,
    required String title,
    required Function onClick,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: index == 0 ? w1p * 4 : 0,
        right: 8,
        top: 8,
      ),
      child: SizedBox(
        width: 70,
        child: Column(
          children: [
            Container(
              height: 70,
              // height: h1p*9,
              decoration: BoxDecoration(
                // color: Colours.boxblue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(containerRadius / 2),
              ),
              child: InkWell(
                onTap: () async {
                  onClick();
                },
                child: Stack(
                  children: [
                    SizedBox(
                      // width: w1p*15,
                      // height: w1p*15,
                      child: cachedImg(
                        img,
                        noPlaceHolder: true,
                        placeholderImage: "assets/images/fever-temp.png",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpace(1),
            SizedBox(
              child: Text(
                title,
                style: t400_14.copyWith(color: clr2D2D2D, height: 1.1),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mentalWellItem({
    // required double h1p,
    required double w1p,
    required String img,
    required int index,
    required String title,
    required Function onClick,
  }) {
    double w = 140;
    // double h = 140;
    return Padding(
      padding: EdgeInsets.only(left: index == 0 ? w1p * 4 : 0, right: 8),
      child: Container(
        width: w,
        // height: h1p*9,
        decoration: BoxDecoration(
          color: clrD1ECFF,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () async {
            onClick();
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Text(
                    title,
                    style: t400_14.copyWith(color: clr2D2D2D, height: 1.1),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -10,
                right: -10,
                child: Container(
                  width: 160,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: clrFFFFFF.withOpacity(0.5),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: w,
                  // height: w1p*15,
                  child: cachedImg(
                    img,
                    placeholderImage: "assets/images/anxiety-temp.png",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ayurvedicNHomioBox({
    required AlignmentGeometry alignment,
    required double maxWidth,
    required String img,
    required String title1,
    required String title2,
    required Function onClick,
  }) {
    // double? _containerWidth;
    //     final RenderBox? renderBox =
    //     containerKey.currentContext?.findRenderObject() as RenderBox?;
    //     if (renderBox != null) {
    //       _containerWidth = renderBox.size.width;
    //
    //     }
    return Expanded(
      child: Container(
        height: 146,
        width: maxWidth * 0.46,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(.3), width: 0.5),
          boxShadow: [boxShadow8],
          image: DecorationImage(image: AssetImage(img), fit: BoxFit.fill),
          // color: Colours.boxblue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(containerRadius / 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(containerRadius / 2),
          child: InkWell(
            onTap: () async {
              onClick();
            },
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(containerRadius / 2),
                      color: clrFFEDEE,
                    ),
                    height: 50,
                    width: maxWidth * 0.46,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title1,
                            style: t500_14.copyWith(
                              color: clrCE6F7D,
                              height: 1,
                            ),
                          ),
                          Text(
                            title2,
                            style: t400_14.copyWith(
                              color: clr717171,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   top: 0,
                //   left: isLeft ? 0 : null,
                //   right: !isLeft ? 0 : null,
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           title1,
                //           style: t500_14.copyWith(color: clrCE6F7D, height: 1),
                //         ),
                //         Text(
                //           title2,
                //           style: t400_12.copyWith(color: clr717171, height: 1),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Align(
                //       alignment: alignment,
                //       child: Text(
                //         title1,
                //         style: t400_14.copyWith(color: clrCE6F7D),
                //         textAlign: textAlign,
                //       )),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Align(
                //       // alignment: alignment,
                //       child: Text(
                //     title2,
                //     style: t400_14.copyWith(color: clr717171),
                //     textAlign: textAlign,
                //   )),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConsultContainer extends StatefulWidget {
  final AlignmentGeometry alignment;
  final String bg;
  final double maxWidth;
  final double maxHeight;
  final String image;
  final String title1;
  final String title2;
  final String subtitle;
  final Color color;
  final Color bgColor;
  final Function onClick;

  const ConsultContainer({
    Key? key,
    required this.alignment,
    required this.bg,
    required this.maxWidth,
    required this.maxHeight,
    required this.image,
    required this.title1,
    required this.title2,
    required this.subtitle,
    required this.color,
    required this.bgColor,
    required this.onClick,
  }) : super(key: key);

  @override
  State<ConsultContainer> createState() => _ConsultContainerState();
}

class _ConsultContainerState extends State<ConsultContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onClick(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40, child: Row(children: [])),
                  Stack(
                    children: [
                      // This container is for solving the edge curve issue in large screens
                      Positioned(
                        bottom: 0,
                        child: Container(
                          // width: widget.maxWidth - 24,
                          width: widget.maxWidth * 0.45,
                          height: widget.maxHeight * .05,
                          color: widget.bgColor,
                        ),
                      ),
                      SizedBox(
                        // width: widget.maxWidth - 24,
                        width: widget.maxWidth * 0.45,
                        child: Image.asset(widget.bg, fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Positioned(
            //   top: 0,right: 0,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Container(decoration: BoxDecoration(
            //         color: clrF5F5F5,
            //         borderRadius: BorderRadius.circular(48)),
            //         width: widget.maxWidth * 0.08,
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
            //           child: Image.asset("assets/images/arrow-right.png"),
            //         )),
            //   ),),
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                height: 40,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title1,
                          style: t400_12.copyWith(
                            color: clr717171,
                            height: 1.15,
                          ),
                        ),
                        SizedBox(
                          width: widget.maxWidth * 0.45 * 0.48,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.title2,
                              style: t500_14.copyWith(
                                color: widget.color,
                                height: 1,
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

            Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                width: (widget.maxWidth * 0.45) * 0.7,
                // height: (widget.maxWidth * 0.45) / 5,
                child: Image.asset(widget.image),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.subtitle,
                  style: t400_10.copyWith(height: 1),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConsultContainerBig extends StatefulWidget {
  final AlignmentGeometry alignment;
  final String bg;
  final double maxWidth;
  final double maxHeight;
  final String image;
  final String title1;
  final String title2;
  final String subtitle1;
  final String subtitle2;
  final Color color;
  final Color bgColor;
  final Function onClick;
  final List<Color> gradinetColor;
  final bool subTitleBlinking;
  // final double screenHeight;
  // final double screenWidth;

  const ConsultContainerBig({
    Key? key,
    required this.alignment,
    required this.bg,
    required this.maxWidth,
    required this.maxHeight,
    required this.image,
    required this.title1,
    required this.title2,
    required this.subtitle1,
    required this.color,
    required this.bgColor,
    required this.onClick,
    required this.subtitle2,
    required this.gradinetColor,
    required this.subTitleBlinking,
  }) : super(key: key);

  @override
  State<ConsultContainerBig> createState() => _ConsultContainerBigState();
}

class _ConsultContainerBigState extends State<ConsultContainerBig> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onClick(),
      child: Container(
        height: widget.maxHeight * 0.22,
        width: widget.maxWidth * 0.45,
        decoration: BoxDecoration(
          color: widget.bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 1,
              left: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title1, style: t400_16),
                    widget.subTitleBlinking
                        ? BlinkText(
                            widget.title2,
                            style: t700_16,
                            endColor: Colors.red,
                            beginColor: const Color(0xff2f3193),
                            duration: const Duration(milliseconds: 1000),
                          )
                        : Text(widget.title2, style: t700_16),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 1,
              left: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.subtitle1, style: t400_14),
                    Text(widget.subtitle2, style: t700_16),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 1,
              right: 1,
              child: Container(
                height: widget.maxHeight * 0.09,
                width: widget.maxWidth * 0.242,
                decoration: BoxDecoration(
                  // color: widget.color,
                  gradient: LinearGradient(colors: widget.gradinetColor),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: const SizedBox(),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Image.asset(
                  widget.image,
                  // height: 100,
                  scale: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConsultContainerSmall extends StatefulWidget {
  final AlignmentGeometry alignment;
  final String bg;
  final double maxWidth;
  final double maxHeight;
  final String image;
  final String title1;
  final String title2;
  final String subtitle1;
  final String subtitle2;
  final Color color;
  final Color bgColor;
  final Function onClick;
  final List<Color> gradientColors;
  // final double screenHeight;
  // final double screenWidth;

  const ConsultContainerSmall({
    Key? key,
    required this.alignment,
    required this.bg,
    required this.maxWidth,
    required this.maxHeight,
    required this.image,
    required this.title1,
    required this.title2,
    required this.subtitle1,
    required this.color,
    required this.bgColor,
    required this.onClick,
    required this.subtitle2,
    required this.gradientColors,
    // required this.screenHeight,
    // required this.screenWidth,
  }) : super(key: key);

  @override
  State<ConsultContainerSmall> createState() => _ConsultContainerSmallState();
}

class _ConsultContainerSmallState extends State<ConsultContainerSmall> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onClick(),
      child: Container(
        height: widget.maxHeight * 0.15,
        width: widget.maxWidth * 0.45,
        decoration: BoxDecoration(
          // color: widget.bgColor,
          gradient: LinearGradient(colors: widget.gradientColors),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 1,
              left: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title1, style: t400_14),
                    Text(widget.title2, style: t700_14),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 1,
              left: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.subtitle1, style: t400_14),
                    Text(widget.subtitle2, style: t800_16),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 1,
              right: 1,
              child: ClipPath(
                // height: widget.maxHeight * 0.09,
                // width: widget.maxWidth * 0.26,
                // decoration: BoxDecoration(
                //     color: widget.color,
                //     borderRadius: const BorderRadius.only(
                //         topLeft: Radius.circular(16),
                //         bottomRight: Radius.circular(16))),
                // clipBehavior: Clip.hardEdge,
                clipper: MyClipper(),
                child: Container(
                  height: widget.maxHeight * 0.12,
                  width: widget.maxWidth * 0.3,
                  decoration: BoxDecoration(
                    color: widget.bgColor,
                    borderRadius: const BorderRadius.only(
                      // topLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: true,
              child: Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Image.asset(
                    widget.image,
                    // height: 100,
                    scale: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  get radius => null;

  @override
  Path getClip(Size size) {
    final path = Path();
    double w = size.width;
    double h = size.height;
    // double cornerRadius = 60;
    path.moveTo(0, h);
    // path.moveTo(w / 2, w / 2);
    path.quadraticBezierTo(w, 90, w, 0);
    path.lineTo(w, h);

    // Bottom right rounded corner
    path.quadraticBezierTo(w, h, w, h);

    path.lineTo(0, h);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class TherapiesContainer extends StatefulWidget {
  final AlignmentGeometry alignment;
  // final String bg;
  final double maxWidth;
  final double itemHeight;
  final String image;
  // final String title1;
  final String title2;
  // final String subtitle;
  final Color? color;
  final Function onClick;

  const TherapiesContainer({
    Key? key,
    required this.alignment,
    required this.itemHeight,
    // required this.bg,
    required this.maxWidth,
    required this.image,
    // required this.title1,
    required this.title2,
    // required this.subtitle,
    this.color,
    required this.onClick,
  }) : super(key: key);

  @override
  State<TherapiesContainer> createState() => _TherapiesContainerState();
}

class _TherapiesContainerState extends State<TherapiesContainer> {
  @override
  Widget build(BuildContext context) {
    Color? color = widget.color;
    if (color == null) {
      List<Color> colors = [
        const Color(0xffBD9F92),
        const Color(0xffFF8C5B),
        const Color(0xff9BB261),
        const Color(0xffC95FBA),
        const Color(0xffFF8C5B),
        const Color(0xff2987FF),
      ];

      Random random = Random();
      int index = random.nextInt(colors.length);
      color = colors[index];
    }

    return InkWell(
      onTap: () => widget.onClick(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 65,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, right: 20),
                    child: Text(
                      widget.title2,
                      style: t500_14.copyWith(color: color, height: 1),
                    ),
                  ),
                ),
                Entry(
                  delay: const Duration(milliseconds: 800),
                  duration: const Duration(milliseconds: 1800),
                  yOffset: 10,
                  child: Container(
                    width: widget.maxWidth * 0.45,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: color,
                    ),
                  ),
                ),
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Entry(
                delay: const Duration(milliseconds: 1000),
                duration: const Duration(milliseconds: 1200),
                yOffset: 10,
                child: SizedBox(
                  width: widget.maxWidth * 0.45,
                  height: (widget.maxWidth * 0.45) / 1.7,
                  child: HomeWidgets().cachedImg(
                    widget.image,
                    fit: BoxFit.fill,
                    noPlaceHolder: true,
                  ),
                ),
              ),
            ),
            // Positioned(bottom: 0,
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Text(widget.subtitle,style:t400_10.copyWith(height: 1),textAlign: TextAlign.start,),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class CounsellingContainer extends StatefulWidget {
  final AlignmentGeometry alignment;
  // final String bg;
  final double maxWidth;
  final String image;
  // final String title1;
  final String title2;
  // final String subtitle;
  final Color? color;
  final Function onClick;

  const CounsellingContainer({
    Key? key,
    required this.alignment,
    // required this.bg,
    required this.maxWidth,
    required this.image,
    // required this.title1,
    required this.title2,
    // required this.subtitle,
    this.color,
    required this.onClick,
  }) : super(key: key);

  @override
  State<CounsellingContainer> createState() => _CounsellingContainerState();
}

class _CounsellingContainerState extends State<CounsellingContainer> {
  @override
  Widget build(BuildContext context) {
    Color? color = widget.color;
    if (color == null) {
      List<Color> colors = [
        const Color(0xffBD9F92),
        const Color(0xffFF8C5B),
        const Color(0xff9BB261),
        const Color(0xffC95FBA),
        const Color(0xffFF8C5B),
        const Color(0xff2987FF),
      ];

      Random random = Random();
      int index = random.nextInt(colors.length);
      color = colors[index];
    }

    return InkWell(
      onTap: () => widget.onClick(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 65,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14.0, right: 20),
                    child: Text(
                      widget.title2,
                      style: t500_14.copyWith(color: color, height: 1),
                    ),
                  ),
                ),
                Entry(
                  delay: const Duration(milliseconds: 800),
                  duration: const Duration(milliseconds: 1800),
                  yOffset: 10,
                  child: CustomPaint(
                    painter: MyPainter(),
                    child: Container(
                      width: widget.maxWidth * 0.45,
                      height: 73,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Entry(
                delay: const Duration(milliseconds: 1000),
                duration: const Duration(milliseconds: 1200),
                yOffset: 10,
                child: SizedBox(
                  width: widget.maxWidth * 0.45,
                  height: (widget.maxWidth * 0.45) / 1.7,
                  child: HomeWidgets().cachedImg(
                    widget.image,
                    fit: BoxFit.fill,
                    noPlaceHolder: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.blue;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      math.pi,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ForumHomeListItem2 extends StatelessWidget {
  final double w1p;
  final double h1p;
  final int index;
  final PublicForums pf;
  const ForumHomeListItem2({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.index,
    required this.pf,
  });

  @override
  Widget build(BuildContext context) {
    String name = '${pf.fullName}';
    name = name.length > 20
        ? "${name.substring(0, 14)}...${name.substring(name.length - 5, name.length)}"
        : name;

    // String age = 'pf.';
    // String place = 'pf.';
    String date = pf.forumCreatedDate != null
        ? getIt<StateManager>().convertStringDateToyMMMMd(pf.forumCreatedDate!)
        : "";
    // String title = pf.title ?? "";
    String image = pf.userImage ?? "";
    String subtitle = pf.description ?? "";
    int count = pf.responsesCount ?? 0;

    return Container(
      // height: 150,
      width: w1p * 90,
      margin: const EdgeInsets.only(top: 10, right: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pf.title!,
            style: t700_18.copyWith(color: clr2D2D2D),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          verticalSpace(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //for image
              Container(
                // height: h1p * 8,
                margin: const EdgeInsets.only(top: 8),
                width: w1p * 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Image.network(
                  // fit: widget.fit,
                  '${StringConstants.baseUrl}$image',
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/images/forum-person-placeholder.png",
                    );
                  },
                  loadingBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/images/forum-person-placeholder.png",
                    );
                  },
                  // placeholder: (context, url) => Image.asset(
                  //     "assets/images/forum-person-placeholder.png"),
                  // errorWidget: (context, url, error) => Image.asset(
                  //     "assets/images/forum-person-placeholder.png")),
                ),
              ),
              horizontalSpace(10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getIt<StateManager>().capitalizeFirstLetter(name),
                    style: t400_16.copyWith(color: clr2D2D2D),
                  ),
                  Text(date, style: t400_14.copyWith(color: clr868686)),
                ],
              ),
            ],
          ),
          verticalSpace(10),
          SizedBox(
            height: 80,
            child: Text(
              subtitle,
              style: t400_14.copyWith(color: clr2D2D2D),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          verticalSpace(10),
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xffF2F2F2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.cloud, color: Color(0xff417CB0)),
                horizontalSpace(10),
                Text(
                  "$count ${AppLocalizations.of(context)!.answers}",
                  style: t400_14.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // return Padding(
    //   padding: EdgeInsets.only(left: index == 0 ? w1p * 4 : 0, right: 8),
    //   child: Stack(
    //     children: [
    //       ClipRRect(
    //         borderRadius: BorderRadius.circular(10),
    //         child: Container(
    //           width: w1p * 80,
    //           margin:
    //               const EdgeInsets.only(top: 15, bottom: 8, right: 5, left: 15),
    //           decoration: BoxDecoration(
    //               boxShadow: [
    //                 boxShadow8,
    //                 boxShadow8b,
    //               ],
    //               borderRadius: BorderRadius.circular(8),
    //               color: const Color(0xffFBFBFB)),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.symmetric(
    //                     horizontal: 10.0, vertical: 8),
    //                 child: Row(
    //                   // crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     horizontalSpace(8),
    //                     Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         verticalSpace(8),
    //                         Text(
    //                           getIt<StateManager>().capitalizeFirstLetter(name),
    //                           style: t400_16.copyWith(color: clr2D2D2D),
    //                         ),
    //                         Text(
    //                           date,
    //                           style: t400_14.copyWith(color: clr868686),
    //                         )

    //                         // Text("$age, $place",style: TextStyles.textStyle78,),
    //                       ],
    //                     ),
    //                     // Spacer(),
    //                     // Text(date,style: TextStyles.textStyle78b,)
    //                   ],
    //                 ),
    //               ),
    //               // verticalSpace(2),
    //               SizedBox(
    //                   height: 120,
    //                   child: Padding(
    //                     padding: const EdgeInsets.symmetric(
    //                         horizontal: 18.0, vertical: 8),
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Text(
    //                           title,
    //                           style: t500_14.copyWith(color: clr2D2D2D),
    //                           maxLines: 3,
    //                           overflow: TextOverflow.ellipsis,
    //                         ),
    //                         Text(
    //                           subtitle,
    //                           style: t400_14.copyWith(color: clr2D2D2D),
    //                           maxLines: 3,
    //                           overflow: TextOverflow.ellipsis,
    //                         ),
    //                       ],
    //                     ),
    //                   )),
    //               Padding(
    //                 padding: const EdgeInsets.all(4),
    //                 child: Container(
    //                   decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(10),
    //                       color: const Color(0xffE9E9E9)),
    //                   width: w1p * 80,
    //                   child: Padding(
    //                     padding: EdgeInsets.symmetric(
    //                         horizontal: w1p * 5, vertical: 12),
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         Text(
    //                           "$count ${AppLocalizations.of(context)!.answers}",
    //                           style: t400_14.copyWith(color: clr2D2D2D),
    //                         ),
    //                         SizedBox(
    //                             height: 18,
    //                             child: SvgPicture.asset(
    //                                 "assets/images/forward-arrow.svg")),
    //                         // Icon(Icons.navigate_next_outlined)
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //         top: 0,
    //         left: 0,
    //         child: Container(
    //           decoration:
    //               BoxDecoration(color: clrFE9297, shape: BoxShape.circle),
    //           child: Padding(
    //             padding: const EdgeInsets.all(3.0),
    //             child: ClipRRect(
    //               borderRadius: BorderRadius.circular(100),
    //               child: SizedBox(
    //                   height: 30,
    //                   width: 30,
    //                   child: CachedNetworkImage(
    //                       fit: BoxFit.cover,
    //                       // fit: widget.fit,
    //                       imageUrl: '${StringConstants.baseUrl}$image',
    //                       placeholder: (context, url) => Image.asset(
    //                           "assets/images/forum-person-placeholder.png"),
    //                       errorWidget: (context, url, error) => Image.asset(
    //                           "assets/images/forum-person-placeholder.png"))),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class AppoinmentItemBox extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String img;
  final String date;
  final int? docId;
  final String? name;
  final String? appoinmentId;
  final String? bookingType;
  final int bookingId;
  final String? type;
  final String? sheduledTime;
  final bool? isPsychology;
  final DateTime? startTime;
  final DateTime? endTime;
  final UpcomingAppointments appoinment;

  const AppoinmentItemBox({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.img,
    required this.date,
    required this.appoinment,
    this.docId,
    required this.bookingId,
    required this.bookingType,
    required this.appoinmentId,
    required this.startTime,
    required this.endTime,
    this.name,
    this.sheduledTime,
    this.isPsychology,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    DateTime nw = DateTime.now();
    bool isSameDay =
        nw.year == startTime?.year &&
        nw.month == startTime?.month &&
        nw.day == startTime?.day;

    // bool isCallWaiting = docId == null;
    // bool isBookedOnline = docId != null;
    // bool isBookedOffline = docId != null && bookingType == "Offline";

    return Container(
      height: 200,
      // width: double.maxFinite,
      margin: EdgeInsets.only(
        left: w1p * 4,
        right: w1p * 4,
        bottom: h1p,
        top: h1p,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [boxShadow7],
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/appointment-card-bg.png"),
        ),
      ),

      // vertical: h1p*0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(containerRadius / 2),
        child: Stack(
          children: [
            docId != null
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 18.0, left: w1p * 40),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          containerRadius / 2,
                        ),
                        child: SizedBox(
                          height: h1p * 40,
                          width: w1p * 40,
                          child: HomeWidgets().cachedImg(
                            img,
                            fit: BoxFit.cover,
                            placeholderImage:
                                "assets/images/doctor-placeholder.png",
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            Container(
              padding: const EdgeInsets.all(10),
              child: docId != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            getIt<StateManager>().capitalizeFirstLetter(
                              name ?? "",
                            ),
                            style: t700_18.copyWith(color: clr2D2D2D),
                            maxLines: 2,
                          ),
                          Text(
                            type ?? "",
                            style: t400_14.copyWith(color: clr2D2D2D),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ),
            docId == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      verticalSpace(8),
                      SizedBox(
                        // width:50,
                        height: 50,
                        child: Image.asset(
                          "assets/images/call-waiting-icon.png",
                        ),
                      ),
                      verticalSpace(8),
                      Container(
                        width: 150,
                        height: 28,
                        decoration: BoxDecoration(
                          color: clrEDEDED.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Call is on waiting...",
                            style: t400_14.copyWith(color: clr2D2D2D),
                          ),
                        ),
                      ),
                      verticalSpace(8),
                      // Container(margin: EdgeInsets.all(8),
                      //     height:70,
                      //     width:70,
                      //     child: Lottie.asset('assets/images/doc-search.json'),
                      // ),
                      HeartBeatLoader(
                        beatColor: Colours.primaryblue,
                        width: w1p * 100,
                        height: 50,
                      ),
                    ],
                  )
                : const SizedBox(),
            Positioned(
              bottom: 12,
              left: 12,
              child:
                  startTime != null &&
                      DateTime.now().isAfter(startTime!) &&
                      docId != null &&
                      bookingType != "Offline"
                  ? Row(
                      children: [
                        InkWell(
                          onTap: () {
                            getIt<BookingManager>().sendConsultedStatus(
                              bookingId,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatPage(
                                  docId: docId,
                                  appId: appoinmentId!,
                                  isCallAvailable: true,
                                  bookId: bookingId,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 45,
                            width: w1p * 50,
                            decoration: BoxDecoration(
                              boxShadow: [boxShadow3],
                              borderRadius: BorderRadius.circular(7),
                              color: clr00C165,
                            ),
                            child: Center(
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.consultNow,
                                  style: t500_18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        horizontalSpace(2),
                        InkWell(
                          onTap: () {
                            getIt<BookingManager>().sendConsultedStatus(
                              bookingId,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatPage(
                                  docId: docId,
                                  appId: appoinmentId!,
                                  isCallAvailable: true,
                                  bookId: bookingId,
                                  isDirectToCall: true,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              boxShadow: [boxShadow3],
                              borderRadius: BorderRadius.circular(7),
                              color: clr00C165,
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset(
                                  "assets/images/video-icon.png",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : docId != null
                  ? SizedBox(
                      width: w1p * 80,
                      child: Row(
                        children: [
                          // ignore: avoid_unnecessary_containers
                          Container(
                            height: 50,
                            width: w1p * 70,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [boxShadow7],
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: pad(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF2F2F2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: 44,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Image.asset(
                                          "assets/images/appointment-clock.png",
                                          color: isPsychology == true
                                              ? clrFA8E53
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                  horizontalSpace(4),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 10.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              date,
                                              style: t400_14.copyWith(
                                                color: clr858585,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            // crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                sheduledTime ?? "",
                                                style: t500_14.copyWith(
                                                  color: clr2D2D2D,
                                                ),
                                              ),
                                              if (isSameDay == true &&
                                                  startTime != null) ...[
                                                // horizontalSpace(8),
                                                AppoinmentTimerText(
                                                  fn: () {
                                                    getIt<HomeManager>()
                                                        .getUpcomingAppointments(
                                                          isRefresh: true,
                                                        );
                                                  },
                                                  consultStartTime: startTime!,
                                                  type: 2,
                                                ),
                                              ],
                                              // : const SizedBox()
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorsNearbyBox extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String? name;
  final String? type;
  final String img;
  final String? ratingAndReviews;
  const DoctorsNearbyBox({
    super.key,
    required this.h1p,
    required this.w1p,
    this.name,
    this.ratingAndReviews,
    required this.img,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    var grad3 = const RadialGradient(
      colors: [Color(0xffFFFFFF), Color(0xffCBCBCB)],
    );

    return Container(
      decoration: BoxDecoration(
        gradient: linearGrad3,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          pad(
            horizontal: w1p * 3,
            vertical: h1p,
            child: Row(
              children: [
                // Container(
                //
                //   height:h1p*12,
                //   width:h1p*12,
                //   decoration: BoxDecoration(
                //     // border: Border.,
                //       image:DecorationImage(image: AssetImage("assets/images/home_icons/temp-peterjames.png"),fit: BoxFit.cover),borderRadius: BorderRadius.circular(containerRadius)),),
                ClipRRect(
                  borderRadius: BorderRadius.circular(containerRadius),
                  child: SizedBox(
                    height: h1p * 12,
                    width: h1p * 12,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      // fit: widget.fit,
                      imageUrl: StringConstants.baseUrl + img,
                      placeholder: (context, url) => Image.asset(
                        "assets/images/forum-person-placeholder.png",
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/forum-person-placeholder.png",
                      ),
                    ),
                  ),
                ),
                horizontalSpace(w1p * 1.5),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name ?? "",
                      style: t700_16.copyWith(color: clr444444, height: 1),
                    ),
                    Text('$type', style: t500_14.copyWith(color: clr444444)),
                    // Text('$experience' ,style: TextStyles.textStyle18,),
                    // Row(
                    //     children: [
                    //       SizedBox(height: 15,width: 15,child: Image.asset("assets/images/home_icons/star-rating.png")),
                    //       horizontalSpace(w1p),
                    //       Text(ratingAndReviews??"",style: TextStyles.textStyle19,),
                    //     ],
                    //   ),
                    verticalSpace(h1p * 1),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colours.grad1, Colours.primaryblue],
                        ),
                        borderRadius: BorderRadius.circular(containerRadius),
                      ),
                      child: pad(
                        horizontal: w1p * 3,
                        vertical: w1p * 1,
                        child: Text(
                          AppLocalizations.of(context)!.bookNow,
                          style: t500_14.copyWith(height: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: false == true
                ? GestureDetector(
                    onTap: () {
                      // openMap(double.parse(doc.clinicLatitude!),double.parse(doc.clinicLongitude!));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: grad3,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            "assets/images/home_icons/round-location.png",
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class OffersCard extends StatelessWidget {
  final double w1p;
  final double h1p;
  final BannerList banner;

  const OffersCard({
    super.key,
    required this.h1p,
    required this.banner,
    required this.w1p,
    // required this.img,
    // required this.img,
    // required this.onTap,
    // this.txt,
  });

  @override
  Widget build(BuildContext context) {
    void handleSpeciality(BuildContext context, BannerList banner) {
      if (banner.bookingType == "Online") {
        // getIt<BookingManager>().onlineBookingRedirectionFn(
        //   specialityId: banner.redirectionId!,
        //   categoryId: null,
        //   specialityTitle: "",
        //   context: context,
        // );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CheckIfDoctorAvailableScreen(
              specialityId: banner.redirectionId!,
              categoryId: null,
              specialityTitle: "",
            ),
          ),
        );
      } else if (banner.bookingType == "Scheduled Online") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FindDoctorsListScreen(
              specialityId: banner.redirectionId!,
              subSpecialityIdForPsychology: null,
            ),
          ),
        );
      }
    }

    return GestureDetector(
      onTap: () {
        // print(banner.bookingType);
        // print("banner.bookingType");
        // print(banner.redirectionType);

        // print("banner.redirectionType");
        // print(banner.redirectionModule);
        // print("banner.redirectionModule");

        if (banner.redirectionType == "Click action") {
          if (banner.redirectionModule == "Speciality") {
            handleSpeciality(context, banner);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BannerDetailsScreen(banner: banner),
              ),
            );
          }
        } else if (banner.redirectionType == "Banner detail") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BannerDetailsScreen(banner: banner),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BannerDetailsScreen(banner: banner),
            ),
          );
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Container(
            // height: 160,width:200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(containerRadius / 2),

              // image: DecorationImage(fit:BoxFit.cover,image: NetworkImage('${StringConstants.imgBaseUrl}${banner.image??""}'))
            ),

            child: HomeWidgets().cachedImg(
              banner.image ?? '',
              noPlaceHolder: true,
              placeholderImage: "assets/images/banner_logo.png",
            ),
          ),
        ),
      ),
    );
  }
}

class ForumListItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final bool isVetinary;
  final int index;
  final PublicForums pf;
  const ForumListItem({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.index,
    required this.isVetinary,
    required this.pf,
  });

  @override
  Widget build(BuildContext context) {
    String name = '${pf.fullName}';
    // String age = 'pf.';
    // String place = 'pf.';
    String date = pf.forumCreatedDate != null
        ? getIt<StateManager>().convertStringDateToyMMMMd(pf.forumCreatedDate!)
        : "";
    String title = pf.title ?? "";
    String image = pf.userImage ?? "";
    String subtitle = pf.description ?? "";
    int count = pf.responsesCount ?? 0;

    return Container(
      width: w1p * 75,
      margin: EdgeInsets.only(
        top: h1p,
        bottom: h1p,
        right: 12,
        left: index == 0 ? w1p * 5 : 0,
      ),
      decoration: BoxDecoration(
        boxShadow: isVetinary ? null : [boxShadow8, boxShadow8b],
        borderRadius: BorderRadius.circular(8),
        color: isVetinary ? const Color(0xffffffff) : const Color(0xffFBFBFB),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: SizedBox(
                    height: 45,
                    width: 45,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      // fit: widget.fit,
                      imageUrl: '${StringConstants.baseUrl}$image',
                      placeholder: (context, url) => Image.asset(
                        "assets/images/forum-person-placeholder.png",
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/forum-person-placeholder.png",
                      ),
                    ),
                  ),
                ),

                horizontalSpace(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getIt<StateManager>().capitalizeFirstLetter(name),
                      style: TextStyles.textStyle77,
                    ),
                    Text(date, style: TextStyles.textStyle78b),
                    // Text("$age, $place",style: TextStyles.textStyle78,),
                  ],
                ),
                // Spacer(),
                // Text(date,style: TextStyles.textStyle78b,)
              ],
            ),
          ),
          verticalSpace(2),
          SizedBox(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.textStyle79,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyles.textStyle80,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Color(0xffE9E9E9)),
            width: w1p * 75,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w1p * 5, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$count ${AppLocalizations.of(context)!.answers}",
                    style: TextStyles.textStyle81,
                  ),
                  isVetinary
                      ? Text(
                          AppLocalizations.of(context)!.reply,
                          style: TextStyles.textStyle81c.copyWith(
                            color: clr444444,
                          ),
                        )
                      : SizedBox(
                          height: 18,
                          child: SvgPicture.asset(
                            "assets/images/forward-arrow.svg",
                          ),
                        ),
                  // Icon(Icons.navigate_next_outlined)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyLocationWidget extends StatelessWidget {
  const MyLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/images/home_icons/location.svg",
          colorFilter: const ColorFilter.mode(
            Colours.primaryblue,
            BlendMode.srcIn,
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.useCurrentLocation,
            style: t500_14.copyWith(color: clr444444),
          ),
        ),
      ],
    );
  }
}

class CustomFabMenu extends StatefulWidget {
  const CustomFabMenu({super.key});

  @override
  State<CustomFabMenu> createState() => _CustomFabMenuState();
}

class _CustomFabMenuState extends State<CustomFabMenu>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
      _isOpen ? _controller.forward() : _controller.reverse();
    });
  }

  /// Main pill-shaped "Pro" button
  Widget _buildMainButton() {
    return GestureDetector(
      onTap: _toggleMenu,
      child: Container(
        padding: const EdgeInsets.all(04),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [boxShadow12],
          gradient: const LinearGradient(
            colors: [
              Color(0xfff59099),
              Color(0xff8467a6),
              Color(0xff007bff),
              Color(0xff00d4ff),
              Color(0xffff5600),
              Color(0xffffbb00),
            ],
          ),
        ),
        child: Container(
          // color: clrA8A8A8,
          height: 40,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.white,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pad(
                  horizontal: 4,
                  child: Image.asset(
                    'assets/images/dq-logo-1.5x.png',
                    height: 24,
                    width: 24,
                  ),
                ),
                Text('Pro', style: t700_16.copyWith(color: Colors.black)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // 🔹 Overlay when open
        if (_isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleMenu,
              child: Container(color: Colors.black54),
            ),
          ),

        // 🔹 Expanding menu items
        Positioned(
          bottom: 70,
          right: 16,
          child: SizeTransition(
            sizeFactor: CurvedAnimation(
              parent: _controller,
              curve: Curves.easeInOut,
            ),
            // axisAlignment: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                tabContainer(
                  title: 'Consultation',
                  subTitle: 'Expert medical advice',
                  image: 'assets/images/tab_consult_img.png',
                  index: 0,
                ),
                tabContainer(
                  title: 'Counseling',
                  subTitle: 'Mental health support',
                  image: 'assets/images/tab_counselling_img.png',
                  index: 1,
                ),
                // tabContainer(title: 'Pet Care', icon: Icons.pets_rounded, index: 4),
                tabContainer(
                  title: 'Ayurvedic',
                  subTitle: 'Natural healing therapy',
                  image: 'assets/images/tab_ayurvedic_img.png',
                  index: 2,
                ),
              ],
            ),
          ),
        ),

        // 🔹 Main "Pro" button
        Positioned(
          bottom: 16,
          right: 16,
          child: SizedBox(width: 90, height: 50, child: _buildMainButton()),
        ),
      ],
    );
  }

  tabContainer({
    required String title,
    required String subTitle,
    required String image,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            reverseTransitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                ProHomeTab(indexFromHome: index),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0); // start from right
                  const end = Offset.zero; // end at normal position
                  const curve = Curves.easeInOut;

                  final tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  final offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        width: 250,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(image),
            ),
            horizontalSpace(10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: t700_18.copyWith(
                    color: Colors.black,
                    letterSpacing: 0.9,
                  ),
                ),
                Text(subTitle, style: t400_14.copyWith(color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HealthNewsCarousel extends StatefulWidget {
  final List<News> items;

  const HealthNewsCarousel({super.key, required this.items});

  @override
  State<HealthNewsCarousel> createState() => _HealthNewsCarouselState();
}

class _HealthNewsCarouselState extends State<HealthNewsCarousel>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int currentIndex = 0;
  // late AnimationController _controller;

  // late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7);
    // _controller = AnimationController(
    //     duration: const Duration(milliseconds: 300), vsync: this);
    // _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  // void _onSwipeLeft() {
  //   setState(() {
  //     currentIndex = (currentIndex + 1) % widget.items.length;
  //   });
  //   _controller.forward(from: 0);
  // }

  // void _onSwipeRight() {
  //   setState(() {
  //     currentIndex =
  //         (currentIndex - 1 + widget.items.length) % widget.items.length;
  //   });
  //   _controller.forward(from: 0);
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double currentPage = 0;
              if (_pageController.hasClients &&
                  _pageController.position.haveDimensions) {
                currentPage =
                    _pageController.page ??
                    _pageController.initialPage.toDouble();
              }

              double delta = index - currentPage;
              double rotateY = delta * 0.2; // radians, for visible lean
              double scale = 1 - (delta.abs() * 0.2); // optional scale effect

              // Clamp rotation
              rotateY = rotateY.clamp(-1.0, 1.0);

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateZ(rotateY)
                  ..scale(scale),
                child: StepCard(
                  index: index + 1,
                  newsItem: widget.items[index],
                ),
              );
            },
          );
        },
      ),
    );
    // return GestureDetector(
    //   onHorizontalDragEnd: (details) {
    //     if (details.primaryVelocity == null) return;

    //     if (details.primaryVelocity! < 0) {
    //       _onSwipeLeft();
    //     } else if (details.primaryVelocity! > 0) {
    //       _onSwipeRight();
    //     }
    //   },
    //   onTap: () {
    //     Navigator.pushNamed(
    //       context,
    //       RouteNames.newsAndTips,
    //       arguments: NewsAndTipsScreenArguments(
    //         type: "News",
    //         news: widget.items[currentIndex],
    //       ),
    //     );
    //   },
    //   child: Container(
    //     height: 400,
    //     margin: const EdgeInsets.symmetric(horizontal: 20),
    //     child: AnimatedBuilder(
    //       animation: _animation,
    //       builder: (context, child) {
    //         return Stack(
    //           alignment: Alignment.center,
    //           children: List.generate(3, (layerIndex) {
    //             int itemIndex =
    //                 (currentIndex + layerIndex) % widget.items.length;
    //             final newsItem = widget.items[itemIndex];

    //             double scale =
    //                 layerIndex == 0 ? 1 : (layerIndex == 1 ? 0.7 : 0.7);
    //             double rotation =
    //                 layerIndex == 0 ? 0 : (layerIndex == 1 ? -5 : 5);
    //             double horizontalOffset =
    //                 layerIndex == 0 ? 0 : (layerIndex == 1 ? -70 : 70);

    //             double verticalOffset = layerIndex == 0 ? -5 : 0;

    //             return Positioned(
    //               top: layerIndex * 10.0,
    //               child: Transform.translate(
    //                 offset: Offset(horizontalOffset, verticalOffset),
    //                 child: Transform.scale(
    //                   scale: scale,
    //                   child: Transform.rotate(
    //                     angle: rotation * pi / 180,
    //                     child: Card(
    //                       color: Colors.white,
    //                       shape: RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.circular(16)),
    //                       elevation: layerIndex == 0 ? 8 : 4,
    //                       child: SizedBox(
    //                         width: 300,
    //                         height: 380,
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Expanded(
    //                               flex: 2,
    //                               child: Stack(
    //                                 alignment: Alignment.bottomLeft,
    //                                 children: [
    //                                   Hero(
    //                                     tag: newsItem.subtitle!,
    //                                     child: ClipRRect(
    //                                       borderRadius:
    //                                           const BorderRadius.vertical(
    //                                               top: Radius.circular(16)),
    //                                       child: Image.network(
    //                                         "${StringConstants.baseUrl}${newsItem.image!}",
    //                                         width: double.infinity,
    //                                         height: 550,
    //                                         fit: BoxFit.cover,
    //                                       ),
    //                                     ),
    //                                   ),
    //                                   Container(
    //                                     margin: const EdgeInsets.all(12),
    //                                     padding: const EdgeInsets.all(8),
    //                                     decoration: BoxDecoration(
    //                                         color: Colors.black54,
    //                                         borderRadius:
    //                                             BorderRadius.circular(10)),
    //                                     child: Column(
    //                                       crossAxisAlignment:
    //                                           CrossAxisAlignment.start,
    //                                       mainAxisSize: MainAxisSize.min,
    //                                       children: [
    //                                         Text(
    //                                           newsItem.title!,
    //                                           style: t600_14,
    //                                         ),
    //                                         if (newsItem.publishedDate != null)
    //                                           Text(
    //                                             newsItem.publishedDate!,
    //                                             style: t400_12,
    //                                           ),
    //                                       ],
    //                                     ),
    //                                   )
    //                                 ],
    //                               ),
    //                             ),
    //                             Expanded(
    //                               flex: 1,
    //                               child: Padding(
    //                                 padding: const EdgeInsets.all(12.0),
    //                                 child: Text(
    //                                   newsItem.description!,
    //                                   maxLines: 4,
    //                                   overflow: TextOverflow.ellipsis,
    //                                   style: t400_14.copyWith(
    //                                       color: Colors.black, height: 1.5),
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             );
    //           }).reversed.toList(),
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}

class DashboardWidgets extends StatefulWidget {
  final double maxHeight;
  final double maxWidth;

  const DashboardWidgets({
    super.key,
    required this.maxHeight,
    required this.maxWidth,
  });

  @override
  State<DashboardWidgets> createState() => _DashboardWidgetsState();
}

class _DashboardWidgetsState extends State<DashboardWidgets>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int currentIndex = 0;
  final Duration singleAnimationDuration = const Duration(milliseconds: 1000);

  final List<Widget> firstColumnItems = [];
  final List<Widget> secondColumnItems = [];
  void startAnimationLoop() async {
    while (mounted) {
      // Animate up
      await _controller.forward();

      // Animate back down
      await _controller.reverse();

      // Soft delay before moving to next widget
      await Future.delayed(const Duration(milliseconds: 300));

      // Move to next widget
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          currentIndex = (currentIndex + 1) % totalItemCount;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: singleAnimationDuration,
    );

    _animation = Tween<double>(
      begin: 0,
      end: -5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start the smooth animation loop
    startAnimationLoop();

    // Initialize column items
    firstColumnItems.addAll([
      buildConsultContainerBig(
        title1: "Book Your",
        title2: "Appointment",
        subTitleBlinking: false,
        color: clrCE6F7D,
        bgColor: const Color(0xffE2A5A5),
        subtitle1: "More Than",
        subtitle2: "2500+\nDoctors",
        image: "assets/images/consultC-img-appoinment.png",
        bg: "assets/images/consultC-bg-appointment.png",
        gradientColors: const [Color(0xffCF707E), Color(0xffF68B93)],
        onClick: () async {
          await Navigator.of(context).push(navigateOnlineCategories(true));
        },
      ),
      buildConsultContainerSmall(
        title1: "Instant Online",
        title2: "Counselling",
        color: clrFA8E53,
        bgColor: const Color(0xffFC8551),
        subtitle1: "Available",
        subtitle2: "24x7",
        image: "assets/images/consultC-img-councelling.png",
        bg: "assets/images/consultC-bg-councelling.png",
        gradientColors: const [
          Color(0xffF37E45),
          Color(0xffF99354),
          Color(0xffF79C55),
        ],
        onClick: () {
          Navigator.of(context).push(navigateOnlineCouncelling());
        },
      ),
    ]);

    secondColumnItems.addAll([
      buildConsultContainerSmall(
        title1: "Online Pet",
        title2: "Consulting",
        color: clr417FB1,
        bgColor: const Color(0xff7EB8E8),
        subtitle1: "Exclusive",
        subtitle2: "Offers",
        image: "assets/images/consultC-img-pet.png",
        bg: "assets/images/consultC-bg-pet.png",
        gradientColors: const [
          Color(0xff609CCE),
          Color(0xff689CC7),
          Color(0xff4D7799),
        ],
        onClick: () {
          showComingSoonDialog(context);
        },
      ),
      buildConsultContainerBig(
        title1: "Consult",
        title2: "Now",
        subTitleBlinking: true,
        color: clr5758AC,
        bgColor: const Color(0xff9E98D3),
        subtitle1: "Connect\nwith in",
        subtitle2: "30 sec",
        image: "assets/images/consultC-img-live.png",
        bg: "assets/images/consultC-bg-live.png",
        gradientColors: const [Color(0xff8066A6), Color(0xff685DA9)],
        onClick: () {
          Navigator.of(context).push(navigateOnlineCategories(false));
        },
      ),
    ]);
  }

  int get totalItemCount => firstColumnItems.length + secondColumnItems.length;

  Widget buildAnimatedItem(int globalIndex, Widget child) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, childWidget) {
        final offsetY = (currentIndex == globalIndex) ? _animation.value : 0.0;
        return Transform.translate(
          offset: Offset(0, offsetY),
          child: childWidget,
        );
      },
      child: child,
    );
  }

  Widget buildConsultContainerBig({
    required String title1,
    required String title2,
    required Color color,
    required Color bgColor,
    required String subtitle1,
    required String subtitle2,
    required String image,
    required String bg,
    required List<Color> gradientColors,
    required VoidCallback onClick,
    required bool subTitleBlinking,
  }) {
    return ConsultContainerBig(
      title1: title1,
      title2: title2,
      color: color,
      bgColor: bgColor,
      subtitle1: subtitle1,
      subtitle2: subtitle2,
      maxWidth: widget.maxWidth,
      maxHeight: widget.maxHeight,
      image: image,
      bg: bg,
      alignment: Alignment.center,
      gradinetColor: gradientColors,
      onClick: onClick,
      subTitleBlinking: subTitleBlinking,
    );
  }

  Widget buildConsultContainerSmall({
    required String title1,
    required String title2,
    required Color color,
    required Color bgColor,
    required String subtitle1,
    required String subtitle2,
    required String image,
    required String bg,
    required List<Color> gradientColors,
    required VoidCallback onClick,
  }) {
    return ConsultContainerSmall(
      title1: title1,
      title2: title2,
      color: color,
      bgColor: bgColor,
      subtitle1: subtitle1,
      subtitle2: subtitle2,
      maxWidth: widget.maxWidth,
      maxHeight: widget.maxHeight,
      image: image,
      bg: bg,
      alignment: Alignment.center,
      gradientColors: gradientColors,
      onClick: onClick,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              firstColumnItems.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: buildAnimatedItem(index, firstColumnItems[index]),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              secondColumnItems.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: buildAnimatedItem(
                  index + firstColumnItems.length,
                  secondColumnItems[index],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StepCard extends StatelessWidget {
  final News newsItem;
  final int index;

  const StepCard({super.key, required this.newsItem, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteNames.newsAndTips,
          arguments: NewsAndTipsScreenArguments(type: "News", news: newsItem),
        );
      },
      child: Container(
        // height: 400,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            // bottomLeft: Radius.circular(16),
            // bottomRight: Radius.circular(16),
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Hero(
                    tag: newsItem.subtitle!,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        "${StringConstants.baseUrl}${newsItem.image!}",
                        width: double.infinity,
                        height: 550,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(newsItem.title!, style: t600_14),
                        if (newsItem.publishedDate != null)
                          Text(newsItem.publishedDate!, style: t400_12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                newsItem.description!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: t400_14.copyWith(color: Colors.black, height: 1.5),
              ),
            ),
          ],
        ),
      ),
      // child: Padding(
      //   padding: const EdgeInsets.all(4.0),
      //   child: Container(
      //     margin: const EdgeInsets.all(4),
      //     height: 250,
      //     decoration: BoxDecoration(
      //         boxShadow: [
      //           BoxShadow(
      //               color: clr717171.withOpacity(0.1),
      //               offset: const Offset(0, 0),
      //               spreadRadius: 4,
      //               blurRadius: 4)
      //         ],
      //         color: const Color(0xffFFDCC0),
      //         borderRadius: BorderRadius.circular(13)),
      //     // height:144,
      //     width: 200,
      //     child: Stack(
      //       alignment: Alignment.topCenter,
      //       // fit: StackFit.expand,
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.only(top: 30.0),
      //           child: Column(
      //             children: [
      //               SizedBox(
      //                   // color: Colors.amber,
      //                   // width: 150,
      //                   height: 140,
      //                   child: Image.network(
      //                       "${StringConstants.baseUrl}${newsItem.image!}")),
      //               SizedBox(
      //                 height: 60,
      //                 child: Padding(
      //                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //                   child: Text(
      //                     newsItem.title!,
      //                     style:
      //                         t400_14.copyWith(color: clr2D2D2D, height: 1.1),
      //                     textAlign: TextAlign.center,
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         Align(
      //           alignment: Alignment.topCenter,
      //           child: Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: Text(
      //               index.toString(),
      //               style: t700_42.copyWith(
      //                   color: const Color(0xff9C6A42), height: 1),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
