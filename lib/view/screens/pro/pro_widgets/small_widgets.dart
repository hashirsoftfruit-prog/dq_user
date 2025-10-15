import 'package:dqapp/model/core/specialities_response_model.dart';
import 'package:flutter/material.dart';

import '../../../theme/constants.dart';
import '../../../theme/text_styles.dart';
import '../../online_catogories_screen.dart';

class ProBystanderBanner extends StatelessWidget {
  final double maxWidth;
  final double h10p;
  const ProBystanderBanner({
    super.key,
    required this.maxWidth,
    required this.h10p,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth,
      padding: const EdgeInsets.all(8),
      height: h10p * 3.2,
      margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/pro_bystander_banner.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Introducing a New\nEra of Care',
            style: t700_16.copyWith(color: clrFFFFFF),
          ),
          Text(
            'With DQ, bystanders \ncan now join and \nsupport — only here first!',
            style: t400_12.copyWith(color: clrFFFFFF),
          ),
        ],
      ),
    );
  }
}

class BookContainer extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle1;
  final String subtitle2;
  final double width;
  final Color color;
  final List<Color> gradient;
  final bool isOnline;
  final bool? isFitImage;
  final List<SpecialityList>? ayurOrHomeoList;
  const BookContainer({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.width,
    required this.color,
    required this.isOnline,
    required this.gradient,
    this.isFitImage = false,
    this.ayurOrHomeoList,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        navigateOnlineCategories(isOnline, ayurOrHomeoList: ayurOrHomeoList),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          child: Container(
            height: width,
            width: width,
            // margin: const EdgeInsets.all(4),
            // padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              border: Border.all(width: 1, color: color),
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              // image: DecorationImage(
              //   image: AssetImage(image),
              //   fit: BoxFit.fill,
              // ),
              boxShadow: [boxShadow13],
            ),
            child: Stack(
              children: [
                if (!isFitImage!)
                  Positioned(
                    bottom: -60,
                    right: 32,
                    child: Transform.rotate(
                      angle: 60 * 3.1415926535 / 180,
                      child: Container(
                        width: width / 2,
                        height: width + 16,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: color,
                        ),
                      ),
                    ),
                  ),
                // Positioned(
                //   bottom: 10,
                //   right: 30,
                //   child: Align(
                //     alignment: Alignment.bottomCenter,
                //     child: Container(
                //       height: 40,
                //       width: 40,
                //       decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(30)), border: Border.all(width: 2, color: clrFFFFFF.withOpacity(.2))),
                //     ),
                //   ),
                // ),
                Positioned(
                  bottom: -36,
                  right: -36,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(70),
                        ),
                        border: Border.all(
                          width: 2,
                          color: clrFFFFFF.withOpacity(.1),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -36,
                  right: -36,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50),
                        ),
                        border: Border.all(
                          width: 2,
                          color: clrFFFFFF.withOpacity(.1),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: t700_16.copyWith(color: clr2D2D2D, height: 1),
                        ),
                        verticalSpace(8),
                        Text(
                          subtitle1,
                          style: t400_12.copyWith(color: clr2D2D2D, height: 1),
                        ),
                        Text(
                          subtitle2,
                          style: t700_12.copyWith(color: clr2D2D2D, height: 1),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isFitImage!)
                  Positioned(
                    bottom: -6,
                    right: 6,
                    child: SizedBox(
                      height: width / 1.6,
                      width: width / 2,
                      child: Image.asset(image),
                    ),
                  ),
                if (isFitImage!)
                  Positioned(
                    bottom: -6,
                    right: -4,
                    child: SizedBox(
                      height: width / 1.5,
                      width: width,
                      child: Image.asset(image, fit: BoxFit.cover),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Route navigateOnlineCategories(
    bool schedule, {
    List<SpecialityList>? ayurOrHomeoList,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          OnlineCategoriesScreen(
            forScheduledBooking: schedule,
            ayurOrHomeoList: ayurOrHomeoList,
          ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}

class TabConsultBanner extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String subtitle;
  final Color subtitleColor;
  final String bgImage;
  final double maxWidth;
  final double h1p;
  final double w1p;
  const TabConsultBanner({
    super.key,
    required this.maxWidth,
    required this.h1p,
    required this.w1p,
    required this.title,
    required this.subtitle,
    required this.bgImage,
    required this.titleColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: h1p * 20,
      width: maxWidth,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(image: AssetImage(bgImage), fit: BoxFit.cover),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(w1p * 7, h1p * 4, w1p * 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: t700_16.copyWith(color: titleColor, height: 1.1),
            ),
            verticalSpace(h1p),
            SizedBox(
              width: w1p * 50,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  subtitle,
                  style: t500_12.copyWith(color: subtitleColor, height: 1.1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
