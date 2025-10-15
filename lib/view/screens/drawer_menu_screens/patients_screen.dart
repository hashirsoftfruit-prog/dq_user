import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/home_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/core/other_patients_response_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../booking_screens/patient_details_form_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  @override
  void initState() {
    super.initState();

    ///Call API for get Patients List
    getIt<HomeManager>().getMyPatientsList();
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
                title: AppLocalizations.of(context)!.myPatients,
                height: h10p,
                width: w10p,
                fn: () {
                  Navigator.pop(context);
                },
              ),
              body: Column(
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
                        mgr.listLoader == true && mgr.myPatientList.isEmpty
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
                            : mgr.myPatientList.isNotEmpty
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
                                    children: mgr.myPatientList.map((item) {
                                      // var index = mgr.myPatientList.indexOf(item);

                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: h1p * 1,
                                        ),
                                        child: Column(
                                          children: [
                                            PatientWidget(
                                              h1p: h1p,
                                              w1p: w1p,
                                              userDetails: item,
                                            ),
                                          ],
                                          // UpcomeAppointmentBox(h1p: h1p,w1p: w1p,date: e.date!=null?getIt<StateManager>().getFormattedDate(e.date!):""
                                          //     ?? "",name:e.doctorFirstName ,type: e.speciality,
                                          //     sheduledTime:"4.00 PM To 6.00 PM"
                                          // ),
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
                                    AppLocalizations.of(context)!.noPatients,
                                    style: TextStyles.notAvailableTxtStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  mgr.myPatientList.isNotEmpty && mgr.myPatientList.length > 2
                      ? const SizedBox()
                      : pad(
                          horizontal: w1p * 6,
                          vertical: h1p * 2,
                          child: ButtonWidget(
                            btnText: AppLocalizations.of(context)!.addMember,

                            ontap: () async {
                              await showModalBottomSheet(
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

                              ///Refreshing patient list
                              getIt<HomeManager>().getMyPatientsList();

                              // String? genderPref = ["Male","Female"].contains(mgr.prefrrdDocGender)==true?mgr.prefrrdDocGender:null;
                              //
                              // refreshDocData(userId:mgr.selectedPatientDetails?.id,genderPref:genderPref,slotPref:  mgr.docsData!.isFreeDoctorAvailable==true?"Free":null );
                            },

                            // child: Container(
                            //
                            //   width: maxWidth,height:h10p*0.6,decoration:BoxDecoration(borderRadius: BorderRadius.circular(21),color: Colours.primaryblue,gradient: linearGrad),
                            //     child: pad(horizontal: 0,vertical: h1p,child: Center(child: Text(AppLocalizations.of(context)!.addMember,style: t700_16.copyWith(color: Color(0xffffffff)),)),),),
                          ),
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class PatientWidget extends StatelessWidget {
  final double w1p;
  final double h1p;
  final UserDetails userDetails;
  const PatientWidget({
    super.key,
    required this.w1p,
    required this.h1p,
    required this.userDetails,
  });

  @override
  Widget build(BuildContext context) {
    Widget dataColumn({required String value, required String title}) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: t400_12.copyWith(
                color: const Color(0xff474747),
                height: 1,
              ),
            ),
            verticalSpace(h1p),
            Text(value, style: t500_14.copyWith(color: clr444444)),
          ],
        ),
      );
    }

    Widget collapsedWidg(bool isExpanded) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colours.lightGrey,
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(color: Colors.black26)
            // gradient: linearGrad3
            // boxShadow: [  BoxShadow(
            //     color: Colors.black12,
            //     spreadRadius: 0.5,offset:Offset(-0.75,0.75),
            //     blurRadius: 10
            // )]
          ),
          child: pad(
            horizontal: w1p * 1,
            vertical: h1p * 1.5,
            child: Row(
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(containerRadius),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:
                            "${StringConstants.baseUrl}'{userDetails.img}'",
                        placeholder: (context, url) => Image.asset(
                          userDetails.gender == "Male"
                              ? 'assets/images/person-man2.png'
                              : 'assets/images/person-woman2.png',
                          fit: BoxFit.fitHeight,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          userDetails.gender == "Male"
                              ? 'assets/images/person-man2.png'
                              : 'assets/images/person-woman2.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ),
                horizontalSpace(w1p * 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: w1p * 40,
                      child: Text(
                        getIt<StateManager>().capitalizeFirstLetter(
                          userDetails.firstName ?? "",
                        ),
                        style: t500_16.copyWith(color: clr444444),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          getIt<StateManager>().capitalizeFirstLetter(
                            '${userDetails.relation} ',
                          ),
                          style: t500_12.copyWith(color: clr2D2D2D),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    isExpanded
                        ? 'assets/images/arrow-up.svg'
                        : 'assets/images/arrow-down.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.black26,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [boxShadow8],
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(left: w1p * 5, right: w1p * 5, bottom: 8),
      padding: const EdgeInsets.all(2),
      child: ExpandableNotifier(
        // <-- Provides ExpandableController to its children
        child: Expandable(
          theme: ExpandableThemeData(
            inkWellBorderRadius: BorderRadius.circular(10),
          ), // <-- Driven by ExpandableController from ExpandableNotifier
          collapsed: ExpandableButton(
            theme: ExpandableThemeData(
              inkWellBorderRadius: BorderRadius.circular(10),
            ),
            child: collapsedWidg(true),
          ),
          expanded: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                ExpandableButton(child: collapsedWidg(false)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: w1p * 3,
                    vertical: h1p * 2,
                  ),
                  child: Column(
                    children: [
                      // verticalSpace(h1p*5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          dataColumn(
                            value: userDetails.dateOfBirth ?? "-",
                            title: AppLocalizations.of(context)!.dateOfBirth,
                          ),
                          dataColumn(
                            value: userDetails.gender ?? "-",
                            title: AppLocalizations.of(context)!.gender,
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          dataColumn(
                            value: userDetails.height ?? "-",
                            title: AppLocalizations.of(context)!.height,
                          ),
                          dataColumn(
                            value: userDetails.weight ?? "-",
                            title: AppLocalizations.of(context)!.weight,
                          ),
                          dataColumn(
                            value: userDetails.bloodGroup ?? "-",
                            title: AppLocalizations.of(context)!.bloodGroup2,
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          dataColumn(
                            value: userDetails.bloodSugar ?? "-",
                            title: AppLocalizations.of(context)!.bloodSugar2,
                          ),
                          dataColumn(
                            value: userDetails.bloodPressure ?? "-",
                            title: AppLocalizations.of(context)!.bloodPressure2,
                          ),
                          dataColumn(
                            value: userDetails.serumCreatinine ?? "-",
                            title: AppLocalizations.of(
                              context,
                            )!.serumCreatinine2,
                          ),
                        ],
                      ),
                      // Divider(),
                    ],
                  ),
                ),
                verticalSpace(h1p * 0.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // loader?SizedBox(height: h1p,):
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () async {
                        await showModalBottomSheet(
                          backgroundColor: Colors.blueGrey,
                          isScrollControlled: true,
                          useSafeArea: true,
                          context: context,
                          builder: (context) => PatientForm(
                            appBarTitle: AppLocalizations.of(
                              context,
                            )!.editMember,
                            maxWidth: w1p * 100,
                            maxHeight: h1p * 100,
                            user: userDetails,
                            isUserIsPatient:
                                userDetails.userId != null &&
                                userDetails.userId ==
                                    getIt<SharedPreferences>().getInt(
                                      StringConstants.userId,
                                    ),
                          ),
                        );
                        getIt<HomeManager>().getMyPatientsList();
                      },
                      child: Container(
                        width: w1p * 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [boxShadow9],
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 24,
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.changePatientInfo,
                              style: t500_16.copyWith(
                                color: clr444444,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(h1p * 1.5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
