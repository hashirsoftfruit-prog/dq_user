import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:dqapp/l10n/app_localizations.dart';

import '../../../../../theme/constants.dart';
import '../../../../../theme/text_styles.dart';
import '../pet_tab.dart';

class PetBanners extends StatefulWidget {
  final double maxWidth;
  const PetBanners({super.key, required this.maxWidth});

  @override
  State<PetBanners> createState() => _PetBannersState();
}

class _PetBannersState extends State<PetBanners> {
  int scrollIndicatorIndex = 0;

  @override
  Widget build(BuildContext context) {
    double maxWidth = widget.maxWidth;
    double w1p = maxWidth * 0.01;
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            onPageChanged: (a, b) {
              setState(() => scrollIndicatorIndex = a);
            },
            viewportFraction: 1,
            enableInfiniteScroll: true,
            // enableInfiniteScroll: mainBanners.length > 1 ? true : false,
            // autoPlay: mainBanners.length > 1 ? true : false,
            // autoPlay: true,
            aspectRatio: 3 / 1,
          ),
          items: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w1p * 4),
              child: SizedBox(
                height: 130,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: maxWidth,
                        height: 110,
                        decoration: BoxDecoration(
                          boxShadow: [boxShadow7],
                          color: const Color(0xffF5EEDC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: w1p * 4,
                            vertical: 8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.onlineVetConsultation,
                                style: t500_16.copyWith(color: clr444444),
                              ),
                              Text(
                                AppLocalizations.of(context)!.exclusiveOffers,
                                style: t500_14.copyWith(color: clr444444),
                              ),
                              BtnWidget(
                                title: AppLocalizations.of(context)!.consultNow,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const CircleWidget(size: 90),
                            SizedBox(
                              height: 130,
                              child: Image.asset(
                                "assets/images/pet-consult.png",
                              ),
                            ),
                            // Text("sdsd"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w1p * 4),
              child: SizedBox(
                height: 130,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: maxWidth,
                        height: 110,
                        decoration: BoxDecoration(
                          boxShadow: [boxShadow7],
                          color: const Color(0xffF5EEDC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: w1p * 8,
                            vertical: 8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.petGrooming,
                                style: t500_18.copyWith(
                                  color: const Color(0xffFF6F61),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.exclusiveOffers,
                                style: t500_14.copyWith(color: clr444444),
                              ),
                              BtnWidget(
                                title: AppLocalizations.of(context)!.schedule,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const CircleWidget(size: 90),
                            SizedBox(
                              height: 130,
                              child: Image.asset(
                                "assets/images/pet-groom-dog.png",
                              ),
                            ),
                            // Text("sdsd"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [0, 1].map((value) {
              // var index = mainBanners.indexOf(e);
              return AnimatedContainer(
                decoration: BoxDecoration(
                  color: const Color(0xffD6D6D6),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(2),
                duration: const Duration(milliseconds: 400),
                height: 3,
                width: scrollIndicatorIndex == value ? 40 : 8,
              );
            }).toList(),
          ),
        ),
        verticalSpace(8),
      ],
    );
  }
}
