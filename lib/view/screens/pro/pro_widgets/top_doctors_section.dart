import 'package:dqapp/model/core/available_doctors_response_model.dart';
import 'package:dqapp/model/core/top_doctors_response_model.dart';
import 'package:dqapp/view/screens/home_screen_widgets.dart';
import 'package:dqapp/view/screens/pro/pro_widgets/doc_speciality_list_display.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';

import '../../booking_screens/booking_screen_widgets.dart';
import '../../booking_screens/redacted_loaders.dart';

class TopDoctorsSection extends StatelessWidget {
  final List<TopDoctors>? doctors;
  final Color bgColor;
  const TopDoctorsSection({
    super.key,
    required this.doctors,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: bgColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Top Doctors',
                style: t700_16.copyWith(color: clr2D2D2D),
              ),
            ),
            const SizedBox(height: 12),
            doctors == null || doctors!.isEmpty
                ? SizedBox(
                    height: 272,
                    child: ListView.builder(
                      itemBuilder: (context, index) => pad(
                        horizontal: 8,
                        child: const SkeletonBox(height: 200, width: 180),
                      ),
                      itemCount: 3,
                      scrollDirection: Axis.horizontal,
                    ),
                  )
                : SizedBox(
                    height: 272,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: doctors?.length,
                      itemBuilder: (context, index) {
                        final doctor = doctors![index];
                        return DoctorCard(
                          name:
                              '${doctor.doctor?.firstName} ${doctor.doctor?.lastName}',
                          qualification: doctor.doctor?.qualification ?? '',
                          secondaryAchievement:
                              doctor.secondaryAchievement ?? '',
                          rating: doctor.rating ?? 0.0,
                          primaryAchievement: doctor.primaryAchievement ?? '',
                          imagePath: doctor.doctor?.image ?? '',
                          doctor: doctor.doctor,
                          cardColor: bgColor,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String qualification;
  final String secondaryAchievement;
  final double rating;
  final String primaryAchievement;
  final String imagePath;
  final Doctors? doctor;
  final Color cardColor;

  const DoctorCard({
    super.key,
    required this.name,
    required this.qualification,
    required this.secondaryAchievement,
    required this.rating,
    required this.primaryAchievement,
    required this.imagePath,
    required this.doctor,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    double w1p = MediaQuery.of(context).size.width / 100;
    double h1p = MediaQuery.of(context).size.height / 100;
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => DocSpecialityListDisplay(
            docId: doctor?.id ?? 0,
            specialites: doctor?.specialities ?? [],
            cardColor: cardColor,
          ),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 120,
                    width: 180,
                    color: Colors.grey[300],
                    child: HomeWidgets().cachedImg(imagePath, fit: BoxFit.fill),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: clrFFFFFF.withOpacity(.6),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 3,
                  left: 3,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AnimatedPopup(
                            child: DoctorDetailsCard(
                              instantDocData: doctor,
                              primaryAchievement: primaryAchievement,
                              secondaryAchievement: secondaryAchievement,
                              rating: rating,
                              h1p: h1p,
                              w1p: w1p,
                            ),
                          ); // Animated dialog
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: clrFFFFFF.withOpacity(.6),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: const Icon(Icons.info_outline_rounded, size: 18),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    clrFFFFFF,
                    const Color(0xFFFFB60C).withOpacity(.2),
                    clrFFFFFF,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 14,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      primaryAchievement,
                      overflow: TextOverflow.ellipsis,
                      style: t400_12.copyWith(color: const Color(0xFF2E3192)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Text(
                      name,
                      style: t700_14.copyWith(color: clr2D2D2D),
                    ),
                  ),
                  Text(
                    qualification,
                    style: t400_12.copyWith(
                      color: clr2D2D2D.withOpacity(.5),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  // Text(degree, style: t400_12.copyWith(color: clr2D2D2D.withOpacity(.5))),
                  // Text(degree, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1EFFF),
                borderRadius: BorderRadius.circular(20),
              ),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                secondaryAchievement,
                style: t400_14.copyWith(color: clr2D2D2D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
