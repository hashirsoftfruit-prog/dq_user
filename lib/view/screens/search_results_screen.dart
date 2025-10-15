import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:provider/provider.dart';
import '../../controller/managers/search_manager.dart';
import '../../model/core/search_results_model.dart';
import '../../model/helper/service_locator.dart';
import '../theme/constants.dart';
import 'booking_screens/booking_loading_screen.dart';
import 'booking_screens/booking_screen_widgets.dart';
import 'booking_screens/doctor_profile_screen.dart';
import 'booking_screens/find_doctors_screen.dart';
import 'location_drawer_screen.dart';

class SearchResultScreen extends StatefulWidget {
  final String title;
  final String? searchquery;
  final int type;
  const SearchResultScreen({
    super.key,
    required this.title,
    required this.type,
    this.searchquery,
  });

  @override
  State<SearchResultScreen> createState() => SearchResultScreenState();
}

class SearchResultScreenState extends State<SearchResultScreen> {
  @override
  void initState() {
    if (widget.searchquery != null && widget.searchquery!.isNotEmpty) {
      onSearchChanged(widget.searchquery!);
    }
    getIt<SearchManager>().refreshRecentSearches(null);
    super.initState();
  }

  @override
  void dispose() {
    getIt<SearchManager>().disposeSearch();
    super.dispose();
  }

  Timer? _debounce;

  TextEditingController keyCntrl = TextEditingController();

  void onSearchChanged(String query) {
    // if (_debounce?.isActive ?? false) _debounce!.cancel();
    // _debounce = Timer(const Duration(milliseconds: 500), () {
    // Make the API call here
    if (query.length > 2) {
      getIt<SearchManager>().searchApi(
        searchKey: query,
        consultType: widget.type,
      );
    } else {
      getIt<SearchManager>().searchResultsModel = null;
      if (mounted) setState(() {});
    }
    // });
  }

  final GlobalKey<ScaffoldState> _key =
      GlobalKey<ScaffoldState>(); // Create a key

  @override
  Widget build(BuildContext context) {
    const int specialityNType = 1;
    const int symptomsNType = 2;
    const int doctorNType = 3;
    const int clinicNType = 4;
    var get = getIt<SmallWidgets>();
    // double heightf =   Provider.of<StateManager>(context).heightF;
    getHead(String heading) {
      return pad(
        vertical: 8,
        child: Text(
          heading,
          style: t500_12.copyWith(color: const Color(0xff2e3192), height: 1),
        ),
      );
    }

    getSuggestionTxt(String txt) {
      return pad(
        vertical: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //   Text(txt,style: TextStyles.textStyle16,),
            // Divider(endIndent: 0,indent: 0,)
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colours.lightGrey, offset: Offset(1, 1)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  txt,
                  style: t500_14.copyWith(color: const Color(0xff818181)),
                ),
              ),
            ),
          ],
        ),
      );
    }

    fn({
      required int? specialityId,
      int? symptomId,
      int? docId,
      required int? categoryId,
      required String specialityTitle,
      required int type,
      required int? subSpecialityId,
    }) {
      final currentFocus = FocusScope.of(context);
      currentFocus.unfocus();

      getIt<SearchManager>().refreshRecentSearches(specialityTitle);

      switch (type) {
        case specialityNType:
          if (widget.type == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FindDoctorsListScreen(
                  specialityId: specialityId!,
                  subSpecialityIdForPsychology: null,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CheckIfDoctorAvailableScreen(
                  categoryId: categoryId,
                  specialityId: specialityId!,
                  specialityTitle: specialityTitle,
                  typeOfPsychology: type,
                  subspecialityId: subSpecialityId,
                ),
              ),
            );
          }
        case symptomsNType:
          if (widget.type == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FindDoctorsListScreen(
                  specialityId: specialityId ?? 0,
                  symptomId: symptomId,
                  subSpecialityIdForPsychology: null,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CheckIfDoctorAvailableScreen(
                  categoryId: categoryId,
                  specialityId: specialityId ?? 0,
                  symptomId: symptomId,
                  specialityTitle: specialityTitle,
                  typeOfPsychology: null,
                  subspecialityId: subSpecialityId,
                ),
              ),
            );
          }
        case doctorNType:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DoctorProfileScreen(
                // specialityId: widget.specialityId,
                specialityId: null,
                docId: docId!,
              ),
            ),
          );

        case clinicNType:
        // Navigator.push(context, MaterialPageRoute(builder: (_)=>BookingLoadingScreen(categoryId:categoryId,specialityId: specialityId, specialityTitle:specialityTitle,typeOfPsychology: type,subspecialityId: subSpecialityId,)));
      }
    }

    // List<Widget> lst = [
    //   "symptoms",
    //   "specialities",
    //   "doctors",
    //   "clinics",
    // ].map((item) => Row(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             Text(
    //               item,
    //               style: t500_14,
    //             ),
    //           ],
    //         ))
    //     .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return SafeArea(
          child: Consumer<SearchManager>(
            builder: (context, mgr, child) {
              SearchResultsModel data =
                  mgr.searchResultsModel ??
                  SearchResultsModel(
                    status: false,
                    speciality: [],
                    doctors: [],
                    clinics: [],
                    service: [],
                    symptom: [],
                  );
              // var popSpecialites ;

              return Scaffold(
                key: _key, // Assign the key to Scaffold.

                drawer: LocationDrawerScreen(w1p: w1p, h1p: h1p),
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.white,
                appBar: get.appBarWidget(
                  title: widget.title,
                  height: h10p,
                  width: w10p,
                  fn: () {
                    Navigator.pop(context);
                  },
                ),
                body: Entry(
                  xOffset: 800,
                  // scale: 20,
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.ease,
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            SearchBarWidget(
                              cntrolr: keyCntrl,
                              hnt: "Search symptoms, specialities, doctors",
                              isClinic: widget.type == 1 ? true : false,
                              searchFn: (val) {
                                if (_debounce?.isActive ?? false) {
                                  _debounce!.cancel();
                                }
                                _debounce = Timer(
                                  const Duration(milliseconds: 500),
                                  () {
                                    // Make the API call here
                                    onSearchChanged(val);
                                  },
                                );
                              },
                              locationFn: () {
                                // print("222222222");
                                _key.currentState?.openDrawer();
                              },
                            ),

                            // get.searchBarBox(title: "Search ${widget.title}", height: h10p, width: w10p,),
                            verticalSpace(h1p),

                            data.status == false &&
                                    mgr.searchSuggestions.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          getHead(
                                            AppLocalizations.of(
                                              context,
                                            )!.recentSearches,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              getIt<SearchManager>()
                                                  .clearRecentSearches();
                                            },
                                            child: getHead(
                                              AppLocalizations.of(
                                                context,
                                              )!.clear,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: mgr.searchSuggestions
                                            .map(
                                              (e) => InkWell(
                                                onTap: () {
                                                  keyCntrl.text = e;

                                                  getIt<SearchManager>()
                                                      .searchApi(
                                                        searchKey: e,
                                                        consultType:
                                                            widget.type,
                                                      );
                                                },
                                                child: getSuggestionTxt(e),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),

                            data.speciality!.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getHead(
                                        AppLocalizations.of(
                                          context,
                                        )!.specialities,
                                      ),
                                      SizedBox(
                                        width: maxWidth,
                                        child: Column(
                                          // semanticChildCount: 4,
                                          //   shrinkWrap: true,physics: NeverScrollableScrollPhysics(),gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 0.85,
                                          //   crossAxisCount: 4)
                                          //   // crossAxisCount: 4,
                                          //   ,
                                          children: List.generate(
                                            data.speciality!.length,
                                            (index) {
                                              String title =
                                                  data
                                                      .speciality?[index]
                                                      .title ??
                                                  "";
                                              String img =
                                                  data
                                                      .speciality?[index]
                                                      .image ??
                                                  "";
                                              int id =
                                                  data.speciality![index].id!;

                                              // var subtitel = popSpecialites.subcategory![index].title;
                                              return InkWell(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onTap: () async {
                                                  fn(
                                                    specialityId: id,
                                                    specialityTitle: title,
                                                    categoryId: null,
                                                    type: specialityNType,
                                                    subSpecialityId: null,
                                                  );
                                                },
                                                child: SearchResItem(
                                                  w1p: w1p,
                                                  h1p: h1p,
                                                  title: title,
                                                  img: img,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),

                            data.symptom!.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getHead(
                                        AppLocalizations.of(context)!.symptoms,
                                      ),
                                      SizedBox(
                                        width: maxWidth,
                                        child: Column(
                                          // semanticChildCount: 4,
                                          //   shrinkWrap: true,
                                          //   physics: NeverScrollableScrollPhysics(),
                                          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 0.85,
                                          // crossAxisCount: 3)
                                          // crossAxisCount: 4,
                                          children: List.generate(
                                            data.symptom!.length,
                                            (index) {
                                              String title =
                                                  data.symptom?[index].title ??
                                                  "";
                                              String img =
                                                  data.symptom?[index].image ??
                                                  "";
                                              int id = data.symptom![index].id!;

                                              // var subtitel = popSpecialites.subcategory![index].title;
                                              return InkWell(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onTap: () async {
                                                  fn(
                                                    specialityId: null,
                                                    symptomId: id,
                                                    specialityTitle: title,
                                                    categoryId: null,
                                                    type: symptomsNType,
                                                    subSpecialityId: null,
                                                  );
                                                },
                                                child: SearchResItem(
                                                  w1p: w1p,
                                                  h1p: h1p,
                                                  title: title,
                                                  img: img,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),

                            data.doctors!.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getHead(
                                        AppLocalizations.of(context)!.doctors,
                                      ),
                                      SizedBox(
                                        width: maxWidth,
                                        child: Column(
                                          // semanticChildCount: 4,
                                          //   shrinkWrap: true,
                                          //   physics: NeverScrollableScrollPhysics(),
                                          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 0.85,
                                          // crossAxisCount: 3)
                                          // crossAxisCount: 4,
                                          children: List.generate(
                                            data.doctors!.length,
                                            (index) {
                                              String name =
                                                  '${data.doctors?[index].firstName} ${data.doctors?[index].lastName}';
                                              String img =
                                                  data.doctors?[index].image ??
                                                  "";
                                              int id = data.doctors![index].id!;
                                              String type = data
                                                  .doctors![index]
                                                  .qualification!;
                                              String? experience =
                                                  data
                                                      .doctors![index]
                                                      .experience ??
                                                  '';

                                              // var subtitel = popSpecialites.subcategory![index].title;
                                              return InkWell(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onTap: () async {
                                                  fn(
                                                    specialityId: null,
                                                    specialityTitle: name,
                                                    categoryId: null,
                                                    type: doctorNType,
                                                    subSpecialityId: null,
                                                    docId: id,
                                                  );
                                                },
                                                child: DocItem(
                                                  w1p: w1p,
                                                  h1p: h1p,
                                                  img: img,
                                                  name: name,
                                                  type: type,
                                                  experience: experience,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            data.clinics!.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getHead(
                                        AppLocalizations.of(context)!.clinics,
                                      ),
                                      SizedBox(
                                        width: maxWidth,
                                        child: Column(
                                          // semanticChildCount: 4,
                                          //   shrinkWrap: true,
                                          //   physics: NeverScrollableScrollPhysics(),
                                          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 0.85,
                                          // crossAxisCount: 3)
                                          // crossAxisCount: 4,
                                          children: List.generate(
                                            data.clinics!.length,
                                            (index) {
                                              // var subtitel = popSpecialites.subcategory![index].title;
                                              return InkWell(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onTap: () async {
                                                  fn(
                                                    specialityId: null,
                                                    specialityTitle: '',
                                                    categoryId: null,
                                                    type: clinicNType,
                                                    subSpecialityId: null,
                                                  );
                                                },
                                                child: ClinicItem(
                                                  w1p: w1p,
                                                  h1p: h1p,
                                                  clinic: data.clinics![index],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
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

class DocItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String name;
  final String img;
  final String experience;
  final String type;
  const DocItem({
    super.key,
    required this.w1p,
    required this.h1p,
    required this.img,
    required this.name,
    required this.experience,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    String docExperience = experience;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // gradient: linearGrad3
        color: Colours.lightGrey,
      ),
      child: pad(
        horizontal: w1p * 3,
        vertical: h1p,
        child: Column(
          children: [
            Row(
              children: [
                // horizontal: w1p*2.5,
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            containerRadius - 1,
                          ),
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
                    Positioned(
                      left: -2,
                      top: -2,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SizedBox(
                          width: 25,
                          child: Image.asset(
                            "assets/images/home_icons/slice-border.png",
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                horizontalSpace(w1p * 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(name, style: TextStyles.textStyle3c),
                      Text(
                        '$type | $docExperience',
                        style: t500_12.copyWith(color: clr2D2D2D),
                      ),
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
          ],
        ),
      ),
    );
  }
}

class ClinicItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final Clinics clinic;
  const ClinicItem({
    super.key,
    required this.w1p,
    required this.h1p,
    required this.clinic,
  });

  @override
  Widget build(BuildContext context) {
    var grad3 = const RadialGradient(
      colors: [Color(0xffFFFFFF), Color(0xffdedddd)],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colours.lightGrey,
          // gradient: linearGrad3
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: h1p),
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
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/placeholder-hospital.png',
                      fit: BoxFit.fitHeight,
                    ),
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
                      clinic.name ?? "",
                      style: t700_14.copyWith(color: clr444444, height: 1.1),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${clinic.address1}, ${clinic.address2}, ${clinic.city}',
                      style: t500_12.copyWith(color: clr2D2D2D, height: 1.1),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              horizontalSpace(w1p * 2),
              clinic.latitude != null && clinic.longitude != null
                  ? GestureDetector(
                      onTap: () {
                        // openMap(double.parse(e.latitude!),double.parse(e.longitude!));
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
  }
}
