import 'dart:async';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/home_screen.dart';

import 'package:dqapp/view/theme/text_styles.dart';

import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/core/upcome_appoiments_response_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';

import '../chat_screen.dart';
import '../home_screen_widgets.dart';
import 'appoinment_detail_screen.dart';

class UpcomingAppointmentsScreen extends StatefulWidget {
  const UpcomingAppointmentsScreen({super.key});

  @override
  State<UpcomingAppointmentsScreen> createState() =>
      _UpcomingAppointmentsScreenState();
}

class _UpcomingAppointmentsScreenState
    extends State<UpcomingAppointmentsScreen> {
  final PageController pgVCntrlr = PageController(initialPage: 0);

  @override
  void dispose() {
    getIt<HomeManager>().setAppointmentsTabTitle(null, isDispose: true);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        selectionBox(String e, bool selected) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(containerRadius / 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: w1p * 3,
                    top: h1p,
                    bottom: h1p,
                  ),
                  child: Text(
                    e,
                    style: selected
                        ? t500_14.copyWith(
                            color: Colours.primaryblue,
                            height: 1.1,
                          )
                        : t500_14.copyWith(color: clr757575),
                  ),
                ),
                selected
                    ? Entry(
                        xOffset: -100,
                        // scale: 20,
                        delay: const Duration(milliseconds: 0),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.ease,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colours.primaryblue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          height: 4,
                          width: 30,
                        ),
                      )
                    : Container(height: 2, color: Colors.white, width: 30),
              ],
            ),
          );
        }

        return Consumer<HomeManager>(
          builder: (context, mgr, child) {
            return Scaffold(
              // extendBody: true,
              backgroundColor: Colors.white,
              appBar: getIt<SmallWidgets>().appBarWidget(
                title: AppLocalizations.of(context)!.appoinments,
                height: h10p,
                width: w10p,
                fn: () {
                  Navigator.pop(context);
                },
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  // await getIt<HomeManager>().getUpcomingAppointments(index:1);
                },
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w1p * 4,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              pgVCntrlr.jumpToPage(0);
                            },
                            child: selectionBox(
                              AppLocalizations.of(context)!.upcoming,
                              mgr.selectedAppointTabTitle == null ||
                                  mgr.selectedAppointTabTitle ==
                                      StringConstants.upcomingBookings,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              pgVCntrlr.jumpToPage(1);
                            },
                            child: selectionBox(
                              AppLocalizations.of(context)!.cancelled,
                              mgr.selectedAppointTabTitle ==
                                  StringConstants.cancelledBookings,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: PageView(
                          controller: pgVCntrlr,
                          allowImplicitScrolling: true,
                          onPageChanged: (pageNo) {
                            getIt<HomeManager>().setAppointmentsTabTitle(
                              pageNo == 0
                                  ? StringConstants.upcomingBookings
                                  : StringConstants.cancelledBookings,
                            );
                          },
                          children: [
                            AppoinmentBookingsList(
                              isCancelled: false,
                              w1p: w1p,
                              h1p: h1p,
                            ),
                            AppoinmentBookingsList(
                              isCancelled: true,
                              w1p: w1p,
                              h1p: h1p,
                            ),
                          ],
                        ),
                      ),
                    ),
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

class AppointmentItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String date;
  final int? bookingID;
  final int? docId;
  final String? name;
  final String appointmentId;
  final String bookingType;
  final String img;
  final bool isOnline;
  final String type;

  final String scheduledTime;
  final String patientName;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool isCancelled;
  const AppointmentItem({
    super.key,
    required this.w1p,
    required this.h1p,
    required this.scheduledTime,
    required this.docId,
    required this.bookingID,
    required this.isCancelled,
    required this.type,
    required this.appointmentId,
    required this.bookingType,
    required this.date,
    required this.isOnline,
    required this.patientName,
    // required this.isApplicable,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    Container getContainr({required Widget child}) {
      return Container(
        margin: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          color: clrD1ECFF,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: child,
        ),
      );
    }

    DateTime nw = DateTime.now();
    bool isSameDay =
        nw.year == startTime?.year &&
        nw.month == startTime?.month &&
        nw.day == startTime?.day;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w1p * 4, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: clrFFFFFF,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            color: clrD9D9D9,
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          pad(
            horizontal: w1p * 3,
            vertical: h1p,
            child: Row(
              children: [
                pad(
                  horizontal: w1p * 2.5,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          // border: Border.,
                          borderRadius: BorderRadius.circular(containerRadius),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              containerRadius,
                            ),
                            child: HomeWidgets().cachedImg(
                              img,
                              placeholderImage:
                                  'assets/images/doctor-placeholder.png',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            date,
                            style: t500_12.copyWith(
                              color: clr444444,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      if (name != null)
                        Text(
                          'Dr.$name',
                          style: t700_16.copyWith(
                            color: clr444444,
                            height: 1.1,
                          ),
                        ),
                      Text(type, style: t500_12.copyWith(color: clr2D2D2D)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(
                                  containerRadius,
                                ),
                              ),
                              child: pad(
                                horizontal: 0,
                                vertical: 0,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                      child: Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: Image.asset(
                                          "assets/images/home_icons/icon-time.png",
                                          color: clr5758AC,
                                        ),
                                      ),
                                    ),
                                    horizontalSpace(w1p),
                                    Text(
                                      scheduledTime,
                                      style: t500_12.copyWith(
                                        height: 1,
                                        color: clr444444,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            isSameDay == true &&
                                    startTime != null &&
                                    !DateTime.now().isAfter(startTime!) &&
                                    isCancelled != true
                                ? AppoinmentTimerText(
                                    fn: () {
                                      getIt<HomeManager>()
                                          .getUpcomingAppointments();
                                    },
                                    consultStartTime: startTime!,
                                    type: 1,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runAlignment: WrapAlignment.spaceBetween,
                        spacing: 4,

                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getContainr(
                            child: Text(
                              'Booked for $patientName',
                              style: t500_12.copyWith(color: clr444444),
                            ),
                          ),
                          getContainr(
                            child: Text(
                              bookingType,
                              style: t500_12.copyWith(color: clr444444),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          isCancelled
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: linearGrad4,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      ),
                    ),
                    child: pad(
                      horizontal: w1p * 3,
                      vertical: h1p,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.appointmentCancelled,
                            style: t500_14.copyWith(height: 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          startTime != null &&
                  isCancelled != true &&
                  DateTime.now().isAfter(startTime!)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: docId == null
                      ? InkWell(
                          onTap: () {},
                          child: Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              boxShadow: [boxShadow2],
                              // border: Border.all(color: Colours.primaryblue.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.white,
                            ),
                            child: pad(
                              vertical: 8,
                              horizontal: 6,
                              child: Center(
                                child: Text(
                                  "Not attended by Doctor",
                                  style: t500_14.copyWith(
                                    color: const Color(0xff676767),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : bookingType != "Offline"
                      ? InkWell(
                          onTap: () {
                            getIt<BookingManager>().sendConsultedStatus(
                              bookingID!,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatPage(
                                  bookId: bookingID!,
                                  docId: docId,
                                  appId: appointmentId,
                                  isCallAvailable: true,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              boxShadow: [boxShadow2],
                              border: Border.all(
                                color: Colours.primaryblue.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.white,
                            ),
                            child: pad(
                              vertical: 8,
                              horizontal: 6,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.consultNow,
                                  style: t500_14.copyWith(
                                    color: const Color(0xff2e3192),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class AppoinmentTimerText extends StatefulWidget {
  final Function fn;
  final int type;
  final DateTime consultStartTime;
  final TextStyle? tstyle;
  const AppoinmentTimerText({
    super.key,
    required this.fn,
    required this.consultStartTime,
    required this.type,
    this.tstyle,
  });

  @override
  State<AppoinmentTimerText> createState() => _ResendOTPTxtState();
}

class _ResendOTPTxtState extends State<AppoinmentTimerText> {
  int secondsRemaining = DateTime.now().second;
  // bool  enableResend = false;
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
          Duration difference = widget.consultStartTime.difference(
            DateTime.now(),
          );

          secondsRemaining = difference.inSeconds;
        });
      } else {
        widget.fn();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      " starts in ${getIt<StateManager>().formatDuration(secondsRemaining)}",
      style:
          widget.tstyle ??
          (widget.type == 1
              ? t500_12.copyWith(color: Colours.primaryblue, height: 1)
              : widget.type == 2
              ? t400_10.copyWith(color: clr2D2D2D)
              : t400_10.copyWith(color: clr2D2D2D)),
    );
  }
}

class AppoinmentBookingsList extends StatefulWidget {
  final double w1p;
  final double h1p;
  final bool isCancelled;
  const AppoinmentBookingsList({
    super.key,
    required this.w1p,
    required this.h1p,
    required this.isCancelled,
  });
  @override
  State<AppoinmentBookingsList> createState() => _AppoinmentBookingsListState();
}

class _AppoinmentBookingsListState extends State<AppoinmentBookingsList> {
  @override
  void initState() {
    if (widget.isCancelled == true) {
      getIt<HomeManager>().getCancelledAppointments(isRefresh: true);
    } else {
      getIt<HomeManager>().getUpcomingAppointments(isRefresh: true);
    }

    super.initState();
    _controller.addListener(_scrollListener);
  }

  final ScrollController _controller = ScrollController();

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      if (widget.isCancelled == true) {
        getIt<HomeManager>().getCancelledAppointments();
      } else {
        getIt<HomeManager>().getUpcomingAppointments();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UpcomingAppoinmentsModel? appointmentsModel = widget.isCancelled == true
        ? Provider.of<HomeManager>(context).cancelledAppointmentsModel
        : Provider.of<HomeManager>(context).upcomingAppointmentsModel;
    bool? loader = Provider.of<HomeManager>(context).appoinmentsLoader;

    return Container(
      child: loader == true
          ? const Center(
              child: Entry(
                yOffset: -100,
                // scale: 20,
                delay: Duration(milliseconds: 0),
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
                child: Padding(
                  padding: EdgeInsets.all(28.0),
                  child: LogoLoader(),
                ),
              ),
            )
          :
            // appointmentsModel?.upcomingAppointments == null && loader==true?
            // Entry(
            //     yOffset: -100,
            //     // scale: 20,
            //     delay: const Duration(milliseconds: 0),
            //     duration: const Duration(milliseconds: 500),
            //     curve: Curves.ease,
            //     child: Padding(
            //       padding: const EdgeInsets.all(28.0),
            //       child: AppLoader( size: 40),
            //     )):
            appointmentsModel!.upcomingAppointments!.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: SizedBox(
                      width: 100,
                      child: Image.asset("assets/images/appoinments.png"),
                    ),
                  ),
                  verticalSpace(4),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.appointmentsNotAvailable,
                      style: TextStyles.notAvailableTxtStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : appointmentsModel.upcomingAppointments != null
          ? ListView(
              controller: _controller,
              children: appointmentsModel.upcomingAppointments!.map((item) {
                var ind = appointmentsModel.upcomingAppointments!.indexOf(item);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BookingDetailsScreen(bookingId: item.id),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        AppointmentItem(
                          bookingID: item.id,
                          bookingType: item.bookingType ?? "",
                          appointmentId: item.appointmentId!,
                          docId: item.doctorId,
                          startTime: DateTime.tryParse(
                            item.bookingStartTime ?? "",
                          ),
                          endTime: DateTime.tryParse(item.bookingEndTime ?? ""),
                          img: item.docImg ?? "",
                          isCancelled: widget.isCancelled,

                          w1p: widget.w1p,
                          h1p: widget.h1p,
                          date: item.date != null
                              ? getIt<StateManager>().convertStringDateToyMMMMd(
                                  item.date!,
                                )
                              : "",
                          name: item.doctorFirstName,
                          type: item.speciality ?? item.subspeciality ?? "",

                          scheduledTime: item.time != null
                              ? getIt<StateManager>().convertTime(item.time!)
                              : "",
                          isOnline: true,
                          patientName: item.patientFirstName ?? "",
                        ),
                        // mgr.appoinmentsLoader==true && mgr.upcomingAppointments.isNotEmpty && index == mgr.upcomingAppointments.length-1?CircularProgressIndicator():SizedBox()
                        appointmentsModel.upcomingAppointments!.length - 1 ==
                                    ind &&
                                appointmentsModel.next != null
                            ? const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                ),
                              )
                            : const SizedBox(),
                      ],

                      // UpcomeAppointmentBox(h1p: h1p,w1p: w1p,date: e.date!=null?getIt<StateManager>().getFormattedDate(e.date!):""
                      //     ?? "",name:e.doctorFirstName ,type: e.speciality,
                      //     sheduledTime:"4.00 PM To 6.00 PM"
                      // ),
                    ),
                  ),
                );
              }).toList(),
            )
          : const SizedBox(),
    );
  }
}
