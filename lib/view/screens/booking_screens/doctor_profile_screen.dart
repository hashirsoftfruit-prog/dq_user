// ignore_for_file: use_build_context_synchronously

import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/model/core/doctor_list_response_model.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../home_screen.dart';
import '../home_screen_widgets.dart';
import 'doctor_slot_pick_screen.dart';
import 'find_doctors_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  final int? specialityId;
  final int? subSpecialityIdForPsychology;
  final int docId;
  final String? onlineFee;
  final String? offlineFee;
  const DoctorProfileScreen({
    super.key,
    required this.specialityId,
    required this.docId,
    this.onlineFee,
    this.offlineFee,
    this.subSpecialityIdForPsychology,
  });

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  @override
  void initState() {
    getIt<BookingManager>().getDocProfile(docId: widget.docId);
    super.initState();
  }

  @override
  void dispose() {
    getIt<BookingManager>().disposeDoctorProfile();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var grad1 = const LinearGradient(colors: [Color(0xff9E74F8), Color(0xff8F5BFE)]);
    // var grad2 = const LinearGradient(colors: [Color(0xff4D51C7), Color(0xff2E3192)]);
    // var grad3 = const RadialGradient(colors: [Color(0xffFFFFFF), Color(0xffCBCBCB)]);

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        slotBox(String time) {
          return Container(
            height: 38,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: clrF3F3F3,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: clrF3F3F3),
              // boxShadow: [boxShadow5b]
            ),
            child: Center(
              child: Text(
                getIt<StateManager>().getFormattedTime(time) ?? "",
                style: t400_14.copyWith(color: clr2D2D2D),
              ),
            ),
          );
        }

        buildTimeSlots({
          required String title,
          required List<String> timeList,
        }) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 18,
                ),
                child: Row(
                  children: [
                    Text(title, style: t500_16.copyWith(color: clr2D2D2D)),
                    horizontalSpace(4),
                    Expanded(
                      child: Container(
                        height: 0.5,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              // Color(0xffE3E3E3),
                              Color(0xffE3E3E3),
                              Color(0xff959595),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  var e = timeList[index];
                  return slotBox(e);
                }, childCount: timeList.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 1,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 3,
                ),
              ),
            ),
          ];
        }

        // proileColumn({
        //   required String title,
        //   required String subtitle,
        // }) {
        //   return ClipRRect(
        //     borderRadius: BorderRadius.circular(20),
        //     // child: BackdropFilter(
        //     //   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        //     child: Container(
        //       // width: 100,
        //       height: 80,
        //       // padding: EdgeInsets.symmetric(horizontal: 0,),
        //       decoration: BoxDecoration(
        //         color: const Color(0xffF7F7F7).withOpacity(0.61),
        //         borderRadius: BorderRadius.circular(20),
        //         border: Border.all(
        //           color: Colors.white,
        //           width: 1,
        //         ),
        //       ),
        //       child: Center(
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Text(title, style: t500_16.copyWith(color: clr2D2D2D)),
        //             Text(subtitle, style: t400_16.copyWith(color: clr2D2D2D)),
        //           ],
        //         ),
        //       ),
        //     ),
        //     // ),
        //   );
        // }

        timeSlotBox({
          required String title,
          required String timeSlot,
          required String? fees,
        }) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: t500_14.copyWith(color: clr2D2D2D)),
              Row(
                children: [
                  SizedBox(
                    height: 14,
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: Image.asset(
                        "assets/images/home_icons/icon-time.png",
                        color: const Color(0xff2E3192),
                      ),
                    ),
                  ),
                  horizontalSpace(w1p),
                  Text(timeSlot, style: t400_12.copyWith(color: clr2D2D2D)),
                ],
              ),
              if (fees != null) ...[
                verticalSpace(4),
                Text('₹$fees', style: t500_16.copyWith(color: clr2D2D2D)),
              ],
              // Row(
              //   children: [
              //     Text(
              //       AppLocalizations.of(context)!.fees,
              //       style: t400_16.copyWith(color: clr858585),
              //     ),
              //     horizontalSpace(5),
              //     Text(
              //       '₹$fees',
              //       style: t500_16.copyWith(color: clr2D2D2D),
              //     ),
              //   ],
              // ),
            ],
          );
        }

        detailsRow({required String icon, required String value}) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10, child: SvgPicture.asset(icon)),
                SizedBox(width: w1p),
                SizedBox(
                  width: w10p * 5,
                  child: Text(value, style: TextStyles.textStyle72),
                ),
              ],
            ),
          );
        }

        bookOnlineOnClick(doc) async {
          int? specialityId = widget.specialityId;

          if (specialityId == null) {
            if (doc.doctorSpecialities.length > 1) {
              int? specialityIndx = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ChooseSpeciality(
                    w1p: w1p,
                    h1p: h1p,
                    specialities: doc.doctorSpecialities ?? [],
                  );
                },
              );
              specialityId = specialityIndx != null
                  ? doc.doctorSpecialities![specialityIndx].id
                  : null;
            } else {
              specialityId = doc.doctorSpecialities.first.id;
            }
          }
          if (specialityId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorSlotPickScreen(
                  date: null,
                  followUpBookId: null,
                  isScheduledOnline: true,
                  isFreeFollowUp: false,
                  docId: doc.id,
                  freeFollowUpId: null,
                  specialityId: specialityId!,
                  subSpecialityIdForPsychology:
                      widget.subSpecialityIdForPsychology,
                ),
              ),
            );
          }
        }

        bookClinicOnClick(doc) async {
          int? specId = widget.specialityId;

          int? clinicIndex = await showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ChooseClinic(
                w1p: w1p,
                h1p: h1p,
                clinics: doc.clinics ?? [],
              );
            },
          );

          if (clinicIndex != null && widget.specialityId == null) {
            if (doc.doctorSpecialities.length > 1) {
              int? specialityIndx = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ChooseSpeciality(
                    w1p: w1p,
                    h1p: h1p,
                    specialities: doc.doctorSpecialities ?? [],
                  );
                },
              );
              specId = specialityIndx != null
                  ? doc.doctorSpecialities![specialityIndx].id
                  : null;
            } else {
              specId = doc.doctorSpecialities.first.id;
            }
          }

          if (clinicIndex != null && specId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorSlotPickScreen(
                  date: null,
                  followUpBookId: null,
                  isScheduledOnline: false,
                  isFreeFollowUp: false,
                  clinicDetails: doc.clinics![clinicIndex],
                  docId: doc.id,
                  freeFollowUpId: null,
                  specialityId: specId!,
                  subSpecialityIdForPsychology:
                      widget.subSpecialityIdForPsychology,
                ),
              ),
            );
          }
        }

        return SafeArea(
          child: Consumer<BookingManager>(
            builder: (context, mgr, child) {
              DocDetailsModel? doc = mgr.docProfile;

              return Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.white,
                body: mgr.profileLoader == true || doc == null
                    ? const Entry(
                        xOffset: 500,
                        // scale: 20,
                        delay: Duration(milliseconds: 10),
                        duration: Duration(milliseconds: 100),
                        curve: Curves.ease,
                        child: Center(child: LogoLoader()),
                      )
                    : mgr.docProfile != null && mgr.docProfile?.id == null
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context)!.doctorDetailsNotAvail,
                          style: TextStyles.notAvailableTxtStyle,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Entry(
                        xOffset: 1000,
                        // scale: 20,
                        delay: const Duration(milliseconds: 0),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.ease,
                        child: CustomScrollView(
                          controller: ScrollController(),
                          slivers: [
                            SliverPersistentHeader(
                              pinned: false, // Keeps it visible at the top
                              delegate: ResizableHeader(
                                minHeight:
                                    310, // Minimum height when scrolled up
                                maxHeight: 355,
                                h1p: h1p,
                                w1p: w1p,
                                doc: doc,
                                // Maximum height before scrolling
                              ),
                            ),
                            SliverPadding(
                              padding: EdgeInsets.only(
                                right: w1p * 4,
                                left: w1p * 4,
                                top: 10,
                              ),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate([
                                  Builder(
                                    builder: (context) {
                                      String? offlineTimeSlot =
                                          doc.offlineStartTime != null &&
                                              doc.offlineEndTime != null
                                          ? '${doc.offlineStartTime} - ${doc.offlineEndTime}'
                                          : null;
                                      String? onlineTimeSlot =
                                          doc.onlineStartTime != null &&
                                              doc.onlineEndTime != null
                                          ? '${doc.onlineStartTime} - ${doc.onlineEndTime}'
                                          : null;

                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 12,
                                        ),
                                        margin: const EdgeInsets.all(1.0),
                                        decoration: BoxDecoration(
                                          color: clrFFFFFF,
                                          borderRadius: BorderRadius.circular(
                                            19,
                                          ),
                                          boxShadow: [boxShadow9],
                                          border: Border.all(
                                            color: clr2D2D2D,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              offlineTimeSlot != null
                                                  ? timeSlotBox(
                                                      title:
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.inClinic,
                                                      timeSlot: offlineTimeSlot,
                                                      fees: widget.offlineFee,
                                                    )
                                                  : const SizedBox(),
                                              offlineTimeSlot != null &&
                                                      onlineTimeSlot != null
                                                  ? const SizedBox(
                                                      height: 50,
                                                      child: VerticalDivider(),
                                                    )
                                                  : const SizedBox(),
                                              onlineTimeSlot != null
                                                  ? timeSlotBox(
                                                      title:
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.online,
                                                      timeSlot: onlineTimeSlot,
                                                      fees: widget.onlineFee,
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ]),
                              ),
                            ),
                            if (doc.timeList != null &&
                                doc.timeList!.isNotEmpty)
                              ...buildTimeSlots(
                                title: "Today’s Availability",
                                timeList: doc.timeList ?? [],
                              ),
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Builder(
                                  builder: (context) {
                                    String? offlineTimeSlot =
                                        doc.offlineStartTime != null &&
                                            doc.offlineEndTime != null
                                        ? '${doc.offlineStartTime} - ${doc.offlineEndTime}'
                                        : null;
                                    String? onlineTimeSlot =
                                        doc.onlineStartTime != null &&
                                            doc.onlineEndTime != null
                                        ? '${doc.onlineStartTime} - ${doc.onlineEndTime}'
                                        : null;

                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: w1p * 4,
                                      ),
                                      child: Column(
                                        children: [
                                          verticalSpace(h1p * 2),

                                          // doc.email!=null?detailsRow(icon: 'assets/images/icon-email.svg',value: doc.email!):SizedBox(),
                                          doc.clinicName != null
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    detailsRow(
                                                      icon:
                                                          'assets/images/icon-location.svg',
                                                      value: doc.clinicName!,
                                                    ),
                                                    offlineTimeSlot != null &&
                                                            doc.clinicLatitude !=
                                                                null
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              openMap(
                                                                double.parse(
                                                                  doc.clinicLatitude!,
                                                                ),
                                                                double.parse(
                                                                  doc.clinicLongitude!,
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              height: 50,
                                                              width: 50,
                                                              decoration: BoxDecoration(
                                                                // gradient: grad3,
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  boxShadow10,
                                                                  boxShadow8,
                                                                ],

                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.all(
                                                                      8.0,
                                                                    ),
                                                                child: Image.asset(
                                                                  "assets/images/home_icons/round-location.png",
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                )
                                              : const SizedBox(),

                                          // doc.clinicName!=null?detailsRow(icon: 'assets/images/icon-phone.svg',value: ''):SizedBox(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                            ),
                                            child: Column(
                                              children: [
                                                verticalSpace(h1p),
                                                Row(
                                                  children: [
                                                    onlineTimeSlot != null
                                                        ? Expanded(
                                                            child: InkWell(
                                                              onTap: () {
                                                                bookOnlineOnClick(
                                                                  doc,
                                                                );
                                                              },
                                                              child: Container(
                                                                height: 50,
                                                                decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        19,
                                                                      ),
                                                                  border: Border.all(
                                                                    color: const Color(
                                                                      0xff333699,
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    AppLocalizations.of(
                                                                      context,
                                                                    )!.bookOnline,
                                                                    style: t500_16.copyWith(
                                                                      color: const Color(
                                                                        0xff393ca4,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                    onlineTimeSlot != null &&
                                                            offlineTimeSlot !=
                                                                null
                                                        ? horizontalSpace(8)
                                                        : const SizedBox(),
                                                    offlineTimeSlot != null
                                                        ? Expanded(
                                                            child: InkWell(
                                                              onTap: () {
                                                                bookClinicOnClick(
                                                                  doc,
                                                                );
                                                              },
                                                              child: Container(
                                                                height: 50,
                                                                decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        19,
                                                                      ),
                                                                  color: const Color(
                                                                    0xff3B3EA8,
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    AppLocalizations.of(
                                                                      context,
                                                                    )!.bookClinic,
                                                                    style:
                                                                        t500_16,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                verticalSpace(18),
                              ]),

                              //    pad(horizontal: w1p*6,
                              //   child:   mgr.onlineCatLoader?CircularProgressIndicator():ListView(
                              //
                              //     children: [
                              //
                              //
                              //     ],
                              //
                              //   ),
                              // ),
                            ),
                          ],
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

class ResizableHeader extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final double w1p;
  final double h1p;
  final DocDetailsModel doc;

  ResizableHeader({
    required this.minHeight,
    required this.maxHeight,
    required this.doc,
    required this.h1p,
    required this.w1p,
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
    // Calculate the dynamic height
    double currentHeight = maxHeight - shrinkOffset;
    double currentProfilePicHeight = 100 - shrinkOffset;
    double pad = 50 - shrinkOffset * 0.05;
    double squareH = 80 - shrinkOffset * 0.3;
    currentHeight = currentHeight
    // .clamp(minHeight, maxHeight)
    ;

    String name = '${doc.firstName ?? ""} ${doc.lastName ?? ""}';
    String qualification = doc.qualification ?? "";
    String experience = doc.experience != null ? '${doc.experience}' : 'N/A';

    proileColumn({required String title, required String subtitle}) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        // child: BackdropFilter(
        //   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          // width: 100,
          height: squareH > 60 ? squareH : 60,
          // padding: EdgeInsets.symmetric(horizontal: 0,),
          decoration: BoxDecoration(
            color: const Color(0xffF7F7F7).withOpacity(0.61),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: t500_16.copyWith(color: clr2D2D2D)),
                Text(subtitle, style: t400_14.copyWith(color: clr2D2D2D)),
              ],
            ),
          ),
        ),
        // ),
      );
    }

    // List<Experiences> exper = data.experiences ?? [];

    // List<String> edu = eduList.map((e)=>'${e.specialization} - ${e.qualificationLevel}\n').toList();
    // String education = edu.join();

    return Column(
      children: [
        Container(
          height: 60,
          color: Colors.white,
          width: w1p * 100,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w1p * 4, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        height: 22,
                        child: Image.asset(
                          "assets/images/back-cupertino.png",
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      AppLocalizations.of(context)!.myDoctors,
                      style: t400_16.copyWith(color: clr2D2D2D),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: w1p * 4,
                left: w1p * 4,
                bottom: pad - 10 > 0 ? pad - 10 : 8,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 10,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  color: const Color(0xffFFEDEE),
                  // boxShadow: [boxShadow1,boxShadow8b],
                  // gradient: grad,
                  borderRadius: BorderRadius.circular(24),
                ),
                // extendBody: true,
                // backgroundColor: Colors.r=tr,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      verticalSpace(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                              height: currentProfilePicHeight > 60
                                  ? currentProfilePicHeight
                                  : 60,
                              width: currentProfilePicHeight > 60
                                  ? currentProfilePicHeight
                                  : 60,
                              child: HomeWidgets().cachedImg(
                                doc.image ?? "",
                                placeholderImage:
                                    "assets/images/doctor-placeholder.png",
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(h1p * 1),
                      Text(name, style: t700_18.copyWith(color: clr2D2D2D)),
                      verticalSpace(h1p * 0.1),
                      Text(
                        qualification,
                        style: t400_14.copyWith(color: clr2D2D2D),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      verticalSpace(pad > 0 ? pad : 0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: shrinkOffset > 20 ? 20 : shrinkOffset,
                ),
                child: SizedBox(
                  width: w1p * 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: proileColumn(
                          title: '${doc.completedBookingCount ?? 0}',
                          subtitle: "Patients",
                        ),
                      ),
                      horizontalSpace(10),
                      Expanded(
                        child: proileColumn(
                          title: experience,
                          subtitle: "Experience",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
