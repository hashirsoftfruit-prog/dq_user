// ignore_for_file: use_build_context_synchronously

import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/controller/managers/state_manager.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:dqapp/view/screens/pet_care_screens/pet_booking_screen_scheduled.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../model/core/doctor_list_response_model.dart';
import '../../../model/core/doctors_slotpick_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import 'redacted_loaders.dart';
import 'scheduled_booking_screen.dart';

class DoctorSlotPickScreen extends StatefulWidget {
  final String? date;
  final int? followUpBookId;
  final int? docId;
  final ClinicsDetails? clinicDetails;
  final int? petId;
  final int? freeFollowUpId;
  final int specialityId;
  final int? subSpecialityIdForPsychology;
  final bool isFreeFollowUp;
  final bool? isPetBooking;
  final bool isScheduledOnline;

  const DoctorSlotPickScreen({
    super.key,
    required this.date,
    required this.followUpBookId,
    required this.docId,
    required this.subSpecialityIdForPsychology,
    this.petId,
    this.clinicDetails,
    this.isPetBooking,
    required this.specialityId,
    required this.isFreeFollowUp,
    required this.freeFollowUpId,
    required this.isScheduledOnline,
  });

  @override
  State<DoctorSlotPickScreen> createState() => _DoctorSlotPickScreenState();
}

class _DoctorSlotPickScreenState extends State<DoctorSlotPickScreen> {
  // AvailableDocsModel docsData;

  @override
  void dispose() {
    getIt<BookingManager>().disposePickSlots();
    super.dispose();
  }

  @override
  void initState() {
    // getIt<BookingManager>().getDoctorSlots(date: widget.date, bookId: widget.followUpBookId, docId: widget.docId, clinicId: widget.clinicDetails?.id, isFreeFollowUp: widget.isFreeFollowUp, isScheduledOnline: widget.isScheduledOnline);
    initialCallForSlot();
    // setState(() {
    //   getIt<BookingManager>().slotPickLoader = true;
    // });
    super.initState();
  }

  initialCallForSlot() async {
    var res = await getDoctorSlots(widget.date, false);
    if (res == true) {
      getDoctorSlots(widget.date, true);
    }
  }

  getDoctorSlots(String? date, bool isFutureSlotsRequired) async {
    bool res = await getIt<BookingManager>().getDoctorSlots(
      date: date,
      bookId: widget.followUpBookId,
      docId: widget.docId,
      clinicId: widget.clinicDetails?.id,
      isFreeFollowUp: widget.isFreeFollowUp,
      isScheduledOnline: widget.isScheduledOnline,
      isFutureSlotsRequired: isFutureSlotsRequired,
    );
    return res;
  }

  // var coupC = TextEditingController(text:" ");

  @override
  Widget build(BuildContext context) {
    slotBox(String time, {required bool selected}) {
      return Container(
        height: 38,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: selected ? clrFFFFFF : clrF3F3F3,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? Colours.primaryblue : clrF3F3F3),
          // boxShadow: [boxShadow5b]
        ),
        child: Center(
          child: Text(
            getIt<StateManager>().getFormattedTime(time) ?? "",
            style: selected
                ? t500_14.copyWith(color: clr2D2D2D)
                : t400_14.copyWith(color: clr2D2D2D),
          ),
        ),
      );
    }

    buildTimeSlots({
      required List<String> timeList,
      required bool buttonLoader,
      selectedTimeSlot,
      required String title,
      required String icon,
    }) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
            child: Row(
              children: [
                SizedBox(height: 24, width: 24, child: Image.asset(icon)),
                Text(title, style: t400_16.copyWith(color: clr2D2D2D)),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              var e = timeList[index];
              return GestureDetector(
                onTap: () {
                  if (!buttonLoader) {
                    getIt<BookingManager>().setSelectedTimeSlot(e);
                  }
                },
                child: slotBox(e, selected: selectedTimeSlot == e),
              );
            }, childCount: timeList.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2 / 1,
              crossAxisSpacing: 6,
              mainAxisSpacing: 3,
            ),
          ),
        ),
      ];
    }

    // List<String> langs = ["English","Malayalam"];
    // List<String> consultOthers = ["Father","Mother","Wife","Other"];
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        // double docCircleSize = 110;
        double horizPad = w1p * 4;

        // getBtn({required String title,bool? loader,double? height}){
        //   return pad(horizontal: w1p*6,vertical: 8,
        //     child: Container(
        //       height:height,
        //       width: maxWidth,decoration:BoxDecoration(borderRadius: BorderRadius.circular(21),color: Colours.primaryblue),
        //       child: pad(horizontal: 0,vertical: 8,child:Center(
        //         child: loader==true? CircularProgressIndicator(color: Colors.white,strokeWidth: 1): Center(child: Text(title,style: t700_16.copyWith(color: Color(0xffffffff)),)),
        //       )),),
        //   );
        // }
        calender(List<AllTimeSlots>? dates, AllTimeSlots selectedDate) {
          List<DateTime?> datesList = dates!.map((e) {
            if (e.timeList == null || e.timeList!.isEmpty) {
              return getIt<StateManager>().convertStringToDDMMYYY(e.date!);
            }
            return null;
          }).toList();
          List<DateTime> filteredDates = datesList
              .where((date) => date != null)
              .cast<DateTime>()
              .toList();

          return EasyInfiniteDateTimeLine(
            dayProps: const EasyDayProps(
              dayStructure: DayStructure.monthDayNumDayStr,
              height: 75,
            ),
            activeColor: Colours.primaryblue,
            selectionMode: const SelectionMode.autoCenter(),
            timeLineProps: const EasyTimeLineProps(separatorPadding: 2),
            itemBuilder: (a, date, selected, onselected) {
              return GestureDetector(
                onTap: () {
                  onselected();
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 76,
                  width: 68,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: selected ? Colours.primaryblue : clrFFFFFF,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 1),
                        color: const Color(0xff000000).withOpacity(0.2),
                        blurRadius: 2.8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${date.day}',
                        style: t500_18.copyWith(
                          color: selected ? clrFFFFFF : clr2D2D2D,
                        ),
                      ),
                      Text(
                        DateFormat('EEE').format(date),
                        style: t400_14.copyWith(
                          color: selected ? clrFFFFFF : clr858585,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            // controller: _controller,
            showTimelineHeader: false,
            focusDate: getIt<StateManager>().convertStringToDDMMYYY(
              selectedDate.date!,
            ),
            // firstDate: getIt<StateManager>().getDateTimeFromString(dates!.first.date!),
            firstDate: getIt<StateManager>().convertStringToDDMMYYY(
              dates.first.date!,
            )!,
            lastDate: getIt<StateManager>().convertStringToDDMMYYY(
              dates.last.date!,
            )!,
            disabledDates: filteredDates,
            // focusDate: DateTime.now(),
            onDateChange: (selectedDate) {
              // print(dates.last.date);
              String dt = getIt<StateManager>().convertDateTimeToDDMMYYY(
                selectedDate,
              );

              getIt<BookingManager>().setSelectedDate(dt);
            },
          );
        }

        // docCircle(String img) {
        //   return SizedBox(
        //       height: docCircleSize,
        //       width: docCircleSize,
        //       child: Stack(
        //         alignment: Alignment.center,
        //         children: [
        //           // Container(height: 90,width: 90,decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white),),
        //           Container(
        //             height: docCircleSize - 15,
        //             width: docCircleSize - 10,
        //             decoration: BoxDecoration(shape: BoxShape.circle, color: Colours.primaryblue.withOpacity(0.10)),
        //           ),
        //           Container(
        //             height: docCircleSize,
        //             width: docCircleSize,
        //             decoration: BoxDecoration(shape: BoxShape.circle, color: Colours.primaryblue.withOpacity(0.05)),
        //           ),
        //           Container(
        //             height: docCircleSize - 20,
        //             width: docCircleSize - 20,
        //             decoration: BoxDecoration(shape: BoxShape.circle, color: Colours.primaryblue.withOpacity(0.5)),
        //             child: ClipRRect(
        //               borderRadius: BorderRadius.circular(100),
        //               child: CachedNetworkImage(
        //                 fit: BoxFit.cover,
        //                 imageUrl: "${StringConstants.baseUrl}$img",
        //                 placeholder: (context, url) => Image.asset(
        //                   'assets/images/doctor-placeholder.png',
        //                   fit: BoxFit.fitHeight,
        //                 ),
        //                 errorWidget: (context, url, error) => Image.asset(
        //                   'assets/images/doctor-placeholder.png',
        //                   fit: BoxFit.fitHeight,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ));
        // }

        return Consumer<BookingManager>(
          builder: (context, mgr, child) {
            // DoctorSlotPickModel? data = mgr.doctorSlotPickModel;
            // print('slot ${mgr.doctorSlotPickModel?.allTimeSlots?.map((e) => e.date).toList()}');
            return Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,

              // extendBody: true,
              backgroundColor: Colors.white,
              // appBar: getIt<SmallWidgets>().appBarWidget(title: AppLocalizations.of(context)!.applyCoupon,
              appBar: getIt<SmallWidgets>().appBarWidget(
                title: AppLocalizations.of(context)!.pickSlots,
                height: h10p - h1p * 2,
                width: w10p,
                fn: () {
                  Navigator.pop(context);
                },
              ),
              body: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      mgr.slotPickLoader == true &&
                              mgr.doctorSlotPickModel == null
                          ? const SlotSelectionSkeleton()
                          // const Center(
                          //     child: Padding(
                          //     padding: EdgeInsets.all(28.0),
                          //     child: LogoLoader(),
                          //   ))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                pad(
                                  horizontal: horizPad,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.schedule,
                                        style: t500_16.copyWith(
                                          color: clr444444,
                                        ),
                                      ),
                                      widget.isFreeFollowUp != true
                                          ? InkWell(
                                              onTap: () async {
                                                DateTime?
                                                result = await showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return CalenderWidget(
                                                      getIt<StateManager>()
                                                          .convertStringToDDMMYYY(
                                                            mgr
                                                                .doctorSlotPickModel!
                                                                .allTimeSlots!
                                                                .last
                                                                .date!,
                                                          )!,
                                                    );
                                                  },
                                                );

                                                if (result != null) {
                                                  // dateC.text = result.toString();

                                                  String
                                                  dt = getIt<StateManager>()
                                                      .convertDateTimeToDDMMYYY(
                                                        result,
                                                      );

                                                  // getIt<BookingManager>().setSelectedDates(dt);
                                                  // getIt<BookingManager>().getDoctorSlots(
                                                  //   date: dt,
                                                  //   bookId: widget.followUpBookId,
                                                  //   docId: widget.docId,
                                                  //   clinicId: widget.clinicDetails?.id,
                                                  //   isFreeFollowUp: widget.isFreeFollowUp,
                                                  //   isScheduledOnline: widget.isScheduledOnline,
                                                  //   isFutureSlotsRequired: true,
                                                  // );octorSlots(dt, true);
                                                  // });

                                                  var res =
                                                      await getDoctorSlots(
                                                        dt,
                                                        false,
                                                      );
                                                  if (res == true) {
                                                    getDoctorSlots(dt, true);
                                                  }
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  mgr.doctorSlotPickModel !=
                                                          null
                                                      ? Text(
                                                          getIt<StateManager>()
                                                              .convertStringDateToyMMMMd(
                                                                getIt<
                                                                      StateManager
                                                                    >()
                                                                    .convertStringToDDMMYYY(
                                                                      mgr
                                                                          .doctorSlotPickModel!
                                                                          .selectedDate!
                                                                          .date!,
                                                                    )
                                                                    .toString(),
                                                              ),
                                                          style: t500_14
                                                              .copyWith(
                                                                color:
                                                                    clr444444,
                                                              ),
                                                        )
                                                      : const SizedBox(),
                                                  horizontalSpace(w1p),
                                                  const Icon(
                                                    Icons.calendar_today,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                                mgr.slotPickLoader == true
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 0,
                                          vertical: h1p * 2,
                                        ),
                                        child: const Center(
                                          child: SizedBox(
                                            width: 40,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1,
                                              color: Colours.primaryblue,
                                            ),
                                          ),
                                        ),
                                      )
                                    : mgr.doctorSlotPickModel?.allTimeSlots !=
                                              null &&
                                          mgr
                                              .doctorSlotPickModel!
                                              .allTimeSlots!
                                              .isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 0,
                                          vertical: h1p * 2,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // if (mgr.futureSlotLoader == true)
                                            //   SizedBox(
                                            //     width: 80,
                                            //     child: calender(mgr.doctorSlotPickModel!.allTimeSlots, mgr.doctorSlotPickModel!.selectedDate!),
                                            //   ),
                                            // mgr.futureSlotLoader == true
                                            //     ? Padding(
                                            //         padding: EdgeInsets.symmetric(horizontal: w1p * 3, vertical: h1p * 2),
                                            //         child: const Center(
                                            //             child: SizedBox(
                                            //           width: 40,
                                            //           child: CircularProgressIndicator(
                                            //             strokeWidth: 1,
                                            //             color: Colours.primaryblue,
                                            //           ),
                                            //         )),
                                            //       )
                                            //     :
                                            Expanded(
                                              child: calender(
                                                mgr
                                                    .doctorSlotPickModel!
                                                    .allTimeSlots,
                                                mgr
                                                    .doctorSlotPickModel!
                                                    .selectedDate!,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                    ]),
                  ),
                  if (mgr.slotPickLoader != true)
                    SliverPadding(
                      padding: EdgeInsets.only(left: horizPad),
                      sliver: SliverPersistentHeader(
                        delegate: IntervalHeadingDelegate(
                          text: AppLocalizations.of(context)!.selectSlot,
                          minHeight: 45,
                          maxHeight: 50,
                          slotCount:
                              "${mgr.doctorSlotPickModel?.selectedDate?.timeList?.length ?? 0} ${AppLocalizations.of(context)!.slotsAvailable}", // Replace with your asset path
                        ),
                        pinned: true, // Keeps it at the top while scrolling
                      ),
                    ),
                  if (mgr.doctorSlotPickModel?.selectedDate?.morningSlots !=
                          null &&
                      mgr
                          .doctorSlotPickModel!
                          .selectedDate!
                          .morningSlots!
                          .isNotEmpty &&
                      mgr
                          .doctorSlotPickModel!
                          .selectedDate!
                          .morningSlots!
                          .isNotEmpty)
                    ...buildTimeSlots(
                      title: "Morning",
                      timeList:
                          mgr.doctorSlotPickModel!.selectedDate!.morningSlots!,
                      buttonLoader: mgr.buttonLoader,
                      selectedTimeSlot:
                          mgr.doctorSlotPickModel!.selectedTimeSlot,
                      icon: "assets/images/slotpick-mng.png",
                    ),
                  if (mgr.doctorSlotPickModel?.selectedDate?.afternoonSlots !=
                          null &&
                      mgr
                          .doctorSlotPickModel!
                          .selectedDate!
                          .afternoonSlots!
                          .isNotEmpty &&
                      mgr
                          .doctorSlotPickModel!
                          .selectedDate!
                          .afternoonSlots!
                          .isNotEmpty)
                    ...buildTimeSlots(
                      title: "Afternoon",
                      timeList: mgr
                          .doctorSlotPickModel!
                          .selectedDate!
                          .afternoonSlots!,
                      buttonLoader: mgr.buttonLoader,
                      selectedTimeSlot:
                          mgr.doctorSlotPickModel!.selectedTimeSlot,
                      icon: "assets/images/slotpick-aftern.png",
                    ),
                  if (mgr.doctorSlotPickModel?.selectedDate?.eveningSlots !=
                          null &&
                      mgr
                          .doctorSlotPickModel!
                          .selectedDate!
                          .eveningSlots!
                          .isNotEmpty &&
                      mgr
                          .doctorSlotPickModel!
                          .selectedDate!
                          .eveningSlots!
                          .isNotEmpty)
                    ...buildTimeSlots(
                      title: "Evening",
                      timeList:
                          mgr.doctorSlotPickModel!.selectedDate!.eveningSlots!,
                      buttonLoader: mgr.buttonLoader,
                      selectedTimeSlot:
                          mgr.doctorSlotPickModel!.selectedTimeSlot,
                      icon: "assets/images/slotpick-evng.png",
                    ),
                  if (mgr.doctorSlotPickModel?.selectedDate?.timeList != null &&
                      mgr
                          .doctorSlotPickModel!
                          .selectedDate!
                          .timeList!
                          .isEmpty &&
                      mgr.slotPickLoader != true)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.slotsNotAvailableInThisDate,
                          style: TextStyles.notAvailableTxtStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  if (mgr.doctorSlotPickModel?.selectedDate?.date != null &&
                      mgr.doctorSlotPickModel?.selectedTimeSlot != null &&
                      mgr.slotPickLoader != true)
                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),

              floatingActionButton:
                  (mgr.doctorSlotPickModel?.selectedDate?.date != null &&
                      mgr.doctorSlotPickModel?.selectedTimeSlot != null)
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                      child: ButtonWidget(
                        ontap: () async {
                          if (widget.isFreeFollowUp) {
                            var result = await getIt<BookingManager>()
                                .scheduleOnlineBooking(
                                  date: mgr
                                      .doctorSlotPickModel
                                      ?.selectedDate
                                      ?.date,
                                  time:
                                      mgr.doctorSlotPickModel?.selectedTimeSlot,
                                  docId: mgr
                                      .doctorSlotPickModel
                                      ?.doctorDetails
                                      ?.id,
                                  specialtyId: widget.specialityId,
                                  paidAmount: null,
                                  isFreeFollowUp: widget.isFreeFollowUp,
                                  freeFollowUpId: widget.freeFollowUpId,
                                  consultationFor: null,
                                );

                            if (result.status == true) {
                              showTopSnackBar(
                                snackBarPosition: SnackBarPosition.bottom,
                                padding: const EdgeInsets.all(30),
                                Overlay.of(context),
                                SuccessToast(
                                  maxLines: 3,
                                  message: result.message ?? "",
                                ),
                              );
                              getIt<HomeManager>().getConsultaions(index: 1);
                              Navigator.pop(context, result);
                            } else {
                              showTopSnackBar(
                                snackBarPosition: SnackBarPosition.bottom,
                                padding: const EdgeInsets.all(30),
                                Overlay.of(context),
                                ErrorToast(
                                  maxLines: 3,
                                  message: result.message ?? "",
                                ),
                              );
                            }
                          } else if (widget.isPetBooking == true) {
                            getIt<BookingManager>().setButtonLoader(true);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PetScheduledBookingScreen(
                                  petId: widget.petId,
                                  doctorDetails:
                                      mgr.doctorSlotPickModel?.doctorDetails!,
                                  date: getIt<StateManager>()
                                      .convertStringToDDMMYYY(
                                        mgr
                                            .doctorSlotPickModel!
                                            .selectedDate!
                                            .date!,
                                      )!,
                                  time: mgr
                                      .doctorSlotPickModel!
                                      .selectedTimeSlot!,
                                  clinicId: widget.clinicDetails?.id,
                                  isScheduledOnline: widget.isScheduledOnline,
                                  specialityId: widget.specialityId,
                                  itemName: "",
                                  subCatId: null,
                                ),
                              ),
                            );
                            getIt<BookingManager>().setButtonLoader(false);
                          } else {
                            getIt<BookingManager>().setButtonLoader(true);

                            var result = await getIt<BookingManager>()
                                .getScheduledBookingData(
                                  specialityId: widget.specialityId,
                                  doctorId: widget.docId,
                                  subSpecialityId:
                                      widget.subSpecialityIdForPsychology,
                                );
                            if (result.status == true) {
                              getIt<BookingManager>().setDocsData(result);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ScheduledBookingScreen(
                                    doctorDetails:
                                        mgr.doctorSlotPickModel?.doctorDetails!,
                                    date: getIt<StateManager>()
                                        .convertStringToDDMMYYY(
                                          mgr
                                              .doctorSlotPickModel!
                                              .selectedDate!
                                              .date!,
                                        )!,
                                    time: mgr
                                        .doctorSlotPickModel!
                                        .selectedTimeSlot!,
                                    clinicInfo: widget.clinicDetails,
                                    isScheduledOnline: widget.isScheduledOnline,
                                    specialityId: widget.specialityId,
                                    subCatId: null,
                                    subSpecialityIdForPsychology:
                                        widget.subSpecialityIdForPsychology,
                                  ),
                                ),
                              );
                            } else {
                              showTopSnackBar(
                                snackBarPosition: SnackBarPosition.bottom,
                                padding: const EdgeInsets.all(30),
                                Overlay.of(context),
                                ErrorToast(
                                  maxLines: 3,
                                  message: result.message ?? "",
                                ),
                              );
                            }
                            getIt<BookingManager>().setButtonLoader(false);
                          }
                        },
                        isLoading: mgr.buttonLoader,
                        btnText: widget.isFreeFollowUp
                            ? AppLocalizations.of(context)!.scheduleBooking
                            : AppLocalizations.of(context)!.next,
                      ),
                    )
                  : const SizedBox(),
            );
          },
        );
      },
    );
  }
}

class CalenderWidget extends StatefulWidget {
  final DateTime minDate;

  const CalenderWidget(this.minDate, {super.key});
  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  // DateTime? pickedDateRange;

  // List<Param> doses;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        "Select Date",
        style: t700_18.copyWith(color: clrFFFFFF, height: 1),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SfDateRangePicker(
            backgroundColor: Colors.white,
            // controller: _controller,
            view: DateRangePickerView.month,
            minDate: DateTime.now(),
            maxDate: DateTime.now().add(const Duration(days: 23)),
            // minDate: widget.minDate.add(Duration(days: 1)),
            selectionMode: DateRangePickerSelectionMode.single,
            toggleDaySelection: true,
            cancelText: "Cancel",

            onSelectionChanged: (dd) {
              Navigator.pop(context, dd.value);
            },
            monthViewSettings: const DateRangePickerMonthViewSettings(
              enableSwipeSelection: false,
            ),
          ),
        ],
      ),
      titlePadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      actionsPadding: const EdgeInsets.only(bottom: 18, right: 10),
      contentPadding: const EdgeInsets.only(bottom: 10, right: 8, left: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(11)),
      ),
    );
  }
}

class IntervalHeadingDelegate extends SliverPersistentHeaderDelegate {
  final String slotCount;
  final double minHeight;
  final double maxHeight;
  final String text;

  IntervalHeadingDelegate({
    required this.slotCount,
    required this.minHeight,
    required this.maxHeight,
    required this.text,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    double progress = shrinkOffset / maxExtent;
    bool isCollapsed = progress > 0.6; // Controls when animation starts

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          // Title (Always Left-Aligned)
          Positioned(
            left: 0,
            top: isCollapsed ? 15 : 5, // Adjusts based on shrinkOffset
            child: Text(text, style: t500_16.copyWith(color: clr444444)),
          ),

          // Animated Slot Count (Moves to Right)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            right: isCollapsed ? 8 : null,
            left: isCollapsed ? null : 0,
            bottom: isCollapsed ? 15 : 0, // Adjusts vertical positioning
            child: Text(
              slotCount,
              style: const TextStyle(
                color: Color(0xff00C165),
                fontWeight: FontWeight.w500,
                fontFamily: "Product Sans Medium",
                fontStyle: FontStyle.normal,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
