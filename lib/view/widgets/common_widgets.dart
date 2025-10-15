import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import '../screens/home_screen_widgets.dart';
import '../theme/constants.dart';

class SmallWidgets {
  locationIcon({Color? brColor, Color? iconClr, double? size}) {
    double sz = size ?? 30;
    return Container(
      height: sz,
      width: sz,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: brColor ?? clrFFFFFF,
      ),
      child: Padding(
        padding: EdgeInsets.all(sz / 3.5),
        child: Image.asset(
          "assets/images/location-icon-doctor-list.png",
          color: iconClr,
        ),
      ),
    );
  }

  AppBar appBarWidget({
    required String? title,
    required double height,
    required double width,
    required Function fn,
    bool? hideBackBtn,
    Widget? trailWidget,
  }) {
    return AppBar(
      toolbarHeight: 60,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: SafeArea(
        child: Container(
          height: 60,
          color: Colors.white,
          child: pad(
            horizontal: width * 0.4,
            vertical: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    hideBackBtn == true
                        ? const SizedBox()
                        : InkWell(
                            onTap: () {
                              fn();
                            },
                            child: SizedBox(
                              height: 22,
                              child: Image.asset(
                                "assets/images/back-cupertino.png",
                                color: Colors.black,
                              ),
                            ),
                          ),
                    SizedBox(width: width * 0.1),
                    Text(
                      title ?? '',
                      style: t400_16.copyWith(color: clr2D2D2D),
                    ),
                  ],
                ),
                trailWidget ?? const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar logoAppBarWidget({double? height}) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: height ?? 60,
      flexibleSpace: SafeArea(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/images/logo-with-text.png"),
          ),
        ),
      ),
    );
  }

  Widget searchBarBox({
    required String title,
    bool? visibility,
    required double height,
    required double width,
    Function? onchangedFn,
  }) {
    return Visibility(
      visible: visibility == true,
      child: pad(
        horizontal: width * 0.1,
        child: Container(
          decoration: BoxDecoration(
            color: Colours.appointBoxClr,
            borderRadius: BorderRadius.circular(containerRadius / 2),
            border: Border.all(width: .2),
          ),
          // height: height,
          child: pad(
            horizontal: width * 0.4,
            vertical: height * 0.00,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(width * 0.1),
                  child: SizedBox(
                    height: height * 0.5,
                    child: SvgPicture.asset(
                      "assets/images/icon-search.svg",
                      height: height * 0.3,
                    ),
                  ),
                ),
                SizedBox(width: width * 0.3),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: title,
                      hintStyle: t500_14.copyWith(color: clr868686),
                    ),
                    onChanged: (value) =>
                        onchangedFn == null ? null : onchangedFn(value),
                  ),
                ),
                // Text(
                //   title,
                //   style: t500_14.copyWith(color: clr444444),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget categoryHeading({
    required String title,
    required Function fn,
    required bool showViewAll,

    // required double height, required double width
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: t500_16.copyWith(color: clr2D2D2D)),
        InkWell(
          onTap: () {
            fn();
          },
          child: showViewAll
              ? Text("View all", style: t400_14.copyWith(color: clrFA8E53))
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget cachedImg(String img) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      // fit: widget.fit,
      imageUrl: StringConstants.baseUrl + img,
      placeholder: (context, url) => Opacity(
        opacity: 0.5,
        child: Image.asset("assets/images/speciality-placeholder.png"),
      ),
      errorWidget: (context, url, error) =>
          Image.asset("assets/images/speciality-placeholder.png"),
    );
  }
}

class SearchResItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String? img;
  final String title;
  const SearchResItem({
    super.key,
    required this.h1p,
    required this.w1p,
    this.img,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          Container(
            // height: h1p*9,
            decoration: BoxDecoration(
              color: Colours.appointBoxClr,
              borderRadius: BorderRadius.circular(containerRadius / 2),
            ),
            child: Row(
              children: [
                img != null
                    ? SizedBox(
                        width: w1p * 16,
                        height: w1p * 16,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SmallWidgets().cachedImg(img!),
                        ),
                      )
                    : const SizedBox(),
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: w1p * 3,
                    ),
                    child: Text(
                      title,
                      style: t500_12.copyWith(color: clr444444, height: 1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String img;
  final String title;
  final Function onClick;
  const CategoryItem({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.img,
    required this.title,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    // Widget specialityBox({
    // required double h1p,
    //       required double w1p,
    //       required String img,
    //       required int index,
    //       required String title,
    //       required Function onClick,}) {
    return Container(
      margin: EdgeInsets.only(right: w1p * 2, bottom: 4),
      width: w1p * 20,
      height: h1p * 20,
      // decoration: BoxDecoration(color: Colors.lightBlue),
      // height: 0,
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              onClick();
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(containerRadius / 2),
                      color: clrEFEFEF,
                    ),
                    height: 30,
                    // width: 100
                  ),
                ),
                SizedBox(
                  width: w1p * 20,
                  // height:w1p*18 ,
                  // height: 80,
                  child: HomeWidgets().cachedImg(
                    img,
                    placeholderImage:
                        "assets/images/home_icons/general-physician-temp.png",
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(4),
          SizedBox(
            child: Text(
              title,
              style: t400_12.copyWith(color: clr2D2D2D, height: 1),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  //
  // return  SizedBox(height: h1p*15,
  //   child: Column(
  //     children: [
  //       Container(
  //         // height: h1p*9,
  //         decoration: BoxDecoration(
  //             color: Colours.appointBoxClr,
  //             borderRadius: BorderRadius.circular(containerRadius/2)),
  //         child: SizedBox(
  //             width: w1p*15,
  //             height: w1p*15,
  //             child: Padding(
  //               padding: EdgeInsets.all(10.0),
  //               child: SmallWidgets().cachedImg(img),
  //             )),
  //       ),SizedBox(child: Text(title,style: TextStyles.textStyle32,textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,))
  //     ],
  //   ),
  // );;
  // }
}

class VideoItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String img;
  final String title;
  final String? duration;
  final Function onClick;
  const VideoItem({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.img,
    required this.title,
    required this.duration,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    // Widget specialityBox({
    // required double h1p,
    //       required double w1p,
    //       required String img,
    //       required int index,
    //       required String title,
    //       required Function onClick,}) {
    return Container(
      margin: const EdgeInsets.only(top: 8),

      decoration: BoxDecoration(
        color: clrFFFFFF,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 4.7,
            spreadRadius: 0,
            color: clr2D2D2D.withOpacity(0.16),
          ),
        ],
      ),
      width: w1p * 100,
      height: 110,
      // decoration: BoxDecoration(color: Colors.lightBlue),
      // height:w1p*20+40 ,
      child: InkWell(
        onTap: () async {
          onClick();
        },
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 130,
                      decoration: BoxDecoration(color: clrEFEFEF),
                      height: 110,
                      child: SizedBox(
                        // height:w1p*18 ,
                        // height: 80,
                        child: HomeWidgets().cachedImg(
                          img,
                          placeholderImage:
                              "assets/images/meditation-video-main-image.png",
                        ),
                      ),
                      // width: 100
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 70,
                    width: 70,
                    child: Center(
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: const Color(0xff3478AF).withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.videocam_sharp,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            horizontalSpace(4),
            Expanded(
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: t500_14.copyWith(color: clr2D2D2D, height: 1.2),
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Text(
                      //   title,
                      //   style: t400_12.copyWith(color: const Color(0xff000000).withOpacity(0.6), height: 1.37),
                      //   textAlign: TextAlign.start,
                      //   maxLines: 2,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      const Spacer(),
                      if (duration != null)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xff2E3192).withOpacity(0.2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: Text(
                              "$duration",
                              style: t400_12.copyWith(
                                color: clr2D2D2D.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  // return  SizedBox(height: h1p*15,
  //   child: Column(
  //     children: [
  //       Container(
  //         // height: h1p*9,
  //         decoration: BoxDecoration(
  //             color: Colours.appointBoxClr,
  //             borderRadius: BorderRadius.circular(containerRadius/2)),
  //         child: SizedBox(
  //             width: w1p*15,
  //             height: w1p*15,
  //             child: Padding(
  //               padding: EdgeInsets.all(10.0),
  //               child: SmallWidgets().cachedImg(img),
  //             )),
  //       ),SizedBox(child: Text(title,style: TextStyles.textStyle32,textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,))
  //     ],
  //   ),
  // );;
  // }
}

class MusicItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String img;
  final String title;
  final Function onClick;
  final String? duration;
  final String? artist;
  const MusicItem({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.img,
    required this.title,
    required this.onClick,
    required this.duration,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    // Widget specialityBox({
    // required double h1p,
    //       required double w1p,
    //       required String img,
    //       required int index,
    //       required String title,
    //       required Function onClick,}) {
    return Container(
      height: 82,

      // height: 77,
      margin: const EdgeInsets.only(top: 8),

      decoration: BoxDecoration(
        color: clrFFFFFF,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 4.7,
            spreadRadius: 0,
            color: clr2D2D2D.withOpacity(0.16),
          ),
        ],
      ),
      width: w1p * 100,
      // height: 110,
      // decoration: BoxDecoration(color: Colors.lightBlue),
      // height:w1p*20+40 ,
      child: InkWell(
        onTap: () async {
          onClick();
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 76,
                  decoration: BoxDecoration(color: clrEFEFEF),
                  height: 76,
                  child: HomeWidgets().cachedImg(
                    img,
                    placeholderImage:
                        "assets/images/music-player-placeholder.png",
                  ),
                  // width: 100
                ),
              ),
            ),
            horizontalSpace(4),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    title,
                    style: t500_16.copyWith(color: clr2D2D2D, height: 1.37),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        duration ?? "",
                        style: t400_10.copyWith(color: clr2D2D2D),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: clr2D2D2D,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Text(
                        artist ?? "unknown",
                        style: t400_10.copyWith(color: clr2D2D2D),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // const Spacer(),
            SizedBox(
              height: 40,
              width: 40,
              child: Image.asset("assets/images/music-player-icon.png"),
            ),
            horizontalSpace(12),
          ],
        ),
      ),
    );
  }

  //
  // return  SizedBox(height: h1p*15,
  //   child: Column(
  //     children: [
  //       Container(
  //         // height: h1p*9,
  //         decoration: BoxDecoration(
  //             color: Colours.appointBoxClr,
  //             borderRadius: BorderRadius.circular(containerRadius/2)),
  //         child: SizedBox(
  //             width: w1p*15,
  //             height: w1p*15,
  //             child: Padding(
  //               padding: EdgeInsets.all(10.0),
  //               child: SmallWidgets().cachedImg(img),
  //             )),
  //       ),SizedBox(child: Text(title,style: TextStyles.textStyle32,textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,))
  //     ],
  //   ),
  // );;
  // }
}

class GradientDivider extends StatelessWidget {
  final double? height;
  final List<Color>? colors;
  const GradientDivider({super.key, this.height, this.colors});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: height ?? 0.5,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                colors ?? [const Color(0xffE3E3E3), const Color(0xff959595)],
          ),
        ),
      ),
    );
  }
}

class SpecialityItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String img;
  final String title;
  final bool selected;
  const SpecialityItem({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.img,
    required this.title,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: h1p*15,
      child: Row(
        children: [
          Container(
            // height: h1p*9,
            decoration: BoxDecoration(
              color: Colours.appointBoxClr,
              borderRadius: BorderRadius.circular(containerRadius / 2),
            ),
            child: SizedBox(
              width: w1p * 15,
              height: w1p * 15,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SmallWidgets().cachedImg(img),
              ),
            ),
          ),
          horizontalSpace(w1p * 3),
          SizedBox(
            child: Text(
              title,
              style: selected
                  ? t500_12.copyWith(color: const Color(0xffffffff), height: 1)
                  : t500_12.copyWith(color: clr444444, height: 1),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// library scrolling_buttons_bar;
//
// import 'package:flutter/material.dart';

class ScrollingButtonBar extends StatefulWidget {
  final List<ButtonsItem> children;
  final double childWidth;
  final double childHeight;
  final Color foregroundColor;
  final int selectedItemIndex;
  final ScrollController scrollController;

  final double radius;
  final Curve curve;
  final Duration animationDuration;

  const ScrollingButtonBar({
    Key? key,
    required this.children,
    required this.childWidth,
    required this.childHeight,
    required this.foregroundColor,
    required this.scrollController,
    required this.selectedItemIndex,
    this.radius = 0.0,
    this.curve = Curves.easeIn,
    this.animationDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  State<ScrollingButtonBar> createState() => _ScrollingButtonBarState();
}

class _ScrollingButtonBarState extends State<ScrollingButtonBar> {
  int _index = 0;
  GlobalKey selectedBottomBarItemKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedBottomBarItemKey.currentContext != null) {
        widget.scrollController.position.ensureVisible(
          selectedBottomBarItemKey.currentContext!.findRenderObject()!,
          alignment: 0.5, // Aligns the image in the middle.
          curve: widget.curve,
          duration: widget.animationDuration, // So it does not jump.
        );
      }
    });

    return SizedBox(
      height: widget.childHeight,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          bool isScrollable =
              widget.children.length * widget.childWidth < constraints.maxWidth;
          return CustomScrollView(
            scrollDirection: Axis.horizontal,
            controller: widget.scrollController,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      top: 0,
                      bottom: 0,
                      left: isScrollable
                          ? constraints.maxWidth /
                                widget.children.length *
                                (_index)
                          : widget.childWidth * _index,
                      right: isScrollable
                          ? (constraints.maxWidth / (widget.children.length)) *
                                (widget.children.length - _index - 1)
                          : widget.childWidth *
                                (widget.children.length - _index - 1),
                      duration: widget.animationDuration,
                      curve: widget.curve,
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.foregroundColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(widget.radius),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: widget.children
                            .asMap()
                            .map(
                              (i, sideButton) => MapEntry(
                                i,
                                Expanded(
                                  key: widget.selectedItemIndex == i
                                      ? selectedBottomBarItemKey
                                      : ValueKey("toolbar_item_$i"),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(widget.radius),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          try {
                                            sideButton.onTap();
                                          } catch (e) {
                                            // print('onTap implementation is missing');
                                          }
                                          setState(() {
                                            _index = i;
                                          });
                                        },
                                        child: SizedBox(
                                          width: widget.childWidth,
                                          height: widget.childHeight,
                                          child: sideButton.child,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .values
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ScrollingButtonBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_index != widget.selectedItemIndex) {
      _index = widget.selectedItemIndex;
      setState(() {});
    }
  }
}

class ButtonsItem {
  final Widget child;
  final VoidCallback onTap;

  ButtonsItem({required this.child, required this.onTap});
}

class PayButton extends StatelessWidget {
  final String btnText;
  final Function ontap;
  final String amount;

  const PayButton({
    super.key,
    required this.btnText,
    required this.ontap,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: clrF3F3F3,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Payable amount",
                    style: t400_14.copyWith(color: clr757575),
                  ),
                  Text(
                    '₹$amount',
                    style: t700_22.copyWith(color: clr2D2D2D, height: 1),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                ontap();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colours.primaryblue,
                ),
                child: pad(
                  horizontal: 0,
                  vertical: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 4,
                    ),
                    child: Text(btnText, style: t400_16),
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

class ButtonWidget extends StatelessWidget {
  final String btnText;
  final Function? ontap;
  final Color? color;
  final bool? isLoading;
  final Color? textColor;
  final BoxBorder? border;

  const ButtonWidget({
    super.key,
    required this.btnText,
    this.isLoading,
    required this.ontap,
    this.color,
    this.textColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isLoading != true) {
          ontap!();
        }
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.circular(16),
          color: color ?? Colours.primaryblue,
        ),
        child: Center(
          child: isLoading == true
              ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 1,
                )
              : Text(btnText, style: t400_16.copyWith(color: textColor)),
        ),
      ),
    );
  }
}

class ErrorToast extends StatelessWidget {
  final String? message;
  final int? maxLines;
  const ErrorToast({super.key, required this.message, this.maxLines});

  @override
  Widget build(BuildContext context) {
    if (message == null || message == "" || message!.isEmpty) {
      return const SizedBox();
    }
    return CustomSnackBar.error(
      backgroundColor: const Color.fromARGB(255, 229, 113, 116),
      message: message ?? "",
      maxLines: maxLines ?? 2,
    );
  }
}

class SuccessToast extends StatelessWidget {
  final String? message;
  final int? maxLines;
  const SuccessToast({super.key, required this.message, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return CustomSnackBar.info(
      backgroundColor: Colours.primaryblue,
      icon: const SizedBox(),
      message: message ?? "",
      maxLines: maxLines ?? 2,
    );
  }
}
