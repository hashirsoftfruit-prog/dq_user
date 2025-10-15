// ignore_for_file: use_build_context_synchronously

import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/model/core/search_medicine_model.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/reminder_screens/prescribed_medicines_screen.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/reminder_screens/select_medicine_screen.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/reminder_screens/set_reminder_screen.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_expandable_text/expandable_text.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../controller/managers/state_manager.dart';
import '../../../../model/core/reminder_list_model.dart';
import '../../../../model/helper/service_locator.dart';
import '../../../theme/constants.dart';
import '../../../widgets/coming_soon_dialog.dart';
import '../../home_screen.dart';
import 'reminder_screens_widgets.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool isVideoCall = false;
  // AvailableDocsModel docsData;
  // int index = 1;

  @override
  void initState() {
    super.initState();
    getIt<HomeManager>().getReminderList();
    // _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    getIt<HomeManager>().disposeReminderScreen();
    super.dispose();
  }

  // final ScrollController _controller = ScrollController();
  //
  // void _scrollListener()async {
  //   if (_controller.position.pixels == _controller.position.maxScrollExtent) {
  //     index++;
  //     getIt<HomeManager>().getConsultaions(index:index );
  //   }
  // }

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

        // floatBtn({required String title}) {
        //   return Padding(
        //     padding: EdgeInsets.all(w1p * 5),
        //     child: Container(
        //       width: maxWidth,
        //       height: 40,
        //       decoration: BoxDecoration(
        //         boxShadow: [boxShadow1],
        //         // gradient: linearGrad2,
        //         borderRadius: BorderRadius.circular(8), color: Colours.primaryblue,
        //       ),
        //       child: Center(
        //         child: Text(
        //           title,
        //           style: t700_16.copyWith(color: Color(0xffffffff)),
        //         ),
        //       ),
        //     ),
        //   );
        // }

        floatBtn2({required String title}) {
          return Padding(
            padding: EdgeInsets.all(w1p * 5),
            child: Container(
              width: maxWidth,
              height: 40,
              decoration: BoxDecoration(
                boxShadow: [boxShadow1],
                // gradient: linearGrad2,
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  title,
                  style: t500_14.copyWith(color: const Color(0xffFF0000)),
                ),
              ),
            ),
          );
        }

        textBtn({required String title, required Function onPressed}) {
          return InkWell(
            onTap: () {
              onPressed();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w1p * 5, vertical: 8),
              child: SizedBox(
                width: maxWidth,
                height: 40,
                child: Text(title, style: t400_16.copyWith(color: clr2D2D2D)),
              ),
            ),
          );
        }

        // selectionBox(String e, bool selected) {
        //   return Container(
        //       // duration: Duration(milliseconds: 500),
        //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(containerRadius / 2)),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Padding(
        //               padding: EdgeInsets.only(
        //                 right: w1p * 3,
        //                 top: h1p,
        //                 bottom: h1p,
        //               ),
        //               child: Text(
        //                 e,
        //                 style: selected ? t500_14.copyWith(color: const Color(0xff5054e5), height: 1) : t500_14.copyWith(color: clr444444, height: 1),
        //               )),
        //           selected
        //               ? Entry(
        //                   xOffset: -100,
        //                   // scale: 20,
        //                   delay: const Duration(milliseconds: 0),
        //                   duration: const Duration(milliseconds: 700),
        //                   curve: Curves.ease,
        //                   child: Container(
        //                     decoration: BoxDecoration(color: Colours.primaryblue, borderRadius: BorderRadius.circular(6)),
        //                     height: 4,
        //                     width: 30,
        //                   ))
        //               : Container(
        //                   height: 2,
        //                   color: Colors.white,
        //                   width: 30,
        //                 )
        //         ],
        //       ));
        // }

        return Consumer<HomeManager>(
          builder: (context, mgr, child) {
            return Scaffold(
              // extendBody: true,
              backgroundColor: Colors.white,
              appBar: getIt<SmallWidgets>().appBarWidget(
                title: AppLocalizations.of(context)!.reminder,
                height: h10p,
                width: w10p,
                trailWidget:
                    mgr.activeReminders == null || mgr.activeReminders!.isEmpty
                    ? const SizedBox()
                    : InkWell(
                        onTap: () {
                          getIt<HomeManager>().reminderListMarkValueChange();
                        },
                        child: mgr.enableMark
                            ? Text(
                                "Cancel",
                                style: t500_14.copyWith(color: clr444444),
                                // :"Select"
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Text(
                                  "Select",
                                  style: t500_14.copyWith(color: clr444444),
                                ),
                                // Image.asset("assets/images/check.png",height: 30,),
                              ),
                      ),
                fn: () {
                  Navigator.pop(context);
                },
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  getIt<HomeManager>().getReminderList();
                },
                child: ListView(
                  // controller: _controller,
                  children: [
                    verticalSpace(h1p * 2),
                    mgr.reminderLoader == true && mgr.activeReminders == null
                        ? Entry(
                            yOffset: -100,
                            // scale: 20,
                            delay: const Duration(milliseconds: 0),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: AppLoader(
                                color: clrCE6F7D.withOpacity(0.5),
                                size: 40,
                              ),
                            ),
                          )
                        : mgr.activeReminders != null &&
                              mgr.activeReminders!.isNotEmpty
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
                              duration: const Duration(milliseconds: 1500),
                              curve: Curves.decelerate,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: h10p),
                                    child: Column(
                                      children: mgr.activeReminders!
                                          .map(
                                            (e) => pad(
                                              vertical: 8,
                                              horizontal: 0,
                                              child: ReminderContainer(
                                                ontap: () {},
                                                drg: e,
                                                h1p: h1p,
                                                w1p: w1p,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Opacity(
                            opacity: 0.5,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: h10p),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18.0,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: SizedBox(
                                        child: Image.asset(
                                          "assets/images/icon-reminder-big.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "You have no reminders.",
                                    style: t700_16.copyWith(color: clr444444),
                                  ),
                                  Text(
                                    "Set a reminder for medicines, food, water etc...",
                                    style: t500_12.copyWith(color: clr444444),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    verticalSpace(h10p),
                  ],
                ),
              ),

              floatingActionButton: mgr.enableMark
                  ? Entry(
                      yOffset: 150,
                      // scale: 20,
                      delay: const Duration(milliseconds: 150),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                      child: GestureDetector(
                        onTap: () async {
                          if (mgr.markedReminderList.isNotEmpty) {
                            bool? result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DeleteReminderPopup(w1p: w1p, h1p: h1p);
                              },
                            );
                            if (result != true) return;
                            var res = await getIt<HomeManager>().deleteReminder(
                              mgr.markedReminderList,
                            );

                            if (res.status == true) {
                              getIt<HomeManager>().reminderListMarkValueChange(
                                val: false,
                              );
                              getIt<HomeManager>().getReminderList();
                            } else {
                              showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.success(
                                  backgroundColor: Colours.toastRed,
                                  maxLines: 3,
                                  message: res.message ?? "",
                                ),
                              );
                            }
                          } else {
                            showTopSnackBar(
                              Overlay.of(context),
                              const CustomSnackBar.success(
                                backgroundColor: Colours.toastRed,
                                maxLines: 3,
                                message: "Select at least one reminder",
                              ),
                            );
                          }
                        },
                        child: floatBtn2(title: "Delete Reminder"),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w1p * 4,
                        vertical: 12,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (isVideoCall)
                            Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8,
                              ),
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.support_agent,
                                          size: 30,
                                          color: clr2E3192,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Need Assistance?',
                                          style: t500_16.copyWith(
                                            color: clr202020,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Connect live with a consultant pharmacist for your medicine-related doubts.',
                                      style: t400_14.copyWith(color: clr202020),
                                    ),
                                    const SizedBox(height: 16),
                                    Center(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          showComingSoonDialog(context);
                                        },
                                        icon: Icon(
                                          Icons.video_call,
                                          color: clrFFFFFF,
                                        ),
                                        label: Text(
                                          'Start Video Call',
                                          style: t500_16,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              clr2E3192, // Your app's primary color
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              25.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                isVideoCall = !isVideoCall;
                                if (mounted) setState(() {});
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Icon(
                                    Icons.support_agent,
                                    size: 40,
                                    color: clr2E3192,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          verticalSpace(h1p * 2),
                          ButtonWidget(
                            btnText: AppLocalizations.of(context)!.addAReminder,
                            ontap: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) => SafeArea(
                                  child: SizedBox(
                                    height: 140,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        textBtn(
                                          title: AppLocalizations.of(
                                            context,
                                          )!.addFromPrescription,
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const PrescribedMedicinesScreen(),
                                              ),
                                            );
                                          },
                                        ),
                                        textBtn(
                                          title: AppLocalizations.of(
                                            context,
                                          )!.addNew,
                                          onPressed: () async {
                                            DrugItem?
                                            res = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => SelectMedicine(
                                                  title: AppLocalizations.of(
                                                    context,
                                                  )!.addReminder,
                                                ),
                                              ),
                                            );
                                            if (res != null) {
                                              Navigator.pop(context);

                                              getIt<HomeManager>().setTitle(
                                                res.title ?? "",
                                              );
                                              var res2 = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const SetReminderScreen(
                                                        isCreatingNew: true,
                                                      ),
                                                ),
                                              );
                                              if (res2 != null) {
                                                getIt<HomeManager>()
                                                    .getReminderList();

                                                Fluttertoast.showToast(
                                                  msg: res2,
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            isLoading: false,
                          ),
                        ],
                      ),
                    ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            );
          },
        );
      },
    );
  }
}

class ReminderContainer extends StatelessWidget {
  final double w1p;
  final double h1p;
  final ReminderItem drg;
  final Function ontap;

  const ReminderContainer({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.drg,
    required this.ontap,
  });

  // bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    bool markEnabled = Provider.of<HomeManager>(context).enableMark;
    List<int> markedReminders = Provider.of<HomeManager>(
      context,
    ).markedReminderList;

    // bool isDailyMedicine = drg.dailyMedication ??false;
    String drugname = drg.title ?? "";

    String intertvalType = drg.medicineIntervalType ?? "";
    // int? interval = drg.interval;
    // String durationType = drg.durationType ??"";
    // String intervalType = drg.interval ??"";
    // String interval = drg.interval ??"";
    // String dosage = drg.dosage ??"";
    // String drugduration = '${drg.duration ?? ""}';
    // String mornDosage = '${drg.morningDosage ?? ""}';
    // String afternDosage = '${drg.afternoonDosage ?? ""}';
    // String evenDosage = '${drg.eveningDosage ?? ""}';
    // String nightDosage = '${drg.nightDosage ?? ""}';

    String subtitle = drg.dosageTime != null
        ? drg.dosageTime!
              .map((e) => getIt<StateManager>().convertTime(e.time!))
              .toList()
              .join(" | ")
        : "";
    String subtitle2 = 'Every ${drg.interval} days ';
    // String durationtext = 'Duration:  ${getIt<StateManager>().getDayLabel(drg.duration!)}  ';

    return GestureDetector(
      onTap: () async {
        if (!markEnabled) {
          getIt<HomeManager>().setReminderModelFromReminders(drg);

          var res2 = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SetReminderScreen(reminderId: drg.id),
            ),
          );
          if (res2 != null) {
            Fluttertoast.showToast(msg: res2);
            getIt<HomeManager>().getReminderList();
          }
        } else {
          getIt<HomeManager>().markReminder(drg.id!);
        }
      },
      onLongPress: () {
        getIt<HomeManager>().markReminder(drg.id!);

        getIt<HomeManager>().reminderListMarkValueChange();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: w1p * 5, vertical: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [boxShadow8],
          // color: Colours.couponBgClr,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // Positioned(bottom:-10,left:0,child: SizedBox(width:100,height:100,child: SvgPicture.asset("assets/images/start-eclip1.svg",color: Colours.primaryblue,))),
            // Positioned(top:-10,right:0,child: RotatedBox(quarterTurns:0,child: SizedBox(width:80,height:80,child: Icon(Icons.medical_services_rounded,color: Colours.primaryblue.withOpacity(0.1),size: 40,)))),
            pad(
              horizontal: w1p * 4,
              vertical: h1p * 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GenericExpandableText(
                              textAlign: TextAlign.start,
                              getIt<StateManager>().capitalizeFirstLetter(
                                drugname,
                              ),
                              style: t500_14.copyWith(
                                color: const Color(0xff474747),
                              ),
                              readlessColor: Colours.primaryblue,
                              readmoreColor: Colours.primaryblue,
                              hasReadMore: true,
                              maxLines: 2,
                            ),
                            verticalSpace(h1p),
                            Text(
                              intertvalType == "Everyday"
                                  ? subtitle
                                  : subtitle2,
                              style: t400_12.copyWith(
                                color: clr444444,
                                height: 1.4,
                              ),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Text(durationtext,style: t400_13.copyWith(color: clr444444, height: 1.4),maxLines:5,overflow: TextOverflow.ellipsis),
                            // Text(drg.toJson().toString(),style: t400_13.copyWith(color: clr444444, height: 1.4),maxLines:5,overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      horizontalSpace(w1p * 7),
                      markEnabled
                          ? Entry(
                              xOffset: -10,
                              // scale: 20,
                              delay: const Duration(milliseconds: 200),
                              duration: const Duration(milliseconds: 50),
                              curve: Curves.ease,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                width: 24,
                                height: 24,
                                child: markEnabled
                                    ? SvgPicture.asset(
                                        markedReminders.contains(drg.id)
                                            ? "assets/images/mark-icon.svg"
                                            : "assets/images/unmark-icon.svg",
                                      )
                                    : const SizedBox(),
                              ),
                            )
                          : const SizedBox(),
                      markEnabled
                          ? const SizedBox()
                          : Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                splashRadius: 20,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                activeColor: Colours.primaryblue,
                                value: drg.status == "1" ? true : false,
                                onChanged: (value) async {
                                  var res = await getIt<HomeManager>()
                                      .changeReminderStatus(drg.id!);
                                  if (res.status == true) {
                                    getIt<HomeManager>().getReminderList();
                                  }
                                },
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
    );
  }
}
