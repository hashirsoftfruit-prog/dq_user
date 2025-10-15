import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/home_screen.dart';

import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/core/basic_response_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../booking_screens/doctor_slot_pick_screen.dart';
import 'drawer_menu_screens_widgets.dart';

class ConsultationsScreen extends StatefulWidget {
  const ConsultationsScreen({super.key});

  @override
  State<ConsultationsScreen> createState() => _ConsultationsScreenState();
}

class _ConsultationsScreenState extends State<ConsultationsScreen> {
  // AvailableDocsModel docsData;
  int index = 1;

  @override
  void initState() {
    super.initState();
    getIt<HomeManager>().getConsultaions(index: index);
    _controller.addListener(_scrollListener);
  }

  final ScrollController _controller = ScrollController();

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      index++;
      getIt<HomeManager>().getConsultaions(index: index);
    }
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

        // List<String> tabHeads = ["Previous","Follow Ups"];

        // selectionBox(String e,bool selected){
        //   return Container(
        //       // duration: Duration(milliseconds: 500),
        //       decoration:
        //      BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(containerRadius/2)),
        //       child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Padding(padding: EdgeInsets.only(right: w1p*3,top: h1p,bottom: h1p,),child: Text(e,style:selected? t500_14.copyWith(color: Color(0xff5054e5), height: 1):t500_14.copyWith(color: clr444444, height: 1),)),
        //        selected?Entry(
        //            xOffset: -100,
        //            // scale: 20,
        //            delay: const Duration(milliseconds: 0),
        //            duration: const Duration(milliseconds: 700),
        //            curve: Curves.ease,
        //            child: Container(
        //              decoration: BoxDecoration(color: Colours.primaryblue,borderRadius: BorderRadius.circular(6)),
        //              height: 4,width: 30,)):Container(height: 2,color: Colors.white,width: 30,)
        //         ],
        //       ));
        // }

        return Consumer<HomeManager>(
          builder: (context, mgr, child) {
            return Scaffold(
              // extendBody: true,
              backgroundColor: Colors.white,
              appBar: getIt<SmallWidgets>().appBarWidget(
                title: AppLocalizations.of(context)!.consultations,
                height: h10p,
                width: w10p,
                fn: () {
                  Navigator.pop(context);
                },
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    index = 1;
                  });
                  await getIt<HomeManager>().getConsultaions(index: index);
                },
                child: Column(
                  children: [
                    // SizedBox(child:
                    // Row(
                    //     children:tabHeads.map((e)=>
                    //     InkWell(focusColor: Colors.transparent,splashColor: Colors.transparent,
                    //         onTap: ()async{
                    //           index = 1;
                    //           getIt<HomeManager>().setAppoinmentsTabTitle(e);
                    //          await getIt<HomeManager>().getUpcomingAppointments(index:index);
                    //
                    //         },
                    //         child: selectionBox(e,mgr.selectedAppointTabTitle==e,))
                    //     ).toList()
                    // ),),
                    Expanded(
                      child: ListView(
                        controller: _controller,
                        children: [
                          verticalSpace(8),
                          mgr.appoinmentsLoader == true &&
                                  mgr.consultaions.isEmpty
                              ? const Entry(
                                  yOffset: -100,
                                  // scale: 20,
                                  delay: Duration(milliseconds: 0),
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                  child: Padding(
                                    padding: EdgeInsets.all(28.0),
                                    child: LogoLoader(),
                                  ),
                                )
                              : mgr.consultaions.isNotEmpty
                              ? Entry(
                                  xOffset: -1000,
                                  // scale: 20,
                                  delay: const Duration(milliseconds: 0),
                                  duration: const Duration(milliseconds: 700),
                                  curve: Curves.ease,
                                  child: Entry(
                                    opacity: .5,
                                    // angle: 3.1415,
                                    delay: const Duration(milliseconds: 0),
                                    duration: const Duration(
                                      milliseconds: 1500,
                                    ),
                                    curve: Curves.decelerate,
                                    child: Column(
                                      children: mgr.consultaions.map((item) {
                                        var index = mgr.consultaions.indexOf(
                                          item,
                                        );

                                        return InkWell(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () async {
                                            // if(coupon.applicable==true){
                                            //   // await applyCoupnFn(coupon.couponCode??"");
                                            //
                                            // }else{
                                            //
                                            //   showTopSnackBar(
                                            //       Overlay.of(context),
                                            //       ErrorToast(
                                            //         message:
                                            //         "This coupon is not applicable",
                                            //       ));
                                            // }
                                          },
                                          child: Column(
                                            children: [
                                              RecentConsultItem(
                                                docId: item.doctorId!,
                                                appoinmentId:
                                                    item.appointmentId!,
                                                bookingStartTime:
                                                    DateTime.tryParse(
                                                      item.bookingStartTime ??
                                                          "",
                                                    ),
                                                bookingEndTime:
                                                    DateTime.tryParse(
                                                      item.bookingEndTime ?? "",
                                                    ),
                                                bookingId: item.id!,
                                                patientname:
                                                    item.patientFirstName ?? "",
                                                h1p: h1p,
                                                w1p: w1p,
                                                date: item.date != null
                                                    ? getIt<StateManager>()
                                                          .convertStringDateToyMMMMd(
                                                            item.date!,
                                                          )
                                                    : "",
                                                name:
                                                    '${item.doctorFirstName ?? ""} ${item.doctorLastname ?? ""}',
                                                type:
                                                    item.speciality ??
                                                    item.subspeciality ??
                                                    "",
                                                sheduledTime:
                                                    getIt<StateManager>()
                                                        .convertTime(
                                                          item.time!,
                                                        ),
                                                doctorImg:
                                                    item.doctorImage ?? "",
                                                isFreeFollowUp:
                                                    item.isFreeFollowupActive ==
                                                    true,
                                                fn: () async {
                                                  BasicResponseModel?
                                                  result = await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => DoctorSlotPickScreen(
                                                        date: null,
                                                        followUpBookId: item.id,
                                                        isScheduledOnline:
                                                            item.bookingType ==
                                                            'Online',
                                                        isFreeFollowUp: true,
                                                        docId: item.doctorId,
                                                        freeFollowUpId: item.id,
                                                        specialityId:
                                                            item.specialityId ??
                                                            item.subSpecialityId!,
                                                        subSpecialityIdForPsychology:
                                                            null,
                                                      ),
                                                    ),
                                                  );
                                                  if (result != null) {
                                                    await getIt<HomeManager>()
                                                        .getFreeFollowUp();

                                                    await getIt<HomeManager>()
                                                        .getUpcomingAppointments(
                                                          isRefresh: true,
                                                        );
                                                    // getIt<HomeManager>()
                                                    //     .getConsultaions(
                                                    //       index: index,
                                                    //     );
                                                  }
                                                },
                                              ),
                                              mgr.appoinmentsLoader == true &&
                                                      mgr
                                                          .consultaions
                                                          .isNotEmpty &&
                                                      index ==
                                                          mgr
                                                                  .consultaions
                                                                  .length -
                                                              1
                                                  ? const CircularProgressIndicator()
                                                  : const SizedBox(),
                                            ],
                                            // UpcomeAppointmentBox(h1p: h1p,w1p: w1p,date: e.date!=null?getIt<StateManager>().getFormattedDate(e.date!):""
                                            //     ?? "",name:e.doctorFirstName ,type: e.speciality,
                                            //     sheduledTime:"4.00 PM To 6.00 PM"
                                            // ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(28.0),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.noConsults,
                                      style: TextStyles.notAvailableTxtStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                        ],
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
