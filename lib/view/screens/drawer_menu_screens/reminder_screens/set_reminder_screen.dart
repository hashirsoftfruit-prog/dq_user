// ignore_for_file: use_build_context_synchronously

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/reminder_screens/reminder_screens_widgets.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/reminder_screens/time_interval_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../controller/managers/state_manager.dart';
import '../../../../model/core/basic_response_model.dart';
import '../../../../model/core/reminder_model.dart';
import '../../../../model/helper/service_locator.dart';
import '../../../theme/constants.dart';
import 'days_interval_screen.dart';

class SetReminderScreen extends StatefulWidget {
  final int? reminderId;
  final bool? isCreatingNew;

  const SetReminderScreen({super.key, this.reminderId, this.isCreatingNew});

  @override
  State<SetReminderScreen> createState() => _SetReminderScreenState();
}

class _SetReminderScreenState extends State<SetReminderScreen>
    with TickerProviderStateMixin {
  // AvailableDocsModel docsData;
  // int index = 1;

  // @override
  // void initState() {
  // getIt<HomeManager>().getReminderBindingData();
  // _controller.addListener(_scrollListener);
  // }

  // final ScrollController _controller = ScrollController();
  //
  // void _scrollListener()async {
  //   if (_controller.position.pixels == _controller.position.maxScrollExtent) {
  //     index++;
  //     getIt<HomeManager>().getConsultaions(index:index );
  //   }
  // }

  @override
  void dispose() {
    getIt<HomeManager>().disposeSetReminder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scollCntr = ScrollController();
    List<Color> colors = [clr8467A6, clr5D5AAB];

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        // BoxDecoration bxDec = BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xffECECEC).withOpacity(0.8));

        getTitle(title) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 12),
            child: Text(
              title,
              style: t400_12.copyWith(color: const Color(0xff6F6F6F)),
            ),
          );
        }

        BasicResponseModel checkCondition(AddReminderModel data) {
          String? message = data.title == null
              ? "Title should not be empty"
              : data.timeAndDoses == null || data.timeAndDoses!.isEmpty
              ? "Time and Dosage should be given"
              : data.dayDuration == null
              ? "Please specify duration"
              : null;

          return BasicResponseModel(status: message == null, message: message);
        }

        getSubTitle(String title) {
          return Text(
            title,
            style: t400_14.copyWith(color: const Color(0xff474747)),
            overflow: TextOverflow.ellipsis,
          );
        }

        // floatBtn({required String title,required AddReminderModel addReminderModel,required bool loader,}){return;}
        // textBtn({required String title,required Function onPressed}){return InkWell(
        //     onTap: (){
        //       onPressed();
        //     },
        //   child: Padding(
        //     padding:  EdgeInsets.symmetric(horizontal: w1p*5,vertical: 8),
        //     child: Container(width: maxWidth,height: 40,
        //       child: Text(title,style: t500_14.copyWith(color: clr444444),),
        //     ),
        //   ),
        // );}

        return Consumer<HomeManager>(
          builder: (context, mgr, child) {
            return Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.white,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              body: CustomScrollView(
                controller: scollCntr,
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: 130,
                    collapsedHeight: 90,
                    pinned: true,
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: colors),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const Spacer(),
                            const Spacer(),
                            // const Spacer(),
                            verticalSpace(20),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      // Navigator.popUntil(context, ModalRoute.withName(RouteNames.home));
                                    },
                                    child: SizedBox(
                                      height: 20,
                                      child: Image.asset(
                                        "assets/images/back-cupertino.png",
                                        color: Colors.white,
                                        // colorFilter: ColorFilter.mode(
                                        //     clrFFFFFF, BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                  verticalSpace(20),
                                  Text(
                                    "Set Your",
                                    style: t400_16.copyWith(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text("Medicine Reminder", style: t500_20),

                                  // Text(
                                  //       "Consultations",
                                  //       style: t500_20,
                                  //     ),
                                  verticalSpace(10),
                                ],
                              ),
                            ),

                            // const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 50,
                          horizontal: 25,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 0,
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Stay Consistent with your doses for better health. ",
                                style: t700_16.copyWith(color: Colors.black),
                              ),
                              verticalSpace(0),

                              getTitle(AppLocalizations.of(context)!.title),
                              ContainerWidget(
                                removeArrow: true,
                                child: getSubTitle(
                                  mgr.addReminderModel.title ?? "",
                                ),
                              ),

                              widget.isCreatingNew == true
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        getTitle(
                                          AppLocalizations.of(context)!.type,
                                        ),
                                        ReminderDropDown(
                                          type: "REMINDERTYPE",
                                          selected:
                                              mgr
                                                  .addReminderModel
                                                  .reminderType ??
                                              StringConstants.medicine,
                                          list: [
                                            BasicListItem(
                                              id: 0,
                                              item: StringConstants.medicine,
                                            ),
                                            BasicListItem(
                                              id: 1,
                                              item: StringConstants.other,
                                            ),
                                          ],
                                          fn: (val) {
                                            getIt<HomeManager>()
                                                .changeReminderType(val.item);
                                          },
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),

                              getTitle(
                                AppLocalizations.of(context)!.timeAndDosage,
                              ),
                              ContainerWidget(
                                ontap: () {
                                  if (mgr.addReminderModel.timeAndDoses ==
                                          null ||
                                      mgr
                                          .addReminderModel
                                          .timeAndDoses!
                                          .isEmpty) {
                                    getIt<HomeManager>().setAddReminderModel();
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const TimeIntervalsScreen(),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: w10p * 6,
                                  child: getSubTitle(
                                    mgr.addReminderModel.timeAndDoses != null &&
                                            mgr
                                                .addReminderModel
                                                .timeAndDoses!
                                                .isNotEmpty
                                        ? mgr.addReminderModel.timeAndDoses!
                                              .map((e) => e.time)
                                              .toList()
                                              .join(" | ")
                                        : "Set intervals, dosage & Time",
                                  ),
                                ),
                              ),

                              getTitle(AppLocalizations.of(context)!.days),
                              InkWell(
                                onTap: () async {
                                  DaysIntervalModel? res = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DaysIntervalScreen(
                                        DaysIntervalModel(
                                          noOfDays:
                                              mgr.addReminderModel.interval,
                                          isDaily: mgr
                                              .addReminderModel
                                              .isDailyMedication,
                                          date: mgr
                                              .addReminderModel
                                              .intervalStartDate,
                                        ),
                                      ),
                                    ),
                                  );
                                  if (res != null) {
                                    getIt<HomeManager>().setDaysIntervalData(
                                      res,
                                    );
                                  }
                                },
                                child: ContainerWidget(
                                  child: getSubTitle(
                                    mgr.addReminderModel.isDailyMedication ==
                                            false
                                        ? 'Every ${mgr.addReminderModel.interval} days'
                                        : "Everyday",
                                  ),
                                ),
                              ),

                              getTitle(AppLocalizations.of(context)!.duration),
                              // ContainerWidget(
                              //   child: getSubTitle("5 Days"),
                              //
                              // ),
                              ReminderDropDown(
                                type: "DURATION",
                                selected:
                                    mgr.addReminderModel.dayDuration != null
                                    ? getIt<StateManager>().getDayLabel(
                                        mgr.addReminderModel.dayDuration!,
                                      )
                                    : null,
                                list: [1, 2, 3, 4, 5, 7, 14, 30, 60, 180, 365]
                                    .map(
                                      (e) => BasicListItem(
                                        id: e,
                                        item: getIt<StateManager>().getDayLabel(
                                          e,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                fn: (val) {
                                  getIt<HomeManager>().setDurationCount(
                                    val.id!,
                                  );
                                },
                              ),

                              Padding(
                                padding: EdgeInsets.all(w1p * 5),
                                child: ButtonWidget(
                                  color: Colors.black,
                                  btnText: widget.reminderId == null
                                      ? AppLocalizations.of(
                                          context,
                                        )!.addAReminder
                                      : AppLocalizations.of(
                                          context,
                                        )!.updateReminder,
                                  isLoading: mgr.reminderLoader,
                                  ontap: () async {
                                    if (widget.reminderId == null) {
                                      BasicResponseModel result =
                                          checkCondition(mgr.addReminderModel);

                                      if (result.status == true) {
                                        var res = await getIt<HomeManager>()
                                            .savePrescriptionReminder();
                                        if (res.status == true) {
                                          Navigator.pop(context, res.message);
                                        } else {
                                          showTopSnackBar(
                                            snackBarPosition:
                                                SnackBarPosition.bottom,
                                            padding: const EdgeInsets.all(30),
                                            Overlay.of(context),
                                            ErrorToast(
                                              maxLines: 4,
                                              message: res.message ?? "",
                                            ),
                                          );
                                        }
                                      } else {
                                        showTopSnackBar(
                                          snackBarPosition:
                                              SnackBarPosition.bottom,
                                          padding: const EdgeInsets.all(30),
                                          Overlay.of(context),
                                          ErrorToast(
                                            maxLines: 4,
                                            message: result.message ?? "",
                                          ),
                                        );
                                      }
                                    } else {
                                      var res = await getIt<HomeManager>()
                                          .updateReminder(widget.reminderId!);
                                      if (res.status == true) {
                                        Navigator.pop(context, res.message);
                                      } else {
                                        showTopSnackBar(
                                          snackBarPosition:
                                              SnackBarPosition.bottom,
                                          padding: const EdgeInsets.all(30),
                                          Overlay.of(context),
                                          ErrorToast(
                                            maxLines: 4,
                                            message: res.message ?? "",
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),

                              if (widget.reminderId != null)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 5,
                                  ),
                                  child: ButtonWidget(
                                    color: Colors.white,
                                    border: Border.all(),
                                    textColor: Colors.black,
                                    btnText: AppLocalizations.of(
                                      context,
                                    )!.deleteTheReminder,
                                    isLoading: mgr.reminderLoader,
                                    ontap: () async {
                                      bool? result = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DeleteReminderPopup(
                                            w1p: w1p,
                                            h1p: h1p,
                                          );
                                        },
                                      );
                                      if (result != true) return;
                                      var res = await getIt<HomeManager>()
                                          .deleteReminder([widget.reminderId!]);

                                      if (res.status == true) {
                                        getIt<HomeManager>()
                                            .reminderListMarkValueChange(
                                              val: false,
                                            );
                                        getIt<HomeManager>().getReminderList();
                                        Navigator.of(context).pop();
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
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            );

            //           return Scaffold(
            //             // extendBody: true,
            //             backgroundColor: Colors.white,

            //             appBar: getIt<SmallWidgets>().appBarWidget(
            //                 title: AppLocalizations.of(context)!.reminder,
            //                 height: h10p,
            //                 width: w10p,
            //                 fn: () {
            //                   Navigator.pop(context);
            //                 }),
            //             body: pad(
            //               horizontal: w1p * 5,
            //               child: RefreshIndicator(
            //                 onRefresh: () async {
            //                   await getIt<HomeManager>().getOffersList();
            //                 },
            //                 child: ListView(
            //                   // controller: _controller,
            //                   children: [
            //                     verticalSpace(h1p * 2),

            //                     getTitle(AppLocalizations.of(context)!.title),
            //                     ContainerWidget(
            //                       removeArrow: true,
            //                       child: getSubTitle(mgr.addReminderModel.title ?? ""),
            //                     ),

            //                     widget.isCreatingNew == true
            //                         ? Column(
            //                             crossAxisAlignment: CrossAxisAlignment.start,
            //                             children: [
            //                               getTitle(AppLocalizations.of(context)!.type),
            //                               ReminderDropDown(
            //                                   type: "REMINDERTYPE",
            //                                   selected: mgr.addReminderModel.reminderType ??
            //                                       StringConstants.medicine,
            //                                   list: [
            //                                     BasicListItem(
            //                                         id: 0, item: StringConstants.medicine),
            //                                     BasicListItem(
            //                                         id: 1, item: StringConstants.other)
            //                                   ],
            //                                   fn: (val) {
            //                                     getIt<HomeManager>()
            //                                         .changeReminderType(val.item);
            //                                   }),
            //                             ],
            //                           )
            //                         : const SizedBox(),

            //                     getTitle(AppLocalizations.of(context)!.timeAndDosage),
            //                     ContainerWidget(
            //                       ontap: () {
            //                         if (mgr.addReminderModel.timeAndDoses == null ||
            //                             mgr.addReminderModel.timeAndDoses!.isEmpty) {
            //                           getIt<HomeManager>().setAddReminderModel();
            //                         }
            //                         Navigator.push(
            //                             context,
            //                             MaterialPageRoute(
            //                                 builder: (_) => const TimeIntervalsScreen()));
            //                       },
            //                       child: SizedBox(
            //                         width: w10p * 6,
            //                         child: getSubTitle(mgr.addReminderModel.timeAndDoses !=
            //                                     null &&
            //                                 mgr.addReminderModel.timeAndDoses!.isNotEmpty
            //                             ? mgr.addReminderModel.timeAndDoses!
            //                                 .map((e) => e.time)
            //                                 .toList()
            //                                 .join(" | ")
            //                             : "Set intervals, dosage & Time"),
            //                       ),
            //                     ),

            //                     getTitle(AppLocalizations.of(context)!.days),
            //                     InkWell(
            //                       onTap: () async {
            //                         DaysIntervalModel? res = await Navigator.push(
            //                             context,
            //                             MaterialPageRoute(
            //                                 builder: (_) => DaysIntervalScreen(
            //                                     DaysIntervalModel(
            //                                         noOfDays: mgr.addReminderModel.interval,
            //                                         isDaily: mgr
            //                                             .addReminderModel.isDailyMedication,
            //                                         date: mgr.addReminderModel
            //                                             .intervalStartDate))));
            //                         if (res != null) {
            //                           getIt<HomeManager>().setDaysIntervalData(res);
            //                         }
            //                       },
            //                       child: ContainerWidget(
            //                         child: getSubTitle(
            //                             mgr.addReminderModel.isDailyMedication == false
            //                                 ? 'Every ${mgr.addReminderModel.interval} days'
            //                                 : "Everyday"),
            //                       ),
            //                     ),

            //                     getTitle(AppLocalizations.of(context)!.duration),
            //                     // ContainerWidget(
            //                     //   child: getSubTitle("5 Days"),
            //                     //
            //                     // ),
            //                     ReminderDropDown(
            //                         type: "DURATION",
            //                         selected: mgr.addReminderModel.dayDuration != null
            //                             ? getIt<StateManager>()
            //                                 .getDayLabel(mgr.addReminderModel.dayDuration!)
            //                             : null,
            //                         list: [1, 2, 3, 4, 5, 7, 14, 30, 60, 180, 365]
            //                             .map((e) => BasicListItem(
            //                                 id: e,
            //                                 item: getIt<StateManager>().getDayLabel(e)))
            //                             .toList(),
            //                         fn: (val) {
            //                           getIt<HomeManager>().setDurationCount(val.id!);
            //                         }),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //             floatingActionButton:

            // //               floatBtn(title:widget.reminderId==null?
            // // AppLocalizations.of(context)!.addAReminder:AppLocalizations.of(context)!.updateReminder,
            // //                   loader: mgr.reminderLoader,
            // //                   addReminderModel:mgr.addReminderModel
            //                 Padding(
            //               padding: EdgeInsets.all(w1p * 5),
            //               child: ButtonWidget(
            //                 btnText: widget.reminderId == null
            //                     ? AppLocalizations.of(context)!.addAReminder
            //                     : AppLocalizations.of(context)!.updateReminder,
            //                 isLoading: mgr.reminderLoader,
            //                 ontap: () async {
            //                   if (widget.reminderId == null) {
            //                     BasicResponseModel result =
            //                         checkCondition(mgr.addReminderModel);

            //                     if (result.status == true) {
            //                       var res =
            //                           await getIt<HomeManager>().savePrescriptionReminder();
            //                       if (res.status == true) {
            //                         Navigator.pop(context, res.message);
            //                       } else {
            //                         showTopSnackBar(
            //                             snackBarPosition: SnackBarPosition.bottom,
            //                             padding: const EdgeInsets.all(30),
            //                             Overlay.of(context),
            //                             ErrorToast(
            //                               maxLines: 4,
            //                               message: res.message ?? "",
            //                             ));
            //                       }
            //                     } else {
            //                       showTopSnackBar(
            //                           snackBarPosition: SnackBarPosition.bottom,
            //                           padding: const EdgeInsets.all(30),
            //                           Overlay.of(context),
            //                           ErrorToast(
            //                             maxLines: 4,
            //                             message: result.message ?? "",
            //                           ));
            //                     }
            //                   } else {
            //                     var res = await getIt<HomeManager>()
            //                         .updateReminder(widget.reminderId!);
            //                     if (res.status == true) {
            //                       Navigator.pop(context, res.message);
            //                     } else {
            //                       showTopSnackBar(
            //                           snackBarPosition: SnackBarPosition.bottom,
            //                           padding: const EdgeInsets.all(30),
            //                           Overlay.of(context),
            //                           ErrorToast(
            //                             maxLines: 4,
            //                             message: res.message ?? "",
            //                           ));
            //                     }
            //                   }
            //                 },
            //               ),
            //             ),
            //             floatingActionButtonLocation:
            //                 FloatingActionButtonLocation.centerDocked,
            //           );
          },
        );
      },
    );
  }
}

class ReminderDropDown extends StatelessWidget {
  final List<BasicListItem> list;
  final Function(BasicListItem v) fn;
  final String? selected;
  final String type;
  const ReminderDropDown({
    super.key,
    required this.list,
    required this.fn,
    required this.selected,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: w1p*5),
      decoration: BoxDecoration(
        color: const Color(0xffECECEC),
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [  BoxShadow(color: Colors.grey.shade200,spreadRadius: 1.5,blurRadius: 1)]
      ),
      child: CustomDropdown<BasicListItem>(
        decoration: CustomDropdownDecoration(
          closedFillColor: Colors.transparent,
          listItemStyle: t500_14.copyWith(color: clr444444),
          headerStyle: t500_14.copyWith(color: const Color(0xff474747)),
          hintStyle: t400_13.copyWith(color: const Color(0xff474747)),
          // closedBorder:Border.all(color: Colours.lightBlu)
        ),
        hintText:
            selected ??
            (type == "DURATION" ? 'Select Duration' : 'Select treatment type'),
        closedHeaderPadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 18,
        ),
        items: list,
        listItemBuilder: (context, item, isSelected, onItemSelect) {
          return GestureDetector(
            onTap: () {
              onItemSelect(); // Trigger the selection
            },
            child: Container(
              color: isSelected ? Colors.grey[300] : Colors.transparent,
              padding: const EdgeInsets.all(2),
              child: Text(
                item.item ??
                    'No title', // Assuming `Treatments` has a `title` property
                style: isSelected
                    ? const TextStyle(fontWeight: FontWeight.bold)
                    : t500_14.copyWith(color: clr444444),
              ),
            ),
          );
        },
        headerBuilder: (context, item, selectedItem) {
          return Container(
            padding: const EdgeInsets.all(2),
            child: Text(
              selected ??
                  'No title', // Assuming `Treatments` has a `title` property
              style: t500_14.copyWith(color: const Color(0xff474747)),
            ),
          );
        },
        // .map((e)=>e.title!).toList(),
        // initialItem: list[0],
        onChanged: (value) {
          if (value != null) {
            fn(value);
          }
        },
      ),
    );
  }
}

class ContainerWidget extends StatelessWidget {
  final Widget child;
  final bool? removeArrow;
  final Function()? ontap;
  const ContainerWidget({
    super.key,
    required this.child,
    this.removeArrow,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: double.infinity,

        // margin: EdgeInsets.symmetric(horizontal: w1p*5),
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(

          //   width: 1.0, // Border width
          //   style: BorderStyle.solid, // Border style (optional)
          // ),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              // spreadRadius: 1,
              blurRadius: 1,
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          // boxShadow: [ BoxShadow(color: Colors.grey.shade200,spreadRadius: 1.5,blurRadius: 1)]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              child,
              removeArrow != true
                  ? SizedBox(
                      height: 18,
                      child: SvgPicture.asset(
                        "assets/images/forward-arrow.svg",
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
