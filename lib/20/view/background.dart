import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      height: size.height,
      width: size.width,
      child: Stack(
        children: [
          Positioned(
            top: -10,
            left: -10,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'images/app_logo.png',
                scale: 0.8,
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: -20,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'images/app_logo.png',
                scale: 0.8,
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: 60,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'images/app_logo.png',
                scale: 0.8,
              ),
            ),
          )
        ],
      ),
    );
  }
}
