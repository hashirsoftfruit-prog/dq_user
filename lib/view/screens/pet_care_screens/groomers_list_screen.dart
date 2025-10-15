import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqapp/controller/managers/home_manager.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:dqapp/view/screens/location_drawer_screen.dart';
import 'package:entry/entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import '../../../controller/managers/location_manager.dart';
import '../../../controller/managers/pets_manager.dart';
import '../../../model/core/pet_groomers_list_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import 'groomer_details_screen.dart';

class GroomersListScreen extends StatefulWidget {
  const GroomersListScreen({Key? key}) : super(key: key);

  @override
  State<GroomersListScreen> createState() => _GroomersListScreenState();
}

class _GroomersListScreenState extends State<GroomersListScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key =
      GlobalKey<ScaffoldState>(); // Create a key

  @override
  void initState() {
    getIt<PetsManager>().getPetGroomersList();
    super.initState();
  }

  @override
  void dispose() {
    getIt<PetsManager>().groomersListDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool? locLoader = Provider.of<HomeManager>(context).locLoader;
    String? selectedLocation = Provider.of<LocationManager>(
      context,
    ).selectedLocation;
    List<String> latLongList =
        getIt<SharedPreferences>().getStringList(
          StringConstants.currentLatAndLong,
        ) ??
        [];

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    String? location =
        selectedLocation ??
        getIt<SharedPreferences>().getString(StringConstants.selectedLocation);

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;
        return Consumer<PetsManager>(
          builder: (context, mgr, child) {
            return SafeArea(
              child: Entry(
                xOffset: 100,
                // angle: 3.1415,
                delay: const Duration(milliseconds: 0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear,

                child: Scaffold(
                  key: _key,
                  // extendBody: true,
                  backgroundColor: Colors.white,
                  appBar: getIt<SmallWidgets>().appBarWidget(
                    title: "",
                    height: h10p * 0.8,
                    width: w10p * 0.8,
                    fn: () {
                      Navigator.pop(context);
                    },
                    trailWidget: locLoader == true
                        ? LoadingAnimationWidget.twoRotatingArc(
                            color: Colours.lightGrey,
                            size: 20,
                          )
                        : InkWell(
                            onTap: () async {
                              await showModalBottomSheet(
                                backgroundColor: Colors.blueGrey,
                                isScrollControlled: true,
                                useSafeArea: true,
                                context: context,
                                builder: (context) =>
                                    LocationDrawerScreen(w1p: w1p, h1p: h1p),
                              );

                              getIt<PetsManager>().getPetGroomersList();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.5,
                                  color: Colours.boxblue,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.location_solid,
                                      color: Colours.boxblue,
                                    ),
                                    SizedBox(
                                      width: w10p * 4,
                                      child: Text(
                                        location ?? "",
                                        style: t500_12.copyWith(
                                          color: clr444444,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                  body: ListView(
                    children: [
                      latLongList.isEmpty && mgr.petGroomers == null
                          ? InkWell(
                              onTap: () {
                                _key.currentState!.openDrawer();
                              },
                              child: const Text("Location unavailable"),
                            )
                          :
                            //
                            // Padding(
                            //   padding:  EdgeInsets.symmetric(horizontal: w1p*4),
                            //   child: Row(
                            //     children: [
                            //       Text("Groomers in ",style: TextStyles.petTxt15,),
                            //       Text(location ?? '',style: TextStyles.petTxt14,),
                            //     ],
                            //   ),
                            // ),
                            // Padding(
                            //     padding:  EdgeInsets.symmetric(horizontal: w1p*4),
                            //     child: Text(,style: TextStyles.petTxt6,)),
                            mgr.listLoader == true
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: petLoader,
                            )
                          : mgr.petGroomers != null &&
                                mgr.petGroomers!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: w1p * 4,
                              ),
                              child: SizedBox(
                                child: Column(
                                  // Adjust aspect ratio for rectangular items
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Groomers Nearby",
                                          style: t400_18.copyWith(
                                            color: const Color(0xff676767),
                                          ),
                                        ),
                                      ],
                                    ),
                                    verticalSpace(h1p),
                                    ...mgr.petGroomers!.map((item) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  GroomerDetailsScreen(
                                                    groomerId: item.id!,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: GroomerListItem(
                                          item: item,
                                          w1p: w1p,
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            )
                          : mgr.petGroomers != null && mgr.petGroomers!.isEmpty
                          ? Padding(
                              padding: EdgeInsets.only(top: h10p * 2),
                              child: Center(
                                child: Text(
                                  "No Groomers available in your location",
                                  style: TextStyles.notAvailableTxtStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class GroomerListItem extends StatelessWidget {
  final PetGroomer item;
  final double w1p;
  const GroomerListItem({super.key, required this.item, required this.w1p});

  @override
  Widget build(BuildContext context) {
    Widget cachedImg(String img) {
      return CachedNetworkImage(
        fit: BoxFit.cover,
        // fit: widget.fit,
        imageUrl: StringConstants.baseUrl + img,
        placeholder: (context, url) => Opacity(
          opacity: 0.5,
          child: Image.asset("assets/images/pet-dog-icon-placeholder-temp.png"),
        ),
        errorWidget: (context, url, error) =>
            Image.asset("assets/images/pet-dog-icon-placeholder-temp.png"),
      );
    }

    BoxDecoration bxDec = BoxDecoration(
      color: Colours.lightBlu,
      borderRadius: BorderRadius.circular(10),
    );

    double size = 80;
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [boxShadow9],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w1p * 4, vertical: 12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [boxShadow11],
                shape: BoxShape.circle,
              ),

              // width: size,height: size,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Stack(
                  children: [
                    SizedBox(
                      width: size,
                      height: size,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        // fit: widget.fit,
                        imageUrl: '${StringConstants.baseUrl}${item.logo}',
                        placeholder: (context, url) => const SizedBox(),
                        errorWidget: (context, url, error) => const SizedBox(),
                      ),
                    ),
                    // Container(
                    //   // width: 50,height: 50,
                    //   // height: size,width: size ,
                    //   decoration:BoxDecoration(image: DecorationImage(image: NetworkImage())
                    // //       border: Border.all(
                    // //   color: Color(0xffFF6F61)
                    // //
                    // // )
                    //   ),child: Image.network(,fit: BoxFit.fitWidth,),
                    //  ),
                    Container(
                      height: size,
                      width: size,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black54, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name ?? "",
                      style: t500_16.copyWith(color: clr444444),
                    ),
                    Text(
                      item.address1 ?? item.address2 ?? "",
                      style: t400_12.copyWith(color: clr444444),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SingleChildScrollView(
                        child: Row(
                          children: item.groomingPets!.map((e) {
                            return SizedBox(
                              height: 20,
                              child: cachedImg(e.petIcon ?? ""),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: bxDec,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: SvgPicture.asset(
                                    "assets/images/icon-time-yellow.svg",
                                  ),
                                ),
                                Text(
                                  "10.00 AM to 5.00 PM",
                                  style: t500_12.copyWith(
                                    color: clr444444,
                                    fontFamily: "Montserrat",
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        horizontalSpace(w1p),
                        Container(
                          decoration: bxDec,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: SvgPicture.asset(
                              "assets/images/icon-map-yellow.svg",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
