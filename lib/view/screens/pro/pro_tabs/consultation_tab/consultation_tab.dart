import 'package:dqapp/view/screens/pro/pro_home_vm.dart';
import 'package:dqapp/view/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../pro_widgets/speciality_list_images.dart';
import '../../pro_widgets/small_widgets.dart';
import 'widgets/symptom_list_images.dart';
import '../../pro_widgets/top_doctors_section.dart';

class ProConsultationTab extends StatelessWidget {
  const ProConsultationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w1p = maxWidth * 0.01;
        double w10p = maxWidth * 0.1;

        return Consumer<ProHomeVm>(
          builder: (context, vm, _) {
            return RefreshIndicator(
              onRefresh: () => vm.getConsultationFns(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TabConsultBanner(
                      bgImage: 'assets/images/tab_consult_banner_img.png',
                      title: 'Instant Consultation,\nAnytime You Need!',
                      titleColor: clr2E3192,
                      subtitle:
                          'Get expert advice in minutes —\nNo queues. No delays. Just solutions.',
                      subtitleColor: clr202020,
                      h1p: h1p,
                      w1p: w1p,
                      maxWidth: maxWidth,
                    ),
                    verticalSpace(h1p * 2),
                    SymptomListImages(
                      vm: vm,
                      maxWidth: maxWidth,
                      w10p: w10p,
                      w1p: w1p,
                      h1p: h1p,
                    ),
                    // const ConsultationCards(),
                    // verticalSpace(h1p * 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BookContainer(
                            image:
                                'assets/images/pro_consult_instant_card_img.png',
                            title: 'Instant\nConsultation',
                            subtitle1: 'Connect\nwithin',
                            subtitle2: '30 Sec',
                            width: maxWidth * .46,
                            color: const Color(0xff65BAFF),
                            gradient: [const Color(0xff65BAFF), clrFFFFFF],
                            isOnline: false,
                            isFitImage: false,
                          ),
                          BookContainer(
                            image:
                                'assets/images/pro_consult_appoint_card_img.png',
                            title: 'Book Your\nAppointment',
                            subtitle1: 'More Than',
                            subtitle2: '2500+\nDoctors',
                            width: maxWidth * .46,
                            color: const Color(0xff8DDCD9),
                            gradient: [const Color(0xff8DDCD9), clrFFFFFF],
                            isOnline: true,
                            isFitImage: true,
                          ),
                        ],
                      ),
                    ),
                    SpecialityListImages(
                      specialityList: vm.specialities?.specialityList ?? [],
                      w1p: w1p,
                    ),
                    if (vm
                            .topDoctorsResponseModel
                            ?.allopathyDoctors
                            ?.isNotEmpty ??
                        false)
                      TopDoctorsSection(
                        doctors: vm.topDoctorsResponseModel?.allopathyDoctors,
                        bgColor: const Color(0xff7C91FF).withOpacity(.1),
                      ),
                    ProBystanderBanner(maxWidth: maxWidth, h10p: h10p),
                    verticalSpace(h1p * .3),
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
