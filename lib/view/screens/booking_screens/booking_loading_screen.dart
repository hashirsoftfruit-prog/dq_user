import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

import '../../../controller/managers/booking_manager.dart';
import '../../../l10n/app_localizations.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../theme/text_styles.dart';

class CheckIfDoctorAvailableScreen extends StatefulWidget {
  final int specialityId;
  final int? symptomId;
  final int? categoryId;
  final String specialityTitle;
  final int? typeOfPsychology;
  final int? subspecialityId;
  const CheckIfDoctorAvailableScreen({
    super.key,
    required this.specialityId,
    this.categoryId,
    this.typeOfPsychology,
    required this.specialityTitle,
    this.subspecialityId,
    this.symptomId,
  });

  @override
  State<CheckIfDoctorAvailableScreen> createState() =>
      CheckIfDoctorAvailableScreenState();
}

class CheckIfDoctorAvailableScreenState
    extends State<CheckIfDoctorAvailableScreen> {
  @override
  void initState() {
    super.initState();
    // print('psy type : ${widget.typeOfPsychology}');
    // print('subspecialityId : ${widget.subspecialityId}');
    // fn(specialityId: widget.specialityId,specialityTitle: widget.specialityTitle,categoryId: widget.categoryId);

    getIt<BookingManager>().onlineBookingRedirectionFn(
      subspecialityId: widget.subspecialityId,
      symptomId: widget.symptomId,
      typeOfPsychology: widget.typeOfPsychology,
      specialityId: widget.specialityId,
      categoryId: widget.categoryId,
      specialityTitle: widget.specialityTitle,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        List<Color> colors = widget.typeOfPsychology != null
            ? [clrF98E95, clrBD6273]
            : [clr8467A6, clr5D5AAB];
        var locale = AppLocalizations.of(context);

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: DoctorConsultationSkeleton(
            colors: colors,
            h1p: h1p,
            w1p: w1p,
            specialityTitle: widget.specialityTitle,
            locale: locale,
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     SizedBox(height: h10p * 2, width: maxWidth, child: Lottie.asset('assets/images/doc-search.json')),
          //     // myLoader(visibility: true),
          //   ],
          // )
        );
      },
    );
  }
}

class DoctorConsultationSkeleton extends StatelessWidget {
  final List<Color> colors;
  final double h1p;
  final double w1p;
  final String specialityTitle;
  final AppLocalizations? locale;
  const DoctorConsultationSkeleton({
    super.key,
    required this.colors,
    required this.h1p,
    required this.w1p,
    required this.locale,
    required this.specialityTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          expandedHeight: 100,
          collapsedHeight: 90,
          pinned: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w1p * 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.popUntil(context, ModalRoute.withName(RouteNames.home));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 20,
                            child: Image.asset(
                              "assets/images/back-cupertino.png",
                              color: Colors.white,
                              // colorFilter: ColorFilter.mode(
                              //     clrFFFFFF, BlendMode.srcIn),
                            ),
                          ),
                          horizontalSpace(12),
                          Text("Instant Consultations", style: t500_20),
                          // Text(
                          //       "Consultations",
                          //       style: t500_20,
                          //     ),
                        ],
                      ),
                    ),
                  ),
                  // const Spacer(),
                  verticalSpace(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(specialityTitle, style: t400_18)],
                  ),
                  verticalSpace(16),
                ],
              ),
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildListDelegate([
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLanguageSelector(context),
                  const SizedBox(height: 16),
                  _buildGenderSelector(context),
                  const SizedBox(height: 16),
                  _buildFeeRangeSelector(context),
                  const SizedBox(height: 16),
                  _buildBestDoctorsSection(context),
                  const SizedBox(height: 16),
                  _buildDoctorCards(context),
                  const SizedBox(height: 16),
                  _buildAppointmentSection(context),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _buildAppBar(context, specialityTitle) {
    return Container(
      height: h1p * 14,
      width: w1p * 100,
      decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w1p * 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                // Navigator.popUntil(context, ModalRoute.withName(RouteNames.home));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    SizedBox(
                      height: 20,
                      child: Image.asset(
                        "assets/images/back-cupertino.png",
                        color: Colors.white,
                      ),
                    ),
                    horizontalSpace(12),
                    Text("Instant Consultations", style: t500_20),
                    // Text(
                    //       "Consultations",
                    //       style: t500_20,
                    //     ),
                  ],
                ),
              ),
            ),
            // const Spacer(),
            verticalSpace(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(specialityTitle, style: t400_18)],
            ),
            verticalSpace(16),
            //     child: SizedBox(
            //         height: 20,
            //         child: SvgPicture.asset(
            //           "assets/images/back-arrow.svg",
            //           colorFilter: ColorFilter.mode(clrFFFFFF, BlendMode.srcIn),
            //         )),
            //   ),
            // ),
            // const Spacer(),
            // Text(
            //   "Live Video",
            //   style: t400_18,
            // ),
            // Text(
            //   "Consultations",
            //   style: t500_20,
            // ),
            // verticalSpace(16)
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // verticalSpace(16),
        Text(
          locale?.preferredLanguage ?? 'Preferred Language',
          style: t500_14.copyWith(color: clr2D2D2D),
        ),
        verticalSpace(h1p),
        Row(
          children: [
            _skeletonBox(context, width: 100, height: 30),
            const SizedBox(width: 8),
            _skeletonBox(context, width: 80, height: 30),
            const SizedBox(width: 8),
            _skeletonBox(context, width: 80, height: 30),
          ],
        ).redacted(context: context, redact: true),
      ],
    );
  }

  Widget _buildGenderSelector(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale?.preferredDoc ?? 'Doctor Preference',
          style: t500_14.copyWith(color: clr2D2D2D),
        ),
        verticalSpace(h1p),
        Row(
          children: [
            _skeletonCircle(context, size: 24),
            const SizedBox(width: 8),
            _skeletonBox(context, width: 70, height: 16),
            const SizedBox(width: 16),
            _skeletonCircle(context, size: 24),
            const SizedBox(width: 8),
            _skeletonBox(context, width: 50, height: 16),
            const SizedBox(width: 16),
            _skeletonCircle(context, size: 24),
            const SizedBox(width: 8),
            _skeletonBox(context, width: 50, height: 16),
          ],
        ).redacted(context: context, redact: true),
      ],
    );
  }

  Widget _buildFeeRangeSelector(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale?.feeRange ?? 'Fee Range',
          style: t500_14.copyWith(color: clr2D2D2D),
        ),
        verticalSpace(h1p),
        Wrap(
          spacing: 8,
          children: List.generate(
            3,
            (_) => _skeletonBox(context, width: 100, height: 30),
          ),
        ),
      ],
    );
  }

  Widget _buildBestDoctorsSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale?.weWillAssignYou ?? "We will assign you",
          style: t400_18.copyWith(color: clr2D2D2D),
        ),
        Text(
          locale?.theBestDoctor ?? "the best doctor",
          style: t700_20.copyWith(color: const Color(0xff625CAB)),
        ),
        verticalSpace(h1p),
      ],
    );
  }

  Widget _buildDoctorCards(context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => _skeletonDoctorCard(context),
      ),
    ).redacted(context: context, redact: true);
  }

  Widget _skeletonDoctorCard(context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _skeletonCircle(context, size: 60),
          const SizedBox(height: 8),
          _skeletonBox(context, width: 100, height: 16),
          const SizedBox(height: 6),
          _skeletonBox(context, width: 120, height: 12),
          // const SizedBox(height: 4),
          // _skeletonBox(context, width: 60, height: 12),
          const Spacer(),
          _skeletonBox(context, width: 140, height: 16),
        ],
      ),
    );
  }

  Widget _buildAppointmentSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale?.consultingFor ?? "Consulting For",
          style: t500_16.copyWith(color: clr444444),
        ).unredacted,
        // locale.selectPatientFillDetails.isNotEmpty?Text(locale.selectPatientFillDetails,style: TextStyles.textStyle38,):SizedBox(),
        verticalSpace(h1p),
        // _skeletonBox(context, width: 150, height: 16),
        // const SizedBox(height: 8),
        Row(
          children: [
            _skeletonCircle(context, size: 24),
            const SizedBox(width: 8),
            _skeletonBox(context, width: 80, height: 16),
            const Spacer(),
            _skeletonBox(context, width: 100, height: 24),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _skeletonBox(context, width: w1p * 40, height: 50),
              horizontalSpace(8),
              _skeletonBox(context, width: w1p * 40, height: 50),
              horizontalSpace(8),
              _skeletonBox(context, width: w1p * 40, height: 50),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    ).redacted(context: context, redact: true);
  }

  Widget _skeletonBox(context, {double width = 100, double height = 16}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // color: Colors.grey.shade300,
      ),
    ).redacted(context: context, redact: true);
  }

  Widget _skeletonCircle(context, {double size = 40}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    ).redacted(context: context, redact: true);
  }
}
