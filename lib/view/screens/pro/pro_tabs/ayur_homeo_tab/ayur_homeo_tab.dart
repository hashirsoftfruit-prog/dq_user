import 'package:dqapp/model/core/symptoms_and_issues_list_model.dart';
import 'package:dqapp/model/core/top_doctors_response_model.dart';
import 'package:dqapp/view/screens/pro/pro_home_vm.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/core/specialities_response_model.dart';
import '../../pro_widgets/small_widgets.dart';
import '../../pro_widgets/speciality_list_images.dart';
import '../../pro_widgets/top_doctors_section.dart';

class ProAyurHomeoTab extends StatelessWidget {
  final bool isAyurvedic;
  const ProAyurHomeoTab({super.key, required this.isAyurvedic});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        double w1p = maxWidth * 0.01;
        // double w10p = maxWidth * 0.1;

        return Consumer<ProHomeVm>(
          builder: (context, vm, _) {
            AyurvedicOrHomeo? ayurvedicOrHomeoSpecialities = isAyurvedic
                ? vm.symptomsAndIssues!.ayurvedic
                : vm.symptomsAndIssues!.homeopathy;
            List<SpecialityList>? ayurOrHomeoList = ayurvedicOrHomeoSpecialities
                ?.subcategory!
                .map(
                  (e) => SpecialityList(
                    id: e.speciality,
                    title: e.title,
                    subtitle: e.subtitle,
                    image: e.icon,
                  ),
                )
                .toList();
            List<TopDoctors>? topDoctors = isAyurvedic
                ? vm.topDoctorsResponseModel?.ayurvedaDoctors!
                : vm.topDoctorsResponseModel?.homeopathyDoctors!;
            return RefreshIndicator(
              onRefresh: () => vm.getConsultationFns(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TabConsultBanner(
                      bgImage:
                          'assets/images/tab_${isAyurvedic ? 'ayurveda' : 'homeo'}_banner_img.png',
                      title: isAyurvedic
                          ? 'Reconnect with Nature.\nRejuvenate with Ayurveda.'
                          : 'Gentle Healing.\nPowerful Results.',
                      titleColor: isAyurvedic
                          ? clrFFFFFF
                          : const Color(0xffFF7D4C),
                      subtitle: isAyurvedic
                          ? 'Ancient Wisdom • Natural Healing\n• Lasting Wellness'
                          : 'Homeopathy — Natural, Safe,\nand Holistic Care for All Ages',
                      subtitleColor: isAyurvedic
                          ? clrFFFFFF
                          : const Color(0xff618943),
                      h1p: h1p,
                      w1p: w1p,
                      maxWidth: maxWidth,
                    ),
                    verticalSpace(h1p * 2),
                    // SymptomListImages(vm: vm, maxWidth: maxWidth, w10p: w10p, w1p: w1p, h1p: h1p),
                    // const ConsultationCards(),
                    // verticalSpace(h1p * 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BookContainer(
                            image:
                                'assets/images/pro_${isAyurvedic ? 'ayurveda' : 'homeo'}_instant_card_img.png',
                            title: 'Instant\nConsultation',
                            subtitle1: 'Connect\nwithin',
                            subtitle2: '30 Sec',
                            width: maxWidth * .46,
                            color: isAyurvedic
                                ? const Color(0xff00C165)
                                : const Color(0xffEFC427),
                            gradient: [
                              isAyurvedic
                                  ? const Color(0xff4DFBA7)
                                  : const Color(0xffFFEA9C),
                              clrFFFFFF,
                            ],
                            isOnline: false,
                            isFitImage: true,
                            ayurOrHomeoList: ayurOrHomeoList,
                            // onTap: () {
                            //   if (ayurOrHomeoList != null && ayurOrHomeoList.isNotEmpty) {
                            //     List<SpecialityList>? lst = ayurOrHomeoList.map((e) => SpecialityList(id: e.id, title: e.title, subtitle: e.subtitle, image: e.image)).toList();
                            //     getIt<CategoryMgr>().setViewAllScreenitems(lst);
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (_) => ViewAllScreen(
                            //                   title: ayurvedicOrHomeoSpecialities!.title ?? "",
                            //                 )));
                            //   } else {
                            //     showTopSnackBar(
                            //         Overlay.of(context),
                            //         const ErrorToast(
                            //           message: "No data found",
                            //         ));
                            //   }
                            // },
                          ),
                          BookContainer(
                            image:
                                'assets/images/pro_${isAyurvedic ? 'ayurveda' : 'homeo'}_appoint_card_img.png',
                            title: 'Book Your\nAppointment',
                            subtitle1: 'More Than',
                            subtitle2: '2500+\nDoctors',
                            width: maxWidth * .46,
                            color: isAyurvedic
                                ? const Color(0xffF7B47F)
                                : const Color(0xff76994D),
                            gradient: [
                              isAyurvedic
                                  ? const Color(0xffF5C49D)
                                  : const Color(0xff76994D),
                              clrFFFFFF,
                            ],
                            isOnline: true,
                            isFitImage: true,
                            ayurOrHomeoList: ayurOrHomeoList,

                            // onTap: () {
                            //   if (ayurOrHomeoList != null && ayurOrHomeoList.isNotEmpty) {
                            //     List<SpecialityList>? lst = ayurOrHomeoList.map((e) => SpecialityList(id: e.id, title: e.title, subtitle: e.subtitle, image: e.image)).toList();
                            //     getIt<CategoryMgr>().setViewAllScreenitems(lst);
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (_) => ViewAllScreen(
                            //                   title: ayurvedicOrHomeoSpecialities!.title ?? "",
                            //                 )));
                            //   } else {
                            //     showTopSnackBar(
                            //         Overlay.of(context),
                            //         const ErrorToast(
                            //           message: "No data found",
                            //         ));
                            //   }
                            // },
                          ),
                        ],
                      ),
                    ),
                    SpecialityListImages(
                      specialityList: ayurOrHomeoList ?? [],
                      w1p: w1p,
                    ),
                    if (topDoctors != null && topDoctors.isNotEmpty)
                      TopDoctorsSection(
                        doctors: topDoctors,
                        bgColor: isAyurvedic
                            ? const Color(0xff00C165).withOpacity(.1)
                            : const Color(0xffFCE8A0).withOpacity(.5),
                      ),
                    // ProBystanderBanner(maxWidth: maxWidth, h10p: h10p),
                    verticalSpace(h1p * 4),
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
