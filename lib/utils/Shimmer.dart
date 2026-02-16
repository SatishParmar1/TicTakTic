import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  // Standard Colors
  static const Color _baseColor = Color(0xFFE0E0E0);
  static const Color _highlightColor = Color(0xFFF5F5F5);

  // 1. Rectangular with Default Radius of 16
   AppShimmer.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
    // CHANGED: Default is now 16 instead of 0
    double borderRadius = 16,
  }) : shapeBorder =  RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(0)),
  ).copyWith(borderRadius: BorderRadius.circular(borderRadius));

  // 2. Circular
   AppShimmer.circular({
    super.key,
    required this.width,
    required this.height,
  }) : shapeBorder = const CircleBorder();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey,
          shape: shapeBorder,
        ),
      ),
    );
  }
}