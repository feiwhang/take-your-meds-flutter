import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  const BaseCard({Key? key, required this.cardChild, this.bgColor})
      : super(key: key);

  final Widget cardChild;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 36,
            spreadRadius: 4,
            offset: const Offset(0, 8),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: cardChild,
    );
  }
}
