import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Hero(
          tag: 'hero-1',
          child: AspectRatio(
            aspectRatio:
                1.0 / 0.8, // Adjusted ratio because height is now shorter
            child: ClipRect(
              // Prevents the top from showing
              child: Align(
                alignment: Alignment.bottomCenter, 
                child: Lottie.asset(
                  'assets/animations/Cooking.json',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
