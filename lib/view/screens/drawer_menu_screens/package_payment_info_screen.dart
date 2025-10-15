import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/model/helper/service_locator.dart';
import 'package:dqapp/view/screens/home_screen.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PackagePaymentInfoScreen extends StatelessWidget {
  final dynamic result;
  const PackagePaymentInfoScreen({super.key, this.result});

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

        return Consumer<HomeManager>(
          builder: (context, mgr, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (!mgr.isPaymentOnProcess && mgr.paymentMessage == "charged") {
                showTopSnackBar(
                  Overlay.of(context),
                  const SuccessToast(
                    message: "You have succesfully purchased the package",
                  ),
                );
                await getIt<BookingManager>().setSelectedPackage(null);
                getIt<HomeManager>().setPaymentStatus(false, "");
              } else if (!mgr.isPaymentOnProcess && mgr.paymentMessage != "") {
                showTopSnackBar(
                  Overlay.of(context),
                  ErrorToast(
                    message: mgr.paymentMessage != ""
                        ? mgr.paymentMessage
                        : "Something went wrong",
                  ),
                );

                getIt<HomeManager>().paymentMessage = "";
              }
            });
            return Consumer<BookingManager>(
              builder: (context, bookingManager, _) {
                return mgr.isPaymentOnProcess
                    ? const Scaffold(body: LogoLoader())
                    : Scaffold(
                        // extendBody: true,
                        backgroundColor: Colors.white,
                        appBar: getIt<SmallWidgets>().appBarWidget(
                          title: AppLocalizations.of(context)!.paymentInfo,
                          height: h10p,
                          width: w10p,
                          fn: () {
                            Navigator.pop(context);
                          },
                        ),
                        body: SafeArea(
                          child: CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.all(10),
                                sliver: SliverList(
                                  delegate: SliverChildListDelegate([
                                    Column(
                                      spacing: 20,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Selected Package : ",
                                              style: t400_14.copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              bookingManager
                                                  .selectedPkg!
                                                  .packagename!,
                                              style: t400_14.copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Amount : ",
                                              style: t400_14.copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "${bookingManager.selectedPkg!.amount!} /-",
                                              style: t400_14.copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Tax : ",
                                              style: t400_14.copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "${bookingManager.selectedPkg!.tax}",
                                              style: t400_14.copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        verticalSpace(15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Final Amount : ",
                                              style: t400_18.copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "${double.parse(bookingManager.selectedPkg!.amount!) + bookingManager.selectedPkg!.tax!} /-",
                                              style: t400_18.copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.centerDocked,
                        // floatingActionButton: Container(
                        //   padding: const EdgeInsets.all(8),
                        //   decoration: BoxDecoration(
                        //     color: Colors.blue,
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   margin: EdgeInsets.only(bottom: h1p * 5),
                        //   child: GestureDetector(
                        //     child: Text(
                        //       "Purchase the Package",
                        //       style: t400_18.copyWith(color: Colors.black),
                        //     ),
                        //   ),
                        // ),
                        floatingActionButton: PayButton(
                          amount:
                              "${double.parse(bookingManager.selectedPkg!.amount!) + bookingManager.selectedPkg!.tax!}",
                          btnText: AppLocalizations.of(context)!.addPackage,
                          ontap: () async {
                            // if(mgr.patientsUnderPackage.isEmpty){

                            // var res =
                            await getIt<HomeManager>().purchasePkgApi(result);
                            // await getIt<BookingManager>().setSelectedPackage(null);
                          },
                        ),
                      );
              },
            );
          },
        );
      },
    );
  }
}
