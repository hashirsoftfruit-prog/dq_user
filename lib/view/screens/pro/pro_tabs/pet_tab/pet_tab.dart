import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/screens/pro/pro_home_vm.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../theme/constants.dart';
import '../../../../widgets/coming_soon_dialog.dart';
import '../../../forum_screens/ask_question_form_screen.dart';
import '../../../forum_screens/forum_details_screen.dart';
import '../../../forum_screens/forum_list_screens.dart';
import '../../../home_screen_widgets.dart';
import '../../../pet_care_screens/boarding_list_screen.dart';
import '../../../pet_care_screens/groomers_list_screen.dart';
import '../../../pet_care_screens/my_pets_list_screen.dart';
import 'widgets/pet_home_buttons.dart';
import 'widgets/pet_banners.dart';

class ProPetScreen extends StatefulWidget {
  const ProPetScreen({Key? key}) : super(key: key);

  @override
  State<ProPetScreen> createState() => _PetHomeScreenState();
}

class _PetHomeScreenState extends State<ProPetScreen> {
  // final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>(); // Create a key

  @override
  Widget build(BuildContext context) {
    // bool? locLoader = Provider.of<HomeManager>(context).locLoader;

    List<HMenuItems> menuIcons = [
      HMenuItems(
        title: "Consultation",
        img: "assets/images/pet_h_menu_consultaion.png",
      ),
      HMenuItems(
        title: "Grooming",
        img: "assets/images/pet_h_menu_grooming.png",
      ),
      HMenuItems(
        title: "Boarding",
        img: "assets/images/pet_h_menu_boarding.png",
      ),
      HMenuItems(title: "Foods", img: "assets/images/pet_h_menu_foods.png"),
      HMenuItems(
        title: "Medicine",
        img: "assets/images/pet_h_menu_medicine.png",
      ),
      HMenuItems(
        title: "Accessories",
        img: "assets/images/pet_h_menu_accessories.png",
      ),
    ];

    // Widget _buildButton({
    //   required String label,
    //   required IconData icon,
    //   required Color backgroundColor,
    //   required Color textColor,
    //   required Color iconColor,
    //   required Color borderColor,
    // }) {
    //   return Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    //     decoration: BoxDecoration(
    //       color: backgroundColor,
    //       borderRadius: BorderRadius.circular(16),
    //       border: Border.all(color: borderColor),
    //       boxShadow: const [
    //         BoxShadow(
    //           color: Colors.black12,
    //           blurRadius: 3,
    //           offset: Offset(0, 2),
    //         ),
    //       ],
    //     ),
    //     child: Row(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Text(label,
    //             style: TextStyle(
    //               color: textColor,
    //               fontWeight: FontWeight.bold,
    //             )),
    //         const SizedBox(width: 8),
    //         Icon(icon, size: 20, color: iconColor),
    //       ],
    //     ),
    //   );
    // }

    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarBrightness: Brightness.dark,
    //   statusBarColor: Colors.white,
    //   statusBarIconBrightness: Brightness.dark,
    // ));
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;
        return Consumer<ProHomeVm>(
          builder: (context, vm, child) {
            return ListView(
              padding: const EdgeInsets.only(top: 16),
              children: [
                // Container(
                //   decoration: BoxDecoration(color: Colors.white, boxShadow: [boxShadow5]),
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(horizontal: w1p * 5, vertical: h1p * 2),
                //     child: Row(
                //       children: [
                //         InkWell(
                //             highlightColor: Colors.transparent,
                //             splashColor: Colors.transparent,
                //             onTap: () {
                //               _key.currentState!.openDrawer();
                //             },
                //             child: Center(
                //                 child: SvgPicture.asset(
                //               "assets/images/home_icons/location.svg",
                //               height: 28,
                //               colorFilter: ColorFilter.mode(clr444444, BlendMode.srcIn), // clr444444,
                //             ))),
                //         horizontalSpace(w1p * 2),
                //         Consumer<LocationManager>(builder: (context, mgr, child) {
                //           return SizedBox(
                //               width: w10p * 4,
                //               child: locLoader == true
                //                   ? LoadingAnimationWidget.twoRotatingArc(color: const Color(0xffFFD166), size: 20)
                //                   : mgr.selectedLocation != null
                //                       ? Text(
                //                           mgr.selectedLocation!,
                //                           style: t400_14.copyWith(color: clr444444),
                //                           overflow: TextOverflow.ellipsis,
                //                         )
                //                       : getIt<SharedPreferences>().getString(StringConstants.selectedLocation) != null
                //                           ? Text(
                //                               getIt<SharedPreferences>().getString(StringConstants.selectedLocation) ?? "",
                //                               style: t400_14.copyWith(color: clr444444),
                //                               overflow: TextOverflow.ellipsis,
                //                             )
                //                           : Text(
                //                               AppLocalizations.of(context)!.chooseLocation,
                //                               style: t400_14.copyWith(color: clr444444),
                //                               overflow: TextOverflow.ellipsis,
                //                             ));
                //         })
                //       ],
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: w1p * 5, vertical: h1p * 1.5),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(
                //         children: [
                //           Text(
                //             AppLocalizations.of(context)!.welcome,
                //             style: t500_16.copyWith(
                //               color: clr444444,
                //             ),
                //           ),
                //           horizontalSpace(w1p),
                //           Text(
                //             getIt<SharedPreferences>().getString(StringConstants.userName) ?? "",
                //             style: t700_16.copyWith(color: const Color(0xffFF6F61)),
                //           ),
                //         ],
                //       ),
                //       Text(AppLocalizations.of(context)!.whatAreYouLookingFor, style: t500_18.copyWith(color: const Color(0xff676767))),
                //     ],
                //   ),
                // ),
                PetBanners(maxWidth: maxWidth),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        showComingSoonDialog(context);
                      },
                      child: PetHomeButtons(
                        label: "Bookings",
                        icon: Icons.calendar_month,
                        backgroundColor: const Color(0xFFE6FBFF), // light blue
                        iconColor: const Color(0xFF379BF2),
                        borderColor: const Color(0xFF379BF2).withOpacity(.5),
                        navigatorPage: const SizedBox(),
                      ),
                    ),
                    PetHomeButtons(
                      label: "My pets",
                      icon: Icons.pets,
                      backgroundColor: const Color(0xFFFFDDF2), // light pink
                      iconColor: const Color(0xFFF950B8),
                      borderColor: const Color(0xFFFF4EB8).withOpacity(.5),
                      navigatorPage: const MyPetsListScreen(),
                    ),

                    // PetHomeButtons(
                    //   buttonText: 'Bookings',
                    //   icon: Icons.calendar_month_rounded,
                    //   color: const Color(0xff00D5FF).withOpacity(0.4),
                    //   navigatePage: const HomeScreen(),
                    // ),
                    // PetHomeButtons(
                    //   buttonText: 'My Pets',
                    //   icon: Icons.pets_rounded,
                    //   color: const Color(0xffFF4EB8).withOpacity(0.4),
                    //   navigatePage: const HomeScreen(),
                    // ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: maxWidth * 0.1,
                    runSpacing: 8,
                    children: menuIcons.map((item) {
                      return InkWell(
                        onTap: () {
                          // showComingSoonDialog(context);
                          // if (item.title == "Consultation") {
                          //   Navigator.push(context, MaterialPageRoute(builder: (_) => const ConsutationModeChooseScreen()));
                          // } else
                          if (item.title == "Grooming") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GroomersListScreen(),
                              ),
                            );
                          } else if (item.title == "Boarding") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BoardersListScreen(),
                              ),
                            );
                          } else {
                            showComingSoonDialog(context);
                          }
                        },
                        child: HomeMenuItem(item),
                      );
                    }).toList(),
                  ),
                ),
                // child: SizedBox(
                //   child: GridView.count(
                //     shrinkWrap: true,
                //     crossAxisCount: 3, // 3 columns
                //     mainAxisSpacing: 0.0,
                //     crossAxisSpacing: 0.0,
                //     childAspectRatio: 1.2, // Adjust aspect ratio for rectangular items
                //     children: menuIcons.map((item) {
                //       return InkWell(
                //           onTap: () {
                //             if (item.title == "Consultation") {
                //               Navigator.push(context, MaterialPageRoute(builder: (_) => const ConsutationModeChooseScreen()));
                //             } else if (item.title == "Grooming") {
                //               Navigator.push(context, MaterialPageRoute(builder: (_) => const GroomersListScreen()));
                //             } else if (item.title == "Boarding") {
                //               Navigator.push(context, MaterialPageRoute(builder: (_) => const BoardersListScreen()));
                //             }
                //           },
                //           child: HomeMenuItem(item));
                //     }).toList(),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(left: w1p * 4, top: h1p * 2),
                //   child: Text(
                //     "Explore",
                //     style: t500_16.copyWith(
                //       color: clr444444,
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                //   child: SizedBox(
                //     height: 130,
                //     child: Stack(
                //       children: [
                //         Center(
                //           child: Container(
                //             width: maxWidth,
                //             height: 110,
                //             decoration: BoxDecoration(boxShadow: [boxShadow7], color: const Color(0xffF5EEDC), borderRadius: BorderRadius.circular(8)),
                //             child: Padding(
                //               padding: EdgeInsets.symmetric(horizontal: w1p * 4, vertical: 8),
                //               child: Column(
                //                 mainAxisSize: MainAxisSize.max,
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Text(
                //                     AppLocalizations.of(context)!.onlineVetConsultation,
                //                     style: t500_16.copyWith(color: clr444444),
                //                   ),
                //                   Text(
                //                     AppLocalizations.of(context)!.exclusiveOffers,
                //                     style: t500_14.copyWith(
                //                       color: clr444444,
                //                     ),
                //                   ),
                //                   BtnWidget(title: AppLocalizations.of(context)!.consultNow),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //         Align(
                //           alignment: Alignment.centerRight,
                //           child: SizedBox(
                //             child: Stack(alignment: Alignment.center, children: [
                //               const CircleWidget(
                //                 size: 90,
                //               ),
                //               SizedBox(height: 130, child: Image.asset("assets/images/pet-consult.png")),
                //               // Text("sdsd"),
                //             ]),
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                //   child: SizedBox(
                //     height: 130,
                //     child: Stack(
                //       children: [
                //         Center(
                //           child: Container(
                //             width: maxWidth,
                //             height: 110,
                //             decoration: BoxDecoration(boxShadow: [boxShadow7], color: const Color(0xffF5EEDC), borderRadius: BorderRadius.circular(8)),
                //             child: Padding(
                //               padding: EdgeInsets.symmetric(horizontal: w1p * 8, vertical: 8),
                //               child: Column(
                //                 mainAxisSize: MainAxisSize.max,
                //                 crossAxisAlignment: CrossAxisAlignment.end,
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Text(
                //                     AppLocalizations.of(context)!.petGrooming,
                //                     style: t500_18.copyWith(
                //                       color: const Color(0xffFF6F61),
                //                     ),
                //                   ),
                //                   Text(
                //                     AppLocalizations.of(context)!.exclusiveOffers,
                //                     style: t500_14.copyWith(
                //                       color: clr444444,
                //                     ),
                //                   ),
                //                   BtnWidget(title: AppLocalizations.of(context)!.schedule),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //         Align(
                //           alignment: Alignment.centerLeft,
                //           child: SizedBox(
                //             child: Stack(
                //               alignment: Alignment.center,
                //               children: [
                //                 const CircleWidget(
                //                   size: 90,
                //                 ),
                //                 SizedBox(height: 130, child: Image.asset("assets/images/pet-groom-dog.png")),
                //                 // Text("sdsd"),
                //               ],
                //             ),
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                verticalSpace(16),
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: const Size(double.infinity, 400),
                        painter: CurvedBackgroundPainter2(),
                      ),
                      CustomPaint(
                        size: const Size(double.infinity, 400),
                        painter: CurvedBackgroundPainter(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: w1p * 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                verticalSpace(18),
                                Text(
                                  AppLocalizations.of(context)!.areYouAPetLover,
                                  style: t700_16.copyWith(color: clr2D2D2D),
                                ),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.expertDoctorsPeopleAreHere,
                                  style: t400_14.copyWith(color: clr2D2D2D),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   width: maxWidth,
                          //   decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.fitWidth, image: AssetImage("assets/images/pet-head-image.png"))),
                          //   child: Padding(
                          //     padding: EdgeInsets.symmetric(horizontal: w1p * 5, vertical: 24),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         verticalSpace(18),
                          //         Text(
                          //           AppLocalizations.of(context)!.areYouAPetLover,
                          //           style: t700_16.copyWith(color: clr2D2D2D),
                          //         ),
                          //         Text(
                          //           AppLocalizations.of(context)!.expertDoctorsPeopleAreHere,
                          //           style: t400_14.copyWith(color: clr2D2D2D),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () async {
                              var res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AskFreeQuestionScreen(
                                    isVetinary: true,
                                  ),
                                ),
                              );
                              if (res != null) {
                                vm.getVetinaryForumList(isRefresh: true);
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: w1p * 5,
                                vertical: h1p * 3,
                              ),
                              decoration: BoxDecoration(
                                boxShadow: [boxShadow4],
                                color: const Color(0xffFFEDC9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0,
                                  vertical: 8,
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.askYourDoubts,
                                    style: t500_18.copyWith(color: clr2D2D2D),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // verticalSpace(h1p),
                          vm.publicForumVeterinaryListModel?.publicForums !=
                                  null
                              ? SizedBox(
                                  // height: 80,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ...vm
                                            .publicForumVeterinaryListModel!
                                            .publicForums!
                                            .take(9)
                                            .map((e) {
                                              var indx = vm
                                                  .publicForumVeterinaryListModel!
                                                  .publicForums!
                                                  .indexOf(e);
                                              return Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              ForumDetailsScreen(
                                                                forumId: e.id!,
                                                                isVetinary:
                                                                    true,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: ForumListItem(
                                                      w1p: w1p,
                                                      h1p: h1p,
                                                      index: indx,
                                                      pf: e,
                                                      isVetinary: true,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            })
                                            .toList(),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              vm.removeVetinaryForums();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const VetinaryForumListScreen(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 100,
                                              width: 100,
                                              decoration: const BoxDecoration(
                                                color: Colors.white12,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colours.lightGrey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          verticalSpace(12),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class HomeMenuItem extends StatelessWidget {
  final HMenuItems item;
  const HomeMenuItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    double size = 60;
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Image.asset(item.img!),
            // Stack(
            //   children: [
            //     Positioned(
            //         top: 0,
            //         right: 0,
            //         child: Container(
            //           height: size * 0.95,
            //           width: size * 0.95,
            //           decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xffFF6F61))),
            //         )),
            //     Positioned(
            //         bottom: 0,
            //         left: 0,
            //         child: Container(
            //           height: size * 0.95,
            //           width: size * 0.95,
            //           decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xffFFF1D1), boxShadow: [boxShadow7]),
            //           child: Image.asset(item.img!),
            //         )),
            //   ],
            // ),
          ),
          verticalSpace(4),
          Text(item.title ?? "", style: t500_12.copyWith(color: clr444444)),
        ],
      ),
    );
  }
}

class HMenuItems {
  String? title;
  String? img;

  HMenuItems({this.title, this.img});
}

class CircleWidget extends StatelessWidget {
  final double size;
  const CircleWidget({super.key, required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [boxShadow5b],
        gradient: const LinearGradient(
          colors: [Color(0xffFFD166), Color(0xffFFF0CC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        color: const Color(0xffFFD166),
      ),
    );
  }
}

class BtnWidget extends StatelessWidget {
  final String title;
  const BtnWidget({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: const Color(0xffFFAE00),
        boxShadow: [boxShadow7],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        child: Text(title, style: t500_14.copyWith(color: clr444444)),
      ),
    );
  }
}

class CurvedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFD166), Color(0xFFF68629)], // Customize colors
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.lineTo(0, size.height);
    // path.quadraticBezierTo(
    //   size.width * 0.2,
    //   size.height,
    //   size.width * 0.5,
    //   size.height * 0.85,
    // );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.6,
      size.width,
      0,
      // size.height * 0.8,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CurvedBackgroundPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color.fromARGB(255, 230, 163, 108),
          Color(0xFFF68629),
        ], // Customize colors
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.lineTo(size.width, 0);

    // path.quadraticBezierTo(
    //   size.width * 0.2,
    //   size.height,
    //   size.width * 0.5,
    //   size.height * 0.85,
    // );
    path.quadraticBezierTo(size.width, size.height, size.width, size.height);
    path.lineTo(0, size.height);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
