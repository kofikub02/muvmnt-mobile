import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProfileCard extends StatelessWidget {
  const ShimmerProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDarkMode ? const Color(0xFF303030) : const Color(0xFFE0E0E0);
    final highlightColor =
        isDarkMode ? const Color(0xFF404040) : const Color(0xFFF5F5F5);
    final shimmerColor = isDarkMode ? Colors.blue : Colors.white;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left section: Name and rating
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name placeholder
              Container(
                height: 20,
                width: 120,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // Rating badge placeholder
              Container(
                height: 24,
                width: 50,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          // Right section: Circular avatar
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: shimmerColor,
            ),
          ),
        ],
      ),
    );
  }
}
