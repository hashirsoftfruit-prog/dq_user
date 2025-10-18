import 'package:dqapp/l10n/app_localizations.dart';
import 'package:dqapp/view/widgets/common_widgets.dart';
import 'package:dqapp/view/screens/search_results_screen.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:dqapp/view/theme/text_styles.dart';

import '../../model/helper/service_locator.dart';
import '../theme/constants.dart';

import 'councelling_therapy_screens/choose_consultation_type_screen.dart';

class SearchChooseScreen extends StatelessWidget {
  const SearchChooseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // fn({
    //   required int specialityId,
    //   required int? categoryId,
    //   required String specialityTitle,
    //   required int type,
    //   required int? subSpecialityId,
    // }){
    //
    //   Navigator.push(context, MaterialPageRoute(builder: (_)=>BookingLoadingScreen(categoryId:categoryId,specialityId: specialityId, specialityTitle:specialityTitle,typeOfPsychology: type,subspecialityId: subSpecialityId,)));
    //
    //
    // }

    var get = getIt<SmallWidgets>();

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: get.appBarWidget(
            title: "",
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                pad(
                  horizontal: w1p * 6,
                  vertical: h1p * 2,
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.chooseWhatAreYouSearchingFor,
                        style: t500_16.copyWith(color: clr444444),
                      ),
                    ],
                  ),
                ),
                BoxWidget(
                  color: const Color(0xffF68629),
                  h1p: h1p,
                  w1p: w1p,
                  indx: 0,
                  txt: AppLocalizations.of(context)!.scheduleBooking,
                  fn: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchResultScreen(
                          title: AppLocalizations.of(context)!.scheduleBooking,
                          type: 1,
                        ),
                      ),
                    );
                  },
                ),
                BoxWidget(
                  color: const Color(0xffBD6273),
                  fn: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchResultScreen(
                          title: AppLocalizations.of(
                            context,
                          )!.onlineConsultations,
                          type: 2,
                        ),
                      ),
                    );
                  },
                  h1p: h1p,
                  w1p: w1p,
                  indx: 0,
                  txt: AppLocalizations.of(context)!.onlineConsultations,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class BoxWidget  extends StatelessWidget {
//   double w1p;
//   double h1p;
//   String img;
//   int indx;
//   Function() fn;
//   String? txt;
//
//   BoxWidget({
//     required this.h1p,
//     required this.w1p,
//     required this.img,
//     required this.indx,
//     this.txt,
//     required this.fn,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return  Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: InkWell(onTap: fn,
//         child: Container(
//           width: w1p*90,height: 60,
//           decoration: BoxDecoration(color: Colors.white,
//           borderRadius: BorderRadius.circular(30)
//           ,boxShadow: [BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 2,
//             blurRadius: 2,
//             offset: const Offset(1, 1))]
//         ),
//         child:Stack(
//           children: [
//
//
//             Align(alignment: Alignment.centerRight,
//               child: ClipRRect(borderRadius: BorderRadius.circular(30),
//                 child: Container(width: w1p*52,height: 60,
//                   child: Image.asset(img,fit: BoxFit.cover,),
//
//                 ),
//               ),
//             ),
//             ClipRRect(borderRadius: BorderRadius.circular(30),
//
//               child: Container(color: Colors.white,width: w1p*55,height: 60,
//                 child: Center(child: Text(txt??"",style: TextStyles.textStyle12b,textAlign: TextAlign.center,)),
//               ),
//             ),
//           ],
//         ),
//
//                   ),
//       ),
//     );
//   }
// }
