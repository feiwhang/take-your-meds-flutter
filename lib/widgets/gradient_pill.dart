import 'package:flutter/material.dart';

class GradientPill extends StatelessWidget {
  const GradientPill(
      {Key? key,
      required this.lightGradient,
      required this.darkGradient,
      required this.pillChild})
      : super(key: key);

  final Color lightGradient;
  final Color darkGradient;
  final Widget pillChild;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(colors: [lightGradient, darkGradient]),
      ),
      child: pillChild,
    );
  }
}
