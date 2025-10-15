import 'dart:math';

import 'package:dqapp/model/core/available_doctors_response_model.dart';
import 'package:dqapp/view/screens/home_screen_widgets.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';

import '../../../theme/constants.dart';
import '../../booking_screens/doctor_profile_screen.dart';

class DocSpecialityListDisplay extends StatelessWidget {
  final List<Speciality> specialites;
  final int docId;
  final Color cardColor;
  const DocSpecialityListDisplay({
    super.key,
    required this.specialites,
    required this.docId,
    required this.cardColor,
  });

  void onItemTap(BuildContext context, Speciality item) {
    Navigator.pop(context); // Close modal
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorProfileScreen(
          // specialityId: widget.specialityId,
          onlineFee: item.specialityOnlineFees?.toStringAsFixed(0),
          offlineFee: item.specialityOfflineFees?.toStringAsFixed(0),
          specialityId: item.specialityId,
          docId: docId,
        ),
      ),
    );
    // You can navigate or handle further logic here
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: specialites.length <= 1
          ? 0.40
          : min(0.31 * specialites.length, 1),
      initialChildSize: specialites.length <= 1
          ? 0.40
          : min(0.31 * specialites.length, 1),
      minChildSize: specialites.length <= 1
          ? 0.40
          : min(0.31 * specialites.length, 1),
      builder: (_, controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Choose Speciality',
                  style: t700_16.copyWith(color: clr2D2D2D),
                ),
              ),
              verticalSpace(4),
              divider(),
              verticalSpace(12),
              Expanded(
                child: ListView.separated(
                  controller: controller,
                  itemCount: specialites.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final speciality = specialites[index];
                    return InkWell(
                      onTap: () => onItemTap(context, speciality),
                      child: Card(
                        elevation: 3,
                        // color: cardColor,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: HomeWidgets().cachedImg(
                                    speciality.specialityImage ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      speciality.specialityTitle ?? '',
                                      style: t700_16.copyWith(color: clr2D2D2D),
                                    ),
                                    const SizedBox(height: 4),
                                    if (speciality.specialityOnlineFees != null)
                                      Text(
                                        'Online: ₹${speciality.specialityOnlineFees?.toStringAsFixed(0)}',
                                        style: t500_13.copyWith(
                                          color: clr2D2D2D,
                                        ),
                                      ),
                                    if (speciality.specialityOfflineFees !=
                                        null)
                                      Text(
                                        'Offline: ₹${speciality.specialityOfflineFees?.toStringAsFixed(0)}',
                                        style: t500_13.copyWith(
                                          color: clr2D2D2D,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: clr2D2D2D,
                                  size: 20,
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
          ),
        );
      },
    );
  }
}
