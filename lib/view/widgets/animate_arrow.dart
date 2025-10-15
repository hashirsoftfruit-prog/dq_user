import 'package:flutter/material.dart';

class AnimatedArrow extends StatefulWidget {
  const AnimatedArrow({Key? key}) : super(key: key);

  @override
  State<AnimatedArrow> createState() => _AnimatedArrowState();
}

class _AnimatedArrowState extends State<AnimatedArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true); // Repeats back and forth

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.1, 0.0), // Slide slightly to the right
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SlideTransition(
        position: _slideAnimation,
        child: Card(
          color: Colors.blue[200],
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 4.0, bottom: 4, right: 4),
            child: Icon(
              Icons.keyboard_double_arrow_right_rounded,
              size: 40,
              color: Colors.blue[800],
            ),
          ),
        ),
      ),
    );
  }
}
