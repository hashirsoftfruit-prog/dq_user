import 'package:dqapp/view/theme/constants.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';

class AppBarForOnlineCategoryScreen extends SliverPersistentHeaderDelegate {
  // final String slotCount;
  final double minHeight;
  final double maxHeight;
  final String title1;
  final String title2;
  final double w1p;
  final bool forScheduledBooking;

  AppBarForOnlineCategoryScreen({
    // required this.slotCount,
    required this.minHeight,
    required this.maxHeight,
    required this.title1,
    required this.w1p,
    required this.title2,
    required this.forScheduledBooking,
    // required this.text,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    double progress = shrinkOffset / maxExtent;
    bool isCollapsed = progress > 0.2; // Controls when animation starts

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      // color:     Color(0xffFFCB9F),
      padding: EdgeInsets.symmetric(horizontal: w1p * 4),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title (Always Left-Aligned)
          SizedBox(
            // width: 60,
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Image.asset(
                      "assets/images/back-cupertino.png",
                      color: Colors.white,
                    ),
                  ),
                ),
                horizontalSpace(8),
                Text(
                  isCollapsed ? '$title1 $title2' : "",
                  style: t400_18.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          const Spacer(),
          isCollapsed
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title1,
                          style: t400_18.copyWith(
                            color: Colors.white,
                            height: 1.05,
                          ),
                        ),
                        Text(
                          title2,
                          style: t500_22.copyWith(
                            color: Colors.white,
                            height: 1.05,
                          ),
                        ),
                      ],
                    ),
                    forScheduledBooking == true
                        ? const SizedBox()
                        : Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Image.asset(
                                      "assets/images/video-call-icon.png",
                                    ),
                                  ),
                                  horizontalSpace(4),
                                  Text(
                                    "Connect with\nin 30 Sec",
                                    style: t400_10.copyWith(color: clr7261A8),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),

          // Animated Slot Count (Moves to Right)
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
