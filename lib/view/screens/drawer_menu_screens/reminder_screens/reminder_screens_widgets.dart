import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/drawer_menu_screens/reminder_screens/set_reminder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:generic_expandable_text/expandable_text.dart';

import '../../../../controller/managers/home_manager.dart';
import '../../../../controller/managers/state_manager.dart';
import '../../../../model/core/reminder_binding_data_model.dart';
import '../../../../model/helper/service_locator.dart';
import '../../../theme/constants.dart';
import '../../../theme/text_styles.dart';

class DrugContainer extends StatelessWidget {
  final double w1p;
  final double h1p;
  final DrugSerializer drg;

  const DrugContainer({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.drg,
  });

  // bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    // bool isDailyMedicine = drg.dailyMedication ??false;
    String drugname = drg.drugName ?? "";
    // String subtitle = drg.medicineInstruction??"";
    String drugUnit = drg.drugUnit ?? "";
    // String durationType = drg.durationType ??"";
    // String intervalType = drg.intervalType ??"";
    // String interval = drg.interval ??"";
    // String dosage = drg.dosage ??"";
    String drugduration = getIt<StateManager>().getDayLabel(drg.duration ?? 0);
    // String mornDosage = '${drg.morningDosage ?? ""}';
    // String afternDosage = '${drg.afternoonDosage ?? ""}';
    // String evenDosage = '${drg.eveningDosage ?? ""}';
    // String nightDosage = '${drg.nightDosage ?? ""}';

    // String subtitle1 = '$mornDosage - $afternDosage - $evenDosage - $nightDosage $drugUnit ';
    // String subtitle2 = '$dosage $drugUnit \n $interval $intervalType ';
    String durationtext = '| $drugduration ';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colours.couponBgClr,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // Positioned(bottom:-10,left:0,child: SizedBox(width:100,height:100,child: SvgPicture.asset("assets/images/start-eclip1.svg",color: Colours.primaryblue,))),
          // Positioned(top:-10,right:0,child: RotatedBox(quarterTurns:0,child: SizedBox(width:80,height:80,child: Icon(Icons.medical_services_rounded,color: Colours.primaryblue.withOpacity(0.1),size: 40,)))),
          pad(
            horizontal: w1p * 4,
            vertical: 18,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // SizedBox(height: 38,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GenericExpandableText(
                            textAlign: TextAlign.start,
                            drugname,
                            style: t700_16.copyWith(
                              color: const Color(0xff3d41ad),
                              height: 1.1,
                            ),
                            readlessColor: Colours.primaryblue,
                            readmoreColor: Colours.primaryblue,
                            hasReadMore: true,
                            maxLines: 2,
                          ),
                          verticalSpace(h1p),
                          // Text(isDailyMedicine?subtitle1:subtitle2,style: t400_13.copyWith(color: clr444444, height: 1.4),maxLines:5,overflow: TextOverflow.ellipsis),
                          Text(
                            '$drugUnit $durationtext',
                            style: t400_13.copyWith(
                              color: clr444444,
                              height: 1.4,
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Text(drg.toJson().toString(),style: t400_13.copyWith(color: clr444444, height: 1.4),maxLines:5,overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    horizontalSpace(w1p * 7),
                    InkWell(
                      onTap: () async {
                        getIt<HomeManager>().setReminderModelFromPriscription(
                          drg,
                        );
                        var res = await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SetReminderScreen(),
                          ),
                        );

                        if (res != null) {
                          getIt<HomeManager>().getReminderList();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [boxShadow7],
                          ),
                          height: 30,
                          width: 30,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: SvgPicture.asset(
                              "assets/images/icon-add-green.svg",
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 48,child:
                // Row(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.start,
                //
                //   children: [
                //
                //   ],
                // )
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeleteReminderPopup extends StatelessWidget {
  final double w1p;
  final double h1p;

  const DeleteReminderPopup({super.key, required this.w1p, required this.h1p});

  @override
  Widget build(BuildContext context) {
    String msg = AppLocalizations.of(context)!.deleteTheReminder;
    // String msg2 = AppLocalizations.of(context)!.onlyTheMembersAddedUnderThisPackageWillRecieve;

    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Center(
        child: Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SizedBox(
          width: w1p * 90,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                msg,
                style: t400_14.copyWith(color: clr2D2D2D),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          // height: h1p*80,
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colours.toastBlue),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 5,
              ),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: t500_16.copyWith(color: clr2D2D2D),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red,
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 5,
              ),
              child: Text(AppLocalizations.of(context)!.delete, style: t500_16),
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
