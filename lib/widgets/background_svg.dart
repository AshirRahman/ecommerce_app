import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackgroundSVG extends StatelessWidget {
  final double opacity;

  const BackgroundSVG({super.key, this.opacity = 0.08});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SvgPicture.asset(
        'assets/images/background.svg',
        fit: BoxFit.cover,
      ),
    );
  }
}
