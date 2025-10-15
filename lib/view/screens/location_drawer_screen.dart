import 'package:dqapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/managers/booking_manager.dart';
import '../../controller/managers/home_manager.dart';
import '../../controller/managers/location_manager.dart';
import '../../model/helper/service_locator.dart';
import '../theme/constants.dart';
import 'home_screen_widgets.dart';
import '../widgets/common_widgets.dart';

class LocationDrawerScreen extends StatefulWidget {
  final double w1p;
  final double h1p;
  final int? specialityId;
  final int? symptomId;
  // String img;
  const LocationDrawerScreen({
    super.key,
    required this.h1p,
    required this.w1p,
    this.specialityId,
    this.symptomId,
    // required this.img,
  });

  @override
  State<LocationDrawerScreen> createState() => _LocationDrawerScreenState();
}

class _LocationDrawerScreenState extends State<LocationDrawerScreen> {
  var cntrlr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationManager>(
      builder: (context, mgr, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: getIt<SmallWidgets>().appBarWidget(
            title: AppLocalizations.of(context)!.selectYourLocation,
            height: widget.h1p * 10,
            width: widget.w1p * 10,
            fn: () {
              Navigator.pop(context);
            },
          ),
          body: Container(
            height: widget.h1p * 100,
            width: widget.w1p * 100,
            color: Colors.white,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                pad(
                  horizontal: widget.w1p * 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpace(widget.h1p * 2),
                      TextFormField(
                        controller: cntrlr,
                        onChanged: (val) async {
                          // if(mgr.searchLoader!=true){
                          if (val.length > 2) {
                            await getIt<LocationManager>().getLocationByName(
                              val,
                            );
                          } else if (val.trim().isEmpty) {
                            getIt<LocationManager>().clearSearches();
                          }
                        },
                        scrollPadding: EdgeInsets.zero,
                        // keyboardType: TextInputType.number,
                        decoration: inputDec3(
                          hnt: AppLocalizations.of(context)!.searchLocation,
                        ),
                        // controller: phNoCntroller,
                      ),

                      verticalSpace(widget.h1p * 1.5),
                      Visibility(
                        visible:
                            MediaQuery.of(context).viewInsets.bottom == 0.0,
                        child: pad(
                          vertical: widget.h1p,
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async {
                              Navigator.pop(context);
                              getIt<HomeManager>().locationLoaderCntrl();

                              var result = await getIt<LocationManager>()
                                  .getLocation();
                              if (result == true) {
                                List<String>? latAndLong =
                                    getIt<SharedPreferences>().getStringList(
                                      StringConstants.currentLatAndLong,
                                    );
                                getIt<BookingManager>().getDoctorList(
                                  specialityId: widget.specialityId ?? 0,

                                  symptomId: widget.symptomId,
                                  latitude: latAndLong?[0],
                                  longitude: latAndLong?[1],
                                );

                                // print("result");
                              }
                              getIt<HomeManager>().locationLoaderCntrl();
                            },
                            child: const MyLocationWidget(),
                          ),
                        ),
                      ),

                      // Text(mgr.selectedLocation,style: TextStyles.textStyle12),
                      verticalSpace(widget.h1p * 1.5),
                      mgr.searchLoader
                          ? Center(
                              child: LoadingAnimationWidget.fallingDot(
                                color: Colours.primaryblue,
                                size: 50,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: mgr.items
                                  .map(
                                    (e) => InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        getIt<LocationManager>()
                                            .clearSearches();
                                        getIt<LocationManager>()
                                            .setSelectedLocation(
                                              placeName: e.title ?? "",
                                              latitude: e.position!.lat ?? 0.0,
                                              longitude: e.position!.lng ?? 0.0,
                                            );
                                        getIt<LocationManager>().changeLoc(
                                          e.title ?? "",
                                        );
                                        FocusScopeNode currentFocus =
                                            FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        cntrlr.clear();
                                        List<String>?
                                        latAndLong = getIt<SharedPreferences>()
                                            .getStringList(
                                              StringConstants.currentLatAndLong,
                                            );
                                        getIt<BookingManager>().getDoctorList(
                                          specialityId:
                                              widget.specialityId ?? 0,
                                          symptomId: widget.symptomId,
                                          latitude: latAndLong?[0],
                                          longitude: latAndLong?[1],
                                        );

                                        // getIt<HomeManager>().getNearClinics(lat: e.position!.lat ?? 0.0, long: e.position!.lng ?? 0.0, state: e.address?.state, country: e.address?.countryName, locality: e.address?.city);
                                        Navigator.pop(context);
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.title ?? "",
                                            style: t500_14.copyWith(
                                              color: const Color(0xff818181),
                                            ),
                                          ),
                                          const Divider(color: Colours.boxblue),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),

                      verticalSpace(widget.h1p * 1.5),
                      mgr.popularCitiesList != null &&
                              mgr.popularCitiesList!.isNotEmpty
                          ? Text(
                              AppLocalizations.of(context)!.popularCities,
                              style: t500_14.copyWith(color: clr444444),
                            )
                          : const SizedBox(),
                      verticalSpace(widget.h1p),
                      verticalSpace(widget.h1p * 0.5),

                      mgr.popularCitiesList != null &&
                              mgr.popularCitiesList!.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: mgr.popularCitiesList!
                                  .map(
                                    (e) => InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        getIt<LocationManager>()
                                            .setSelectedLocation(
                                              placeName: e.city ?? "",
                                              latitude: double.parse(
                                                e.latitude!,
                                              ),
                                              longitude: double.parse(
                                                e.longitude!,
                                              ),
                                            );
                                        getIt<LocationManager>().changeLoc(
                                          e.city ?? "",
                                        );
                                        getIt<BookingManager>().getDoctorList(
                                          specialityId:
                                              widget.specialityId ?? 0,
                                          symptomId: widget.symptomId,
                                          latitude: e.latitude!,
                                          longitude: e.longitude!,
                                        );
                                        // getIt<HomeManager>().getNearClinics(lat: double.parse(e.latitude!), long: double.parse(e.longitude!), locality: e.city ?? "");
                                        Navigator.pop(context);
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.city ?? "",
                                            style: t500_14.copyWith(
                                              color: const Color(0xff818181),
                                            ),
                                          ),
                                          const Divider(
                                            color: Colours.couponBgClr,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
