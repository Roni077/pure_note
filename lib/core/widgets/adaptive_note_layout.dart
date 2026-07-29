import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AdaptiveNoteLayout extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final bool isGridView;

  const AdaptiveNoteLayout({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.isGridView = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Enforce grid for tablet/desktop
        bool useGrid = isGridView;
        int crossAxisCount = 2;

        if (constraints.maxWidth > 900) {
          useGrid = true;
          crossAxisCount = 4; // Desktop
        } else if (constraints.maxWidth > 600) {
          useGrid = true;
          crossAxisCount = 3; // Tablet
        } else if (constraints.maxWidth < 400 && isGridView) {
          crossAxisCount = 2; // Small phone
        }

        if (useGrid) {
          return AnimationLimiter(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.85,
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: crossAxisCount,
                  duration: const Duration(milliseconds: 375),
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: itemBuilder(context, index),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return AnimationLimiter(
            child: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: itemCount,
              separatorBuilder: (context, index) => const SizedBox(height: 8.0),
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: itemBuilder(context, index),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
