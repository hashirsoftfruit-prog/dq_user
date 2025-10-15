import 'package:dqapp/model/core/my_pets_list_model.dart';
import 'package:dqapp/view/screens/pet_care_screens/create_pet_screen.dart';
import 'package:dqapp/view/screens/pet_care_screens/pet_booking_screen_instant.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../booking_screens/find_doctors_screen.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import '../../../controller/managers/pets_manager.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';

class MyPetsListScreen extends StatefulWidget {
  final bool? isScheduledBooking;

  const MyPetsListScreen({super.key, this.isScheduledBooking});

  @override
  State<MyPetsListScreen> createState() => _MyPetsListScreenState();
}

class _MyPetsListScreenState extends State<MyPetsListScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key =
      GlobalKey<ScaffoldState>(); // Create a key

  @override
  void initState() {
    getIt<PetsManager>().getMyPetList();
    super.initState();
  }

  @override
  void dispose() {
    getIt<PetsManager>().myPetListDispose();
    super.dispose();
  }

  // void _checkConditionAndNavigate() async {
  //   var res = await getIt<PetsManager>().getMyPetList();
  //   if (res != null && res == false) {
  //     //checking the condition for navigating to pet creation screen
  //     Future.delayed(Duration.zero, () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const PetCreationScreen()),
  //       );
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // bool? locLoader = Provider.of<HomeManager>(context).locLoader;
    // String? selectedLocation = Provider.of<LocationManager>(context).selectedLocation;
    // List<String> latLongList = getIt<SharedPreferences>().getStringList(StringConstants.currentLatAndLong)??[];

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // String?  location =  selectedLocation ?? getIt<SharedPreferences>().getString(StringConstants.selectedLocation) ;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
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
                  appBar: AppBar(
                    toolbarHeight: 80,
                    leading: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    backgroundColor: const Color(0xffFFDDF2),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                    ),
                    elevation: 0,
                    title: Row(
                      children: [
                        Text(
                          "My pets",
                          style: t700_16.copyWith(color: Colors.black),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.pets, color: Color(0xffF950B8)),
                      ],
                    ),
                  ),
                  // appBar: getIt<SmallWidgets>().appBarWidget(
                  //     title: "My Pets",
                  //     height: h10p * 0.8,
                  //     width: w10p * 0.8,
                  //     fn: () {
                  //       Navigator.pop(context);
                  //     }),
                  body: Stack(
                    children: [
                      mgr.petListLoader == true
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: petLoader,
                            )
                          : mgr.myPetsListModel?.myPetsList != null &&
                                mgr.myPetsListModel!.myPetsList!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: w1p * 4,
                              ),
                              child: SizedBox(
                                child: Column(
                                  // Adjust aspect ratio for rectangular items
                                  children: [
                                    verticalSpace(h1p),
                                    ...mgr.myPetsListModel!.myPetsList!.map((
                                      item,
                                    ) {
                                      return InkWell(
                                        onTap: () {
                                          if (widget.isScheduledBooking ==
                                              true) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => FindDoctorsListScreen(
                                                  isPetDoctors: true,
                                                  specialityId: item
                                                      .veterinarySpecialityId!,
                                                  petId: item.petId,
                                                  subSpecialityIdForPsychology:
                                                      null,
                                                ),
                                              ),
                                            );
                                          } else if (widget
                                                  .isScheduledBooking ==
                                              false) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    PetInstantBookingScreen(
                                                      itemName: null,
                                                      subCatId: null,
                                                      specialityId: item
                                                          .veterinarySpecialityId!,
                                                      petId: item.petId,
                                                    ),
                                              ),
                                            );
                                          }
                                        },
                                        child: PetListItem(
                                          item: item,
                                          w1p: w1p,
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            )
                          : mgr.myPetsListModel?.myPetsList != null &&
                                mgr.myPetsListModel!.myPetsList!.isEmpty
                          ? Padding(
                              padding: EdgeInsets.only(top: h10p * 2),
                              child: Center(
                                child: Text(
                                  "Add your pet",
                                  style: TextStyles.notAvailableTxtStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24, right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () async {
                                  var res = await showModalBottomSheet(
                                    backgroundColor: Colors.blueGrey,
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    context: context,
                                    builder: (context) =>
                                        const PetCreationScreen(),
                                  );

                                  if (res != null) {
                                    await getIt<PetsManager>().getMyPetList();
                                  }
                                },
                                icon: const Icon(Icons.add, size: 20),
                                label: const Text("Add your pet"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B3EA8),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // floatingActionButton: FloatingActionButton(
                  //   child: const Text("Add Pet"),
                  //   onPressed: () async {
                  //     var res = await showModalBottomSheet(backgroundColor: Colors.blueGrey, isScrollControlled: true, useSafeArea: true, context: context, builder: (context) => const PetCreationScreen());

                  //     if (res != null) {
                  //       await getIt<PetsManager>().getMyPetList();
                  //     }
                  //   },
                  // ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class PetListItem extends StatelessWidget {
  final MyPetModel item;
  final double w1p;
  const PetListItem({super.key, required this.item, required this.w1p});

  @override
  Widget build(BuildContext context) {
    // double size = 80;
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
        // boxShadow: [boxShadow9]
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w1p * 4, vertical: 12),
        child: Row(
          children: [
            // Container(
            //   decoration: BoxDecoration(boxShadow: [boxShadow11], shape: BoxShape.circle),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(100),
            //     child: Stack(
            //       children: [
            //         SizedBox(
            //             width: size,
            //             height: size,
            //             child: CachedNetworkImage(
            //               fit: BoxFit.cover,
            //               // fit: widget.fit,
            //               imageUrl: '${StringConstants.baseUrl}${item.name}',
            //               placeholder: (context, url) => const SizedBox(),
            //               errorWidget: (context, url, error) => const SizedBox(),
            //             )),
            //         Container(
            //           height: size,
            //           width: size,
            //           decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.black54, Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.center)),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // horizontalSpace(12),
            Expanded(
              child: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name ?? "",
                      style: t700_20.copyWith(color: clr2D2D2D),
                    ),
                    Text(
                      '${item.breed ?? ""}(${item.pet ?? ""})',
                      style: t500_16.copyWith(color: Colors.black45),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${item.gender ?? ""}  ·  DOB: ${item.dateOfBirth ?? ""}',
                      style: t400_14.copyWith(color: Colors.black45),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
