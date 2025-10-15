import 'package:dqapp/l10n/app_localizations.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../controller/managers/category_manager.dart';
import '../../../../model/core/specialities_response_model.dart';
import '../../../../model/helper/service_locator.dart';
import '../../../theme/constants.dart';
import '../../../theme/text_styles.dart';
import '../../booking_screens/booking_loading_screen.dart';
import '../../home_screen_widgets.dart';
import '../../view_all_specialities_categories_screen.dart';

class SpecialityListImages extends StatelessWidget {
  final List<SpecialityList> specialityList;
  final double w1p;
  const SpecialityListImages({
    super.key,
    required this.specialityList,
    required this.w1p,
  });

  @override
  Widget build(BuildContext context) {
    String username =
        getIt<SharedPreferences>().getString(StringConstants.userName) ?? "";
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
            specialityTitle: specialityTitle,
          ),
        ),
      );
    }

    return Column(
      children: [
        verticalSpace(12),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: w1p * 5),
          child: Row(
            children: [
              SizedBox(
                child: Text(
                  "Hi ${username.length > 10 ? "${username.substring(0, 6)}..${username.substring(username.length - 2, username.length)}" : username}, how can we make your day better?",
                  style: t400_12.copyWith(color: clr2D2D2D),
                ),
              ),
              horizontalSpace(8),
              Expanded(child: Container(child: divider())),
            ],
          ),
        ),
        Entry(
          yOffset: -20,
          duration: const Duration(milliseconds: 700),
          delay: const Duration(milliseconds: 50),
          curve: Curves.ease,
          child: Builder(
            builder: (context) {
              // List<SpecialityList> sList = vm.specialities?.specialityList ?? [];
              List<SpecialityList> sList = specialityList;
              int noOfSpecialites = specialityList.length;
              double specialitySize = 90;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: w1p * 0),
                child: SizedBox(
                  height: specialitySize + 35,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: sList.isNotEmpty
                          ? sList.map((e) {
                              var i = sList.indexOf(e);

                              return // pad(horizontal: w1p*0.1,
                              i <= 6
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        left: i == 0 ? w1p * 4 : w1p * 2,
                                        right: i == 6 ? w1p * 4 : 0,
                                      ),
                                      child: hW.specialityBox(
                                        context: context,
                                        isRedacted: false,
                                        size: specialitySize,
                                        count: noOfSpecialites,
                                        index: i,
                                        w1p: w1p,
                                        title: sList[i].title ?? "",
                                        img: sList[i].image ?? "",
                                        onClick: () async {
                                          if (i != 6) {
                                            int id = sList[i].id!;
                                            String title = sList[i].title!;

                                            fn(
                                              specialityTitle: title,
                                              specialityId: id,
                                              categoryId: null,
                                            );
                                          } else {
                                            getIt<CategoryMgr>()
                                                .setViewAllScreenitems(
                                                  specialityList,
                                                );
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ViewAllScreen(
                                                  title: AppLocalizations.of(
                                                    context,
                                                  )!.specialities,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    )
                                  : const SizedBox();
                            }).toList()
                          : [
                              for (int i = 0; i < 6; i++)
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: i == 0 ? w1p * 4 : w1p * 2,
                                    right: i == 6 ? w1p * 4 : 0,
                                  ),
                                  child: hW.specialityBox(
                                    context: context,
                                    isRedacted: true,
                                    size: specialitySize,
                                    count: 6,
                                    index: i,
                                    w1p: w1p,
                                    title: "Redacted",
                                    img: "Redacted",
                                    onClick: () async {},
                                  ),
                                ),
                            ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
