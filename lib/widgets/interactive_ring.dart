import 'package:flutter/material.dart';
import 'dart:math';

class InteractiveRing extends StatefulWidget {
  const InteractiveRing({super.key});

  @override
  State<InteractiveRing> createState() => _InteractiveRingState();
}

class _InteractiveRingState extends State<InteractiveRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
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
    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Ring
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade800, width: 6),
            ),
          ),

          // Inner Animated Ring
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.red.withOpacity(0.7),
                        Colors.transparent,
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          // Center Dot
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),

          // ==== COMMENTED LABELS (Future use) ====
          // const Positioned(top: 8, child: Text("Mid -3", style: TextStyle(color: Colors.red))),
          // const Positioned(left: 8, top: 100, child: RotatedBox(quarterTurns: -1, child: Text("Bass +6", style: TextStyle(color: Colors.white70)))),
          // const Positioned(right: 8, top: 100, child: RotatedBox(quarterTurns: 1, child: Text("Treble +6", style: TextStyle(color: Colors.white70)))),
          // const Positioned(bottom: 10, child: Text("-3", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}