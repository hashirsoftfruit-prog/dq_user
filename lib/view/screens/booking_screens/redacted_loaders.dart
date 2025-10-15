import 'package:dqapp/view/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({super.key, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
    ).redact(context);
  }
}

class SkeletonBox extends StatelessWidget {
  final double height;
  final double width;
  const SkeletonBox({super.key, this.height = 16, this.width = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
    ).redact(context);
  }
}

class FindDoctorRedactedLoader extends StatelessWidget {
  const FindDoctorRedactedLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: 3, // Number of cards to show
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemBuilder: (context, index) => _buildDoctorCard(),
        ),
      ),
    );
  }

  Widget _buildDoctorCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              SkeletonCircle(size: 60),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 140, height: 16),
                    SizedBox(height: 8),
                    SkeletonBox(width: 170, height: 12),
                    SizedBox(height: 4),
                    SkeletonBox(width: 80, height: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SkeletonBox(width: double.infinity, height: 40),
          const SizedBox(height: 12),
          _buildConsultationTimes(),
          const SizedBox(height: 12),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildConsultationTimes() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBox(width: 120, height: 16),
        SizedBox(height: 8),
        Row(
          children: [
            SkeletonBox(width: 120, height: 20),
            SizedBox(width: 12),
            SkeletonBox(width: 120, height: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        const Expanded(child: SkeletonBox(width: double.infinity, height: 40)),
        const SizedBox(width: 12),
        const Expanded(child: SkeletonBox(width: double.infinity, height: 40)),
        horizontalSpace(6),
        const SkeletonCircle(size: 40),
      ],
    );
  }
}

class SlotSelectionSkeleton extends StatelessWidget {
  const SlotSelectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dateSkeleton(),
          verticalSpace(16),
          _datePickerSkeleton(context),
          verticalSpace(24),
          const SkeletonBox(width: 150),
          verticalSpace(8),
          const SkeletonBox(width: 100),
          verticalSpace(16),
          _sectionSkeleton('Morning', context),
          verticalSpace(16),
          _sectionSkeleton('Afternoon', context),
          verticalSpace(16),
          _sectionSkeleton('Evening', context),
        ],
      ),
    ).redacted(context: context, redact: true);
  }

  Widget dateSkeleton() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [SkeletonBox(width: 100), SkeletonBox(width: 100)],
    );
  }

  Widget _datePickerSkeleton(context) {
    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, __) => const SkeletonBox(
          width: 60,
          height: 60,
        ).redacted(context: context, redact: true),
      ),
    );
  }

  Widget _sectionSkeleton(String label, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SkeletonBox(width: 120, height: 16), // Section label placeholder
        const SizedBox(height: 12),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.15,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 3,
              crossAxisSpacing: 6,
              childAspectRatio: 2 / 1,
            ),
            itemBuilder: (_, __) => const SkeletonBox(
              width: 80,
              height: 40,
            ).redacted(context: context, redact: true),
            itemCount: 6,
          ),
        ),
      ],
    );
  }
}

class VideosListLoader extends StatelessWidget {
  const VideosListLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 301,
      child: ListView.builder(
        itemCount: 4,
        // padding: EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(6),
          width: MediaQuery.of(context).size.width,
          height: 110,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SkeletonBox(width: 130, height: 110),
              horizontalSpace(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonBox(width: 160),
                  verticalSpace(8),
                  const SkeletonBox(width: 120),
                  const Spacer(),
                  const SkeletonBox(width: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AudiosListLoader extends StatelessWidget {
  const AudiosListLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 301,
      child: ListView.builder(
        itemCount: 4,
        // padding: EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(6),
          width: MediaQuery.of(context).size.width,
          height: 82,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const SkeletonBox(width: 76, height: 82),
              horizontalSpace(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SkeletonBox(width: 160),
                  verticalSpace(8),
                  const SkeletonBox(width: 120),
                  // const Spacer(),
                  // const SkeletonBox(width: 40),
                ],
              ),
              const Spacer(),
              const SkeletonCircle(size: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class TherapySelectionSkeleton extends StatelessWidget {
  const TherapySelectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            // mainAxisExtent: maxWidth * 0.4,
            // mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: 10, // Number of therapy cards
          itemBuilder: (context, index) {
            return const Stack(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: double.infinity, height: 130),
                // RedactSkeletonItem(
                //   child: Container(
                //     height: 100,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       color: Colors.grey.shade400,
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //   ),
                // ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SkeletonBox(width: 100),
                ),

                // RedactSkeletonItem(
                //   child: Container(
                //     height: 12,
                //     width: 100,
                //     decoration: BoxDecoration(
                //       color: Colors.grey.shade400,
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}
