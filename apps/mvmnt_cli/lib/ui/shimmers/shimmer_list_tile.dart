import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListTile extends StatelessWidget {
  final double height;

  const ShimmerListTile({super.key, this.height = 72.0});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDarkMode ? const Color(0xFF303030) : const Color(0xFFE0E0E0);
    final highlightColor =
        isDarkMode ? const Color(0xFF404040) : const Color(0xFFF5F5F5);
    final shimmerColor = isDarkMode ? Colors.blue : Colors.white;

    // Important: Add a SizedBox with specific height to ensure the shimmer is visible
    return SizedBox(
      height: height,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        // Important: Wrap in Container with color to enable shimmer effect
        child: Container(
          color: Colors.transparent, // This helps activate the shimmer
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: constraints.maxWidth * 0.7,
                    height: 16,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: constraints.maxWidth * 0.9,
                    height: 12,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
