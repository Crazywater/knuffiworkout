import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A splash screen with an animation that is rendered while Firebase
/// initializes.
class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final image = DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/weight.png'),
        ),
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.all(64.0),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (a, b) => Transform(
            transform: Matrix4.translationValues(
                0.0, -100.0 * math.sin(math.pi * _animation.value), 0.0),
            alignment: Alignment.center,
            child: image,
          ),
        ),
      ),
    );
  }
}
