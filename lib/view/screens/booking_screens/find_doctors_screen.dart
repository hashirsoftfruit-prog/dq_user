// ignore_for_file: use_build_context_synchronously

import 'package:dqapp/controller/managers/state_manager.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/model/core/doctor_list_response_model.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/managers/location_manager.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../home_screen_widgets.dart';
import '../location_drawer_screen.dart';
import 'booking_screen_widgets.dart';
import 'doctor_slot_pick_screen.dart';
import 'redacted_loaders.dart';

class FindDoctorsListScreen extends StatefulWidget {
  final int specialityId;
  final int? symptomId;
  final int? subSpecialityIdForPsychology;
  final int? petId;
  final bool? isPetDoctors;
  const FindDoctorsListScreen({
    super.key,
    required this.specialityId,
    required this.subSpecialityIdForPsychology,
    this.isPetDoctors,
    this.petId,
    this.symptomId,
  });

  @override
  State<FindDoctorsListScreen> createState() => _FindDoctorsListScreenState();
}

class _FindDoctorsListScreenState extends State<FindDoctorsListScreen> {
  late ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _key =
      GlobalKey<ScaffoldState>(); // Create a key

  // double _scrollControllerOffset = 0.0;

  // _scrollListener() {
  //   setState(() {
  //     _scrollControllerOffset = _scrollController.offset;
  //   });
  // }

  @override
  void initState() {
    _scrollController = ScrollController();
    // _scrollController.addListener(_scrollListener);
    List<String>? latAndLong = getIt<SharedPreferences>().getStringList(
      StringConstants.currentLatAndLong,
    );
    getIt<BookingManager>().getDoctorList(
      specialityId: widget.specialityId,
      symptomId: widget.symptomId,
      subSpecialityId: widget.subSpecialityIdForPsychology,
      latitude: latAndLong?[0],
      longitude: latAndLong?[1],
    );
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return Consumer<BookingManager>(
          builder: (context, mgr, child) {
            // var dd = DoctorListModel.fromJson(tempMap);
            List<DocDetailsModel> docs = mgr.doctorsList?.doctors ?? [];
            return Scaffold(
              key: _key,
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              drawer: LocationDrawerScreen(
                w1p: w1p,
                h1p: h1p,
                specialityId: widget.specialityId,
                symptomId: widget.symptomId,
              ),

              // appBar: SmallWidgets().appBarWidget(title: AppLocalizations.of(context)!.findDoctorsClinic, height: h10p, width: w10p,fn: (){
              //   Navigator.pop(context);
              // }),
              body: NestedScrollView(
                // floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxisScrolled) => [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: clrFFEDEE,
                    floating: true,
                    snap: true,
                    toolbarHeight: 180,
                    flexibleSpace: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xffF98E95), Color(0xffBD6273)],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: w1p * 4,
                              vertical: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: SvgPicture.asset(
                                  "assets/images/back-arrow-cupertino.svg",
                                  colorFilter: ColorFilter.mode(
                                    clrFFFFFF,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Book Your", style: t400_18),
                                    Text("Appointment", style: t500_20),
                                    verticalSpace(8),
                                  ],
                                ),

                                // Text("500+ Doctors",style: t400_14.copyWith(color: clr2D2D2D),)
                              ],
                            ),
                          ),
                          Container(
                            color: clrFFFFFF,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                w1p * 4,
                                h1p,
                                w1p * 4,
                                0,
                              ),
                              padding: EdgeInsets.all(w1p * 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xffF98E95).withAlpha(80),
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 100),
                                child: InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    _key.currentState!.openDrawer();
                                  },
                                  child: Consumer<LocationManager>(
                                    builder: (context, lMgr, child) {
                                      return Row(
                                        children: [
                                          AnimatedRotation(
                                            duration: const Duration(
                                              milliseconds: 400,
                                            ),
                                            turns: -1 / 4,
                                            // turns: hMgr.heightF == 4 ? 0 : -1 / 4,
                                            child: SmallWidgets().locationIcon(
                                              size: 24,
                                              iconClr: Colors.black,
                                            ),
                                          ),
                                          horizontalSpace(8),
                                          SizedBox(
                                            width: w10p * 6,
                                            child: lMgr.locLoader == true
                                                ? LoadingAnimationWidget.twoRotatingArc(
                                                    color: Colors.white,
                                                    size: 20,
                                                  )
                                                : lMgr.selectedLocation != null
                                                ? Row(
                                                    children: [
                                                      Text(
                                                        'Doctors in ',
                                                        style: t400_14.copyWith(
                                                          color: clr202020,
                                                        ),
                                                        // overflow: TextOverflow.ellipsis,
                                                      ),
                                                      SizedBox(
                                                        width: w10p * 4,
                                                        child: Text(
                                                          lMgr.selectedLocation!,
                                                          style: t700_14
                                                              .copyWith(
                                                                color:
                                                                    clr202020,
                                                              ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : getIt<SharedPreferences>()
                                                              .getString(
                                                                StringConstants
                                                                    .selectedLocation,
                                                              ) !=
                                                          null &&
                                                      getIt<SharedPreferences>()
                                                              .getStringList(
                                                                StringConstants
                                                                    .currentLatAndLong,
                                                              ) !=
                                                          null
                                                ? Row(
                                                    children: [
                                                      Text(
                                                        'Doctors in ',
                                                        style: t400_14.copyWith(
                                                          color: clr202020,
                                                        ),
                                                        // overflow: TextOverflow.ellipsis,
                                                      ),
                                                      SizedBox(
                                                        width: w10p * 4,
                                                        child: Text(
                                                          '${getIt<SharedPreferences>().getString(StringConstants.selectedLocation)}',
                                                          style: t700_14
                                                              .copyWith(
                                                                color:
                                                                    clr202020,
                                                              ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.chooseLocation,
                                                    style: t400_14.copyWith(
                                                      color: Colors.grey,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                          ),
                                          const Expanded(child: SizedBox()),
                                          if (lMgr.selectedLocation != null ||
                                              getIt<SharedPreferences>()
                                                          .getString(
                                                            StringConstants
                                                                .selectedLocation,
                                                          ) !=
                                                      null &&
                                                  getIt<SharedPreferences>()
                                                          .getStringList(
                                                            StringConstants
                                                                .currentLatAndLong,
                                                          ) !=
                                                      null)
                                            GestureDetector(
                                              onTap: () async {
                                                lMgr.changeLoc(null);
                                                getIt<SharedPreferences>()
                                                    .remove(
                                                      StringConstants
                                                          .selectedLocation,
                                                    );
                                                getIt<SharedPreferences>()
                                                    .remove(
                                                      StringConstants
                                                          .currentLatAndLong,
                                                    );
                                                if (mounted) setState(() {});

                                                mgr.getDoctorList(
                                                  specialityId:
                                                      widget.specialityId,
                                                  symptomId: widget.symptomId,
                                                  subSpecialityId: widget
                                                      .subSpecialityIdForPsychology,
                                                );

                                                // await Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                                                // getIt<HomeManager>().getSpecialities();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 4.0,
                                                      horizontal: 4,
                                                    ),
                                                child: Text(
                                                  'Clear',
                                                  style: t400_14.copyWith(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          // GestureDetector(
                                          //     onTap: (){
                                          //       _key.currentState!.openEndDrawer();
                                          //
                                          //     },
                                          //     child: Padding(
                                          //       padding: const EdgeInsets.only(top:0.0 ,bottom:0.0 ,left:8.0 ),
                                          //       child: SvgPicture.asset("assets/images/home_icons/menu.svg",height: 28,),
                                          //     )),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                body: mgr.listLoader == true
                    ? const FindDoctorRedactedLoader()
                    // ? const Center(child: LogoLoader())
                    : Column(
                        children: [
                          docs.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(28.0),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.noSpecialityDoctors,
                                      style: TextStyles.notAvailableTxtStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : Expanded(
                                  // xOffset: 1000,
                                  // // scale: 20,
                                  // delay: const Duration(milliseconds: 0),
                                  // duration: const Duration(milliseconds: 1000),
                                  // curve: Curves.ease,
                                  child: CustomScrollView(
                                    slivers: [
                                      // SliverToBoxAdapter(child:
                                      //   Container(height: 70,child: Center(child: Text("sds"),),)
                                      //   ,),
                                      // SliverPadding(
                                      //   padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                                      //   sliver: SliverList(
                                      //       delegate: SliverChildListDelegate([
                                      //     SmallWidgets().searchBarBox(title: AppLocalizations.of(context)!.search, height: h10p, width: w10p),
                                      //     verticalSpace(h1p),

                                      //     // Column(
                                      //     //     children: docs.map((e) {
                                      //     //   String? clinicName = e.clinicName;
                                      //     //   String? clinicalAddress1 = e.address1;
                                      //     //   String? clinicalAddress2 = e.address2;
                                      //     //   String fullClinicAddress = [clinicName, clinicalAddress1, clinicalAddress2].where((element) => element != null && element.isNotEmpty).join(", ");
                                      //     //   print("fullClinicAddress findDrPage");
                                      //     //   print('$fullClinicAddress, $clinicName');
                                      //     //   return Padding(
                                      //     //     padding: const EdgeInsets.only(bottom: 8.0),
                                      //     //     child: GestureDetector(
                                      //     //       onTap: () {
                                      //     //         Navigator.push(
                                      //     //             context,
                                      //     //             MaterialPageRoute(
                                      //     //                 builder: (_) => DoctorProfileScreen(
                                      //     //                       // specialityId: widget.specialityId,
                                      //     //                       onlineFee: e.doctorOnlineFee,
                                      //     //                       offlineFee: e.doctorOfflineFee,
                                      //     //                       specialityId: widget.specialityId,
                                      //     //                       docId: e.id!,
                                      //     //                     )));
                                      //     //       },
                                      //     //       child: DocItem(
                                      //     //         h1p: h1p,
                                      //     //         w1p: w1p,
                                      //     //         name: '${e.firstName ?? ""} ${e.lastName ?? ""}',
                                      //     //         type: e.qualification ?? "",
                                      //     //         currentClinicAddress: fullClinicAddress.isNotEmpty ? fullClinicAddress : null,
                                      //     //         offlineTimeSlot: e.offlineStartTime != null && e.offlineEndTime != null ? '${e.offlineStartTime} - ${e.offlineEndTime}' : null,
                                      //     //         onlineTimeSlot: e.onlineStartTime != null && e.onlineEndTime != null ? '${e.onlineStartTime} - ${e.onlineEndTime}' : null,
                                      //     //         experience: e.experience != null ? '${e.experience}' : '',
                                      //     //         img: e.image ?? "",
                                      //     //         latitudeOfPrimaryClinic: e.clinicLatitude,
                                      //     //         longitudeOfPrimaryClinic: e.clinicLongitude,
                                      //     //         bookOnlineOnClick: () {
                                      //     //           Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorSlotPickScreen(subSpecialityIdForPsychology: widget.subSpecialityIdForPsychology, isPetBooking: widget.isPetDoctors, petId: widget.petId, date: null, followUpBookId: null, isScheduledOnline: true, isFreeFollowUp: false, docId: e.id, freeFollowUpId: null, specialityId: widget.specialityId)));
                                      //     //         },
                                      //     //         bookClinicOnClick: () async {
                                      //     //           if (e.clinics != null && e.clinics!.isNotEmpty) {
                                      //     //             int? result = await showModalBottomSheet(
                                      //     //               context: context,
                                      //     //               builder: (BuildContext context) {
                                      //     //                 return ChooseClinic(
                                      //     //                   w1p: w1p,
                                      //     //                   h1p: h1p,
                                      //     //                   clinics: e.clinics ?? [],
                                      //     //                 );
                                      //     //               },
                                      //     //             );
                                      //     //             if (result != null) {
                                      //     //               Navigator.push(
                                      //     //                   context,
                                      //     //                   MaterialPageRoute(
                                      //     //                       builder: (_) => DoctorSlotPickScreen(
                                      //     //                             date: null,
                                      //     //                             followUpBookId: null,
                                      //     //                             isScheduledOnline: false,
                                      //     //                             isFreeFollowUp: false,
                                      //     //                             clinicDetails: e.clinics![result],
                                      //     //                             docId: e.id,
                                      //     //                             freeFollowUpId: null,
                                      //     //                             specialityId: widget.specialityId,
                                      //     //                             subSpecialityIdForPsychology: widget.subSpecialityIdForPsychology,
                                      //     //                           )));
                                      //     //             }
                                      //     //           } else {
                                      //     //             Fluttertoast.showToast(msg: AppLocalizations.of(context)!.clinicsNotAvailable);
                                      //     //           }
                                      //     //         },
                                      //     //       ),
                                      //     //     ),
                                      //     //   );
                                      //     // }).toList())
                                      //   ])),
                                      // ),
                                      SliverPadding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: w1p * 4,
                                          vertical: h1p * 2,
                                        ),
                                        sliver: SliverList.builder(
                                          itemCount: docs.length,
                                          itemBuilder: (context, index) {
                                            var e = docs[index];
                                            String? clinicName = e.clinicName;
                                            String? clinicalAddress1 =
                                                e.address1;
                                            String? clinicalAddress2 =
                                                e.address2;

                                            String fullClinicAddress =
                                                [
                                                      clinicName,
                                                      clinicalAddress1,
                                                      clinicalAddress2,
                                                    ]
                                                    .where(
                                                      (element) =>
                                                          element != null &&
                                                          element.isNotEmpty,
                                                    )
                                                    .join(", ");
                                            // print("fullClinicAddress findDrPage");
                                            // print('$fullClinicAddress, $clinicName');

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 8.0,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (BuildContext context) {
                                                      return AnimatedPopup(
                                                        child:
                                                            DoctorDetailsCard(
                                                              scheduledDocData:
                                                                  e,
                                                              h1p: h1p,
                                                              w1p: w1p,
                                                            ),
                                                      ); // Animated dialog
                                                    },
                                                  );
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (_) => DoctorProfileScreen(
                                                  //               // specialityId: widget.specialityId,
                                                  //               onlineFee: e.doctorOnlineFee,
                                                  //               offlineFee: e.doctorOfflineFee,
                                                  //               specialityId: widget.specialityId,
                                                  //               docId: e.id!,
                                                  //             )));
                                                },
                                                child: DocItem(
                                                  h1p: h1p,
                                                  w1p: w1p,
                                                  name:
                                                      '${e.firstName ?? ""} ${e.lastName ?? ""}',
                                                  type: e.qualification ?? "",
                                                  currentClinicAddress:
                                                      fullClinicAddress
                                                          .isNotEmpty
                                                      ? fullClinicAddress
                                                      : null,
                                                  offlineTimeSlot:
                                                      e.offlineStartTime !=
                                                              null &&
                                                          e.offlineEndTime !=
                                                              null
                                                      ? '${e.offlineStartTime} - ${e.offlineEndTime}'
                                                      : null,
                                                  onlineTimeSlot:
                                                      e.onlineStartTime !=
                                                              null &&
                                                          e.onlineEndTime !=
                                                              null
                                                      ? '${e.onlineStartTime} - ${e.onlineEndTime}'
                                                      : null,
                                                  experience:
                                                      e.experience != null
                                                      ? '${e.experience}'
                                                      : '',
                                                  img: e.image ?? "",
                                                  latitudeOfPrimaryClinic:
                                                      e.clinicLatitude,
                                                  longitudeOfPrimaryClinic:
                                                      e.clinicLongitude,
                                                  bookOnlineOnClick: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) => DoctorSlotPickScreen(
                                                          subSpecialityIdForPsychology:
                                                              widget
                                                                  .subSpecialityIdForPsychology,
                                                          isPetBooking: widget
                                                              .isPetDoctors,
                                                          petId: widget.petId,
                                                          date: null,
                                                          followUpBookId: null,
                                                          isScheduledOnline:
                                                              true,
                                                          isFreeFollowUp: false,
                                                          docId: e.id,
                                                          freeFollowUpId: null,
                                                          specialityId: widget
                                                              .specialityId,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  bookClinicOnClick: () async {
                                                    if (e.clinics != null &&
                                                        e.clinics!.isNotEmpty) {
                                                      int?
                                                      result = await showModalBottomSheet(
                                                        context: context,
                                                        builder:
                                                            (
                                                              BuildContext
                                                              context,
                                                            ) {
                                                              return ChooseClinic(
                                                                w1p: w1p,
                                                                h1p: h1p,
                                                                clinics:
                                                                    e.clinics ??
                                                                    [],
                                                              );
                                                            },
                                                      );
                                                      if (result != null) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) => DoctorSlotPickScreen(
                                                              date: null,
                                                              followUpBookId:
                                                                  null,
                                                              isScheduledOnline:
                                                                  false,
                                                              isFreeFollowUp:
                                                                  false,
                                                              clinicDetails: e
                                                                  .clinics![result],
                                                              docId: e.id,
                                                              freeFollowUpId:
                                                                  null,
                                                              specialityId: widget
                                                                  .specialityId,
                                                              subSpecialityIdForPsychology:
                                                                  widget
                                                                      .subSpecialityIdForPsychology,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                        msg: AppLocalizations.of(
                                                          context,
                                                        )!.clinicsNotAvailable,
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
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

class DocItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String name;
  final String img;
  final String experience;
  final String? onlineTimeSlot;
  final String type;
  final String? offlineTimeSlot;
  final String? currentClinicAddress;
  final Function bookOnlineOnClick;
  final Function bookClinicOnClick;
  final String? latitudeOfPrimaryClinic;
  final String? longitudeOfPrimaryClinic;
  const DocItem({
    super.key,
    required this.w1p,
    required this.h1p,
    required this.img,
    required this.name,
    required this.experience,
    required this.onlineTimeSlot,
    required this.type,
    required this.offlineTimeSlot,
    required this.currentClinicAddress,
    required this.bookOnlineOnClick,
    required this.bookClinicOnClick,
    required this.latitudeOfPrimaryClinic,
    required this.longitudeOfPrimaryClinic,
  });

  @override
  Widget build(BuildContext context) {
    String docName = getIt<StateManager>().capitalizeFirstLetter(name);

    var bxdec = BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          spreadRadius: 0,
          blurRadius: 7.3,
          offset: const Offset(0, 0),
          color: const Color(0xffC3C3C3).withOpacity(0.3),
        ),
      ],
      border: Border.all(color: clr2D2D2D, width: 0.6),
      borderRadius: BorderRadius.circular(12),
    );
    // var grad2 = const LinearGradient(colors: [Color(0xff4D51C7), Color(0xff2E3192)]);
    // var grad3 = const RadialGradient(colors: [
    //   Color(0xffFFFFFF),
    //   Color(0xffCBCBCB),
    // ]);

    Widget timeWidget(String time, String icon) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15, child: Image.asset(icon)),
          horizontalSpace(w1p),
          Text(time, style: t500_12.copyWith(color: const Color(0xff000000))),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withOpacity(0.16),
            blurRadius: 4.7,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: pad(
        horizontal: w1p * 3,
        vertical: h1p,
        child: Column(
          children: [
            verticalSpace(8),
            Row(
              children: [
                // horizontal: w1p*2.5,
                SizedBox(
                  height: 80,
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: HomeWidgets().cachedImg(
                      img,
                      placeholderImage: 'assets/images/doctor-placeholder.png',
                    ),
                  ),
                ),
                horizontalSpace(w1p * 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Dr.$docName',
                        style: t700_16.copyWith(color: clr2D2D2D),
                      ),
                      Text(type, style: t400_14.copyWith(color: clr2D2D2D)),
                      Text(
                        experience,
                        style: t400_14.copyWith(color: clr2D2D2D),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 0.5,
                width: w1p * 60,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffE3E3E3), Color(0xff959595)],
                  ),
                ),
              ),
            ),
            // Row(children: [
            //   SizedBox(height: 15,width: 15, child: Image.asset("assets/images/doc-list-icon1.png")),
            //   Text("time",style: TextStyles.textStyle65,),
            // ],),
            verticalSpace(4),

            currentClinicAddress != null
                ? Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: clrF8F8F8,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 16.7,
                            height: 16.7,
                            child: Image.asset(
                              "assets/images/location-icon-doctor-list.png",
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            child: Text(
                              "$currentClinicAddress",
                              style: t400_14.copyWith(
                                color: clr2D2D2D,
                                height: 1.1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            verticalSpace(4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.consultationTime,
                style: TextStyles.textStyle66,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                children: [
                  onlineTimeSlot != null
                      ? timeWidget(
                          onlineTimeSlot!,
                          "assets/images/doc-list-icon2.png",
                        )
                      : const SizedBox(),
                  offlineTimeSlot != null
                      ? horizontalSpace(w1p * 5)
                      : const SizedBox(),
                  offlineTimeSlot != null
                      ? timeWidget(
                          offlineTimeSlot!,
                          "assets/images/doc-list-icon1.png",
                        )
                      : const SizedBox(),
                ],
              ),
            ),

            verticalSpace(4),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: onlineTimeSlot != null
                        ? InkWell(
                            onTap: () {
                              bookOnlineOnClick();
                            },
                            child: Container(
                              decoration: bxdec,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 12,
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.bookOnline,
                                    style: t400_14.copyWith(color: clr2E3192),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  horizontalSpace(w1p * 2),
                  Expanded(
                    child: offlineTimeSlot != null
                        ? InkWell(
                            onTap: () {
                              bookClinicOnClick();
                            },
                            child: Container(
                              decoration: bxdec,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 12,
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.bookClinic,
                                    style: t400_14.copyWith(color: clr2E3192),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  if (offlineTimeSlot != null &&
                      latitudeOfPrimaryClinic != null) ...[
                    horizontalSpace(w1p),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: GestureDetector(
                        onTap: () {
                          openMap(
                            double.parse(latitudeOfPrimaryClinic!),
                            double.parse(longitudeOfPrimaryClinic!),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: clrFFFFFF,
                            boxShadow: const [BoxShadow()],
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Image.asset(
                              "assets/images/home_icons/round-location.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChooseClinic extends StatefulWidget {
  final double w1p;
  final double h1p;
  final List<ClinicsDetails> clinics; // String type;

  const ChooseClinic({
    super.key,
    required this.w1p,
    required this.h1p,
    required this.clinics,
  });

  @override
  State<ChooseClinic> createState() => _ChooseClinicState();
}

class _ChooseClinicState extends State<ChooseClinic> {
  int? selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var grad3 = const RadialGradient(
      colors: [Color(0xffFFFFFF), Color(0xffCBCBCB)],
    );

    List<ClinicsDetails>? clins = widget.clinics; // String type;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: widget.w1p * 4, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.chooseClinic,
            style: t500_14.copyWith(color: clr2D2D2D),
          ),
          Expanded(
            child: Container(
              // width: widget.w1p*90,
              // height: h1p*80,
              child: pad(
                // horizontal: w1p*1,
                vertical: widget.h1p,
                child: ListView(
                  shrinkWrap: true,
                  children: clins.map((e) {
                    var ind = clins.indexOf(e);
                    bool isselected = selectedIndex == ind;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = ind;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: isselected
                              ? Border.all(
                                  color: clr5A6BE2.withOpacity(0.5),
                                  width: 2,
                                )
                              : null,
                          color: Colors.white,
                          // gradient: linearGrad3
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              // horizontal: w1p*2.5,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  color: Colors.white,
                                  height: 60,
                                  width: 60,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: "null", //"not available now",
                                    placeholder: (context, url) => Image.asset(
                                      'assets/images/placeholder-hospital.png',
                                      fit: BoxFit.fitHeight,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                          'assets/images/placeholder-hospital.png',
                                          fit: BoxFit.fitHeight,
                                        ),
                                  ),
                                ),
                              ),
                              horizontalSpace(widget.w1p * 2),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      e.name ?? "",
                                      style: t500_16.copyWith(
                                        color: clr2D2D2D,
                                        height: 1.1,
                                      ),
                                    ),
                                    Text(
                                      '${e.address1}, ${e.address2}, ${e.city}',
                                      style: t500_12.copyWith(color: clr2D2D2D),
                                    ),
                                  ],
                                ),
                              ),
                              horizontalSpace(widget.w1p * 2),
                              e.latitude != null && e.longitude != null
                                  ? GestureDetector(
                                      onTap: () {
                                        openMap(
                                          double.parse(e.latitude!),
                                          double.parse(e.longitude!),
                                        );
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          gradient: grad3,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.asset(
                                            "assets/images/home_icons/round-location.png",
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          ButtonWidget(
            isLoading: false,
            ontap: () async {
              Navigator.pop(context, selectedIndex);
            },
            btnText: "Continue",
          ),
        ],
      ),
    );
  }
}

class ChooseSpeciality extends StatefulWidget {
  final double w1p;
  final double h1p;
  final List<DoctorSpecialities> specialities; // String type;

  const ChooseSpeciality({
    super.key,
    required this.w1p,
    required this.h1p,
    required this.specialities,
  });

  @override
  State<ChooseSpeciality> createState() => _ChooseSpecialityState();
}

class _ChooseSpecialityState extends State<ChooseSpeciality> {
  int? selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<DoctorSpecialities>? specialty = widget.specialities; // String type;

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        AppLocalizations.of(context)!.chooseSpeciality,
        style: TextStyles.textStyle3c,
      ),
      content: SizedBox(
        width: widget.w1p * 90,

        // height: h1p*80,
        child: pad(
          // horizontal: w1p*1,
          vertical: widget.h1p,
          child: ListView(
            shrinkWrap: true,
            children: specialty.map((e) {
              var ind = specialty.indexOf(e);
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = ind;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: selectedIndex == ind
                        ? const Color(0xff393DA6)
                        : Colors.white,
                    // gradient: linearGrad3
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6,
                    ),
                    child: SpecialityItem(
                      selected: selectedIndex == ind,
                      w1p: widget.w1p,
                      h1p: widget.h1p,
                      title: e.title ?? "",
                      img: e.image ?? "",
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: linearGrad,
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context, selectedIndex);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 10,
              ),
              child: Text(
                AppLocalizations.of(context)!.continue1,
                style: t700_18.copyWith(color: clrFFFFFF, height: 1),
              ),
            ),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 18.0),
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

Future<void> openMap(double latitude, double longitude) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunchUrl(Uri.parse(googleUrl))) {
    await launchUrl(Uri.parse(googleUrl));
  } else {
    throw 'Could not open the map.';
  }
}
