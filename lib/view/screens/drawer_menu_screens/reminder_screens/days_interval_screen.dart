import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/reminder_screens/time_interval_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
import '../../../../controller/managers/state_manager.dart';
import '../../../../model/helper/service_locator.dart';
import '../../../theme/constants.dart';

class DaysIntervalScreen extends StatefulWidget {
  final DaysIntervalModel data;
  const DaysIntervalScreen(this.data, {super.key});
  @override
  State<DaysIntervalScreen> createState() => _DaysIntervalScreenState();
}

class _DaysIntervalScreenState extends State<DaysIntervalScreen> {
  int? groupV;
  int? noOfDays;

  radioBtn(value) {
    return Radio(
      value: value,
      groupValue: groupV,
      onChanged: (val) {
        setState(() {
          groupV = val;
        });
      },
    );
  }

  addOrSubtractTime({required bool isAdd}) {
    if (isAdd && noOfDays! < 31) {
      setState(() => noOfDays = noOfDays! + 1);
    } else if (!isAdd && noOfDays! > 1) {
      setState(() => noOfDays = noOfDays! - 1);
    }
  }

  DateTime? selectedDate;
  @override
  void initState() {
    groupV = widget.data.isDaily == false ? 1 : 0;
    noOfDays = widget.data.noOfDays ?? 2;
    selectedDate = DateTime.parse(
      widget.data.date ?? DateTime.now().toString(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxHeight = constraints.maxHeight;
          double maxWidth = constraints.maxWidth;
          double h1p = maxHeight * 0.01;
          double h10p = maxHeight * 0.1;
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

          getSubTitle(String title) {
            return Text(
              title,
              style: t400_14.copyWith(color: const Color(0xff474747)),
              overflow: TextOverflow.ellipsis,
            );
          }

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
                        style: t400_12.copyWith(color: const Color(0xff474747)),
                      ),
                      subtitle != null
                          ? Text(
                              subtitle,
                              style: t500_10.copyWith(
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

          // getSubTitle(String title){
          //   return Text(title,style:t400_14.copyWith(color: Color(0xff474747)),overflow: TextOverflow.ellipsis,);
          // }

          floatBtn({required String title}) {
            return Padding(
              padding: EdgeInsets.all(w1p * 5),
              child: Container(
                width: maxWidth,
                height: 40,
                decoration: BoxDecoration(
                  gradient: linearGrad2,
                  borderRadius: BorderRadius.circular(8),
                  color: Colours.primaryblue,
                ),
                child: Center(
                  child: Text(
                    title,
                    style: t700_16.copyWith(color: const Color(0xffffffff)),
                  ),
                ),
              ),
            );
          }

          // textBtn({required String title, required Function onPressed}) {
          //   return InkWell(
          //     onTap: () {
          //       onPressed();
          //     },
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(horizontal: w1p * 5, vertical: 8),
          //       child: Container(
          //         width: maxWidth,
          //         height: 40,
          //         child: Text(
          //           title,
          //           style: t500_14.copyWith(color: clr444444),
          //         ),
          //       ),
          //     ),
          //   );
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
                  fn: () {
                    Navigator.pop(context);
                  },
                ),
                body: pad(
                  horizontal: w1p * 5,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      // await getIt<HomeManager>().getOffersList();
                    },
                    child: ListView(
                      // controller: _controller,
                      children: [
                        verticalSpace(h1p * 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.daily,
                              style: t500_14.copyWith(color: clr444444),
                            ),
                            radioBtn(0),
                          ],
                        ),
                        const Divider(color: Colours.lightBlu),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.inIntervalOfDays,
                              style: t500_14.copyWith(color: clr444444),
                            ),
                            radioBtn(1),
                          ],
                        ),
                        groupV == 1
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          getTitle("Start Date"),
                                          Container(
                                            width: w10p * 4,
                                            // margin: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                width: 0.5,
                                                color: Colors.black12,
                                              ),
                                              // boxShadow: [boxShadow5]
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: TimePickerSpinnerPopUp(
                                                mode: CupertinoDatePickerMode
                                                    .date,
                                                // initTime: DateTime.now(),
                                                minTime: DateTime.now(),
                                                // minTime: DateTime.now().subtract(const Duration(days: 10)),
                                                maxTime: DateTime.now().add(
                                                  const Duration(days: 10),
                                                ),
                                                barrierColor: Colors
                                                    .black12, //Barrier Color when pop up show
                                                minuteInterval: 1,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                      12,
                                                      10,
                                                      12,
                                                      10,
                                                    ),
                                                cancelText: 'Cancel',
                                                confirmText: 'OK',
                                                enable: true,
                                                timeWidgetBuilder: (v) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          1.0,
                                                        ),
                                                    child: getSubTitle(
                                                      getIt<StateManager>()
                                                          .convertStringDateToyMMMd(
                                                            selectedDate
                                                                .toString(),
                                                          ),
                                                    ),
                                                  );
                                                },
                                                radius: 10,
                                                pressType:
                                                    PressType.singlePress,
                                                timeFormat: 'hh : mm a',
                                                use24hFormat: false,
                                                // Customize your time widget
                                                // timeWidgetBuilder: (dateTime) {},
                                                // locale: const Locale('vi'),
                                                onChange: (dateTime) {
                                                  setState(() {
                                                    selectedDate = dateTime;
                                                  });
                                                },
                                              ),
                                            ),
                                            //     removeArrow: true,
                                            // ontap: (){
                                            //
                                            // },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          getTitle("Interval"),
                                          getRow(
                                            title: '$noOfDays days',
                                            subtractFn: () {
                                              addOrSubtractTime(isAdd: false);
                                            },
                                            addFn: () {
                                              addOrSubtractTime(isAdd: true);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const Divider(color: Colours.lightBlu),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: InkWell(
                  onTap: () {
                    Navigator.pop(
                      context,
                      DaysIntervalModel(
                        date: groupV == 0
                            ? DateTime.now().toString()
                            : selectedDate.toString(),
                        isDaily: groupV == 0 ? true : false,
                        noOfDays: groupV == 0 ? null : noOfDays,
                      ),
                    );
                  },
                  child: floatBtn(title: "Done"),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
              );
            },
          );
        },
      ),
    );
  }
}

class DaysIntervalModel {
  String? date;
  int? noOfDays;
  bool? isDaily;

  DaysIntervalModel({this.date, this.noOfDays, this.isDaily});
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
        // margin: EdgeInsets.symmetric(horizontal: w1p*5),
        decoration: BoxDecoration(
          color: const Color(0xffECECEC).withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
          // boxShadow: const [
          //   BoxShadow(color: Colors.grey.shade200,spreadRadius: 1.5,blurRadius: 1)
          // ],
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
