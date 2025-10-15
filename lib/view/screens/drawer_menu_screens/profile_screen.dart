import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/theme/text_styles.dart';

import 'package:dqapp/controller/managers/profile_manager.dart';
import 'package:dqapp/model/core/profile_model.dart';
import 'package:dqapp/view/widgets/popup_with_scroll_list.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/managers/auth_manager.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/core/basic_response_model.dart';
import '../../../model/core/medical_suggestions_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../widgets/common_widgets.dart';
import '../../theme/constants.dart';
import '../booking_screens/booking_screen_widgets.dart';
import '../../widgets/drop_down_list_popup_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  var contrllr = TextEditingController();

  @override
  void initState() {
    super.initState();
    getIt<ProfileManager>().initProfile();
    // MedicalDetails healthDetails = widget.user.medicalDetails ?? MedicalDetails();

    // contrllr.text = usrDetails.firstName ?? "";
    // lnameC.text = usrDetails.lastName ?? "";
    // ageC.text = usrDetails.dateOfBirth ?? "";
    // genderC.text = usrDetails.gender ?? "";
    // // relationC.text =
    // // widget.relation != null ? widget.relation! : usrDetails.relation ?? "";
    // HghtC.text = healthDetails.height ?? "";
    // weightC.text = healthDetails.weight ?? "";
    // bGroupC.text = healthDetails.bloodGroup ?? "";
    // bSugarC.text = healthDetails.bloodSugar ?? "";
    // BpC.text = healthDetails.bloodPressure ?? "";
    // serumC.text = healthDetails.serumCreatinine ?? "";
  }

  Future<void> launchInWebView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void dispose() {
    getIt<ProfileManager>().disposeProfile();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final PageController pgControllr = PageController();

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return Consumer<ProfileManager>(
          builder: (context, mgr, child) {
            int? userId = mgr.profileModel.personalDetails!.id;
            String? proPic = mgr.profileModel.personalDetails!.image;
            String? fname = mgr.profileModel.personalDetails!.firstName;
            String? lname = mgr.profileModel.personalDetails!.lastName;
            String? phone = mgr.profileModel.personalDetails!.phone;
            String? email = mgr.profileModel.personalDetails!.email;
            String? gender = mgr.profileModel.personalDetails!.gender;
            String? dateOfBirth = mgr.profileModel.personalDetails!.dateOfBirth;
            String? maritalStatus =
                mgr.profileModel.personalDetails!.maritalStatus;
            // String? height =  mgr.profileModel.healthDetails;
            // String? weight =  mgr.profileModel.healthDetails!.weight;
            // String? bloodGroup =  mgr.profileModel.healthDetails!.bloodGroup;
            // String? bloodPress =  mgr.profileModel.healthDetails!.bloodPressure;
            HeatlthDetails? healthDetails = mgr.profileModel.healthDetails;
            MedicalDetails? medicalDetails = mgr.profileModel.medicalDetails;
            List<String> pastMedicaitons =
                medicalDetails?.pastMedication != null
                ? medicalDetails!.pastMedication!
                      .map((e) => e.pastMedication)
                      .whereType<String>()
                      .toList()
                : [];
            List<String> currentMedications =
                medicalDetails?.currentMedication != null
                ? medicalDetails!.currentMedication!
                      .map((e) => e.currentMedication)
                      .whereType<String>()
                      .toList()
                : [];

            List<String> allergies = medicalDetails?.allergy != null
                ? medicalDetails!.allergy!
                      .map((e) => e.allergy)
                      .whereType<String>()
                      .toList()
                : [];
            List<String> chronicDesease = medicalDetails?.chronicDisease != null
                ? medicalDetails!.chronicDisease!
                      .map((e) => e.chronicDisease)
                      .whereType<String>()
                      .toList()
                : [];
            List<String> injuries = medicalDetails?.injury != null
                ? medicalDetails!.injury!
                      .map((e) => e.injury)
                      .whereType<String>()
                      .toList()
                : [];
            MedicalInfoSuggestionsModel? medSugges = mgr.medicalSuggestions;

            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              appBar: getIt<SmallWidgets>().appBarWidget(
                title: AppLocalizations.of(context)!.profile,
                height: h10p,
                width: w10p,
                fn: () {
                  Navigator.pop(context);
                },
              ),
              body: Entry(
                xOffset: 300,
                // scale: 20,
                // scale: 20,
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                child: ListView(
                  children: [
                    pad(
                      horizontal: w1p * 4,
                      child: Container(
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            image: AssetImage(
                              "assets/images/profile-screen-top-bg.png",
                            ),
                          ),
                          color: Colors.white,
                          boxShadow: [boxShadow8b],
                          gradient: linearGrad2,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: pad(
                          vertical: h1p * 3,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      height: h1p * 11,
                                      width: h1p * 11,
                                      decoration: BoxDecoration(
                                        border: proPic == null
                                            ? Border.all(
                                                width: 2,
                                                color: Colors.white54,
                                              )
                                            : null,
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(
                                              proPic != null ? 0 : 18.0,
                                            ),
                                            child: proPic != null
                                                ? Image.network(
                                                    '${StringConstants.baseUrl}$proPic',
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    gender!.toUpperCase() ==
                                                            "MALE"
                                                        ? "assets/images/person-man.png"
                                                        : "assets/images/person-women.png",
                                                    color: Colors.white54,
                                                  ),
                                          ),
                                          mgr.profileEditable == true
                                              ? InkWell(
                                                  onTap: () async {
                                                    final imgSelected =
                                                        await ImagePicker()
                                                            .pickImage(
                                                              imageQuality: 70,
                                                              maxWidth: 1440,
                                                              source:
                                                                  ImageSource
                                                                      .gallery,
                                                            );
                                                    if (imgSelected != null) {
                                                      var result =
                                                          await getIt<
                                                                ProfileManager
                                                              >()
                                                              .changeProPic(
                                                                imgSelected,
                                                              );
                                                      if (result.status ==
                                                          true) {
                                                        getIt<ProfileManager>()
                                                            .getProfileData();
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: proPic == null
                                                          ? Colors.black87
                                                          : Colors.black38,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons
                                                            .camera_alt_outlined,
                                                        color: Colors.white54,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  verticalSpace(12),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 2),
                                    transitionBuilder: (child, animation) =>
                                        ScaleTransition(
                                          scale: animation,
                                          child: child,
                                        ),
                                    child: mgr.profileEditable == true
                                        ? Entry(
                                            yOffset: -20,
                                            // scale: 20,
                                            delay: const Duration(
                                              milliseconds: 100,
                                            ),
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.ease,
                                            child: Column(
                                              children: [
                                                EditProfileTextFeild2(
                                                  h1p: h1p,
                                                  value: getIt<StateManager>()
                                                      .capitalizeFirstLetter(
                                                        fname ?? "",
                                                      ),
                                                  w1p: w1p,
                                                  cntrolr: contrllr,
                                                  hnt: AppLocalizations.of(
                                                    context,
                                                  )!.firstname,
                                                  readOnly: mgr.profileReadonly,
                                                  type: "char",
                                                  fn: () {
                                                    showDialog(
                                                      // backgroundColor: Colors.white,
                                                      // isScrollControlled: false,
                                                      useSafeArea: true,
                                                      // showDragHandle: true,
                                                      context: context,
                                                      builder: (context) => TextFieldPop(
                                                        value: fname,
                                                        fn: (val) async {
                                                          getIt<
                                                                ProfileManager
                                                              >()
                                                              .updateFirstname(
                                                                val,
                                                              );
                                                          var result =
                                                              await getIt<
                                                                    ProfileManager
                                                                  >()
                                                                  .updatePersonalDetails({
                                                                    "first_name":
                                                                        val,
                                                                  });
                                                          if (result.status ==
                                                              true) {
                                                            getIt<AuthManager>()
                                                                .saveUserName(
                                                                  val,
                                                                );
                                                          }
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),
                                                EditProfileTextFeild2(
                                                  h1p: h1p,
                                                  value: getIt<StateManager>()
                                                      .capitalizeFirstLetter(
                                                        lname ?? "",
                                                      ),
                                                  w1p: w1p,
                                                  cntrolr: contrllr,
                                                  hnt: AppLocalizations.of(
                                                    context,
                                                  )!.lastName,
                                                  readOnly: mgr.profileReadonly,
                                                  type: "char",
                                                  fn: () {
                                                    showDialog(
                                                      // backgroundColor: Colors.white,
                                                      // isScrollControlled: false,
                                                      useSafeArea: true,
                                                      // showDragHandle: true,
                                                      context: context,
                                                      builder: (context) => TextFieldPop(
                                                        value: lname,
                                                        fn: (val) {
                                                          getIt<
                                                                ProfileManager
                                                              >()
                                                              .updateLastName(
                                                                val,
                                                              );
                                                          getIt<
                                                                ProfileManager
                                                              >()
                                                              .updatePersonalDetails(
                                                                {
                                                                  "last_name":
                                                                      val,
                                                                },
                                                              );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                        : Entry(
                                            yOffset: 10,
                                            // scale: 20,
                                            delay: const Duration(
                                              milliseconds: 100,
                                            ),
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.ease,
                                            child: SizedBox(
                                              width: w10p * 9,
                                              child: Text(
                                                '${getIt<StateManager>().capitalizeFirstLetter("$fname")} ${getIt<StateManager>().capitalizeFirstLetter("$lname")}',
                                                style: t500_14,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                  ),
                                  // SizedBox(
                                  //     height: h1p * 2,
                                  //     child: const VerticalDivider(
                                  //       color: Colours.lightGrey,
                                  //     )),
                                  SizedBox(
                                    child: Center(
                                      child: Text(phone ?? "", style: t500_14),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                right: 10,
                                top: 0,
                                child: InkWell(
                                  onTap: () {
                                    getIt<ProfileManager>().setProfileEditable(
                                      !mgr.profileEditable,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Entry(
                                      yOffset: -100,
                                      // scale: 20,
                                      // scale: 20,
                                      delay: const Duration(milliseconds: 1000),
                                      duration: const Duration(
                                        milliseconds: 1000,
                                      ),
                                      curve: Curves.ease,
                                      child:
                                          // Icon(Icons.done,color: Colors.white,)
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.white54,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                3.0,
                                              ),
                                              child: mgr.profileEditable != true
                                                  ? const Icon(
                                                      Icons.edit_outlined,
                                                      color: Colors.white,
                                                    )
                                                  : const Icon(
                                                      Icons.file_download_done,
                                                      color: Colors.white,
                                                    ),
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // verticalSpace(h1p),
                    verticalSpace(h1p * 2),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: h1p * 4,
                                    color: Colours.lightBlu,
                                  ),
                                ),
                              ],
                            ),
                            ScrollingButtonBar(
                              selectedItemIndex: mgr.tabIndex,
                              scrollController: scrollController,
                              childWidth: w10p * 2,
                              childHeight: h1p * 4,
                              foregroundColor: const Color(0xff6C6EB8),
                              radius: 0,
                              animationDuration: const Duration(
                                milliseconds: 333,
                              ),
                              children: [
                                ButtonsItem(
                                  child: Container(
                                    color: mgr.tabIndex != 0
                                        ? Colors.transparent
                                        : Colors.transparent,
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.personalInfo,
                                        style: mgr.tabIndex == 0
                                            ? t500_14.copyWith(
                                                color: const Color(0xffF2F2F2),
                                              )
                                            : t500_14.copyWith(
                                                color: clr444444,
                                              ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    getIt<ProfileManager>().changeIndex(0);
                                    pgControllr.animateToPage(
                                      0,
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                ),
                                ButtonsItem(
                                  child: Container(
                                    color: mgr.tabIndex != 1
                                        ? Colors.transparent
                                        : Colors.transparent,
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.healthInfo,
                                        style: mgr.tabIndex == 1
                                            ? t500_14.copyWith(
                                                color: const Color(0xffF2F2F2),
                                              )
                                            : t500_14.copyWith(
                                                color: clr444444,
                                              ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    getIt<ProfileManager>().changeIndex(1);
                                    pgControllr.animateToPage(
                                      1,
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                ),
                                ButtonsItem(
                                  child: Container(
                                    color: mgr.tabIndex != 2
                                        ? Colors.transparent
                                        : Colors.transparent,
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.medicalInfo,
                                        style: mgr.tabIndex == 2
                                            ? t500_14.copyWith(
                                                color: const Color(0xffF2F2F2),
                                              )
                                            : t500_14.copyWith(
                                                color: clr444444,
                                              ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    getIt<ProfileManager>().changeIndex(2);
                                    pgControllr.animateToPage(
                                      2,
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    verticalSpace(h1p * 2),
                    SizedBox(
                      height: h10p * 5,
                      child: PageView(
                        pageSnapping: true,
                        controller: pgControllr,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          //personal details
                          // ++++++++++++++++++
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: h1p * 2,
                                  horizontal: w1p * 2,
                                ),
                                child: Column(
                                  children: [
                                    EditProfileTextFeild(
                                      h1p: h1p,
                                      value: email,
                                      w1p: w1p,
                                      cntrolr: contrllr,
                                      hnt: AppLocalizations.of(context)!.email,
                                      readOnly: mgr.profileReadonly,
                                      type: "char",
                                      fn: () {
                                        showDialog(
                                          // backgroundColor: Colors.white,
                                          // isScrollControlled: false,
                                          useSafeArea: true,
                                          // showDragHandle: true,
                                          context: context,
                                          builder: (context) => TextFieldPop(
                                            isEmail: true,
                                            value: email,
                                            fn: (val) {
                                              getIt<ProfileManager>()
                                                  .updateEmail(val);
                                              getIt<ProfileManager>()
                                                  .updatePersonalDetails({
                                                    "email": val,
                                                  });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    verticalSpace(h1p * 1),
                                    InkWell(
                                      child: EditProfileTextFeild(
                                        h1p: h1p,
                                        w1p: w1p,
                                        value: gender,
                                        cntrolr: contrllr,
                                        hnt: AppLocalizations.of(
                                          context,
                                        )!.gender,
                                        readOnly: mgr.profileReadonly,
                                        type: "char",
                                        fn: () {
                                          var lst = ["Male", "Female", "Other"];
                                          int selectedIndex =
                                              getIt<ProfileManager>()
                                                  .findIndexFromList(
                                                    lst: lst,
                                                    selectedValue: gender ?? "",
                                                  ) ??
                                              0;

                                          showModalBottomSheet(
                                            backgroundColor: Colors.white,
                                            isScrollControlled: true,
                                            useSafeArea: true,
                                            showDragHandle: true,
                                            context: context,
                                            builder: (context) => ScrollPopUp(
                                              lst: lst,
                                              itemIndex: selectedIndex,
                                              fn: (val) {
                                                getIt<ProfileManager>()
                                                    .updateGenderInProfileModel(
                                                      val,
                                                    );
                                                getIt<ProfileManager>()
                                                    .updatePersonalDetails({
                                                      "gender": val,
                                                    });
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    verticalSpace(h1p * 1),
                                    EditProfileTextFeild(
                                      h1p: h1p,
                                      w1p: w1p,
                                      value: dateOfBirth,
                                      cntrolr: contrllr,
                                      hnt: AppLocalizations.of(
                                        context,
                                      )!.dateOfBirth,
                                      readOnly: mgr.profileReadonly,
                                      type: "char",
                                      fn: () {},
                                    ),
                                    verticalSpace(h1p * 1),
                                    EditProfileTextFeild(
                                      h1p: h1p,
                                      w1p: w1p,
                                      value: maritalStatus,
                                      cntrolr: contrllr,
                                      hnt: AppLocalizations.of(
                                        context,
                                      )!.maritalStatus,
                                      readOnly: mgr.profileReadonly,
                                      type: "char",
                                      fn: () {
                                        var lst = ["Married", "Unmarried"];
                                        int selectedIndex =
                                            getIt<ProfileManager>()
                                                .findIndexFromList(
                                                  lst: lst,
                                                  selectedValue: gender ?? "",
                                                ) ??
                                            0;
                                        // List<int> heightRange = [65, 272]; // Min and Max height in cm

                                        showModalBottomSheet(
                                          backgroundColor: Colors.white,
                                          isScrollControlled: true,
                                          useSafeArea: true,
                                          showDragHandle: true,
                                          context: context,
                                          builder: (context) => ScrollPopUp(
                                            lst: lst,
                                            itemIndex: selectedIndex,
                                            fn: (val) {
                                              getIt<ProfileManager>()
                                                  .updateMaritalStatusInProfileModel(
                                                    val,
                                                  );
                                              getIt<ProfileManager>()
                                                  .updatePersonalDetails({
                                                    "marital_status": val,
                                                  });
                                              // if(result.status==true){
                                              //
                                              // }
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //Health Details
                          // ++++++++++++++++++
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: h1p * 2,
                                  horizontal: w1p * 2,
                                ),
                                child: Column(
                                  children: [
                                    EditProfileTextFeild(
                                      h1p: h1p,
                                      w1p: w1p,
                                      value: healthDetails?.height,
                                      cntrolr: contrllr,
                                      hnt: AppLocalizations.of(context)!.height,
                                      readOnly: mgr.profileReadonly,
                                      type: "char",
                                      fn: () {
                                        List<String> lst = List.generate(
                                          300 - 65 + 1,
                                          (index) => (65 + index).toString(),
                                        );
                                        int selectedIndex =
                                            getIt<ProfileManager>()
                                                .findIndexFromList(
                                                  lst: lst,
                                                  selectedValue:
                                                      healthDetails?.height ??
                                                      "100",
                                                ) ??
                                            0;

                                        showModalBottomSheet(
                                          backgroundColor: Colors.white,
                                          isScrollControlled: true,
                                          useSafeArea: true,
                                          showDragHandle: true,
                                          context: context,
                                          builder: (context) => ScrollPopUp(
                                            lst: lst,
                                            itemIndex: selectedIndex,
                                            measur: "cm",
                                            fn: (val) {
                                              getIt<ProfileManager>()
                                                  .updateHeight(val);
                                              getIt<ProfileManager>()
                                                  .updateHealthDetails({
                                                    "height": int.parse(val),
                                                  });
                                              // if(result.status==true){
                                              //
                                              // }
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    verticalSpace(h1p * 1),
                                    EditProfileTextFeild(
                                      h1p: h1p,
                                      w1p: w1p,
                                      value: healthDetails?.weight,
                                      cntrolr: contrllr,
                                      hnt: AppLocalizations.of(context)!.weight,
                                      readOnly: mgr.profileReadonly,
                                      type: "char",
                                      fn: () {
                                        List<String> lst = List.generate(
                                          999 - 2 + 1,
                                          (index) => (2 + index).toString(),
                                        );
                                        int selectedIndex =
                                            getIt<ProfileManager>()
                                                .findIndexFromList(
                                                  lst: lst,
                                                  selectedValue:
                                                      healthDetails?.weight ??
                                                      "50",
                                                ) ??
                                            0;

                                        showModalBottomSheet(
                                          backgroundColor: Colors.white,
                                          isScrollControlled: true,
                                          useSafeArea: true,
                                          showDragHandle: true,
                                          context: context,
                                          builder: (context) => ScrollPopUp(
                                            lst: lst,
                                            itemIndex: selectedIndex,
                                            measur: "kg",
                                            fn: (val) {
                                              getIt<ProfileManager>()
                                                  .updateWeight(val);
                                              getIt<ProfileManager>()
                                                  .updateHealthDetails({
                                                    "weight": int.parse(val),
                                                  });
                                              // if(result.status==true){
                                              //
                                              // }
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    verticalSpace(h1p * 1),
                                    EditProfileTextFeild(
                                      h1p: h1p,
                                      w1p: w1p,
                                      value:
                                          healthDetails?.bloodGroup != null &&
                                              healthDetails!
                                                  .bloodGroup!
                                                  .isNotEmpty
                                          ? healthDetails.bloodGroup
                                          : null,
                                      cntrolr: contrllr,
                                      hnt: AppLocalizations.of(
                                        context,
                                      )!.bloodGroup2,
                                      readOnly: mgr.profileReadonly,
                                      type: "char",
                                      fn: () {
                                        List<String> lst = [
                                          'A+',
                                          'A-',
                                          'B+',
                                          'B-',
                                          'AB+',
                                          'AB-',
                                          'O+',
                                          'O-',
                                        ];

                                        int selectedIndex =
                                            getIt<ProfileManager>()
                                                .findIndexFromList(
                                                  lst: lst,
                                                  selectedValue:
                                                      healthDetails
                                                          ?.bloodGroup ??
                                                      "B-",
                                                ) ??
                                            0;

                                        showModalBottomSheet(
                                          backgroundColor: Colors.white,
                                          isScrollControlled: true,
                                          useSafeArea: true,
                                          showDragHandle: true,
                                          context: context,
                                          builder: (context) => ScrollPopUp(
                                            lst: lst,
                                            itemIndex: selectedIndex,
                                            measur: "",
                                            fn: (val) {
                                              getIt<ProfileManager>()
                                                  .updateBloodGroup(val);
                                              getIt<ProfileManager>()
                                                  .updateHealthDetails({
                                                    "blood_group": val,
                                                  });
                                              // if(result.status==true){
                                              //
                                              // }
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    verticalSpace(h1p * 1),
                                    EditProfileTextFeild(
                                      h1p: h1p,
                                      w1p: w1p,
                                      value:
                                          healthDetails?.bloodPressure !=
                                                  null &&
                                              healthDetails!
                                                  .bloodPressure!
                                                  .isNotEmpty
                                          ? healthDetails.bloodPressure
                                          : null,
                                      cntrolr: contrllr,
                                      hnt: AppLocalizations.of(
                                        context,
                                      )!.bloodPressure,
                                      readOnly: mgr.profileReadonly,
                                      type: "char",
                                      fn: () {
                                        String? systolicVlaue;
                                        String? diastolic;
                                        List<String> lst = List.generate(
                                          200 - 90 + 1,
                                          (index) => (90 + index).toString(),
                                        );
                                        List<String> lst2 = List.generate(
                                          120 - 60 + 1,
                                          (index) => (60 + index).toString(),
                                        );

                                        if (healthDetails?.bloodPressure !=
                                            null) {
                                          var listOfValues = healthDetails!
                                              .bloodPressure!
                                              .split('/');
                                          if (listOfValues.isNotEmpty &&
                                              listOfValues.length == 2) {
                                            systolicVlaue = listOfValues[0];
                                            diastolic = listOfValues[1];
                                          }
                                        }

                                        int selectedIndex =
                                            getIt<ProfileManager>()
                                                .findIndexFromList(
                                                  lst: lst,
                                                  selectedValue:
                                                      systolicVlaue ?? "",
                                                ) ??
                                            (lst.length) % 2;
                                        int selectedIndex2 =
                                            getIt<ProfileManager>()
                                                .findIndexFromList(
                                                  lst: lst2,
                                                  selectedValue:
                                                      diastolic ?? "",
                                                ) ??
                                            (lst2.length) % 2;

                                        showModalBottomSheet(
                                          backgroundColor: Colors.white,
                                          isScrollControlled: true,
                                          useSafeArea: true,
                                          showDragHandle: true,
                                          context: context,
                                          builder: (context) =>
                                              ScrollPopUpWith2Value(
                                                itemIndex2: selectedIndex2,
                                                lst: lst,
                                                lst2: lst2,
                                                itemIndex: selectedIndex,
                                                measur: "mmHg",
                                                fn: (val) {
                                                  getIt<ProfileManager>()
                                                      .updateBloodP(val);
                                                  getIt<ProfileManager>()
                                                      .updateHealthDetails({
                                                        "blood_pressure": val,
                                                      });
                                                  // if(result.status==true){
                                                  //
                                                  // }
                                                },
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //Medical details
                          // ++++++++++++++++++
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: h1p * 2,
                                  horizontal: w1p * 2,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      EditProfileTextFeild(
                                        h1p: h1p,
                                        w1p: w1p,
                                        value: allergies.isNotEmpty
                                            ? allergies.join(', ')
                                            : null,
                                        cntrolr: contrllr,
                                        hnt: AppLocalizations.of(
                                          context,
                                        )!.allergies,
                                        readOnly: mgr.profileReadonly,
                                        type: "char",
                                        fn: () {
                                          if (medSugges?.suggestions != null) {
                                            getIt<StateManager>().setListItems(
                                              isRefresh: true,
                                              medSugges!.suggestions!
                                                  .map(
                                                    (e) => e.type == 'Allergy'
                                                        ? BasicListItem(
                                                            item: e.suggestion,
                                                            id: e.id,
                                                          )
                                                        : null,
                                                  )
                                                  .whereType<BasicListItem>()
                                                  .toList(),
                                            );
                                            getIt<StateManager>().addItems(
                                              isRefresh: true,
                                              medicalDetails?.allergy != null
                                                  ? medicalDetails!.allergy!
                                                        .map(
                                                          (e) => BasicListItem(
                                                            id: e.id,
                                                            item: e.allergy,
                                                          ),
                                                        )
                                                        .toList()
                                                  : [],
                                            );
                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              useSafeArea: true,
                                              showDragHandle: true,
                                              backgroundColor: Colors.white,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DropDownListScreen(
                                                  maxWidth: maxWidth,
                                                  maxHeight: maxHeight,
                                                  fn: (selectedItems) async {
                                                    var result = await getIt<ProfileManager>()
                                                        .updateMedicalInfo(
                                                          type: "allergy",
                                                          items: selectedItems,
                                                          previousList:
                                                              medicalDetails
                                                                      ?.allergy !=
                                                                  null
                                                              ? medicalDetails!
                                                                    .allergy!
                                                                    .map(
                                                                      (
                                                                        e,
                                                                      ) => BasicListItem(
                                                                        id: e
                                                                            .id,
                                                                        item: e
                                                                            .allergy,
                                                                      ),
                                                                    )
                                                                    .toList()
                                                              : [],
                                                        );
                                                    if (result.status == true) {
                                                      getIt<ProfileManager>()
                                                          .getProfileData();
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: "Something went wrong",
                                            );
                                          }
                                        },
                                      ),
                                      verticalSpace(h1p * 1),
                                      EditProfileTextFeild(
                                        h1p: h1p,
                                        w1p: w1p,
                                        value: currentMedications.isNotEmpty
                                            ? currentMedications.join(', ')
                                            : null,
                                        cntrolr: contrllr,
                                        hnt: AppLocalizations.of(
                                          context,
                                        )!.currentMedications,
                                        readOnly: mgr.profileReadonly,
                                        type: "char",
                                        fn: () {
                                          if (medSugges?.drugs != null) {
                                            getIt<StateManager>().setListItems(
                                              isRefresh: true,
                                              medSugges!.drugs!
                                                  .map(
                                                    (e) => BasicListItem(
                                                      item: e.title,
                                                      id: e.id,
                                                    ),
                                                  )
                                                  .toList(),
                                            );
                                            getIt<StateManager>().addItems(
                                              isRefresh: true,
                                              medicalDetails
                                                          ?.currentMedication !=
                                                      null
                                                  ? medicalDetails!
                                                        .currentMedication!
                                                        .map(
                                                          (e) => BasicListItem(
                                                            id: e.id,
                                                            item: e
                                                                .currentMedication,
                                                          ),
                                                        )
                                                        .toList()
                                                  : [],
                                            );

                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              useSafeArea: true,
                                              showDragHandle: true,
                                              backgroundColor: Colors.white,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DropDownListScreen(
                                                  maxWidth: maxWidth,
                                                  maxHeight: maxHeight,
                                                  disableCreate: true,
                                                  //   lst:
                                                  // medSugges!.drugs!.map((e)=>BasicListItem(item: e.title,id: e.id)).toList(),
                                                  //   selectedItems:medicalDetails?.currentMedication!=null?medicalDetails!.currentMedication!.map((e)=>BasicListItem(id: e.id,item: e.currentMedication)).toList():[],
                                                  fn: (selectedItems) async {
                                                    var result = await getIt<ProfileManager>().updateMedicalInfo(
                                                      type:
                                                          "current_medication",
                                                      items: selectedItems,
                                                      previousList:
                                                          medicalDetails
                                                                  ?.currentMedication !=
                                                              null
                                                          ? medicalDetails!
                                                                .currentMedication!
                                                                .map(
                                                                  (
                                                                    e,
                                                                  ) => BasicListItem(
                                                                    id: e.id,
                                                                    item: e
                                                                        .currentMedication,
                                                                  ),
                                                                )
                                                                .toList()
                                                          : [],
                                                    );
                                                    if (result.status == true) {
                                                      getIt<ProfileManager>()
                                                          .getProfileData();
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: "Something went wrong",
                                            );
                                          }
                                        },
                                      ),
                                      verticalSpace(h1p * 1),
                                      EditProfileTextFeild(
                                        h1p: h1p,
                                        w1p: w1p,
                                        value: pastMedicaitons.isNotEmpty
                                            ? pastMedicaitons.join(', ')
                                            : null,
                                        cntrolr: contrllr,
                                        hnt: AppLocalizations.of(
                                          context,
                                        )!.postMedications,
                                        readOnly: mgr.profileReadonly,
                                        type: "char",
                                        fn: () {
                                          getIt<StateManager>().setListItems(
                                            isRefresh: true,
                                            medSugges!.drugs!
                                                .map(
                                                  (e) => BasicListItem(
                                                    item: e.title,
                                                    id: e.id,
                                                  ),
                                                )
                                                .toList(),
                                          );
                                          getIt<StateManager>().addItems(
                                            isRefresh: true,
                                            medicalDetails?.pastMedication !=
                                                    null
                                                ? medicalDetails!
                                                      .pastMedication!
                                                      .map(
                                                        (e) => BasicListItem(
                                                          id: e.id,
                                                          item:
                                                              e.pastMedication,
                                                        ),
                                                      )
                                                      .toList()
                                                : [],
                                          );

                                          if (medSugges.drugs != null) {
                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              useSafeArea: true,
                                              showDragHandle: true,
                                              backgroundColor: Colors.white,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DropDownListScreen(
                                                  maxWidth: maxWidth,
                                                  maxHeight: maxHeight,
                                                  disableCreate: true,
                                                  //   lst:
                                                  // medSugges!.drugs!.map((e)=>BasicListItem(item: e.title,id: e.id)).toList(),
                                                  //   selectedItems:medicalDetails?.pastMedication!=null?medicalDetails!.pastMedication!.map((e)=>BasicListItem(id: e.id,item: e.pastMedication)).toList():[],
                                                  fn: (selectedItems) async {
                                                    var result = await getIt<ProfileManager>()
                                                        .updateMedicalInfo(
                                                          type:
                                                              "past_medication",
                                                          items: selectedItems,
                                                          previousList:
                                                              medicalDetails
                                                                      ?.pastMedication !=
                                                                  null
                                                              ? medicalDetails!
                                                                    .pastMedication!
                                                                    .map(
                                                                      (
                                                                        e,
                                                                      ) => BasicListItem(
                                                                        id: e
                                                                            .id,
                                                                        item: e
                                                                            .pastMedication,
                                                                      ),
                                                                    )
                                                                    .toList()
                                                              : [],
                                                        );
                                                    if (result.status == true) {
                                                      getIt<ProfileManager>()
                                                          .getProfileData();
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: "Something went wrong",
                                            );
                                          }
                                        },
                                      ),
                                      verticalSpace(h1p * 1),
                                      EditProfileTextFeild(
                                        h1p: h1p,
                                        w1p: w1p,
                                        value: chronicDesease.isNotEmpty
                                            ? chronicDesease.join(', ')
                                            : null,
                                        cntrolr: contrllr,
                                        hnt: AppLocalizations.of(
                                          context,
                                        )!.chronicDiseases,
                                        readOnly: mgr.profileReadonly,
                                        type: "char",
                                        fn: () {
                                          getIt<StateManager>().setListItems(
                                            isRefresh: true,
                                            medSugges!.suggestions!
                                                .map(
                                                  (e) =>
                                                      e.type ==
                                                          'Chronic Disease'
                                                      ? BasicListItem(
                                                          item: e.suggestion,
                                                          id: e.id,
                                                        )
                                                      : null,
                                                )
                                                .whereType<BasicListItem>()
                                                .toList(),
                                          );
                                          getIt<StateManager>().addItems(
                                            isRefresh: true,
                                            medicalDetails?.chronicDisease !=
                                                    null
                                                ? medicalDetails!
                                                      .chronicDisease!
                                                      .map(
                                                        (e) => BasicListItem(
                                                          id: e.id,
                                                          item:
                                                              e.chronicDisease,
                                                        ),
                                                      )
                                                      .toList()
                                                : [],
                                          );

                                          if (medSugges.suggestions != null) {
                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              useSafeArea: true,
                                              showDragHandle: true,
                                              backgroundColor: Colors.white,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DropDownListScreen(
                                                  maxWidth: maxWidth,
                                                  maxHeight: maxHeight,
                                                  //   lst:
                                                  // medSugges!.suggestions!.map((e)=>e.type=='Chronic Disease'?BasicListItem(item: e.suggestion,id: e.id):null).whereType<BasicListItem>().toList(),
                                                  //   selectedItems:medicalDetails?.chronicDisease!=null?medicalDetails!.chronicDisease!.map((e)=>BasicListItem(id: e.id,item: e.chronicDisease)).toList():[],
                                                  fn: (selectedItems) async {
                                                    var result = await getIt<ProfileManager>()
                                                        .updateMedicalInfo(
                                                          type:
                                                              "chronic_disease",
                                                          items: selectedItems,
                                                          previousList:
                                                              medicalDetails
                                                                      ?.chronicDisease !=
                                                                  null
                                                              ? medicalDetails!
                                                                    .chronicDisease!
                                                                    .map(
                                                                      (
                                                                        e,
                                                                      ) => BasicListItem(
                                                                        id: e
                                                                            .id,
                                                                        item: e
                                                                            .chronicDisease,
                                                                      ),
                                                                    )
                                                                    .toList()
                                                              : [],
                                                        );
                                                    if (result.status == true) {
                                                      getIt<ProfileManager>()
                                                          .getProfileData();
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: "Something went wrong",
                                            );
                                          }
                                        },
                                      ),
                                      verticalSpace(h1p * 1),
                                      EditProfileTextFeild(
                                        h1p: h1p,
                                        w1p: w1p,
                                        value: injuries.isNotEmpty
                                            ? injuries.join(', ')
                                            : null,
                                        cntrolr: contrllr,
                                        hnt: AppLocalizations.of(
                                          context,
                                        )!.injuries,
                                        readOnly: mgr.profileReadonly,
                                        type: "char",
                                        fn: () {
                                          getIt<StateManager>().setListItems(
                                            isRefresh: true,
                                            medSugges!.suggestions!
                                                .map(
                                                  (e) => e.type == 'Injury'
                                                      ? BasicListItem(
                                                          item: e.suggestion,
                                                          id: e.id,
                                                        )
                                                      : null,
                                                )
                                                .whereType<BasicListItem>()
                                                .toList(),
                                          );
                                          getIt<StateManager>().addItems(
                                            isRefresh: true,
                                            medicalDetails?.injury != null
                                                ? medicalDetails!.injury!
                                                      .map(
                                                        (e) => BasicListItem(
                                                          id: e.id,
                                                          item: e.injury,
                                                        ),
                                                      )
                                                      .toList()
                                                : [],
                                          );

                                          if (medSugges.suggestions != null) {
                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              useSafeArea: true,
                                              showDragHandle: true,
                                              backgroundColor: Colors.white,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DropDownListScreen(
                                                  maxWidth: maxWidth,
                                                  maxHeight: maxHeight,
                                                  //   lst:
                                                  // medSugges!.suggestions!.map((e)=>e.type=='Injury'?BasicListItem(item: e.suggestion,id: e.id):null).whereType<BasicListItem>().toList(),
                                                  //   selectedItems:medicalDetails?.injury!=null?medicalDetails!.injury!.map((e)=>BasicListItem(id: e.id,item: e.injury)).toList():[],
                                                  fn: (selectedItems) async {
                                                    var result = await getIt<ProfileManager>()
                                                        .updateMedicalInfo(
                                                          type: "injury",
                                                          items: selectedItems,
                                                          previousList:
                                                              medicalDetails
                                                                      ?.injury !=
                                                                  null
                                                              ? medicalDetails!
                                                                    .injury!
                                                                    .map(
                                                                      (
                                                                        e,
                                                                      ) => BasicListItem(
                                                                        id: e
                                                                            .id,
                                                                        item: e
                                                                            .injury,
                                                                      ),
                                                                    )
                                                                    .toList()
                                                              : [],
                                                        );
                                                    if (result.status == true) {
                                                      getIt<ProfileManager>()
                                                          .getProfileData();
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: "Something went wrong",
                                            );
                                          }
                                        },
                                      ),
                                      verticalSpace(18),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: Container(
                // width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Uri url = Uri.parse(
                      '${StringConstants.baseUrl}/delete-account/$userId',
                    );
                    launchInWebView(url);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                  child: Text(
                    'Delete Account',
                    style: t400_12.copyWith(color: Colors.red),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          },
        );
      },
    );
  }
}
