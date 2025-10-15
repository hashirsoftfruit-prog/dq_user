// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:dotted_border/dotted_border.dart';
import 'package:dqapp/controller/managers/state_manager.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';

import 'dart:async';

import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/core/booking_validation_models.dart';
import '../../theme/constants.dart';
import 'loading_screen.dart';

class BookingSuccessScreen extends StatefulWidget {
  final BookingSaveResponseModel bookingSuccessData;
  final bool? isFree;

  // String appoinmentId;
  // int bookingId;
  const BookingSuccessScreen({
    super.key,
    required this.bookingSuccessData,
    this.isFree,
  });

  @override
  State<BookingSuccessScreen> createState() => BookingSuccessScreenState();
}

class BookingSuccessScreenState extends State<BookingSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.05), // slightly up
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pop(context, 'success');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String bookingID = widget.bookingSuccessData.appointmentId ?? "";
    String orderId = widget.bookingSuccessData.paymentDetails['id'] ?? "";
    double amount = widget.bookingSuccessData.paymentDetails['amount'] ?? "";
    String date = StateManager().convertStringDateToyMMMMd(
      widget.bookingSuccessData.dateTime!,
    );
    String time = StateManager().getTimefromDatetimeString(
      widget.bookingSuccessData.dateTime!,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        // double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        Future<bool> onWillPop() async {
          // Navigator.pop(context, 'success');
          return Future.value(false);
        }

        return Consumer<HomeManager>(
          builder: (context, hMgr, child) {
            return WillPopScope(
              onWillPop: onWillPop,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.white,
                body: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // myLoader(  visibility: true),
                    SizedBox(
                      width: maxWidth,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Entry(
                            scale: 1.3,
                            // angle: 3.1415,
                            delay: const Duration(milliseconds: 0),
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.decelerate,
                            child: HeartBeatLoader(
                              beatColor: Colours.primaryblue,
                              width: w1p * 100,
                              height: 50,
                            ),
                          ),

                          // child: Image.asset('assets/images/pulse-image.png')),
                          // Entry(scale: 0.7,
                          //     // angle: 3.1415,
                          //     delay: const Duration(milliseconds: 0),
                          //     duration: const Duration(milliseconds: 1500),
                          //     curve: Curves.decelerate,
                          //     child: Image.asset('assets/images/book-success.png')),
                          Entry(
                            scale: .1,
                            // yOffset: 10,
                            // angle: 3.1415,
                            delay: const Duration(milliseconds: 10),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.decelerate,
                            child: SizedBox(
                              height: w10p * 4.3,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Image.asset(
                                    'assets/images/book-success2.png',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.isFree == true
                          ? AppLocalizations.of(context)!.bookingSuccess
                          : AppLocalizations.of(context)!.paymentSuccess,
                      style: t500_20.copyWith(color: const Color(0xff1976D2)),
                      textAlign: TextAlign.center,
                    ),
                    verticalSpace(24),
                    Entry(
                      opacity: 0,
                      yOffset: 10,
                      // angle: 3.1415,
                      delay: const Duration(milliseconds: 1000),
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.decelerate,

                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: w1p * 5),
                        child: DottedBorder(
                          options: const RectDottedBorderOptions(
                            color: Colors.grey,
                            strokeWidth: 1,
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Booking Details",
                                  style: t500_14.copyWith(color: clr2D2D2D),
                                ),
                                verticalSpace(8),
                                Text(
                                  "Booking Id : $bookingID",
                                  style: t400_14.copyWith(color: clr2D2D2D),
                                ),
                                Text(
                                  "Order Id : $orderId",
                                  style: t400_14.copyWith(color: clr2D2D2D),
                                ),
                                verticalSpace(8),
                                Text(
                                  "Amount : ₹$amount",
                                  style: t700_16.copyWith(color: clr2D2D2D),
                                ),
                                verticalSpace(4),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: Image.asset(
                                        widget
                                                    .bookingSuccessData
                                                    .clinicAddress !=
                                                null
                                            ? "assets/images/in-clinic-icon-green.png"
                                            : "assets/images/video-call-icon.png",
                                      ),
                                    ),
                                    horizontalSpace(4),
                                    Text(
                                      widget.bookingSuccessData.clinicAddress !=
                                              null
                                          ? "In-clinic consultation"
                                          : "Online consultation",
                                      style: t400_14.copyWith(color: clr2D2D2D),
                                    ),
                                  ],
                                ),
                                verticalSpace(4),
                                widget.bookingSuccessData.doctorName != null
                                    ? Container(
                                        width: maxWidth,
                                        decoration: BoxDecoration(
                                          color: clrF8F8F8,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Doctor Details",
                                                    style: t400_14.copyWith(
                                                      color: clr2D2D2D,
                                                    ),
                                                  ),
                                                  Text(
                                                    widget
                                                            .bookingSuccessData
                                                            .doctorName ??
                                                        "",
                                                    style: t700_16.copyWith(
                                                      color: clr2D2D2D,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        maxWidth -
                                                        w10p * 3 -
                                                        50,
                                                    child: Text(
                                                      widget
                                                              .bookingSuccessData
                                                              .doctorProfessionalQualifications ??
                                                          "",
                                                      style: t400_12.copyWith(
                                                        color: clr2D2D2D,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: Image.asset(
                                                    "assets/images/doctor-placeholder.png",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                verticalSpace(8),
                                widget.bookingSuccessData.clinicAddress != null
                                    ? Row(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 16,
                                            child: Image.asset(
                                              "assets/images/location-outline-icon.png",
                                            ),
                                          ),
                                          horizontalSpace(6),
                                          SizedBox(
                                            width: w1p * 55,
                                            child: Text(
                                              widget
                                                      .bookingSuccessData
                                                      .clinicAddress ??
                                                  "",
                                              style: t400_14.copyWith(
                                                color: clr2D2D2D,
                                                height: 1,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                verticalSpace(8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  height: 28,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(23),
                                    color: clrF3F3F3,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 15,
                                        child: Image.asset(
                                          "assets/images/success-screen-calender.png",
                                        ),
                                      ),
                                      horizontalSpace(4),
                                      Text(
                                        date,
                                        style: t400_12.copyWith(
                                          color: clr2D2D2D,
                                        ),
                                      ),
                                      horizontalSpace(12),
                                      SizedBox(
                                        height: 15,
                                        child: Image.asset(
                                          "assets/images/success-screen-clock.png",
                                        ),
                                      ),
                                      horizontalSpace(4),
                                      Text(
                                        time,
                                        style: t400_12.copyWith(
                                          color: clr2D2D2D,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Spacer(),
                    // Entry(
                    //   opacity: 0,
                    //   yOffset: 10,
                    //   // angle: 3.1415,
                    //   delay: const Duration(milliseconds: 2500),
                    //   duration: const Duration(milliseconds: 1000),
                    //   curve: Curves.decelerate,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       Navigator.pop(context, 'success');
                    //     },
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         boxShadow: [boxShadow7b], color: clrFFFFFF,
                    //         borderRadius: BorderRadius.circular(30),
                    //         // border: Border.all(color: clr5A6BE2)
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 18.0),
                    //         child: Text(
                    //           "Continue",
                    //           style: t400_14.copyWith(color: clr5A6BE2),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const Spacer(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
