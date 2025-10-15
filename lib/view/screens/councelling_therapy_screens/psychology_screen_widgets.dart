import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../theme/constants.dart';
import '../../theme/text_styles.dart';

class MWellCard extends StatelessWidget {
  final double w1p;
  final double h1p;
  // String img;
  final String img;
  final int indx;
  final String? txt;
  const MWellCard({
    super.key,
    required this.h1p,
    required this.w1p,
    // required this.indx,
    required this.indx,
    required this.img,
    this.txt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: w1p * 2),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(containerRadius / 2),
            child: SizedBox(
                height: 100,
                child: CachedNetworkImage(
                    fit: BoxFit.fitHeight,
                    // fit: widget.fit,
                    imageUrl: '${StringConstants.baseUrl}$img',
                    placeholder: (context, url) => Opacity(
                        opacity: 0.4,
                        child: Image.asset(
                          "assets/images/placeholder-psychology.png",
                          fit: BoxFit.fill,
                        )),
                    errorWidget: (context, url, error) => Opacity(
                        opacity: 0.4,
                        child: Image.asset(
                          "assets/images/placeholder-psychology.png",
                          fit: BoxFit.fill,
                        )))),
          ),
          SizedBox(
              child: Text(
            txt ?? "",
            style: t500_14.copyWith(color: clr444444),
            overflow: TextOverflow.ellipsis,
          )),
        ],
      ),
    );
  }
}

class TherapyBox extends StatelessWidget {
  final double w1p;
  final double h1p;
  // String img;
  final int indx;
  final String? txt;
  const TherapyBox({
    super.key,
    required this.h1p,
    required this.w1p,
    // required this.indx,
    required this.indx,
    this.txt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: w1p * 2),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(1, 1))
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Text(
                txt ?? "",
                style: t500_14.copyWith(color: clr444444),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FeelingsIconWidget extends StatelessWidget {
  final String title;
  final int emotionValue;
  final Function onTap;
  final int? selectedEmotionCode;

  const FeelingsIconWidget(
      {super.key,
      required this.emotionValue,
      required this.onTap,
      required this.selectedEmotionCode,
      required this.title});

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedEmotionCode == emotionValue;

    List<String> images = [
      "assets/images/feel-icon-angry.png",
      "assets/images/feel-icon-sad.png",
      "assets/images/feel-icon-normal.png",
      "assets/images/feel-icon-good.png",
      "assets/images/feel-icon-happy.png",
    ];
    return Expanded(
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            margin: const EdgeInsets.all(4),
            padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 2 : 4, vertical: 10),
            decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xffFFB97E)
                    : const Color(0xffFFF4EB),
                borderRadius: BorderRadius.circular(26)),
            child: GestureDetector(
              onTap: () {
                onTap();
              },
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.all(isSelected == true ? 1 : 4.0),
                  child: Image.asset(images[emotionValue - 1]),
                ),
                Text(title,
                    style: isSelected
                        ? t500_12
                        : t400_12.copyWith(color: clr2D2D2D)),
              ]),
            )));
  }
}

class AppBarForCouncelling extends SliverPersistentHeaderDelegate {
  // final String slotCount;
  final double minHeight;
  final double maxHeight;
  final String title1;
  final String title2;
  final double w1p;

  AppBarForCouncelling({
    // required this.slotCount,
    required this.minHeight,
    required this.maxHeight,
    required this.title1,
    required this.w1p,
    required this.title2,
    // required this.text,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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
                        color: Colors.black,
                      )),
                ),
                horizontalSpace(8),
                Text(
                  isCollapsed ? '$title1 $title2' : "",
                  style: t400_18.copyWith(color: clr2D2D2D),
                )
              ],
            ),
          ),
          const Spacer(),
          isCollapsed
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title1,
                      style: t400_18.copyWith(color: clr2D2D2D, height: 1.05),
                    ),
                    Text(
                      title2,
                      style: t500_22.copyWith(color: clr2D2D2D, height: 1.05),
                    ),
                  ],
                )

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

class TherapyTutorial {
  String stepNo;
  String image;
  String title;

  TherapyTutorial({
    required this.stepNo,
    required this.image,
    required this.title,
  });
}

class MeeditationWidget extends StatelessWidget {
  final double w1p;
  const MeeditationWidget(this.w1p, {super.key});
  @override
  Widget build(BuildContext context) {
    double widgetHeight = 123;
    IconData icon = Icons.videocam_sharp;

    LinearGradient gradient = const LinearGradient(
      colors: [Color(0xff609DCE), Color(0xff004D8A)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Stack(
          children: [
            SizedBox(
              width: w1p * 70,
              height: widgetHeight,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Meditation", style: t500_20.copyWith(height: 1.04)),
                    const SizedBox(height: 4),
                    Text(
                      "Find your calm. Breathe.Meditate.",
                      style: t400_16.copyWith(height: 1),
                    ),
                  ],
                ),
              ),
            ),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(20),
            //   child: Image.asset(
            //     'assets/images/councelling-thumnail-audio.png', // Replace with actual image path
            //     width: 150,
            //     height: widgetHeight,
            //     fit: BoxFit.cover,
            //   ),
            // ),

            Align(
              alignment: Alignment.centerRight,
              child: ClipPath(
                clipper: CurvedClipper(),
                child: Container(
                  height: widgetHeight,
                  width: 155,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/images/councelling-thumnail-video.png',
                          ))),
                  child: SizedBox(
                    height: widgetHeight,
                    width: widgetHeight,
                    child: Center(
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: const Color(0xff3478AF).withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RelaxModeWidget extends StatelessWidget {
  final double w1p;
  const RelaxModeWidget(this.w1p, {super.key});

  @override
  Widget build(BuildContext context) {
    double imageAreaSize = 155;
    double widgetHeight = 123;
    IconData icon = Icons.play_arrow;
    LinearGradient gradient = const LinearGradient(
      colors: [
        Color(0xff94434F),
        Color(0xffFA7285),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: w1p * 100 - imageAreaSize,
                height: widgetHeight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Meditation", style: t500_20.copyWith(height: 1.04)),
                      const SizedBox(height: 4),
                      Text(
                        "Find your calm. Breathe.Meditate.",
                        style: t400_16.copyWith(height: 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(20),
            //   child: Image.asset(
            //     'assets/images/councelling-thumnail-audio.png', // Replace with actual image path
            //     width: 150,
            //     height: widgetHeight,
            //     fit: BoxFit.cover,
            //   ),
            // ),

            Align(
              alignment: Alignment.centerLeft,
              child: ClipPath(
                clipper: RightCurvedClipper(),
                child: Container(
                  height: widgetHeight,
                  width: imageAreaSize,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/images/councelling-thumnail-audio.png',
                          ))),
                  child: SizedBox(
                    height: widgetHeight,
                    width: widgetHeight,
                    child: Center(
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: const Color(0xffFA7285).withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper for the rounded diagonal shape
// Custom Clipper for the curved shape
class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start at the top-left
    path.lineTo(size.width * 0.25, 0);

    // Curve at the left side
    path.quadraticBezierTo(
        0, size.height * 0.5, size.width * 0.25, size.height);

    // Line to the bottom-right
    path.lineTo(size.width - 20, size.height);

    // Curve at the right side
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 20);

    // Line to the top-right
    path.lineTo(size.width, 20);

    // Right-side rounded curve
    path.quadraticBezierTo(size.width, 0, size.width - 20, 0);

    // Close the path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class RightCurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start at top-left
    path.lineTo(0, size.height);

    // Line to bottom-right before curve
    path.lineTo(size.width * 0.75, size.height);

    // Right-side curve
    path.quadraticBezierTo(
      size.width, size.height * 0.5, // Control point
      size.width * 0.75, 0, // End point
    );

    // Line to top-left
    path.lineTo(0, 0);

    // Close path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
