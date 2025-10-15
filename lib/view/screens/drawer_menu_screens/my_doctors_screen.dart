import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../booking_screens/doctor_profile_screen.dart';
import 'package:dqapp/view/screens/home_screen.dart';

class MyDoctorsScreen extends StatefulWidget {
  const MyDoctorsScreen({super.key});

  @override
  State<MyDoctorsScreen> createState() => _MyDoctorsScreenState();
}

class _MyDoctorsScreenState extends State<MyDoctorsScreen> {
  // AvailableDocsModel docsData;

  @override
  void initState() {
    super.initState();
    getIt<HomeManager>().getMyDoctorsList();
  }

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
            return Scaffold(
              // extendBody: true,
              backgroundColor: Colors.white,
              appBar: getIt<SmallWidgets>().appBarWidget(
                title: AppLocalizations.of(context)!.myDoctors,
                height: h10p,
                width: w10p,
                fn: () {
                  Navigator.pop(context);
                },
              ),
              body: pad(
                horizontal: w1p * 4,
                child: Column(
                  children: [
                    // SizedBox(child:
                    // Row(
                    //     children:tabHeads.map((e)=>
                    //     InkWell(focusColor: Colors.transparent,splashColor: Colors.transparent,
                    //         onTap: ()async{
                    //           index = 1;
                    //           getIt<HomeManager>().setAppoinmentsTabTitle(e);
                    //          await getIt<HomeManager>().getUpcomingAppointments(index:index);
                    //
                    //         },
                    //         child: selectionBox(e,mgr.selectedAppointTabTitle==e,))
                    //     ).toList()
                    // ),),
                    Expanded(
                      child: ListView(
                        children: [
                          verticalSpace(h1p * 2),
                          mgr.listLoader == true && mgr.myDoctorsModel.isEmpty
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
                              : mgr.myDoctorsModel.isNotEmpty
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
                                    duration: const Duration(
                                      milliseconds: 1500,
                                    ),
                                    curve: Curves.decelerate,
                                    child: Column(
                                      children: mgr.myDoctorsModel.map((item) {
                                        // var index = mgr.myDoctorsModel.indexOf(item);

                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: h1p * 2,
                                          ),
                                          child: InkWell(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            onTap: () async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      DoctorProfileScreen(
                                                        specialityId: null,
                                                        docId: item.id!,
                                                      ),
                                                ),
                                              );

                                              // if(coupon.applicable==true){
                                              //   // await applyCoupnFn(coupon.couponCode??"");
                                              //
                                              // }else{
                                              //
                                              //   showTopSnackBar(
                                              //       Overlay.of(context),
                                              //       ErrorToast(
                                              //         message:
                                              //         "This coupon is not applicable",
                                              //       ));
                                              // }
                                            },
                                            child: Column(
                                              children: [
                                                DocItem(
                                                  h1p: h1p,
                                                  w1p: w1p,
                                                  name:
                                                      '${item.firstName ?? ""} ${item.lastName ?? ""}',
                                                  type:
                                                      item.qualification ?? "",
                                                  gender: item.gender ?? "",
                                                  img: item.image ?? "",
                                                  experience:
                                                      '${item.experience ?? 0}',
                                                  currentClinicAddress:
                                                      item.clinicName ?? "",
                                                  onlineTimeSlot: "",
                                                  offlineTimeSlot: "",
                                                ),
                                              ],
                                              // UpcomeAppointmentBox(h1p: h1p,w1p: w1p,date: e.date!=null?getIt<StateManager>().getFormattedDate(e.date!):""
                                              //     ?? "",name:e.doctorFirstName ,type: e.speciality,
                                              //     sheduledTime:"4.00 PM To 6.00 PM"
                                              // ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(28.0),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.noDoctors,
                                      style: TextStyles.notAvailableTxtStyle,
                                      textAlign: TextAlign.center,
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
  final String gender;
  final String? offlineTimeSlot;
  final String currentClinicAddress;
  const DocItem({
    super.key,
    required this.w1p,
    required this.h1p,
    required this.img,
    required this.name,
    required this.gender,
    required this.experience,
    required this.onlineTimeSlot,
    required this.type,
    required this.offlineTimeSlot,
    required this.currentClinicAddress,
  });

  @override
  Widget build(BuildContext context) {
    String docExperience = '$experience Years ';
    // var grad1 = const LinearGradient(colors: [Color(0xff9E74F8),Color(0xff8F5BFE),]);
    // var grad2 = const LinearGradient(colors: [Color(0xff4D51C7),Color(0xff2E3192)]);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: Colors.black26),
        boxShadow: [boxShadow5],
        color: Colors.white,
        // gradient: linearGrad3
      ),
      child: pad(
        horizontal: w1p * 3,
        vertical: h1p * 2,
        child: Column(
          children: [
            Row(
              children: [
                // horizontal: w1p*2.5,
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(containerRadius),
                        // border: Border.all(color: Colors.black26),
                        boxShadow: [boxShadow5],
                        color: Colors.white,
                        // gradient: linearGrad3
                      ),
                      height: 70,
                      width: 70,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(containerRadius),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: "${StringConstants.baseUrl}$img",
                            placeholder: (context, url) => Image.asset(
                              'assets/images/doctor-placeholder.png',
                              fit: BoxFit.fitHeight,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/doctor-placeholder.png',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Positioned(left:0,top:0,child: SizedBox(
                    //
                    //     width:35,
                    //     child: Image.asset("assets/images/home_icons/slice-border.png",color: Colors.black26,))),
                  ],
                ),
                horizontalSpace(w1p * 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(name, style: TextStyles.textStyle3c),
                      Row(
                        children: [
                          Text(
                            '$gender ',
                            style: t500_12.copyWith(color: clr2D2D2D),
                          ),
                          Text(
                            ' | ',
                            style: t500_14.copyWith(color: clr2D2D2D),
                          ),
                          Text(
                            docExperience,
                            style: t500_12.copyWith(color: clr2D2D2D),
                          ),
                        ],
                      ),
                      Text(type, style: t500_12.copyWith(color: clr2D2D2D)),
                    ],
                  ),
                ),
              ],
            ),

            // Divider(),
            // Row(children: [
            //   SizedBox(height: 15,width: 15, child: Image.asset("assets/images/doc-list-icon1.png")),
            //   Text("time",style: TextStyles.textStyle65,),
            // ],),

            // verticalSpace(h1p),
            // Align(
            //     alignment: Alignment.centerLeft,
            //     child: Text(currentClinicAddress,style: TextStyles.textStyle65,)),

            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 5),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: onlineTimeSlot!=null? Container(
            //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),gradient:grad1, ),
            //           child: Padding(
            //             padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 12),
            //             child: Center(child: Text("Book Online",style: TextStyles.textStyle64,)),
            //           ),):SizedBox(),
            //       ),
            //       horizontalSpace(w1p),
            //       Expanded(
            //         child:offlineTimeSlot!=null? Container(
            //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),gradient:grad2, ),
            //           child: Padding(
            //             padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 12),
            //             child: Center(child: Text("Book Clinic",style: TextStyles.textStyle64,)),
            //           ),):SizedBox(),
            //       ),
            //
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
