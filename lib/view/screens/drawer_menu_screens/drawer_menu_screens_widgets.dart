import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../theme/constants.dart';
import '../chat_screen.dart';
import '../home_screen_widgets.dart';
import 'appoinment_detail_screen.dart';

class RecentConsultItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String date;
  final int bookingId;
  final int docId;
  final String name;
  final String type;
  final String sheduledTime;
  final String appoinmentId;
  final bool isFreeFollowUp;
  final String patientname;
  final String doctorImg;
  final DateTime? bookingStartTime;
  final DateTime? bookingEndTime;
  final bool? showsInHome;
  final Function fn;
  const RecentConsultItem({
    super.key,
    required this.w1p,
    required this.h1p,
    required this.docId,
    required this.bookingId,
    required this.sheduledTime,
    required this.type,
    required this.isFreeFollowUp,
    required this.appoinmentId,
    required this.date,
    this.showsInHome,
    required this.doctorImg,
    required this.patientname,
    // required this.isApplicable,
    required this.name,
    required this.fn,
    required this.bookingStartTime,
    required this.bookingEndTime,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookingDetailsScreen(
              bookingId: bookingId,
              isConsulted: true,
              goToChatFn: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatPage(
                      appId: appoinmentId,
                      docId: docId,
                      isCallAvailable: false,
                      bookId: bookingId,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          left: w1p * 4,
          right: w1p * 4,
          bottom: showsInHome == true ? 0 : 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [boxShadow9],
          // color: Color(0xffFBFBFB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            pad(
              horizontal: w1p * 3,
              vertical: showsInHome == true ? 0 : 18,
              child: Row(
                children: [
                  pad(
                    horizontal: w1p * 0,
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: HomeWidgets().cachedImg(
                          doctorImg,
                          fit: BoxFit.cover,
                          placeholderImage:
                              'assets/images/doctor-placeholder.png',
                        ),
                      ),
                    ),
                  ),
                  horizontalSpace(w1p * 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Dr. $name",
                          style: t500_14.copyWith(
                            color: clr2D2D2D,
                            height: 1.1,
                          ),
                          maxLines: 2,
                        ),
                        Text(
                          type,
                          style: t400_12.copyWith(
                            color: clr757575,
                            height: 1.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "$date $sheduledTime",
                          style: t500_12.copyWith(
                            color: clr757575,
                            height: 1.1,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  isFreeFollowUp
                      ? InkWell(
                          onTap: () async {
                            fn();
                          },
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              boxShadow: [boxShadow1],
                              // gradient: linearGrad,
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.white,
                            ),
                            child: pad(
                              vertical: 6,
                              horizontal: 8,
                              child: Text(
                                AppLocalizations.of(context)!.freefollowup,
                                style: t500_12.copyWith(color: clr5A6BE2),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),

            // showsInHome==true?SizedBox(): Divider(color: Colours.lightBlu,)
          ],
        ),
      ),
    );
  }
}

class DocItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String fname;
  final String lname;
  final String img;
  final String type;
  final String currentClinicAddress;
  const DocItem({
    super.key,
    required this.w1p,
    required this.h1p,
    required this.img,
    required this.fname,
    required this.lname,
    required this.type,
    required this.currentClinicAddress,
  });

  @override
  Widget build(BuildContext context) {
    // var grad1 = LinearGradient(colors: [Color(0xff9E74F8),Color(0xff8F5BFE),]);
    // var grad2 = LinearGradient(colors: [Color(0xff4D51C7),Color(0xff2E3192)]);

    return pad(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 75,
            width: 75,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: "${StringConstants.baseUrl}$img",
                placeholder: (context, url) => Image.asset(
                  'assets/images/doctor-placeholder.png',
                  fit: BoxFit.fitHeight,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/doctor-placeholder.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          horizontalSpace(w1p * 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              // mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Dr.$fname $lname',
                  style: t500_16.copyWith(color: clr2D2D2D),
                ),
                // Row(
                //   children: [
                //     Text('$docExperience',style: t500_12.copyWith(color: clr2D2D2D)),
                //   ],
                // ),
                Text(type, style: t400_12.copyWith(color: clr757575)),
                Text(
                  currentClinicAddress,
                  style: t400_12.copyWith(color: clr757575),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClinicBox extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String clinicName;
  // String img;
  // String type;
  final String clinicAddress1;
  final String? lat;
  final String? long;
  const ClinicBox({
    super.key,
    required this.w1p,
    required this.h1p,
    // required this.img,
    required this.clinicName,
    // required this.type,
    required this.clinicAddress1,
    required this.lat,
    required this.long,
  });

  @override
  Widget build(BuildContext context) {
    var grad3 = const RadialGradient(
      colors: [Color(0xffFFFFFF), Color(0xffeeeeee)],
    );

    // var grad1 = const LinearGradient(colors: [
    //   Color(0xff9E74F8),
    //   Color(0xff8F5BFE),
    // ]);
    // var grad2 = const LinearGradient(colors: [Color(0xff4D51C7), Color(0xff2E3192)]);

    return pad(
      child: Column(
        children: [
          Row(
            children: [
              // horizontal: w1p*2.5,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(clinicName, style: t500_16.copyWith(color: clr2D2D2D)),
                    // Row(
                    //   children: [
                    //     Text('$docExperience',style: t500_12.copyWith(color: clr2D2D2D)),
                    //   ],
                    // ),
                    Text(
                      clinicAddress1,
                      style: t400_12.copyWith(color: clr757575),
                    ),
                  ],
                ),
              ),
              lat != null && long != null
                  ? GestureDetector(
                      onTap: () {
                        openMap(double.parse(lat!), double.parse(long!));
                      },
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
                    )
                  : const SizedBox(),
            ],
          ),

          // Divider(),
          // Row(children: [
          //   SizedBox(height: 15,width: 15, child: Image.asset("assets/images/doc-list-icon1.png")),
          //   Text("time",style: TextStyles.textStyle65,),
          // ],),

          // verticalSpace(h1p),
          // Align(
          //     alignment: Alignment.centerLeft,
          //     child: Text(currentClinicAddress,style: TextStyles.textStyle65,)),

          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 5),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: onlineTimeSlot!=null? Container(
          //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),gradient:grad1, ),
          //           child: Padding(
          //             padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 12),
          //             child: Center(child: Text("Book Online",style: TextStyles.textStyle64,)),
          //           ),):SizedBox(),
          //       ),
          //       horizontalSpace(w1p),
          //       Expanded(
          //         child:offlineTimeSlot!=null? Container(
          //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),gradient:grad2, ),
          //           child: Padding(
          //             padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 12),
          //             child: Center(child: Text("Book Clinic",style: TextStyles.textStyle64,)),
          //           ),):SizedBox(),
          //       ),
          //
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class WarningPopUp extends StatelessWidget {
  // double w1p;
  // double h1p;
  final String msg; // String type;
  final String? cancelBtnText;
  final String? proceedBtnText;
  // Function bookOnlineOnClick;
  // Function bookClinicOnClick;
  const WarningPopUp({
    super.key,
    // required this.w1p,
    // required this.h1p,
    required this.msg,
    this.cancelBtnText,
    this.proceedBtnText,
    // required this.type,
    // required this.offlineTimeSlot,
    // required this.currentClinicAddress,
    // required this.bookOnlineOnClick,
    // required this.bookClinicOnClick,
  });

  @override
  Widget build(BuildContext context) {
    // String msg=msg;
    // String msg='Closing this page will interrupt your consultations';

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Message', style: TextStyles.textStyle3c),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(msg, style: t500_14.copyWith(color: clr444444)),

              // verticalSpace(h1p),
              // Text(msg),
            ],
          ),

          // height: h1p*80,
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: clr444444, width: 0.5),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 8,
              ),
              child: Text(
                cancelBtnText ?? AppLocalizations.of(context)!.cancel,
                style: t500_14.copyWith(color: clr444444),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // gradient: linearGrad
            color: Colours.toastRed,
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 8,
              ),
              child: Text(
                proceedBtnText ?? AppLocalizations.of(context)!.proceed,
                style: t500_14,
              ),
            ),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 18.0),
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

Future<void> openMap(double latitude, double longitude) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunchUrl(Uri.parse(googleUrl))) {
    await launchUrl(Uri.parse(googleUrl));
  } else {
    throw 'Could not open the map.';
  }
}
