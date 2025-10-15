// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/controller/services/payment_service.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/home_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../booking_screens/booking_screen_widgets.dart';
import '../booking_screens/package_details_screen.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  // AvailableDocsModel docsData;
  // int index = 1;

  @override
  void initState() {
    super.initState();
    getIt<HomeManager>().getPackages();
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

        return PopScope(
          canPop: false, // We'll handle the logic manually
          onPopInvokedWithResult: (didPop, result) async {
            final homeManager = getIt<HomeManager>();
            final paymentStatus = homeManager.isPaymentOnProcess;

            // If a payment is in progress
            if (paymentStatus) {
              if (Platform.isAndroid) {
                final backPressResult = await PaymentService.instance.hyperSDK
                    .onBackPress();
                log(
                  "message is Back press status from HyperSDK: $backPressResult",
                );

                // If SDK allows back navigation
                if (backPressResult.toLowerCase() == "true") {
                  if (context.mounted) Navigator.of(context).pop();
                } else {
                  // Block back press while payment in progress
                  log(
                    "message is Back press blocked due to ongoing payment or loading",
                  );
                }
              }
              return; // Don't pop automatically
            }
            log("message is no payment is on process");
            // If no payment is in progress → normal back navigation

            if (context.mounted) Navigator.of(context).pop();
          },
          child: Consumer<HomeManager>(
            builder: (context, mgr, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mgr.isPaymentOnProcess &&
                    mgr.paymentMessage == "charged") {
                  showTopSnackBar(
                    Overlay.of(context),
                    const SuccessToast(
                      message: "You have succesfully purchased the package",
                    ),
                  );
                  getIt<HomeManager>().resetPaymentStatus();
                } else if (!mgr.isPaymentOnProcess &&
                    mgr.paymentMessage != "") {
                  showTopSnackBar(
                    Overlay.of(context),
                    ErrorToast(
                      message: mgr.paymentMessage != ""
                          ? mgr.paymentMessage
                          : "Something went wrong",
                    ),
                  );
                  getIt<HomeManager>().resetPaymentStatus();
                }
              });
              return Scaffold(
                // extendBody: true,
                backgroundColor: Colors.white,
                appBar: getIt<SmallWidgets>().appBarWidget(
                  title: AppLocalizations.of(context)!.packages,
                  height: h10p,
                  width: w10p,
                  fn: () {
                    Navigator.pop(context);
                  },
                ),
                body: mgr.isPaymentOnProcess
                    ? const LogoLoader()
                    : pad(
                        horizontal: w1p * 5,
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await getIt<HomeManager>().getPackages();
                          },
                          child: ListView(
                            // controller: _controller,
                            children: [
                              // verticalSpace(h1p*2),
                              mgr.appoinmentsLoader == true &&
                                      mgr.allPackages == null
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
                                  : mgr.allPackages != null
                                  ? Entry(
                                      xOffset: -1000,
                                      // scale: 20,
                                      delay: const Duration(milliseconds: 0),
                                      duration: const Duration(
                                        milliseconds: 700,
                                      ),
                                      curve: Curves.ease,
                                      child: Entry(
                                        opacity: .5,
                                        // angle: 3.1415,
                                        delay: const Duration(milliseconds: 0),
                                        duration: const Duration(
                                          milliseconds: 1500,
                                        ),
                                        curve: Curves.decelerate,
                                        child: Column(
                                          children: mgr.allPackages!
                                              .map(
                                                (e) => InkWell(
                                                  onTap: () async {
                                                    // if(mgr.selectedPatientDetails!=null){
                                                    //   if(mgr.consultingForOther){
                                                    //     getIt<BookingManager>().setPatientsUnderPackage(user:mgr.selectedPatientDetails!,isAdd:true);
                                                    //
                                                    //   }
                                                    await getIt<
                                                          BookingManager
                                                        >()
                                                        .getPatientsDetailsList();

                                                    var result =
                                                        await showModalBottomSheet(
                                                          backgroundColor:
                                                              Colors.blueGrey,
                                                          isScrollControlled:
                                                              true,
                                                          useSafeArea: true,
                                                          context: context,
                                                          builder: (context) =>
                                                              PackageDetailsScreen(
                                                                alreadySelectedUser:
                                                                    null,
                                                                maxWidth:
                                                                    maxWidth,
                                                                maxHeight:
                                                                    maxHeight,
                                                                pkg: e,
                                                              ),
                                                        );

                                                    if (result != null) {
                                                      // var res =
                                                      //     await getIt<
                                                      //           HomeManager
                                                      //         >()
                                                      //         .purchasePkgApi(
                                                      //           result,
                                                      //         );
                                                      // await getIt<
                                                      //       BookingManager
                                                      //     >()
                                                      //     .setSelectedPackage(
                                                      //       null,
                                                      //     );

                                                      // Navigator.of(context).push(
                                                      //   MaterialPageRoute(
                                                      //     builder: (ctx) =>
                                                      //         PackagePaymentInfoScreen(
                                                      //           result: result,
                                                      //         ),
                                                      //   ),
                                                      // );

                                                      showDialog(
                                                        context: context,
                                                        builder: (ctx) {
                                                          return Dialog(
                                                            insetPadding:
                                                                const EdgeInsets.all(
                                                                  16,
                                                                ), // space from screen edges
                                                            backgroundColor: Colors
                                                                .transparent, // optional
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          12,
                                                                        ),
                                                                  ),
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                    12,
                                                                  ),
                                                              child: SingleChildScrollView(
                                                                // prevents overflow on small screens
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                child: Column(
                                                                  children: [
                                                                    BillBox(
                                                                      h1p: h1p,
                                                                      w1p: w1p,
                                                                      bill:
                                                                          getIt<
                                                                                BookingManager
                                                                              >()
                                                                              .packageBillModel,
                                                                      isLoading:
                                                                          null,
                                                                    ),
                                                                    verticalSpace(
                                                                      15,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        // PayButton(
                                                                        //   amount:
                                                                        //       "${double.parse(getIt<BookingManager>().selectedPkg!.amount!) + getIt<BookingManager>().selectedPkg!.tax!}",
                                                                        //   btnText: AppLocalizations.of(
                                                                        //     context,
                                                                        //   )!.addPackage,
                                                                        //   ontap: () async {
                                                                        //     // if(mgr.patientsUnderPackage.isEmpty){
                                                                        //     Navigator.pop(
                                                                        //       context,
                                                                        //     );
                                                                        //     // var res =
                                                                        //     await getIt<
                                                                        //           HomeManager
                                                                        //         >()
                                                                        //         .purchasePkgApi(
                                                                        //           result,
                                                                        //         );
                                                                        //     // await getIt<BookingManager>().setSelectedPackage(null);
                                                                        //   },
                                                                        // ),
                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                            Navigator.pop(
                                                                              context,
                                                                            );
                                                                            await getIt<
                                                                                  HomeManager
                                                                                >()
                                                                                .purchasePkgApi(
                                                                                  result,
                                                                                );
                                                                            getIt<
                                                                                  HomeManager
                                                                                >()
                                                                                .getPackages();
                                                                          },
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(
                                                                                16,
                                                                              ),
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
                                                                                child: Text(
                                                                                  AppLocalizations.of(
                                                                                    context,
                                                                                  )!.addPackage,
                                                                                  style: t400_16,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );

                                                      // if (res.status == true) {
                                                      //   showTopSnackBar(
                                                      //       Overlay.of(context),
                                                      //       SuccessToast(
                                                      //           message:
                                                      //               res.message ??
                                                      //                   ""));
                                                      // } else {
                                                      //   showTopSnackBar(
                                                      //       Overlay.of(context),
                                                      //       SuccessToast(
                                                      //           message:
                                                      //               res.message ??
                                                      //                   ""));
                                                      // }
                                                    }
                                                  },
                                                  child: Card(
                                                    margin:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 6,
                                                        ),
                                                    elevation: 3,
                                                    child: PackagesContainer(
                                                      h1p: h1p,
                                                      w1p: w1p,
                                                      title: e.title ?? "",
                                                      subtitle:
                                                          e.subtitle ?? "",
                                                      salePrice:
                                                          e.cuttingAmount !=
                                                              null
                                                          ? "₹${e.cuttingAmount!}"
                                                          : "",
                                                      offerPrice:
                                                          "₹${e.amount ?? ""}",
                                                      savedAmount:
                                                          " Save ₹${e.amount ?? ""}",
                                                      btnTxt: "Choose Package",
                                                      image: e.image ?? "",
                                                    ),
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
                                          AppLocalizations.of(
                                            context,
                                          )!.noPackages,
                                          style:
                                              TextStyles.notAvailableTxtStyle,
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
          ),
        );
      },
    );
  }
}
