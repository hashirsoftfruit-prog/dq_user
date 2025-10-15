import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:dqapp/view/theme/text_styles.dart';

import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';

class ChooseConsultationTypeScreen extends StatelessWidget {
  const ChooseConsultationTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var get = getIt<SmallWidgets>();

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: get.appBarWidget(
            title: "",
            height: h10p,
            width: w10p,
            fn: () {
              Navigator.pop(context);
            },
          ),
          body: Entry(
            xOffset: 800,
            // scale: 20,
            delay: const Duration(milliseconds: 100),
            duration: const Duration(milliseconds: 900),
            curve: Curves.ease,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                pad(
                  horizontal: w1p * 6,
                  vertical: h1p * 2,
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.chooseYourPreferredConsultationMode,
                        style: t400_20.copyWith(color: clr444444, height: 1.27),
                      ),
                    ],
                  ),
                ),
                BoxWidget(
                  h1p: h1p,
                  w1p: w1p,
                  indx: 0,
                  txt: AppLocalizations.of(context)!.scheduleBooking,
                  color: const Color(0xffF68629),
                  fn: () {
                    Navigator.pop(context, "Scheduled");
                  },
                ),
                BoxWidget(
                  color: const Color(0xffBD6273),
                  fn: () {
                    Navigator.pop(context, "Instant");
                  },
                  h1p: h1p,
                  w1p: w1p,
                  indx: 0,
                  txt: AppLocalizations.of(context)!.onlineConsultations,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BoxWidget extends StatelessWidget {
  final double w1p;
  final double h1p;
  final int indx;
  final Color color;
  final Function() fn;
  final String? txt;

  const BoxWidget({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.indx,
    this.txt,
    required this.color,
    required this.fn,
  });

  @override
  Widget build(BuildContext context) {
    List<String> splittedTitle = txt!.split(" ");
    List<String> splittedTitleremovingFrst = splittedTitle.sublist(1);

    double fHeight = 87;
    double fWidth = w1p * 90;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: fn,
        child: Container(
          width: fWidth,
          height: fHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Entry(
                  xOffset: -50,
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 600),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: fWidth - w1p * 50,
                      height: fHeight,
                      decoration: BoxDecoration(color: color),
                    ),
                  ),
                ),
              ),
              Entry(
                xOffset: 50,
                duration: const Duration(milliseconds: 500),
                delay: const Duration(milliseconds: 600),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(1, 1),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  width: fWidth - 10,
                  height: fHeight - 10,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${splittedTitle[0]} ',
                              style: t500_18.copyWith(color: color),
                            ),
                            ...splittedTitleremovingFrst.map(
                              (e) => TextSpan(
                                text: '$e ',
                                style: t400_18.copyWith(
                                  color: const Color(0xff717171),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
