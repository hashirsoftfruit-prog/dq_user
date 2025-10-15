import 'package:dqapp/controller/managers/category_manager.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/core/specialities_response_model.dart';
import '../../model/helper/service_locator.dart';
import '../theme/constants.dart';

import 'booking_screens/booking_loading_screen.dart';

class ViewAllScreen extends StatefulWidget {
  final String title;
  const ViewAllScreen({super.key, required this.title});

  @override
  State<ViewAllScreen> createState() => ViewAllScreenState();
}

class ViewAllScreenState extends State<ViewAllScreen> {
  @override
  Widget build(BuildContext context) {
    fn({
      required int specialityId,
      required int? categoryId,
      required String specialityTitle,
    }) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CheckIfDoctorAvailableScreen(
            categoryId: categoryId,
            specialityId: specialityId,
            specialityTitle: specialityTitle,
          ),
        ),
      );
    }

    // fn({
    //   required int specialityId,
    //   required String specialityTitle,
    // })async{
    //   var result = await getIt<BookingManager>().getDocsList(specialityId: specialityId);
    //   if(result.status==true&&result.doctors!.isNotEmpty) {
    //     getIt<BookingManager>().setDocsData(result);
    //
    //     Navigator.push(context, MaterialPageRoute(builder: (_)=>BookingScreen(subCatId:null,specialityId: specialityId,itemName: specialityTitle,pkgAvailability:result.packageAvailability, )));
    //
    //   }else{
    //
    //     showTopSnackBar(
    //         Overlay.of(context),
    //         ErrorToast(
    //           message:
    //           result.message??"",
    //         ));
    //   }
    // }
    var get = getIt<SmallWidgets>();
    // double heightf =   Provider.of<StateManager>(context).heightF;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return Consumer<CategoryMgr>(
          builder: (context, mgr, child) {
            List<SpecialityList>? specialityViewAllModel =
                mgr.specialityViewList;
            return Scaffold(
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
                          get.searchBarBox(
                            title: "Search ${widget.title}",
                            height: h10p,
                            width: w10p,
                            visibility: true,
                            onchangedFn: (value) => mgr.searchSpeciality(value),
                          ),
                          verticalSpace(h1p),
                          verticalSpace(h1p * 0.5),
                          SizedBox(
                            width: maxWidth,
                            child: GridView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                              // crossAxisCount: 4,
                              children: List.generate(
                                specialityViewAllModel!.length,
                                (index) {
                                  String title =
                                      specialityViewAllModel[index].title ?? "";
                                  String img =
                                      specialityViewAllModel[index].image ?? "";
                                  int id = specialityViewAllModel[index].id!;

                                  // var subtitel = popSpecialites.subcategory![index].title;
                                  return CategoryItem(
                                    onClick: () async {
                                      fn(
                                        specialityId: id,
                                        specialityTitle: title,
                                        categoryId: null,
                                      );
                                    },
                                    w1p: w1p,
                                    h1p: h1p,
                                    title: title,
                                    img: img,
                                  );
                                },
                              ),
                            ),
                          ),
                          verticalSpace(h1p),
                          verticalSpace(h1p),
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
        );
      },
    );
  }
}

// class LeftCornerClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(size.width, 0.0);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0.0, size.height);
//     path.lineTo(0.0, size.height - 50.0); // Adjust the curve position
//     path.quadraticBezierTo(0.0, size.height - 50.0, 50.0, size.height - 100.0); // Adjust control points to modify curve
//     path.lineTo(0.0, 0.0); // Returning back to initial point closes the path
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }
