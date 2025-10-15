import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';

class ProDQFutureTab extends StatelessWidget {
  const ProDQFutureTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        FeatureCard(
          title: "Touch the Future of Healthcare!",
          description:
              "Experience lightning-fast drone delivery for your health needs.",
          imagePath: "assets/images/pro_future_drone.png",
        ),
        SizedBox(height: 16),
        FeatureCard(
          title: "DQ Laboratories",
          description:
              "We partner with top labs to offer easy online test scheduling and direct result access.",
          imagePath: "assets/images/pro_future_lab.png",
        ),
        SizedBox(height: 16),
        FeatureCard(
          title: "DQ Pharmacy",
          description:
              "We’re onboarding pharmacies for online ordering and delivery of medicines.",
          imagePath: "assets/images/pro_future_pharmacy.png",
        ),
        SizedBox(height: 16),
        FeatureCard(
          title: "DQ E Clinic",
          description: "",
          imagePath: "assets/images/pro_future_e_clinic.png",
          textColor: [Color(0xFFBE232C), Color(0xFF302D79)],
        ),
      ],
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final List<Color>? textColor;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      padding: const EdgeInsets.all(16),
      child: textColor == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    title,
                    style: t700_16.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    description,
                    style: t400_12.copyWith(color: Colors.white),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: t700_16.copyWith(
                    // color: textColor![0],
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: textColor!,
                        end: Alignment.centerRight,
                        begin: Alignment.centerLeft,
                      ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                ),
              ],
            ),
    );
  }
}
