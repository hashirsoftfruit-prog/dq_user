// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/model/core/bill_model.dart';
import 'package:dqapp/model/core/package_list_response_model.dart';
import 'package:dqapp/view/screens/booking_screens/patient_details_form_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../model/core/other_patients_response_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/common_widgets.dart';
import '../home_screen_widgets.dart';

class PackageDetailsScreen extends StatefulWidget {
  final double maxHeight;
  final double maxWidth;
  final Packages pkg;
  final int? alreadySelectedUser;
  // double ma
  const PackageDetailsScreen({
    super.key,
    required this.maxHeight,
    required this.pkg,
    required this.alreadySelectedUser,
    required this.maxWidth,
  });

  @override
  State<PackageDetailsScreen> createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen> {
  @override
  void dispose() {
    getIt<BookingManager>().disposePatientsUnderPackage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Selected user ${widget.alreadySelectedUser}");
    // String files =  Provider.of<BookingManager>(context).selectedGnder;

    double maxHeight = widget.maxHeight;
    double maxWidth = widget.maxWidth;
    double h1p = maxHeight * 0.01;
    double h10p = maxHeight * 0.1;
    double w10p = maxWidth * 0.1;
    double w1p = maxWidth * 0.01;

    // List<String> langs = ["English","Malayalam"];

    benefit(benefit, icon) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SizedBox(width: 20, height: 20, child: Image.asset(image)),
            Icon(icon, size: 20, color: Colors.green),
            horizontalSpace(4),
            Text(benefit, style: t400_14.copyWith(color: clr2D2D2D)),
          ],
        ),
      );
    }

    getPersonRow({required UserDetails user, required bool selected}) {
      String name = user.firstName ?? "";
      String img = user.firstName ?? "";
      String relation = user.relation ?? "You";
      String gender = user.gender ?? "";

      String placeholderImg = gender.toUpperCase() == "MALE"
          ? "assets/images/patient-vector-male.png"
          : "assets/images/patient-vector-female.png";

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.alreadySelectedUser == user.id &&
            !getIt<BookingManager>().patientsUnderPackage
                .map((users) => users.id)
                .contains(widget.alreadySelectedUser)) {
          getIt<BookingManager>().setPatientsUnderPackage(
            user: user,
            isAdd: true,
          );
          selected = true;
          if (mounted) setState(() {});
        }
      });

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                      height: h1p * 6,
                      width: h1p * 6,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        // fit: widget.fit,
                        imageUrl: StringConstants.baseUrl + img,
                        placeholder: (context, url) =>
                            Image.asset(placeholderImg),
                        errorWidget: (context, url, error) =>
                            Image.asset(placeholderImg),
                      ),
                    ),
                  ),
                  horizontalSpace(w1p * 2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: t500_14.copyWith(color: clr2D2D2D)),
                      Text(
                        relation,
                        style: t400_14.copyWith(color: const Color(0xff858585)),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: widget.alreadySelectedUser == user.id || selected,
                    onChanged: (val) {
                      if (widget.alreadySelectedUser != null &&
                          user.id == widget.alreadySelectedUser) {
                        showTopSnackBar(
                          snackBarPosition: SnackBarPosition.bottom,
                          padding: const EdgeInsets.all(30),
                          Overlay.of(context),
                          const ErrorToast(
                            maxLines: 4,
                            message:
                                "Please purchase this package with the selected member, or choose a different patient",
                          ),
                        );
                      } else {
                        getIt<BookingManager>().setPatientsUnderPackage(
                          isAdd: val!,
                          user: user,
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: h1p * 5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: h1p),
                      child: SvgPicture.asset(
                        "assets/images/forward-arrow.svg",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 1.5, color: Colours.boxblue),
        ],
      );
    }

    return SafeArea(
      child: Consumer<BookingManager>(
        builder: (context, mgr, child) {
          UserDetails appUser =
              mgr.otherPatientsDetails.userDetails ?? UserDetails();
          return Scaffold(
            appBar: getIt<SmallWidgets>().appBarWidget(
              title: AppLocalizations.of(context)!.packageDetails,
              height: h10p,
              width: w10p,
              fn: () {
                Navigator.pop(context);
              },
            ),
            body: Container(
              // height: h10p*7,
              color: Colors.white,
              child: Stack(
                children: [
                  pad(
                    horizontal: w1p * 4,
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colours.grad1, Colours.primaryblue],
                              ),
                              borderRadius: BorderRadius.circular(
                                containerRadius / 2,
                              ),
                            ),
                            child: AspectRatio(
                              aspectRatio: 2 / 1,
                              child: HomeWidgets().cachedImg(
                                widget.pkg.image ?? "",
                                noPlaceHolder: true,
                              ),
                            ),
                          ),
                        ),
                        verticalSpace(h1p * 2),
                        pad(
                          horizontal: w1p * 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.pkg.subtitle ?? "",
                                style: t700_18.copyWith(color: clr2D2D2D),
                              ),
                              verticalSpace(8),
                              Wrap(
                                children: [
                                  // benefit('${widget.pkg.noOfConsultation ?? ''} Consultations', "assets/images/video-call-icon.png"),
                                  benefit(
                                    '${widget.pkg.noOfConsultation ?? ''} Consultations',
                                    Icons.videocam_rounded,
                                  ),
                                  horizontalSpace(12),
                                  benefit(
                                    '${widget.pkg.noOfDays ?? ''} Days Validity',
                                    Icons.calendar_month_rounded,
                                  ),
                                ],
                              ),
                              verticalSpace(8),
                              Text(
                                widget.pkg.description ?? "",
                                style: t400_14.copyWith(color: clr2D2D2D),
                              ),
                              verticalSpace(24),
                            ],
                          ),
                        ),
                        verticalSpace(h1p),
                        Container(
                          decoration: BoxDecoration(
                            // boxShadow:[ boxShadow7],
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.addYourFamilyMembers,
                                  style: t400_18.copyWith(color: clr444444),
                                ),
                                mgr.otherPatientsDetails.userRelations !=
                                            null &&
                                        mgr
                                                .otherPatientsDetails
                                                .userRelations!
                                                .length >
                                            2
                                    ? const SizedBox()
                                    : InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            backgroundColor: Colors.blueGrey,
                                            isScrollControlled: true,
                                            useSafeArea: true,
                                            context: context,
                                            builder: (context) => PatientForm(
                                              maxWidth: maxWidth,
                                              maxHeight: maxHeight,
                                              relation: null,
                                              appBarTitle: AppLocalizations.of(
                                                context,
                                              )!.addMember,
                                              user: UserDetails(),
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          height: 25,
                                          child: Image.asset(
                                            "assets/images/add-button-circle.png",
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(color: Colours.lightBlu),
                        Column(
                          children: [
                            if (mgr
                                    .otherPatientsDetails
                                    .userDetails
                                    ?.isPackageOptedUser !=
                                true)
                              getPersonRow(
                                selected: mgr.patientsUnderPackage.contains(
                                  appUser,
                                ),
                                user: appUser,
                              ),
                            ...mgr.otherPatientsDetails.userRelations!
                                .where(
                                  (user) => user.isPackageOptedUser != true,
                                )
                                .map(
                                  (e) => getPersonRow(
                                    selected: mgr.patientsUnderPackage.contains(
                                      e,
                                    ),
                                    user: e,
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                        verticalSpace(h10p * 1.5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: pad(
              vertical: h1p * 2,
              horizontal: 18,
              child: PayButton(
                amount: widget.pkg.amount!,
                btnText: AppLocalizations.of(context)!.proceed,
                ontap: () async {
                  // if(mgr.patientsUnderPackage.isEmpty){

                  bool? result = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PackageWarningPop(w1p: w1p, h1p: h1p);
                    },
                  );
                  // }

                  if (result != null) {
                    List<int> lst = mgr.patientsUnderPackage.isNotEmpty
                        ? mgr.patientsUnderPackage
                              .map((e) => e.appUserId!)
                              .toList()
                        : [];
                    // lst.add(mgr.otherPatientsDetails.userDetails!.appUserId!);
                    await getIt<BookingManager>().setSelectedPackage(
                      SelectedPackageModel(
                        packageDetails: SelectedPackageDetails(
                          packageId: widget.pkg.id,
                          packageMembers: lst,
                        ),
                        packagename: widget.pkg.title,
                        amount: widget.pkg.amount,
                        tax: widget.pkg.tax ?? 0,
                      ),
                    );
                    await getIt<BookingManager>().setPackageBillModel(
                      BillResponseModel(
                        amountAfterDiscount:
                            "${(widget.pkg.tax ?? 0) + double.parse(widget.pkg.amount!)}",
                        pkgAmount: widget.pkg.amount,
                        packageAmt: widget.pkg.amount,
                        status: true,
                        // platformFee: mgr.billModel?.platformFee,
                        tax: (widget.pkg.tax ?? 0).toString(),
                        // fee: mgr.billModel?.fee,
                        // discount: mgr.billModel?.discount,
                      ),
                    );
                    Navigator.pop(context, {
                      "package_id": widget.pkg.id,
                      "package_members": lst,
                      "amount": double.parse(widget.pkg.amount!),
                      "tax": widget.pkg.tax,
                    });
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class PackageWarningPop extends StatelessWidget {
  final double w1p;
  final double h1p;

  const PackageWarningPop({super.key, required this.w1p, required this.h1p});

  @override
  Widget build(BuildContext context) {
    String msg = AppLocalizations.of(
      context,
    )!.theDetailsOFTHePersonWillNotBeEditable;
    String msg2 = AppLocalizations.of(
      context,
    )!.onlyTheMembersAddedUnderThisPackageWillRecieve;

    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Center(
        child: Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
      ),
      // title: Text(
      //   'Message',
      //   style: t400_16.copyWith(color: clr2D2D2D),
      // ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SizedBox(
          width: w1p * 90,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                msg2,
                style: t400_14.copyWith(color: clr2D2D2D),
                textAlign: TextAlign.center,
              ),
              verticalSpace(h1p),
              Text(
                msg,
                style: t400_14.copyWith(color: clr2D2D2D),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          // height: h1p*80,
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colours.toastBlue),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 5,
              ),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: t500_16.copyWith(color: clr2D2D2D),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: linearGrad,
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 5,
              ),
              child: Text(
                AppLocalizations.of(context)!.proceed,
                style: t500_16,
              ),
            ),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 18.0),
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
