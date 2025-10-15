import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/reminder_screens/reminder_screens_widgets.dart';
import 'package:dqapp/view/screens/home_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/helper/service_locator.dart';
import '../../../theme/constants.dart';

class PrescribedMedicinesScreen extends StatefulWidget {
  const PrescribedMedicinesScreen({super.key});

  @override
  State<PrescribedMedicinesScreen> createState() =>
      _PrescribedMedicinesScreenState();
}

class _PrescribedMedicinesScreenState extends State<PrescribedMedicinesScreen> {
  // AvailableDocsModel docsData;
  // int index = 1;

  @override
  void initState() {
    super.initState();
    getIt<HomeManager>().getReminderPriscriptionList();
    // _controller.addListener(_scrollListener);
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
                title: AppLocalizations.of(context)!.addFromPrescription,
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
                    getIt<HomeManager>().getReminderPriscriptionList();
                  },
                  child: ListView(
                    // controller: _controller,
                    children: [
                      verticalSpace(h1p * 2),
                      mgr.reminderLoader == true &&
                              mgr.reminderPrescriptionList == null
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
                          : mgr.reminderPrescriptionList?.drugSerializer !=
                                    null &&
                                mgr
                                    .reminderPrescriptionList!
                                    .drugSerializer!
                                    .isNotEmpty
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
                                    mgr.reminderLoader == true
                                        ? subLoader
                                        : const SizedBox(),
                                    mgr
                                                    .reminderPrescriptionList!
                                                    .drugSerializer !=
                                                null &&
                                            mgr
                                                .reminderPrescriptionList!
                                                .drugSerializer!
                                                .isNotEmpty
                                        ? Column(
                                            children: mgr
                                                .reminderPrescriptionList!
                                                .drugSerializer!
                                                .map(
                                                  (e) =>
                                                      e.drugs != null &&
                                                          e.drugs!.isNotEmpty
                                                      ? Column(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                e.doctorFirstName ??
                                                                    "",
                                                                style: t400_12
                                                                    .copyWith(
                                                                      color: const Color(
                                                                        0xff6F6F6F,
                                                                      ),
                                                                    ),
                                                              ),
                                                            ),
                                                            const Divider(
                                                              color: Colours
                                                                  .appointBoxClr,
                                                            ),
                                                            ...e.drugs!
                                                                .map(
                                                                  (f) => pad(
                                                                    vertical: 0,
                                                                    horizontal:
                                                                        0,
                                                                    child: GestureDetector(
                                                                      onTap:
                                                                          () {},
                                                                      child: DrugContainer(
                                                                        drg: f,
                                                                        h1p:
                                                                            h1p,
                                                                        w1p:
                                                                            w1p,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                                .toList(),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                )
                                                .toList(),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(28.0),
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.youHaveNoPrescription,
                                                style: TextStyles
                                                    .notAvailableTxtStyle,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                    verticalSpace(h1p * 2),
                                  ],
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.youHaveNoPrescription,
                                  style: TextStyles.notAvailableTxtStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
