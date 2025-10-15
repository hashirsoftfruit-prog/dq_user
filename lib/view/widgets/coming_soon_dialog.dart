import 'package:flutter/material.dart';

import '../theme/text_styles.dart';

void showComingSoonDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lottie animation (requires lottie package)
            // Lottie.asset(
            //   'assets/images/under_construction.json',
            //   width: 150,
            //   height: 150,
            //   repeat: true,
            // ),
            // const SizedBox(height: 16),
            Text(
              'Coming Soon!',
              style: t700_24.copyWith(
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [Colors.blueAccent, Colors.purpleAccent],
                  ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
              ),
              // style: TextStyle(
              //   fontSize: 24,
              //   fontWeight: FontWeight.bold,
              //   foreground: Paint()
              //     ..shader = const LinearGradient(
              //       colors: [Colors.blueAccent, Colors.purpleAccent],
              //     ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
              // ),
            ),
            const SizedBox(height: 10),
            Text(
              'We’re working hard to bring this feature to you. Stay tuned!',
              textAlign: TextAlign.center,
              style: t400_16.copyWith(color: Colors.grey),
              // style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Okay',
                style: t500_16,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
