import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/controller/managers/state_manager.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/reminder_screens/days_interval_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_thumb_slider/multi_thumb_slider.dart';
import 'package:provider/provider.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
import '../../../../model/core/basic_response_model.dart';
import '../../../../model/core/reminder_model.dart';
import '../../../../model/helper/service_locator.dart';
import '../../../theme/constants.dart';

class TimeIntervalsScreen extends StatefulWidget {
  const TimeIntervalsScreen({super.key});

  // TimeIntervalsScreen();

  @override
  State<TimeIntervalsScreen> createState() => _TimeIntervalsScreenState();
}

class _TimeIntervalsScreenState extends State<TimeIntervalsScreen> {
  // AvailableDocsModel docsData;
  // int index = 1;

  // @override
  // void initState() {
  //   // getIt<HomeManager>().getReminderBindingData();
  //   // _controller.addListener(_scrollListener);

  // }

  // final ScrollController _controller = ScrollController();
  //
  // void _scrollListener()async {
  //   if (_controller.position.pixels == _controller.position.maxScrollExtent) {
  //     index++;
  //     getIt<HomeManager>().getConsultaions(index:index );
  //   }
  // }
  MultiThumbSliderController controller = MultiThumbSliderController();

  // List<double> stops = [0.0,0.3,0.4,0.5,0.6,1.0];

  @override
  Widget build(BuildContext context) {
    List<TimeAndDoses> data = Provider.of<HomeManager>(
      context,
    ).addReminderModel.timeAndDoses!;

    AddReminderModel addReminderModel = Provider.of<HomeManager>(
      context,
    ).addReminderModel;
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        // double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        getRow({
          required String title,
          String? subtitle,
          required Function subtractFn,
          required Function addFn,
        }) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BtnWidget(
                ontap: () {
                  subtractFn();
                },
                isAdd: false,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: t400_16.copyWith(color: const Color(0xff474747)),
                    ),
                    subtitle != null
                        ? Text(
                            subtitle,
                            style: t500_14.copyWith(
                              color: const Color(0xff474747),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              BtnWidget(
                ontap: () {
                  addFn();
                },
                isAdd: true,
              ),
            ],
          );
        }

        getTitle(title) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 12),
            child: Text(
              title,
              style: t400_12.copyWith(color: const Color(0xff6F6F6F)),
            ),
          );
        }

        floatBtn({required String title}) {
          return Padding(
            padding: EdgeInsets.all(w1p * 5),
            child: ButtonWidget(
              color: Colors.black,
              btnText: title,
              ontap: () {
                Navigator.pop(context);
              },
              // padding: EdgeInsets.all(w1p * 5),
            ),
          );
        }

        return Consumer<HomeManager>(
          builder: (context, mgr, child) {
            return Scaffold(
              // extendBody: true,
              backgroundColor: Colors.white,
              appBar: getIt<SmallWidgets>().appBarWidget(
                title: AppLocalizations.of(context)!.reminder,
                height: h10p,
                width: w10p,
                fn: () {
                  Navigator.pop(context);
                },
              ),
              body: Padding(
                padding: EdgeInsets.fromLTRB(w1p * 5, 0, w1p * 5, h10p * 1.1),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await getIt<HomeManager>().getOffersList();
                  },
                  child: ListView(
                    // controller: _controller,
                    children: [
                      getTitle(AppLocalizations.of(context)!.howManyTimesADay),
                      getRow(
                        title: data.length.toString(),
                        subtractFn: () {
                          getIt<HomeManager>().addOrSubtractTime(isAdd: false);
                        },
                        addFn: () {
                          getIt<HomeManager>().addOrSubtractTime(isAdd: true);
                        },
                      ),

                      getTitle(
                        "${AppLocalizations.of(context)!.dosage} (${data.length} ${AppLocalizations.of(context)!.intervals})",
                      ),
                      // getTitle("Dosage (${data.length} intervals )"),
                      Wrap(
                        children: data.map((e) {
                          var i = data.indexOf(e);

                          return Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 0.5,
                                color: Colors.black12,
                              ),
                              // boxShadow: [boxShadow5]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () async {
                                  var t = await showTimePicker(
                                    context: context,
                                    initialTime: getIt<StateManager>()
                                        .getTimeOfDayFromString(e.time!),
                                  );
                                  if (t != null) {
                                    getIt<HomeManager>().changeTime(
                                      index: i,
                                      time: getIt<StateManager>()
                                          .getStringFromTimeOfDay(t),
                                    );
                                  }
                                },
                                child: getRow(
                                  title: e.dose.toString(),
                                  subtitle: e.time.toString(),
                                  subtractFn: () {
                                    getIt<HomeManager>().addDosage(
                                      isAdd: false,
                                      index: i,
                                    );
                                  },
                                  addFn: () {
                                    getIt<HomeManager>().addDosage(
                                      isAdd: true,
                                      index: i,
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      data.length < 5
                          ? getTitle(AppLocalizations.of(context)!.time)
                          : const SizedBox(),

                      data.length < 5
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: MultiThumbSlider(
                                controller: controller,
                                overdragBehaviour: ThumbOverdragBehaviour.stop,
                                lockBehaviour: ThumbLockBehaviour.both,
                                valuesChanged: (values) {
                                  // print(values);
                                  // setState(() {
                                  // stops = values;
                                  // print(values.map((f)=>getIt<StateManager>().convertSliderValueToTime(f)).toList());
                                  // });
                                  List<double> lst = values;
                                  lst.removeAt(0);
                                  lst.removeAt(values.length - 1);
                                  // print("lst.lengthlst.length");
                                  // print(lst.length);
                                  // print(lst.length);
                                  getIt<HomeManager>().setAddReminderModel(
                                    val: "dfdf",
                                    scrollValues: lst,
                                  );
                                },
                                // initalSliderValues: data.map((e)=>e.scrollValue).toList().insert(0, 0.0),
                                initalSliderValues: [
                                  0,
                                  ...data.map((e) => e.scrollValue).toList(),
                                  1,
                                ],
                                thumbBuilder: (context, index) {
                                  List<TimeAndDoses> lst = [
                                    TimeAndDoses(scrollValue: 0),
                                    ...data,
                                    TimeAndDoses(scrollValue: 1),
                                  ];

                                  if (index != 0 && index != lst.length - 1) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // DefaultThumb(
                                        // color: Colors.blue,
                                        //                         ),
                                        Text(
                                          index % 2 != 0
                                              ? lst[index].time.toString()
                                              : "",
                                          style: t400_11.copyWith(
                                            color: const Color(0xff474747),
                                          ),
                                        ),
                                        Container(
                                          width: 13,
                                          height: 13,
                                          decoration: const BoxDecoration(
                                            color: Colours.primaryblue,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Text(
                                          index % 2 == 0
                                              ? lst[index].time.toString()
                                              : "",
                                          style: t400_11.copyWith(
                                            color: const Color(0xff474747),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                                // background: customBackground
                                //     ? Container(
                                //   decoration: BoxDecoration(
                                //     gradient: LinearGradient(
                                //         colors: List.from(colors),
                                //         begin: Alignment.centerLeft,
                                //         end: Alignment.centerRight,
                                //         stops: List.from(stops)),
                                //   ),
                                // )
                                //     : null,
                              ),
                            )
                          : Row(
                              children: [
                                StartTimeEndTime(
                                  title: "Start time",
                                  timeText: addReminderModel.startTime != null
                                      ? getIt<StateManager>()
                                            .getTimefromDatetimeString(
                                              addReminderModel.startTime!,
                                            )
                                      : data.first.time!,
                                  fn: (val) {
                                    getIt<HomeManager>()
                                        .changeStartTimeOrEndTime(
                                          date: val,
                                          isStartTime: true,
                                        );
                                  },
                                ),
                                horizontalSpace(8),
                                StartTimeEndTime(
                                  title: "End time",
                                  timeText: addReminderModel.endTime != null
                                      ? getIt<StateManager>()
                                            .getTimefromDatetimeString(
                                              addReminderModel.endTime!,
                                            )
                                      : data.last.time!,
                                  fn: (val) {
                                    getIt<HomeManager>()
                                        .changeStartTimeOrEndTime(
                                          date: val,
                                          isStartTime: false,
                                        );
                                  },
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: floatBtn(title: "Done"),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            );
          },
        );
      },
    );
  }
}

class StartTimeEndTime extends StatelessWidget {
  final String title;
  final String timeText;
  final Function(DateTime val) fn;

  const StartTimeEndTime({
    super.key,
    required this.title,
    required this.timeText,
    required this.fn,
  });

  @override
  Widget build(BuildContext context) {
    getTitle(title) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 12),
        child: Text(
          title,
          style: t400_12.copyWith(color: const Color(0xff6F6F6F)),
        ),
      );
    }

    getSubTitle(String title) {
      return Text(
        title,
        style: t400_14.copyWith(color: const Color(0xff474747)),
        overflow: TextOverflow.ellipsis,
      );
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.max,
        children: [
          getTitle(title),
          // ContainerWidget(child: getSubTitle("sdsd"),
          //   ontap: (){
          //
          //   },
          // ),
          Row(
            children: [
              // Expanded(
              //   child: Container(decoration: BoxDecoration(border: Border.all()),
              //
              //       child:Text(timeText)),
              // ),
              TimePickerSpinnerPopUp(
                mode: CupertinoDatePickerMode.time,
                initTime: getIt<StateManager>().getTimeToDateTime(timeText),
                // minTime: DateTime.now().subtract(const Duration(days: 10)),
                // maxTime: DateTime.now().add(const Duration(days: 10)),
                barrierColor: Colors.black12, //Barrier Color when pop up show
                minuteInterval: 1,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                cancelText: 'Cancel',
                confirmText: 'OK',
                enable: true,
                timeWidgetBuilder: (v) {
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ContainerWidget(child: getSubTitle(timeText)),
                  );
                },
                radius: 10,
                pressType: PressType.singlePress,
                timeFormat: 'hh : mm a',
                use24hFormat: false,
                // Customize your time widget
                // timeWidgetBuilder: (dateTime) {},
                // locale: const Locale('vi'),
                onChange: (dateTime) {
                  fn(dateTime);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReminderDropDown extends StatelessWidget {
  final List<BasicListItem> list;
  const ReminderDropDown(this.list, {super.key});

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
        hintText: 'Type',
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
        headerBuilder: (co0ntext, item, selected) {
          return Container(
            padding: const EdgeInsets.all(2),
            child: Text(
              item.item ??
                  'No title', // Assuming `Treatments` has a `title` property
              style: t500_14.copyWith(color: const Color(0xff474747)),
            ),
          );
        },
        // .map((e)=>e.title!).toList(),
        // initialItem: list[0],
        onChanged: (value) {
          // print("changed");
          if (value != null) {
            // getIt<HomeManager>().selectForumTreatmentItem(value);
          }
        },
      ),
    );
  }
}

class BtnWidget extends StatelessWidget {
  final bool isAdd;
  final Function()? ontap;
  const BtnWidget({super.key, required this.isAdd, this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [boxShadow7],
        ),
        height: 40,
        width: 30,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset(
            isAdd
                ? "assets/images/reminder-add-btn.svg"
                : "assets/images/reminder-subtract-btn.svg",
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
