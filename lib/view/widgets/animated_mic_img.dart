import 'package:flutter/material.dart';
import '../theme/constants.dart';

class AnimatedMic extends StatefulWidget {
  const AnimatedMic({super.key});

  @override
  State<AnimatedMic> createState() => _AnimatedMicState();
}

class _AnimatedMicState extends State<AnimatedMic>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow
            Container(
              width: 115,
              height: 115,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: clr6C6EB8.withOpacity(.4),
                    // color: Colors.purple.withOpacity(0.5),
                    blurRadius: _animation.value + 10,
                    spreadRadius: _animation.value + 5,
                  ),
                ],
              ),
              child: Image.asset('assets/images/img-mic-circle-2.png'),
            ),
            // Middle glow
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: clr6C6EB8.withOpacity(.2),
                    blurRadius: _animation.value + 5,
                    spreadRadius: _animation.value / 2,
                  ),
                ],
              ),
              child: Image.asset('assets/images/img-mic-circle-1.png'),
            ),
            // Mic icon with glow
            SizedBox(
              width: 41,
              height: 41,
              child: Image.asset('assets/images/img-mic.png'),
            ),
          ],
        );
      },
    );
  }
}
