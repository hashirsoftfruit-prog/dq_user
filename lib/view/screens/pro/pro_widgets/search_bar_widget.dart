// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../speech.dart';
import '../../../theme/constants.dart';
import '../../../theme/text_styles.dart';
import '../../search_results_screen.dart';

class ProSearchBar extends StatelessWidget {
  final double maxWidth;
  final double maxHeight;
  const ProSearchBar({
    super.key,
    required this.maxWidth,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    List<TyperAnimatedText> lst =
        [
              (AppLocalizations.of(context)!.symptoms),
              AppLocalizations.of(context)!.specialities,
              AppLocalizations.of(context)!.doctors,
              AppLocalizations.of(context)!.clinics,
            ]
            .map(
              (item) => TyperAnimatedText(
                item,
                textStyle: t400_14,
                speed: const Duration(milliseconds: 100),
              ),
            )
            .toList();
    // double maxHeight = constraints.maxHeight;
    // double maxWidth = constraints.maxWidth;
    double h1p = maxHeight * 0.01;
    //   double h10p = maxHeight * 0.1;
    double w10p = maxWidth * 0.1;
    double w1p = maxWidth * 0.01;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: h1p * 7,
        child: Entry(
          // yOffset: -20,
          // // scale: 20,
          // duration: const Duration(milliseconds: 500),
          // delay: const Duration(milliseconds: 50),
          // curve: Curves.ease,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: 1,
            // opacity: hMgr.heightF == 4 ? 1 : 0,
            child: pad(
              // horizontal: w1p * 5,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/searchScreen');
                },
                child: AnimatedContainer(
                  // margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + h1p * 6 - (searchFixed ? h1p * 1 : 0)
                  // (!searchFixed
                  //     ? scrlPosition > 40
                  //         ? scrlPosition
                  //         : h10p * 0.7 - scrlPosition
                  //     : h1p * 6)
                  // ),
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(containerRadius / 2),
                    color: clr202020.withOpacity(0.4),
                    // border: searchFixed ? Border.all(color: clr202020.withOpacity(0.4), width: 0.5) : null,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: maxWidth - w10p,
                    height: 0.6,
                    // height: hMgr.heightF == 4 ? h10p * 0.6 : 0,
                    decoration: BoxDecoration(
                      color: Colours.boxblue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(containerRadius / 2),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: SvgPicture.asset(
                              "assets/images/icon-search.svg",
                              colorFilter: ColorFilter.mode(
                                clrFFFFFF,
                                BlendMode.srcIn,
                              ),

                              // color: clrFFFFFF,
                            ),
                          ),
                          horizontalSpace(8),
                          Text(
                            AppLocalizations.of(context)!.searchFor,
                            style: t400_14,
                            // textAlign: TextAlign.start,
                          ),
                          AnimatedTextKit(
                            repeatForever: true,
                            animatedTexts: lst,
                            onTap: () {},
                          ),
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: VerticalDivider(),
                          ),
                          GestureDetector(
                            onTap: () async {
                              var res = await showModalBottomSheet(
                                elevation: 0,
                                isDismissible: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return const SpeechToTextWidget();
                                },
                              );

                              if (res != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SearchResultScreen(
                                      title: AppLocalizations.of(
                                        context,
                                      )!.onlineConsultations,
                                      type: 2,
                                      searchquery: res,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 12,
                              ),
                              // color: Colors.red,
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: SvgPicture.asset(
                                  "assets/images/home_icons/icon-mic.svg",
                                  colorFilter: ColorFilter.mode(
                                    clrFFFFFF,
                                    BlendMode.srcIn,
                                  ),
                                  // color: clrFFFFFF,
                                ),
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
          ),
        ),
      ),
    );
  }
}
