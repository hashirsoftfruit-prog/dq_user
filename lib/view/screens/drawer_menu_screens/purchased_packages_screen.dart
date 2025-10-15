import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/home_screen.dart';

import 'dart:math';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/core/purchased_pkgs_list_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../booking_screens/booking_screen_widgets.dart';

class PurchasedPackagesScreen extends StatefulWidget {
  const PurchasedPackagesScreen({super.key});

  @override
  State<PurchasedPackagesScreen> createState() =>
      _PurchasedPackagesScreenState();
}

class _PurchasedPackagesScreenState extends State<PurchasedPackagesScreen> {
  // AvailableDocsModel docsData;
  // int index = 1;

  @override
  void initState() {
    super.initState();
    getIt<HomeManager>().getPurchasedPackages();
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
                title: AppLocalizations.of(context)!.purchasedPackages,
                height: h10p,
                width: w10p,
                fn: () {
                  Navigator.pop(context);
                },
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  getIt<HomeManager>().getPurchasedPackages();
                },
                child: ListView(
                  // controller: _controller,
                  children: [
                    verticalSpace(h1p * 2),
                    mgr.appoinmentsLoader == true &&
                            mgr.purchasedPackages == null
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
                        : mgr.purchasedPackages != null &&
                              mgr.purchasedPackages!.isNotEmpty
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
                                children: mgr.purchasedPackages!
                                    .map(
                                      (e) => InkWell(
                                        onTap: () async {
                                          // }
                                          // else{

                                          // }
                                        },
                                        child: PurchasedPackageContainer(
                                          h1p: h1p,
                                          w1p: w1p,
                                          pkg: e,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.noPackages,
                                style: TextStyles.notAvailableTxtStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
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

class PurchasedPackageContainer extends StatelessWidget {
  final double w1p;
  final double h1p;
  final PurchasedPackage pkg;
  const PurchasedPackageContainer({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.pkg,
  });

  // bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    String pkgStarting = pkg.startDate != null
        ? getIt<StateManager>().convertStringDateToMMMddyyyy(pkg.startDate!)
        : '';
    String pkgEnding = pkg.endDate != null
        ? getIt<StateManager>().convertStringDateToMMMddyyyy(pkg.endDate!)
        : '';

    int? pendignConsults = pkg.remainingNoOfConsultation ?? 0;
    int? daysLeft = max(
      0,
      getIt<StateManager>().calculateDayDifference(pkg.endDate ?? ""),
    );
    int? totalConsults = pkg.totalNoOfConsultation;
    int? totalMembers = pkg.packageMember?.length ?? 0;
    // int? totalMembers = 4;
    double amt = pkg.amount ?? 0;
    double circleSize = w1p * 7;

    Color bgclr = const Color(0xffF6F6F6);
    getCircle({int? patientsCount, Color? color, String? name}) {
      return Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          // boxShadow:
          // [BoxShadow(offset: Offset(-0.5,0.5),spreadRadius: 1,blurRadius:1,color: Colours.boxblue.withOpacity(0.1),),],
          shape: BoxShape.circle,
          color: color ?? getRandomColor(name ?? ""),
          // border: Border.all(color: bgclr,width: 1)
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
            child: SizedBox(
              child: patientsCount == null
                  // ? Icon(
                  //     Icons.person,
                  //     size: w1p * 4,
                  //     color: Colors.white,
                  //   )
                  ? Text(
                      name?.substring(0, 1) ?? "",
                      style: t700_12.copyWith(color: Colors.white),
                    )
                  : Center(
                      child: Text(
                        "+$patientsCount",
                        style: TextStyle(
                          fontSize: w1p * 3,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: 4, left: w1p * 5, right: w1p * 5, top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        // color: bgclr,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          boxShadow8,
          // BoxShadow(offset: Offset(1,1),spreadRadius: 2,blurRadius:4,
          //   color: Colours.boxblue.withOpacity(0.5),),
        ],
      ),
      child: pad(
        vertical: 18,
        horizontal: w1p * 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: w1p * 60,
                  child: Text(
                    pkg.packageTitle ?? '',
                    style: t500_16.copyWith(color: const Color(0xff363997)),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return AnimatedPopup(
                                child: PackageMembersCard(
                                  users: pkg.packageMember ?? [],
                                ),
                              ); // Animated dialog
                            },
                          );
                        },
                        child: SizedBox(
                          width: w1p * 20,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              totalMembers > 0
                                  ? getCircle(color: Colors.white)
                                  : const SizedBox(),
                              totalMembers > 1
                                  ? Positioned(
                                      right: totalMembers > 2 ? w1p * 8 : 0,
                                      child: getCircle(
                                        // color: clrFE9297,
                                        name:
                                            '${pkg.packageMember?[1].appUserFirstName} ${pkg.packageMember?[1].appUserLastName}',
                                      ),
                                    )
                                  : const SizedBox(),
                              totalMembers > 0
                                  ? Positioned(
                                      right: totalMembers == 1
                                          ? w1p * 2
                                          : w1p * 4,
                                      child: getCircle(
                                        // color: clr6C6EB8,
                                        name:
                                            '${pkg.packageMember?[0].appUserFirstName} ${pkg.packageMember?[0].appUserLastName}',
                                      ),
                                    )
                                  : const SizedBox(),
                              totalMembers > 2
                                  ? Positioned(
                                      right: 0,
                                      child: getCircle(
                                        color: Colours.boxblue,
                                        patientsCount: totalMembers - 2,
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      Text("Members", style: TextStyles.textStyle75b),
                    ],
                  ),
                ),
              ],
            ),
            verticalSpace(h1p * 2),
            Container(
              decoration: BoxDecoration(
                color: bgclr,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 2,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.black38,
                      size: 16,
                    ),
                    horizontalSpace(w1p * 2),
                    Text(
                      '$pkgStarting - $pkgEnding',
                      style: TextStyles.textStyle75,
                    ),
                  ],
                ),
              ),
            ),
            verticalSpace(h1p),
            Text(
              '$pendignConsults ${AppLocalizations.of(context)!.consultationLeftOutOf} $totalConsults',
              style: TextStyles.textStyle75,
            ),
            Text(
              '$daysLeft ${AppLocalizations.of(context)!.daysLeft}',
              style: TextStyles.textStyle75,
            ),
            verticalSpace(h1p),
            Row(
              children: List.generate(
                totalConsults ?? 0,
                (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: h1p * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: index < pendignConsults
                            ? Colours.lightBlu
                            : Colours.primaryblue,
                      ),
                    ),
                  ),
                ),
              ).toList(),
            ),
            verticalSpace(h1p * 2),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(1, 1),
                    spreadRadius: 3,
                    blurRadius: 4,
                    color: Colors.white38.withOpacity(0.1),
                  ),
                ],
                color: const Color(0xffE7E7E7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    '${AppLocalizations.of(context)!.packageFee}: $amt',
                    style: TextStyles.textStyle76,
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

class PackageMembersCard extends StatelessWidget {
  final List<PackageMember> users;

  const PackageMembersCard({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Member List',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: users.length,
          separatorBuilder: (context, index) => const Divider(height: 12),
          itemBuilder: (context, index) {
            final user = users[index];
            final color = getRandomColor(
              '${user.appUserFirstName} ${user.appUserLastName}',
            );

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: Text(
                  user.appUserFirstName![0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                '${user.appUserFirstName} ${user.appUserLastName}',
                style: t500_16.copyWith(color: clr2D2D2D),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
