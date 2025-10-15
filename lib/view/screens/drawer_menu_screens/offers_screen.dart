import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/home_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:generic_expandable_text/expandable_text.dart';
import 'package:provider/provider.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../booking_screens/offers_listing_screen.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  // AvailableDocsModel docsData;
  // int index = 1;

  @override
  void initState() {
    super.initState();
    getIt<HomeManager>().getOffersList();
    // _controller.addListener(_scrollListener);
  }

  // final ScrollController _controller = ScrollController();
  //
  // void _scrollListener()async {
  //   if (_controller.position.pixels == _controller.position.maxScrollExtent) {
  //     index++;
  //     getIt<HomeManager>().getConsultaions(index:index );
  //   }
  // }

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
        //                 style: selected ? t500_14.copyWith(color: Color(0xff5054e5), height: 1) : t500_14.copyWith(color: clr444444, height: 1),
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
                title: AppLocalizations.of(context)!.offers,
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
                    await getIt<HomeManager>().getOffersList();
                  },
                  child: ListView(
                    // controller: _controller,
                    children: [
                      verticalSpace(h1p * 2),
                      mgr.appoinmentsLoader == true && mgr.offersModel == null
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
                          : mgr.offersModel != null &&
                                ((mgr.offersModel?.discountList != null &&
                                        mgr
                                            .offersModel!
                                            .discountList!
                                            .isNotEmpty) ||
                                    (mgr.offersModel?.couponList != null &&
                                        mgr
                                            .offersModel!
                                            .couponList!
                                            .isNotEmpty))
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
                                    mgr.offersModel!.couponList != null &&
                                            mgr
                                                .offersModel!
                                                .couponList!
                                                .isNotEmpty
                                        ? Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  // Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          OffersListScreen(
                                                            couponList:
                                                                mgr
                                                                    .offersModel!
                                                                    .couponList ??
                                                                [],
                                                            discountList:
                                                                const [],
                                                            isCoupon: true,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  // decoration: const BoxDecoration(
                                                  //   borderRadius: BorderRadius.only(
                                                  //     topRight: Radius.circular(10),
                                                  //     topLeft: Radius.circular(10),
                                                  //   ),
                                                  // color: Colours.primaryblue,
                                                  // ),
                                                  child: pad(
                                                    horizontal: w1p * 4,
                                                    vertical: h1p * 0.5,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.coupons,
                                                          style: t500_18
                                                              .copyWith(
                                                                color:
                                                                    clr2D2D2D,
                                                              ),
                                                        ),
                                                        Text(
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.seeAll,
                                                          style: t500_14
                                                              .copyWith(
                                                                color:
                                                                    clr2D2D2D,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              CarouselSlider(
                                                options: CarouselOptions(
                                                  height: 150,
                                                  // height: h10p*2.7,
                                                  viewportFraction: 1,
                                                  enableInfiniteScroll:
                                                      mgr
                                                              .offersModel!
                                                              .couponList!
                                                              .length >
                                                          1
                                                      ? true
                                                      : false,
                                                  autoPlay:
                                                      mgr
                                                              .offersModel!
                                                              .couponList!
                                                              .length >
                                                          1
                                                      ? true
                                                      : false,
                                                  aspectRatio: 16 / 9,
                                                  // enlargeCenterPage: true
                                                ),
                                                items: mgr
                                                    .offersModel!
                                                    .couponList!
                                                    .map(
                                                      (e) => pad(
                                                        vertical: 0,
                                                        horizontal: 0,
                                                        child: GestureDetector(
                                                          onTap: () {},
                                                          child: CouponContainer(
                                                            title:
                                                                e.title ?? "",
                                                            subtitle:
                                                                e.subtitle ??
                                                                "",
                                                            h1p: h1p,
                                                            w1p: w1p,
                                                            couponCode:
                                                                e.couponCode ??
                                                                "",
                                                            // couponCode: e.couponCode??"",
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                    verticalSpace(h1p * 2),
                                    mgr.offersModel!.discountList != null &&
                                            mgr
                                                .offersModel!
                                                .discountList!
                                                .isNotEmpty
                                        ? Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          OffersListScreen(
                                                            couponList:
                                                                const [],
                                                            discountList:
                                                                mgr
                                                                    .offersModel!
                                                                    .discountList ??
                                                                [],
                                                            isCoupon: false,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  // decoration: const BoxDecoration(
                                                  //   borderRadius: BorderRadius.only(
                                                  //     topRight: Radius.circular(10),
                                                  //     bottomLeft: Radius.circular(10),
                                                  //   ),
                                                  //   color: Colours.primaryblue,
                                                  // ),
                                                  child: pad(
                                                    horizontal: w1p * 4,
                                                    vertical: h1p * 0.5,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.discounts,
                                                          style: t500_18
                                                              .copyWith(
                                                                color:
                                                                    clr2D2D2D,
                                                              ),
                                                        ),
                                                        Text(
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.seeAll,
                                                          style: t500_14
                                                              .copyWith(
                                                                color:
                                                                    clr2D2D2D,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              CarouselSlider(
                                                options: CarouselOptions(
                                                  height: 150,
                                                  // height: h10p*2.7,
                                                  viewportFraction: 1,
                                                  enableInfiniteScroll:
                                                      mgr
                                                              .offersModel!
                                                              .discountList!
                                                              .length >
                                                          1
                                                      ? true
                                                      : false,
                                                  autoPlay:
                                                      mgr
                                                              .offersModel!
                                                              .discountList!
                                                              .length >
                                                          1
                                                      ? true
                                                      : false,
                                                  aspectRatio: 16 / 9,
                                                  // enlargeCenterPage: true
                                                ),
                                                items: mgr
                                                    .offersModel!
                                                    .discountList!
                                                    .map(
                                                      (e) => pad(
                                                        vertical: 0,
                                                        horizontal: 0,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            // Navigator.push(context, MaterialPageRoute(builder: (_)=>DoctorProfileScreen()));
                                                          },
                                                          child:
                                                              DiscountContainer(
                                                                title:
                                                                    e.title ??
                                                                    "",
                                                                subtitle:
                                                                    e.subtitle ??
                                                                    "",
                                                                h1p: h1p,
                                                                w1p: w1p,
                                                                offerPrice:
                                                                    "200",
                                                                savedAmount:
                                                                    "100",
                                                              ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.noOffers,
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

// class CouponContainer extends StatelessWidget {
//   final double w1p;
//   final double h1p;
//   final String title;
//   final String subtitle;
//   final String couponCode;
//   final bool? isShowInListScreen;
//   const CouponContainer({
//     super.key,
//     required this.h1p,
//     required this.w1p,
//     required this.subtitle,
//     required this.title,
//     required this.couponCode,
//     this.isShowInListScreen,
//   });
//   // bool isExpand = false;
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topRight: Radius.circular(10),
//         topLeft: Radius.circular(10),
//         bottomRight: Radius.circular(10),
//         bottomLeft: Radius.circular(10),
//         // bottomRight: Radius.circular(isShowInListScreen == true ? 10 : 0),
//         // bottomLeft: Radius.circular(isShowInListScreen == true ? 10 : 0),
//       ),
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Colours.couponBgClr,
//           // borderRadius: BorderRadius.circular(10)
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//                 bottom: -10,
//                 left: 0,
//                 child: SizedBox(
//                     width: 100,
//                     height: 100,
//                     child: SvgPicture.asset(
//                       "assets/images/start-eclip1.svg",
//                       colorFilter: const ColorFilter.mode(Colours.primaryblue, BlendMode.srcIn),
//                     ))),
//             Positioned(
//                 top: -10,
//                 right: 0,
//                 child: RotatedBox(
//                     quarterTurns: 0,
//                     child: SizedBox(
//                         width: 80,
//                         height: 80,
//                         child: SvgPicture.asset(
//                           "assets/images/icon-coupon.svg",
//                           colorFilter: ColorFilter.mode(Colours.primaryblue.withOpacity(0.2), BlendMode.srcIn),
//                         )))),
//             pad(
//               vertical: isShowInListScreen == true ? 48 : 8,
//               horizontal: w1p * 4,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               title,
//                               style: t700_16.copyWith(color: const Color(0xff3d41ad), height: 1.1),
//                               maxLines: isShowInListScreen == true ? 5 : 3,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             verticalSpace(h1p),
//                             isShowInListScreen == true
//                                 ? GenericExpandableText(
//                                     textAlign: TextAlign.start,
//                                     subtitle,
//                                     style: t400_13.copyWith(color: clr444444, height: 1.4),
//                                     readlessColor: Colours.primaryblue,
//                                     readmoreColor: Colours.primaryblue,
//                                     hasReadMore: true,
//                                     maxLines: 2,
//                                   )
//                                 : Text(subtitle, style: t400_13.copyWith(color: clr444444, height: 1.4), maxLines: isShowInListScreen == true ? 5 : 3, overflow: TextOverflow.ellipsis),
//                           ],
//                         ),
//                       ),
//                       horizontalSpace(w1p * 7),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CouponContainer extends StatefulWidget {
  final double w1p;
  final double h1p;
  final String title;
  final String subtitle;
  final String? couponCode;
  final String? description;
  final String? discountType;
  final String? discountValue;
  final String? maxSpend;
  final String? consultationType;
  final String? startDate;
  final String? endDate;
  final bool? isApplicableToAll;
  final bool? isShowInListScreen;

  const CouponContainer({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.title,
    required this.subtitle,
    this.couponCode,
    this.description,
    this.discountType,
    this.discountValue,
    this.consultationType,
    this.startDate,
    this.endDate,
    this.isShowInListScreen,
    this.isApplicableToAll,
    this.maxSpend,
  });

  @override
  State<CouponContainer> createState() => _CouponContainerState();
}

class _CouponContainerState extends State<CouponContainer> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        // padding: EdgeInsets.all(widget.w1p * 4),
        decoration: BoxDecoration(
          color: Colours.couponBgClr,
          // gradient: LinearGradient(
          //   colors: [Colours.primaryblue.withOpacity(0.1), Colors.white],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          // border: Border.all(color: Colours.primaryblue.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            if (widget.couponCode == null)
              Positioned(
                bottom: -10,
                left: 0,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: SvgPicture.asset(
                    "assets/images/start-eclip1.svg",
                    colorFilter: const ColorFilter.mode(
                      Colours.primaryblue,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            Positioned(
              top: -10,
              right: 0,
              child: RotatedBox(
                quarterTurns: 0,
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: SvgPicture.asset(
                    "assets/images/${widget.couponCode != null ? 'icon-coupon' : 'icon-offers'}.svg",
                    colorFilter: ColorFilter.mode(
                      Colours.primaryblue.withOpacity(0.08),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                widget.h1p * 2,
                widget.h1p * 2,
                widget.h1p * 2,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title and Subtitle
                  Text(
                    widget.title,
                    style: t700_16.copyWith(color: Colours.primaryblue),
                  ),
                  verticalSpace(widget.h1p * 0.5),
                  Text(
                    widget.subtitle,
                    style: t400_13.copyWith(color: clr444444),
                  ),

                  verticalSpace(widget.h1p * 3.5),

                  /// Coupon Code Banner
                  if (widget.couponCode != null && widget.couponCode != '')
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: widget.h1p,
                        horizontal: widget.w1p * 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colours.primaryblue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colours.primaryblue),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.discount,
                            color: Colours.primaryblue,
                            size: 20,
                          ),
                          horizontalSpace(widget.w1p),
                          Text(
                            "Use Code: ",
                            style: t500_14.copyWith(color: Colours.primaryblue),
                          ),
                          Text(
                            widget.couponCode ?? '',
                            style: t700_14.copyWith(color: Colours.primaryblue),
                          ),
                        ],
                      ),
                    ),

                  /// Expandable Content
                  if (isExpanded && widget.isShowInListScreen == true) ...[
                    verticalSpace(widget.h1p * 1.5),
                    if (widget.description != null &&
                        widget.description != "") ...[
                      Text(
                        widget.description ?? '',
                        style: t400_13.copyWith(color: Colors.black87),
                      ),
                      verticalSpace(widget.h1p),
                    ],

                    Row(
                      children: [
                        Icon(
                          Icons.local_offer_rounded,
                          color: Colors.green.shade700,
                          size: 18,
                        ),
                        horizontalSpace(6),
                        Text(
                          "${widget.discountValue} ${widget.discountType == 'Amount' ? 'Rs' : '%'} Off ${widget.maxSpend != null && widget.discountType != 'Amount' ? 'upto ${widget.maxSpend}' : ''}",
                          style: t600_14.copyWith(color: Colors.black54),
                        ),
                      ],
                    ),

                    verticalSpace(widget.h1p),
                    Row(
                      children: [
                        const Icon(
                          Icons.medical_services,
                          color: Colors.deepPurple,
                          size: 18,
                        ),
                        horizontalSpace(6),
                        Text(
                          "Consultation Type: ${widget.consultationType}",
                          style: t600_14.copyWith(color: Colors.black54),
                        ),
                      ],
                    ),

                    verticalSpace(widget.h1p),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: Colors.orange,
                        ),
                        horizontalSpace(6),
                        Text(
                          "Valid: ${widget.startDate} to ${widget.endDate}",
                          style: t600_14.copyWith(color: Colors.black54),
                        ),
                      ],
                    ),

                    if (widget.couponCode != null) ...[
                      verticalSpace(widget.h1p),
                      Text(
                        widget.isApplicableToAll == true
                            ? "Applicable to all specialities"
                            : "Applicable to selected specialities only",
                        style: t600_14.copyWith(color: Colours.primaryblue),
                      ),
                      verticalSpace(widget.h1p * 0.5),
                    ],

                    /// Display as chips
                    // Wrap(
                    //   spacing: 6,
                    //   runSpacing: 6,
                    //   children: widget.specialities
                    //       .take(8)
                    //       .map((s) => Chip(
                    //             label: Text(s, style: TextStyle(fontSize: 12)),
                    //             backgroundColor: Colours.primaryblue.withOpacity(0.1),
                    //             shape: StadiumBorder(side: BorderSide(color: Colours.primaryblue.withOpacity(0.3))),
                    //           ))
                    //       .toList(),
                    // ),

                    // if (widget.specialities.length > 8)
                    //   Padding(
                    //     padding: EdgeInsets.only(top: widget.h1p),
                    //     child: Text("+${widget.specialities.length - 8} more", style: t400_12.copyWith(color: Colors.grey)),
                    //   ),
                  ],

                  // verticalSpace(widget.h1p * 1.5),

                  /// View More / Less button
                  if (widget.isShowInListScreen == true)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () =>
                            setState(() => isExpanded = !isExpanded),
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          size: 18,
                        ),
                        label: Text(isExpanded ? "View Less" : "View More"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colours.primaryblue,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiscountContainer extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String title;
  final String subtitle;
  final String offerPrice;
  final String savedAmount;
  final bool? isShowInListScreen;
  const DiscountContainer({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.subtitle,
    required this.title,
    required this.offerPrice,
    required this.savedAmount,
    this.isShowInListScreen,
  });

  // bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: const Radius.circular(10),
        topLeft: const Radius.circular(10),
        bottomRight: Radius.circular(isShowInListScreen == true ? 10 : 0),
        bottomLeft: Radius.circular(isShowInListScreen == true ? 10 : 0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colours.couponBgClr,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -10,
              left: 0,
              child: SizedBox(
                width: 100,
                height: 100,
                child: SvgPicture.asset(
                  "assets/images/start-eclip1.svg",
                  colorFilter: const ColorFilter.mode(
                    Colours.primaryblue,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -10,
              right: 0,
              child: RotatedBox(
                quarterTurns: 0,
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: SvgPicture.asset(
                    "assets/images/icon-offers.svg",
                    colorFilter: ColorFilter.mode(
                      Colours.primaryblue.withOpacity(0.2),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            pad(
              vertical: isShowInListScreen == true ? 48 : 8,
              horizontal: w1p * 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: t700_16.copyWith(
                                color: const Color(0xff3d41ad),
                                height: 1.1,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            verticalSpace(h1p),
                            isShowInListScreen == true
                                ? GenericExpandableText(
                                    textAlign: TextAlign.start,
                                    subtitle,
                                    style: t400_13.copyWith(
                                      color: clr444444,
                                      height: 1.4,
                                    ),
                                    readlessColor: Colours.primaryblue,
                                    readmoreColor: Colours.primaryblue,
                                    hasReadMore: true,
                                    maxLines: 2,
                                  )
                                : Text(
                                    subtitle,
                                    style: t400_12.copyWith(
                                      color: clr444444,
                                      height: 1.2,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ],
                        ),
                      ),
                      horizontalSpace(w1p * 7),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
