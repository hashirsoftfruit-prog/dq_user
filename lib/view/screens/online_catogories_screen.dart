// ignore_for_file: use_build_context_synchronously

import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/controller/managers/category_manager.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/model/core/online_cat_response_model.dart';
import 'package:dqapp/view/screens/booking_screens/redacted_loaders.dart';
import 'package:dqapp/view/screens/widgets/appbar_widget.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/core/specialities_response_model.dart';
import '../../model/helper/service_locator.dart';
import '../theme/constants.dart';
import 'booking_screens/booking_loading_screen.dart';
import 'booking_screens/find_doctors_screen.dart';

class OnlineCategoriesScreen extends StatefulWidget {
  final bool? forScheduledBooking;
  final List<SpecialityList>? ayurOrHomeoList;
  const OnlineCategoriesScreen({
    super.key,
    this.ayurOrHomeoList,
    this.forScheduledBooking,
  });

  @override
  State<OnlineCategoriesScreen> createState() => _OnlineCategoriesScreenState();
}

class _OnlineCategoriesScreenState extends State<OnlineCategoriesScreen> {
  ScrollController scCntrol = ScrollController();

  // int hhht = 4;
  // late double ht;
  //   void _scrollListener()async {
  //
  //     if (
  //     // scCntrol.position.userScrollDirection==ScrollDirection.forward&&
  //         scCntrol.position.pixels>100
  //     ) {
  //       // print();
  //       getIt<StateManager>().changeHeight(1.8);
  //
  //     }else if(scCntrol.position.pixels<100){
  //       getIt<StateManager>().changeHeight(4);
  //
  //     }
  //   }

  @override
  void initState() {
    if (widget.ayurOrHomeoList == null) {
      getIt<CategoryMgr>().getCategories();
    }

    // scCntrol.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fn({
      required int specialityId,
      int? subCatList,
      required String specialityTitle,
    }) async {
      if (widget.forScheduledBooking == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FindDoctorsListScreen(
              specialityId: specialityId,
              subSpecialityIdForPsychology: null,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CheckIfDoctorAvailableScreen(
              categoryId: null,
              specialityId: specialityId,
              specialityTitle: specialityTitle,
            ),
          ),
        );

        // var result = await getIt<BookingManager>().getDocsList(specialityId: specialityId);
        // if (result.status == true && result.isAnyDoctorExist == true) {
        //   getIt<BookingManager>().setDocsData(result);
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => BookingScreen(
        //                 specialityId: specialityId,
        //                 itemName: specialityTitle,
        //                 subCatId: null,
        //               )));
        // } else {
        //   showTopSnackBar(
        //       Overlay.of(context),
        //       ErrorToast(
        //         message: result.message,
        //       ));
        // }
      }
    }

    var get = getIt<SmallWidgets>();
    bool availableDocsLoader = Provider.of<BookingManager>(
      context,
    ).bookingScreenLoader;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        String appBarTitle1 = widget.forScheduledBooking == true
            ? "Book Your"
            : "Live Video";
        String appBarTitle2 = widget.forScheduledBooking == true
            ? "Appointment"
            : "Consultation";
        // SliverGridDelegateWithFixedCrossAxisCount params = const SliverGridDelegateWithFixedCrossAxisCount(
        //     mainAxisExtent: 100,
        //     crossAxisSpacing: 2,
        //     mainAxisSpacing: 2,
        //     crossAxisCount: 4);

        return Consumer<CategoryMgr>(
          builder: (context, mgr, child) {
            OnlineCategoriesModel? model = mgr.onlineCats;
            CategoryModel? popSpecialites;
            CategoryModel? healthIssues;
            CategoryModel? commnsyms;
            String? title1;
            String? title2;
            String? title3;
            if (model != null &&
                (model.popularSpecialities != null ||
                    model.healthIssues != null ||
                    model.commonSymptoms != null)) {
              popSpecialites = model.popularSpecialities;
              healthIssues = model.healthIssues;
              commnsyms = model.commonSymptoms;
              title1 = popSpecialites?.title;
              title2 = healthIssues?.title;
              title3 = commnsyms?.title;
            }
            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              extendBody: true,

              // appBar: get.appBarWidget(
              //     title: widget.forScheduledBooking == true
              //         ? AppLocalizations.of(context)!.findDoctorsClinic
              //         :AppLocalizations.of(context)!.liveVideoConsult2,
              //     height: h10p,
              //     width: w10p,
              //     fn: () {
              //       Navigator.pop(context);
              //     })
              // ,
              body: Container(
                height: maxHeight,
                width: maxWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      if (widget.forScheduledBooking!) ...[
                        const Color(0xffFE9297),
                        const Color.fromARGB(255, 255, 180, 183),
                      ] else ...[
                        const Color(0xff8467A6),
                        const Color.fromARGB(255, 191, 152, 235),
                      ],
                      clrFFFFFF,
                      clrFFFFFF,
                      clrFFFFFF,
                      clrFFFFFF,
                    ],

                    end: Alignment.bottomCenter,
                    begin: Alignment.topCenter,
                  ),
                ),
                child: Stack(
                  children: [
                    SafeArea(
                      child: Entry(
                        xOffset: 1000,
                        // scale: 20,
                        delay: const Duration(milliseconds: 0),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.ease,
                        child: CustomScrollView(
                          slivers: [
                            SliverPersistentHeader(
                              delegate: AppBarForOnlineCategoryScreen(
                                title1: appBarTitle1,
                                title2: appBarTitle2,
                                w1p: w1p,
                                minHeight: 60,
                                maxHeight: 120,
                                forScheduledBooking:
                                    widget.forScheduledBooking!,
                                // slotCount: "${mgr.doctorSlotPickModel?.selectedDate?.timeList?.length??0} ${AppLocalizations.of(context)!.slotsAvailable}", // Replace with your asset path
                              ),
                              floating: true,
                              pinned:
                                  true, // Keeps it at the top while scrolling
                            ),
                            // SliverAppBar(
                            //   automaticallyImplyLeading: false,
                            //   foregroundColor: Colors.white,
                            //   // backgroundColor:clrFFEDEE,
                            //   floating: true,
                            //   pinned: true,
                            //   // toolbarHeight: 136,
                            //   collapsedHeight: 137,
                            //   expandedHeight: 140,

                            //   flexibleSpace: Container(
                            //     decoration: BoxDecoration(
                            //       borderRadius: const BorderRadius.vertical(
                            //         bottom: Radius.circular(20),
                            //       ),
                            //       gradient: LinearGradient(
                            //         begin: Alignment.topLeft,
                            //         end: Alignment.bottomCenter,
                            //         colors: widget.forScheduledBooking == true
                            //             ? [
                            //                 const Color(0xffFE9297),
                            //                 // Color(0xffFE9297),
                            //                 // Color(0xff6C6EB8),
                            //                 const Color(0xff6C6EB8),
                            //               ]
                            //             : [
                            //                 const Color(0xff8467A6),
                            //                 const Color(0xff8467A6),
                            //                 const Color(0xff5D5AAB),
                            //               ],
                            //       ),
                            //     ),
                            //     child: SafeArea(
                            //       child: Padding(
                            //         padding: EdgeInsets.symmetric(
                            //           horizontal: w1p * 4,
                            //           vertical: 8,
                            //         ),
                            //         child: Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Row(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.spaceBetween,
                            //               children: [
                            //                 GestureDetector(
                            //                   onTap: () {
                            //                     Navigator.pop(context);
                            //                   },
                            //                   child: SizedBox(
                            //                     height: 50,
                            //                     width: 30,
                            //                     child: Image.asset(
                            //                       "assets/images/back-cupertino.png",
                            //                       color: Colors.white,
                            //                     ),
                            //                   ),
                            //                 ),

                            //                 const Spacer(),
                            //                 // SizedBox(
                            //                 //     height: 25,
                            //                 //     child: Image.asset("assets/images/location-icon.png")),
                            //                 // horizontalSpace(2),
                            //                 // Text("Kozhikode",style: t700_14.copyWith(color: clr2D2D2D),)
                            //               ],
                            //             ),
                            //             const Spacer(),
                            //             Row(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.spaceBetween,
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.end,
                            //               children: [
                            //                 Column(
                            //                   crossAxisAlignment:
                            //                       CrossAxisAlignment.start,
                            //                   children: [
                            //                     Text(
                            //                       appBarTitle1,
                            //                       style: t400_18.copyWith(
                            //                         height: 1,
                            //                       ),
                            //                     ),
                            //                     Text(
                            //                       appBarTitle2,
                            //                       style: t500_20.copyWith(
                            //                         height: 1,
                            //                       ),
                            //                     ),
                            //                   ],
                            //                 ),
                            //                 widget.forScheduledBooking == true
                            //                     ? const SizedBox()
                            //                     : Container(
                            //                         height: 45,
                            //                         decoration: BoxDecoration(
                            //                           color: Colors.white,
                            //                           borderRadius:
                            //                               BorderRadius.circular(
                            //                                 20,
                            //                               ),
                            //                         ),
                            //                         child: Padding(
                            //                           padding:
                            //                               const EdgeInsets.symmetric(
                            //                                 horizontal: 8.0,
                            //                               ),
                            //                           child: Row(
                            //                             children: [
                            //                               SizedBox(
                            //                                 width: 20,
                            //                                 height: 20,
                            //                                 child: Image.asset(
                            //                                   "assets/images/video-call-icon.png",
                            //                                 ),
                            //                               ),
                            //                               horizontalSpace(4),
                            //                               Text(
                            //                                 "Connect with\nin 30 Sec",
                            //                                 style: t400_10
                            //                                     .copyWith(
                            //                                       color:
                            //                                           clr7261A8,
                            //                                     ),
                            //                               ),
                            //                             ],
                            //                           ),
                            //                         ),
                            //                       ),
                            //               ],
                            //             ),
                            //             verticalSpace(8),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            SliverPadding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: w1p * 4,
                              ),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate([
                                  get.searchBarBox(
                                    title: AppLocalizations.of(
                                      context,
                                    )!.searchSpecialitesSymptoms,
                                    height: h10p,
                                    width: w10p,
                                  ),
                                ]),
                              ),
                            ),
                            if (mgr.onlineCatLoader)
                              // const Center(child: LogoLoader())
                              SliverPadding(
                                padding: const EdgeInsets.all(2),
                                sliver: SliverToBoxAdapter(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (var i = 0; i < 4; i++)
                                        Row(
                                          children: [
                                            for (var j = 0; j < 3; j++)
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: SkeletonBox(
                                                  width: 100,
                                                  height: 100,
                                                ),
                                              ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            if (widget.ayurOrHomeoList != null &&
                                widget.ayurOrHomeoList!.isNotEmpty)
                              SliverPadding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w1p * 4,
                                ),
                                sliver: SliverList(
                                  delegate: SliverChildListDelegate([
                                    get.searchBarBox(
                                      title: "Search Treatment",
                                      height: h10p,
                                      width: w10p,
                                      visibility: true,
                                      onchangedFn: (value) =>
                                          mgr.searchSpeciality(value),
                                    ),
                                    verticalSpace(h1p),
                                    verticalSpace(h1p * 0.5),
                                    SizedBox(
                                      width: maxWidth,
                                      child: GridView(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                            ),
                                        // crossAxisCount: 4,
                                        children: List.generate(
                                          widget.ayurOrHomeoList!.length,
                                          (index) {
                                            String title =
                                                widget
                                                    .ayurOrHomeoList?[index]
                                                    .title ??
                                                "";
                                            String img =
                                                widget
                                                    .ayurOrHomeoList?[index]
                                                    .image ??
                                                "";
                                            int id = widget
                                                .ayurOrHomeoList![index]
                                                .id!;

                                            // var subtitel = popSpecialites.subcategory![index].title;
                                            return CategoryItem(
                                              onClick: () async {
                                                fn(
                                                  specialityId: id,
                                                  specialityTitle: title,
                                                );
                                              },
                                              w1p: w1p,
                                              h1p: h1p,
                                              title: title,
                                              img: img,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    verticalSpace(h1p),
                                    verticalSpace(h1p),
                                  ]),
                                ),
                              ),
                            if (widget.ayurOrHomeoList == null) ...[
                              if (popSpecialites?.subcategory != null &&
                                  popSpecialites!.subcategory!.isNotEmpty) ...[
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 4,
                                  ),
                                  sliver: SliverToBoxAdapter(
                                    child: get.categoryHeading(
                                      title: title1 ?? "",
                                      fn: () {},
                                      showViewAll:
                                          popSpecialites.subcategory!.length >
                                          8,
                                    ),
                                  ),
                                ),
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 4,
                                  ), // Optional spacing
                                  sliver: SliverGrid(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        String? title = popSpecialites!
                                            .subcategory![index]
                                            .title;
                                        String? img =
                                            popSpecialites
                                                .subcategory![index]
                                                .icon ??
                                            "";
                                        int? id = popSpecialites
                                            .subcategory![index]
                                            .speciality;

                                        return CategoryItem(
                                          w1p: w1p,
                                          h1p: h1p,
                                          title: title ?? "",
                                          img: img,
                                          onClick: () async {
                                            await fn(
                                              specialityTitle: title ?? '',
                                              specialityId: id!,
                                              subCatList: null,
                                            );
                                          },
                                        );
                                      },
                                      childCount:
                                          popSpecialites.subcategory!.length > 8
                                          ? 8
                                          : popSpecialites.subcategory!.length,
                                    ),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              3, // Adjust grid layout as needed
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                          childAspectRatio:
                                              .95, // Adjust to prevent overflow
                                        ),
                                  ),
                                ),
                              ],
                              if (healthIssues?.subcategory != null &&
                                  healthIssues!.subcategory!.isNotEmpty) ...[
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 4,
                                  ),
                                  sliver: SliverToBoxAdapter(
                                    child: get.categoryHeading(
                                      title: title2 ?? "",
                                      fn: () {},
                                      showViewAll:
                                          healthIssues.subcategory!.length > 8,
                                    ),
                                  ),
                                ),
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 4,
                                  ), // Optional spacing
                                  sliver: SliverGrid(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        var title = healthIssues!
                                            .subcategory![index]
                                            .title;
                                        var img =
                                            healthIssues
                                                .subcategory![index]
                                                .icon ??
                                            "";
                                        var id = healthIssues
                                            .subcategory![index]
                                            .speciality;

                                        return GestureDetector(
                                          onTap: () async {
                                            await fn(
                                              specialityTitle: title ?? '',
                                              specialityId: id!,
                                            );
                                          },
                                          child: CategoryItem(
                                            w1p: w1p,
                                            h1p: h1p,
                                            title: title ?? "",
                                            img: img,
                                            onClick: () async {
                                              await fn(
                                                specialityTitle: title ?? '',
                                                specialityId: id!,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      childCount:
                                          healthIssues.subcategory!.length > 8
                                          ? 8
                                          : healthIssues.subcategory!.length,
                                    ),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3, // 3 items per row
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                          childAspectRatio:
                                              .95, // Adjust as needed to prevent overflow
                                        ),
                                  ),
                                ),
                              ],
                              if (commnsyms?.subcategory != null &&
                                  commnsyms!.subcategory!.isNotEmpty) ...[
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 4,
                                  ),
                                  sliver: SliverToBoxAdapter(
                                    child: get.categoryHeading(
                                      title: title3 ?? "",
                                      fn: () {},
                                      showViewAll:
                                          commnsyms.subcategory!.length > 8,
                                    ),
                                  ),
                                ),
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 4,
                                  ), // Optional spacing
                                  sliver: SliverGrid(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        var title = commnsyms!
                                            .subcategory![index]
                                            .title;
                                        var img =
                                            commnsyms
                                                .subcategory![index]
                                                .icon ??
                                            "";
                                        var id = commnsyms
                                            .subcategory![index]
                                            .speciality;

                                        return GestureDetector(
                                          onTap: () async {
                                            await fn(
                                              specialityTitle: title ?? '',
                                              specialityId: id!,
                                            );
                                          },
                                          child: CategoryItem(
                                            w1p: w1p,
                                            h1p: h1p,
                                            title: title ?? "",
                                            img: img,
                                            onClick: () async {
                                              await fn(
                                                specialityTitle: title ?? '',
                                                specialityId: id!,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      childCount:
                                          commnsyms.subcategory!.length > 8
                                          ? 8
                                          : commnsyms.subcategory!.length,
                                    ),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3, // Adjust as needed
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                          childAspectRatio:
                                              .95, // Adjust to prevent overflow
                                        ),
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),
                    myLoader(
                      width: maxWidth,
                      height: maxHeight,
                      visibility: availableDocsLoader,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// class LeftCornerClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(size.width, 0.0);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0.0, size.height);
//     path.lineTo(0.0, size.height - 50.0); // Adjust the curve position
//     path.quadraticBezierTo(0.0, size.height - 50.0, 50.0, size.height - 100.0); // Adjust control points to modify curve
//     path.lineTo(0.0, 0.0); // Returning back to initial point closes the path
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }
