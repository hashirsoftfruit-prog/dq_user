import 'package:flutter/material.dart';

import '../../../../../../model/core/symptoms_and_issues_list_model.dart';
import '../../../../../theme/constants.dart';
import '../../../../../theme/text_styles.dart';
import '../../../../booking_screens/booking_loading_screen.dart';
import '../../../../home_screen_widgets.dart';
import '../../../pro_home_vm.dart';

class SymptomListImages extends StatelessWidget {
  final ProHomeVm vm;
  final double maxWidth;
  final double w1p;
  final double w10p;
  final double h1p;

  const SymptomListImages(
      {super.key,
      required this.vm,
      required this.maxWidth,
      required this.w1p,
      required this.w10p,
      required this.h1p});

  @override
  Widget build(BuildContext context) {
    var hW = HomeWidgets();
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
                  specialityTitle: specialityTitle)));
    }

    return pad(
      vertical: h1p * .2,
      child: Builder(builder: (context) {
        // MentalWellness? mwell;
        Symptoms? symptoms;
        // List<Subcategory>? mwellList;
        List<Subcategory> symptomsList = [];

        if (vm.symptomsAndIssues != null) {
          SymptomsAndIssuesModel data = vm.symptomsAndIssues!;
          symptoms = data.symptoms;
          symptomsList = symptoms?.subcategory ?? [];
        }

        // NOT FEELING WELL SECTION

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vm.symptomsAndIssues != null && symptoms != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8, horizontal: w1p * 5),
                        child: Row(
                          children: [
                            SizedBox(
                                width: w10p * 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        symptoms.title ?? '',
                                        style: t700_16.copyWith(
                                            color: clr2D2D2D, height: 1.1),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    verticalSpace(4),
                                    Text(
                                      symptoms.subtitle ?? '',
                                      style: t400_12.copyWith(
                                          color: clr2D2D2D, height: 1.1),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )),
                            horizontalSpace(8),
                            Expanded(child: Container(child: divider())),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: maxWidth,
                          height: 118,
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            // controller:scCntrol ,

                            scrollDirection: Axis.horizontal,
                            children: symptomsList.map((symptom) {
                              var i = symptomsList.indexOf(symptom);
                              // print('symptoms : ${symptomsList.map((e) => e.toJson()).toList()}');

                              return hW.symptomsItem(
                                  index: i,
                                  img: symptom.icon ?? '',
                                  title: symptom.title ?? '',
                                  w1p: w1p,
                                  onClick: () async {
                                    int specialityId = symptom.speciality!;
                                    int subcatId = symptom.speciality!;

                                    fn(
                                        specialityId: specialityId,
                                        specialityTitle: symptom.title ?? "",
                                        categoryId: subcatId);
                                  });
                            }).toList(),
                          )),
                      verticalSpace(12)
                    ],
                  )
                : const SizedBox(),
          ],
        );
      }),
    );
  }
}
